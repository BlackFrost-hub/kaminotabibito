/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, 施法单位: any, 技能ID: number) => void) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, 单位: any) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, 原始ID: string | undefined | null) => number;
};
const { 距离平方XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};

import type { 环境互动触发点 } from "./00．环境互动配置";
const { 环境互动技能ID, 环境互动默认触发范围 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置") as {
  环境互动技能ID: string;
  环境互动默认触发范围: number;
};

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, 单位: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, 玩家: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;

const 环境互动调查点列表: 环境互动触发点[] = [];
let 已初始化环境互动 = false;

function 移除调查点(this: void, 调查点ID: string): boolean {
  for (let i = 0; i < 环境互动调查点列表.length; i++) {
    if (环境互动调查点列表[i].ID !== 调查点ID) continue;
    环境互动调查点列表.splice(i, 1);
    return true;
  }
  return false;
}

function 处理环境互动技能(this: void, 施法单位: any, 技能ID: number): void {
  if (施法单位 == null || 施法单位 === 0 || !是玩家英雄组单位(施法单位)) return;
  if (技能ID !== stringToFourCCSafe(环境互动技能ID)) return;

  const 玩家 = GetOwningPlayer(施法单位);
  if (玩家 == null || 玩家 === 0) return;
  const 玩家ID = GetPlayerId(玩家);
  const 施法X = GetUnitX(施法单位);
  const 施法Y = GetUnitY(施法单位);

  for (let i = 0; i < 环境互动调查点列表.length; i++) {
    const 调查点 = 环境互动调查点列表[i];
    const 触发范围 = 调查点.触发范围 != null && 调查点.触发范围 > 0
      ? 调查点.触发范围
      : 环境互动默认触发范围;
    if (距离平方XY(施法X, 施法Y, 调查点.X, 调查点.Y) > 触发范围 * 触发范围) continue;

    if (调查点.触发回调(玩家ID, 施法单位, 调查点)) {
      移除调查点(调查点.ID);
    }
    return;
  }
}

/** 注册一个可被环境互动技能触发的调查点；同 ID 会先替换旧配置。 */
export function 注册环境互动调查点(this: void, 调查点: 环境互动触发点): boolean {
  if (调查点 == null || 调查点.ID === "" || 调查点.触发回调 == null) return false;
  移除调查点(调查点.ID);
  环境互动调查点列表.push(调查点);
  return true;
}

/** 注销指定调查点，返回是否找到并移除。 */
export function 注销环境互动调查点(this: void, 调查点ID: string): boolean {
  if (调查点ID === "") return false;
  return 移除调查点(调查点ID);
}

/** 注销全部调查点；任务结束、场景切换或失败清理时使用。 */
export function 清理全部环境互动调查点(this: void): void {
  for (let i = 环境互动调查点列表.length - 1; i >= 0; i--) {
    环境互动调查点列表.pop();
  }
}

export function init环境互动(this: void): void {
  if (已初始化环境互动) return;
  已初始化环境互动 = true;
  registerSpellEffectListener(处理环境互动技能);
}

export {};
