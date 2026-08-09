const jass = require("jass.common") as any;

import { IMaxBJ } from "../../../lib/扩展函数/BJ函数/index";
import { getPlayerFirstHero } from "../../../lib/扩展函数/自定义扩展函数/index";
const { GS_UnitPry } = require("lib.扩展函数.Star扩展函数.02．GS单位属性") as {
  GS_UnitPry: (this: void, unit: any, change: number, propertyType: number, value: number) => void;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, unit: any, attributeName: string, delta: number) => void;
};
import {
  bindRewardParseHeroResolver,
  isConditionMatchedWithContext,
  RewardExecContext,
  RewardExecResult,
} from "./06．任务奖励解析";

// ========== 虚拟分区：奖励执行（资源/经验/属性） ==========
function getUserPlayers(): any[] {
  const out: any[] = [];
  for (let i = 0; i < 4; i++) {
    const p = jass.Player(i);
    if (p && jass.GetPlayerController(p) === jass.MAP_CONTROL_USER) out.push(p);
  }
  return out;
}

bindRewardParseHeroResolver(getPlayerFirstHero);

function gainGold(players: any[], value: number): void {
  for (const p of players) {
    const cur = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD) || 0;
    jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD, cur + value);
  }
}

function gainLumber(players: any[], value: number): void {
  for (const p of players) {
    const cur = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER) || 0;
    jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER, cur + value);
  }
}

function gainExp(players: any[], value: number): void {
  for (const p of players) {
    const hero = getPlayerFirstHero(p);
    if (hero) jass.AddHeroXP(hero, value, true);
  }
}

function gainLevel(players: any[], value: number): void {
  for (const p of players) {
    const hero = getPlayerFirstHero(p);
    if (hero) {
      const lv = jass.GetHeroLevel(hero);
      jass.SetHeroLevel(hero, lv + value, false);
    }
  }
}

function gainHeroStat(players: any[], statName: string, value: number): void {
  const integerValue = jass.R2I(value) as number;
  for (const p of players) {
    const hero = getPlayerFirstHero(p);
    if (!hero) continue;
    if (statName === "力量") {
      jass.SetHeroStr(hero, jass.GetHeroStr(hero, false) + integerValue, true);
    } else if (statName === "敏捷") {
      jass.SetHeroAgi(hero, jass.GetHeroAgi(hero, false) + integerValue, true);
    } else if (statName === "智力") {
      jass.SetHeroInt(hero, jass.GetHeroInt(hero, false) + integerValue, true);
    }
  }
}

function gainAttack(this: void, players: any[], value: number): void {
  for (const p of players) {
    const hero = getPlayerFirstHero(p);
    if (hero) GS_UnitPry(hero, 0, 2, value);
  }
}

function gainPlayerAttribute(this: void, players: any[], attributeName: string, value: number): void {
  for (const player of players) {
    const hero = getPlayerFirstHero(player);
    if (hero) 调整玩家属性(hero, attributeName, value);
  }
}

interface 数值表达式解析状态 {
  文本: string;
  位置: number;
  英雄等级: number;
}

function 跳过表达式空格(this: void, 状态: 数值表达式解析状态): void {
  while (状态.位置 < 状态.文本.length && 状态.文本.charAt(状态.位置) === " ") 状态.位置++;
}

function 尝试读取表达式标记(this: void, 状态: 数值表达式解析状态, 标记: string): boolean {
  跳过表达式空格(状态);
  if (状态.文本.substring(状态.位置, 状态.位置 + 标记.length) !== 标记) return false;
  状态.位置 += 标记.length;
  return true;
}

function 读取表达式数字(this: void, 状态: 数值表达式解析状态): number {
  跳过表达式空格(状态);
  let 整数 = 0;
  let 小数 = 0;
  let 小数位倍率 = 0.1;
  let 已读取 = false;
  let 正在读取小数 = false;
  while (状态.位置 < 状态.文本.length) {
    const 字符 = 状态.文本.charAt(状态.位置);
    if (字符 >= "0" && 字符 <= "9") {
      已读取 = true;
      const 数字 = 字符.charCodeAt(0) - 48;
      if (正在读取小数) {
        小数 += 数字 * 小数位倍率;
        小数位倍率 *= 0.1;
      } else {
        整数 = 整数 * 10 + 数字;
      }
      状态.位置++;
      continue;
    }
    if (字符 === "." && !正在读取小数) {
      正在读取小数 = true;
      状态.位置++;
      continue;
    }
    break;
  }
  return 已读取 ? 整数 + 小数 : 0;
}

