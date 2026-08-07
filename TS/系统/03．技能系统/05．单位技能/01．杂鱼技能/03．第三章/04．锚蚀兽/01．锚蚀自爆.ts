/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../00．封印守卫战公共/00．类型";
import { 锚蚀兽配置 } from "./00．配置";
import {
  单位处于硬控制,
  命令攻击目标,
  创建封印守卫战点特效,
  取单位X,
  取单位Y,
  取单位距离平方,
  读取单位攻击力,
  读取单位最大生命,
  读取封印守卫战敌人记录,
  读取封印守卫战核心,
  封印守卫战单位存活,
} from "../00．封印守卫战公共/01．共享";

const jass = require("jass.common") as any;
const { 开始充能, 停止单位充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, params: any) => number;
  停止单位充能: (this: void, unit: any) => boolean;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const KillUnit = jass.KillUnit as (this: void, unit: any) => void;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;

function 锚蚀兽仍在自爆范围(this: void, record: 封印守卫战敌人记录): boolean {
  const core = 读取封印守卫战核心();
  return 封印守卫战单位存活(core)
    && 取单位距离平方(record.单位, core) <= 锚蚀兽配置.自爆范围 * 锚蚀兽配置.自爆范围;
}

function on锚蚀兽充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "锚蚀兽" || record.充能ID !== chargeId) return;
  if (!锚蚀兽仍在自爆范围(record) || 单位处于硬控制(unit)) 停止单位充能(unit);
}

function on锚蚀兽充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "锚蚀兽" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  const core = 读取封印守卫战核心();
  if (!锚蚀兽仍在自爆范围(record) || !封印守卫战单位存活(core)) return;
  const damage = 读取单位最大生命(core) * 锚蚀兽配置.核心最大生命伤害比例
    + 读取单位攻击力(unit) * 锚蚀兽配置.自身攻击力伤害比例;
  创建封印守卫战点特效({
    模型路径: 锚蚀兽配置.自爆特效,
    X: 取单位X(unit),
    Y: 取单位Y(unit),
    Z: 0,
    缩放: 0.8,
    持续秒: 2,
  });
  造成单体技能伤害({
    来源: unit,
    目标: core,
    伤害: damage,
    伤害类型: DAMAGE_TYPE_NORMAL,
    来源类型: "单位技能",
    标签: "封印守卫战-锚蚀自爆",
    参与技能伤害加成: false,
  });
  KillUnit(unit);
}

function on锚蚀兽充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "锚蚀兽") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  if (reason !== "完成") record.下次技能毫秒 = getServerTime() + 锚蚀兽配置.失败重试毫秒;
}

function 开始锚蚀兽自爆(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.充能ID !== 0 || 单位处于硬控制(record.单位)) return false;
  const id = 开始充能(record.单位, {
    持续时间: 锚蚀兽配置.蓄力持续秒,
    强制硬直: true,
    显示进度条特效: true,
    周期回调间隔: 0.1,
    周期回调: on锚蚀兽充能周期,
    充能完成回调: on锚蚀兽充能完成,
    结束回调: on锚蚀兽充能结束,
  });
  record.充能ID = id;
  return id > 0;
}

export function 刷新锚蚀兽AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (record.充能ID !== 0 || 当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 锚蚀兽配置.AI刷新毫秒;
  const core = 读取封印守卫战核心();
  if (!封印守卫战单位存活(core)) return;
  record.当前目标 = core;
  if (取单位距离平方(record.单位, core) <= 锚蚀兽配置.自爆范围 * 锚蚀兽配置.自爆范围) {
    if (当前毫秒 >= record.下次技能毫秒) 开始锚蚀兽自爆(record);
    return;
  }
  命令攻击目标(record.单位, core);
}

export function 清理锚蚀兽机制(this: void, record: 封印守卫战敌人记录): void {
  if (record.充能ID !== 0 && 封印守卫战单位存活(record.单位)) 停止单位充能(record.单位);
  record.充能ID = 0;
}
