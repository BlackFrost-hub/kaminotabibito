/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { TransmissionFromUnitWithNameBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  TransmissionFromUnitWithNameBJ: (
    this: void,
    toForce: any,
    whichUnit: any,
    unitName: string,
    soundHandle: any,
    message: string,
    timeType: number,
    timeVal: number,
    wait: boolean,
  ) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { 发送头像提示给玩家, 发送单位提示给玩家, 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送头像提示给玩家: (this: void, targetPlayer: any, iconPath: string, text: string, duration?: number) => void;
  发送单位提示给玩家: (this: void, targetPlayer: any, sourceUnit: any, text: string, duration?: number) => void;
  广播单位提示: (this: void, sourceUnit: any, text: string, duration?: number) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import 主线剧情片段配置表 from "./01．剧情片段配置表";
import type { 剧情动作参数表, 剧情动作执行上下文 } from "../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度, 写入当前剧情动作上下文 } from "../00．剧情系统核心工具/01．剧情动作上下文";
import { 按名字给触发单位物品, 按原始ID给触发单位物品, 执行通用剧情动作, 读取语义单位引用, 设置玩家英雄组控制状态 } from "../00．剧情系统核心工具/06．剧情通用执行工具";
import { 注册剧情运行时单位, 清理剧情运行时单位 } from "../00．剧情系统核心工具/08．剧情运行时单位";
import { 启动剧情Boss战 } from "../00．剧情系统核心工具/11．剧情Boss战启动桥接";
import { 进入剧情电影模式, 退出剧情电影模式并恢复镜头 } from "../00．剧情系统核心工具/12．剧情电影镜头";
import { 执行剧情片段清理 } from "../00．剧情系统核心工具/13．剧情片段清理注册表";
import { 获取主线节点配置 } from "../00．剧情系统核心工具/09．主线节点配置";
import type { 剧情片段配置, 剧情步骤 } from "./00．剧情步骤类型";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerPlayer = jass.GetTriggerPlayer as (this: void) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, whichPlayer: any) => number;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (
  this: void,
  trig: any,
  whichPlayer: any,
  chatMessageToDetect: string,
  exactMatchOnly: boolean,
) => any;
const TriggerRegisterPlayerEvent = jass.TriggerRegisterPlayerEvent as (this: void, trig: any, whichPlayer: any, whichPlayerEvent: any) => any;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, whichType: any) => boolean;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;

const EVENT_PLAYER_END_CINEMATIC = jass.EVENT_PLAYER_END_CINEMATIC as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET as number;
const bj_QUESTMESSAGE_HINT = jglobals.bj_QUESTMESSAGE_HINT as number;
const bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED as number;

const 剧情播放器模块名 = "11．剧情系统-剧情步骤播放器";
const 默认广播头像路径 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp";
const 剧情ESC双击间隔毫秒 = 300;
const 当前剧情触发单位语义名 = "剧情.当前触发单位";

export interface 剧情播放器运行时 {
  当前片段ID?: string;
  当前步骤索引: number;
  当前倍速: number;
  是否正在播放: boolean;
  是否请求跳过: boolean;
  播放世代: number;
}

interface 剧情延迟任务 {
  到期时间毫秒: number;
  播放世代: number;
  类型: "下一步" | "绝对时间动作";
  动作ID?: string;
  参数?: Record<string, string | number | boolean>;
}

const 默认剧情播放器运行时: 剧情播放器运行时 = {
  当前步骤索引: 0,
  当前倍速: 1,
  是否正在播放: false,
  是否请求跳过: false,
  播放世代: 0,
};

const 剧情播放器运行时状态: 剧情播放器运行时 = { ...默认剧情播放器运行时 };
const 剧情ESC最近按下时间表: Record<number, number | undefined> = {};
let 当前片段: 剧情片段配置 | undefined;
let 已初始化剧情步骤播放器 = false;
const 剧情延迟任务列表: 剧情延迟任务[] = [];
let 剧情延迟任务扫描回调ID = 0;
let 执行主线剧情动作函数: ((动作ID: string, 参数: 剧情动作参数表) => void) | undefined;

