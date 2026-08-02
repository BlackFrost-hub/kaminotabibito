/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 获取或创建巴尔扎罗斯上下文 } from "./03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯技能数值配置, 巴尔扎罗斯音效配置 } from "./02．数值与表现配置";
import { 播放巴尔扎罗斯台词 } from "./14．台词播放";
import { 施加巴尔扎罗斯灼热 } from "./16．灼热层数工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { stringToFourCC, 单位未标记死亡 as 单位有效, 单位到点距离平方 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建多波延迟AOE } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.03．多波延迟AOE") as {
  创建多波延迟AOE: (this: void, 参数: any) => any;
};
const { 施加单体攻击力提高Buff } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.02．攻击力提高") as {
  施加单体攻击力提高Buff: (this: void, 来源单位: any, 目标单位: any, 参数: any) => boolean;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};

const { 获取Boss护卫列表, 是否指定Boss护卫 } = require("系统.01．单位系统.10．护卫系统.index") as {
  获取Boss护卫列表: (this: void, boss: any, 只返回存活?: boolean) => any[];
  是否指定Boss护卫: (this: void, unit: any, boss: any) => boolean;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;

const 巴尔扎罗斯单位类型ID = stringToFourCC(巴尔扎罗斯单位技能配置.单位ID);
const 王者天罚技能ID = stringToFourCC(巴尔扎罗斯技能数值配置.王者天罚.技能槽位);
let 王者天罚已注册 = false;

interface 天罚波次 {
  X: number;
  Y: number;
  半径: number;
  延迟秒: number;
}

function 治疗单位(this: void, source: any, unit: any, amount: number): void {
  if (!单位有效(unit) || amount <= 0) return;
  doHeal({ HealSource: source, HealTarget: unit, HealAmount: amount, ItemHeal: false, HealEffect: false });
}

function 计算天罚半径(this: void, context: 巴尔扎罗斯运行时上下文): number {
  const config = 巴尔扎罗斯技能数值配置.王者天罚;
  if (context.阶段 >= 2) return config.基础半径 * config.第二阶段半径倍率;
  return config.基础半径;
}

function 播放天罚爆炸特效(this: void, x: number, y: number): void {
  const config = 巴尔扎罗斯技能数值配置.王者天罚;
  创建点特效({
    模型路径: config.爆炸特效路径, X: x, Y: y, Z: config.爆炸特效高度,
    缩放: config.爆炸特效缩放, 持续秒: config.爆炸特效持续秒,
  });
}

function 记录天罚玩家命中(this: void, context: 巴尔扎罗斯运行时上下文, target: any): void {
  const hid = GetHandleId(target) || 0;
  if (hid === 0) return;
  context.王者天罚命中记录[hid] = (context.王者天罚命中记录[hid] ?? 0) + 1;
  if (context.王者天罚命中记录[hid] >= 3) {
    施加巴尔扎罗斯灼热(target, 巴尔扎罗斯技能数值配置.王者天罚.连续三波灼热层数);
    context.王者天罚命中记录[hid] = 0;
  }
}

function 收集天罚命中候选(this: void, context: 巴尔扎罗斯运行时上下文): any[] {
  const result = 获取Boss技能敌对英雄列表(context.Boss单位);
  const guards = 获取Boss护卫列表(context.Boss单位, true);
  for (let i = 0; i < guards.length; i++) result.push(guards[i]);
  if (单位有效(context.Boss单位)) result.push(context.Boss单位);
  return result;
}

function 是护卫(this: void, context: 巴尔扎罗斯运行时上下文, unit: any): boolean {
  return 是否指定Boss护卫(unit, context.Boss单位);
}

function 触发天罚波次(this: void, context: 巴尔扎罗斯运行时上下文, 波次: 天罚波次): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  播放天罚爆炸特效(波次.X, 波次.Y);
  播放Boss坐标音效(巴尔扎罗斯音效配置.王者天罚.落点爆炸, 波次.X, 波次.Y, 巴尔扎罗斯音效配置.默认裁断距离);
  const radius2 = 波次.半径 * 波次.半径;
  const candidates = 收集天罚命中候选(context);
  for (let i = 0; i < candidates.length; i++) {
    const unit = candidates[i];
    if (!单位有效(unit) || 单位到点距离平方(unit, 波次.X, 波次.Y) > radius2) continue;
    if (unit === boss) {
      治疗单位(boss, boss, GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * 巴尔扎罗斯技能数值配置.王者天罚.命中自身治疗最大生命比例);
    } else if (是护卫(context, unit)) {
      施加单体攻击力提高Buff(boss, unit, {
        持续时间: 巴尔扎罗斯技能数值配置.王者天罚.护卫命中增攻持续秒,
        攻击力: 读取单位攻击力(unit) * 巴尔扎罗斯技能数值配置.王者天罚.护卫命中增攻比例,
      });
    } else {
      执行BossAOE技能伤害({
        技能ID: 王者天罚技能ID,
        来源: boss,
        目标: unit,
        伤害公式: {
          来源攻击力比例: 巴尔扎罗斯技能数值配置.王者天罚.伤害Boss攻击力比例,
          目标最大生命比例: 巴尔扎罗斯技能数值配置.王者天罚.伤害目标最大生命比例,
          总倍率: 巴尔扎罗斯技能数值配置.王者天罚.伤害总倍率,
        },
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_FIRE,
        weaponType: WEAPON_TYPE_WHOKNOWS,
      });
      记录天罚玩家命中(context, unit);
    }
  }
}

