/** @noSelfInFile */

import type { ThreatEntry } from "./00．仇恨存储";
import { getEnemyThreats, getHighestThreat } from "./00．仇恨存储";
import { 获取应攻击目标 } from "./02．目标选择";

export interface Boss技能仇恨目标 {
  targetHid: number;
  targetRef: any;
  threat: number;
  lastUpdateTime?: number;
}

export type 技能目标过滤器 = (entry: Boss技能仇恨目标) => boolean;

export function 获取Boss技能最高仇恨目标(
  this: void,
  boss: any,
  filter?: 技能目标过滤器
): ThreatEntry | null {
  return getHighestThreat(boss, filter);
}

export function 获取Boss技能应攻击目标(
  this: void,
  boss: any,
  filter?: 技能目标过滤器
): Boss技能仇恨目标 | null {
  return 获取应攻击目标(boss, filter);
}

export function 获取Boss技能仇恨目标列表(this: void, boss: any, filter?: 技能目标过滤器): ThreatEntry[] {
  const entries = getEnemyThreats(boss);
  if (filter == null) return entries;
  const result: ThreatEntry[] = [];
  for (let i = 0; i < entries.length; i++) {
    if (filter(entries[i])) result.push(entries[i]);
  }
  return result;
}
