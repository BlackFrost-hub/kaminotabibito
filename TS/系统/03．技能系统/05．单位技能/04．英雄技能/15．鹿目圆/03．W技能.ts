/** @noSelfInFile */

import { 鹿目圆单位技能配置 } from "./00．配置";
import {
  是鹿目圆,
  是鹿目圆圆神,
  鹿目圆伤害无视魔抗,
  鹿目圆治疗友军,
  消耗鹿目圆W立即满蓄标记,
  消耗鹿目圆圆环强化,
} from "./01．状态与被动";
import { 鹿目圆BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/10．鹿目圆";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 开始充能, 停止充能 } from "../../../00．技能模板+函数/01．技能函数/06．施法·蓄力·充能/充能系统";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { StopSoundBJ, PlaySoundAtPointBJ, PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  StopSoundBJ: (this: void, soundHandle: any, fadeOut: boolean) => void;
  PlaySoundAtPointBJ: (this: void, soundHandle: any, volumePercent: number, x: number, y: number, z: number) => void;
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, unit: any) => void;
};

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 造成单体技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 两点角度, 取单位ID, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  取单位ID: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitMoveSpeed = jass.GetUnitMoveSpeed as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const SetUnitMoveSpeed = jass.SetUnitMoveSpeed as (this: void, unit: any, speed: number) => void;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const bj_DEGTORAD = (jass.bj_DEGTORAD ?? 0.017453292519943295) as number;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 配置 = 鹿目圆单位技能配置;

function 获取W全局音效(this: void, soundKey: string): any {
  if (soundKey === "") return;
  const sound = jglobals[soundKey];
  if (sound == null || sound === 0) return;
  return sound;
}

/** 源 A01S：StopSoundBJ 后在施法者位置播放发射音效。 */
function 播放W发射音效(this: void, soundKey: string, x: number, y: number): void {
  const sound = 获取W全局音效(soundKey);
  if (sound == null) return;
  StopSoundBJ(sound, false);
  PlaySoundAtPointBJ(sound, 100, x, y, 0);
}

/** 源 Func019A：每个敌人命中时用 PlaySoundOnUnitBJ 播放命中音效。 */
function 播放W命中音效(this: void, soundKey: string, target: any): void {
  const sound = 获取W全局音效(soundKey);
  if (sound == null) return;
  PlaySoundOnUnitBJ(sound, 100, target);
}

type W阶段 = "蓄力" | "待发" | "发射中" | "结束";

interface W蓄力上下文 {
  施法者: any;
  阶段: W阶段;
  充能ID: number;
  原移动速度: number;
  蓄力箭: any;
  已蓄力秒: number;
  立即满蓄: boolean;
  待发版本: number;
  /** 待发期系数（源 WSHSJ：2.0 起每 0.05s +0.1，上限 5.0） */
  系数: number;
  成长周期ID: number;
  成长Tick: number;
  表现已移除: boolean;
}

interface W弹道上下文 {
  施法者: any;
  技能实例ID: number;
  箭单位: any;
  方向: number;
  剩余Tick: number;
  伤害: number;
  治疗: number;
  忽略魔抗: boolean;
  已命中: Record<number, true | undefined>;
  周期ID: number;
}

const W蓄力上下文表: Record<number, W蓄力上下文 | undefined> = {};
let W待发版本 = 0;

function 移除单位壳(this: void, unit: any): void {
  if (unit != null && unit !== 0) 立即移除单位并取消排泄登记(unit);
}

function 切换W技能(this: void, hero: any, 可发射: boolean): void {
  if (hero == null || hero === 0) return;
  const owner = GetOwningPlayer(hero);
  SetPlayerAbilityAvailable(owner, 配置.技能.W蓄力.类型ID, !可发射);
  SetPlayerAbilityAvailable(owner, 配置.技能.W发射.类型ID, 可发射);
}

