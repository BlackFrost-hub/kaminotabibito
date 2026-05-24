# 项目通用函数与 API 经验

这份文档给后续 AI 快速定位项目里的通用能力用。先找封装，再写业务；不要凭记忆直接写 JASS/JAPI 调用。

## 先查哪里

- 项目规则入口：`.cursor/rules/README.md`、`.cursor/rules/GLOBAL_AGENT_PROMPT.mdc`
- TSTL 硬规则：`.cursor/rules/agent-shared/tstl-hard-rules.mdc`
- 编码与补丁安全：`.cursor/rules/tooling/encoding-and-patch-safety.mdc`
- 运行时 API 真源：`jass表.txt`、`japi表.txt`、`TS/平台扩展API取值.ts`
- 生成产物：`src/**/*.lua` 只在需要检查 self/nil 参数错位时看；`src/**/*.js` 不是运行目标，已忽略

## 常用目录

- 通用 lib：`TS/lib/扩展函数`
- Star 扩展：`TS/lib/扩展函数/Star扩展函数`
- 自定义扩展：`TS/lib/扩展函数/自定义扩展函数`
- YDWE 兼容：`TS/lib/扩展函数/YDWE函数`
- BJ 包装：`TS/lib/扩展函数/BJ函数`
- 技能函数：`TS/系统/03．技能系统/00．技能模板+函数/01．技能函数`
- 通用技能函数：`TS/系统/03．技能系统/00．技能模板+函数/02．通用函数`
- 事件中心：`TS/系统/00．核心系统/01．事件中心`

## 统一入口优先级

- 玩家英雄判断优先用 `getRegisteredPlayerHero(GetOwningPlayer(unit)) === unit`
- 物品使用优先走 `04．物品事件中心.ts` / `13．物品技能事件中心.ts`
- 技能释放优先走 `08．技能事件中心.ts`
- 单位死亡优先走 `07．单位死亡事件中心.ts`
- 英雄升级优先走 `06．英雄升级事件中心.ts`
- 聊天测试优先走 `12．聊天命令事件中心.ts`
- 定时逻辑优先走 `TS/系统/00．核心系统/05．中心计时器.ts`

## 伤害、治疗、资源

- 伤害数值修改只放伤害修正器，优先找 `TS/系统/04．伤害系统/01．伤害事件.ts`
- 命中后业务效果挂 `registerAppliedFinalDamageListener`
- 只有伤害系统自身的修正逻辑继续挂 `registerDamageCallback` / damage modifier
- 治疗走 `TS/系统/04．伤害系统/02．治疗系统`，优先用 `doHeal`
- 魔法恢复/减少看 `06．魔法恢复.ts`、`07．减少生命值.ts`
- 最终治疗回调优先用 `registerAppliedFinalHealListener`
- 命中、闪避、暴击系统在 `04．命中系统`、`05．闪避系统`、`06．暴击系统`

## 装备、物品、单位、技能数据

- 装备数据：`TS/系统/02．物品系统/01．装备数据.ts`
- 装备名反查：`TS/系统/02．物品系统/13．物品名反查.ts`
- 装备查询封装：`TS/lib/扩展函数/物品相关函数/装备数据查询.ts`
- 装备次数叠加配置：`TS/系统/02．物品系统/16．装备次数叠加配置.ts`
- 创建物品优先用 `TS/lib/扩展函数/物品相关函数/创建物品函数.ts`
- 单位配置表：`TS/系统/01．单位系统/08．单位配置表`
- 玩家英雄配置：`TS/系统/01．单位系统/00．单位初始化创建/01．玩家英雄/00．玩家英雄配置.ts`
- 技能数据表：`TS/系统/03．技能系统/08．技能数据表/00．技能数据表.ts`
- Buff 数据表：`TS/系统/05．Buff系统/02．Buff数据表/00．Buff数据表.ts`

## JASS / JAPI 调用规则

- 不要直接写 `jass.Xxx(...)` 或 `japi.Xxx(...)`
- 先绑定局部别名，再调用，例如 `const GetUnitX = jass.GetUnitX as ...`
- 不用 Lua/TS `Math.*` 写运行时逻辑，优先用项目数学封装或 JASS/BJ 包装
- 回调传给 JASS/DzAPI 时用模块级命名函数，不用匿名闭包
- `fix-lua-for-pack.js` 不要为 TSTL 问题随便改，先从 TS 源头规避

## YDUserData 与全局变量

- YDUserData 安全版路径是 `lib.扩展函数.YDWE函数.09．YDUserData安全版`，注意是中文圆点 `．`
- 如果安全版所在文件有 `@noSelfInFile`，引用侧要特别检查生成 Lua 是否参数错位
- 和 JASS 全局变量交互时，音效等 `gg_snd_*` 句柄优先用 `require("jass.globals").gg_snd_xxx`
- `declare const gg_snd_xxx` 只解决 TS 编译，不保证 Lua 运行时能拿到 JASS 全局

## 音效与表现

- 英雄语音目录：`TS/系统/09．表现系统/10．英雄语音`
- 普通本地播放只放最终表现层，逻辑判断必须同步完成
- 3D 音效优先用 BJ 音效封装，例如 `PlaySoundOnUnitBJ(sound, 100, unit)`
- 广播提示看 `TS/系统/09．表现系统/06．广播提示消息`

## 自检口径

- 改 TS 后先 `npm run build`
- 涉及导入函数、事件中心、timer、JASS/JAPI、YDUserData 时，检查生成 Lua 的 self/nil 参数
- 中文文件尽量用 `apply_patch` 小补丁，不要整文件重写
- 不要把无关格式化、重排、清理混进功能修复
## 调试输出

- 普通调试优先用 `print`，不要默认用 `DisplayTimedTextToPlayer`
- `print` 适合临时调试；`DisplayTimedTextToPlayer` 更容易刷屏
- 同一条调试日志在某些环境里出现两次，通常是正常现象，不要先假设逻辑执行了两遍

## JASS 全局与音效

- 读 `gg_snd_*` 之类的 JASS 全局，优先用 `require("jass.globals")`
- `declare const` 只解决 TS 编译认识变量，不解决运行时取值
- 需要确认运行时语义时，直接看项目里的 JASS 全局接入方式，不要只看类型声明
