const jass = require("jass.common") as any;

import { IMaxBJ } from "../../../lib/扩展函数/BJ函数/index";
import { getPlayerFirstHero } from "../../../lib/扩展函数/自定义扩展函数/index";
import {
  bindRewardParseHeroResolver,
  isConditionMatchedWithContext,
  RewardExecContext,
  RewardExecResult,
} from "./11．任务奖励解析";

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
  for (const p of players) {
    const hero = getPlayerFirstHero(p);
    if (!hero) continue;
    if (statName === "力量") {
      jass.SetHeroStr(hero, jass.GetHeroStr(hero, false) + value, true);
    } else if (statName === "敏捷") {
      jass.SetHeroAgi(hero, jass.GetHeroAgi(hero, false) + value, true);
    } else if (statName === "智力") {
      jass.SetHeroInt(hero, jass.GetHeroInt(hero, false) + value, true);
    }
  }
}

function readFirstNumber(s: string): number {
  let found = false;
  let n = 0;
  for (let i = 0; i < s.length; i++) {
    const c = s.charAt(i);
    if (c >= "0" && c <= "9") {
      found = true;
      n = n * 10 + (c.charCodeAt(0) - 48);
    } else if (found) {
      break;
    }
  }
  return n;
}

function resolveAmountExpr(expr: string, triggerPlayerId?: number): number {
  const text = expr.trim();
  if (text.indexOf("IMaxBJ(") === 0) {
    const player = triggerPlayerId != null ? jass.Player(triggerPlayerId) : null;
    const hero = player ? getPlayerFirstHero(player) : null;
    const level = hero ? (jass.GetHeroLevel(hero) as number) : 1;
    const a = 20000 - (level - 20) * 1000;
    return IMaxBJ(a, 10000);
  }
  return readFirstNumber(text);
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
    const value = resolveAmountExpr(payload, triggerPlayerId);
    if (value > 0) gainExp(targetPlayers, value);
    return;
  }
  if (payload.indexOf("金币") >= 0 || payload.indexOf("gold") >= 0) {
    const value = resolveAmountExpr(payload, triggerPlayerId);
    if (value > 0) gainGold(targetPlayers, value);
    return;
  }
  if (payload.indexOf("能量碎片") >= 0 || payload.indexOf("木头") >= 0 || payload.indexOf("木材") >= 0 || payload.indexOf("wood") >= 0) {
    const value = resolveAmountExpr(payload, triggerPlayerId);
    if (value > 0) gainLumber(targetPlayers, value);
    return;
  }
  if (payload.indexOf("等级") >= 0 || payload.indexOf("level") >= 0) {
    const value = resolveAmountExpr(payload, triggerPlayerId);
    if (value > 0) gainLevel(targetPlayers, value);
    return;
  }
  if (payload.indexOf("力量") >= 0) {
    const value = resolveAmountExpr(payload, triggerPlayerId);
    if (value > 0) gainHeroStat(targetPlayers, "力量", value);
    return;
  }
  if (payload.indexOf("敏捷") >= 0) {
    const value = resolveAmountExpr(payload, triggerPlayerId);
    if (value > 0) gainHeroStat(targetPlayers, "敏捷", value);
    return;
  }
  if (payload.indexOf("智力") >= 0) {
    const value = resolveAmountExpr(payload, triggerPlayerId);
    if (value > 0) gainHeroStat(targetPlayers, "智力", value);
  }
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
    if (colon > 0) {
      const cond = line.substring(0, colon).trim();
      const expr = line.substring(colon + 1).trim();
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

