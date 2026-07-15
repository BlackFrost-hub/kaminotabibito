/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
const { 计算组合技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害") as {
  计算组合技能伤害: (this: void, 来源: any, 目标: any, 参数: any) => number;
};

import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 安兹模型动画配置, 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 创建圆形安全区组, type 圆形安全区组 } from '../../../../00．技能模板+函数/04．机制组件/02．战斗区域/04．圆形安全区组';
import { 启动雅儿贝德天空坠落联动 } from './01．护卫雅儿贝德/05．黑翼拘束';

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const DEG_TO_RAD = 0.017453292519943295;
const 天空坠落大型技能Key = '天空坠落';

interface 天空坠落实例 {
  安全区组: 圆形安全区组;
  法阵特效: any;
  墓碑特效列表: any[];
  表现已清理: boolean;
}

function 销毁天空坠落预警表现(this: void, instance: 天空坠落实例): void {
  if (instance.表现已清理) return;
  instance.表现已清理 = true;
  if (instance.法阵特效 != null && instance.法阵特效 !== 0) {
    DestroyEffect(instance.法阵特效);
    instance.法阵特效 = 0;
  }
  for (let i = 0; i < instance.墓碑特效列表.length; i++) {
    const effect = instance.墓碑特效列表[i];
    if (effect != null && effect !== 0) DestroyEffect(effect);
  }
  instance.墓碑特效列表 = [];
  instance.安全区组.销毁();
}

function 创建天空坠落预警(this: void, context: 安兹运行时上下文, castSeconds: number): 天空坠落实例 {
  const boss = context.安兹单位;
  const cfg = 安兹乌尔恭数值与表现配置;
  const stage = cfg.阶段技能;
  const originX = GetUnitX(boss);
  const originY = GetUnitY(boss);
  const safeZones: Array<{ ID: string; X: number; Y: number; 半径: number; 名称: string }> = [];
  const graves: any[] = [];
  for (let i = 0; i < stage.天空坠落安全区数量; i++) {
    const angle = (30 + i * 120) * DEG_TO_RAD;
    const cos = Cos(angle);
    const sin = Sin(angle);
    const graveX = originX + cos * stage.天空坠落墓碑距离;
    const graveY = originY + sin * stage.天空坠落墓碑距离;
    const safeX = originX + cos * stage.天空坠落安全区中心距离;
    const safeY = originY + sin * stage.天空坠落安全区中心距离;
    const grave = AddSpecialEffect(cfg.表现资源.天空坠落墓碑特效路径, graveX, graveY);
    if (grave != null && grave !== 0) {
      EXSetEffectSize(grave, stage.天空坠落墓碑缩放);
      graves.push(grave);
    }
    safeZones.push({
      ID: '天空坠落墓碑阴影' + String(i + 1),
      X: safeX,
      Y: safeY,
      半径: stage.天空坠落安全区半径,
      名称: '墓碑阴影',
    });
  }
  const safeZoneGroup = 创建圆形安全区组({
    清理: context.清理,
    名称: '安兹·天空坠落安全区',
    安全区列表: safeZones,
    默认显示提示: true,
    提示持续秒: castSeconds,
  });
  const circle = AddSpecialEffect(cfg.表现资源.天空坠落天空法阵特效路径, originX, originY);
  if (circle != null && circle !== 0) {
    EXSetEffectZ(circle, stage.天空坠落法阵高度);
    EXSetEffectSize(circle, stage.天空坠落法阵缩放);
  }
  const instance: 天空坠落实例 = {
    安全区组: safeZoneGroup,
    法阵特效: circle,
    墓碑特效列表: graves,
    表现已清理: false,
  };
  context.清理.登记清理('安兹-天空坠落预警表现', function 天空坠落预警表现清理(this: void): void {
    销毁天空坠落预警表现(instance);
  });
  return instance;
}

function 结算天空坠落伤害(this: void, context: 安兹运行时上下文, instance: 天空坠落实例): void {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.清理.已清理()) return;
  const cfg = 安兹乌尔恭数值与表现配置;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const laser = AddSpecialEffect(cfg.表现资源.天空坠落光柱特效路径, x, y);
  const impact = AddSpecialEffect(cfg.表现资源.天空坠落冲击特效路径, x, y);
  if (laser != null && laser !== 0) YDWETimerDestroyEffectSafe(cfg.阶段技能.天空坠落冲击特效持续秒, laser);
  if (impact != null && impact !== 0) YDWETimerDestroyEffectSafe(cfg.阶段技能.天空坠落冲击特效持续秒, impact);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!单位有效(target) || instance.安全区组.单位是否安全(target)) continue;
    造成AOE技能伤害({
      来源: boss,
      目标: target,
      伤害: 计算组合技能伤害(boss, target, {
        来源攻击力比例: cfg.阶段技能.天空坠落伤害Boss攻击力比例,
        目标最大生命比例: cfg.阶段技能.天空坠落伤害目标最大生命比例,
      }),
      attack: false,
      ranged: true,
      attackType: ATTACK_TYPE_MAGIC,
      伤害类型: DAMAGE_TYPE_MAGIC,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: 'Boss技能',
      标签: '安兹·天空坠落',
    });
  }
  销毁天空坠落预警表现(instance);
}

export function 释放安兹天空坠落(this: void, context: 安兹运行时上下文): boolean {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.天空坠落已释放 || context.当前大型技能 != null) return false;
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  const castSeconds = GetRandomReal(cfg.天空坠落施法最小秒, cfg.天空坠落施法最大秒);
  const recoverySeconds = GetRandomReal(cfg.天空坠落回落最小秒, cfg.天空坠落回落最大秒);
  context.天空坠落已释放 = true;
  context.当前大型技能 = 天空坠落大型技能Key;
  const instance = 创建天空坠落预警(context, castSeconds);
  if (context.模式 === '守护者介入') 启动雅儿贝德天空坠落联动(context, castSeconds);
  启动基础施法时间线({
    施法者: boss,
    硬直秒: castSeconds,
    动画编号: cfg.天空坠落动画编号,
    动画速度: cfg.天空坠落动画速度,
    恢复动画编号: 安兹模型动画配置.待机编号,
    吟唱条: {
      通道: '大招',
      总时长: castSeconds,
      颜色ID: 3,
      标题文本: '超位魔法·天空坠落',
      提示文本: '进入墓碑背后的白色安全区',
    },
    on生效: function 天空坠落生效(this: void): void {
      结算天空坠落伤害(context, instance);
      const recoveryId = addDelayedCallback(recoverySeconds * 1000, function 天空坠落输出窗口结束(this: void): void {
        if (context.当前大型技能 === 天空坠落大型技能Key) {
          context.当前大型技能 = undefined;
          context.上次大型技能结束Ms = getServerTime();
        }
      });
      context.清理.登记延迟回调('安兹-天空坠落输出窗口', recoveryId);
    },
  });
  return true;
}

export const 天空坠落技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  类型: '超位魔法阶段技',
  语义: '高空白金法阵蓄势，玩家进入墓碑阴影规避贯穿场地的致命光柱。',
  实现要求: '破解后必须保留稳定输出窗口，禁止护盾、时间停止和护卫拦截立即覆盖。',
} as const;
