/** @noSelfInFile */

import type { Boss血条弱点韧性运行状态, Boss弱点定义 } from "./00．类型";
import {
  Boss弱点反馈默认配置,
  Boss弱点提示文本,
  Boss弱点消息类型默认值,
  Boss弱点运行常量,
} from "./01．常量定义";
import {
  显示Boss弱点真实图标,
  刷新Boss护盾文本,
  设置Boss护盾灰色显示,
  设置Boss护盾完整显示,
  设置Boss护盾破碎显示,
  设置Boss弱点命中表现,
} from "./04．Boss弱点UI";
import { 获取全部Boss血条弱点韧性运行状态 } from "./05．Boss弱点运行状态";

const jass = require("jass.common") as any;
const jassGlobals = require("jass.globals") as any;
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { getServerTime, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 获取单位最终武器类型 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.07．武器类型") as {
  获取单位最终武器类型: (this: void, unit: any) => string;
};
const { Sound3DII_Mp3PlayReuse, prewarmReusableSound } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_Mp3PlayReuse: (this: void, path: string, player?: any) => void;
  prewarmReusableSound: (this: void, path: string) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, 来源单位: any, 目标单位: any, Buff类型: number, 持续时间: number) => void;
};

const GetHandleId = jass.GetHandleId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerName = jass.GetPlayerName as (player: any) => string;
const Player = jass.Player as (playerId: number) => any;
const bj_QUESTMESSAGE_UNITACQUIRED = jassGlobals.bj_QUESTMESSAGE_UNITACQUIRED ?? Boss弱点消息类型默认值.弱点发现;
const bj_QUESTMESSAGE_WARNING = jassGlobals.bj_QUESTMESSAGE_WARNING ?? Boss弱点消息类型默认值.护盾破碎;

// 后续实现时：属性伤害类型对齐伤害数字核心的 伤害类型快照；武器弱点按旧 JASS 字段语义对齐。
let 是否已注册Boss弱点最终伤害监听 = false;
let 是否已注册Boss弱点伤害修正 = false;
let 是否已注册Boss破盾伤害修正 = false;
let 弱点表现刷新回调ID = 0;

function 读取护盾值(this: void, state: Boss血条弱点韧性运行状态): number {
  return state.当前护盾值 > 0 ? state.当前护盾值 : 0;
}

function 读取护盾最大值(this: void, state: Boss血条弱点韧性运行状态): number {
  return state.最大护盾值 > 0 ? state.最大护盾值 : 0;
}

function 写入护盾值(this: void, state: Boss血条弱点韧性运行状态, value: number): void {
  state.当前护盾值 = value > 0 ? value : 0;
}

function 取正数配置(this: void, value: number | undefined, fallback: number): number {
  return value != null && value > 0 ? value : fallback;
}

function 取非负配置(this: void, value: number | undefined, fallback: number): number {
  return value != null && value >= 0 ? value : fallback;
}

function 取有效倍率配置(this: void, value: number | undefined, fallback: number): number {
  return value != null && value > 0 ? value : fallback;
}

function 取伤害加成配置(this: void, value: number | undefined, fallback: number): number {
  return value != null ? value : fallback;
}

function 播放全员本地音效(this: void, path: string | undefined): void {
  if (path == null || path === "") return;
  for (let playerId = 0; playerId <= Boss弱点运行常量.全员音效最大玩家ID; playerId++) {
    Sound3DII_Mp3PlayReuse(path, Player(playerId));
  }
}

function 预热Boss弱点反馈音效(this: void, state: Boss血条弱点韧性运行状态): void {
  prewarmReusableSound(state.配置?.弱点发现音效路径 ?? Boss弱点反馈默认配置.弱点发现音效路径);
  prewarmReusableSound(state.配置?.弱点击中音效路径 ?? Boss弱点反馈默认配置.弱点击中音效路径);
  prewarmReusableSound(state.配置?.护盾破碎音效路径 ?? Boss弱点反馈默认配置.护盾破碎音效路径);
}

function 发送全员任务消息(this: void, messageType: number, message: string): void {
  if (message === "") return;
  QuestMessageBJ(GetPlayersAll(), messageType, message);
}

function 取攻击者玩家名(this: void, attacker: any): string {
  if (attacker == null || attacker === 0) return Boss弱点提示文本.默认玩家名;
  const owner = GetOwningPlayer(attacker);
  if (owner == null || owner === 0) return Boss弱点提示文本.默认玩家名;
  const name = GetPlayerName(owner);
  return name != null && name !== "" ? name : Boss弱点提示文本.默认玩家名;
}

