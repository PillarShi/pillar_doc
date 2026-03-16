### 内核编译时的module

在内核编译时的 `module_init` 和动态模块时的不是同一个实现，通过宏 `MODULE` (注意区分 `CONFIG_MODULES` )，本质上内核编译时的就是将相关函数定义到指定段，按顺序初始化。

### idr(radix tree/xarray)

旧 radix tree 原理 : https://zhuanlan.zhihu.com/p/533338300

在新内核中 radix 已经是 xarray的一层封装了。

### lock

https://zhuanlan.zhihu.com/p/8068425906

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