function 清理W蓄力上下文(this: void, context: W蓄力上下文): void {
  if (context.阶段 === "结束") return;
  context.阶段 = "结束";
  const chargeId = context.充能ID;
  context.充能ID = 0;
  if (chargeId !== 0) 停止充能(chargeId);
  const growId = context.成长周期ID;
  context.成长周期ID = 0;
  if (growId !== 0) removePeriodicCallback(growId);
  移除单位壳(context.蓄力箭);
  context.蓄力箭 = null;
  移除单位指定Buff(context.施法者, 鹿目圆BuffID.因果之矢蓄力);
  移除单位指定Buff(context.施法者, 鹿目圆BuffID.因果之矢待发);
  if (context.施法者 != null && context.施法者 !== 0) {
    SetUnitMoveSpeed(context.施法者, context.原移动速度);
    切换W技能(context.施法者, false);
  }
  const id = 取单位ID(context.施法者);
  if (id !== 0 && W蓄力上下文表[id] === context) delete W蓄力上下文表[id];
}

function W待发到期(this: void, variable?: any): void {
  const data = variable as { context: W蓄力上下文; version: number } | undefined;
  if (data == null) return;
  const context = data.context;
  if (context.阶段 !== "待发" || context.待发版本 !== data.version) return;
  清理W蓄力上下文(context);
}

/** 源 Func007T 循环实数2>=30 分支：移除进度条/蓄力箭、恢复移速；系数已在成长终点锁定为最高 */
function W待发表现移除(this: void, variable?: any): void {
  const data = variable as { context: W蓄力上下文; version: number } | undefined;
  if (data == null) return;
  const context = data.context;
  if (context.阶段 !== "待发" || context.待发版本 !== data.version || context.表现已移除) return;
  context.表现已移除 = true;
  const growId = context.成长周期ID;
  context.成长周期ID = 0;
  if (growId !== 0) removePeriodicCallback(growId);
  context.系数 = 配置.W.系数最高;
  移除单位壳(context.蓄力箭);
  context.蓄力箭 = null;
  if (context.施法者 != null && context.施法者 !== 0) {
    SetUnitMoveSpeed(context.施法者, context.原移动速度);
  }
}

/** 源 Func007T 待发循环：每 0.05s WSHSJ = 2.0 + 0.1×n，上限 5.0 */
function W待发成长Tick(this: void, variable?: any): void {
  const context = variable as W蓄力上下文 | undefined;
  if (context == null || context.阶段 !== "待发" || context.表现已移除) return;
  context.成长Tick += 1;
  const next = 配置.W.系数最低 + 配置.W.系数成长每秒 * (context.成长Tick * 0.05);
  context.系数 = next >= 配置.W.系数最高 ? 配置.W.系数最高 : next;
  if (context.系数 >= 配置.W.系数最高 && context.成长周期ID !== 0) {
    removePeriodicCallback(context.成长周期ID);
    context.成长周期ID = 0;
  }
  // 源 Func007T：蓄力箭每 tick 跟随小圆；施法进度条由充能封装驱动。
  刷新W蓄力表现(context);
}

function 刷新W蓄力表现(this: void, context: W蓄力上下文): void {
  if (!单位存活(context.施法者)) return;
  if (!单位存活(context.蓄力箭)) return;
  const full = 配置.W.蓄力秒;
  const progress = context.已蓄力秒 >= full ? 1 : context.已蓄力秒 / full;
  // 源 Func002T：蓄力期缩放 1.00+0.04×循环实数（满蓄 2.0）；待发期固定 2.75
  const scale = context.阶段 === "待发"
    ? 配置.W.蓄力箭待发缩放
    : 配置.W.蓄力箭基础缩放
      + (配置.W.蓄力箭满蓄力缩放 - 配置.W.蓄力箭基础缩放) * progress;
  SetUnitX(context.蓄力箭, GetUnitX(context.施法者));
  SetUnitY(context.蓄力箭, GetUnitY(context.施法者));
  SetUnitFacing(context.蓄力箭, GetUnitFacing(context.施法者));
  SetUnitFlyHeight(context.蓄力箭, 是鹿目圆圆神(context.施法者) ? 配置.W.圆神蓄力箭高度 : 配置.W.蓄力箭高度, 0);
  SetUnitScale(context.蓄力箭, scale, scale, scale);
}