function 构造弱点发现提示(this: void, attacker: any, weak: Boss弱点定义): string {
  return Boss弱点提示文本.战斗提示前缀
    + Boss弱点提示文本.弱点发现玩家名前缀
    + 取攻击者玩家名(attacker)
    + Boss弱点提示文本.弱点发现玩家名后缀
    + weak.提示颜色
    + Boss弱点提示文本.弱点发现弱点名前缀
    + weak.显示名
    + Boss弱点提示文本.弱点发现弱点名后缀;
}

function 查找目标Boss弱点状态(this: void, target: any): Boss血条弱点韧性运行状态 | undefined {
  if (target == null || target === 0) return undefined;
  const targetHandleId = GetHandleId(target);
  const states = 获取全部Boss血条弱点韧性运行状态();
  for (let i = 0; i < states.length; i++) {
    const state = states[i];
    if (state.Boss句柄ID === targetHandleId && state.是否伤害结算已注册 && !state.是否已结束) return state;
  }
  return undefined;
}

function 取武器弱点键(this: void, attacker: any): string {
  const weaponType = 获取单位最终武器类型(attacker);
  if (weaponType === "剑") return "剑弱";
  if (weaponType === "枪") return "枪弱";
  if (weaponType === "斧锤") return "斧弱";
  if (weaponType === "弓箭") return "弓弱";
  if (weaponType === "匕首") return "短剑弱";
  if (weaponType === "法杖") return "杖弱";
  return "";
}

function 取属性弱点键(this: void, snapshot: any): string {
  if (snapshot == null) return "";
  if (snapshot.isFireDamage === true) return "火弱";
  if (snapshot.isWaterDamage === true) return "冰弱";
  if (snapshot.isThunderDamage === true) return "雷弱";
  if (snapshot.isWoodDamage === true) return "风弱";
  if (snapshot.isLightDamage === true) return "光弱";
  if (snapshot.isDarkDamage === true) return "暗弱";
  return "";
}

function 查找弱点索引(this: void, state: Boss血条弱点韧性运行状态, weakKey: string): number {
  if (state.配置 == null || weakKey === "") return -1;
  const weakList = state.配置.弱点列表;
  for (let i = 0; i < weakList.length; i++) {
    if (weakList[i].弱点键 === weakKey) return i;
  }
  return -1;
}

function 取命中弱点索引(this: void, state: Boss血条弱点韧性运行状态, attacker: any, applied: number, snapshot: any): number {
  if (state.配置 == null) return -1;

  let weaponWeakKey = "";
  if (snapshot != null && snapshot.isNormalAttack === true && snapshot.isPhysicalDamage === true) {
    const demand = state.配置.弱点伤害需求 || 0;
    state.武器弱点伤害累计 += applied;
    if (demand <= 0 || state.武器弱点伤害累计 >= demand) {
      state.武器弱点伤害累计 = 0;
      weaponWeakKey = 取武器弱点键(attacker);
    }
  }
  const weaponIndex = 查找弱点索引(state, weaponWeakKey);
  if (weaponIndex >= 0) return weaponIndex;

  const elementWeakKey = 取属性弱点键(snapshot);
  return 查找弱点索引(state, elementWeakKey);
}

function 取弱点冷却毫秒(this: void, state: Boss血条弱点韧性运行状态, weak: Boss弱点定义): number {
  if (state.配置?.弱点冷却毫秒 != null && state.配置.弱点冷却毫秒 > 0) return state.配置.弱点冷却毫秒;
  return weak.类别 === "武器" ? Boss弱点反馈默认配置.武器弱点冷却毫秒 : Boss弱点反馈默认配置.属性弱点冷却毫秒;
}

function 扣除Boss护盾(this: void, state: Boss血条弱点韧性运行状态): number {
  const shieldValue = 读取护盾值(state);
  if (shieldValue <= 0) {
    刷新Boss护盾文本(state, 0);
    return 0;
  }
  const reduceValue = 取正数配置(state.配置?.护盾命中削减值, Boss弱点反馈默认配置.护盾命中削减值);
  const nextValue = shieldValue - reduceValue;
  写入护盾值(state, nextValue);
  刷新Boss护盾文本(state, nextValue > 0 ? nextValue : 0);
  return nextValue > 0 ? nextValue : 0;
}

