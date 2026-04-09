
### list

#### list initialization

```c
static inline void INIT_LIST_HEAD(struct list_head *list)
{
	WRITE_ONCE(list->next, list);
	list->prev = list;
}
```

为什么两个赋值不一样：

在链表操作中，通常：

- next 指针：是遍历链表的入口点，可能被并发访问
- prev 指针：通常只在持有锁的情况下访问，并发风险较低

#### list delete node

`list_del` 删除节点后使指针指向毒化地址（节点不可用，适合即将释放的场景）。

`list_del_init` 删除节点后将指针指向自身（节点置为空链表状态，适合后续可能复用的场景）。

### 内核编译时的module

在内核编译时的 `module_init` 和动态模块时的不是同一个实现，通过宏 `MODULE` (注意区分 `CONFIG_MODULES` )，本质上内核编译时的就是将相关函数定义到指定段，按顺序初始化。

### idr(radix tree/xarray)

旧 radix tree 原理 : https://zhuanlan.zhihu.com/p/533338300

在新内核中 radix 已经是 xarray的一层封装了。

### lock

https://zhuanlan.zhihu.com/p/8068425906

#### spinlock

阅读源码时发现 `spin_lock_irqsave` 是宏展开，`spin_unlock_irqrestore` 却是静态内联函数，我认为：

- `spin_lock_irqsave` 函数参数中的`flag`是获取。若是函数，在完全按语义下则需要多一次栈空间，传入指针；而宏展开则可以直接赋值flag到当前变量。
- `spin_unlock_irqrestore` 函数参数中的`flag`是单纯传入数据。这时没上面问题，用静态内联函数让编译器去动态判断，动态平衡性能与空间。

### workqueue

在使用旧接口:
```c
#define create_workqueue(name)						\
	alloc_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, 1, (name))
```

- `__WQ_LEGACY` 的意思是：
  旧接口的“兼容语义”标记，搜索代码来看在 workqueue 上只是标记，没有特殊处理流程
- `WQ_MEM_RECLAIM` 的意思是：
  这个 workqueue 上排队的 work，在系统内存紧张、直接回收、回写、OOM 边缘等情况下，仍然必须有能力被执行，不然可能形成循环
  等待，内核为此准备 rescuer 机制，避免因为 worker 线程无法创建/调度而卡死。

  也就是如果某条“释放内存 / 推进回收 / 完成资源回收”的路径依赖这个 work 执行，就要加 `WQ_MEM_RECLAIM`。
  典型必须加的场景：

  - work 里会释放关键资源，释放后系统才能继续分配内存
  - work 参与页回收、回写、bio/块层清理、inode/dentry 回收、文件系统回收链
  - work 是某个 teardown/cleanup 的必要步骤，而这个 cleanup 会在 reclaim 压力下被等待
  - 某个代码路径在内存分配失败或低内存情况下，仍然要依赖该 work 完成才能继续

### wait queue

https://zhuanlan.zhihu.com/p/474516220

#### wait_event

`WQ_FLAG_EXCLUSIVE` 标志表示独占等待者，即当该等待者在唤醒流程中，被唤醒并成功执行后就停止继续唤醒流程，可以良好防止“惊群”。
对于这种排他性的等待者需要插入队列尾部，防止非独占的永远无法唤醒，保证公平性。

#### wake_up

`wake_up_locked` 和 `wake_up`：`wake_up` 在调用时自行上锁， `wake_up_locked` 在调用时已经上锁。

在 `wake_up` 里的 `__wake_up_common_lock` 中有看到参数 `wake_flags`，在这里是 0 表示普通唤醒。

`__wake_up_common_lock` 的核心是 `__wake_up_common`，发现传入参数有个 `bookmark` 书签节点，在外部看不出来能干什么，进入函数 `__wake_up_common` 内外结合发现：

- 原来函数内不是直接遍历唤醒完所有 n 个节点，而是单次最多唤醒 `WAITQUEUE_WALK_BREAK_CNT` 个节点(n > WAITQUEUE_WALK_BREAK_CNT)。
- 若唤醒完 `WAITQUEUE_WALK_BREAK_CNT` 个节点后，就会插入书签节点并标记它，之后退出函数 `__wake_up_common`，返回到 `__wake_up_common_lock`。
  而在 `__wake_up_common_lock` 中会进行一次放锁。
- 之后判断是否标记书签节点，以此判断是否再次进入 `__wake_up_common`。
- 这样每次拿锁唤醒一些再放锁，循环往复。**既保证临界区，又保证了不会出现唤醒个数太多而导致锁时间太长**。

那为什么要书签节点，而不是直接通过指针标记节点呢：使用书签入队，书签节点再当前环境栈空间上，可以保证在当前唤醒结束前，对应内存空间不会释放，即使在唤醒过程中放锁，其他环境抢占并也进行了队列操作，但书签已经入队，不会出现野指针。

#### 思考

从大体功能上来看，在某些场景中wait 和 semaphore 非常相似，那两者区别在哪？

- semaphore 通过 `down` 减计数器并挂起，`up` 加计数器并只唤醒一个等待者。
- wait 对比 semaphore 可以做更多的判断更加灵活，同时也能支持唤醒多个。

