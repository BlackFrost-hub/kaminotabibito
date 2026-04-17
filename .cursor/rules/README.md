# Cursor 工程规则（索引）

规则按**主题**拆到子目录，便于维护；**全部放在子目录下**（避免部分 Cursor 版本在「根目录 `.mdc` + 子目录混放」时不加载子目录规则）。

| 目录 | 内容 |
|------|------|
| [`war3-tstl/`](war3-tstl/) | TSTL → Lua、JASS 调用与回调坑、随机数、全局数组、`udg_TempUnit`、`UnitDamageTarget` |
| [`dzapi/`](dzapi/) | DzAPI UI 帧类型、LoadToc、FDF 崩溃；键盘/sync 以 `ui-frame-types.mdc` §键盘与 `TS/lib/扩展函数/封装函数/04．硬件输入/04．键盘函数.ts` 为准 |
| [`equipment/`](equipment/) | 装备回复 `hot` 字段、`USE_ITEM` 双触发防重 |
| [`stes-ydlocal/`](stes-ydlocal/) | STES 事件、YDLocal 传参/返回值、`YDLocal1Release` |
| [`tooling/`](tooling/) | 调试输出、`print`、音效/漂浮字路径约定 |
| [`agent-shared/`](agent-shared/) | 跨代理入口：约定先看本索引；Codex 等非 Cursor 代理同时参考根目录 `AGENTS.md` |

带 YAML frontmatter 的 `.mdc` 仍可使用 `description`、`globs`、`alwaysApply` 控制是否自动注入上下文。

2026年4月17日20:10:49更新
1.先看jass表和japi表，它们在项目根目录里，不要把BJ函数当jass或者japi函数使用！也不要互相间混淆！
2.用绝对路径如 require("lib.扩展函数.YDWE函数.04．YDWE_trigger") 或 require("系统.05．Buff系统.00．Buff系统") ，而不是相对路径 ./ 。如相对路径 ./06．X库函数 。这在 Lua 运行时无法解析
3.TS\lib\扩展函数  这里是函数封装库，你可以看看有没有你可以利用的，当我要你从源文件封装时，优化源文件代码，你还需要检查里面用到的函数，项目的封装函数库里是否齐全，不齐全就报告给我。
4.对于jass的全局变量，不能用globalThis，这是ts/lua端的全局，而不是jass的
5.TS\lib\扩展函数\自定义扩展函数   认为可以日后通用的函数可以放在这里，或者新建一个文件放在这里
6.若新建一个文件夹，如果有通用函数，你要么并入合适的文件，要么新建一个文件 ，新建文件夹时，需要有index文件统一入口和导出，并且在父级文件夹的index文件添加。单文件不可以超过400行，最好不超过500行，超过了就拆分多文件。
7.新建全新系统时，需要你添加md文件给后续ai接手
8.TS\系统\02．物品系统\07．装备提取.ts和TS\系统\12．测试系统\STES事件测试.ts    →这里是STES事件的相关演示                                           TS\系统\12．测试系统\YDLocal返回值测试.ts   →这里YD函数的相关演示
9..cursor 这里是一些坑和经验
1.一个方法使用不通就学会变通！

另外，如果你不懂STES怎么用，我需要说明：jass端不可以调用lua端的函数，但是通过STES事件可以变相做到→TS\系统\02．物品系统\07．装备提取.ts 这个系统就可以lua端和jass端互相调用，如果我说明了要求需要被jass端调用，可以被jass端触发，而且可以传参，那么你就需要支持。