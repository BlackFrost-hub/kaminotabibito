/** @noSelfInFile */
/**
 * 塞莉亚·克莱尔 - 动作表现（01A，A8 硬门槛落地）
 *
 * - 技能文件一律通过本文件播放/停止动作；禁止散落调用
 *   SetUnitAnimation / SetUnitAnimationByIndex / SetUnitTimeScale。
 * - 限时段走 `02．通用函数/00．单位动画等待.ts` 的 播放限时单位动画；
 *   循环保持段走 `18．单位动画守护.ts` 的 创建/停止单位动画守护。
 * - 中断/死亡/场景清理路径由技能实例登记 清理塞莉亚循环动作：
 *   停止守护并恢复 1.0 动画速度，不残留循环或中途回站立。
 * - 当前仅 R 蓄力槽（Spell 1，祭出魔法书/公式展开）语义经截图确认已接入；
 *   Q/W/E/D 的分阶段槽与收势为已知缺口（见执行计划 A8），不得用 Stand 冒充。
 */

import { 塞莉亚克莱尔模型动作配置, 塞莉亚克莱尔动作槽配置 } from "./00．配置";

const jass = require("jass.common") as any;
/** 本封装内部恢复速度专用；对外仍只暴露具名接口。 */
const SetUnitTimeScale = jass.SetUnitTimeScale as ((u: any, scale: number) => void) | undefined;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as ((u: any, index: number) => void) | undefined;

const { 播放限时单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  播放限时单位动画: (this: void, 参数: any) => any;
};
const {
  创建单位动画守护,
  停止单位动画守护,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.18．单位动画守护") as {
  创建单位动画守护: (this: void, 参数: any) => any;
  停止单位动画守护: (this: void, 句柄: any) => void;
};

export interface 塞莉亚动作槽 {
  /** 模型序列的显示索引（0-based）；null = 待映射槽，业务不得播放 */
  索引: number | null;
  名称: string;
  原始时长秒: number;
  播放速度: number;
  /** -1 表示由技能实例通过循环守护管理生命周期 */
  持续秒: number;
}

function 取槽配置(this: void, 槽名: keyof typeof 塞莉亚克莱尔动作槽配置): 塞莉亚动作槽 {
  return 塞莉亚克莱尔动作槽配置[槽名] as unknown as 塞莉亚动作槽;
}

/** 播放一次限时动作段；持续秒 > 0 时到期自动按公共函数恢复待机与速度。返回句柄供篮子登记。 */
export function 播放塞莉亚限时动作(
  this: void,
  英雄: any,
  槽名: keyof typeof 塞莉亚克莱尔动作槽配置,
  持续秒?: number,
): any {
  if (英雄 == null || 英雄 === 0) return null;
  const 槽 = 取槽配置(槽名);
  if (槽.索引 == null) return null; // 待映射槽：不播放
  const 实际持续 = 持续秒 != null && 持续秒 > 0 ? 持续秒 : 槽.原始时长秒 / 槽.播放速度;
  return 播放限时单位动画({
    单位: 英雄,
    动画编号: 槽.索引,
    动画速度: 槽.播放速度,
    持续秒: 实际持续,
    恢复动画编号: 塞莉亚克莱尔模型动作配置.待机索引,
  });
}

/** 开始循环保持段（守护周期重放）；返回守护句柄，由技能实例负责 停止塞莉亚循环动作。 */
export function 开始塞莉亚循环动作(this: void, 英雄: any, 槽名: keyof typeof 塞莉亚克莱尔动作槽配置): any {
  if (英雄 == null || 英雄 === 0) return null;
  const 槽 = 取槽配置(槽名);
  if (槽.索引 == null) return null; // 待映射槽：不播放
  return 创建单位动画守护({
    单位: 英雄,
    动画编号: 槽.索引,
    间隔秒: 槽.原始时长秒 / 槽.播放速度,
    立即播放: true,
    死亡时清理: true,
    调试名: "塞莉亚-" + 槽名,
  });
}

/** 停止循环守护并恢复 1.0 动画速度（所有结束路径必须调用）。 */
export function 停止塞莉亚循环动作(this: void, 英雄: any, 守护句柄: any): void {
  if (守护句柄 != null) 停止单位动画守护(守护句柄);
  if (英雄 != null && 英雄 !== 0) {
    if (SetUnitTimeScale != null) SetUnitTimeScale(英雄, 1);
    if (SetUnitAnimationByIndex != null) SetUnitAnimationByIndex(英雄, 塞莉亚克莱尔模型动作配置.待机索引);
  }
}

/** 仅恢复动画速度（无守护句柄时的兜底恢复路径）。 */
export function 恢复塞莉亚动画速度(this: void, 英雄: any): void {
  if (英雄 != null && 英雄 !== 0 && SetUnitTimeScale != null) SetUnitTimeScale(英雄, 1);
}

export {};