function 读取表达式基础值(this: void, 状态: 数值表达式解析状态): number {
  跳过表达式空格(状态);
  if (尝试读取表达式标记(状态, "+")) return 读取表达式基础值(状态);
  if (尝试读取表达式标记(状态, "-")) return 0 - 读取表达式基础值(状态);
  if (尝试读取表达式标记(状态, "(")) {
    const 数值 = 读取表达式加减(状态);
    尝试读取表达式标记(状态, ")");
    return 数值;
  }
  if (尝试读取表达式标记(状态, "IMaxBJ")) {
    if (!尝试读取表达式标记(状态, "(")) return 0;
    const 左值 = 读取表达式加减(状态);
    尝试读取表达式标记(状态, ",");
    const 右值 = 读取表达式加减(状态);
    尝试读取表达式标记(状态, ")");
    return IMaxBJ(左值, 右值);
  }
  if (尝试读取表达式标记(状态, "英雄等级") || 尝试读取表达式标记(状态, "等级")) return 状态.英雄等级;
  return 读取表达式数字(状态);
}

function 读取表达式乘除(this: void, 状态: 数值表达式解析状态): number {
  let 数值 = 读取表达式基础值(状态);
  while (状态.位置 < 状态.文本.length) {
    if (尝试读取表达式标记(状态, "*")) {
      数值 *= 读取表达式基础值(状态);
      continue;
    }
    if (尝试读取表达式标记(状态, "/")) {
      const 除数 = 读取表达式基础值(状态);
      if (除数 !== 0) 数值 /= 除数;
      continue;
    }
    break;
  }
  return 数值;
}

function 读取表达式加减(this: void, 状态: 数值表达式解析状态): number {
  let 数值 = 读取表达式乘除(状态);
  while (状态.位置 < 状态.文本.length) {
    if (尝试读取表达式标记(状态, "+")) {
      数值 += 读取表达式乘除(状态);
      continue;
    }
    if (尝试读取表达式标记(状态, "-")) {
      数值 -= 读取表达式乘除(状态);
      continue;
    }
    break;
  }
  return 数值;
}

function 获取奖励英雄等级(this: void, triggerPlayerId?: number): number {
  const player = triggerPlayerId != null ? jass.Player(triggerPlayerId) : null;
  const hero = player ? getPlayerFirstHero(player) : null;
  return hero ? (jass.GetHeroLevel(hero) as number) : 1;
}

function resolveAmountExpr(expr: string, triggerPlayerId?: number): number {
  const 状态: 数值表达式解析状态 = {
    文本: expr.trim(),
    位置: 0,
    英雄等级: 获取奖励英雄等级(triggerPlayerId),
  };
  return 读取表达式加减(状态);
}

function 提取类型前数值表达式(this: void, 文本: string, 类型名: string): string {
  const 位置 = 文本.indexOf(类型名);
  return 位置 >= 0 ? 文本.substring(0, 位置).trim() : "";
}

function 提取属性数值表达式(this: void, 文本: string, 属性名: string): string {
  const 位置 = 文本.indexOf(属性名);
  if (位置 < 0) return "";
  const 前段 = 文本.substring(0, 位置).trim();
  if (前段 !== "") return 前段.split("%").join("").trim();
  let 后段 = 文本.substring(位置 + 属性名.length).trim();
  while (后段.charAt(0) === ":" || 后段.charAt(0) === "+" || 后段.charAt(0) === "＋") 后段 = 后段.substring(1).trim();
  return 后段.split("%").join("").trim();
}