const 第二三章友方NPC引用白名单: Record<string, true | undefined> = {
  "主线NPC.阿莫斯": true,
  "主线NPC.艾伦": true,
  "主线NPC.赤尾": true,
  "主线NPC.锻造区证人": true,
  "主线NPC.恶魔城领主": true,
  "主线NPC.菲尼克斯尔残响": true,
  "主线NPC.赫克提尔": true,
  "主线NPC.皇家禁卫": true,
  "主线NPC.克林姆德王": true,
  "主线NPC.里凡特": true,
  "主线NPC.耶提尔": true,
  "剧情运行时.封印核心奥斯特利一世": true,
};

export function 创建剧情播放器运行时(this: void): 剧情播放器运行时 {
  return { ...默认剧情播放器运行时 };
}

export function 查找主线剧情片段(this: void, 片段ID: string): 剧情片段配置 | undefined {
  for (let i = 0; i < 主线剧情片段配置表.length; i++) {
    const 片段 = 主线剧情片段配置表[i];
    if (片段.片段ID === 片段ID) return 片段;
  }
  return undefined;
}

function 计算步骤持续时间(this: void, seconds: number): number {
  const 倍速 = 剧情播放器运行时状态.当前倍速 > 0 ? 剧情播放器运行时状态.当前倍速 : 1;
  const result = seconds / 倍速;
  if (result < 0.03) return 0.03;
  return result;
}

function 安排下一步(this: void, delaySeconds: number): void {
  if (!剧情播放器运行时状态.是否正在播放) return;
  添加剧情延迟任务({
    到期时间毫秒: getServerTime() + 计算步骤持续时间(delaySeconds) * 1000,
    播放世代: 剧情播放器运行时状态.播放世代,
    类型: "下一步",
  });
}

function 完成第二三章友方NPC归属收尾(this: void, 片段: 剧情片段配置 | undefined): void {
  if (片段 == null) return;
  const 是第二章 = 片段.片段ID.indexOf("elven_city_") === 0 || 片段.片段ID === "elven_forest_gate_arrival";
  const 是第三章 = 片段.片段ID.indexOf("molten_realm_") === 0;
  if (!是第二章 && !是第三章) return;

  const 已处理引用: Record<string, true | undefined> = {};
  for (let i = 0; i < 片段.步骤列表.length; i++) {
    const 步骤 = 片段.步骤列表[i];
    if (步骤.type !== "dialog") continue;
    const 引用 = 步骤.说话者引用;
    if (引用 == null || 第二三章友方NPC引用白名单[引用] !== true || 已处理引用[引用] === true) continue;
    已处理引用[引用] = true;
    const unit = 读取语义单位引用(引用);
    if (unit == null || unit === 0 || IsUnitType(unit, UNIT_TYPE_DEAD) === true) continue;
    SetUnitOwner(unit, Player(6), true);
  }
}

function 结束当前剧情片段(this: void): void {
  const 片段ID = 剧情播放器运行时状态.当前片段ID ?? "";
  const 已完成片段 = 当前片段;
  const 播放世代 = 剧情播放器运行时状态.播放世代;
  剧情播放器运行时状态.是否正在播放 = false;
  剧情播放器运行时状态.是否请求跳过 = false;
  剧情播放器运行时状态.当前步骤索引 = 0;
  剧情播放器运行时状态.当前片段ID = undefined;
  当前片段 = undefined;
  清理剧情延迟任务(播放世代);
  清理剧情ESC按键状态();
  完成第二三章友方NPC归属收尾(已完成片段);
  执行剧情片段清理(片段ID);
  清理剧情运行时单位(当前剧情触发单位语义名);
  // 片段前置可能接管玩家英雄；正常结束和 Esc 跳过都必须释放该状态。
  设置玩家英雄组控制状态(false, false);
  退出剧情电影模式并恢复镜头();
  if (片段ID !== "") debugLogForce(剧情播放器模块名, "剧情片段结束", 片段ID);
}

function 安排绝对时间动作(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "runAction") return;
  const 参数 = 步骤.参数 ?? {};
  if (参数.挂点 !== "absoluteTime") return;

  const 时间秒 = typeof 参数.时间秒 === "number" ? 参数.时间秒 : Number(参数.时间秒) || 0;
  添加剧情延迟任务({
    到期时间毫秒: getServerTime() + 计算步骤持续时间(时间秒) * 1000,
    播放世代: 剧情播放器运行时状态.播放世代,
    类型: "绝对时间动作",
    动作ID: 步骤.动作ID,
    参数,
  });
}

