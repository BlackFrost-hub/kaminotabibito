/** @noSelfInFile */
/**
 * 爱蜜莉雅 - 普攻联动：契约应和与帕克追击（A3）
 *
 * - 有效普攻条件（规划 3.3）：目标带寒意 / 目标在冰晶附近 / 目标在 W 冰花或 R 领域内。
 * - 有效普攻累计"契约应和"（Buff 层数，持续 5 秒，上限 3）。
 * - 第 3 次有效普攻：消耗全部契约应和，触发帕克追击（短距离追踪冰弹 + 小额魔法伤害）。
 * - 帕克追击减少当前剩余冷却最长的一个 Q/W/E 冷却 1 秒；不减少 R/D。
 * - 帕克追击不重复触发碎冰、不额外消耗冰晶。
 * - 普攻本身不叠加寒意（规划约束：普通层数表现与冻结/霜裂分离）。
 */

import { 爱蜜莉雅技能配置, 爱蜜莉雅普攻配置, 爱蜜莉雅被动配置, 爱蜜莉雅表现配置 } from "./00．配置";
import { 爱蜜莉雅BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/20．爱蜜莉雅";
import { 查询爱蜜莉雅冰晶 } from "./02．公共状态与冰晶";
import { 是爱蜜莉雅 } from "./03．被动效果";

const jass = require("jass.common") as any;
const { stringToFourCCSafe: stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { registerManualBuff, 移除单位指定Buff, 获取单位Buff层数 } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
  获取单位Buff层数: (this: void, unit: any, buffID: string) => number;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力, 距离平方XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
};
const platformAbilityApi = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, 单位: any, 技能代码: number) => number;
  技能_获取技能最大冷却时间: (this: void, 单位: any, 技能代码: number) => number;
};
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCC(爱蜜莉雅技能配置.单位类型ID);
const Q技能ID = stringToFourCC(爱蜜莉雅技能配置.Q.技能ID);
const W技能ID = stringToFourCC(爱蜜莉雅技能配置.W.技能ID);
const E技能ID = stringToFourCC(爱蜜莉雅技能配置.E.技能ID);
const R技能ID = stringToFourCC(爱蜜莉雅技能配置.R.技能ID);
const D技能ID = stringToFourCC(爱蜜莉雅技能配置.D.技能ID);

//=============================================================================
// 区域目标标记（W 冰花 / R 领域：进入 +1，离开 -1）
//=============================================================================

/** 爱蜜莉雅区域目标计数表：目标句柄 → 覆盖区域数（W/R 区域进入/离开维护） */
const 区域目标计数表: Record<number, number | undefined> = {};

/** W/R 区域进入时调用（目标进入冰花/领域判定） */
export function 标记目标在爱蜜莉雅区域(this: void, 目标: any): void {
  if (目标 == null || 目标 === 0) return;
  const id = GetHandleId(目标);
  区域目标计数表[id] = (区域目标计数表[id] ?? 0) + 1;
}

/** W/R 区域离开时调用 */
export function 取消标记目标在爱蜜莉雅区域(this: void, 目标: any): void {
  if (目标 == null || 目标 === 0) return;
  const id = GetHandleId(目标);
  const 计数 = 区域目标计数表[id];
  if (计数 == null) return;
  if (计数 <= 1) delete 区域目标计数表[id];
  else 区域目标计数表[id] = 计数 - 1;
}

/** 目标当前是否位于任意爱蜜莉雅区域（W/R）内 */
export function 目标在爱蜜莉雅区域(this: void, 目标: any): boolean {
  if (目标 == null || 目标 === 0) return false;
  return (区域目标计数表[GetHandleId(目标)] ?? 0) > 0;
}

//=============================================================================
// 有效普攻判定与契约应和
//=============================================================================

/** 冰晶附近判定（普攻命中点与任一冰晶距离 ≤ 配置值） */
function 目标在冰晶附近(this: void, 英雄: any, 目标: any): boolean {
  const 列表 = 查询爱蜜莉雅冰晶(英雄);
  const x = GetUnitX(目标);
  const y = GetUnitY(目标);
  const 判定距离平方 = 180 * 180; // 冰晶附近判定距离（码，待实机核对）
  for (let i = 0; i < 列表.length; i++) {
    if (距离平方XY(列表[i].X, 列表[i].Y, x, y) <= 判定距离平方) return true;
  }
  return false;
}

/** 目标是否带寒意（Buff 层数 > 0） */
function 目标带寒意(this: void, 目标: any): boolean {
  return 获取单位Buff层数(目标, 爱蜜莉雅BuffID.寒意) > 0;
}

/** 判定一次普攻是否"有效"（规划 3.3 条件之一即可） */
function 普攻是否有效(this: void, 英雄: any, 目标: any): boolean {
  if (目标带寒意(目标)) return true;
  if (目标在冰晶附近(英雄, 目标)) return true;
  if (目标在爱蜜莉雅区域(目标)) return true;
  return false;
}

//=============================================================================
// 帕克追击：追踪冰弹 + Q/W/E 冷却缩减
//=============================================================================

