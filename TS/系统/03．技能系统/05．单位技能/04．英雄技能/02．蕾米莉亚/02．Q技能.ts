/** @noSelfInFile */

import { 蕾米莉亚单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { 创建带上下文原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.07．上下文弹幕") as {
  创建带上下文原生弹幕: (this: void, params: any) => any;
};
const { 造成单体技能伤害, 创建独立技能伤害实例, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  创建独立技能伤害实例: (this: void, params: any) => number;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
};
const { 读取单位攻击力, 读取单位最大生命, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  读取单位最大生命: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, unit: any, attributeName: string, delta: number) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;

const 配置 = 蕾米莉亚单位技能配置 as any;
const Q配置 = 配置.Q as any;
const Q技能ID = stringToFourCCSafe(Q配置.技能ID ?? "0003");
const Q兼容技能ID = stringToFourCCSafe(Q配置.兼容技能ID ?? "A0LG");
const 单位类型ID = 配置.单位类型ID as number;
const 血雾替身单位类型ID = stringToFourCCSafe(配置.E?.替身单位ID ?? "e08O");
const { 获取血雾本体 } = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.04．E技能") as {
  获取血雾本体: (this: void, unit: any) => any;
};

interface Q上下文 {
  施法者: any;
  技能实例ID: number;
  伤害攻击力: number;
  伤害最大生命: number;
  目标?: any;
}

function Q目标允许(this: void, caster: any, target: any): boolean {
  return target != null && target !== 0 && target !== caster && 单位存活(target)
    && IsUnitEnemy(target, GetOwningPlayer(caster))
    && jass.IsUnitType(target, UNIT_TYPE_ANCIENT) !== true
    && jass.IsUnitType(target, UNIT_TYPE_MECHANICAL) !== true
    && jass.IsUnitType(target, UNIT_TYPE_STRUCTURE) !== true;
}

function IsUnitEnemy(this: void, unit: any, player: any): boolean {
  return jass.IsUnitEnemy(unit, player) === true;
}

function Q命中(this: void, event: { 上下文: Q上下文; 命中单位: any; 弹幕ID: number }): void {
  const context = event.上下文;
  const target = event.命中单位;
  if (!Q目标允许(context.施法者, target)) return;

  const targetLife = GetUnitState(target, UNIT_STATE_LIFE) || 0;
  const targetMaxLife = 读取单位最大生命(target);
  const belowHalf = targetMaxLife > 0 && targetLife < targetMaxLife * (Q配置.低血线 ?? 0.5);
  const damage = context.伤害攻击力 * (belowHalf ? (Q配置.低血额外伤害倍率 ?? 1.5) : 1)
    + context.伤害最大生命 * (belowHalf
      ? (Q配置.低血最大生命倍率 ?? Q配置.最大生命倍率 ?? 0.1)
      : (Q配置.最大生命倍率 ?? 0.1));
  if (!(damage > 0)) return;

  开始击退(target, {
    角度: 两点角度(GetUnitX(context.施法者), GetUnitY(context.施法者), GetUnitX(target), GetUnitY(target)),
    主单位: context.施法者,
    距离: Q配置.击退距离 ?? 250,
    持续时间: Q配置.击退持续秒 ?? 0.25,
    检查地形: true,
    禁用碰撞: true,
    暂停单位: false,
  });
  施加眩晕(context.施法者, target, Q配置.眩晕秒 ?? 0.6, "蕾米莉亚-冈格尼尔", "技能");
  // 源 JASS 在伤害结算前临时获得 50% 护甲穿透和 100% 命中率，结算后立即恢复。
  调整玩家属性(context.施法者, "护甲穿透", 0.50);
  调整玩家属性(context.施法者, "命中率", 1.00);
  try {
    造成单体技能伤害({
      来源: context.施法者,
      目标: target,
      伤害: damage,
      伤害类型: DAMAGE_TYPE_NORMAL,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
      来源类型: "单位技能",
      技能ID: Q技能ID,
      技能实例ID: context.技能实例ID,
      标签: "蕾米莉亚-神枪·冈格尼尔之枪",
      参与技能伤害加成: true,
    });
  } finally {
    调整玩家属性(context.施法者, "命中率", -1.00);
    调整玩家属性(context.施法者, "护甲穿透", -0.50);
  }

  // 斩杀线必须在实际伤害结算后判断，避免把伤害前的低血目标改成另一套伤害。
  const lifeAfterDamage = GetUnitState(target, UNIT_STATE_LIFE) || 0;
  if (单位存活(target) && targetMaxLife > 0 && lifeAfterDamage < targetMaxLife * (Q配置.斩杀线 ?? 0.1)) {
    SetUnitState(target, UNIT_STATE_LIFE, 0);
  }
}