function 获取执行主线剧情动作函数(this: void): (动作ID: string, 参数: 剧情动作参数表) => void {
  if (执行主线剧情动作函数 == null) {
    const 模块 = require("../00．剧情系统核心工具/04．主线剧情动作注册表") as {
      执行主线剧情动作: (动作ID: string, 参数: 剧情动作参数表) => void;
    };
    执行主线剧情动作函数 = 模块.执行主线剧情动作;
  }
  return 执行主线剧情动作函数;
}

function 执行剧情延迟任务(this: void, 上下文: 剧情延迟任务): void {
  if (!剧情播放器运行时状态.是否正在播放) return;
  if (上下文.播放世代 !== 剧情播放器运行时状态.播放世代) return;
  if (上下文.类型 === "下一步") {
    执行当前剧情步骤();
    return;
  }
  if (上下文.动作ID == null || 上下文.参数 == null) return;
  获取执行主线剧情动作函数()(上下文.动作ID, 上下文.参数);
}

function 尝试停止剧情延迟任务扫描(this: void): void {
  if (剧情延迟任务列表.length > 0 || 剧情延迟任务扫描回调ID === 0) return;
  removePeriodicCallback(剧情延迟任务扫描回调ID);
  剧情延迟任务扫描回调ID = 0;
}

function 清理剧情延迟任务(this: void, 播放世代: number): void {
  let 写入索引 = 0;
  for (let i = 0; i < 剧情延迟任务列表.length; i++) {
    const 任务 = 剧情延迟任务列表[i];
    if (任务.播放世代 === 播放世代) continue;
    剧情延迟任务列表[写入索引] = 任务;
    写入索引 += 1;
  }
  for (let i = 剧情延迟任务列表.length - 1; i >= 写入索引; i--) {
    剧情延迟任务列表.pop();
  }
  尝试停止剧情延迟任务扫描();
}

function on剧情延迟任务扫描(this: void): void {
  const 当前时间毫秒 = getServerTime();
  const 到期任务: 剧情延迟任务[] = [];
  let 写入索引 = 0;
  for (let i = 0; i < 剧情延迟任务列表.length; i++) {
    const 任务 = 剧情延迟任务列表[i];
    if (当前时间毫秒 >= 任务.到期时间毫秒) {
      到期任务.push(任务);
      continue;
    }
    剧情延迟任务列表[写入索引] = 任务;
    写入索引 += 1;
  }
  for (let i = 剧情延迟任务列表.length - 1; i >= 写入索引; i--) {
    剧情延迟任务列表.pop();
  }
  for (let i = 0; i < 到期任务.length; i++) {
    执行剧情延迟任务(到期任务[i]);
  }
  尝试停止剧情延迟任务扫描();
}

function 添加剧情延迟任务(this: void, 任务: 剧情延迟任务): void {
  剧情延迟任务列表.push(任务);
  if (剧情延迟任务扫描回调ID === 0) {
    剧情延迟任务扫描回调ID = addPeriodicCallback(10, on剧情延迟任务扫描);
  }
}

function 安排片段绝对时间动作(this: void, 片段: 剧情片段配置): void {
  for (let i = 0; i < 片段.步骤列表.length; i++) {
    安排绝对时间动作(片段.步骤列表[i]);
  }
}

function 执行对白步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "dialog") return;
  const 持续时间 = 步骤.持续时间 ?? 3;
  const 下一步延迟 = 步骤.原生电影阻塞 === false ? 0 : 持续时间;
  if (步骤.使用原生电影系统 === true) {
    const 说话者 = 步骤.说话者 ?? "系统";
    const 文本 = 步骤.文本;
    const 说话者单位 = 读取说话者单位(说话者, 步骤.说话者引用);
    if (步骤.原生对白自动开启电影模式 !== false) 进入剧情电影模式();
    TransmissionFromUnitWithNameBJ(
      GetPlayersAll(),
      说话者单位 != null && 说话者单位 !== 0 ? 说话者单位 : null,
      说话者,
      null,
      文本,
      bj_TIMETYPE_SET,
      计算步骤持续时间(持续时间),
      false,
    );
    剧情播放器运行时状态.当前步骤索引++;
    安排下一步(下一步延迟);
    return;
  }
  执行UIDialog步骤(步骤);
}