function executeOneRewardExpr(expr: string, triggerPlayerId?: number): void {
  const text = expr.trim();
  if (text === "" || text === "null") return;
  const allPlayers = getUserPlayers();
  const targetPlayers =
    text.indexOf("完成任务的玩家") >= 0 || text.indexOf("Player") >= 0
      ? (triggerPlayerId != null ? [jass.Player(triggerPlayerId)] : [])
      : allPlayers;
  let payload = text;
  const prefixes = ["所有玩家", "完成任务的玩家", "Player"];
  for (const p of prefixes) {
    if (payload.indexOf(p) === 0) {
      payload = payload.substring(p.length).trim();
      while (payload.charAt(0) === "+" || payload.charAt(0) === "＋") payload = payload.substring(1).trim();
      break;
    }
  }
  if (payload.indexOf("经验") >= 0 || payload.indexOf("exp") >= 0) {
    const value = resolveAmountExpr(提取类型前数值表达式(payload, payload.indexOf("经验") >= 0 ? "经验" : "exp"), triggerPlayerId);
    if (value > 0) gainExp(targetPlayers, value);
    return;
  }
  if (payload.indexOf("金币") >= 0 || payload.indexOf("gold") >= 0) {
    const value = resolveAmountExpr(提取类型前数值表达式(payload, payload.indexOf("金币") >= 0 ? "金币" : "gold"), triggerPlayerId);
    if (value > 0) gainGold(targetPlayers, value);
    return;
  }
  if (payload.indexOf("能量碎片") >= 0 || payload.indexOf("木头") >= 0 || payload.indexOf("木材") >= 0 || payload.indexOf("wood") >= 0) {
    let 类型名 = "能量碎片";
    if (payload.indexOf("木头") >= 0) 类型名 = "木头";
    else if (payload.indexOf("木材") >= 0) 类型名 = "木材";
    else if (payload.indexOf("wood") >= 0) 类型名 = "wood";
    const value = resolveAmountExpr(提取类型前数值表达式(payload, 类型名), triggerPlayerId);
    if (value > 0) gainLumber(targetPlayers, value);
    return;
  }
  const 以等级结尾 = payload.length > "等级".length && payload.substring(payload.length - "等级".length) === "等级";
  const 以Level结尾 = payload.length > "level".length && payload.substring(payload.length - "level".length) === "level";
  if (以等级结尾 || 以Level结尾) {
    const value = resolveAmountExpr(提取类型前数值表达式(payload, 以等级结尾 ? "等级" : "level"), triggerPlayerId);
    if (value > 0) gainLevel(targetPlayers, value);
    return;
  }
  if (payload.indexOf("攻击力") >= 0) {
    const value = resolveAmountExpr(提取属性数值表达式(payload, "攻击力"), triggerPlayerId);
    if (value > 0) gainAttack(targetPlayers, value);
    return;
  }
  if (payload.indexOf("智力成长") >= 0) {
    const value = resolveAmountExpr(提取属性数值表达式(payload, "智力成长"), triggerPlayerId);
    if (value !== 0) gainPlayerAttribute(targetPlayers, "智力成长", value);
    return;
  }
  const 百分比属性名列表 = ["金属性抗性", "魔法伤害", "暴击伤害", "暴击率"];
  for (const 属性名 of 百分比属性名列表) {
    if (payload.indexOf(属性名) < 0) continue;
    const value = resolveAmountExpr(提取属性数值表达式(payload, 属性名), triggerPlayerId);
    if (value !== 0) gainPlayerAttribute(targetPlayers, 属性名, payload.indexOf("%") >= 0 ? value / 100 : value);
    return;
  }
  if (payload.indexOf("力量") >= 0) {
    const value = resolveAmountExpr(提取属性数值表达式(payload, "力量"), triggerPlayerId);
    if (value > 0) gainHeroStat(targetPlayers, "力量", value);
    return;
  }
  if (payload.indexOf("敏捷") >= 0) {
    const value = resolveAmountExpr(提取属性数值表达式(payload, "敏捷"), triggerPlayerId);
    if (value > 0) gainHeroStat(targetPlayers, "敏捷", value);
    return;
  }
  if (payload.indexOf("智力") >= 0) {
    const value = resolveAmountExpr(提取属性数值表达式(payload, "智力"), triggerPlayerId);
    if (value > 0) gainHeroStat(targetPlayers, "智力", value);
  }
}

function 是否奖励条件(this: void, 条件: string): boolean {
  const 文本 = 条件.trim();
  if (文本.indexOf("英雄等级") === 0) return true;
  if (文本.indexOf("装备等级") === 0) return true;
  return 文本.indexOf("|") >= 0 && 文本.indexOf("I") >= 0;
}

export function applyRewardWithContext(rewardRaw: string, ctx: RewardExecContext): RewardExecResult {
  if (!rewardRaw || rewardRaw === "") return { matchedRuleIndex: -1, matchedCondition: "" };
  let matchedRuleIndex = -1;
  let matchedCondition = "";
  const lines = rewardRaw.split("\n");
  for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
    const line = lines[lineIdx].trim();
    if (line === "") continue;
    const colon = line.indexOf(":");
    if (colon > 0 && 是否奖励条件(line.substring(0, colon))) {
      const cond = line.substring(0, colon).trim();
      const expr = line.substring(colon + 1).trim();
      if (expr === "") continue;
      if (!isConditionMatchedWithContext(cond, ctx)) continue;
      const parts = expr.split(";");
      for (const p of parts) executeOneRewardExpr(p, ctx.triggerPlayerId);
      matchedRuleIndex = lineIdx;
      matchedCondition = cond;
      break;
    }
    const parts = line.split(";");
    for (const p of parts) executeOneRewardExpr(p, ctx.triggerPlayerId);
  }
  return { matchedRuleIndex, matchedCondition };
}

export function previewRewardMatchWithContext(rewardRaw: string, ctx: RewardExecContext): RewardExecResult {
  if (!rewardRaw || rewardRaw === "") return { matchedRuleIndex: -1, matchedCondition: "" };
  const lines = rewardRaw.split("\n");
  for (let lineIdx = 0; lineIdx < lines.length; lineIdx++) {
    const line = lines[lineIdx].trim();
    if (line === "") continue;
    const colon = line.indexOf(":");
    if (colon <= 0) continue;
    const cond = line.substring(0, colon).trim();
    if (!是否奖励条件(cond)) continue;
    if (line.substring(colon + 1).trim() === "") continue;
    if (isConditionMatchedWithContext(cond, ctx)) {
      return { matchedRuleIndex: lineIdx, matchedCondition: cond };
    }
  }
  return { matchedRuleIndex: -1, matchedCondition: "" };
}

export function giveRewardToPlayers(rewardRaw: string, triggerPlayerId?: number): void {
  applyRewardWithContext(rewardRaw, { triggerPlayerId });
}

export { getPlayerFirstHero };

