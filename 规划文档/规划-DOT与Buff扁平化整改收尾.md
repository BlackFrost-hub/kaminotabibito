# DOT 与 Buff 扁平化整改收尾计划

## 1. 文档用途
本文档是针对 `DOT` 与 `Buff` 扁平化改造后的**收尾执行文档**。

适用对象：
- 负责本轮补丁收尾的开发者
- 负责按规范落地的 AI 执行者
- 最后做代码审查与验收的人

本文档**不是新一轮重构计划**，而是对现有扁平化结果做最小闭环修正。

---

## 2. 当前状态结论
当前源码已经完成了主要目标：

- `DOT` 主状态已改为单层扁平结构  
  `dotStateFlat["typeId|hid"]`
- `DOT` 忽略目标表已改为单层扁平结构  
  `ignoredTargetFlat["typeId|hid"]`
- `Buff` 主状态已改为单层扁平结构  
  `buffByUnitAndId["hid|buffId"]`
- 核心 tick / 同步推进路径已改为  
  “扫描 flat 表 -> 排序数组 -> for 循环”

因此，本轮不再讨论“是否要扁平化”，而是只处理尚未完全收口的 3 个问题。

---

## 3. 本轮必须收尾的 3 个问题

### 3.1 DOT flat key 解析不够严格
文件：
- `TS/系统/04．伤害系统/01．DOT定义/04．DOT工具.ts`

当前问题：
- `parseDotFlatKey()` 使用 `parseInt`
- 会错误接受类似 `antiHeal|123abc`

这与“严格 key 校验”的验收说法不一致。

### 3.2 Buff flat key 解析不够严格
文件：
- `TS/系统/05．Buff系统/00．Buff系统.ts`

当前问题：
- `parseBuffKey()` 使用 `parseInt`
- 会错误接受类似 `123abc|D001`

这同样不符合“严格 key 校验”。

### 3.3 `getBuffIdsOnUnit()` 仍暴露对象枚举顺序
文件：
- `TS/系统/05．Buff系统/00．Buff系统.ts`

当前问题：
- `getBuffIdsOnUnit()` 直接 `for...in buffByUnitAndId`
- 返回值没有稳定排序
- 虽然当前 `BuffUIViewModel` 后续又做了排序，但这个 API 自身仍泄露不稳定顺序

---

## 4. 本轮目标

### 4.1 代码目标
- `parseDotFlatKey()` 改为严格纯数字校验
- `parseBuffKey()` 改为严格纯数字校验
- `getBuffIdsOnUnit()` 返回稳定排序结果

### 4.2 范围目标
本轮只允许修改：
- `TS/系统/04．伤害系统/01．DOT定义/04．DOT工具.ts`
- `TS/系统/05．Buff系统/00．Buff系统.ts`
- `规划文档/DOT与Buff扁平化改造执行报告.md`

### 4.3 非目标
本轮不做：
- 不新增新容器
- 不引入 `activeKeys`
- 不继续改 `BuffUI`
- 不扩展到其它系统
- 不做性能优化

---

## 5. 明确禁止事项
以下内容本轮一律禁止：

1. 禁止顺手重写 `DOT` 系统
2. 禁止顺手重写 `Buff` 系统
3. 禁止新增任何新的二级状态容器
4. 禁止把这轮修复扩展成“性能优化轮”
5. 禁止混入 unrelated 格式化、命名清洗、注释大改

---

## 6. 推荐实施方案

### 6.1 在两个文件内各自新增局部 helper
推荐形态：

```ts
function parseStrictPositiveInt(s: string): number | null {
  if (s === "") return null;
  for (let i = 0; i < s.length; i++) {
    const ch = s.substring(i, i + 1);
    if (ch < "0" || ch > "9") return null;
  }
  const n = parseInt(s, 10);
  if (isNaN(n) || n <= 0) return null;
  return n;
}
```

要求：
- 不使用正则
- 不使用宽松 `parseInt` 直接判定
- 必须保证整串都是十进制数字

### 6.2 修改 `parseDotFlatKey()`
文件：
- `TS/系统/04．伤害系统/01．DOT定义/04．DOT工具.ts`

