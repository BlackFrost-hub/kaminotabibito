/** @noSelfInFile */

import type { AI技能覆盖配置, AI目标选择方式, AI施法目标类型, 单位AI配置 } from "../00．AI配置/01．AI配置类型";
import { 解析单位AI配置单位类型ID } from "../00．AI配置/02．AI配置工具";
import { BossAI配置表 } from "../00．AI配置/01．BossAI配置表";
import { 英雄BossAI配置表 } from "../00．AI配置/04．英雄BossAI配置表";
import { 异界BossAI配置表 } from "../00．AI配置/05．异界BossAI配置表";
import { 获取所有Boss自动技能启动上下文, 清理Boss自动技能启动上下文 } from "../03．Boss战启动桥接/01．Boss自动技能注册表";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitName = jass.GetUnitName as (whichUnit: any) => string;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: number) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (whichUnit: any, order: string) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (whichUnit: any, order: string, x: number, y: number) => boolean;
const IssueTargetOrder = jass.IssueTargetOrder as (whichUnit: any, order: string, targetWidget: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as number;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as number;
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { getEnemyUnitsInRangeOfUnit } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRangeOfUnit: (this: void, centerUnit: any, radius: number) => any[];
};
const { SUC_IsUnitAlive, SUC_MatchBasicTarget } = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数") as {
  SUC_IsUnitAlive: (this: void, unit: any) => boolean;
  SUC_MatchBasicTarget: (this: void, target: any, source: any, wantEnemy: boolean) => boolean;
};
const { getObjectProperty, ObjectType, YDWEDistanceBetweenUnits } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  getObjectProperty: (this: void, objectType: number, objectId: number | string, property: string) => string;
  ObjectType: { ABILITY: number };
  YDWEDistanceBetweenUnits: (this: void, a: any, b: any) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 获取应攻击目标 } = require("系统.01．单位系统.06．仇恨系统.02．目标选择") as {
  获取应攻击目标: (
    this: void,
    敌人: any,
    filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean
  ) => { targetHid: number; targetRef: any; threat: number } | null;
};
const { 技能数据表 } = require("系统.03．技能系统.08．技能数据表.00．技能数据表") as {
  技能数据表: Record<string, Record<string, any>>;
};
const platformAbilityApi = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, 单位: any, 技能代码: number) => number;
  技能_获取技能施法距离: (this: void, 单位: any, 技能代码: number) => number;
  技能_获取技能施法范围: (this: void, 单位: any, 技能代码: number) => number;
};
const { 技能_获取技能当前冷却时间, 技能_获取技能施法距离, 技能_获取技能施法范围 } = platformAbilityApi;

const 模块名 = "Boss主动扫描施法";
const 默认扫描间隔毫秒 = 250;
const 默认公共施法间隔毫秒 = 1000;

interface Boss主动运行状态 {
  下次检查时间: number;
  下次可施法时间: number;
}

const Boss主动运行状态表: Record<number, Boss主动运行状态 | undefined> = {};
const 技能命令缓存: Record<string, string | undefined> = {};
const 技能能力ID缓存: Record<string, number | undefined> = {};
const 技能施法距离缓存: Record<string, number | undefined> = {};
const 技能施法范围缓存: Record<string, number | undefined> = {};

let Boss主动扫描回调ID = 0;

const Boss主动扫描配置表: 单位AI配置[] = [
  ...BossAI配置表,
  ...英雄BossAI配置表,
  ...异界BossAI配置表,
];

function 取单位句柄ID(unit: any): number {
  if (unit == null || unit === 0) return 0;
  const handleId = jass.GetHandleId(unit) as number;
  return handleId || 0;
}

function 读取数值字段(raw: any): number {
  if (raw == null) return 0;
  if (typeof raw === "number") return raw;
  if (typeof raw === "string") {
    const value = parseFloat(raw);
    return isNaN(value) ? 0 : value;
  }
  if (typeof raw === "object") {
    const directKeys = ["1", 1, "0", 0];
    for (let i = 0; i < directKeys.length; i++) {
      const value = raw[directKeys[i] as any];
      if (value != null && value !== "") {
        return 读取数值字段(value);
      }
    }
    const keys = Object.keys(raw).sort((a, b) => {
      const na = parseInt(a, 10);
      const nb = parseInt(b, 10);
      if (isNaN(na) && isNaN(nb)) return a < b ? -1 : 1;
      if (isNaN(na)) return 1;
      if (isNaN(nb)) return -1;
      return na - nb;
    });
    for (let i = 0; i < keys.length; i++) {
      const value = raw[keys[i]];
      if (value != null && value !== "") {
        return 读取数值字段(value);
      }
    }
  }
  return 0;
}

