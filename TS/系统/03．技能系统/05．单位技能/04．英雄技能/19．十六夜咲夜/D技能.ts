/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import {
  创建咲夜单位壳,
  安全移除单位壳,
  单位存活,
  播放咲夜单位音效,
  播放咲夜坐标音效,
  注册咲夜周期任务,
  移除咲夜周期任务,
} from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
// SetUnitLifePercentBJ 是 Blizzard.j 函数，从 BJ 函数库取（jass.common 取到的是 nil）
const { SetUnitLifePercentBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitLifePercentBJ: (this: void, unit: any, percent: number) => void;
};

const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetHandleId = jass.GetHandleId as (this: void, value: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (this: void, unit: any, red: number, green: number, blue: number, alpha: number) => void;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const UNIT_TYPE_TAUREN = jass.UNIT_TYPE_TAUREN as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;

interface D监听上下文 { 占位: boolean; }
interface D冻结记录 {
  单位: any;
  机械单位: boolean;
  冻结X: number;
  冻结Y: number;
}
interface D施法上下文 {
  施法者: any;
  世界单位: any;
  中心X: number;
  中心Y: number;
  来源: string;
  Tick: number;
  周期ID: number;
  已结束: boolean;
  枚举组: any;
  记录: Record<number, D冻结记录 | undefined>;
}

const D视觉冻结计数: Record<number, number | undefined> = {};

function 获取D监听上下文(this: void, _caster: any): D监听上下文 { return { 占位: true }; }

function 进入D视觉冻结(this: void, unit: any): void {
  const id = GetHandleId(unit);
  const count = D视觉冻结计数[id] ?? 0;
  D视觉冻结计数[id] = count + 1;
  if (count > 0) return;
  SetUnitTimeScale(unit, 0);
  SetUnitVertexColor(unit, 255, 255, 255, 配置.D.冻结透明度);
}

function 离开D视觉冻结(this: void, unit: any): void {
  const id = GetHandleId(unit);
  const count = D视觉冻结计数[id] ?? 0;
  if (count <= 1) {
    delete D视觉冻结计数[id];
    SetUnitTimeScale(unit, 1);
    SetUnitVertexColor(unit, 255, 255, 255, 255);
  } else {
    D视觉冻结计数[id] = count - 1;
  }
}

function 释放D冻结单位(this: void, context: D施法上下文, record: D冻结记录): void {
  移除单位暂停(record.单位, context.来源);
  离开D视觉冻结(record.单位);
  delete context.记录[GetHandleId(record.单位)];
}

function 结束D技能(this: void, context: D施法上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.周期ID !== 0) 移除咲夜周期任务(context.周期ID);
  context.周期ID = 0;
  for (const key in context.记录) {
    const record = context.记录[key as unknown as number];
    if (record != null) 释放D冻结单位(context, record);
  }
  if (context.枚举组 != null && context.枚举组 !== 0) jass.DestroyGroup(context.枚举组);
  context.枚举组 = null;
  安全移除单位壳(context.世界单位);
  播放咲夜坐标音效("gg_snd_BlinkBirth1", context.中心X, context.中心Y);
}

function 枚举D范围单位(this: void, context: D施法上下文): any[] {
  const group = context.枚举组;
  jass.GroupClear(group);
  jass.GroupEnumUnitsInRange(group, context.中心X, context.中心Y, 配置.D.半径, null);
  const result: any[] = [];
  while (true) {
    const unit = jass.FirstOfGroup(group);
    if (unit == null || unit === 0) break;
    jass.GroupRemoveUnit(group, unit);
    if (unit === context.施法者 || unit === context.世界单位) continue;
    if (!单位存活(unit) || IsUnitType(unit, UNIT_TYPE_TAUREN)) continue;
    result.push(unit);
  }
  return result;
}

function 推进D技能(this: void, variable?: any): void {
  const context = variable as D施法上下文 | undefined;
  if (context == null || context.已结束) return;
  if (!单位存活(context.施法者)) {
    结束D技能(context);
    return;
  }
  context.Tick += 1;
  const inside: Record<number, boolean | undefined> = {};
  const units = 枚举D范围单位(context);
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    const id = GetHandleId(unit);
    inside[id] = true;
    let record = context.记录[id];
    if (record == null) {
      const mechanical = IsUnitType(unit, UNIT_TYPE_MECHANICAL);
      record = { 单位: unit, 机械单位: mechanical, 冻结X: GetUnitX(unit), 冻结Y: GetUnitY(unit) };
      context.记录[id] = record;
      添加单位暂停(unit, context.来源);
      进入D视觉冻结(unit);
    }
    if (record.机械单位) {
      SetUnitX(unit, record.冻结X);
      SetUnitY(unit, record.冻结Y);
      if (!IsUnitEnemy(unit, GetOwningPlayer(context.施法者))) SetUnitLifePercentBJ(unit, 100);
    }
  }
  for (const key in context.记录) {
    const record = context.记录[key as unknown as number];
    if (record != null && inside[GetHandleId(record.单位)] !== true) 释放D冻结单位(context, record);
  }
  if (context.Tick >= 配置.D.持续Tick) 结束D技能(context);
}

function 释放十六夜咲夜D(this: void, _listener: D监听上下文, caster: any): void {
  const x = GetSpellTargetX();
  const y = GetSpellTargetY();
  const world = 创建咲夜单位壳(caster, 配置.单位壳.咲夜的世界, x, y, 0);
  if (world == null || world === 0) return;
  SetUnitScale(world, 配置.D.世界缩放, 配置.D.世界缩放, 配置.D.世界缩放);
  const context: D施法上下文 = {
    施法者: caster,
    世界单位: world,
    中心X: x,
    中心Y: y,
    来源: `十六夜咲夜-D:${GetHandleId(world)}`,
    Tick: 0,
    周期ID: 0,
    已结束: false,
    枚举组: jass.CreateGroup(),
    记录: {},
  };
  播放咲夜坐标音效("gg_snd_FlameStrikeTargetWaveNonLoop1", x, y);
  播放咲夜单位音效("gg_snd_IzayoiSakuya_D", caster);
  context.周期ID = 注册咲夜周期任务(配置.D.周期毫秒, 推进D技能, context);
}

export function 注册十六夜咲夜D(this: void): void {
  注册单位技能壳监听({
    名称: "十六夜咲夜-小夜特制秒表（D）",
    单位类型ID: 配置.英雄单位类型ID,
    技能ID: 配置.技能.D.类型ID,
    获取或创建上下文: 获取D监听上下文,
    释放技能: 释放十六夜咲夜D,
    创建独立技能实例: false,
  });
}

注册十六夜咲夜D();

export {};
