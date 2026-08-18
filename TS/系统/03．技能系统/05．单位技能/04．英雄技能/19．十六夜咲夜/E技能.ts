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
  type 直线飞刀命中结果,
} from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
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

interface E监听上下文 { 占位: boolean; }
interface E施法上下文 {
  施法者: any;
  技能实例ID?: number;
  攻击力: number;
  剩余飞刀: number;
  已结束: boolean;
}
interface E飞刀数据 {
  施法: E施法上下文;
  已反弹: boolean;
}

function 获取E监听上下文(this: void, _caster: any): E监听上下文 { return { 占位: true }; }

function E飞刀结束(this: void, state: 直线飞刀状态): void {
  const data = state.自定义数据 as E飞刀数据;
  const cast = data.施法;
  cast.剩余飞刀 -= 1;
  if (cast.剩余飞刀 <= 0 && !cast.已结束) {
    cast.已结束 = true;
    结束独立技能伤害实例(cast.技能实例ID);
  }
}

function E飞刀命中(this: void, target: any, state: 直线飞刀状态): 直线飞刀命中结果 {
  const data = state.自定义数据 as E飞刀数据;
  const cast = data.施法;
  const multiplier = data.已反弹 ? 配置.E.反弹伤害攻击力倍率 : 配置.E.首段伤害攻击力倍率;
  造成单体技能伤害({
    来源: cast.施法者,
    目标: target,
    伤害: cast.攻击力 * multiplier,
    伤害类型: DAMAGE_TYPE_NORMAL,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: "单位技能",
    标签: data.已反弹 ? "十六夜咲夜-E-反弹" : "十六夜咲夜-E-首段",
    技能ID: 配置.技能.E.类型ID,
    技能实例ID: cast.技能实例ID,
  });
  if (!data.已反弹) {
    data.已反弹 = true;
    return "反弹";
  }
  return "结束";
}

function 释放十六夜咲夜E(this: void, _context: E监听上下文, caster: any, 技能实例ID?: number): void {
  const casterX = GetUnitX(caster);
  const casterY = GetUnitY(caster);
  const baseAngle = 两点角度(casterX, casterY, GetSpellTargetX(), GetSpellTargetY());
  const cast: E施法上下文 = {
    施法者: caster,
    技能实例ID,
    攻击力: 读取单位攻击力(caster),
    剩余飞刀: 配置.E.数量,
    已结束: false,
  };
  const source = `十六夜咲夜-E:${技能实例ID ?? jass.GetHandleId(caster)}`;
  施加短硬直并播放动作(caster, source, 配置.E.硬直秒, "spell");
  播放咲夜单位音效(`gg_snd_IzayoiSakuya_attack${jass.GetRandomInt(4, 8)}`, caster);
  播放咲夜单位音效("gg_snd_OrbOfCorruptionMissile", caster);

  const initialAngle = baseAngle + 配置.E.初始角度偏移;
  for (let i = 1; i <= 配置.E.数量; i++) {
    const angle = initialAngle - 配置.E.每刀角度间隔 * i;
    const state = 创建直线飞刀({
      施法者: caster,
      单位类型ID: 配置.单位壳.蓝刀,
      X: 极坐标X(casterX, 配置.E.创建距离, angle),
      Y: 极坐标Y(casterY, 配置.E.创建距离, angle),
      角度: angle,
      周期毫秒: 配置.E.周期毫秒,
      每Tick位移: 配置.E.每Tick位移,
      最大距离: 配置.E.最大距离,
      命中半径: 配置.E.命中半径,
      命中去重: true,
      命中回调: E飞刀命中,
      结束回调: E飞刀结束,
    });
    if (state == null) cast.剩余飞刀 -= 1;
    else state.自定义数据 = { 施法: cast, 已反弹: false } as E飞刀数据;
  }
  if (cast.剩余飞刀 <= 0) 结束独立技能伤害实例(技能实例ID);
}

export function 注册十六夜咲夜E(this: void): void {
  注册单位技能壳监听({
    名称: "十六夜咲夜-Silver Bound（E）",
    单位类型ID: 配置.英雄单位类型ID,
    技能ID: 配置.技能.E.类型ID,
    获取或创建上下文: 获取E监听上下文,
    释放技能: 释放十六夜咲夜E,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 6,
  });
}

注册十六夜咲夜E();

export {};
