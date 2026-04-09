## MCU OTA (DM)

这个需要芯片支持AB分区的自映射（double map）。

### 标志

- `App Active Flag` ： 准备激活的app
- `Self Update A/B bit` ： A/B分区正在进行刷写
- `A/B Block State Flag bit` ： A/B分区状态
- `A&b sync flag`： 刷写完成时设置同步flag为0 / 建议使用APP自带比较标志
- `SU_counter`：启动次数
- `SYNC_counter`：同步次数

### 场景

#### 启动

```mermaid
flowchart LR
S1[根据 App Active Flag] -->|启动A/B| S2{检查Self Update A/B bit}
S2 -->|1| S3[进入 A/B APP，并通知转跳self boot，完成back up刷写]
S2 -->|0| S4{判断刷新状态 Block State Flag bit}
S4 -->|0x00| S5{校验APP及标定区域}
S5 -->|失败| S6[停留boot]
S5 -->|成功| S7[进入 A/B APP]
S4 -->|其他值| S6[停留boot]
```

#### APP内

```mermaid
flowchart LR
A1[OTA Master的更新请求] -->|OTA 更新包的验证通过| A2[设置自身Self Update bit 1]
A2 --> A3[转跳self boot,刷写back up]
```

#### 转跳self boot,刷写back up

```mermaid
flowchart LR
B1[self boot确认刷写请求] --> B2{校验检查Backup Flash Block状态}
B2 -->|异常| B3[终止更新流程，向 OTA Master 反馈升级失败，并reset]
B2 -->|正常| B4{判断Block State Flag}
B4 -->|0x00| B5[Block State Flag 置位为 0x01]
B4 -->|0x01| B6[擦除除了 Block State Flag 所Block State Flag 处 sector 之外的 Backup Flash Block 区域]
B4 -->|0x02| B5
B4 -->|Reserved| B5
B5 --> B6
B6 --> B7{更新APP和标定，并完成校验}
B7 -->|成功| B8[Block State Flag 置位为 0x00，Self Update bit 置为 0，App Active Flag 切换] --> reset
B7 -->|失败| B9[Block State Flag 置位为 0x02] --> B3
```

#### 同步

暂定由boot进行

```mermaid
flowchart LR
SYNC1[在跳入app前一刻] --> SYNC2{判断是否需要同步}
SYNC2 -->|1| SYNC4[已同步] --> SYNC5[进入APP]
SYNC2 -->|0| SYNC3{根据Synchronization failure limit 对比 SYNC_counter}
SYNC3 -->|同步次数满足| SYNC6[不同步] --> SYNC5
SYNC3 -->|同步次数未满足| SYNC7{根据Startup trigger operation 对比 SU_counter}
SYNC7 -->|未满足条件| SYNC11[SU_counter增加] --> SYNC5
SYNC7 -->|满足条件| SYNC8{尝试同步}
SYNC8 -->|同步成功，校验通过| SYNC9[记录结果] --> SYNC5
SYNC8 -->|同步失败，超时| SYNC10[SYNC_counter增加]
SYNC10 --> SYNC9[记录结果] --> SYNC5
```

- 若在等待同步或同步过程中，模块接收到新的升级请求，应将 FF01 的 Byte3 Bit0 置为 0，Byte4 置为 0xE0 ‘During synchronization’，直到同步完成。

- 在同步过程中，模块无需额外维持整车唤醒。
- 模块应将同步最终结果记录在本地 Log 中。

- 若同步失败，模块应记录 Programming Error Code: PEC 0x030B（Err_ synchronization）。(PEC DID, Programing Error Code dataIdentifier 可参考诊断规范 PA0A2K。)