function 创建天罚波次列表(this: void, context: 巴尔扎罗斯运行时上下文): 天罚波次[] {
  const config = 巴尔扎罗斯技能数值配置.王者天罚;
  const radius = 计算天罚半径(context);
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  const waves: 天罚波次[] = [];
  for (let h = 0; h < heroes.length; h++) {
    const hero = heroes[h];
    if (!单位有效(hero)) continue;
    for (let i = 0; i < config.波次延迟秒.length; i++) {
      waves.push({
        X: GetUnitX(hero),
        Y: GetUnitY(hero),
        半径: radius,
        延迟秒: config.波次延迟秒[i],
      });
    }
  }
  if (context.阶段 >= 3) {
    const 区域列表 = context.战斗区域组.区域列表;
    for (let i = 0; i < config.波次延迟秒.length; i++) {
      for (let j = 0; j < config.第三阶段额外随机落点数; j++) {
        const 区域 = 区域列表.length > 0 ? 区域列表[j % 区域列表.length].配置 : undefined;
        waves.push({
          X: 区域 == null ? GetUnitX(context.Boss单位) : GetRandomReal(区域.左, 区域.右),
          Y: 区域 == null ? GetUnitY(context.Boss单位) : GetRandomReal(区域.下, 区域.上),
          半径: config.额外随机落点半径,
          延迟秒: config.波次延迟秒[i],
        });
      }
    }
  }
  return waves;
}

export function 释放巴尔扎罗斯王者天罚(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.王者天罚;
  const waves = 创建天罚波次列表(context);
  if (waves.length <= 0) return;
  context.王者天罚命中记录 = {};
  创建多波延迟AOE({
    清理: context.清理,
    名称: "巴尔扎罗斯-王者天罚",
    波次列表: waves,
    on触发: function 巴尔扎罗斯王者天罚波次触发(this: void, 波次: 天罚波次): void {
      触发天罚波次(context, 波次);
    },
  });
  启动基础施法时间线({
    施法者: boss,
    硬直秒: config.施法硬直秒,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    吟唱条: {
      通道: "大招",
      总时长: config.施法硬直秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 巴尔扎罗斯王者天罚台词(this: void): void {
      播放巴尔扎罗斯台词(boss, "王者天罚");
    },
    on生效: function 巴尔扎罗斯王者天罚收尾(this: void): void {},
  });
}

export function 注册巴尔扎罗斯王者天罚(this: void): void {
  if (王者天罚已注册) return;
  王者天罚已注册 = true;
  注册单位技能壳监听({
    名称: "巴尔扎罗斯王者天罚",
    单位类型ID: 巴尔扎罗斯单位类型ID,
    技能ID: 王者天罚技能ID,
    获取或创建上下文: 获取或创建巴尔扎罗斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 巴尔扎罗斯运行时上下文, boss: any): void {
      on巴尔扎罗斯王者天罚生效(boss, 王者天罚技能ID);
    },
  });
}

function on巴尔扎罗斯王者天罚生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 王者天罚技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 巴尔扎罗斯单位类型ID) return;
  const context = 获取或创建巴尔扎罗斯上下文(castingUnit);
  if (context == null) return;
  释放巴尔扎罗斯王者天罚(context);
}

export {};
