# 装备回复 / USE_ITEM 执行两次

## 现象
监听 `EVENT_PLAYER_UNIT_USE_ITEM` 的触发器，在一次使用物品时回调会执行 **2 次**（同一 trigger、同一 handle）。

## 原因
**非 TS/Lua 重复注册**。只注册了一个触发器，但 **引擎/事件层对一次“使用物品”会派发两次 USE_ITEM 事件**，导致同一 trigger 的 action 被调用两次。

## 正确做法
- **防重必须用 `globalThis`** 存 key（如 `单位+物品类型id`）和“已执行”标记。用 `g`（jass.globals）会因两次回调可能处在不同 `g` 上下文而失效（第二次读到 nil，防重无效）。
- 同一次使用内：第一次进入时设 `globalThis.__EquipHealExecutedKey = key` 并执行 HealItemEffect；第二次进入时若 `__EquipHealExecutedKey === key` 直接 return。用 Timer 在 0.5s 后清空 key，以便下次使用。

## 不要
- 不要依赖“只注册一次”来避免两次执行（引擎会发两次事件）。
- 不要用 JASS 全局变量或地图侧改触发器来规避，应在 Lua 侧用 globalThis 防重即可。
