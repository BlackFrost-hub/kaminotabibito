# Warcraft 3 随机数规则

## 默认结论

- 新代码使用 `jass.GetRandomInt`、`jass.GetRandomReal` 或项目现有随机封装。
- 不调用 `math.randomseed()`，也不在业务模块自行维护 Lua 随机种子。
- 随机结果会影响单位、物品、伤害、奖励或其他同步状态时，所有客户端必须在相同顺序、相同次数下消费随机数。

## 推荐写法

先绑定局部别名，再调用 JASS 随机原生：

```ts
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const index = GetRandomInt(0, candidates.length - 1);
```

数组下标必须与调用区间配套：

- `GetRandomInt(0, length - 1)`：直接作为 TS 数组下标。
- `GetRandomInt(1, length)`：使用前减 `1`。
- 空数组先早退，不能调用反向区间。

## 禁止

- 用时间、本地文件、缓存、对象地址、`tostring({})` 或客户端状态作为随机种子。
- 每次抽取前重新调用 `math.randomseed()`。
- 在 `GetLocalPlayer()`、`sync=false` 或其他本机异步路径里产生会影响同步玩法的随机结果。
- 同一随机结果在不同客户端走不同数量的后续随机调用。

## 历史代码

若旧模块仍使用 Lua `math.random` / `math.randomseed`，不要把它当新代码模板。先确认是否能迁移到 JASS 随机原生；无法迁移时，必须证明初始化只执行一次、种子固定且所有客户端调用顺序一致，并记录保留原因。

当前装备掉落与装备提取代码均已使用 `GetRandomInt` / `GetRandomReal`，不再需要单独设置 Lua 随机种子。