function W充能周期(this: void, unit: any, chargeId: number, elapsed: number): void {
  const context = W蓄力上下文表[取单位ID(unit)];
  if (context == null || context.充能ID !== chargeId || context.阶段 !== "蓄力") return;
  context.已蓄力秒 = context.立即满蓄 ? 配置.W.蓄力秒 : elapsed;
  刷新W蓄力表现(context);
}

function W充能完成(this: void, unit: any, chargeId: number): void {
  const context = W蓄力上下文表[取单位ID(unit)];
  if (context == null || context.充能ID !== chargeId || context.阶段 !== "蓄力") return;
  context.充能ID = 0;
  context.已蓄力秒 = 配置.W.蓄力秒;
  context.阶段 = "待发";
  context.系数 = 配置.W.系数最低;
  context.待发版本 = ++W待发版本;
  刷新W蓄力表现(context);
  移除单位指定Buff(unit, 鹿目圆BuffID.因果之矢蓄力);
  // A01S 可用窗口 4.5s（源 4.50s 切回计时）
  registerManualBuff(unit, 鹿目圆BuffID.因果之矢待发, 配置.W.待发窗口秒, 1, {
    sourceUnit: unit,
    effectSourceName: "因果之矢",
    effectSourceType: "技能",
  });
  切换W技能(unit, true);
  // 系数成长循环（源 0.05s×30：2.0→5.0）
  context.成长周期ID = addPeriodicCallback(50, W待发成长Tick, context);
  // 1.5s 后移除蓄力箭并恢复移速（源循环实数2>=30 分支）
  addDelayedCallback(配置.W.待发表现移除秒 * 1000, W待发表现移除, { context, version: context.待发版本 });
  addDelayedCallback(配置.W.待发窗口秒 * 1000, W待发到期, { context, version: context.待发版本 });
}

function W充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const context = W蓄力上下文表[取单位ID(unit)];
  if (context == null || context.充能ID !== chargeId) return;
  context.充能ID = 0;
  if (reason === "完成" || context.阶段 === "发射中" || context.阶段 === "结束") return;
  清理W蓄力上下文(context);
}

function 获取W蓄力入口(this: void, hero: any): { 英雄: any } | undefined {
  return 是鹿目圆(hero) ? { 英雄: hero } : undefined;
}

function 释放W蓄力(this: void, _entry: { 英雄: any }, caster: any): void {
  if (!单位存活(caster) || !是鹿目圆(caster)) return;
  const id = 取单位ID(caster);
  const old = W蓄力上下文表[id];
  if (old != null) 清理W蓄力上下文(old);

  const arrow = 创建单位并登记排泄安全(
    GetOwningPlayer(caster),
    配置.单位壳.W蓄力箭,
    GetUnitX(caster),
    GetUnitY(caster),
    GetUnitFacing(caster),
  );
  if (arrow == null || arrow === 0) {
    return;
  }

  const immediate = 消耗鹿目圆W立即满蓄标记(caster);
  const context: W蓄力上下文 = {
    施法者: caster,
    阶段: "蓄力",
    充能ID: 0,
    原移动速度: GetUnitMoveSpeed(caster),
    蓄力箭: arrow,
    已蓄力秒: immediate ? 配置.W.蓄力秒 : 0,
    立即满蓄: immediate,
    待发版本: 0,
    系数: 配置.W.系数最低,
    成长周期ID: 0,
    成长Tick: 0,
    表现已移除: false,
  };
  W蓄力上下文表[id] = context;
  SetUnitMoveSpeed(caster, 配置.W.蓄力移动速度);
  切换W技能(caster, immediate);
  刷新W蓄力表现(context);
  registerManualBuff(caster, 鹿目圆BuffID.因果之矢蓄力, immediate ? 0.1 : 配置.W.蓄力秒, 1, {
    sourceUnit: caster,
    effectSourceName: "因果之矢",
    effectSourceType: "技能",
  });
  for (let i = 0; i < 配置.W.起手特效.length; i++) {
    createTimedUnitEffect(caster, "origin", 配置.W.起手特效[i], 1);
  }

  context.充能ID = 开始充能(caster, {
    持续时间: immediate ? 0.02 : 配置.W.蓄力秒,
    强制硬直: false,
    指令中断: false,
    周期回调间隔: 配置.W.周期间隔毫秒 / 1000,
    周期回调: W充能周期,
    充能完成回调: W充能完成,
    结束回调: W充能结束,
  });
  if (context.充能ID === 0) 清理W蓄力上下文(context);
}