function 读取技能表数值(skillId: string, field: "Rng" | "Area"): number {
  const 缓存键 = `${skillId}:${field}`;
  const cached = field === "Rng" ? 技能施法距离缓存[缓存键] : 技能施法范围缓存[缓存键];
  if (cached != null) return cached;

  const entry = 技能数据表[skillId];
  if (entry == null) return 0;
  const value = 读取数值字段(entry[field]);
  if (field === "Rng") {
    技能施法距离缓存[缓存键] = value;
  } else {
    技能施法范围缓存[缓存键] = value;
  }
  return value;
}

function 读取技能命令字符串(skillId: string): string {
  const cached = 技能命令缓存[skillId];
  if (cached != null) return cached;
  const value = getObjectProperty(ObjectType.ABILITY, skillId, "Order") || "";
  技能命令缓存[skillId] = value;
  return value;
}

function 读取技能能力ID(skillId: string): number {
  const cached = 技能能力ID缓存[skillId];
  if (cached != null) return cached;
  const value = stringToFourCCSafe(skillId);
  技能能力ID缓存[skillId] = value;
  return value;
}

function 读取技能当前冷却毫秒(unit: any, skillId: string): number {
  const abilityId = 读取技能能力ID(skillId);
  if (abilityId === 0) return 0;
  const currentCooldown = 技能_获取技能当前冷却时间(unit, abilityId) || 0;
  if (currentCooldown <= 0) return 0;
  return currentCooldown * 1000;
}

function 读取技能实时施法距离(unit: any, skillId: string): number {
  const abilityId = 读取技能能力ID(skillId);
  if (abilityId !== 0) {
    const currentRange = 技能_获取技能施法距离(unit, abilityId) || 0;
    if (currentRange > 0) return currentRange;
  }
  return 读取技能表数值(skillId, "Rng");
}

function 读取技能实时施法范围(unit: any, skillId: string): number {
  const abilityId = 读取技能能力ID(skillId);
  if (abilityId !== 0) {
    const currentArea = 技能_获取技能施法范围(unit, abilityId) || 0;
    if (currentArea > 0) return currentArea;
  }
  return 读取技能表数值(skillId, "Area");
}

function 获取Boss主动运行状态(unit: any): Boss主动运行状态 {
  const handleId = 取单位句柄ID(unit);
  let state = Boss主动运行状态表[handleId];
  if (state == null) {
    state = {
      下次检查时间: 0,
      下次可施法时间: 0,
    };
    Boss主动运行状态表[handleId] = state;
  }
  return state;
}

function 清理Boss主动运行状态(unit: any): void {
  const handleId = 取单位句柄ID(unit);
  if (handleId === 0) return;
  Boss主动运行状态表[handleId] = undefined;
}

function 是否有效Boss主动目标(candidate: any, source: any): boolean {
  if (candidate == null || candidate === 0) return false;
  if (!SUC_MatchBasicTarget(candidate, source, true)) return false;
  if (jass.IsUnitType(candidate, jass.UNIT_TYPE_ANCIENT)) return false;
  if (jass.IsUnitType(candidate, jass.UNIT_TYPE_SUMMONED)) return false;
  return true;
}

function 选择最近敌人(unit: any, candidates: any[]): any | null {
  if (candidates.length === 0) return null;
  let best = candidates[0];
  let bestDistance = YDWEDistanceBetweenUnits(unit, best);
  for (let i = 1; i < candidates.length; i++) {
    const candidate = candidates[i];
    const distance = YDWEDistanceBetweenUnits(unit, candidate);
    if (distance < bestDistance) {
      best = candidate;
      bestDistance = distance;
    }
  }
  return best;
}

function 读取单位状态百分比(unit: any, currentState: number, maxState: number): number {
  const max = GetUnitState(unit, maxState);
  if (max <= 0) return 100;
  const current = GetUnitState(unit, currentState);
  return (current / max) * 100;
}