function 读取当前剧情触发单位(this: void): any {
  return YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
}

function 读取说话者单位(this: void, 说话者: string | undefined, 说话者引用: string | undefined): any {
  const 引用单位 = 读取单位引用(说话者引用);
  if (引用单位 != null && 引用单位 !== 0) return 引用单位;
  if (说话者 === "玩家") {
    const 触发单位 = 读取当前剧情触发单位();
    if (触发单位 != null && 触发单位 !== 0) return 触发单位;
  }
  if (说话者 != null && 说话者 !== "") {
    const 运行时单位 = 读取语义单位引用(`主线NPC.${说话者}`);
    if (运行时单位 != null && 运行时单位 !== 0) return 运行时单位;
    const 主线NPC单位 = YDUserDataGetSafe("string", "主线NPC", 说话者, "unit");
    if (主线NPC单位 != null && 主线NPC单位 !== 0) return 主线NPC单位;
    const Boss单位 = YDUserDataGetSafe("string", "Boss", 说话者, "unit");
    if (Boss单位 != null && Boss单位 !== 0) return Boss单位;
  }
  return null;
}

function 执行UIDialog步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "dialog") return;
  const 说话者 = 步骤.说话者 ?? "系统";
  const 文本 = 步骤.文本;
  const 持续时间 = 步骤.持续时间 ?? 3;
  const 持续时间毫秒 = 持续时间 * 1000;
  const 说话者单位 = 读取说话者单位(说话者, 步骤.说话者引用);
  if (说话者单位 != null && 说话者单位 !== 0) {
    for (let i = 0; i < 4; i++) {
      发送单位提示给玩家(Player(i), 说话者单位, 文本, 持续时间毫秒);
    }
  } else {
    for (let i = 0; i < 4; i++) {
      发送头像提示给玩家(Player(i), 默认广播头像路径, `${说话者}：${文本}`, 持续时间毫秒);
    }
  }
  剧情播放器运行时状态.当前步骤索引++;
  安排下一步(步骤.原生电影阻塞 === false ? 0 : 持续时间);
}

function 执行UI广播步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "broadcast") return;
  const 文本 = 步骤.文本;
  const 持续时间毫秒 = (步骤.持续时间 ?? 3) * 1000;
  const 来源单位 = 读取单位引用(步骤.来源单位引用);
  if (来源单位 != null && 来源单位 !== 0) {
    广播单位提示(来源单位, 文本, 持续时间毫秒);
    return;
  }
  const 头像路径 = 步骤.头像路径 ?? 默认广播头像路径;
  for (let i = 0; i < 4; i++) {
    发送头像提示给玩家(Player(i), 头像路径, 文本, 持续时间毫秒);
  }
}

function 广播剧情跳过提示(this: void): void {
  const 文本 = "|cffffff00『系统提示』：|r请在 |cffffcc000.3 秒|r 内连续按下两次 |cffffcc00ESC|r 跳过当前剧情。";
  for (let i = 0; i < 4; i++) {
    发送头像提示给玩家(Player(i), 默认广播头像路径, 文本, 3200);
  }
}

function 清理剧情ESC按键状态(this: void): void {
  for (const playerId in 剧情ESC最近按下时间表) {
    delete 剧情ESC最近按下时间表[Number(playerId)];
  }
}

function 执行广播步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "broadcast") return;
  const 持续时间 = 步骤.持续时间 ?? 3;
  if (步骤.广播渠道 === "ui") {
    执行UI广播步骤(步骤);
  } else {
    const 说话者 = 步骤.说话者 ?? "系统";
    TransmissionFromUnitWithNameBJ(GetPlayersAll(), null, 说话者, null, 步骤.文本, bj_TIMETYPE_SET, 计算步骤持续时间(持续时间), false);
  }
  剧情播放器运行时状态.当前步骤索引++;
  安排下一步(持续时间);
}

function 执行等待步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "wait") return;
  剧情播放器运行时状态.当前步骤索引++;
  安排下一步(步骤.持续时间);
}