function 是W合法碰撞单位(this: void, unit: any): boolean {
  return 单位存活(unit)
    && IsUnitType(unit, UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(unit, UNIT_TYPE_ANCIENT) !== true;
}

/** 序列化已命中表（unitId 逗号分隔），游戏 Lua 环境无全局 JSON */
function 序列化W命中记录(this: void, record: Record<number, true | undefined>): string {
  const parts: string[] = [];
  for (const key in record) {
    if (record[key] === true) parts.push(key);
  }
  return parts.join(",");
}

function 结束W弹道(this: void, context: W弹道上下文): void {
  if (context.周期ID !== 0) {
    removePeriodicCallback(context.周期ID);
    context.周期ID = 0;
  }
  移除单位壳(context.箭单位);
  结束独立技能伤害实例(context.技能实例ID);
}

function 推进W弹道(this: void, variable?: any): void {
  const context = variable as W弹道上下文 | undefined;
  if (context == null) return;
  if (!单位存活(context.箭单位) || context.剩余Tick <= 0) {
    结束W弹道(context);
    return;
  }

  const radians = context.方向 * bj_DEGTORAD;
  const x = GetUnitX(context.箭单位) + Cos(radians) * 配置.W.弹道步长;
  const y = GetUnitY(context.箭单位) + Sin(radians) * 配置.W.弹道步长;
  SetUnitX(context.箭单位, x);
  SetUnitY(context.箭单位, y);
  context.剩余Tick -= 1;

  const owner = GetOwningPlayer(context.施法者);
  const targets = getUnitsInRange(x, y, 配置.W.碰撞半径);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (target === context.施法者 || !是W合法碰撞单位(target)) continue;
    const targetId = 取单位ID(target);
    if (context.已命中[targetId] === true) continue;
    if (IsUnitEnemy(target, owner) === true) {
      context.已命中[targetId] = true;
      // 源 Func011A：每个敌人命中时 PlaySoundOnUnitBJ(gg_snd_TheBlackArrow)
      播放W命中音效(配置.W.命中音效键, target);
      造成单体技能伤害({
        来源: context.施法者,
        目标: target,
        伤害: context.伤害,
        伤害类型: DAMAGE_TYPE_MAGIC,
        attack: true,
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: 配置.技能.W发射.类型ID,
        技能实例ID: context.技能实例ID,
        标签: "鹿目圆-W-因果之矢",
        参与技能伤害加成: true,
        忽略魔法抗性: context.忽略魔抗,
      });
    } else if (IsUnitAlly(target, owner) === true) {
      context.已命中[targetId] = true;
      鹿目圆治疗友军(context.施法者, target, context.治疗, 0);
    }
  }

  if (context.剩余Tick <= 0) 结束W弹道(context);
}

function 获取W发射入口(this: void, hero: any): { 英雄: any } | undefined {
  return 是鹿目圆(hero) ? { 英雄: hero } : undefined;
}

