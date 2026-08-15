/** @noSelfInFile */
// 黑崎一护 A键黑流牙突：卍解期间按 A 攻击 500-1200 码敌人时突进强化普攻。
// 源 JASS 真源：开启R之后的A键黑流牙突.j（入口 86-134；推进周期 22-84；标记清理 4-20）。
// 架构（计划第 3 节）：A键中心只负责按玩家分发“进入攻击选择”状态（武装标记）；
// 真正的目标单位由同步 EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER（单位指令事件中心）取得，
// 距离/形态/突进/伤害/标记全部同步执行。单位壳（技能马甲 BlackArrowMissile）优化为直接特效，
// 保持壳参数：缩放3.0、飞行高度135、0.02s/30码时间线（计划第 5 节）。

import { 黑崎一护技能配置 } from "./00．配置";
import { 获取黑崎一护状态, 黑崎一护是否卍解, 黑崎一护A键是否武装, 解除黑崎一护A键武装 } from "./01．状态表";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback, addDelayedCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 注册A键监听 } = require("系统.00．核心系统.01．事件中心.14．A键事件中心") as {
  注册A键监听: (this: void, playerId: number, listener: (this: void, event: any) => void) => void;
};
const { registerTargetOrderListener } = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerTargetOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe, YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, p: any) => number;
const GetHeroLevel = jass.GetHeroLevel as (this: void, unit: any) => number;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, p: any) => boolean;
const IsUnitAliveBJ = jass.IsUnitAliveBJ as (this: void, unit: any) => boolean;
const ShowUnit = jass.ShowUnit as (this: void, unit: any, show: boolean) => void;
const SelectUnitForPlayerSingle = jass.SelectUnitForPlayerSingle as (this: void, unit: any, p: any) => void;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const IsTerrainPathable = jass.IsTerrainPathable as (this: void, x: number, y: number, pathingType: any) => boolean;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const SquareRoot = jass.SquareRoot as (this: void, x: number) => number;
const OrderId = jass.OrderId as (this: void, orderString: string) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const DzSetEffectPos = japi.DzSetEffectPos as (this: void, effect: any, x: number, y: number, z: number) => void;

const 配置 = 黑崎一护技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const 攻击指令ID = OrderId("attack");

// ---------------------------------------------------------------------------
// A键武装：A键中心回调只推进同步状态（计划第 3 节）
// ---------------------------------------------------------------------------

const 已注册A键的玩家: Record<number, boolean> = {};

function A键回调(this: void, event: any): void {
  if (event == null || event.player == null || event.player === 0) return;
  // 只武装当前拥有黑崎一护且处于卍解的玩家的英雄本体
  const playerId = GetPlayerId(event.player);
  const hero = 按玩家查找黑崎一护(playerId);
  if (hero == null || hero === 0) return;
  if (!黑崎一护是否卍解(hero)) return;
  const record = 获取黑崎一护状态(hero);
  if (record != null) record.A键已武装 = true;
}

function 按玩家查找黑崎一护(this: void, playerId: number): any {
  const g = jass.CreateGroup();
  jass.GroupEnumUnitsOfPlayer(g, jass.Player(playerId));
  let found: any = null;
  let u = jass.FirstOfGroup(g);
  while (u != null && u !== 0) {
    jass.GroupRemoveUnit(g, u);
    if (GetUnitTypeId(u) === 英雄单位类型ID && IsUnitAliveBJ(u)) {
      found = u;
      break;
    }
    u = jass.FirstOfGroup(g);
  }
  jass.DestroyGroup(g);
  return found;
}

/** R 卍解启动时调用：按玩家注册一次 A 键监听，重复注册被中心忽略。 */
export function 注册玩家黑流牙突A键(this: void, caster: any): void {
  if (caster == null || caster === 0) return;
  const playerId = GetPlayerId(GetOwningPlayer(caster));
  if (已注册A键的玩家[playerId] === true) return;
  已注册A键的玩家[playerId] = true;
  注册A键监听(playerId, A键回调);
}

// ---------------------------------------------------------------------------
// 突进上下文与执行
// ---------------------------------------------------------------------------

