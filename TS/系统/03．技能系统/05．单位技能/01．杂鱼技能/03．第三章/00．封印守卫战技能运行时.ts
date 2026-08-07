/** @noSelfInFile */

import type { 封印守卫战第三章技能环境, 封印守卫战敌人记录, 封印守卫战敌人类型 } from "./00．封印守卫战公共/00．类型";
import {
  创建封印守卫战敌人记录,
  封印守卫战第三章敌人单位ID,
  封印守卫战单位存活,
  清空封印守卫战敌人记录,
  读取封印守卫战敌人列表,
  读取封印守卫战敌人记录,
  移除封印守卫战敌人记录引用,
  设置封印守卫战第三章技能环境,
} from "./00．封印守卫战公共/01．共享";
import { 刷新失控英灵AI, 处理失控英灵普攻命中 } from "./02．失控英灵/01．缚魂斩";
import { 刷新夺灵祭司AI, 清理夺灵祭司机制 } from "./03．夺灵祭司/01．夺灵仪式";
import { 刷新锚蚀兽AI, 清理锚蚀兽机制 } from "./04．锚蚀兽/01．锚蚀自爆";
import {
  刷新断誓猎手AI,
  刷新断誓猎手核心压制,
  修正断誓猎手核心普攻,
  清理断誓猎手全局机制,
} from "./05．断誓猎手/01．断誓射猎";
import {
  刷新黑暗残响AI,
  清理全部黑暗残响弹幕,
  清理黑暗残响机制,
} from "../../02．精英技能/03．第三章/01．黑暗残响/01．暗影索敌";
import {
  初始化裂誓重卫机制,
  修正裂誓重卫减伤,
  刷新裂誓重卫AI,
  清理裂誓重卫机制,
} from "../../02．精英技能/03．第三章/02．裂誓重卫/01．裂誓壁垒";
import {
  修正失律号令减伤,
  刷新全部号令强化,
  刷新失律号令者AI,
  清理全部失律号令强化,
  清理失律号令记录,
} from "../../02．精英技能/03．第三章/03．失律号令者/01．失律号令";
import { 刷新潮蚀巡鳞者AI, 清理潮蚀巡鳞者机制 } from "./06．潮蚀巡鳞者/01．潮刃突袭";
import { 刷新碎礁投石手AI, 清理碎礁投石手机制 } from "../../02．精英技能/03．第三章/04．碎礁投石手/01．碎礁投掷";
import {
  刷新灵潮祭司AI,
  修正潮蚀护持减伤,
  清理灵潮祭司机制,
} from "../../02．精英技能/03．第三章/05．灵潮祭司/01．灵潮祷印";
import {
  刷新金鳞执刑官AI,
  修正重鳞护体减伤,
  清理金鳞执刑官机制,
} from "../../02．精英技能/03．第三章/06．金鳞执刑官/01．金鳞冲阵";
import {
  刷新深渊鳞将AI,
  清理深渊鳞将机制,
} from "../../02．精英技能/03．第三章/07．深渊鳞将/01．深渊回潮";

const jass = require("jass.common") as any;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const 技能运行时刷新毫秒 = 100;
const 伤害修正优先级 = 35;

let 运行时周期ID = 0;
let 伤害修正器ID = 0;
let 已注册最终伤害监听 = false;
let 运行时启动 = false;

function 解析封印守卫战敌人类型(this: void, unit: any): 封印守卫战敌人类型 | undefined {
  const typeId = GetUnitTypeId(unit);
  if (typeId === 封印守卫战第三章敌人单位ID.失控英灵) return "失控英灵";
  if (typeId === 封印守卫战第三章敌人单位ID.夺灵祭司) return "夺灵祭司";
  if (typeId === 封印守卫战第三章敌人单位ID.锚蚀兽) return "锚蚀兽";
  if (typeId === 封印守卫战第三章敌人单位ID.断誓猎手) return "断誓猎手";
  if (typeId === 封印守卫战第三章敌人单位ID.黑暗残响) return "黑暗残响";
  if (typeId === 封印守卫战第三章敌人单位ID.裂誓重卫) return "裂誓重卫";
  if (typeId === 封印守卫战第三章敌人单位ID.失律号令者) return "失律号令者";
  if (typeId === 封印守卫战第三章敌人单位ID.潮蚀巡鳞者) return "潮蚀巡鳞者";
  if (typeId === 封印守卫战第三章敌人单位ID.碎礁投石手) return "碎礁投石手";
  if (typeId === 封印守卫战第三章敌人单位ID.灵潮祭司) return "灵潮祭司";
  if (typeId === 封印守卫战第三章敌人单位ID.金鳞执刑官) return "金鳞执刑官";
  if (typeId === 封印守卫战第三章敌人单位ID.深渊鳞将) return "深渊鳞将";
  return undefined;
}