要求：
- 继续使用 `indexOf("|")`
- `typeId` 仍然允许非空字符串
- `hid` 必须通过 `parseStrictPositiveInt()` 解析
- 遇到 `antiHeal|123abc` 必须返回 `null`

### 6.3 修改 `parseBuffKey()`
文件：
- `TS/系统/05．Buff系统/00．Buff系统.ts`

要求：
- 继续使用 `indexOf("|")`
- `buffID` 仍然要求非空
- `hid` 必须通过 `parseStrictPositiveInt()` 解析
- 遇到 `123abc|D001` 必须返回 `null`

### 6.4 修改 `getBuffIdsOnUnit()`
文件：
- `TS/系统/05．Buff系统/00．Buff系统.ts`

要求：
- 保留现有扫描逻辑
- 收集完成后必须稳定排序

推荐排序：

```ts
out.sort((a, b) => {
  if (a < b) return -1;
  if (a > b) return 1;
  return 0;
});
```

本轮不要求进一步改成新容器，只要求把 API 输出稳定化。

---

## 7. 修改文件清单

| 文件 | 必改内容 |
|------|---------|
| `TS/系统/04．伤害系统/01．DOT定义/04．DOT工具.ts` | 新增严格纯数字解析 helper；修 `parseDotFlatKey()` |
| `TS/系统/05．Buff系统/00．Buff系统.ts` | 新增严格纯数字解析 helper；修 `parseBuffKey()`；给 `getBuffIdsOnUnit()` 加排序 |
| `规划文档/DOT与Buff扁平化改造执行报告.md` | 把“严格 key 校验”表述改成与源码一致；补充 `getBuffIdsOnUnit()` 已稳定排序 |

---

## 8. 验收标准

### 8.1 代码层验收
必须满足：

1. `parseDotFlatKey()` 不再接受 `antiHeal|123abc`
2. `parseBuffKey()` 不再接受 `123abc|D001`
3. `getBuffIdsOnUnit()` 返回值稳定排序
4. 不新增任何新的 `state[x][y]` 风格结构

### 8.2 构建验收
必须执行：

1. `npm run build`

要求：
- 构建通过
- 如果有已有 warning，可记录，但不能引入新的报错

### 8.3 功能回归
至少确认：

1. DOT 正常叠加、刷新、到期清理
2. Buff 正常增加、覆盖、移除
3. BuffUI 仍正常显示 Buff 图标与 tooltip

---

## 9. 实施顺序

按下面顺序执行，不要跳：

1. 改 `04．DOT工具.ts`
2. 改 `00．Buff系统.ts`
3. 跑 `npm run build`
4. 改 `DOT与Buff扁平化改造执行报告.md`

原因：
- 先把代码修正完
- 确认 build 过了
- 最后再更新执行报告，避免文档先行

---

## 10. 执行者回填区

### 已完成项
- [x] `04．DOT工具.ts` — 新增 `parseStrictPositiveInt`；`parseDotFlatKey` 改用严格解析
- [x] `00．Buff系统.ts` — 新增 `parseStrictPositiveInt`；`parseBuffKey` 改用严格解析；`getBuffIdsOnUnit` 加稳定排序
- [x] 额外修复：`pcall(nil, func)` 死代码 → 具名函数体模式
- [x] 额外修复：`self`/`nil` 参数对齐（`00．Buff系统.ts`、`08．DOT基础工具.ts`）
- [x] 额外修复：deps 冒号调用 → 提取局部变量（5 个文件）

### 未完成项
- [ ] 实机联机验证（DOT 叠加/刷新/到期、Buff 增加/覆盖/移除、BuffUI、desync）

### 构建结果
- [x] TSTL 编译通过（仅有预先存在的 warning）
- [x] 备注：`07．装备提取.ts` TS2304 为预先存在错误，非本轮引入

### 回归结果
- [ ] DOT 回归正常（待实机验证）
- [ ] Buff 回归正常（待实机验证）
- [ ] BuffUI 回归正常（待实机验证）

### 风险说明
- 严格 key 解析可能导致之前被 parseInt 容错的脏数据被跳过（预期行为）
- self/nil 对齐修复修正了之前的 bug，需实机确认
- pcall 具名函数体修复使之前被静默吞掉的逻辑现在能执行，可能暴露隐藏问题