interface 黑流牙突上下文 {
  施法者: any;
  玩家: any;
  目标: any;
  特效: any;
  Tick数: number;
  回调ID: number;
  进行中: boolean;
}

const 突进上下文表: Record<number, 黑流牙突上下文> = {};

function 恢复施法者(this: void, ctx: 黑流牙突上下文): void {
  const caster = ctx.施法者;
  if (caster != null && caster !== 0) {
    ShowUnit(caster, true);
    SelectUnitForPlayerSingle(caster, ctx.玩家);
  }
  if (ctx.特效 != null && ctx.特效 !== 0) 销毁点特效(ctx.特效);
  ctx.特效 = null;
  ctx.进行中 = false;
  if (ctx.回调ID !== 0) removePeriodicCallback(ctx.回调ID);
  ctx.回调ID = 0;
}

function 清除黑流牙突标记(this: void, variable: any): void {
  const target = variable as any;
  if (target == null || target === 0) return;
  YDUserDataClearSafe("unit", target, "黑流牙突", "boolean");
}

function 结算黑流牙突命中(this: void, ctx: 黑流牙突上下文): void {
  const caster = ctx.施法者;
  const target = ctx.目标;

  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  创建点特效({
    模型路径: 配置.黑流牙突.命中特效.模型,
    X: tx,
    Y: ty,
    Z: 配置.黑流牙突.命中特效.高度,
    面向角度: 配置.黑流牙突.命中特效.面向角度,
    缩放: 配置.黑流牙突.命中特效.缩放,
    持续秒: 配置.黑流牙突.命中特效.持续秒,
  });

  // 源：攻击力 × (1.20 + 0.02 × 英雄等级)，触发攻击效果的强化伤害
  const 伤害 = 读取单位攻击力(caster) * (配置.黑流牙突.基础伤害倍率 + 配置.黑流牙突.每级伤害加成 * GetHeroLevel(caster));
  造成单体技能伤害({
    来源: caster,
    目标: target,
    伤害,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    attack: true,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    标签: "黑崎一护-黑流牙突",
  });

  // 目标 5 秒内置标记
  YDUserDataSetSafe("unit", target, "黑流牙突", "boolean", true);
  addDelayedCallback(Math.round(配置.黑流牙突.标记持续秒 * 1000), 清除黑流牙突标记 as unknown as (this: void, variable?: any) => void, target);

  恢复施法者(ctx);
}

function 推进黑流牙突(this: void, variable: any): void {
  const ctx = variable as 黑流牙突上下文;
  if (ctx == null || ctx.进行中 !== true) return;
  const caster = ctx.施法者;
  const target = ctx.目标;

  ctx.Tick数 += 1;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster) || target == null || target === 0 || !IsUnitAliveBJ(target) || ctx.Tick数 >= 配置.黑流牙突.最大推进次数) {
    恢复施法者(ctx); // 未命中/死亡收尾：恢复本体显示
    return;
  }

  // 每 tick 重新取“施法者→目标”方向（源行为）
  const cx = GetUnitX(caster);
  const cy = GetUnitY(caster);
  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  const 角度 = Atan2(ty - cy, tx - cx) * bj_RADTODEG;
  const rad = 角度 * bj_DEGTORAD;
  const nx = cx + Cos(rad) * 配置.黑流牙突.每Tick距离;
  const ny = cy + Sin(rad) * 配置.黑流牙突.每Tick距离;

  // 地形检查（计划第 4 节：不得无条件位移）
  if (IsTerrainPathable(nx, ny, PATHING_TYPE_WALKABILITY)) {
    恢复施法者(ctx);
    return;
  }

  SetUnitX(caster, nx);
  SetUnitY(caster, ny);
  SetUnitFacing(caster, 角度);
  if (ctx.特效 != null && ctx.特效 !== 0) DzSetEffectPos(ctx.特效, nx, ny, 配置.黑流牙突.特效高度);
  创建点特效({ 模型路径: 配置.黑流牙突.推进特效.模型, X: nx, Y: ny, Z: 0, 持续秒: 配置.黑流牙突.推进特效.持续秒 });

  const dx = nx - tx;
  const dy = ny - ty;
  if (SquareRoot(dx * dx + dy * dy) <= 配置.黑流牙突.命中半径码) {
    结算黑流牙突命中(ctx);
  }
}

