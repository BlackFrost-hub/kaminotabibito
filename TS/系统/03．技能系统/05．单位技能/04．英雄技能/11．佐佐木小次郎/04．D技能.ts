/** @noSelfInFile */

/**
 * 佐佐木小次郎 - D 平行次元斩（右键分身换位 + 残影冲刺）
 *
 * 源 JASS：`右键分身移动.J`（触发 1ZZMSY）。
 * 流程：
 * - 玩家任意单位右键点选目标时，在目标单位 100 码内寻找佐佐木分身
 *   （存活、幻象 Buff、同类型、距本体 ≤1000 码），随机选取一个
 * - 本体与分身交换位置（本体 SetUnitX/Y，分身 SetUnitPosition），
 *   本体原地 holdposition，进入 3 秒内部瞬移冷却（A0GW 上由 QWERD 系统显示，见 00B）
 * - 在原位置生成残影马甲（e07W，动作 9 @2.2 倍速、顶点色 alpha 225）向分身原位置冲刺：
 *   常速 40 码/20ms（2000 码/秒）；距离 ≥750 码进入快速模式 60 码/20ms（3000 码/秒）
 * - 冲刺路径 200 码内敌人受到 攻击力×1.5 换位冲刺伤害（每单位一次）
 * - 快速模式追加「燕返」被动：额外造成 攻击力×2 + 0.5 秒硬直（每单位一次），
 *   并生成 e07S/e07T 快速刀光（DK52 音效）
 * - 换位后 1 秒内为「瞬移后」窗口（Q 附加剑气，见 00B）
 */