function 触发Boss护盾破碎(this: void, state: Boss血条弱点韧性运行状态, attacker: any): void {
  if (state.是否护盾破碎中) return;
  state.是否护盾破碎中 = true;
  写入护盾值(state, 0);
  刷新Boss护盾文本(state, 0);
  设置Boss护盾破碎显示(state);
  播放全员本地音效(state.配置?.护盾破碎音效路径 ?? Boss弱点反馈默认配置.护盾破碎音效路径);
  发送全员任务消息(bj_QUESTMESSAGE_WARNING, Boss弱点提示文本.护盾破碎提示);

  const source = attacker != null && attacker !== 0 ? attacker : state.Boss单位;
  const controlDuration = 取正数配置(state.配置?.破盾控制持续秒, Boss弱点反馈默认配置.破盾控制持续秒);
  const controlType = 取非负配置(state.配置?.破盾控制Buff类型, Boss弱点反馈默认配置.破盾控制Buff类型);
  if (controlDuration > 0) {
    施加快速控制Buff(source, state.Boss单位, controlType, controlDuration);
  }

  const now = getServerTime();
  const brokenMs = 取正数配置(state.配置?.破碎护盾显示毫秒, Boss弱点反馈默认配置.破碎护盾显示毫秒);
  const restoreMs = 取正数配置(state.配置?.护盾冷却毫秒, Boss弱点反馈默认配置.护盾恢复延迟毫秒);
  state.护盾破碎切灰截止毫秒 = now + brokenMs;
  state.护盾恢复截止毫秒 = now + brokenMs + restoreMs;
}

function 处理Boss弱点命中(this: void, state: Boss血条弱点韧性运行状态, weakIndex: number, attacker: any, applied: number): void {
  if (state.配置 == null) return;
  if (weakIndex < 0 || weakIndex >= state.配置.弱点列表.length) return;
  if (state.弱点保护列表[weakIndex] === true) return;

  const now = getServerTime();
  const weak = state.配置.弱点列表[weakIndex];
  const isFirstDiscovery = state.弱点已暴露列表[weakIndex] !== true;
  显示Boss弱点真实图标(state, weakIndex);
  if (isFirstDiscovery) {
    播放全员本地音效(state.配置.弱点发现音效路径 ?? Boss弱点反馈默认配置.弱点发现音效路径);
    if (state.配置.弱点发现提示启用 !== false) {
      发送全员任务消息(bj_QUESTMESSAGE_UNITACQUIRED, 构造弱点发现提示(attacker, weak));
    }
  }
  设置Boss弱点命中表现(state, weakIndex, true);
  state.弱点保护列表[weakIndex] = true;
  state.弱点保护截止毫秒列表[weakIndex] = now + 取弱点冷却毫秒(state, weak);
  state.弱点命中表现截止毫秒列表[weakIndex] = now + 取正数配置(
    state.配置.弱点命中表现毫秒,
    Boss弱点反馈默认配置.弱点命中表现毫秒,
  );
  const shieldValue = 扣除Boss护盾(state);
  播放全员本地音效(state.配置.弱点击中音效路径 ?? Boss弱点反馈默认配置.弱点击中音效路径);
  if (shieldValue <= 0) {
    触发Boss护盾破碎(state, attacker);
  }
  确保Boss弱点表现刷新();
}

function onBoss弱点命中伤害修正(this: void, context: any): number {
  if (context == null) return 0;
  if (!(context.currentDamage > 0)) return context.currentDamage;
  const state = 查找目标Boss弱点状态(context.target);
  if (state == null || state.配置 == null) return context.currentDamage;
  state.待处理弱点命中索引 = -1;
  if (state.是否护盾破碎中) return context.currentDamage;

  const weakIndex = 取命中弱点索引(state, context.attacker, context.currentDamage, context);
  if (weakIndex < 0) return context.currentDamage;
  if (state.弱点保护列表[weakIndex] === true) return context.currentDamage;

  state.待处理弱点命中索引 = weakIndex;
  const bonus = 取伤害加成配置(state.配置.弱点命中伤害加成, Boss弱点反馈默认配置.弱点命中伤害加成);
  if (!(bonus > 0)) return context.currentDamage;
  return context.currentDamage * (1 + bonus);
}

function onBoss弱点最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  const state = 查找目标Boss弱点状态(target);
  if (state == null || state.配置 == null) return;
  const weakIndex = state.待处理弱点命中索引;
  state.待处理弱点命中索引 = -1;
  if (!(applied > 0)) return;
  if (state.是否护盾破碎中) return;
  if (weakIndex < 0) return;
  处理Boss弱点命中(state, weakIndex, attacker, applied);
}

