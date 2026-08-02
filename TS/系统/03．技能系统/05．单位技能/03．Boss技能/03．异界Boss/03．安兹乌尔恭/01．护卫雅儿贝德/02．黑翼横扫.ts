/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 执行BossAOE技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 单位是否在扇形区域 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 开始击退 } from '../../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};

const { 设置特效颜色 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  设置特效颜色: (this: void, effect: any, red: number, green: number, blue: number, alpha?: number) => void;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as (effect: any, degrees: number) => void;
const RAD_TO_DEG = 57.29577951308232;

function 设置黑翼横扫特效表现(this: void, effect: any, facing: number, scale: number, duration: number): void {
  if (effect == null || effect === 0) return;
  EXEffectMatRotateZ(effect, facing);
  EXSetEffectSize(effect, scale);
  YDWETimerDestroyEffectSafe(duration, effect);
}

function 播放黑翼横扫表现(this: void, albedo: any, facing: number, 重击X: number, 重击Y: number): void {
  const cfg = 安兹乌尔恭数值与表现配置;
  const x = GetUnitX(albedo);
  const y = GetUnitY(albedo);
  const pressure = AddSpecialEffect(cfg.表现资源.雅儿贝德黑翼横扫特效路径, x, y);
  const impact = AddSpecialEffect(cfg.表现资源.雅儿贝德重击特效路径, 重击X, 重击Y);
  const visual = cfg.守护者模式;
  设置特效颜色(
    pressure,
    visual.黑翼横扫风压特效红,
    visual.黑翼横扫风压特效绿,
    visual.黑翼横扫风压特效蓝,
  );
  设置黑翼横扫特效表现(pressure, facing, visual.黑翼横扫风压特效缩放, visual.黑翼横扫特效持续秒);
  设置黑翼横扫特效表现(impact, facing, visual.雅儿贝德重击特效缩放, visual.雅儿贝德重击特效持续秒);
}

function 结算黑翼横扫(this: void, context: 安兹运行时上下文, facing: number): void {
  const albedo = context.雅儿贝德?.单位;
  if (!单位有效(albedo) || context.挑战已结束) return;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const x = GetUnitX(albedo);
  const y = GetUnitY(albedo);
  const radians = facing / RAD_TO_DEG;
  const impactX = x + Cos(radians) * cfg.黑翼横扫半径;
  const impactY = y + Sin(radians) * cfg.黑翼横扫半径;
  播放黑翼横扫表现(albedo, facing, impactX, impactY);
  const heroes = 获取Boss技能敌对英雄列表(context.安兹单位);
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!单位有效(target) || !单位是否在扇形区域(target, x, y, cfg.黑翼横扫半径, facing, cfg.黑翼横扫角度)) continue;
    执行BossAOE技能伤害({
      来源: albedo,
      目标: target,
      伤害公式: {
        来源攻击力比例: cfg.黑翼横扫伤害攻击力比例,
        目标最大生命比例: cfg.黑翼横扫伤害目标最大生命比例,
      },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
      标签: '雅儿贝德·黑翼横扫',
    });
    开始击退(target, {
      来源单位: albedo,
      距离: cfg.黑翼横扫击退距离,
      持续时间: cfg.黑翼横扫击退秒,
      检查地形: true,
      暂停单位: true,
      只命中敌人: false,
    });
  }
}

export function 释放雅儿贝德黑翼横扫(this: void, context: 安兹运行时上下文, target: any): boolean {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || !单位有效(target) || context.挑战已结束 || context.当前大型技能 != null) return false;
  if (state.阶段状态 === '失衡' || state.阶段状态 === '已离场') return false;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const facing = Atan2(GetUnitY(target) - GetUnitY(albedo), GetUnitX(target) - GetUnitX(albedo)) * RAD_TO_DEG;
  const token = state.独占状态?.开始({
    key: '雅儿贝德-黑翼横扫',
    优先级: 30,
    持续毫秒: (cfg.黑翼横扫预警秒 + 1) * 1000,
    可被抢占: false,
  }) ?? 0;
  if (token === 0) return false;
  state.守护连接生效 = false;
  立即设置单位朝向(albedo, facing);
  创建技能提示圈({
    类型: '红色扇形',
    X: GetUnitX(albedo),
    Y: GetUnitY(albedo),
    半径: cfg.黑翼横扫半径,
    扇形角度: cfg.黑翼横扫角度,
    朝向: facing,
    持续时间: cfg.黑翼横扫预警秒,
    来源单位: albedo,
  });
  启动基础施法时间线({
    施法者: albedo,
    硬直秒: cfg.黑翼横扫预警秒,
    动画编号: cfg.黑翼横扫动画编号,
    动画速度: cfg.黑翼横扫动画速度,
    恢复动画编号: 1,
    on生效: function 黑翼横扫生效(this: void): void {
      结算黑翼横扫(context, facing);
    },
  });
  state.上次普通技能Ms = getServerTime();
  return true;
}

export const 黑翼横扫技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  包含战斗自身位移: false,
  语义: '以宽扇形黑翼风压将玩家推出安兹附近，方向清楚且不覆盖阶段安全区。',
} as const;