function 释放W发射(this: void, _entry: { 英雄: any }, caster: any, 技能实例ID?: number): void {
  const context = W蓄力上下文表[取单位ID(caster)];
  // 源：A01S 仅在蓄满后的待发窗口内可用；窗口外/已结束直接失败
  if (context == null || 技能实例ID == null || context.阶段 !== "待发") {
    结束独立技能伤害实例(技能实例ID);
    return;
  }

  const targetX = GetSpellTargetX();
  const targetY = GetSpellTargetY();
  const startX = GetUnitX(caster);
  const startY = GetUnitY(caster);
  const direction = 两点角度(startX, startY, targetX, targetY);
  // 源：系数 = WSHSJ（蓄满后待发窗口内 2.0→5.0），发射瞬间读取
  const 系数 = context.系数;
  // 源 A01S：圆环之力hit==2 → ×1.20 并清零；==1 → ×1.10 并清零
  const dLayers = 消耗鹿目圆圆环强化(caster);
  const dMultiplier = 1 + dLayers * 配置.W.D伤害额外比例;
  const attack = 读取单位攻击力(caster);
  const 伤害 = attack * 系数 * dMultiplier;
  // 源 Func013A：治疗 = 数据×0.60（数据含 D 倍率）
  const 治疗 = 伤害 * 配置.W.治疗占伤害比例;
  // 源 Func019T：弹道最长 20+系数×6 tick
  const projectileTicks = 配置.W.弹道基础Tick + jass.R2I(配置.W.每系数弹道Tick * 系数 + 0.5);

  context.阶段 = "发射中";
  const chargeId = context.充能ID;
  context.充能ID = 0;
  if (chargeId !== 0) 停止充能(chargeId);
  const growId = context.成长周期ID;
  context.成长周期ID = 0;
  if (growId !== 0) removePeriodicCallback(growId);
  移除单位壳(context.蓄力箭);
  context.蓄力箭 = null;
  移除单位指定Buff(caster, 鹿目圆BuffID.因果之矢蓄力);
  移除单位指定Buff(caster, 鹿目圆BuffID.因果之矢待发);
  SetUnitMoveSpeed(caster, context.原移动速度);
  切换W技能(caster, false);
  delete W蓄力上下文表[取单位ID(caster)];
  context.阶段 = "结束";

  // 源 A01S：发射音效 gg_snd_FrostArrowLaunch1
  播放W发射音效(配置.W.发射音效键, startX, startY);
  const arrow = 创建单位并登记排泄安全(GetOwningPlayer(caster), 配置.单位壳.W发射箭, startX, startY, direction);
  if (arrow == null || arrow === 0) {
    结束独立技能伤害实例(技能实例ID);
    return;
  }
  // 源：尺寸 = 1.00 + 系数×0.25；射击箭 e01I 默认 moveHeight 125，源未改射击箭高度
  const scale = 配置.W.发射箭基础缩放 + 配置.W.发射箭每系数缩放 * 系数;
  SetUnitFacing(arrow, direction);
  SetUnitScale(arrow, scale, scale, scale);

  const projectile: W弹道上下文 = {
    施法者: caster,
    技能实例ID,
    箭单位: arrow,
    方向: direction,
    剩余Tick: projectileTicks,
    伤害,
    治疗,
    忽略魔抗: 鹿目圆伤害无视魔抗(caster),
    已命中: {},
    周期ID: 0,
  };
  projectile.周期ID = addPeriodicCallback(配置.W.弹道间隔毫秒, 推进W弹道, projectile);
}

function 注册W单位类型(this: void, unitTypeId: number): void {
  注册单位技能壳监听({
    名称: "鹿目圆-因果之矢蓄力",
    单位类型ID: unitTypeId,
    技能ID: 配置.技能.W蓄力.类型ID,
    获取或创建上下文: 获取W蓄力入口,
    释放技能: 释放W蓄力,
    创建独立技能实例: false,
  });
  注册单位技能壳监听({
    名称: "鹿目圆-因果之矢发射",
    单位类型ID: unitTypeId,
    技能ID: 配置.技能.W发射.类型ID,
    获取或创建上下文: 获取W发射入口,
    释放技能: 释放W发射,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 3,
  });
}

注册W单位类型(配置.单位.普通类型ID);
注册W单位类型(配置.单位.圆神类型ID);

export {};
