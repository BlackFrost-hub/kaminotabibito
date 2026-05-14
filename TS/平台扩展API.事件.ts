/** @noSelfInFile */

/**
 * 平台扩展 API 中文包装 - 事件。
 */

type 玩家句柄 = any;
type 单位句柄 = any;
type 物品句柄 = any;
type 控件句柄 = any;
type 特效句柄 = any;
type 触发器句柄 = any;
type 点句柄 = any;
type 单位组句柄 = any;
type 技能句柄 = any;
type 代理句柄 = any;
type 漂浮字句柄 = any;
type 玩家组句柄 = any;
type 布尔表达式句柄 = any;
type 按钮句柄 = any;
type 对话框句柄 = any;
type 计时器对话框句柄 = any;
type 追踪物句柄 = any;
type 排行榜句柄 = any;
type 多面板句柄 = any;
type 多面板项句柄 = any;
type 区域句柄 = any;
type 矩形句柄 = any;
type 闪电句柄 = any;
type 音效句柄 = any;
type 可破坏物句柄 = any;

type 原生表 = Record<string, any>;
const 平台原生表 = require("jass.japi") as 原生表;
const 原生函数表 = 平台原生表 as Record<string, (...参数: any[]) => any>;

export function 平台扩展_注册_随机存档删除事件(this: void, 触发器: 触发器句柄): void {
  return (原生函数表["KKApiTriggerRegisterBackendLogicDelete"] as (触发器: 触发器句柄) => void)(触发器);
}

export function 平台扩展_注册_随机存档更新事件(this: void, 触发器: 触发器句柄): void {
  return (原生函数表["KKApiTriggerRegisterBackendLogicUpdata"] as (触发器: 触发器句柄) => void)(触发器);
}

export function 平台扩展_注册_天梯投降事件(this: void, 触发器: 触发器句柄): void {
  return (原生函数表["KKApiTriggerRegisterLadderSurrender"] as (触发器: 触发器句柄) => void)(触发器);
}