import { 佐佐木单位技能配置 } from "./00．配置";
import { 播放佐佐木坐标音效 } from "./00A．表现工具";
import {
  是佐佐木本体,
  是佐佐木分身,
  瞬移是否就绪,
  启用瞬移冷却,
  设置瞬移后标记,
  注册佐佐木英雄,
  获取玩家佐佐木英雄,
} from "./00B．分身与状态管理";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerTargetOrderListener } = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerTargetOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void) => void;
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { SFB_施加通用Buff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_施加通用Buff: (this: void, 来源单位: any, 目标单位: any, Buff类型: number, 持续时间: number) => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const D技能ID数值 = stringToFourCCSafe(佐佐木单位技能配置.D被动技能ID);

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const CreateUnit = jass.CreateUnit as (this: void, player: any, unitId: number, x: number, y: number, face: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (this: void, unit: any, r: number, g: number, b: number, a: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;

const 残影马甲ID = stringToFourCCSafe(佐佐木单位技能配置.D.残影马甲ID);
const 快速刀光前ID = stringToFourCCSafe(佐佐木单位技能配置.D.快速刀光前ID);
const 快速刀光后ID = stringToFourCCSafe(佐佐木单位技能配置.D.快速刀光后ID);

function 两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return Math.sqrt(dx * dx + dy * dy);
}

function 两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
}

function 是有效敌人(this: void, 施法者: any, target: any): boolean {
  if (target == null || target === 0 || target === 施法者) return false;
  if (!单位存活(target)) return false;
  if (jass.IsUnitType(target, jass.UNIT_TYPE_ANCIENT as any)) return false;
  if (jass.IsUnitType(target, jass.UNIT_TYPE_MECHANICAL as any)) return false;
  if (jass.IsUnitType(target, jass.UNIT_TYPE_STRUCTURE as any)) return false;
  if (!isUnitEnemy(target, 施法者)) return false;
  return true;
}

/** 执行换位与残影冲刺（源 JASS Trig_1ZZMSYFunc002Func002Func005T） */
function 执行佐佐木换位(this: void, 英雄: any, 分身单位: any): void {
  const cfg = 佐佐木单位技能配置.D;
  const owner = GetOwningPlayer(英雄);
  const 本体X = GetUnitX(英雄);
  const 本体Y = GetUnitY(英雄);
  const 分身X = GetUnitX(分身单位);
  const 分身Y = GetUnitY(分身单位);
  const 距离 = 两点距离(本体X, 本体Y, 分身X, 分身Y);
  const 角度 = 两点角度(本体X, 本体Y, 分身X, 分身Y);
  const 弧度 = 角度 * Math.PI / 180;
  const 快速模式 = 距离 >= cfg.快速模式距离;
  const 每tick距离 = 快速模式 ? cfg.快速每tick距离 : cfg.冲刺每tick距离;
  const 总步数 = Math.ceil(距离 / 每tick距离);

  // 残影马甲：顶点色 alpha 225、动作 9 @2.2 倍速
  const 残影 = CreateUnit(owner, 残影马甲ID, 本体X, 本体Y, 角度);
  if (残影 == null || 残影 === 0) return;
  SetUnitVertexColor(残影, 255, 255, 255, 225);
  SetUnitAnimationByIndex(残影, 9);
  SetUnitTimeScale(残影, 2.2);

  // 快速模式：前方 100 码快速刀光（e07S）+ 起点 0.1 倍速慢刀光（e07T）
  let 刀光: any = null;
  if (快速模式) {
    刀光 = CreateUnit(owner, 快速刀光前ID, 本体X + Math.cos(弧度) * 100, 本体Y + Math.sin(弧度) * 100, 角度);
    const 刀光后 = CreateUnit(owner, 快速刀光后ID, 本体X, 本体Y, 角度);
    SetUnitTimeScale(刀光后, 0.1);
    if (刀光 != null && 刀光 !== 0) {
      播放佐佐木坐标音效(cfg.快速刀光音效路径, GetUnitX(刀光), GetUnitY(刀光), cfg.快速刀光音效裁断);
    }
  }

  // 突进 + 被动瞬移音效（源 MetalHeavySliceFlesh2 / DJ11）
  播放佐佐木坐标音效(cfg.突进音效路径, 本体X, 本体Y, cfg.突进音效裁断);
  播放佐佐木坐标音效(cfg.换位音效路径, 本体X, 本体Y, cfg.换位音效裁断);

  // 内部瞬移冷却 3 秒；A0GW 上由 QWERD 系统显示，创建分身时会提前刷新
  启用瞬移冷却(英雄);

  // 交换位置：本体瞬移到分身处，分身送回原位；本体原地待命
  SetUnitX(英雄, 分身X);
  SetUnitY(英雄, 分身Y);
  SetUnitPosition(分身单位, 本体X, 本体Y);
  IssueImmediateOrder(英雄, "holdposition");

  // 配合 Q 技能的「瞬移后」窗口
  设置瞬移后标记(英雄);

  // 残影冲刺 + 路径伤害（源 0.02 秒循环计时器）
  const 冲刺命中表: Record<number, boolean | undefined> = {};
  const 燕返命中表: Record<number, boolean | undefined> = {};
  const 步长X = Math.cos(弧度) * 每tick距离;
  const 步长Y = Math.sin(弧度) * 每tick距离;
  let 当前X = 本体X;
  let 当前Y = 本体Y;
  let 已走步数 = 0;

  const loopId = addPeriodicCallback(cfg.冲刺tick毫秒, () => {
    已走步数++;
    if (已走步数 > 总步数 || !单位存活(英雄)) {
      RemoveUnit(残影);
      if (刀光 != null && 刀光 !== 0) RemoveUnit(刀光);
      removePeriodicCallback(loopId);
      return;
    }

    当前X += 步长X;
    当前Y += 步长Y;
    SetUnitX(残影, 当前X);
    SetUnitY(残影, 当前Y);
    if (刀光 != null && 刀光 !== 0) {
      SetUnitX(刀光, 当前X + 步长X * (100 / 每tick距离));
      SetUnitY(刀光, 当前Y + 步长Y * (100 / 每tick距离));
    }

    // 路径及附近敌人：换位冲刺伤害（每单位一次）
    const units = getUnitsInRange(当前X, 当前Y, cfg.换位伤害半径);
    for (let i = 0; i < units.length; i++) {
      const enemy = units[i];
      if (!是有效敌人(英雄, enemy)) continue;
      const enemyId = GetHandleId(enemy);
      if (冲刺命中表[enemyId] === true) continue;
      冲刺命中表[enemyId] = true;
      造成技能伤害({
        来源: 英雄,
        目标: enemy,
        伤害: 读取单位攻击力(英雄) * cfg.换位攻击倍率,
        伤害类型: DAMAGE_TYPE_NORMAL,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: D技能ID数值,
        标签: "佐佐木小次郎-换位冲刺",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });
    }

    // 快速模式追加「燕返」被动：攻击力×2 + 0.5 秒硬直（每单位一次）
    if (快速模式) {
      for (let i = 0; i < units.length; i++) {
        const enemy = units[i];
        if (!是有效敌人(英雄, enemy)) continue;
        const enemyId = GetHandleId(enemy);
        if (燕返命中表[enemyId] === true) continue;
        燕返命中表[enemyId] = true;
        SFB_施加通用Buff(英雄, enemy, 21, cfg.燕返硬直秒);
        造成技能伤害({
          来源: 英雄,
          目标: enemy,
          伤害: 读取单位攻击力(英雄) * cfg.燕返攻击倍率,
          伤害类型: DAMAGE_TYPE_NORMAL,
          ranged: false,
          attackType: ATTACK_TYPE_NORMAL,
          weaponType: WEAPON_TYPE_WHOKNOWS,
          来源类型: "单位技能",
          技能ID: D技能ID数值,
          标签: "佐佐木小次郎-燕返被动",
          伤害形态: "AOE",
          参与技能伤害加成: true,
        });
      }
    }
  });
}

function on佐佐木右键指令(this: void, 指令单位: any, orderId: number, 目标单位: any, 目标物品: any, 目标可破坏物: any): void {
  void orderId;
  void 目标物品;
  void 目标可破坏物;
  if (目标单位 == null || 目标单位 === 0) return;

  // 由指令单位定位佐佐木本体：本体自身下单，或同玩家任意单位下单反查注册表
  let 英雄: any = null;
  if (是佐佐木本体(指令单位)) {
    注册佐佐木英雄(指令单位);
    英雄 = 指令单位;
  } else {
    英雄 = 获取玩家佐佐木英雄(GetOwningPlayer(指令单位));
  }
  if (英雄 == null || 英雄 === 0) return;
  if (!单位存活(英雄)) return;
  if (!瞬移是否就绪(英雄)) return;

  // 只认右键点中的分身：目标单位本身是佐佐木有效分身（距本体 ≤1000 码）时直接换位。
  // 不做范围搜索/随机选取——玩家点中的就是目标，且避免命中残留句柄传到地图中心。
  const cfg = 佐佐木单位技能配置.D;
  const 本体X = GetUnitX(英雄);
  const 本体Y = GetUnitY(英雄);
  if (是佐佐木分身(英雄, 目标单位) && 两点距离(本体X, 本体Y, GetUnitX(目标单位), GetUnitY(目标单位)) <= cfg.瞬移最大距离) {
    执行佐佐木换位(英雄, 目标单位);
  }
}

registerTargetOrderListener(on佐佐木右键指令);

export {};