function 处理护盾破碎计时(this: void, state: Boss血条弱点韧性运行状态, now: number): void {
  if (!state.是否护盾破碎中) return;
  if (state.护盾破碎切灰截止毫秒 > 0 && now >= state.护盾破碎切灰截止毫秒) {
    state.护盾破碎切灰截止毫秒 = 0;
    设置Boss护盾灰色显示(state);
  }
  if (state.护盾恢复截止毫秒 > 0 && now >= state.护盾恢复截止毫秒) {
    const maxShield = 读取护盾最大值(state);
    写入护盾值(state, maxShield);
    刷新Boss护盾文本(state, maxShield);
    设置Boss护盾完整显示(state);
    state.是否护盾破碎中 = false;
    state.护盾破碎切灰截止毫秒 = 0;
    state.护盾恢复截止毫秒 = 0;
  }
}

function onBoss弱点表现刷新Tick(this: void): void {
  const now = getServerTime();
  const states = 获取全部Boss血条弱点韧性运行状态();
  let hasActive = false;
  for (let i = 0; i < states.length; i++) {
    const state = states[i];
    if (state.是否已结束 || !state.是否伤害结算已注册) continue;
    hasActive = true;
    处理护盾破碎计时(state, now);
    for (let weakIndex = 0; weakIndex < state.弱点保护列表.length; weakIndex++) {
      if (state.弱点保护列表[weakIndex] === true && now >= (state.弱点保护截止毫秒列表[weakIndex] || 0)) {
        state.弱点保护列表[weakIndex] = false;
        state.弱点保护截止毫秒列表[weakIndex] = 0;
      }
      if ((state.弱点命中表现截止毫秒列表[weakIndex] || 0) > 0 && now >= state.弱点命中表现截止毫秒列表[weakIndex]) {
        state.弱点命中表现截止毫秒列表[weakIndex] = 0;
        设置Boss弱点命中表现(state, weakIndex, false);
      }
    }
  }
  if (!hasActive && 弱点表现刷新回调ID !== 0) {
    removePeriodicCallback(弱点表现刷新回调ID);
    弱点表现刷新回调ID = 0;
  }
}

function 确保Boss弱点最终伤害监听(this: void): void {
  if (是否已注册Boss弱点最终伤害监听) return;
  是否已注册Boss弱点最终伤害监听 = true;
  registerAppliedFinalDamageListener(onBoss弱点最终伤害);
}

function 确保Boss弱点伤害修正(this: void): void {
  if (是否已注册Boss弱点伤害修正) return;
  是否已注册Boss弱点伤害修正 = true;
  registerDamageModifier(onBoss弱点命中伤害修正, 30);
}

function onBoss破盾伤害修正(this: void, context: any): number {
  if (context == null) return 0;
  if (!(context.currentDamage > 0)) return context.currentDamage;
  const state = 查找目标Boss弱点状态(context.target);
  if (state == null || state.配置 == null) return context.currentDamage;
  if (!state.是否护盾破碎中) return context.currentDamage;
  const multiplier = 取有效倍率配置(state.配置.破盾伤害倍率, Boss弱点反馈默认配置.破盾伤害倍率);
  return context.currentDamage * multiplier;
}

function 确保Boss破盾伤害修正(this: void): void {
  if (是否已注册Boss破盾伤害修正) return;
  是否已注册Boss破盾伤害修正 = true;
  registerDamageModifier(onBoss破盾伤害修正, 25);
}

function 确保Boss弱点表现刷新(this: void): void {
  if (弱点表现刷新回调ID !== 0) return;
  弱点表现刷新回调ID = addPeriodicCallback(Boss弱点运行常量.表现刷新间隔毫秒, onBoss弱点表现刷新Tick);
}

export function 注册Boss弱点伤害结算(this: void, state: Boss血条弱点韧性运行状态): void {
  if (state.是否已结束 || state.是否伤害结算已注册) return;
  if (!state.是否启用机制UI) return;
  if (!state.是否弱点已注册) return;
  预热Boss弱点反馈音效(state);
  确保Boss弱点伤害修正();
  确保Boss破盾伤害修正();
  确保Boss弱点最终伤害监听();
  state.是否伤害结算已注册 = true;
}

export function 注销Boss弱点伤害结算(this: void, state: Boss血条弱点韧性运行状态): void {
  if (!state.是否伤害结算已注册) return;
  state.是否伤害结算已注册 = false;
  state.是否护盾破碎中 = false;
  state.护盾破碎切灰截止毫秒 = 0;
  state.护盾恢复截止毫秒 = 0;
}