function 初始化封印守卫战敌人机制(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (record.类型 === "黑暗残响") record.下次技能毫秒 = 当前毫秒 + 1000;
  else if (record.类型 === "裂誓重卫") {
    record.下次技能毫秒 = 当前毫秒 + 1000;
    初始化裂誓重卫机制(record);
  } else if (record.类型 === "失律号令者") record.下次技能毫秒 = 当前毫秒 + 1500;
  else if (record.类型 === "潮蚀巡鳞者") record.下次技能毫秒 = 当前毫秒 + 800;
  else if (record.类型 === "碎礁投石手") record.下次技能毫秒 = 当前毫秒 + 1200;
  else if (record.类型 === "灵潮祭司") record.下次技能毫秒 = 当前毫秒 + 1200;
  else if (record.类型 === "金鳞执刑官") record.下次技能毫秒 = 当前毫秒 + 1000;
  else if (record.类型 === "深渊鳞将") record.下次技能毫秒 = 当前毫秒 + 1400;
}

function 清理封印守卫战敌人机制(this: void, record: 封印守卫战敌人记录): void {
  if (record.类型 === "夺灵祭司") 清理夺灵祭司机制(record);
  else if (record.类型 === "锚蚀兽") 清理锚蚀兽机制(record);
  else if (record.类型 === "黑暗残响") 清理黑暗残响机制(record);
  else if (record.类型 === "裂誓重卫") 清理裂誓重卫机制(record);
  else if (record.类型 === "失律号令者") 清理失律号令记录(record);
  else if (record.类型 === "潮蚀巡鳞者") 清理潮蚀巡鳞者机制(record);
  else if (record.类型 === "碎礁投石手") 清理碎礁投石手机制(record);
  else if (record.类型 === "灵潮祭司") 清理灵潮祭司机制(record);
  else if (record.类型 === "金鳞执刑官") 清理金鳞执刑官机制(record);
  else if (record.类型 === "深渊鳞将") 清理深渊鳞将机制(record);
  else if (record.号令属性已施加) 清理失律号令记录(record);
}

function 刷新单个封印守卫战敌人(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (record.类型 === "失控英灵") 刷新失控英灵AI(record, 当前毫秒);
  else if (record.类型 === "夺灵祭司") 刷新夺灵祭司AI(record, 当前毫秒);
  else if (record.类型 === "锚蚀兽") 刷新锚蚀兽AI(record, 当前毫秒);
  else if (record.类型 === "断誓猎手") 刷新断誓猎手AI(record, 当前毫秒);
  else if (record.类型 === "黑暗残响") 刷新黑暗残响AI(record, 当前毫秒);
  else if (record.类型 === "裂誓重卫") 刷新裂誓重卫AI(record, 当前毫秒);
  else if (record.类型 === "失律号令者") 刷新失律号令者AI(record, 当前毫秒);
  else if (record.类型 === "潮蚀巡鳞者") 刷新潮蚀巡鳞者AI(record, 当前毫秒);
  else if (record.类型 === "碎礁投石手") 刷新碎礁投石手AI(record, 当前毫秒);
  else if (record.类型 === "灵潮祭司") 刷新灵潮祭司AI(record, 当前毫秒);
  else if (record.类型 === "金鳞执刑官") 刷新金鳞执刑官AI(record, 当前毫秒);
  else if (record.类型 === "深渊鳞将") 刷新深渊鳞将AI(record, 当前毫秒);
}

