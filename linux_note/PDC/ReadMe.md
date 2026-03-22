
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
