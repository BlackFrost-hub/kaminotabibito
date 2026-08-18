/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 两点角度, 极坐标X, 极坐标Y, 单位存活, 获取咲夜现存飞刀, 播放咲夜坐标音效 } from "./01．飞刀与时间工具";
import { 设置十六夜咲夜符卡书冷却 } from "./符卡公共";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 执行战斗自身传送到坐标 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制") as {
  执行战斗自身传送到坐标: (this: void, unit: any, x: number, y: number) => boolean;
};

interface RA监听上下文 { 占位: boolean; }
interface RA冻结记录 { 单位: any; }
interface RA施法上下文 {
  施法者: any;
  来源: string;
  冻结单位: RA冻结记录[];
  已结束: boolean;
  强化令牌: number;
}

const RA强化令牌表: Record<number, number | undefined> = {};
let RA强化令牌自增 = 0;

export function 十六夜咲夜处于RA强化(this: void, caster: any): boolean {
  if (caster == null || caster === 0) return false;
  return RA强化令牌表[jass.GetHandleId(caster) as number] != null;
}

function 获取RA监听上下文(this: void, _caster: any): RA监听上下文 { return { 占位: true }; }

function 枚举范围单位(this: void, caster: any, x: number, y: number, radius: number): any[] {
  const result: any[] = [];
  const group = jass.CreateGroup();
  jass.GroupEnumUnitsInRange(group, x, y, radius, null);
  while (true) {
    const unit = jass.FirstOfGroup(group);
    if (unit == null || unit === 0) break;
    jass.GroupRemoveUnit(group, unit);
    if (unit !== caster && 单位存活(unit) && !jass.IsUnitType(unit, jass.UNIT_TYPE_TAUREN)) result.push(unit);
  }
  jass.DestroyGroup(group);
  return result;
}

function 结束RA(this: void, variable?: any): void {
  const context = variable as RA施法上下文 | undefined;
  if (context == null || context.已结束) return;
  context.已结束 = true;
  const casterId = jass.GetHandleId(context.施法者) as number;
  if (RA强化令牌表[casterId] === context.强化令牌) delete RA强化令牌表[casterId];
  for (let i = 0; i < context.冻结单位.length; i++) 移除单位暂停(context.冻结单位[i].单位, context.来源);
  播放咲夜坐标音效("gg_snd_IzayoiSakuya_RA", jass.GetUnitX(context.施法者), jass.GetUnitY(context.施法者));
}

function 释放十六夜咲夜RA(this: void, _listener: RA监听上下文, caster: any, 技能实例ID?: number): void {
  设置十六夜咲夜符卡书冷却(caster, 配置.符卡间隔秒.RA);
  const startX = jass.GetUnitX(caster) as number;
  const startY = jass.GetUnitY(caster) as number;
  const targetX = jass.GetSpellTargetX() as number;
  const targetY = jass.GetSpellTargetY() as number;
  const angle = 两点角度(startX, startY, targetX, targetY);
  const dx = targetX - startX;
  const dy = targetY - startY;
  const targetDistance = jass.SquareRoot(dx * dx + dy * dy) as number;
  const moveDistance = Math.min(targetDistance, Math.min(配置.RA.基础位移 + jass.GetHeroAgi(caster, true) * 配置.RA.敏捷位移倍率, 配置.RA.最大位移));
  执行战斗自身传送到坐标(caster, 极坐标X(startX, moveDistance, angle), 极坐标Y(startY, moveDistance, angle));

  const source = `十六夜咲夜-RA:${技能实例ID ?? jass.GetHandleId(caster)}`;
  const frozen = 枚举范围单位(caster, startX, startY, 配置.RA.单位冻结半径);
  const records: RA冻结记录[] = [];
  for (let i = 0; i < frozen.length; i++) {
    添加单位暂停(frozen[i], source);
    records.push({ 单位: frozen[i] });
  }
  const knives = 获取咲夜现存飞刀(caster, startX, startY, 配置.RA.飞刀冻结半径);
  for (let i = 0; i < knives.length; i++) {
    const knife = knives[i];
    knife.设置角度(两点角度(jass.GetUnitX(knife.单位), jass.GetUnitY(knife.单位), targetX, targetY));
    knife.设置已飞行距离(Math.max(0, knife.取已飞行距离() - 配置.RA.返还飞行距离));
  }
  RA强化令牌自增 += 1;
  RA强化令牌表[jass.GetHandleId(caster) as number] = RA强化令牌自增;
  播放咲夜坐标音效("gg_snd_IzayoiSakuya_RA2", startX, startY);
  播放咲夜坐标音效("gg_snd_BlinkBirth1", startX, startY);
  addDelayedCallback(配置.RA.持续秒 * 1000, 结束RA, {
    施法者: caster,
    来源: source,
    冻结单位: records,
    已结束: false,
    强化令牌: RA强化令牌自增,
  } as RA施法上下文);
}

export function 注册十六夜咲夜RA(this: void): void {
  注册单位技能壳监听({
    名称: "十六夜咲夜-女仆秘技杀人玩偶（RA）",
    单位类型ID: 配置.英雄单位类型ID,
    技能ID: 配置.技能.RA.类型ID,
    获取或创建上下文: 获取RA监听上下文,
    释放技能: 释放十六夜咲夜RA,
    创建独立技能实例: false,
  });
}

注册十六夜咲夜RA();

export {};