function 是否满足百分比区间(value: number, min?: number, max?: number): boolean {
  if (min != null && value < min) return false;
  if (max != null && value > max) return false;
  return true;
}

function 是否满足技能释放条件(
  unit: any,
  技能: AI技能覆盖配置,
  target: any | null
): boolean {
  const lifePercent = 读取单位状态百分比(unit, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE);
  if (!是否满足百分比区间(lifePercent, 技能.最低生命百分比, 技能.最高生命百分比)) {
    return false;
  }

  const manaPercent = 读取单位状态百分比(unit, UNIT_STATE_MANA, UNIT_STATE_MAX_MANA);
  if (!是否满足百分比区间(manaPercent, 技能.最低魔法百分比, 技能.最高魔法百分比)) {
    return false;
  }

  if (target != null && target !== 0 && target !== unit) {
    const distance = YDWEDistanceBetweenUnits(unit, target);
    if (技能.最小施法距离 != null && distance < 技能.最小施法距离) {
      return false;
    }
    if (技能.最大施法距离 != null && distance > 技能.最大施法距离) {
      return false;
    }
  }

  return true;
}

function 按单位获取Boss主动AI配置(unit: any): 单位AI配置 | undefined {
  const unitTypeId = GetUnitTypeId(unit);
  if (unitTypeId !== 0) {
    for (let i = 0; i < Boss主动扫描配置表.length; i++) {
      const 配置 = Boss主动扫描配置表[i];
      if (解析单位AI配置单位类型ID(配置) === unitTypeId) {
        return 配置;
      }
    }
  }

  const unitName = GetUnitName(unit);
  for (let i = 0; i < Boss主动扫描配置表.length; i++) {
    const 配置 = Boss主动扫描配置表[i];
    if (配置.单位名 === unitName) {
      return 配置;
    }
  }

  return undefined;
}

function 选择主动施法目标(
  unit: any,
  配置: 单位AI配置,
  技能: AI技能覆盖配置,
  范围: number
): any | null {
  const 施法目标类型 = 技能.施法目标类型 ?? "自动";
  if (施法目标类型 === "无目标") return null;
  if (施法目标类型 === "自己") return unit;

  const candidates = getEnemyUnitsInRangeOfUnit(unit, 范围).filter((candidate) => 是否有效Boss主动目标(candidate, unit));
  if (candidates.length === 0) return null;

  const 目标选择方式 = 技能.目标选择方式 ?? 配置.默认目标选择方式 ?? "最高仇恨";
  if (目标选择方式 === "最近敌人") {
    return 选择最近敌人(unit, candidates);
  }

  const threat = 获取应攻击目标(unit, (entry) => {
    const target = entry.targetRef;
    if (!是否有效Boss主动目标(target, unit)) return false;
    return YDWEDistanceBetweenUnits(unit, target) <= 范围;
  });
  if (threat != null && threat.targetRef != null && threat.targetRef !== 0) {
    return threat.targetRef;
  }

  return 选择最近敌人(unit, candidates);
}

function 执行技能下单(
  unit: any,
  技能: AI技能覆盖配置,
  命令字符串: string,
  target: any | null
): boolean {
  const 施法目标类型 = 技能.施法目标类型 ?? "自动";
  if (施法目标类型 === "无目标") {
    return IssueImmediateOrder(unit, 命令字符串) === true;
  }

  if (施法目标类型 === "自己") {
    return IssueTargetOrder(unit, 命令字符串, unit) === true;
  }

  if (施法目标类型 === "单位") {
    if (target == null || target === 0) return false;
    return IssueTargetOrder(unit, 命令字符串, target) === true;
  }

  if (施法目标类型 === "点") {
    const pointTarget = target != null && target !== 0 ? target : unit;
    const x = jass.GetUnitX(pointTarget);
    const y = jass.GetUnitY(pointTarget);
    return IssuePointOrder(unit, 命令字符串, x, y) === true;
  }

  if (施法目标类型 === "单位或点") {
    if (target != null && target !== 0) {
      return IssueTargetOrder(unit, 命令字符串, target) === true;
    }
    const x = jass.GetUnitX(unit);
    const y = jass.GetUnitY(unit);
    return IssuePointOrder(unit, 命令字符串, x, y) === true;
  }

  if (target != null && target !== 0) {
    return IssueTargetOrder(unit, 命令字符串, target) === true;
  }

  return IssueImmediateOrder(unit, 命令字符串) === true;
}