function 执行自定义动作步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "runAction") return;
  const 参数 = 步骤.参数 ?? {};
  if (参数.挂点 === "absoluteTime") {
    剧情播放器运行时状态.当前步骤索引++;
    执行当前剧情步骤();
    return;
  }
      获取执行主线剧情动作函数()(步骤.动作ID, 参数);
  剧情播放器运行时状态.当前步骤索引++;
  执行当前剧情步骤();
}

function 读取单位引用(this: void, 引用: string | undefined): any {
  if (引用 == null || 引用 === "") return null;
  return 读取语义单位引用(引用);
}

function 执行Boss战启动步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "startBossFight") return;
  const bossUnit = 读取单位引用(步骤.Boss引用) ?? 读取单位引用((步骤 as any).Boss名 ? `Boss.${(步骤 as any).Boss名}` : undefined);
  启动剧情Boss战(bossUnit);
  剧情播放器运行时状态.当前步骤索引++;
  执行当前剧情步骤();
}

function 执行给物品步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "giveItem") return;
  const itemRawId = (步骤 as any).物品ID as string | undefined;
  const itemName = (步骤 as any).物品名 as string | undefined;
  if (itemRawId != null && itemRawId !== "") {
    按原始ID给触发单位物品(itemRawId);
  } else if (itemName != null && itemName !== "") {
    按名字给触发单位物品(itemName);
  }
  剧情播放器运行时状态.当前步骤索引++;
  执行当前剧情步骤();
}

function 执行跳过模式步骤逻辑(this: void, 步骤: 剧情步骤): void {
  // 旧配置未填写时保持执行；需要跳过的纯演出动作必须显式写 false。
  if (步骤.跳过也执行 === false) return;
  switch (步骤.type) {
    case "dialog":
    case "broadcast":
    case "wait":
      return;
    case "runAction":
      获取执行主线剧情动作函数()(步骤.动作ID, 步骤.参数 ?? {});
      return;
    case "startBossFight": {
      const bossUnit = 读取单位引用(步骤.Boss引用) ?? 读取单位引用((步骤 as any).Boss名 ? `Boss.${(步骤 as any).Boss名}` : undefined);
      启动剧情Boss战(bossUnit);
      return;
    }
    case "giveItem": {
      const itemRawId = (步骤 as any).物品ID as string | undefined;
      const itemName = (步骤 as any).物品名 as string | undefined;
      if (itemRawId != null && itemRawId !== "") {
        按原始ID给触发单位物品(itemRawId);
      } else if (itemName != null && itemName !== "") {
        按名字给触发单位物品(itemName);
      }
      return;
    }
    default:
      执行通用剧情动作((步骤 as any).参数 ?? {});
      return;
  }
}

function 快进执行当前片段剩余逻辑(this: void): void {
  if (当前片段 == null) return;
  for (let i = 剧情播放器运行时状态.当前步骤索引; i < 当前片段.步骤列表.length; i++) {
    执行跳过模式步骤逻辑(当前片段.步骤列表[i]);
  }
}

function 发送跳过后的主线引导(this: void): void {
  const 节点 = 获取主线节点配置(读取剧情进度());
  if (节点 == null || 节点.提示文本 === "") return;
  QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, 节点.提示文本);
}

function 执行当前剧情步骤(this: void): void {
  if (!剧情播放器运行时状态.是否正在播放 || 当前片段 == null) return;
  if (剧情播放器运行时状态.是否请求跳过) {
    结束当前剧情片段();
    return;
  }

  if (剧情播放器运行时状态.当前步骤索引 >= 当前片段.步骤列表.length) {
    结束当前剧情片段();
    return;
  }

  const 步骤 = 当前片段.步骤列表[剧情播放器运行时状态.当前步骤索引];
  switch (步骤.type) {
    case "dialog":
      执行对白步骤(步骤);
      return;
    case "broadcast":
      执行广播步骤(步骤);
      return;
    case "wait":
      执行等待步骤(步骤);
      return;
    case "runAction":
      执行自定义动作步骤(步骤);
      return;
    case "startBossFight":
      执行Boss战启动步骤(步骤);
      return;
    case "giveItem":
      执行给物品步骤(步骤);
      return;
    default:
      执行通用剧情动作((步骤 as any).参数 ?? {});
      剧情播放器运行时状态.当前步骤索引++;
      执行当前剧情步骤();
      return;
  }
}

