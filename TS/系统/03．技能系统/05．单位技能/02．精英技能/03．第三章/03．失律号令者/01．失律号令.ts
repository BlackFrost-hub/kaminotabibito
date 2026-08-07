/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/00．类型";
import { 失律号令者配置 } from "./00．配置";
import {
  单位处于硬控制,
  创建封印守卫战单位常驻特效,
  创建封印守卫战点特效,
  取单位X,
  取单位Y,
  取单位距离平方,
  读取封印守卫战敌人列表,
  读取封印守卫战敌人记录,
  读取封印守卫战核心,
  命令攻击目标,
  封印守卫战单位存活,
  销毁封印守卫战单位常驻特效,
} from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/01．共享";

const jass = require("jass.common") as any;
const { 开始充能, 停止单位充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, params: any) => number;
  停止单位充能: (this: void, unit: any) => boolean;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, propertyId: number, value: number) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 封印守卫战BuffID } = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战") as {
  封印守卫战BuffID: { 失律号令强化: string };
};

const GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed as (this: void, unit: any) => number;
const 移动速度属性ID = 9;
const 攻击速度属性ID = 10;
const 号令强化特效键 = "封印守卫战-失律号令强化";

function 清除单个号令强化(this: void, record: 封印守卫战敌人记录): void {
  if (record.号令属性已施加 && 封印守卫战单位存活(record.单位)) {
    SGSS_SetState(record.单位, 移动速度属性ID, -record.号令移动速度增量);
    SGSS_SetState(record.单位, 攻击速度属性ID, -失律号令者配置.攻击速度提高);
  }
  record.号令属性已施加 = false;
  record.号令结束毫秒 = 0;
  record.号令移动速度增量 = 0;
  销毁封印守卫战单位常驻特效(record.单位, 号令强化特效键);
  移除单位指定Buff(record.单位, 封印守卫战BuffID.失律号令强化);
}

function 施加单个号令强化(this: void, record: 封印守卫战敌人记录, 当前毫秒: number, sourceUnit: any): void {
  if (!record.号令属性已施加) {
    record.号令移动速度增量 = GetUnitDefaultMoveSpeed(record.单位) * 失律号令者配置.移动速度提高;
    SGSS_SetState(record.单位, 移动速度属性ID, record.号令移动速度增量);
    SGSS_SetState(record.单位, 攻击速度属性ID, 失律号令者配置.攻击速度提高);
    record.号令属性已施加 = true;
    创建封印守卫战单位常驻特效(record.单位, 失律号令者配置.强化特效, 号令强化特效键);
  }
  record.号令结束毫秒 = 当前毫秒 + 失律号令者配置.持续毫秒;
  registerManualBuff(
    record.单位,
    封印守卫战BuffID.失律号令强化,
    失律号令者配置.持续毫秒 / 1000,
    失律号令者配置.移动速度提高,
    {
      sourceUnit,
      effectSourceName: "失律号令者-失律号令",
      effectSourceType: "技能",
      effectValue2: 失律号令者配置.攻击速度提高,
    },
  );
}

function 释放失律号令(this: void, casterRecord: 封印守卫战敌人记录, 当前毫秒: number): number {
  const list = 读取封印守卫战敌人列表();
  let count = 0;
  for (let i = 0; i < list.length; i++) {
    const targetRecord = list[i];
    if (!封印守卫战单位存活(targetRecord.单位)) continue;
    if (取单位距离平方(casterRecord.单位, targetRecord.单位) > 失律号令者配置.号令范围 * 失律号令者配置.号令范围) continue;
    施加单个号令强化(targetRecord, 当前毫秒, casterRecord.单位);
    count += 1;
  }
  创建封印守卫战点特效({
    模型路径: 失律号令者配置.脉冲特效,
    X: 取单位X(casterRecord.单位),
    Y: 取单位Y(casterRecord.单位),
    Z: 0,
    缩放: 0.8,
    持续秒: 2,
  });
  return count;
}

function on失律号令充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "失律号令者" || record.充能ID !== chargeId) return;
  if (单位处于硬控制(unit)) 停止单位充能(unit);
}

function on失律号令充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "失律号令者" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  const now = getServerTime();
  释放失律号令(record, now);
  record.下次技能毫秒 = now + 失律号令者配置.技能冷却毫秒;
}

function on失律号令充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "失律号令者") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  if (reason !== "完成") record.下次技能毫秒 = getServerTime() + 失律号令者配置.技能冷却毫秒;
}

function 开始失律号令(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.充能ID !== 0 || 单位处于硬控制(record.单位)) return false;
  const id = 开始充能(record.单位, {
    持续时间: 失律号令者配置.引导持续秒,
    强制硬直: true,
    显示进度条特效: true,
    周期回调间隔: 0.1,
    周期回调: on失律号令充能周期,
    充能完成回调: on失律号令充能完成,
    结束回调: on失律号令充能结束,
  });
  record.充能ID = id;
  return id > 0;
}

export function 刷新全部号令强化(this: void, 当前毫秒: number): void {
  const list = 读取封印守卫战敌人列表();
  for (let i = 0; i < list.length; i++) {
    const record = list[i];
    if (record.号令属性已施加 && (!封印守卫战单位存活(record.单位) || 当前毫秒 >= record.号令结束毫秒)) {
      清除单个号令强化(record);
    }
  }
}

export function 修正失律号令减伤(this: void, context: any): number {
  const record = 读取封印守卫战敌人记录(context?.target);
  if (record == null || !record.号令属性已施加 || getServerTime() >= record.号令结束毫秒) return context.currentDamage;
  return context.currentDamage * (1 - 失律号令者配置.减伤比例);
}

export function 刷新失律号令者AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (record.充能ID !== 0 || 当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 失律号令者配置.AI刷新毫秒;
  if (当前毫秒 >= record.下次技能毫秒 && 开始失律号令(record)) return;
  const core = 读取封印守卫战核心();
  if (封印守卫战单位存活(core)) 命令攻击目标(record.单位, core);
}

export function 清理失律号令记录(this: void, record: 封印守卫战敌人记录): void {
  if (record.充能ID !== 0 && 封印守卫战单位存活(record.单位)) 停止单位充能(record.单位);
  record.充能ID = 0;
  清除单个号令强化(record);
}

export function 清理全部失律号令强化(this: void): void {
  const list = 读取封印守卫战敌人列表();
  for (let i = 0; i < list.length; i++) 清除单个号令强化(list[i]);
}