function 选择可施法技能(
  unit: any,
  配置: 单位AI配置
): { skill: AI技能覆盖配置; target: any | null; coolMs: number; range: number; area: number } | null {
  const 技能列表 = (配置.技能覆盖 ?? [])
    .filter((skill) => skill != null && !skill.禁用 && skill.技能ID != null && skill.技能ID !== "")
    .slice()
    .sort((a, b) => {
      const 权重A = a.权重 ?? 0;
      const 权重B = b.权重 ?? 0;
      if (权重A !== 权重B) return 权重B - 权重A;
      const idA = a.技能ID ?? "";
      const idB = b.技能ID ?? "";
      return idA < idB ? -1 : 1;
    });

  for (let i = 0; i < 技能列表.length; i++) {
    const skill = 技能列表[i];
    const skillId = skill.技能ID as string;
    if (skillId == null || skillId === "") continue;

    const abilityId = 读取技能能力ID(skillId);
    if (abilityId === 0 || jass.GetUnitAbilityLevel(unit, abilityId) <= 0) continue;
    const coolMs = 读取技能当前冷却毫秒(unit, skillId);
    if (coolMs > 0) continue;

    const range = skill.最大施法距离 ?? 读取技能实时施法距离(unit, skillId) ?? 配置.默认施法距离 ?? 1200;
    const area = 读取技能实时施法范围(unit, skillId);
    const target = 选择主动施法目标(unit, 配置, skill, range);

    if (!是否满足技能释放条件(unit, skill, target)) continue;

    if ((skill.施法目标类型 ?? "自动") !== "无目标" && (skill.施法目标类型 ?? "自动") !== "自己") {
      if (target == null || target === 0) continue;
    }

    const order = 读取技能命令字符串(skillId);
    if (order === "") continue;

    return { skill, target, coolMs, range, area };
  }

  return null;
}

function 尝试驱动单个Boss(context: { Boss单位: any; 来源: string; 注册时间: number }): void {
  const unit = context.Boss单位;
  if (unit == null || unit === 0) {
    return;
  }
  if (!SUC_IsUnitAlive(unit)) {
    清理Boss自动技能启动上下文(unit);
    清理Boss主动运行状态(unit);
    return;
  }

  const 单位名 = GetUnitName(unit);
  const 配置 = 按单位获取Boss主动AI配置(unit);
  if (配置 == null) {
    return;
  }
  if (配置.AI模式 !== "固定技能表") {
    return;
  }

  const now = getServerTime();
  const state = 获取Boss主动运行状态(unit);
  const 检查间隔 = 配置.检查间隔Ms ?? 默认扫描间隔毫秒;
  if (state.下次检查时间 > now) {
    return;
  }
  state.下次检查时间 = now + 检查间隔;

  if (state.下次可施法时间 > now) {
    return;
  }

  const 选择结果 = 选择可施法技能(unit, 配置);
  if (选择结果 == null) {
    return;
  }

  const { skill, target, coolMs, range, area } = 选择结果;
  const order = 读取技能命令字符串(skill.技能ID as string);
  const 成功 = 执行技能下单(unit, skill, order, target);
  if (!成功) {
    return;
  }

  state.下次可施法时间 = now + (配置.公共施法间隔Ms ?? 默认公共施法间隔毫秒);

  debugLogForce(
    模块名,
    "Boss主动施法",
    "boss=",
    单位名,
    "skill=",
    skill.技能名,
    "id=",
    skill.技能ID,
    "target=",
    target != null && target !== 0 ? jass.GetUnitName(target) : "无目标",
    "cdMs=",
    coolMs,
    "range=",
    range,
    "area=",
    area,
    "公共间隔Ms=",
    配置.公共施法间隔Ms ?? 默认公共施法间隔毫秒
  );
}

function onBoss主动扫描Tick(this: void): void {
  const contexts = 获取所有Boss自动技能启动上下文();
  for (let i = 0; i < contexts.length; i++) {
    尝试驱动单个Boss(contexts[i]);
  }
}

export function initBoss主动扫描施法(this: void): void {
  if (Boss主动扫描回调ID !== 0) return;
  Boss主动扫描回调ID = addPeriodicCallback(250, onBoss主动扫描Tick);
}

export function 重新扫描Boss主动施法(this: void): void {
  onBoss主动扫描Tick();
}