所以一般来说计数资源用 semaphore，等待事件用 wait。

### completion

粗略的来看，completion 实际上是 wait 的一层特殊封装：等待条件固定为判断一个 flag —— 是否完成。

### notifier

通知链和一般的 IPC 不太一样，类似订阅和发布，做到了良好的解耦：

- 订阅者：对某一事件感兴趣的一方。定义了当事件发生时，相应的回调函数，并将其注册到通知链中（即在通知链的队列中插入一项）。
- 发布者：事件发生的发布者。当检测到某事件或者本身产生事件时，通知所有对该事件感兴趣的一方事件发生。发布者通知动作这个过程实际上就是根据通知链（保存了每一个订阅者对事件的回调函数），遍历通知链中的每一项，然后调用相应的回调函数。

在阅读代码中发现更多是使用读写锁/读写信号量，因此通知链的发布者可以读并发，同时回调不是执行一次发布者就删掉回调，删掉回调需要订阅者进行（取消订阅），也就是说发布者只管事件发生时调用回调，而订阅完全有订阅者掌控，完美的解耦。

### timer

https://blog.csdn.net/wangquan1992/article/details/122968025

每个CPU都含有一到两个 `struct timer_base` 结构体，当使用 `CONFIG_NO_HZ_COMMON` 时（类tickless模式）就需要2个：
- `BASE_STD`（Standard）：插入的 timer 是时间敏感的，因此系统定时器根据这些 timer 来设置下一次的到期时间。因此也需要比较精准的系统硬件定时器。
- `BASE_DEF`（Deferrable）：插入的 timer 是可以延期的，系统不会根据这些 timer 来设置到期时间，仅有 `BASE_STD` 的定时器到期时顺便一起做检查。

#### 桶

linux timer 使用了时间轮，相关结构体是 `struct timer_base`。
看 `struct timer_base` 里定时器的 list 用了桶结构，分为 0\~7/8级，共8/9级，每级有64个元素，因此最多有578个桶。
每级都有一个粒度（Granularity），表示系统至少要过多少个Tick才会检查某一个桶里面的所有定时器；粒度具体每级的值可以看 timer.c 中的 `LVL_CLK_SHIFT`。

> 一般来说，假设 HZ 为 1000，每级有 `LVL_SIZE` 64 个桶，每级颗粒度为 `LVL_GRAN(n)`（0层为1，1层为8，2层为64）。

在老版本的 timer 中桶存在降级机制，因此 timer 整体为一个大的时间轮，即保证了插入/删除的速度，又不存在精准度缺失；但相应的：如果存在的定时器过多，那降级可能会发生较大的抖动（迁移后可能会发生重新计算），同时对底层桶压力较大，容易坍缩为单链表。

而在新版本中 timer 桶不再降级，插入到什么地方就是什么地方，其中包含了一个绝妙的策略：短周期定时器往往需要高精准度，长周期定时器往往可以存在偏移，而每级里的桶之间差值即为对应等级的偏移。

从源码来看，timer 时间轮的层级划分是通过当前时间和预期的差值来划分，符合上面的策略。
但具体到层级中的每个桶，则是直接通过预期时间划分，因为在上面策略中，不再降级，所以每一级都是一个独立的时间轮，只是精度不同。

在插入和检查时都会计算在哪个桶，因此不会存在访问桶出错的情况。

`mod_timer(&timer, jiffies + X);` 在例子中，如果X刚好是一个巨大且不合理的（比如X刚好是 jiffies 的整个周期），内核默认相信程序员，因此内核是不做额外错误处理的，不建议用内核的 timer / jiffies 来定时/比较如此长的时间，建议一般X最大在周期的一半。

#### 迁移

在 `__mod_timer` 中有函数 `get_target_base` 获取 `struct timer_base`，其在 SMP 和 NO_HZ 情况下，如果 timer 没绑定 CPU 就会用到 `get_nohz_timer_target`：该函数会判断当前 CPU 是否空闲，如果不是空闲状态，那还是返回当前的CPU编号，如果是空闲，会找到最近的一个忙的处理器。为什么是忙的处理器有些奇怪？

由于 linux 针对的 CPU 可能会有较高的功耗和多级的缓存，当 CPU 进入空闲时，一般都会进入睡眠，这时去唤醒的整体开销巨大，不如让正在忙的 CPU 接手。
那么新问题来了忙的一直忙？实际上 timer 是：遵循绑核，本核优先，忙核其次。

所以，一共要迁移定时器的情况是：
- 跨 CPU 操作 timer
- CPU 进入 idle 尝试主动迁移
- `CONFIG_NO_HZ_FULL` 下隔离核主动迁移

#### tick 模式

在 timer 学习过程中发现，tick的模式有多种，其中`CONFIG_NO_HZ_COMMON` （类tickless模式）实际有两种模式：
- `CONFIG_NO_HZ_IDLE` CPU 空闲时 tickless
- `CONFIG_NO_HZ_FULL` CPU 空闲或只有一个任务时 tickless

为什么没有完全的 tickless？
1. 完全 tickless 会导致调度公平性完全失效。
2. 任务若出现死循环，因为在一段时间内无法被打断，无效空转。
3. 任务负载均衡，统计决策能力下降。
