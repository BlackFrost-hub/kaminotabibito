/** @noSelfInFile */

const { 计算组合技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害") as {
  计算组合技能伤害: (this: void, 来源: any, 目标: any, 参数: any) => number;
};

import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 获取或创建巴尔扎罗斯上下文 } from "./03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯技能数值配置, 巴尔扎罗斯音效配置 } from "./02．数值与表现配置";
import { 播放巴尔扎罗斯台词 } from "./14．台词播放";
import { 施加巴尔扎罗斯灼热 } from "./16．灼热层数工具";
import { 延迟播放Boss坐标音效, 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 开始原地击飞 } from "../../../../00．技能模板+函数/01．技能函数/03．跳跃·击飞/index";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { stringToFourCC, 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;

const 巴尔扎罗斯单位类型ID = stringToFourCC(巴尔扎罗斯单位技能配置.单位ID);
const 熔岩喷发技能ID = stringToFourCC(巴尔扎罗斯技能数值配置.熔岩喷发.技能槽位);
let 熔岩喷发已注册 = false;

interface 熔岩喷发落点 {
  X: number;
  Y: number;
}

function 计算喷发伤害(this: void, boss: any, target: any): number {
  const config = 巴尔扎罗斯技能数值配置.熔岩喷发;
  return 计算组合技能伤害(boss, target, {
    来源攻击力比例: config.爆发伤害Boss攻击力比例,
    目标最大生命比例: config.爆发伤害目标最大生命比例,
    总倍率: config.爆发伤害总倍率,
  });
}

function 创建随机落点(this: void, boss: any, target: any): 熔岩喷发落点 {
  const config = 巴尔扎罗斯技能数值配置.熔岩喷发;
  if (!单位有效(target)) return { X: GetUnitX(boss), Y: GetUnitY(boss) };
  const angle = GetRandomReal(0, 360);
  const distance = GetRandomReal(0, config.选点偏移半径);
  return {
    X: GetUnitX(target) + CosBJ(angle) * distance,
    Y: GetUnitY(target) + SinBJ(angle) * distance,
  };
}

function 播放喷发特效(this: void, x: number, y: number): void {
  const config = 巴尔扎罗斯技能数值配置.熔岩喷发;
  const paths = [config.爆发特效路径, config.爆发叠加特效路径, config.爆发一次性特效路径];
  for (let i = 0; i < paths.length; i++) {
    创建点特效({
      模型路径: paths[i], X: x, Y: y, Z: config.爆发特效高度,
      缩放: config.爆发特效缩放, 持续秒: config.爆发特效持续秒,
    });
  }
}

function 创建熔岩残留区(this: void, context: 巴尔扎罗斯运行时上下文, x: number, y: number): void {
  const config = 巴尔扎罗斯技能数值配置.熔岩喷发;
  const instance = 创建持续危险区域({
    X: x,
    Y: y,
    半径: config.残留半径,
    持续时间: config.残留持续秒,
    检测间隔: config.残留Tick秒,
    影响目标: "敌方",
    所有者: context.Boss单位,
    模型路径: config.残留特效路径,
    特效高度: config.残留特效高度,
    提示圈: { 类型: "敌方圆形" },
    on周期: function 巴尔扎罗斯熔岩残留周期(this: void, units: any[]): void {
      const boss = context.Boss单位;
      if (!单位有效(boss)) return;
      for (let i = 0; i < units.length; i++) {
        const unit = units[i];
        if (!单位有效(unit)) continue;
        const damage = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) * config.残留伤害目标最大生命比例;
        造成AOE技能伤害({
          技能ID: 熔岩喷发技能ID,
          来源: boss,
          目标: unit,
          伤害: damage,
          attack: false,
          ranged: true,
          attackType: ATTACK_TYPE_CHAOS,
          伤害类型: DAMAGE_TYPE_FIRE,
          weaponType: WEAPON_TYPE_WHOKNOWS,
          来源类型: "Boss技能",
        });
        施加巴尔扎罗斯灼热(unit, config.残留灼热层数);
      }
    },
  });
  context.清理.登记清理("巴尔扎罗斯-熔岩喷发残留", function 巴尔扎罗斯熔岩喷发残留清理(this: void): void {
    instance.销毁();
  });
}