function 减少最长QWE冷却(this: void, 英雄: any): void {
  const 技能表: { id: number; 当前: number }[] = [
    { id: Q技能ID, 当前: platformAbilityApi.技能_获取技能当前冷却时间(英雄, Q技能ID) },
    { id: W技能ID, 当前: platformAbilityApi.技能_获取技能当前冷却时间(英雄, W技能ID) },
    { id: E技能ID, 当前: platformAbilityApi.技能_获取技能当前冷却时间(英雄, E技能ID) },
  ];
  let 最长索引 = -1;
  let 最长冷却 = 0;
  for (let i = 0; i < 技能表.length; i++) {
    if (技能表[i].当前 > 最长冷却) {
      最长冷却 = 技能表[i].当前;
      最长索引 = i;
    }
  }
  if (最长索引 < 0 || 最长冷却 <= 0) return;
  const 目标技能 = 技能表[最长索引];
  const 剩余 = 目标技能.当前 - 爱蜜莉雅普攻配置.帕克追击冷却缩减秒;
  const 新冷却 = 剩余 > 0 ? 剩余 : 0;
  const 最大冷却 = platformAbilityApi.技能_获取技能最大冷却时间(英雄, 目标技能.id);
  platformAbilityAction.技能_设置技能冷却时间(英雄, 目标技能.id, 新冷却, 最大冷却);
}

function 发射帕克追击冰弹(this: void, 英雄: any, 目标: any): void {
  if (英雄 == null || 目标 == null || 目标 === 0) return;
  const 伤害 = 读取单位攻击力(英雄) * 爱蜜莉雅普攻配置.帕克追击伤害攻击力倍率;
  const 追踪弹 = 发射弹道({
    名称: "爱蜜莉雅-帕克追击",
    所有者: 英雄,
    发射方向角: GetUnitFacing(英雄),
    速度: 爱蜜莉雅普攻配置.帕克追击速度,
    轨迹: { 类型: "追踪", 目标, 追踪转向速度: 540 },
    最大距离: 900,
    命中半径: 爱蜜莉雅普攻配置.帕克追击命中半径,
    影响目标: "敌方",
    碰撞消失: true,
    每单位最大命中次数: 1,
    伤害值: 伤害,
    伤害类型: DAMAGE_TYPE_COLD,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 0,
    技能标签: "爱蜜莉雅-帕克追击",
    伤害形态: "单体",
    参与技能伤害加成: false,
    模型: 爱蜜莉雅表现配置.帕克追击.模型路径,
   RGB: 爱蜜莉雅表现配置.帕克追击.RGB,
       缩放: 爱蜜莉雅表现配置.帕克追击.缩放,
  });
  void 追踪弹;
}

//=============================================================================
// 伤害监听入口
//=============================================================================

function 处理爱蜜莉雅造成伤害(this: void, target: any, attacker: any, _applied: number, snapshot: any): void {
  if (attacker == null || attacker === 0 || !是爱蜜莉雅(attacker)) return;
  // 仅普攻触发契约应和；跳过技能包装伤害与非原攻击者
  if (snapshot?.isNormalAttack !== true) return;
  if (snapshot?.isWrappedSkillDamage === true) return;
  if (snapshot?.originalAttacker != null && snapshot.originalAttacker !== attacker) return;
  if (target == null || target === 0) return;

  // 有效普攻条件（规划 3.3）
  if (!普攻是否有效(attacker, target)) return;

  // 契约应和 +1（Buff 层数承载；上限 3）
  const 当前层数 = 获取单位Buff层数(attacker, 爱蜜莉雅BuffID.契约应和);
  const 新层数 = 当前层数 + 1;
  if (新层数 >= 爱蜜莉雅普攻配置.契约应和上限) {
    // 第 3 次：消耗全部应和，触发帕克追击
    debugLogForce("爱蜜莉雅-普攻联动", "状态", "第3次有效普攻触发帕克追击", "目标", target);
    移除单位指定Buff(attacker, 爱蜜莉雅BuffID.契约应和);
    发射帕克追击冰弹(attacker, target);
    减少最长QWE冷却(attacker);
    return;
  }
  registerManualBuff(attacker, 爱蜜莉雅BuffID.契约应和, 爱蜜莉雅普攻配置.契约应和持续秒, 新层数, {
    stack: 新层数,
  });
}

let 已注册 = false;
let 死亡清理已注册 = false;

function 确保区域标记死亡清理(this: void): void {
  if (死亡清理已注册) return;
  死亡清理已注册 = true;
  registerDeathListener(function 爱蜜莉雅区域标记死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
    if (dyingUnit == null || dyingUnit === 0) return;
    delete 区域目标计数表[GetHandleId(dyingUnit)];
  });
}

export function 注册爱蜜莉雅普攻联动(this: void): void {
  debugLogForce("爱蜜莉雅-普攻联动", "注册", "名称", "注册爱蜜莉雅普攻联动");
  if (已注册) return;
  已注册 = true;
  确保区域标记死亡清理();
  registerAppliedFinalDamageListener(处理爱蜜莉雅造成伤害);
}

export {};
