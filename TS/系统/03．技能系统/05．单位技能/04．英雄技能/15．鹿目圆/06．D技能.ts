/** @noSelfInFile */

import { 鹿目圆单位技能配置 } from "./00．配置";
import {
  是鹿目圆,
  是鹿目圆圆神,
  鹿目圆伤害无视魔抗,
  鹿目圆治疗友军,
  激活鹿目圆圆环强化,
  获取鹿目圆圆环强化层数,
  消耗鹿目圆圆环强化,
} from "./01．状态与被动";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 注册普攻攻击效果监听 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.02．攻击效果监听") as {
  注册普攻攻击效果监听: (this: void, params: any) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 魔法增减 } = require("系统.04．伤害系统.02．治疗系统.06．魔法恢复") as {
  魔法增减: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean) => number;
};
const { 移除单位负面Buff } = require("系统.05．Buff系统.05．Buff清除函数") as {
  移除单位负面Buff: (this: void, target: any, onlyPurgable?: boolean) => number;
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { 施加临时属性效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果") as {
  施加临时属性效果: (this: void, unit: any, durationMs: number, items: any[], options?: any) => any;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const {
  创建单位坐标跟随特效,
  销毁单位坐标跟随特效,
} = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, model: string, key?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, key?: string) => void;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const 配置 = 鹿目圆单位技能配置;
const D特效键 = "鹿目圆-圆环之力";
const D特效版本表: Record<number, number | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : GetHandleId(unit);
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 是D合法目标(this: void, target: any): boolean {
  return 单位存活(target)
    && IsUnitType(target, UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(target, UNIT_TYPE_ANCIENT) !== true;
}

function 清理D表现(this: void, variable?: any): void {
  const data = variable as { hero: any; version: number } | undefined;
  if (data == null) return;
  const id = 取单位ID(data.hero);
  if (id === 0 || D特效版本表[id] !== data.version) return;
  delete D特效版本表[id];
  销毁单位坐标跟随特效(data.hero, D特效键);
}

function 播放D表现(this: void, hero: any): void {
  const id = 取单位ID(hero);
  if (id === 0) return;
  const version = (D特效版本表[id] ?? 0) + 1;
  D特效版本表[id] = version;
  销毁单位坐标跟随特效(hero, D特效键);
  const goddess = 是鹿目圆圆神(hero);
  创建单位坐标跟随特效(
    hero,
    goddess ? 配置.D.圆神特效 : 配置.D.普通特效,
    D特效键,
    goddess ? 配置.D.圆神特效缩放 : 配置.D.普通特效缩放,
    配置.D.特效高度,
  );
  addDelayedCallback(配置.D.持续秒 * 1000, 清理D表现, { hero, version });
}

function 获取D入口(this: void, hero: any): { 英雄: any } | undefined {
  return 是鹿目圆(hero) ? { 英雄: hero } : undefined;
}

function 释放D(this: void, _entry: { 英雄: any }, caster: any): void {
  const layers = 激活鹿目圆圆环强化(caster);
  if (layers <= 0) return;
  播放D表现(caster);
}

function D敌方结算(this: void, source: any, target: any, layers: number): void {
  const second = layers >= 2;
  const maxMana = GetUnitStateJapi(target, UNIT_STATE_MAX_MANA);
  const manaRatio = second ? 配置.D.二次敌人最大魔法削减比例 : 配置.D.一次敌人最大魔法削减比例;
  if (maxMana > 0) 魔法增减(target, -maxMana * manaRatio);

  if (second) {
    施加快速控制Buff(source, target, 2, 配置.D.二次沉默秒, "鹿目圆-圆环之力", "技能");
    const targetAttack = 读取单位攻击力(target);
    if (targetAttack > 0) {
      施加临时属性效果(target, 配置.D.二次沉默秒 * 1000, [{
        类型: "攻击",
        数值: -targetAttack * 配置.D.二次减攻击比例,
      }]);
    }
  }

  const sourceAttack = 读取单位攻击力(source);
  const damageRatio = second ? 配置.D.二次攻击力伤害比例 : 配置.D.一次攻击力伤害比例;
  造成单体技能伤害({
    来源: source,
    目标: target,
    伤害: sourceAttack * damageRatio,
    伤害类型: DAMAGE_TYPE_MAGIC,
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "普攻强化",
    技能ID: 配置.技能.D.类型ID,
    标签: "鹿目圆-D-圆环之力",
    参与技能伤害加成: true,
    忽略魔法抗性: 鹿目圆伤害无视魔抗(source),
  });
}

function D友方低生命击退(this: void, source: any, ally: any): void {
  const enemies = getEnemyUnitsInRange(source, GetUnitX(ally), GetUnitY(ally), 配置.D.低生命友军击退范围);
  for (let i = 0; i < enemies.length; i++) {
    const enemy = enemies[i];
    if (!是D合法目标(enemy)) continue;
    开始击退(enemy, {
      来源单位: ally,
      距离: 配置.D.低生命友军击退距离,
      持续时间: 0.5,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      位移特效: "",
    });
  }
}

function D友方结算(this: void, source: any, target: any, layers: number): void {
  const second = layers >= 2;
  const maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  const life = GetUnitState(target, UNIT_STATE_LIFE);
  const lowLife = maxLife > 0 && life / maxLife < 配置.D.低生命判定比例;
  const healRatio = second ? 配置.D.二次友军治疗攻击力比例 : 配置.D.一次友军治疗攻击力比例;
  鹿目圆治疗友军(source, target, 读取单位攻击力(source) * healRatio, 0);
  if (second) {
    移除单位负面Buff(target, false);
    if (lowLife) D友方低生命击退(source, target);
  }
}

function D普攻条件(this: void, ctx: any): boolean {
  return ctx != null
    && ctx.isNormalAttack === true
    && 是鹿目圆(ctx.source)
    && 获取鹿目圆圆环强化层数(ctx.source) > 0
    && 是D合法目标(ctx.target);
}

function D普攻命中(this: void, ctx: any): void {
  const source = ctx.source;
  const target = ctx.target;
  const layers = 消耗鹿目圆圆环强化(source);
  if (layers <= 0) return;
  销毁单位坐标跟随特效(source, D特效键);
  delete D特效版本表[取单位ID(source)];
  const owner = GetOwningPlayer(source);
  if (IsUnitEnemy(target, owner) === true) D敌方结算(source, target, layers);
  else if (IsUnitAlly(target, owner) === true) D友方结算(source, target, layers);
}

function 注册D单位类型(this: void, unitTypeId: number): void {
  注册单位技能壳监听({
    名称: "鹿目圆-圆环之力",
    单位类型ID: unitTypeId,
    技能ID: 配置.技能.D.类型ID,
    获取或创建上下文: 获取D入口,
    释放技能: 释放D,
    创建独立技能实例: false,
  });
}

注册D单位类型(配置.单位.普通类型ID);
注册D单位类型(配置.单位.圆神类型ID);
注册普攻攻击效果监听({
  名称: "鹿目圆-圆环之力普攻",
  允许技能普攻: false,
  条件: D普攻条件,
  命中后: D普攻命中,
});

export {};
