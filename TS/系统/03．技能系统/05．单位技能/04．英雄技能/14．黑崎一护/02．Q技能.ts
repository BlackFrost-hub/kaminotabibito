/** @noSelfInFile */
// 黑崎一护 Q：月牙天冲（A01G）。解放前后双形态弹道，使用后刷新瞬步D。
// 源 JASS 真源：技能.j（A01G 段 646-692；弹道周期 Func009T 38-111；碰撞 Func017A 8-17）。
// 单位壳 e00P/e012/e013 迁移为直接特效 + 路径上下文（计划第 5 节），伤害走统一封装。
// 冲突口径：解放后“无视100%护甲”源挂 player 属性；伤害系统 getBoolAttr 本身支持“单位属性优先、玩家属性回退”，
// 故按源口径直挂 player 属性（结算前开、结算后关）。

import { 黑崎一护技能配置 } from "./00．配置";
import { 黑崎一护是否卍解, 记录月牙位置, 清除月牙位置 } from "./01．状态表";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};

const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const DzSetEffectPos = japi.DzSetEffectPos as (this: void, effect: any, x: number, y: number, z: number) => void;

const 配置 = 黑崎一护技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const Q类型ID = stringToFourCCSafe(配置.Q.技能ID);
const D类型ID = stringToFourCCSafe(配置.D.技能ID);

function 计算两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG;
}

interface Q弹道上下文 {
  施法者: any;
  X: number;
  Y: number;
  角度: number;
  Tick数: number;
  已命中组: Record<number, boolean>;
  主特效: any;
  虚影特效: any;
  卍解: boolean;
  攻击力快照: number;
  技能实例ID?: number;
  回调ID: number;
  已启动: boolean;
}

const Q弹道上下文表: Record<number, Q弹道上下文> = {};

function 获取或创建Q上下文(this: void, unit: any): Q弹道上下文 {
  const id = GetHandleId(unit);
  let ctx = Q弹道上下文表[id];
  if (ctx == null) {
    ctx = {
      施法者: unit,
      X: 0,
      Y: 0,
      角度: 0,
      Tick数: 0,
      已命中组: {},
      主特效: null,
      虚影特效: null,
      卍解: false,
      攻击力快照: 0,
      回调ID: 0,
      已启动: false,
    };
    Q弹道上下文表[id] = ctx;
  }
  return ctx;
}

function 结束Q弹道(this: void, ctx: Q弹道上下文): void {
  if (ctx.回调ID !== 0) removePeriodicCallback(ctx.回调ID);
  ctx.回调ID = 0;
  if (ctx.主特效 != null && ctx.主特效 !== 0) 销毁点特效(ctx.主特效);
  if (ctx.虚影特效 != null && ctx.虚影特效 !== 0) 销毁点特效(ctx.虚影特效);
  ctx.主特效 = null;
  ctx.虚影特效 = null;
  ctx.已命中组 = {};
  ctx.已启动 = false;
  清除月牙位置(ctx.施法者);
}

function 结算Q月牙碰撞(this: void, ctx: Q弹道上下文): void {
  const caster = ctx.施法者;
  const 敌军 = 获取范围敌军(caster, ctx.X, ctx.Y, 配置.Q.碰撞半径);
  if (敌军 == null || 敌军.length === 0) return;

  const 参数 = ctx.卍解 ? 配置.Q.解放后 : 配置.Q.未解放;
  const 伤害 = ctx.攻击力快照 * 参数.伤害攻击力倍率;
  // 源：卍解分支结算前 player“无视护甲”置 true；伤害系统 getBoolAttr 单位无该属性时回退读玩家属性。
  if (ctx.卍解) YDUserDataSetSafe("player", GetOwningPlayer(caster), "无视护甲", "boolean", true);
  for (let i = 0; i < 敌军.length; i++) {
    const target = 敌军[i];
    if (target == null || target === 0) continue;
    const tid = GetHandleId(target);
    if (ctx.已命中组[tid] === true) continue; // 源：重复单位组，每目标仅命中一次
    ctx.已命中组[tid] = true;
    造成单体技能伤害({
      来源: caster,
      目标: target,
      伤害,
      伤害类型: DAMAGE_TYPE_NORMAL,
      attack: true,
      ranged: true,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: "黑崎一护-Q月牙天冲",
      技能ID: Q类型ID,
      技能实例ID: ctx.技能实例ID,
    });
  }
  if (ctx.卍解) YDUserDataSetSafe("player", GetOwningPlayer(caster), "无视护甲", "boolean", false);
}