function 执行熔岩喷发爆发(this: void, context: 巴尔扎罗斯运行时上下文, 落点: 熔岩喷发落点): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩喷发;
  播放喷发特效(落点.X, 落点.Y);
  播放Boss坐标音效(巴尔扎罗斯音效配置.熔岩喷发.地面开裂, 落点.X, 落点.Y, 巴尔扎罗斯音效配置.默认裁断距离);
  延迟播放Boss坐标音效(巴尔扎罗斯音效配置.熔岩喷发.熔岩上冲, 落点.X, 落点.Y, 巴尔扎罗斯音效配置.熔岩喷发.熔岩上冲延迟Ms, 巴尔扎罗斯音效配置.默认裁断距离);
  延迟播放Boss坐标音效(巴尔扎罗斯音效配置.熔岩喷发.最后爆裂, 落点.X, 落点.Y, 巴尔扎罗斯音效配置.熔岩喷发.最后爆裂延迟Ms, 巴尔扎罗斯音效配置.默认裁断距离);
  const instance = 创建持续危险区域({
    X: 落点.X,
    Y: 落点.Y,
    半径: config.爆发半径,
    持续时间: config.爆发持续顶飞秒,
    检测间隔: 0.12,
    影响目标: "敌方",
    所有者: boss,
    显示提示圈: false,
    on进入: function 巴尔扎罗斯熔岩喷发爆发命中(this: void, unit: any): void {
      if (!单位有效(unit)) return;
      造成AOE技能伤害({
        技能ID: 熔岩喷发技能ID,
        来源: boss,
        目标: unit,
        伤害: 计算喷发伤害(boss, unit),
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_CHAOS,
        伤害类型: DAMAGE_TYPE_FIRE,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "Boss技能",
      });
      施加巴尔扎罗斯灼热(unit, config.爆发灼热层数);
      开始原地击飞(unit, {
        持续时间: config.爆发持续顶飞秒,
        最小高度: 180,
        最大高度: 260,
        暂停单位: false,
        主单位: boss,
        主单位死亡时中断: true,
        中断已有跳跃: true,
        冲击波模型: "",
      });
    },
    on销毁: function 巴尔扎罗斯熔岩喷发爆发结束(this: void): void {
      if (context.清理.已清理()) return;
      创建熔岩残留区(context, 落点.X, 落点.Y);
    },
  });
  context.清理.登记清理("巴尔扎罗斯-熔岩喷发爆发", function 巴尔扎罗斯熔岩喷发爆发清理(this: void): void {
    instance.销毁();
  });
}

export function 释放巴尔扎罗斯熔岩喷发(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩喷发;
  const target = 获取Boss技能随机敌对英雄(boss);
  const 落点 = 创建随机落点(boss, target);
  创建技能提示圈({
    类型: "渐变圆形",
    X: 落点.X,
    Y: 落点.Y,
    半径: config.爆发半径,
    持续时间: config.爆发延迟秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    施法者: boss,
    目标X: 落点.X,
    目标Y: 落点.Y,
    硬直秒: config.爆发延迟秒,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: config.爆发延迟秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 巴尔扎罗斯熔岩喷发台词(this: void): void {
      播放巴尔扎罗斯台词(boss, "熔岩喷发");
    },
    on生效: function 巴尔扎罗斯熔岩喷发生效(this: void): void {
      执行熔岩喷发爆发(context, 落点);
    },
  });
}

export function 注册巴尔扎罗斯熔岩喷发(this: void): void {
  if (熔岩喷发已注册) return;
  熔岩喷发已注册 = true;
  注册单位技能壳监听({
    名称: "巴尔扎罗斯熔岩喷发",
    单位类型ID: 巴尔扎罗斯单位类型ID,
    技能ID: 熔岩喷发技能ID,
    获取或创建上下文: 获取或创建巴尔扎罗斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 巴尔扎罗斯运行时上下文, boss: any): void {
      on巴尔扎罗斯熔岩喷发生效(boss, 熔岩喷发技能ID);
    },
  });
}

function on巴尔扎罗斯熔岩喷发生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 熔岩喷发技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 巴尔扎罗斯单位类型ID) return;
  const context = 获取或创建巴尔扎罗斯上下文(castingUnit);
  if (context == null) return;
  释放巴尔扎罗斯熔岩喷发(context);
}

export {};
