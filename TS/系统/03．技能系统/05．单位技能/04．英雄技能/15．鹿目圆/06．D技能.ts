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
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
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
const { 读取单位攻击力, 取单位ID, 单位存活, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  取单位ID: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const {
  创建点特效,
  销毁点特效,
} = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};

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

/** 播放地图预载全局音效（源 PlaySoundAtPointBJ/OnUnitBJ gg_snd_*） */
function 播放D全局音效(this: void, soundKey: string): void {
  if (soundKey === "") return;
  const sound = jglobals[soundKey];
  if (sound == null || sound === 0) return;
  jass.StartSound(sound);
}

interface D表现状态 {
  英雄: any;
  特效: any;
  周期ID: number;
}

const D表现表: Record<number, D表现状态 | undefined> = {};
const D特效版本表: Record<number, number | undefined> = {};

/** 源 Func011T：特效每 tick 移到 英雄+40 码（facing+90）位置，Z=240 */
function D环绕Tick(this: void, variable?: any): void {
  const state = variable as D表现状态 | undefined;
  if (state == null) return;
  const hero = state.英雄;
  if (!单位存活(hero) || 获取鹿目圆圆环强化层数(hero) <= 0) {
    销毁D表现(hero);
    return;
  }
  if (state.特效 == null || state.特效 === 0) return;
  const 环绕角度 = jass.GetUnitFacing(hero) + 90;
  const x = 极坐标X(GetUnitX(hero), 环绕角度, 配置.D.环绕距离);
  const y = 极坐标Y(GetUnitY(hero), 环绕角度, 配置.D.环绕距离);
  japi.DzSetEffectPos(state.特效, x, y, 配置.D.环绕高度);
}

function 销毁D表现(this: void, hero: any): void {
  if (hero == null || hero === 0) return;
  const id = 取单位ID(hero);
  const state = D表现表[id];
  if (state != null) {
    if (state.周期ID !== 0) removePeriodicCallback(state.周期ID);
    if (state.特效 != null && state.特效 !== 0) 销毁点特效(state.特效);
    delete D表现表[id];
  }
  delete D特效版本表[id];
}

function 播放D表现(this: void, hero: any): void {
  const id = 取单位ID(hero);
  if (id === 0) return;
  销毁D表现(hero);
  const version = (D特效版本表[id] ?? 0) + 1;
  D特效版本表[id] = version;
  const goddess = 是鹿目圆圆神(hero);
  const effect = 创建点特效({
    模型路径: goddess ? 配置.D.圆神特效 : 配置.D.普通特效,
    X: GetUnitX(hero),
    Y: GetUnitY(hero),
    Z: 配置.D.特效高度,
    面向角度: 270,
    缩放: goddess ? 配置.D.圆神特效缩放 : 配置.D.普通特效缩放,
    持续秒: 配置.D.持续秒,
  });
  const state: D表现状态 = { 英雄: hero, 特效: effect, 周期ID: 0 };
  D表现表[id] = state;
  state.周期ID = addPeriodicCallback(配置.D.环绕周期毫秒, D环绕Tick, state);
  addDelayedCallback(配置.D.持续秒 * 1000, 清理D表现, { hero, version });
}

function 清理D表现(this: void, variable?: any): void {
  const data = variable as { hero: any; version: number } | undefined;
  if (data == null) return;
  const id = 取单位ID(data.hero);
  if (id === 0 || D特效版本表[id] !== data.version) return;
  销毁D表现(data.hero);
}

function 是D合法目标(this: void, target: any): boolean {
  return 单位存活(target)
    && IsUnitType(target, UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(target, UNIT_TYPE_ANCIENT) !== true;
}

function 获取D入口(this: void, hero: any): { 英雄: any } | undefined {
  return 是鹿目圆(hero) ? { 英雄: hero } : undefined;
}

function 释放D(this: void, _entry: { 英雄: any }, caster: any): void {
  const layers = 激活鹿目圆圆环强化(caster);
  if (layers <= 0) {
    return;
  }
  // 源 A01X：PlaySoundAtPointBJ(gg_snd_AbsorbMana)
  播放D全局音效(配置.D.施放音效键);
  // 源 A01X 二次分支：第二次使用额外消耗最大魔法 8%（走项目统一魔法增减 API）
  if (layers >= 2) {
    const maxMana = GetUnitStateJapi(caster, UNIT_STATE_MAX_MANA);
    if (maxMana > 0) 魔法增减(caster, -maxMana * 配置.D.二次使用魔法消耗比例);
  }
  播放D表现(caster);
}

function D敌方结算(this: void, source: any, target: any, layers: number): void {
  const second = layers >= 2;
  // 源被动效果2.j：dtpink 命中特效；敌方魔法直接设为 max×0.80/0.70（走统一魔法增减 API）
  createTimedEffect(配置.D.敌方命中特效, GetUnitX(target), GetUnitY(target), 0, 1.5);
  createTimedEffect(second ? 配置.D.二次敌方特效 : 配置.D.一次敌方特效, GetUnitX(target), GetUnitY(target), 0, 2);
  if (second) {
    createTimedEffect(配置.D.二次敌方追加特效, GetUnitX(target), GetUnitY(target), 0, 2);
    施加快速控制Buff(source, target, 2, 配置.D.二次沉默秒, "鹿目圆-圆环之力", "技能");
    const targetAttack = 读取单位攻击力(target);
    if (targetAttack > 0) {
      施加临时属性效果(target, 配置.D.二次沉默秒 * 1000, [{
        类型: "攻击",
        数值: -targetAttack * 配置.D.二次减攻击比例,
      }]);
    }
  }
  const maxMana = GetUnitStateJapi(target, UNIT_STATE_MAX_MANA);
  if (maxMana > 0) {
    const 保留比例 = second ? 配置.D.敌方魔法保留比例二次 : 配置.D.敌方魔法保留比例一次;
    const 目标魔法 = maxMana * 保留比例;
    const 当前魔法 = GetUnitStateJapi(target, jass.UNIT_STATE_MANA);
    const delta = 目标魔法 - 当前魔法;
    if (delta !== 0) 魔法增减(target, delta);
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
  // 源被动效果2.j：dtpink + gg_snd_LightningBolt，击退友军周围 500 码内敌人 500 码
  createTimedEffect(配置.D.击退特效, GetUnitX(ally), GetUnitY(ally), 0, 1);
  播放D全局音效(配置.D.击退音效键);
  const enemies = getEnemyUnitsInRange(source, GetUnitX(ally), GetUnitY(ally), 配置.D.击退范围);
  for (let i = 0; i < enemies.length; i++) {
    const enemy = enemies[i];
    if (!是D合法目标(enemy)) continue;
    开始击退(enemy, {
      来源单位: ally,
      距离: 配置.D.击退距离,
      持续时间: 0.3,
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
  // 源被动效果2.j：二次强化命中友军且 生命 >= max×0.50 → 驱散 + 击退其周围敌人
  const 高生命 = maxLife > 0 && life >= maxLife * 配置.D.击退生命阈值比例;
  const healRatio = second ? 配置.D.二次友军治疗攻击力比例 : 配置.D.一次友军治疗攻击力比例;
  const healAmount = 读取单位攻击力(source) * healRatio;
  鹿目圆治疗友军(source, target, healAmount, 0);
  if (second) {
    移除单位负面Buff(target, false);
    if (高生命) D友方低生命击退(source, target);
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
  if (layers <= 0) {
    return;
  }
  销毁D表现(source);
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
