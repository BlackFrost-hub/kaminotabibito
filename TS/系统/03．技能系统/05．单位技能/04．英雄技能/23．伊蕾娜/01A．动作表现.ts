/** @noSelfInFile */

const jass = require("jass.common") as any;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, speed: number) => void;

const { 播放限时单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  播放限时单位动画: (this: void, 参数: any) => any;
};
const { 创建单位动画守护, 停止单位动画守护 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.18．单位动画守护") as {
  创建单位动画守护: (this: void, 参数: any) => any;
  停止单位动画守护: (this: void, 句柄: any) => void;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

export interface 伊蕾娜动作参数 {
  readonly 索引: number;
  readonly 名称: string;
  readonly 原始时长秒: number;
  readonly 播放速度: number;
  readonly 持续秒: number;
}

/** 限时阶段动作：统一恢复 stand 与 1.0 动画速度，避免技能文件直接操作动画状态。 */
export function 播放伊蕾娜阶段动作(this: void, 单位: any, 动作: 伊蕾娜动作参数): any {
  if (单位 == null || 单位 === 0 || 动作 == null) return null;
  debugLogForce("伊蕾娜-动作表现", "动作", "阶段播放", "动作名", 动作.名称);
  return 播放限时单位动画({
    单位,
    动画编号: 动作.索引,
    动画速度: 动作.播放速度,
    持续秒: 动作.持续秒 > 0 ? 动作.持续秒 : 动作.原始时长秒,
    恢复动画名: "stand",
    恢复动画速度: 1,
  });
}

/** 循环阶段动作：用于扫帚飞行，调用方必须把返回句柄登记进技能实例清理篮子。 */
export function 开始伊蕾娜循环动作(this: void, 单位: any, 动作: 伊蕾娜动作参数): any {
  if (单位 == null || 单位 === 0 || 动作 == null) return null;
  debugLogForce("伊蕾娜-动作表现", "动作", "循环开始", "动作名", 动作.名称);
  SetUnitTimeScale(单位, 动作.播放速度);
  return 创建单位动画守护({
    单位,
    动画编号: 动作.索引,
    间隔秒: 动作.原始时长秒,
    立即播放: true,
    死亡时清理: true,
    调试名: "伊蕾娜-" + 动作.名称,
  });
}

export function 停止伊蕾娜循环动作(this: void, 句柄: any): void {
  debugLogForce("伊蕾娜-动作表现", "动作", "循环停止");
  if (句柄 != null && 句柄.单位 != null && 句柄.单位 !== 0) SetUnitTimeScale(句柄.单位, 1);
  停止单位动画守护(句柄);
}

export {};
