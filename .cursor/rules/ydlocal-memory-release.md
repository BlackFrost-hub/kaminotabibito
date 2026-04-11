# YDWE 逆天局部变量系统 - 内存释放规则

## 核心原则：使用逆天局部变量必须 YDLocal1Release

`YDLocal1Release()` 是 YDWE 逆天局部变量系统的**内存释放函数**。每次使用 `YDLocalInitialize()` 初始化局部变量上下文后，**必须**在逻辑结束时调用 `YDLocal1Release()` 释放，否则会造成哈希表内存泄漏。

## 调用配对规则

```
YDLocalInitialize()  ← 必须调用
  ... 业务逻辑（YDLocal1Set/Get, YDLocal5Set/Get, YDLocal7Set/Get 等）...
YDLocal1Release()    ← 必须调用，与 Initialize 配对
```

## YDLocal 函数分类

| 函数 | 用途 | 使用场景 |
|------|------|---------|
| `YDLocalInitialize()` | 初始化局部变量上下文，递增 step，保存 G_SIndex 到栈 | 进入触发器动作时调用 |
| `YDLocal1Release()` | **释放局部变量表**，FlushChildHashtable 清理，恢复 G_SIndex/G_LIndex | 退出触发器动作时调用 |
| `YDLocal1Set/Get` | 当前触发器的局部变量读写 | 触发器内部局部变量 |
| `YDLocal5Set/Get` | **传参**：调用方向被调用方传参数 | 调用方在执行子触发器前设置 |
| `YDLocal7Set/Get` | **返回值**：被调用方向调用方返回数据 | 被调用方写入返回值到父级局部变量表 |
| `clearStar_PIndex()` | 清除当前触发器上的父索引 | 被调用方在返回值设置完后清理 |

## 完整调用流程示例

### 调用方（触发自定义事件）
```typescript
YDLocalInitialize();                    // 1. 初始化
YDLocal1Set("string", "loc_str", "444"); // 2. 设置自己的局部变量
// 遍历子触发器:
YDLocalExecuteTrigger(trg);             // 3. 计算子触发器的 ydl_triggerstep
saveParentIndex(trg);                   // 4. 保存父索引（用于返回值）
YDLocal5Set("string", "loc_str", "444");// 5. 传参给子触发器
YDTriggerExecuteTrigger(trg, false);    // 6. 执行子触发器
const ret = YDLocal1Get("string", "loc_c"); // 7. 读取返回值
YDLocal1Release();                      // 8. 释放！
```

### 被调用方（JASS 触发器动作）
```jass
YDLocalInitialize()
set Star_PIndex = LoadInteger(YDHT, GetHandleId(GetTriggeringTrigger()), SKey_PIndex)
set loc_str = YDLocal5Get(string, "loc_str")   // 读参数
set loc_c = loc_str + "123"
call YDLocal7Set(string, "loc_c", loc_c)       // 写返回值
call RemoveSavedInteger(YDHT, GetHandleId(GetTriggeringTrigger()), SKey_PIndex)
call YDLocal1Release()                          // 释放！
```

### STES_Fire 自动处理
`STES_Fire(name)` 内部已自动处理 `YDLocalExecuteTrigger` + `saveParentIndex` + `YDTriggerExecuteTrigger` + 索引恢复，调用方无需手动管理。

## 注意事项

1. **YDLocal1Release 会 FlushChildHashtable**，调用后该触发器当前 step 的所有局部变量都会被清除
2. **G_SIndex/G_LIndex 通过栈恢复**，支持嵌套调用（A调B调C），每层 Release 恢复上一层
3. **YDLocal5 传参必须在 YDLocalExecuteTrigger 之后**，因为 ydl_triggerstep 由它设置
4. **YDLocal7 返回值写入的是父级局部变量表**，调用方用 YDLocal1Get 读取
5. **忘记 YDLocal1Release = 内存泄漏**，与魔兽的 RemoveLocation/DestroyGroup 同等重要