function 推进Q月牙(this: void, variable: any): void {
  const ctx = variable as Q弹道上下文;
  if (ctx == null || ctx.已启动 !== true) return;

  ctx.Tick数 += 1;
  if (ctx.Tick数 >= 配置.Q.最大推进次数) {
    结束Q弹道(ctx);
    return;
  }

  const rad = ctx.角度 * bj_DEGTORAD;
  ctx.X += Cos(rad) * 配置.Q.每Tick距离;
  ctx.Y += Sin(rad) * 配置.Q.每Tick距离;

  const 参数 = ctx.卍解 ? 配置.Q.解放后 : 配置.Q.未解放;
  if (ctx.主特效 != null && ctx.主特效 !== 0) {
    DzSetEffectPos(ctx.主特效, ctx.X, ctx.Y, 参数.弹道高度);
  }
  if (ctx.虚影特效 != null && ctx.虚影特效 !== 0) {
    DzSetEffectPos(ctx.虚影特效, ctx.X, ctx.Y, 配置.Q.解放后.虚影高度);
  }
  记录月牙位置(ctx.施法者, ctx.X, ctx.Y); // D 瞬步连携：飞向未结束的月牙

  // 拖尾表现（源每 tick 双特效，高度 160）
  创建点特效({ 模型路径: 参数.拖尾模型, X: ctx.X, Y: ctx.Y, Z: 参数.拖尾高度, 缩放: 参数.拖尾缩放, 持续秒: 参数.拖尾持续秒 });
  创建点特效({
    模型路径: 参数.拖尾副模型,
    X: ctx.X,
    Y: ctx.Y,
    Z: 参数.拖尾高度,
    缩放: ctx.卍解 ? 配置.Q.解放后.拖尾副缩放 : 1,
    持续秒: 参数.拖尾副持续秒,
  });

  结算Q月牙碰撞(ctx);
}

function Q可释放(this: void, context: Q弹道上下文, _caster: any): boolean {
  return context.已启动 !== true;
}

function 释放Q月牙天冲(this: void, context: Q弹道上下文, caster: any, 技能实例ID?: number): void {
  // 源：Q 使用后刷新瞬步D（同步冷却路径）
  技能_设置技能冷却时间(caster, D类型ID, 0, 配置.D.物编冷却秒);

  const tx = GetSpellTargetX();
  const ty = GetSpellTargetY();
  const sx = GetUnitX(caster);
  const sy = GetUnitY(caster);
  const 角度 = 计算两点角度(sx, sy, tx, ty);
  const 卍解 = 黑崎一护是否卍解(caster);
  const 参数 = 卍解 ? 配置.Q.解放后 : 配置.Q.未解放;

  Sound3DII_CooPlayReuse(参数.音效.路径, sx, sy, 0, 参数.音效.裁断距离);

  context.施法者 = caster;
  context.X = sx;
  context.Y = sy;
  context.角度 = 角度;
  context.Tick数 = 0;
  context.已命中组 = {};
  context.卍解 = 卍解;
  context.攻击力快照 = 读取单位攻击力(caster);
  context.技能实例ID = 技能实例ID;
  context.已启动 = true;

  context.主特效 = 创建点特效({
    模型路径: 参数.弹道模型,
    X: sx,
    Y: sy,
    Z: 参数.弹道高度,
    面向角度: 角度,
    X轴角度: 参数.弹道X轴角度, // 物编 maxRoll=-90
    缩放: 参数.弹道缩放,
    持续秒: 1.5,
  });
  if (卍解) {
    context.虚影特效 = 创建点特效({
      模型路径: 配置.Q.解放后.虚影模型,
      X: sx,
      Y: sy,
      Z: 配置.Q.解放后.虚影高度,
      面向角度: 角度,
      缩放: 配置.Q.解放后.虚影缩放,
      持续秒: 1.5,
    });
  } else {
    context.虚影特效 = null;
  }

  记录月牙位置(caster, sx, sy);
  context.回调ID = addPeriodicCallback(
    Math.round(配置.Q.推进间隔秒 * 1000),
    推进Q月牙 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

export function 注册黑崎一护Q(this: void): void {
  注册单位技能壳监听({
    名称: "黑崎一护-月牙天冲（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.Q.技能ID,
    获取或创建上下文: 获取或创建Q上下文,
    可释放: Q可释放,
    释放技能: 释放Q月牙天冲,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 3,
  });
}

注册黑崎一护Q();

export {};
