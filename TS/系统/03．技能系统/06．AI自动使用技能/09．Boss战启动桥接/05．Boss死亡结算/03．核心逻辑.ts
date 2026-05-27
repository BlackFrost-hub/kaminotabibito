/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

import type { Boss死亡全员奖励, Boss死亡击杀者奖励, Boss死亡结算配置, Boss死亡清理项, Boss死亡结算提示类型 } from "./00．类型";
import { Boss死亡结算配置表, Boss死亡结算提示文本表 } from "./02．Boss死亡结算配置表";
import { Boss死亡结算特殊逻辑标签 } from "./01．常量定义";

const { YDUserDataGetSafe, YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { YDUserDataClearTable } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataClearTable: (this: void, tableTypeName: string, tableKey: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { AddItemToStockBJ } = require("lib.扩展函数.BJ函数.03．物品与库存") as {
  AddItemToStockBJ: (this: void, whichItemId: number, whichUnit: any, currentStock: number, stockMax: number) => void;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { ModifyHeroStat, AddHeroXPSwapped, bj_HEROSTAT_STR, bj_HEROSTAT_AGI, bj_HEROSTAT_INT } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  ModifyHeroStat: (this: void, whichStat: number, whichHero: any, modifyMethod: number, value: number) => void;
  AddHeroXPSwapped: (this: void, xpToAdd: number, whichHero: any, showEyeCandy: boolean) => void;
  bj_HEROSTAT_STR: number;
  bj_HEROSTAT_AGI: number;
  bj_HEROSTAT_INT: number;
};
const { 增加英雄基础全属性 } = require("lib.扩展函数.自定义扩展函数.index") as {
  增加英雄基础全属性: (this: void, unit: any, value: number) => void;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { AdjustPlayerStateBJ } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  AdjustPlayerStateBJ: (delta: number, whichPlayer: any, whichPlayerState: any) => void;
};
const { 调整玩家属性 } = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具") as {
  调整玩家属性: (this: void, unit: any, attrName: string, delta: number) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const CreateItem = jass.CreateItem as (itemid: number, x: number, y: number) => any;
const CreateUnit = jass.CreateUnit as (id: any, unitid: number, x: number, y: number, face: number) => any;
const Player = jass.Player as (number: number) => any;
const ForGroup = jass.ForGroup as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass.GetEnumUnit as () => any;
const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;
const GetHeroLevel = jass.GetHeroLevel as (whichHero: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: number) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as number;
const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

const 攻击力属性ID = 1;
const BJ修改增加 = 0;

const 沙漠宝藏额外掉落候选 = ["炽热生物挂坠", "远古毒咒护符", "远古巫术项链", "远古血巫项链"] as const;

let 当前全员奖励: Boss死亡全员奖励 | undefined;
let 豺狼异变累计次数 = 0;

function 读取玩家英雄组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

function 取结算消息枚举(this: void, 提示类型: Boss死亡结算提示类型 | undefined): number {
  switch (提示类型) {
    case "UNITACQUIRED":
      return jglobals.bj_QUESTMESSAGE_UNITACQUIRED;
    case "ITEMACQUIRED":
      return jglobals.bj_QUESTMESSAGE_ITEMACQUIRED;
    case "COMPLETED":
      return jglobals.bj_QUESTMESSAGE_COMPLETED;
    case "ALWAYSHINT":
      return jglobals.bj_QUESTMESSAGE_ALWAYSHINT;
    case "WARNING":
      return jglobals.bj_QUESTMESSAGE_WARNING;
    case "UPDATED":
    default:
      return jglobals.bj_QUESTMESSAGE_UPDATED;
  }
}

function 发送Boss死亡结算提示(this: void, 配置: Boss死亡结算配置): void {
  if (配置.提示文本键 == null || 配置.提示文本键 === "") return;
  const 提示文本键 = 配置.提示文本键 as keyof typeof Boss死亡结算提示文本表;
  const 文本 = Boss死亡结算提示文本表[提示文本键];
  if (文本 == null) return;
  QuestMessageBJ(GetPlayersAll(), 取结算消息枚举(配置.提示类型), 文本);
}

function on发放Boss死亡全员奖励(this: void): void {
  const 英雄 = GetEnumUnit();
  const 奖励 = 当前全员奖励;
  if (英雄 == null || 英雄 === 0 || 奖励 == null) return;

  if (奖励.经验 != null && 奖励.经验 !== 0) AddHeroXPSwapped(奖励.经验, 英雄, true);
  if (奖励.基础全属性 != null && 奖励.基础全属性 !== 0) 增加英雄基础全属性(英雄, 奖励.基础全属性);
  if (奖励.力量 != null && 奖励.力量 !== 0) ModifyHeroStat(bj_HEROSTAT_STR, 英雄, BJ修改增加, 奖励.力量);
  if (奖励.敏捷 != null && 奖励.敏捷 !== 0) ModifyHeroStat(bj_HEROSTAT_AGI, 英雄, BJ修改增加, 奖励.敏捷);
  if (奖励.智力 != null && 奖励.智力 !== 0) ModifyHeroStat(bj_HEROSTAT_INT, 英雄, BJ修改增加, 奖励.智力);
  if (奖励.攻击力 != null && 奖励.攻击力 !== 0) SGSS_SetState(英雄, 攻击力属性ID, 奖励.攻击力);
  if (奖励.魔法恢复 != null && 奖励.魔法恢复 !== 0) 调整玩家属性(英雄, "魔法恢复", 奖励.魔法恢复);
  if (奖励.金币 != null && 奖励.金币 !== 0) {
    AdjustPlayerStateBJ(奖励.金币, GetOwningPlayer(英雄), jass.PLAYER_STATE_RESOURCE_GOLD as any);
  }
}

function 发放Boss死亡全员奖励(this: void, 奖励: Boss死亡全员奖励 | undefined): void {
  if (奖励 == null) return;
  当前全员奖励 = 奖励;
  const 玩家英雄组 = 读取玩家英雄组();
  if (玩家英雄组 != null && 玩家英雄组 !== 0) ForGroup(玩家英雄组, on发放Boss死亡全员奖励);
  当前全员奖励 = undefined;
}

function 发放Boss死亡击杀者奖励(this: void, 奖励: Boss死亡击杀者奖励 | undefined, 击杀者: any): void {
  if (奖励 == null || 击杀者 == null || 击杀者 === 0) return;

  if (奖励.金币 != null && 奖励.金币 !== 0) {
    AdjustPlayerStateBJ(奖励.金币, GetOwningPlayer(击杀者), jass.PLAYER_STATE_RESOURCE_GOLD as any);
  }

  if (奖励.物品名列表 == null || 奖励.物品名列表.length <= 0) return;
  const x = GetUnitX(击杀者);
  const y = GetUnitY(击杀者);
  for (let i = 0; i < 奖励.物品名列表.length; i++) {
    const 物品ID = stringToFourCCSafe(按名字反查物品ID(奖励.物品名列表[i]));
    if (物品ID > 0) CreateItem(物品ID, x, y);
  }
}

function 执行清理项(this: void, 清理项: Boss死亡清理项, Boss单位: any): void {
  if (清理项.表名 == null || 清理项.表名 === "") return;

  if (清理项.表名 === "当前Boss单位表") {
    if (Boss单位 == null || Boss单位 === 0) return;
    if (清理项.清理整表 === true || (清理项.字段名 == null && 清理项.键名 == null)) {
      YDUserDataClearTable("unit", Boss单位);
      return;
    }
    if (清理项.字段名 != null && 清理项.字段名 !== "") {
      YDUserDataClearSafe("unit", Boss单位, 清理项.字段名, 清理项.值类型名 ?? "unit");
    }
    return;
  }

  if (清理项.键名 == null || 清理项.键名 === "") return;
  YDUserDataClearSafe("string", 清理项.表名, 清理项.键名, 清理项.值类型名 ?? "unit");
}

function 执行Boss死亡清理(this: void, 配置: Boss死亡结算配置, Boss单位: any): void {
  const 清理列表 = 配置.清理列表;
  if (清理列表 == null || 清理列表.length <= 0) return;
  for (let i = 0; i < 清理列表.length; i++) 执行清理项(清理列表[i], Boss单位);
}

function 取Boss死亡位置(this: void, Boss单位: any, 击杀者: any): { x: number; y: number } {
  if (Boss单位 != null && Boss单位 !== 0) return { x: GetUnitX(Boss单位), y: GetUnitY(Boss单位) };
  if (击杀者 != null && 击杀者 !== 0) return { x: GetUnitX(击杀者), y: GetUnitY(击杀者) };
  return { x: 0, y: 0 };
}

function 掉落固定物品(this: void, 配置: Boss死亡结算配置, Boss单位: any, 击杀者: any): void {
  const 物品列表 = 配置.固定掉落物品名列表;
  if (物品列表 == null || 物品列表.length <= 0) return;
  const 位置 = 取Boss死亡位置(Boss单位, 击杀者);
  for (let i = 0; i < 物品列表.length; i++) {
    const 物品ID = stringToFourCCSafe(按名字反查物品ID(物品列表[i]));
    if (物品ID > 0) CreateItem(物品ID, 位置.x, 位置.y);
  }
}

function 创建Boss死亡宝箱(this: void, 配置: Boss死亡结算配置, Boss单位: any, 击杀者: any): any {
  if (配置.宝箱单位ID == null || 配置.宝箱单位ID === "") return null;
  const 宝箱单位类型ID = stringToFourCCSafe(配置.宝箱单位ID);
  if (宝箱单位类型ID <= 0) return null;
  const 位置 = 取Boss死亡位置(Boss单位, 击杀者);
  const 宝箱 = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 宝箱单位类型ID, 位置.x, 位置.y, 0);
  if (宝箱 == null || 宝箱 === 0) return null;

  const 库存列表 = 配置.宝箱库存物品名列表;
  if (库存列表 == null || 库存列表.length <= 0) return 宝箱;
  for (let i = 0; i < 库存列表.length; i++) {
    const 物品ID = stringToFourCCSafe(按名字反查物品ID(库存列表[i]));
    if (物品ID > 0) AddItemToStockBJ(物品ID, 宝箱, 1, 1);
  }
  return 宝箱;
}

function Boss死亡结算命中标签(this: void, 配置: Boss死亡结算配置, 标签: string): boolean {
  const 列表 = 配置.特殊逻辑标签;
  return 列表 != null && 列表.indexOf(标签) >= 0;
}

function 处理Boss死亡特殊逻辑前置(this: void, 配置: Boss死亡结算配置, 击杀者: any): boolean {
  if (Boss死亡结算命中标签(配置, Boss死亡结算特殊逻辑标签.豺狼异变累计)) {
    豺狼异变累计次数 += 1;
    if (豺狼异变累计次数 <= 1) return false;
  }

  if (Boss死亡结算命中标签(配置, Boss死亡结算特殊逻辑标签.沙漠宝藏击杀者非中立)) {
    if (击杀者 == null || 击杀者 === 0) return false;
    const 击杀者玩家 = GetOwningPlayer(击杀者);
    if (击杀者玩家 === Player(PLAYER_NEUTRAL_AGGRESSIVE)) return false;
  }

  if (Boss死亡结算命中标签(配置, Boss死亡结算特殊逻辑标签.嗜血兽人低等级击杀奖励)) {
    if (击杀者 == null || 击杀者 === 0 || IsUnitType(击杀者, UNIT_TYPE_HERO) !== true || GetHeroLevel(击杀者) > 17) {
      配置 = { ...配置, 全员奖励: undefined };
    }
  }

  return true;
}

function 处理Boss死亡特殊逻辑掉落(this: void, 配置: Boss死亡结算配置, Boss单位: any, 击杀者: any): void {
  if (!Boss死亡结算命中标签(配置, Boss死亡结算特殊逻辑标签.沙漠宝藏击杀者非中立)) return;

  const 位置 = 取Boss死亡位置(Boss单位, 击杀者);
  const 金币物品ID = stringToFourCCSafe(按名字反查物品ID("金币+600"));
  const 掉落次数 = GetRandomInt(15, 25);
  for (let i = 0; i < 掉落次数; i++) {
    if (金币物品ID > 0) CreateItem(金币物品ID, 位置.x, 位置.y);
  }

  const 候选 = 沙漠宝藏额外掉落候选[GetRandomInt(0, 沙漠宝藏额外掉落候选.length - 1)];
  const 额外物品ID = stringToFourCCSafe(按名字反查物品ID(候选));
  if (额外物品ID > 0) CreateItem(额外物品ID, 位置.x, 位置.y);
}

function 延迟执行Boss死亡奖励与提示(this: void, 配置: Boss死亡结算配置, 全员奖励: Boss死亡全员奖励 | undefined): void {
  if (全员奖励 != null) 发放Boss死亡全员奖励(全员奖励);
  发送Boss死亡结算提示(配置);
}

function 执行Boss死亡奖励与提示(this: void, 配置: Boss死亡结算配置, 击杀者: any): void {
  let 全员奖励 = 配置.全员奖励;

  if (Boss死亡结算命中标签(配置, Boss死亡结算特殊逻辑标签.嗜血兽人低等级击杀奖励)) {
    if (击杀者 == null || 击杀者 === 0 || IsUnitType(击杀者, UNIT_TYPE_HERO) !== true || GetHeroLevel(击杀者) > 17) {
      全员奖励 = undefined;
    }
  }

  if (配置.延迟提示秒数 != null && 配置.延迟提示秒数 > 0) {
    addDelayedCallback(配置.延迟提示秒数 * 1000, function onBoss死亡结算延迟回调(): void {
      延迟执行Boss死亡奖励与提示(配置, 全员奖励);
    });
    return;
  }

  延迟执行Boss死亡奖励与提示(配置, 全员奖励);
}

function 解析Boss单位(this: void, 配置: Boss死亡结算配置, Boss单位?: any): any {
  if (Boss单位 != null && Boss单位 !== 0) return Boss单位;
  if (配置.Boss引用键 == null || 配置.Boss引用键 === "") return null;
  const 点位 = 配置.Boss引用键.indexOf(".");
  if (点位 <= 0 || 点位 >= 配置.Boss引用键.length - 1) return null;
  const 表名 = 配置.Boss引用键.substring(0, 点位);
  const 键名 = 配置.Boss引用键.substring(点位 + 1);
  return YDUserDataGetSafe("string", 表名, 键名, "unit");
}

function 取单位名匹配原始ID(this: void, 单位名: string): number {
  const Boss原始ID = 按名字反查Boss单位ID(单位名);
  if (Boss原始ID != null && Boss原始ID !== "") return stringToFourCCSafe(Boss原始ID);
  const 总表原始ID = 按名字反查总单位ID(单位名);
  if (总表原始ID != null && 总表原始ID !== "") return stringToFourCCSafe(总表原始ID);
  return 0;
}

function Boss单位匹配配置(this: void, 配置: Boss死亡结算配置, Boss单位: any): boolean {
  if (Boss单位 == null || Boss单位 === 0) return false;

  if (配置.Boss引用键 != null && 配置.Boss引用键 !== "") {
    const 引用单位 = 解析Boss单位(配置);
    if (引用单位 != null && 引用单位 !== 0 && 引用单位 === Boss单位) return true;
  }

  const 单位类型ID = GetUnitTypeId(Boss单位);
  if (单位类型ID <= 0) return false;

  if (配置.Boss单位名 != null && 配置.Boss单位名 !== "") {
    return 取单位名匹配原始ID(配置.Boss单位名) === 单位类型ID;
  }

  const 名称列表 = 配置.Boss单位名列表;
  if (名称列表 == null || 名称列表.length <= 0) return false;
  for (let i = 0; i < 名称列表.length; i++) {
    if (取单位名匹配原始ID(名称列表[i]) === 单位类型ID) return true;
  }
  return false;
}

export function 获取Boss死亡结算配置(this: void, Boss单位: any): Boss死亡结算配置 | undefined {
  if (Boss单位 == null || Boss单位 === 0) return undefined;
  for (let i = 0; i < Boss死亡结算配置表.length; i++) {
    const 配置 = Boss死亡结算配置表[i];
    if (Boss单位匹配配置(配置, Boss单位)) return 配置;
  }
  return undefined;
}

export function 按结算键获取Boss死亡结算配置(this: void, 结算键: string): Boss死亡结算配置 | undefined {
  for (let i = 0; i < Boss死亡结算配置表.length; i++) {
    if (Boss死亡结算配置表[i].键 === 结算键) return Boss死亡结算配置表[i];
  }
  return undefined;
}

export function 执行Boss死亡结算(this: void, 配置: Boss死亡结算配置, Boss单位?: any, 击杀者?: any): boolean {
  const 运行Boss单位 = 解析Boss单位(配置, Boss单位);
  if (!处理Boss死亡特殊逻辑前置(配置, 击杀者)) return false;

  掉落固定物品(配置, 运行Boss单位, 击杀者);
  处理Boss死亡特殊逻辑掉落(配置, 运行Boss单位, 击杀者);
  创建Boss死亡宝箱(配置, 运行Boss单位, 击杀者);
  执行Boss死亡清理(配置, 运行Boss单位);
  发放Boss死亡击杀者奖励(配置.击杀者奖励, 击杀者);
  执行Boss死亡奖励与提示(配置, 击杀者);
  return true;
}

export function 尝试执行Boss死亡结算(this: void, Boss单位: any, 击杀者?: any): boolean {
  const 配置 = 获取Boss死亡结算配置(Boss单位);
  if (配置 == null) return false;
  return 执行Boss死亡结算(配置, Boss单位, 击杀者);
}