function Q弹幕Tick(this: void, instance: any, _delta: number): void {
  instance.蕾米莉亚Q表现累计秒 = (instance.蕾米莉亚Q表现累计秒 ?? 0) + _delta;
  if (instance.蕾米莉亚Q表现累计秒 < 0.04) return;
  instance.蕾米莉亚Q表现累计秒 -= 0.04;
  创建点特效({
    模型路径: Q配置.飞行表现?.模型路径 ?? "war3mapImported\\Shockwave_Fire.mdl",
    X: instance.当前X,
    Y: instance.当前Y,
    缩放: Q配置.飞行表现?.缩放 ?? 0.15,
    持续秒: Q配置.飞行表现?.持续秒 ?? 0.05,
    // Shockwave_Fire 的模型前向轴有 270 度基准偏移。
    Z轴角度: (instance.当前方向角 ?? 0) + 270,
  });
}

function Q弹幕结束(this: void, _reason: string, _id: number): void {
  // 独立伤害实例由施法时长兜底自动回收；命中后仍允许弹幕继续穿透。
}

function 释放蕾米莉亚Q(this: void, _context: any, caster: any, 技能实例ID?: number): void {
  const 真实施法者 = 获取血雾本体(caster) ?? caster;
  const targetUnit = GetSpellTargetUnit();
  const targetX = targetUnit != null && targetUnit !== 0 ? GetUnitX(targetUnit) : GetSpellTargetX();
  const targetY = targetUnit != null && targetUnit !== 0 ? GetUnitY(targetUnit) : GetSpellTargetY();
  const level = GetUnitAbilityLevel(真实施法者, Q技能ID) || GetUnitAbilityLevel(caster, Q技能ID) || 1;
  const skillInstanceId = 技能实例ID ?? 创建独立技能伤害实例({ 技能ID: Q技能ID, 来源类型: "单位技能", 持续时间秒: 1.2 });
  const context: Q上下文 = {
    施法者: 真实施法者,
    技能实例ID: skillInstanceId,
    伤害攻击力: 读取单位攻击力(caster) * ((Q配置.攻击力基础倍率 ?? 1) + (Q配置.攻击力每级倍率 ?? 0.1) * level),
    伤害最大生命: 读取单位最大生命(caster) * (Q配置.最大生命倍率 ?? 0.1),
  };
  Sound3DII_UnitPlayReuse(Q配置.音效?.路径 ?? "HeroVoice\\REmilia\\REmiliaQ.mp3", 真实施法者, Q配置.音效?.裁断距离 ?? 1250);
  const angle = 两点角度(GetUnitX(caster), GetUnitY(caster), targetX, targetY);
  创建带上下文原生弹幕({
    上下文: context,
    命中后清理: false,
    on命中: Q命中,
    on结束: Q弹幕结束,
    弹幕参数: {
      所有者: 真实施法者,
      X: GetUnitX(caster),
      Y: GetUnitY(caster),
      方向角: angle,
    // TS 原生弹幕使用码/秒；源 JASS 的 80 会经过 0.66 / 0.04 换算为 1320。
    速度: Q配置.速度 ?? 1320,
      飞行高度: Q配置.飞行高度 ?? 75,
      生命周期: Q配置.生命周期秒 ?? 0.94,
      最大距离: Q配置.最大距离 ?? 1150,
      命中半径: Q配置.命中半径 ?? 200,
      影响目标: "敌方",
      每单位最大命中次数: 1,
      模型: Q配置.模型路径 ?? "war3mapImported\\remiliasq.mdl",
      缩放: Q配置.缩放 ?? 2.5,
      禁用碰撞: true,
      onTick: Q弹幕Tick,
    },
  });
}

function 获取Q上下文(this: void, unit: any): Q上下文 { return { 施法者: unit, 技能实例ID: 0, 伤害攻击力: 0, 伤害最大生命: 0 }; }

function 注册Q监听(this: void, skillId: number, name: string, unitTypeId: number = 单位类型ID): void {
  注册单位技能壳监听({
    名称: name,
    单位类型ID: unitTypeId,
    技能ID: skillId,
    获取或创建上下文: 获取Q上下文,
    释放技能: 释放蕾米莉亚Q,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 1.2,
  });
}

注册Q监听(Q技能ID, "蕾米莉亚-神枪·冈格尼尔之枪（Q）");
if (Q兼容技能ID !== Q技能ID) 注册Q监听(Q兼容技能ID, "蕾米莉亚-神枪·冈格尼尔之枪（Q兼容壳）");
注册Q监听(Q兼容技能ID, "蕾米莉亚-血雾替身Q", 血雾替身单位类型ID);

export {};