function on封印守卫战第三章技能Tick(this: void): void {
  if (!运行时启动) return;
  const now = getServerTime();
  const list = 读取封印守卫战敌人列表();
  let index = 0;
  while (index < list.length) {
    const record = list[index];
    if (!封印守卫战单位存活(record.单位)) {
      清理封印守卫战敌人机制(record);
      移除封印守卫战敌人记录引用(record);
      continue;
    }
    刷新单个封印守卫战敌人(record, now);
    index += 1;
  }
  刷新断誓猎手核心压制(now);
  刷新全部号令强化(now);
}

function on封印守卫战第三章最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!运行时启动) return;
  const record = 读取封印守卫战敌人记录(attacker);
  if (record == null) return;
  if (record.类型 === "失控英灵") 处理失控英灵普攻命中(record, target, applied, snapshot, getServerTime());
}

function on封印守卫战第三章伤害修正(this: void, context: any): number {
  if (!运行时启动 || context == null) return context?.currentDamage ?? 0;
  let damage = context.currentDamage;
  const attackerRecord = 读取封印守卫战敌人记录(context.attacker);
  if (attackerRecord?.类型 === "断誓猎手") {
    context.currentDamage = damage;
    damage = 修正断誓猎手核心普攻(attackerRecord, context, getServerTime());
  }
  context.currentDamage = damage;
  damage = 修正裂誓重卫减伤(context);
  context.currentDamage = damage;
  damage = 修正失律号令减伤(context);
  context.currentDamage = damage;
  damage = 修正潮蚀护持减伤(context);
  context.currentDamage = damage;
  damage = 修正重鳞护体减伤(context);
  return damage;
}

function 确保封印守卫战第三章伤害入口(this: void): void {
  if (!已注册最终伤害监听) {
    registerAppliedFinalDamageListener(on封印守卫战第三章最终伤害);
    已注册最终伤害监听 = true;
  }
  if (伤害修正器ID === 0) 伤害修正器ID = registerDamageModifier(on封印守卫战第三章伤害修正, 伤害修正优先级);
}

export function 启动封印守卫战第三章敌人技能(
  this: void,
  环境: 封印守卫战第三章技能环境,
): boolean {
  if (环境 == null) return false;
  停止封印守卫战第三章敌人技能();
  设置封印守卫战第三章技能环境(环境);
  运行时启动 = true;
  确保封印守卫战第三章伤害入口();
  运行时周期ID = addPeriodicCallback(技能运行时刷新毫秒, on封印守卫战第三章技能Tick);
  return 运行时周期ID > 0;
}

export function 登记封印守卫战第三章敌人(this: void, unit: any): boolean {
  if (!运行时启动 || !封印守卫战单位存活(unit)) return false;
  const type = 解析封印守卫战敌人类型(unit);
  if (type == null) return false;
  const record = 创建封印守卫战敌人记录(unit, type, getServerTime());
  if (record == null) return false;
  初始化封印守卫战敌人机制(record, getServerTime());
  return true;
}

export function 注销封印守卫战第三章敌人(this: void, unit: any): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null) return;
  清理封印守卫战敌人机制(record);
  移除封印守卫战敌人记录引用(record);
}

export function 令封印守卫战敌人技能立即就绪(this: void, unit: any): boolean {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null) return false;
  record.下次技能毫秒 = 0;
  record.下次AI毫秒 = 0;
  return true;
}

export function 读取封印守卫战第三章敌人运行记录(this: void, unit: any): 封印守卫战敌人记录 | undefined {
  return 读取封印守卫战敌人记录(unit);
}

export function 停止封印守卫战第三章敌人技能(this: void): void {
  运行时启动 = false;
  if (运行时周期ID !== 0) removePeriodicCallback(运行时周期ID);
  运行时周期ID = 0;
  const list = 读取封印守卫战敌人列表();
  while (list.length > 0) {
    const record = list[list.length - 1];
    清理封印守卫战敌人机制(record);
    移除封印守卫战敌人记录引用(record);
  }
  清理全部黑暗残响弹幕();
  清理全部失律号令强化();
  清理断誓猎手全局机制();
  清空封印守卫战敌人记录();
  设置封印守卫战第三章技能环境(undefined);
  if (伤害修正器ID !== 0) unregisterDamageModifier(伤害修正器ID);
  伤害修正器ID = 0;
}
