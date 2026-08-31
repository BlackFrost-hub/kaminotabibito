/** @noSelfInFile */
/**
 * 芙莉莲动作表现（A8）
 *
 * 最终人物模型 051_Frieren 的限时动画与循环动作守护统一封装。
 * Q/W/E/R/D 文件不得散落 SetUnitAnimation/SetUnitAnimationByIndex/SetUnitTimeScale，
 * 一律通过本模块接口播放；恢复动画速度 1.0，向 02 技能清理器提供句柄。
 * 技能动作索引 0 表示"未确认槽"跳过；待机恢复使用模型配置的真实 Stand 索引。
 */

import { 芙莉莲模型动作配置, 芙莉莲技能动作槽 } from "./00．配置";

const jass = require("jass.common") as any;
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
};
const { 登记芙莉莲清理 } = require("./02．被动效果") as {
  登记芙莉莲清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
};

const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;

export interface 动作槽 {
  /** 模型序列显示索引（0 = 未确认槽，跳过） */
  索引: number;
  名称: string;
  原始时长秒: number;
  播放速度: number;
  持续秒: number;
  循环: boolean;
}

function 取序列定义(this: void, 索引: number): { 原始时长秒: number; 循环: boolean } | null {
  for (let i = 0; i < 芙莉莲模型动作配置.序列.length; i++) {
    const s = 芙莉莲模型动作配置.序列[i];
    if (s.索引 === 索引) return { 原始时长秒: s.原始时长秒, 循环: s.循环 };
  }
  return null;
}

/**
 * 播放限时动作：按索引播放指定时长，结束后恢复模型配置的待机序列与动画速度 1.0。
 * 登记 02 技能清理器（技能结束/死亡统一移除恢复回调）。
 */
export function 播放限时动作(this: void, 英雄: any, 槽: 动作槽, 登记名: string): void {
  if (英雄 == null || 英雄 === 0 || 槽.索引 <= 0) return;
  SetUnitAnimationByIndex(英雄, 槽.索引);
  if (槽.播放速度 > 0 && 槽.播放速度 !== 1) SetUnitTimeScale(英雄, 槽.播放速度);
  if (槽.持续秒 > 0) {
    const 持续毫秒 = 槽.持续秒 * 1000;
    const 恢复ID = addDelayedCallback(持续毫秒, function 恢复站立(this: void): void {
      if (单位存活(英雄)) {
        SetUnitTimeScale(英雄, 1);
        SetUnitAnimationByIndex(英雄, 芙莉莲模型动作配置.待机索引);
      }
    });
    登记芙莉莲清理(英雄, 登记名, function 动作恢复清理(this: void): void {
      removeDelayedCallback(恢复ID);
      if (单位存活(英雄)) {
        SetUnitTimeScale(英雄, 1);
        SetUnitAnimationByIndex(英雄, 芙莉莲模型动作配置.待机索引);
      }
    });
  }
}

/**
 * 开始循环动作守护（保持段，如 W 防御保持 / R 蓄力保持）。
 * 返回句柄；调用 停止循环守护 恢复模型配置的待机序列与速度 1.0。
 */
export interface 循环守护句柄 {
  英雄: any;
  登记名: string;
  恢复ID: number;
}

export function 开始循环守护(this: void, 英雄: any, 槽: 动作槽, 登记名: string): 循环守护句柄 | null {
  if (英雄 == null || 英雄 === 0 || 槽.索引 <= 0) return null;
  SetUnitAnimationByIndex(英雄, 槽.索引);
  if (槽.播放速度 > 0 && 槽.播放速度 !== 1) SetUnitTimeScale(英雄, 槽.播放速度);
  // 循环模型自身会循环；守护在 持续秒 到期后恢复（窗口长度），提前停止则由 停止循环守护 处理
  let 恢复ID = 0;
  if (槽.持续秒 > 0) {
    恢复ID = addDelayedCallback(槽.持续秒 * 1000, function 守护到期(this: void): void {
      if (单位存活(英雄)) {
        SetUnitTimeScale(英雄, 1);
        SetUnitAnimationByIndex(英雄, 芙莉莲模型动作配置.待机索引);
      }
    });
  }
  const 句柄: 循环守护句柄 = { 英雄, 登记名, 恢复ID };
  登记芙莉莲清理(英雄, 登记名, function 守护清理(this: void): void {
    停止循环守护(句柄);
  });
  return 句柄;
}

export function 停止循环守护(this: void, 句柄: 循环守护句柄 | null): void {
  if (句柄 == null) return;
  if (句柄.恢复ID !== 0) removeDelayedCallback(句柄.恢复ID);
  句柄.恢复ID = 0;
  if (句柄.英雄 != null && 句柄.英雄 !== 0 && 单位存活(句柄.英雄)) {
    SetUnitTimeScale(句柄.英雄, 1);
    SetUnitAnimationByIndex(句柄.英雄, 芙莉莲模型动作配置.待机索引);
  }
}

// 技能动作槽便捷构造（按 00．配置 芙莉莲技能动作槽 索引取定义）
function 构造槽(this: void, 槽配置: { 索引: number; 播放速度: number; 持续秒: number }): 动作槽 {
  // 名称/原始时长/循环 从 芙莉莲模型动作配置 权威带出（00 技能动作槽只登记索引/播放速度/持续秒）
  const def = 取序列定义(槽配置.索引);
  return {
    索引: 槽配置.索引,
    名称: def != null ? 取序列名称(槽配置.索引) : "",
    原始时长秒: def != null ? def.原始时长秒 : 0,
    播放速度: 槽配置.播放速度,
    持续秒: 槽配置.持续秒,
    循环: def != null ? def.循环 : false,
  };
}

function 取序列名称(this: void, 索引: number): string {
  for (let i = 0; i < 芙莉莲模型动作配置.序列.length; i++) {
    if (芙莉莲模型动作配置.序列[i].索引 === 索引) return 芙莉莲模型动作配置.序列[i].名称;
  }
  return "";
}

export const 芙莉莲动作槽 = {
  Q发射: 构造槽(芙莉莲技能动作槽.Q发射),
  W保持防御: 构造槽(芙莉莲技能动作槽.W保持防御),
  E起飞: 构造槽(芙莉莲技能动作槽.E起飞),
  E观察保持: 构造槽(芙莉莲技能动作槽.E观察保持),
  R蓄力保持: 构造槽(芙莉莲技能动作槽.R蓄力保持),
  R发射: 构造槽(芙莉莲技能动作槽.R发射),
  D花田: 构造槽(芙莉莲技能动作槽.D花田),
} as const;
