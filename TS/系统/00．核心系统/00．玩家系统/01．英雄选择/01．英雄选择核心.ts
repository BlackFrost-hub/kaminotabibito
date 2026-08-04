/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const centerTimer = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getGameElapsedTime: (this: void) => number;
};
const selectionCenter = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  initPlayerSelectionCenter: (this: void, whichPlayer: any) => void;
  addSelectionListener: (this: void, listener: (player: any, playerId: number, unit: any, isSelected: boolean) => void) => void;
};
const bridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  initPlayerHeroGetBridge?: (this: void) => void;
  directRegisterPlayerHero: (this: void, whichPlayer: any, whichHero: any) => void;
};
const ydSafe = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { ModifyHeroSkillPoints } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  ModifyHeroSkillPoints: (this: void, whichHero: any, modifyMethod: number, value: number) => boolean;
};
const { RectContainsUnit: RectContainsUnitBJ } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  RectContainsUnit: (this: void, whichRect: any, whichUnit: any) => boolean;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查技能ID } = require("系统.03．技能系统.08．技能数据表.01．技能名反查") as {
  按名字反查技能ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};

import 英雄选择配置表, { 英雄选择配置 } from "./00．英雄选择配置表";

const GroupAddUnit = jass.GroupAddUnit as (whichGroup: any, whichUnit: any) => void;
const GetRectCenterX = jass.GetRectCenterX as (whichRect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (whichRect: any) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (whichPlayer: any, x: number, y: number, duration: number, message: string) => void;
const initPlayerHeroGetBridge = bridge.initPlayerHeroGetBridge;
const directRegisterPlayerHero = bridge.directRegisterPlayerHero;

const 默认英雄禁用技能原始ID = "Ane2";
const 默认BB单位原始ID = "ewsp";
const 英雄选择轮询间隔毫秒 = 50;

function 获取句柄ID(this: void, 句柄: any): number {
  if (句柄 == null || 句柄 === 0 || typeof jass.GetHandleId !== "function") return 0;
  return jass.GetHandleId(句柄);
}

export type 英雄选择状态 = {
  是否已初始化: boolean;
  是否已关闭: boolean;
  已确认玩家数: number;
  正在等待二击确认玩家数: number;
};

export type 英雄选择已确认单位 = {
  英雄: any;
  BB?: any;
};

const 当前状态: 英雄选择状态 = {
  是否已初始化: false,
  是否已关闭: false,
  已确认玩家数: 0,
  正在等待二击确认玩家数: 0,
};

const 点击次数过期时间表: Record<number, number[]> = {};
let 点击次数轮询ID: number | undefined;
let 英雄注册桥接已初始化 = false;

/**
 * 迁移设计说明：
 * 1. 入口改为“玩家选中单位事件中心”，不再直接依赖 EVENT_PLAYER_UNIT_SELECTED 的旧触发。
 * 2. 确认英雄后，直接调用 `directRegisterPlayerHero`。
 * 3. 不再依赖 STES 的“玩家英雄注册”桥接。
 * 4. 旧 JASS 里那批 `TriggerRegisterUnitEvent` 必须保留，确认英雄后仍按配置表原生注册。
 * 5. `TriggerExecute(gg_trg__u)` 也保持原样执行，不追溯其来源。
 */

export function 获取英雄选择配置(this: void): 英雄选择配置 {
  return 英雄选择配置表;
}

export function 获取英雄选择状态(this: void): 英雄选择状态 {
  return 当前状态;
}

function 获取旧触发对象(this: void, 旧触发名: string): any {
  return (jglobals as Record<string, any>)[旧触发名];
}

function 获取原生单位事件(this: void, 事件名: string): any {
  return (jass as Record<string, any>)[事件名];
}

function 获取注册目标单位(this: void, 已确认单位: 英雄选择已确认单位, 目标单位: "英雄" | "BB"): any {
  if (目标单位 === "BB") return 已确认单位.BB;
  return 已确认单位.英雄;
}

export function 注册英雄选择旧单位事件(this: void, 已确认单位: 英雄选择已确认单位): number {
  let 已注册数量 = 0;
  const 注册项列表 = 英雄选择配置表.必须保留的旧单位事件注册项;
  for (let i = 0; i < 注册项列表.length; i++) {
    const 注册项 = 注册项列表[i];
    const 目标单位 = 获取注册目标单位(已确认单位, 注册项.目标单位);
    const 旧触发 = 获取旧触发对象(注册项.旧触发名);
    const 原生事件 = 获取原生单位事件(注册项.事件名);
    if (目标单位 == null || 目标单位 === 0) {
      continue;
    }
    if (旧触发 == null || 旧触发 === 0) {
      continue;
    }
    if (原生事件 == null) {
      continue;
    }
    jass.TriggerRegisterUnitEvent(旧触发, 目标单位, 原生事件);
    已注册数量++;
  }
  return 已注册数量;
}

function 当前游戏毫秒(this: void): number {
  return Number(centerTimer.getGameElapsedTime()) * 1000;
}

function 获取点击次数(this: void, 玩家: any): number {
  return Number(ydSafe.YDUserDataGetSafe("player", 玩家, 英雄选择配置表.英雄点击次数键, "real")) || 0;
}

function 设置点击次数(this: void, 玩家: any, 值: number): void {
  ydSafe.YDUserDataSetSafe("player", 玩家, 英雄选择配置表.英雄点击次数键, "real", 值);
}

function 增加点击次数(this: void, 玩家: any): number {
  const 新值 = 获取点击次数(玩家) + 1;
  设置点击次数(玩家, 新值);
  return 新值;
}

function 减少点击次数(this: void, 玩家: any): number {
  const 当前值 = 获取点击次数(玩家);
  const 新值 = 当前值 > 0 ? 当前值 - 1 : 0;
  设置点击次数(玩家, 新值);
  return 新值;
}

function 清空点击次数(this: void, 玩家: any): void {
  ydSafe.YDUserDataClearSafe("player", 玩家, 英雄选择配置表.英雄点击次数键, "real");
}

function 更新等待确认玩家数(this: void): void {
  let 数量 = 0;
  for (let i = 0; i < 英雄选择配置表.可选玩家ID列表.length; i++) {
    const 玩家ID = 英雄选择配置表.可选玩家ID列表[i];
    const 过期列表 = 点击次数过期时间表[玩家ID];
    if (过期列表 != null && 过期列表.length > 0) {
      数量++;
    }
  }
  当前状态.正在等待二击确认玩家数 = 数量;
}

function 停止点击次数轮询(this: void): void {
  if (点击次数轮询ID == null) return;
  centerTimer.removePeriodicCallback(点击次数轮询ID);
  点击次数轮询ID = undefined;
}

function 轮询点击次数衰减(this: void): void {
  const 现在毫秒 = 当前游戏毫秒();
  let 仍有待处理任务 = false;

  for (let i = 0; i < 英雄选择配置表.可选玩家ID列表.length; i++) {
    const 玩家ID = 英雄选择配置表.可选玩家ID列表[i];
    const 过期列表 = 点击次数过期时间表[玩家ID];
    if (过期列表 == null || 过期列表.length <= 0) continue;

    while (过期列表.length > 0 && 过期列表[0] <= 现在毫秒) {
      const 过期时间 = 过期列表[0];
      过期列表.shift();
      const 衰减后次数 = 减少点击次数(jass.Player(玩家ID));
    }
    if (过期列表.length > 0) 仍有待处理任务 = true;
  }

  更新等待确认玩家数();
  if (!仍有待处理任务) {
    停止点击次数轮询();
  }
}

function 确保点击次数轮询已启动(this: void): void {
  if (点击次数轮询ID != null) {
    return;
  }
  点击次数轮询ID = centerTimer.addPeriodicCallback(英雄选择轮询间隔毫秒, 轮询点击次数衰减);
}

function 记录一次点击确认窗口(this: void, 玩家: any): void {
  const 玩家ID = jass.GetPlayerId(玩家);
  const 过期时间 = 当前游戏毫秒() + 英雄选择配置表.双击确认窗口秒数 * 1000;
  let 列表 = 点击次数过期时间表[玩家ID];
  if (列表 == null) {
    列表 = [];
    点击次数过期时间表[玩家ID] = 列表;
  }
  列表.push(过期时间);
  const 新点击次数 = 增加点击次数(玩家);
  更新等待确认玩家数();
  确保点击次数轮询已启动();
}

function 是可选玩家(this: void, 玩家ID: number): boolean {
  return 英雄选择配置表.可选玩家ID列表.indexOf(玩家ID) >= 0;
}

function 获取配置矩形(this: void, 全局名: string): any {
  return (jglobals as Record<string, any>)[全局名];
}

function 是英雄选择区域内单位(this: void, 单位: any): boolean {
  const 选择区域 = 获取配置矩形(英雄选择配置表.选择区域全局名);
  if (选择区域 == null || 选择区域 === 0) return false;
  return RectContainsUnitBJ(选择区域, 单位) === true;
}

function 玩家是否已选择英雄(this: void, 玩家: any): boolean {
  return ydSafe.YDUserDataGetSafe("player", 玩家, 英雄选择配置表.英雄已选择标记键, "boolean") === true;
}

function 解析技能类型ID(this: void, 技能名: string | undefined): number {
  const 原始ID = 技能名 == null ? undefined : 按名字反查技能ID(技能名);
  if (原始ID != null && 原始ID !== "") {
    return stringToFourCCSafe(原始ID);
  }
  return stringToFourCCSafe(默认英雄禁用技能原始ID);
}

function 解析单位类型ID(this: void, 单位名: string | undefined): number {
  const 原始ID = 单位名 == null ? undefined : 按名字反查总单位ID(单位名);
  if (原始ID != null && 原始ID !== "") {
    return stringToFourCCSafe(原始ID);
  }
  return stringToFourCCSafe(默认BB单位原始ID);
}

function 获取英雄出生点(this: void): { X: number; Y: number } | undefined {
  const 出生区域 = 获取配置矩形(英雄选择配置表.英雄出生区域全局名);
  if (出生区域 == null || 出生区域 === 0) return undefined;
  return {
    X: GetRectCenterX(出生区域),
    Y: GetRectCenterY(出生区域),
  };
}

function 写入玩家英雄名字符串(this: void, 玩家: any, 英雄: any): void {
  const 字符串数组 = (jglobals as any).udg_String as string[] | undefined;
  if (字符串数组 == null) return;
  const 索引 = jass.GetPlayerId(玩家) + 英雄选择配置表.玩家英雄名写入字符串数组偏移;
  字符串数组[索引] = jass.GetUnitName(英雄);
}

function 获取英雄单击介绍文本(this: void, 英雄: any): string | undefined {
  const 单位名 = jass.GetUnitName(英雄);
  return 英雄选择配置表.英雄单击介绍表[单位名];
}

function 显示英雄单击介绍(this: void, 玩家: any, 英雄: any): void {
  const 文本 = 获取英雄单击介绍文本(英雄);
  if (文本 == null || 文本 === "") {
    return;
  }
  DisplayTimedTextToPlayer(玩家, 0, 0, 英雄选择配置表.单击介绍显示秒数, 文本);
}

function 执行选择确认公共触发(this: void): void {
  const 触发名 = 英雄选择配置表.选择确认后直接执行触发名;
  if (触发名 == null || 触发名 === "") {
    return;
  }
  const 触发器 = 获取旧触发对象(触发名);
  if (触发器 == null || 触发器 === 0) {
    return;
  }
  if (typeof jass.TriggerExecute === "function") {
    jass.TriggerExecute(触发器);
  }
}

function 发送英雄确认公告(this: void, 玩家: any, 英雄: any): void {
  const 文本 = `${英雄选择配置表.英雄确认公告前缀}|cffffcc99『${jass.GetPlayerName(玩家)}』|r使用角色『${jass.GetUnitName(英雄)}』开始了旅途！`;
  QuestMessageBJ(GetPlayersAll(), jglobals.bj_QUESTMESSAGE_UPDATED as number, 文本);
}

function 确保英雄注册桥接已初始化(this: void): void {
  if (英雄注册桥接已初始化) {
    return;
  }
  if (typeof initPlayerHeroGetBridge === "function") {
    initPlayerHeroGetBridge();
  }
  英雄注册桥接已初始化 = true;
}

function 确认英雄选择(this: void, 玩家: any, 英雄: any): void {
  const 出生点 = 获取英雄出生点();
  if (出生点 == null) {
    return;
  }

  const BB单位类型ID = 解析单位类型ID(英雄选择配置表.BB单位名);
  const 禁用技能ID = 解析技能类型ID(英雄选择配置表.英雄禁用技能名);
  const 英雄组 = ydSafe.YDUserDataGetSafe("string", 英雄选择配置表.玩家英雄单位组表名, 英雄选择配置表.玩家英雄单位组键, "group");

  if (typeof ModifyHeroSkillPoints === "function") {
    ModifyHeroSkillPoints(英雄, jglobals.bj_MODIFYMETHOD_ADD as number, 1);
  }
  发送英雄确认公告(玩家, 英雄);

  if (禁用技能ID !== 0) {
    jass.UnitRemoveAbility(英雄, 禁用技能ID);
  }

  ydSafe.YDUserDataSetSafe("player", 玩家, 英雄选择配置表.英雄已选择标记键, "boolean", true);
  if (英雄组 != null && 英雄组 !== 0) {
    GroupAddUnit(英雄组, 英雄);
  }
  ydSafe.YDUserDataSetSafe("player", 玩家, "英雄", "unit", 英雄);
  jass.SetUnitOwner(英雄, 玩家, true);

  const BB = 创建单位并登记排泄安全(玩家, BB单位类型ID, 出生点.X, 出生点.Y, 0);
  ydSafe.YDUserDataSetSafe("player", 玩家, 英雄选择配置表.记录玩家BB键, "unit", BB);
  jass.SetUnitPosition(英雄, 出生点.X, 出生点.Y);
  StarOther_PanCameraToTimedForPlayer(玩家, 出生点.X, 出生点.Y, 0.5);
  写入玩家英雄名字符串(玩家, 英雄);

  注册英雄选择旧单位事件({ 英雄, BB });
  ydSafe.YDUserDataSetSafe("string", 英雄选择配置表.记录已选英雄表名, 英雄选择配置表.记录已选英雄键, "unit", 英雄);
  执行选择确认公共触发();
  确保英雄注册桥接已初始化();
  directRegisterPlayerHero(玩家, 英雄);

  当前状态.已确认玩家数 = 当前状态.已确认玩家数 + 1;
}

function 应忽略本次选择(this: void, 玩家: any, 玩家ID: number, 单位: any, isSelected: boolean): boolean {
  if (当前状态.是否已关闭) {
    return true;
  }
  if (isSelected !== true) {
    return true;
  }
  if (!是可选玩家(玩家ID)) {
    return true;
  }
  const 选择区域 = 获取配置矩形(英雄选择配置表.选择区域全局名);
  if (选择区域 == null || 选择区域 === 0) {
    return true;
  }
  if (!是英雄选择区域内单位(单位)) {
    return true;
  }
  if (jass.IsUnitType(单位, jass.UNIT_TYPE_HERO) !== true) {
    return true;
  }
  const 单位所有者 = jass.GetOwningPlayer(单位);
  const 中立被动玩家 = jass.Player(jass.PLAYER_NEUTRAL_PASSIVE);
  if (单位所有者 !== 中立被动玩家) {
    return true;
  }
  if (玩家是否已选择英雄(玩家)) {
    return true;
  }
  return false;
}

function on英雄选择事件(this: void, 玩家: any, 玩家ID: number, 单位: any, isSelected: boolean): void {
  if (应忽略本次选择(玩家, 玩家ID, 单位, isSelected)) return;

  const 当前点击次数 = 获取点击次数(玩家);
  if (当前点击次数 >= 1) {
    确认英雄选择(玩家, 单位);
    return;
  }

  显示英雄单击介绍(玩家, 单位);
  记录一次点击确认窗口(玩家);
}

function 关闭英雄选择系统(this: void): void {
  if (当前状态.是否已关闭) {
    return;
  }
  当前状态.是否已关闭 = true;

  for (let i = 0; i < 英雄选择配置表.可选玩家ID列表.length; i++) {
    const 玩家ID = 英雄选择配置表.可选玩家ID列表[i];
    const 玩家 = jass.Player(玩家ID);
    清空点击次数(玩家);
    delete 点击次数过期时间表[玩家ID];
  }

  更新等待确认玩家数();
  停止点击次数轮询();
  QuestMessageBJ(GetPlayersAll(), jglobals.bj_QUESTMESSAGE_ALWAYSHINT as number, 英雄选择配置表.选择系统关闭提示文本);
}

function 初始化选中事件中心(this: void): void {
  for (let i = 0; i < 英雄选择配置表.可选玩家ID列表.length; i++) {
    const 玩家ID = 英雄选择配置表.可选玩家ID列表[i];
    const 玩家 = jass.Player(玩家ID);
    selectionCenter.initPlayerSelectionCenter(玩家);
  }
  selectionCenter.addSelectionListener(on英雄选择事件);
}

export function 初始化英雄选择系统(this: void): void {
  if (当前状态.是否已初始化) {
    return;
  }
  当前状态.是否已初始化 = true;

  初始化选中事件中心();
  if (英雄选择配置表.选择系统关闭秒数 > 0) {
    centerTimer.addDelayedCallback(英雄选择配置表.选择系统关闭秒数 * 1000, 关闭英雄选择系统);
  }
}

export {};