export function 播放主线剧情片段(this: void, 片段ID: string, 上下文?: 剧情动作执行上下文): boolean {
  const 片段 = 查找主线剧情片段(片段ID);
  if (片段 == null) {
    debugLogForce(剧情播放器模块名, "找不到剧情片段", 片段ID);
    return false;
  }
  if (剧情播放器运行时状态.是否正在播放) {
    debugLogForce(剧情播放器模块名, "已有剧情播放中，跳过", 片段ID);
    return false;
  }

  清理剧情运行时单位(当前剧情触发单位语义名);
  if (上下文 != null) {
    写入当前剧情动作上下文(上下文);
    if (上下文.触发单位 != null && 上下文.触发单位 !== 0) {
      注册剧情运行时单位(当前剧情触发单位语义名, 上下文.触发单位);
    }
  }
  当前片段 = 片段;
  剧情播放器运行时状态.播放世代++;
  剧情播放器运行时状态.当前片段ID = 片段ID;
  剧情播放器运行时状态.当前步骤索引 = 0;
  剧情播放器运行时状态.当前倍速 = 片段.默认倍速 ?? 1;
  剧情播放器运行时状态.是否正在播放 = true;
  剧情播放器运行时状态.是否请求跳过 = false;
  if (片段.可Esc整段跳过 === true) {
    广播剧情跳过提示();
  }
  安排片段绝对时间动作(片段);
  debugLogForce(剧情播放器模块名, "播放剧情片段", 片段ID, "steps=", 片段.步骤列表.length);
  执行当前剧情步骤();
  return true;
}

function on剧情ESC跳过(this: void): void {
  if (!剧情播放器运行时状态.是否正在播放 || 当前片段 == null) return;
  const 当前步骤 = 当前片段.步骤列表[剧情播放器运行时状态.当前步骤索引];
  if (当前步骤?.可跳过 === false || (当前片段.可Esc整段跳过 !== true && 当前步骤?.可跳过 !== true)) return;

  const player = GetTriggerPlayer();
  if (player == null || player === 0) return;
  const playerId = GetPlayerId(player);
  const now = getServerTime();
  const lastPressTime = 剧情ESC最近按下时间表[playerId];
  if (lastPressTime == null || now - lastPressTime > 剧情ESC双击间隔毫秒 || now < lastPressTime) {
    剧情ESC最近按下时间表[playerId] = now;
    QuestMessageBJ(
      GetPlayersAll(),
      bj_QUESTMESSAGE_HINT,
      "|cffffff00『系统提示』：|r已检测到第一次 |cffffcc00ESC|r，请在 |cffffcc000.3 秒|r 内再按一次跳过。",
    );
    return;
  }

  delete 剧情ESC最近按下时间表[playerId];
  剧情播放器运行时状态.是否请求跳过 = true;
  QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_HINT, "|cffffff00『系统提示』：|r已跳过当前剧情。");
  快进执行当前片段剩余逻辑();
  发送跳过后的主线引导();
  结束当前剧情片段();
}

function on剧情二倍速命令(this: void): void {
  const player = GetTriggerPlayer();
  if (player == null || player === 0) return;
  if (!剧情播放器运行时状态.是否正在播放) return;
  剧情播放器运行时状态.当前倍速 = 2;
  QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_HINT, "|cffffff00『系统提示』：|r当前剧情已切换为 2 倍速。");
}

function 注册剧情播放器输入事件(this: void): void {
  const escTrigger = CreateTrigger();
  const speedTrigger = CreateTrigger();
  for (let i = 0; i < 8; i++) {
    TriggerRegisterPlayerEvent(escTrigger, Player(i), EVENT_PLAYER_END_CINEMATIC);
    TriggerRegisterPlayerChatEvent(speedTrigger, Player(i), "-2", true);
  }
  TriggerAddAction(escTrigger, on剧情ESC跳过);
  TriggerAddAction(speedTrigger, on剧情二倍速命令);
}

export function 初始化剧情步骤播放器(this: void): void {
  if (已初始化剧情步骤播放器) return;
  已初始化剧情步骤播放器 = true;
  void 主线剧情片段配置表;
  注册剧情播放器输入事件();
}
