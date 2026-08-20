/** @noSelfInFile */
// 云端 E：无双剑法（A0KP，被动）。普攻命中后按目标生命百分比三分支给予 4 秒属性增益，8 秒触发冷却。
// 源 JASS 真源：云端E被动.j（入口 81-173；暴击回收 Func009T 62-79；攻击回收 Func013T 44-60；护甲回收 Func006T 26-42）。
// 冲突口径（计划 7.1/7.2）：低生命分支源误用 GetHeroInt，按介绍改读当前敏捷；
// 边界按源 GUI/JASS“或等于”：≥95% 走洞察、≤50% 走破势，其余走御势；
// 源为“命中后追加 4 秒属性”而非“下次攻击前强化”，TS 保留源结算时序并如实记录。
// 2026-08-17：修复“被动没效果”（派发层 damageType 恒 0 导致普攻全被拦，改以 isNormalAttack 为门）；
// 补齐三分支漂浮字（无双一击/趁胜追击/无所畏惧，源 CreateTextTagUnitBJ）。

import { 云端技能配置 } from "./00．配置";
import { 云端E是否冷却中, 设置云端E冷却, 获取云端状态 } from "./01．状态表";
import { 云端BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/18．云端";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (
    this: void,
    cb: (
      this: void,
      unit: any,
      damage: number,
      damageType: number,
      fromDotTickBatch?: boolean,
      source?: any,
      isNormalAttack?: boolean,
    ) => void,
  ) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 临时调整攻击, 临时调整护甲 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
  临时调整护甲: (this: void, unit: any, value: number) => void;
};
const { 读取单位敏捷 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位敏捷: (this: void, unit: any) => number;
};
const { 秒转毫秒, 向下取整整数 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算") as {
  秒转毫秒: (this: void, seconds: number) => number;
  向下取整整数: (this: void, value: number) => number;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
// 源 PlaySoundOnUnitBJ(gg_snd_effect_sound18, 100, 来源)：照源用 jglobals 全局音效句柄 + BJ 封装播放
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
};
const { CreateFloatTextOnUnit } = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: any) => any;
};
// E 为被动，8 秒触发冷却是内部标记（引擎不感知），登记到 QWERD 冷却显示（仅本地表现）
const { 登记被动技能冷却 } = require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示") as {
  登记被动技能冷却: (this: void, unit: any, abilityId: number, cooldownSec: number) => void;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, p: any) => boolean;
const IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer as (this: void, unit: any, p: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

const 配置 = 云端技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const E类型ID = stringToFourCCSafe(配置.E.技能ID);

interface E增益上下文 {
  施法者: any;
  分支: "洞察" | "破势" | "御势";
  增量: number;
  已回收: boolean;
}

function 结束E触发冷却(this: void, variable: any): void {
  const caster = variable as any;
  if (caster == null || caster === 0) return;
  设置云端E冷却(caster, false);
  登记被动技能冷却(caster, E类型ID, 0); // 清除冷却显示登记（时间戳到期也会自动回落）
  const record = 获取云端状态(caster);
  if (record != null) record.E冷却回调ID = 0;
}

function 回收E增益(this: void, variable: any): void {
  const ctx = variable as E增益上下文;
  if (ctx == null || ctx.已回收 === true) return;
  ctx.已回收 = true;
  const caster = ctx.施法者;
  if (caster == null || caster === 0) return;
  // 只撤销本次实例的增量（计划 7.3.3）：暴击走 player 属性增量对，攻击/护甲走临时调整增量对
  if (ctx.分支 === "洞察") {
    const player = GetOwningPlayer(caster);
    const 当前暴击率 = Number(YDUserDataGetSafe("player", player, "暴击率", "real")) || 0;
    const 当前暴击伤害 = Number(YDUserDataGetSafe("player", player, "暴击伤害", "real")) || 0;
    YDUserDataSetSafe("player", player, "暴击率", "real", 当前暴击率 - ctx.增量);
    YDUserDataSetSafe("player", player, "暴击伤害", "real", 当前暴击伤害 - ctx.增量);
  } else if (ctx.分支 === "破势") {
    临时调整攻击(caster, -ctx.增量);
  } else {
    临时调整护甲(caster, -ctx.增量);
  }
}

function 处理无双剑法触发(this: void, unit: any, _damage: number, damageType: number, _fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean): void {
  // 过滤顺序优化（2026-08-17）：来源身份检查前置——全图任意伤害事件都会路过本监听，
  // 99% 与云端无关的事件在第一个门无声拦下；忽略类日志降级 debugLog（受开关控制），避免刷屏
  if (source == null || source === 0) {
    return;
  }
  if (GetUnitTypeId(source) !== 英雄单位类型ID) {
    return; // 非云端英雄的伤害，与 E 无关（源：仅特定英雄列表）
  }
  if (isNormalAttack !== true) {
    return;
  }
  // 2026-08-17 修复“E被动没效果”：伤害事件回调的 damageType 被派发层硬编码为 0，
  // 原判断 damageType !== DAMAGE_TYPE_NORMAL 必然拦下所有普攻；源条件实为 OR 关系
  // （伤害>0.01 或 类型=NORMAL），普攻标记已覆盖语义，不再单独判 damageType
  if (GetUnitAbilityLevel(source, E类型ID) < 1) {
    return;
  }
  // 源：目标是施法者的敌人且非其拥有单位
  const attackerPlayer = GetOwningPlayer(source);
  if (IsUnitAlly(unit, attackerPlayer) || IsUnitOwnedByPlayer(unit, attackerPlayer)) {
    return;
  }
  if (云端E是否冷却中(source)) {
    return;
  }

  // 8 秒触发冷却（单位级标记，多实例互不影响，计划 7.3.4）；同步登记到 QWERD 冷却 UI 显示
  设置云端E冷却(source, true);
  登记被动技能冷却(source, E类型ID, 配置.E.触发冷却秒);
  const record = 获取云端状态(source);
  if (record != null) {
    if (record.E冷却回调ID !== 0) removeDelayedCallback(record.E冷却回调ID);
    record.E冷却回调ID = addDelayedCallback(
      秒转毫秒(配置.E.触发冷却秒),
      结束E触发冷却 as unknown as (this: void, variable?: any) => void,
      source,
    );
  }

  const e音效句柄 = (jglobals as any)[配置.E.音效.全局音效键];
  if (e音效句柄 != null) PlaySoundOnUnitBJ(e音效句柄, 100, source);

  const 等级 = GetUnitAbilityLevel(source, E类型ID);
  const 最大生命 = GetUnitState(unit, UNIT_STATE_MAX_LIFE);
  const 生命百分比 = 最大生命 > 0 ? (GetUnitState(unit, UNIT_STATE_LIFE) / 最大生命) * 100 : 0;

  let ctx: E增益上下文;
  if (生命百分比 >= 配置.E.高生命阈值) {
    // 洞察：暴击率/暴击伤害各 +2%×级（源挂 player 属性，伤害系统支持玩家属性回退读取）
    // 源漂浮字（TRIGSTR_958）在受击单位头顶，红色
    CreateFloatTextOnUnit(unit, 配置.E.洞察.漂浮字, {
      size: 配置.E.漂浮字.尺寸,
      red: 255,
      green: 0,
      blue: 0,
      alpha: 配置.E.漂浮字.透明度,
      duration: 配置.E.漂浮字.持续秒,
      speedY: 配置.E.漂浮字.上浮速度,
      height: 40,
    });
    const 提升 = 配置.E.洞察.每级暴击提升 * 等级;
    const player = GetOwningPlayer(source);
    const 当前暴击率 = Number(YDUserDataGetSafe("player", player, "暴击率", "real")) || 0;
    const 当前暴击伤害 = Number(YDUserDataGetSafe("player", player, "暴击伤害", "real")) || 0;
    YDUserDataSetSafe("player", player, "暴击率", "real", 当前暴击率 + 提升);
    YDUserDataSetSafe("player", player, "暴击伤害", "real", 当前暴击伤害 + 提升);
    registerManualBuff(source, 云端BuffID.无双洞察, 配置.E.增益持续秒, 提升);
    ctx = { 施法者: source, 分支: "洞察", 增量: 提升, 已回收: false };
  } else if (生命百分比 <= 配置.E.低生命阈值) {
    // 破势：攻击力 + 当前敏捷×(0.4×级)（源误用智力，按介绍修正，计划 7.2）
    // 源漂浮字（TRIGSTR_957）在施法者头顶，红色
    CreateFloatTextOnUnit(source, 配置.E.破势.漂浮字, {
      size: 配置.E.漂浮字.尺寸,
      red: 255,
      green: 0,
      blue: 0,
      alpha: 配置.E.漂浮字.透明度,
      duration: 配置.E.漂浮字.持续秒,
      speedY: 配置.E.漂浮字.上浮速度,
      height: 40,
    });
    const 增量 = 向下取整整数(读取单位敏捷(source) * (配置.E.破势.每级敏捷系数 * 等级));
    临时调整攻击(source, 增量);
    registerManualBuff(source, 云端BuffID.无双破势, 配置.E.增益持续秒, 增量);
    ctx = { 施法者: source, 分支: "破势", 增量, 已回收: false };
  } else {
    // 御势：护甲 + 3×级
    // 源漂浮字（TRIGSTR_956）在施法者头顶，蓝色，高度 20
    CreateFloatTextOnUnit(source, 配置.E.御势.漂浮字, {
      size: 配置.E.漂浮字.尺寸,
      red: 0,
      green: 0,
      blue: 255,
      alpha: 配置.E.漂浮字.透明度,
      duration: 配置.E.漂浮字.持续秒,
      speedY: 配置.E.漂浮字.上浮速度,
      height: 20,
    });
    const 增量 = 配置.E.御势.每级护甲提升 * 等级;
    临时调整护甲(source, 增量);
    registerManualBuff(source, 云端BuffID.无双御势, 配置.E.增益持续秒, 增量);
    ctx = { 施法者: source, 分支: "御势", 增量, 已回收: false };
  }

  addDelayedCallback(
    秒转毫秒(配置.E.增益持续秒),
    回收E增益 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

let 已注册 = false;

export function 注册云端E(this: void): void {
  if (已注册) return;
  已注册 = true;
  registerDamageCallback(处理无双剑法触发);
}

注册云端E();

export {};
