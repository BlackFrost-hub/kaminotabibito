/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import {
  创建直线飞刀,
  两点角度,
  极坐标X,
  极坐标Y,
  播放咲夜单位音效,
  施加短硬直并播放动作,
  type 直线飞刀状态,
} from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 十六夜咲夜处于RA强化 } from "./RA技能";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 造成单体技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;

interface W监听上下文 { 占位: boolean; }
interface W施法上下文 {
  施法者: any;
  技能实例ID?: number;
  伤害: number;
  剩余飞刀: number;
  已结束: boolean;
  目标X: number;
  目标Y: number;
  波次数: number;
  当前波次: number;
}

function 获取W监听上下文(this: void, _caster: any): W监听上下文 { return { 占位: true }; }

function W飞刀结束(this: void, state: 直线飞刀状态): void {
  const cast = state.自定义数据 as W施法上下文;
  cast.剩余飞刀 -= 1;
  if (cast.剩余飞刀 <= 0 && !cast.已结束) {
    cast.已结束 = true;
    结束独立技能伤害实例(cast.技能实例ID);
  }
}

function W飞刀命中(this: void, target: any, state: 直线飞刀状态): "结束" {
  const cast = state.自定义数据 as W施法上下文;
  造成单体技能伤害({
    来源: cast.施法者,
    目标: target,
    伤害: cast.伤害,
    伤害类型: DAMAGE_TYPE_NORMAL,
    attack: true,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: "单位技能",
    标签: "十六夜咲夜-W-Misdirection",
    技能ID: 配置.技能.W.类型ID,
    技能实例ID: cast.技能实例ID,
  });
  return "结束";
}

function 发射十六夜咲夜W(this: void, variable?: any): void {
  const cast = variable as W施法上下文 | undefined;
  if (cast == null) return;
  const caster = cast.施法者;
  if (caster == null || caster === 0) {
    结束独立技能伤害实例(cast.技能实例ID);
    return;
  }
  const casterX = GetUnitX(caster);
  const casterY = GetUnitY(caster);
  const baseAngle = 两点角度(casterX, casterY, cast.目标X, cast.目标Y);
  const source = `十六夜咲夜-W:${cast.技能实例ID ?? jass.GetHandleId(caster)}`;
  施加短硬直并播放动作(caster, source, 配置.W.硬直秒, "spell,slam");
  播放咲夜单位音效(`gg_snd_IzayoiSakuya_attack${jass.GetRandomInt(4, 8)}`, caster);
  播放咲夜单位音效("gg_snd_OrbOfCorruptionMissile", caster);

  const initialAngle = baseAngle + 配置.W.初始角度偏移;
  for (let i = 1; i <= 配置.W.数量; i++) {
    const angle = initialAngle - 配置.W.每刀角度间隔 * i;
    const state = 创建直线飞刀({
      施法者: caster,
      单位类型ID: 配置.单位壳.红刀,
      X: 极坐标X(casterX, 配置.W.创建距离, angle),
      Y: 极坐标Y(casterY, 配置.W.创建距离, angle),
      角度: angle,
      周期毫秒: 配置.W.周期毫秒,
      每Tick位移: 配置.W.每Tick位移,
      最大距离: 配置.W.最大距离,
      命中半径: 配置.W.命中半径,
      命中回调: W飞刀命中,
      结束回调: W飞刀结束,
    });
    if (state == null) cast.剩余飞刀 -= 1;
    else state.自定义数据 = cast;
  }
  cast.当前波次 += 1;
  if (cast.当前波次 < cast.波次数) addDelayedCallback(配置.RA.W波间隔毫秒, 发射十六夜咲夜W, cast);
  if (cast.剩余飞刀 <= 0) 结束独立技能伤害实例(cast.技能实例ID);
}

function 释放十六夜咲夜W(this: void, _context: W监听上下文, caster: any, 技能实例ID?: number): void {
  const waves = 十六夜咲夜处于RA强化(caster) ? 配置.RA.W波数 : 1;
  const cast: W施法上下文 = {
    施法者: caster,
    技能实例ID,
    伤害: 读取单位攻击力(caster) * 配置.W.伤害攻击力倍率,
    剩余飞刀: 配置.W.数量 * waves,
    已结束: false,
    目标X: GetSpellTargetX(),
    目标Y: GetSpellTargetY(),
    波次数: waves,
    当前波次: 0,
  };
  addDelayedCallback(10, 发射十六夜咲夜W, cast);
}

export function 注册十六夜咲夜W(this: void): void {
  注册单位技能壳监听({
    名称: "十六夜咲夜-Misdirection（W）",
    单位类型ID: 配置.英雄单位类型ID,
    技能ID: 配置.技能.W.类型ID,
    获取或创建上下文: 获取W监听上下文,
    释放技能: 释放十六夜咲夜W,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 5,
  });
}

注册十六夜咲夜W();

export {};