function 发起黑流牙突(this: void, caster: any, target: any): void {
  const cx = GetUnitX(caster);
  const cy = GetUnitY(caster);
  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  const 角度 = Atan2(ty - cy, tx - cx) * bj_RADTODEG;
  const rad = 角度 * bj_DEGTORAD;

  // 源：本体隐藏；出生点为施法者沿目标方向反向 75 码
  ShowUnit(caster, false);
  const bx = cx - Cos(rad) * 配置.黑流牙突.出生偏移码;
  const by = cy - Sin(rad) * 配置.黑流牙突.出生偏移码;
  const effect = 创建点特效({
    模型路径: 配置.黑流牙突.特效模型,
    X: bx,
    Y: by,
    Z: 配置.黑流牙突.特效高度,
    面向角度: 角度,
    缩放: 配置.黑流牙突.特效缩放,
    持续秒: 2.5,
  });

  const ctx: 黑流牙突上下文 = {
    施法者: caster,
    玩家: GetOwningPlayer(caster),
    目标: target,
    特效: effect,
    Tick数: 0,
    回调ID: 0,
    进行中: true,
  };
  突进上下文表[GetHandleId(caster)] = ctx;
  ctx.回调ID = addPeriodicCallback(
    Math.round(配置.黑流牙突.推进间隔秒 * 1000),
    推进黑流牙突 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

// ---------------------------------------------------------------------------
// 同步目标指令入口：A键进入攻击选择后，真正点击敌人由这里取得
// ---------------------------------------------------------------------------

function 目标指令回调(this: void, unit: any, orderId: number, targetUnit: any, _targetItem: any, _targetDestructable: any): void {
  if (unit == null || unit === 0) return;
  if (GetUnitTypeId(unit) !== 英雄单位类型ID) return;
  if (orderId !== 攻击指令ID) return;

  const record = 获取黑崎一护状态(unit);
  if (record == null || record.A键已武装 !== true) return;
  // A键武装是一次性的：无论本次攻击是否满足黑流牙突条件都消耗，避免残留
  解除黑崎一护A键武装(unit);

  if (record.卍解 !== true) return;
  if (targetUnit == null || targetUnit === 0 || !IsUnitAliveBJ(targetUnit)) return;
  if (!IsUnitEnemy(targetUnit, GetOwningPlayer(unit))) return;
  if (YDUserDataGetSafe("unit", targetUnit, "黑流牙突", "boolean") === true) return;

  const dx = GetUnitX(targetUnit) - GetUnitX(unit);
  const dy = GetUnitY(targetUnit) - GetUnitY(unit);
  const 距离 = SquareRoot(dx * dx + dy * dy);
  if (距离 < 配置.黑流牙突.最小距离码 || 距离 > 配置.黑流牙突.最大距离码) return;

  // 突进中不允许叠加
  const 旧上下文 = 突进上下文表[GetHandleId(unit)];
  if (旧上下文 != null && 旧上下文.进行中 === true) return;

  发起黑流牙突(unit, targetUnit);
}

// ---------------------------------------------------------------------------
// 死亡清理与注册
// ---------------------------------------------------------------------------

let 已初始化 = false;

function 黑流牙突死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  const ctx = 突进上下文表[GetHandleId(dyingUnit)];
  if (ctx != null && ctx.进行中 === true) {
    if (ctx.回调ID !== 0) removePeriodicCallback(ctx.回调ID);
    ctx.回调ID = 0;
    if (ctx.特效 != null && ctx.特效 !== 0) 销毁点特效(ctx.特效);
    ctx.特效 = null;
    ctx.进行中 = false;
  }
}

export function 注册黑流牙突(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  registerTargetOrderListener(目标指令回调);
  registerDeathListener(黑流牙突死亡清理);
  // R 卍解启动时按玩家调用 注册玩家黑流牙突A键；A键中心按 playerId 分发。
}

注册黑流牙突();

export {};
