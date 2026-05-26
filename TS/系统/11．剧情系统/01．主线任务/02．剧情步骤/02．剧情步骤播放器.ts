/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: (this: void) => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};
const { TransmissionFromUnitWithNameBJ, CinematicModeBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
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
  CinematicModeBJ: (this: void, cineMode: boolean, forForce: any) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 启动Boss战运行 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.03．Boss战运行驱动") as {
  启动Boss战运行: (this: void, bossUnit: any) => void;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.03．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import 主线剧情片段配置表 from "./01．剧情片段配置表";
import type { 剧情动作参数表, 剧情动作执行上下文 } from "../00．剧情系统核心工具/00．剧情动作类型";
import { 写入当前剧情动作上下文 } from "../00．剧情系统核心工具/01．剧情动作上下文";
import { 按名字给触发单位物品, 执行通用剧情动作 } from "../00．剧情系统核心工具/06．剧情通用执行工具";
import type { 剧情片段配置, 剧情步骤 } from "./00．剧情步骤类型";

const CreateTimer = jass.CreateTimer as (this: void) => any;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetExpiredTimer = jass.GetExpiredTimer as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetTriggerPlayer = jass.GetTriggerPlayer as (this: void) => any;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (
  this: void,
  trig: any,
  whichPlayer: any,
  chatMessageToDetect: string,
  exactMatchOnly: boolean,
) => any;
const TriggerRegisterPlayerEvent = jass.TriggerRegisterPlayerEvent as (this: void, trig: any, whichPlayer: any, whichPlayerEvent: any) => any;

const EVENT_PLAYER_END_CINEMATIC = jass.EVENT_PLAYER_END_CINEMATIC as any;
const bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET as number;
const bj_QUESTMESSAGE_HINT = jglobals.bj_QUESTMESSAGE_HINT as number;

const 剧情播放器模块名 = "11．剧情系统-剧情步骤播放器";
const Boss战表名 = "Boss战";
const Boss战绑定单位字段 = "绑定单位";
const Boss战触发玩家字段 = "触发玩家";

export interface 剧情播放器运行时 {
  当前片段ID?: string;
  当前步骤索引: number;
  当前倍速: number;
  是否正在播放: boolean;
  是否请求跳过: boolean;
  播放世代: number;
}

interface 剧情绝对时间动作上下文 {
  播放世代: number;
  动作ID: string;
  参数: Record<string, string | number | boolean>;
}

const 默认剧情播放器运行时: 剧情播放器运行时 = {
  当前步骤索引: 0,
  当前倍速: 1,
  是否正在播放: false,
  是否请求跳过: false,
  播放世代: 0,
};

const 剧情播放器运行时状态: 剧情播放器运行时 = { ...默认剧情播放器运行时 };
let 当前片段: 剧情片段配置 | undefined;
let 已初始化剧情步骤播放器 = false;
const 绝对时间动作上下文表: Record<number, 剧情绝对时间动作上下文 | undefined> = {};
let 执行主线剧情动作函数: ((动作ID: string, 参数: 剧情动作参数表) => void) | undefined;

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
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;
  safeTimerStart(timer, 计算步骤持续时间(delaySeconds), false, on剧情下一步计时器到期);
}

function 结束当前剧情片段(this: void): void {
  const 片段ID = 剧情播放器运行时状态.当前片段ID ?? "";
  剧情播放器运行时状态.是否正在播放 = false;
  剧情播放器运行时状态.是否请求跳过 = false;
  剧情播放器运行时状态.当前步骤索引 = 0;
  剧情播放器运行时状态.当前片段ID = undefined;
  当前片段 = undefined;
  CinematicModeBJ(false, GetPlayersAll());
  if (片段ID !== "") debugLogForce(剧情播放器模块名, "剧情片段结束", 片段ID);
}

function on剧情下一步计时器到期(this: void): void {
  const timer = GetExpiredTimer();
  safeDestroyTimer(timer);
  执行当前剧情步骤();
}

function 安排绝对时间动作(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "runAction") return;
  const 参数 = 步骤.参数 ?? {};
  if (参数.挂点 !== "absoluteTime") return;

  const 时间秒 = typeof 参数.时间秒 === "number" ? 参数.时间秒 : Number(参数.时间秒) || 0;
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;

  const handleId = GetHandleId(timer);
  绝对时间动作上下文表[handleId] = {
    播放世代: 剧情播放器运行时状态.播放世代,
    动作ID: 步骤.动作ID,
    参数,
  };
  safeTimerStart(timer, 计算步骤持续时间(时间秒), false, on剧情绝对时间动作到期);
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

function on剧情绝对时间动作到期(this: void): void {
  const timer = GetExpiredTimer();
  const handleId = GetHandleId(timer);
  const 上下文 = 绝对时间动作上下文表[handleId];
  delete 绝对时间动作上下文表[handleId];
  safeDestroyTimer(timer);

  if (上下文 == null) return;
  if (!剧情播放器运行时状态.是否正在播放) return;
  if (上下文.播放世代 !== 剧情播放器运行时状态.播放世代) return;
  if (剧情播放器运行时状态.是否请求跳过) return;
  获取执行主线剧情动作函数()(上下文.动作ID, 上下文.参数);
}

function 安排片段绝对时间动作(this: void, 片段: 剧情片段配置): void {
  for (let i = 0; i < 片段.步骤列表.length; i++) {
    安排绝对时间动作(片段.步骤列表[i]);
  }
}

function 执行对白步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "dialog" && 步骤.type !== "broadcast") return;
  const 说话者 = 步骤.说话者 ?? "系统";
  const 文本 = 步骤.文本;
  const 持续时间 = 步骤.持续时间 ?? 3;
  TransmissionFromUnitWithNameBJ(GetPlayersAll(), null, 说话者, null, 文本, bj_TIMETYPE_SET, 计算步骤持续时间(持续时间), false);
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

function 读取YD单位引用(this: void, 引用: string | undefined): any {
  if (引用 == null || 引用 === "") return null;
  const splitIndex = 引用.indexOf(".");
  if (splitIndex < 0) return null;
  const tableName = 引用.substring(0, splitIndex);
  const keyName = 引用.substring(splitIndex + 1);
  if (tableName === "" || keyName === "") return null;
  return YDUserDataGetSafe("string", tableName, keyName, "unit");
}

function 执行Boss战启动步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "startBossFight") return;
  const bossUnit = 读取YD单位引用(步骤.Boss引用) ?? 读取YD单位引用((步骤 as any).Boss名 ? `Boss.${(步骤 as any).Boss名}` : undefined);
  if (bossUnit != null && bossUnit !== 0) {
    应用Boss战启动属性配置(bossUnit);
    YDUserDataSetSafe("string", Boss战表名, Boss战绑定单位字段, "unit", bossUnit);
    const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
    if (触发单位 != null && 触发单位 !== 0) {
      YDUserDataSetSafe("string", Boss战表名, Boss战触发玩家字段, "unit", 触发单位);
    }
    PauseUnit(bossUnit, false);
    SetUnitInvulnerable(bossUnit, false);
    启动Boss战运行(bossUnit);
  }
  剧情播放器运行时状态.当前步骤索引++;
  执行当前剧情步骤();
}

function 执行给物品步骤(this: void, 步骤: 剧情步骤): void {
  if (步骤.type !== "giveItem") return;
  const itemName = (步骤 as any).物品名 as string | undefined;
  if (itemName != null && itemName !== "") 按名字给触发单位物品(itemName);
  剧情播放器运行时状态.当前步骤索引++;
  执行当前剧情步骤();
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
    case "broadcast":
      执行对白步骤(步骤);
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

  if (上下文 != null) 写入当前剧情动作上下文(上下文);
  当前片段 = 片段;
  剧情播放器运行时状态.播放世代++;
  剧情播放器运行时状态.当前片段ID = 片段ID;
  剧情播放器运行时状态.当前步骤索引 = 0;
  剧情播放器运行时状态.当前倍速 = 片段.默认倍速 ?? 1;
  剧情播放器运行时状态.是否正在播放 = true;
  剧情播放器运行时状态.是否请求跳过 = false;
  安排片段绝对时间动作(片段);
  debugLogForce(剧情播放器模块名, "播放剧情片段", 片段ID, "steps=", 片段.步骤列表.length);
  执行当前剧情步骤();
  return true;
}

function on剧情ESC跳过(this: void): void {
  if (!剧情播放器运行时状态.是否正在播放 || 当前片段 == null) return;
  if (当前片段.可Esc整段跳过 !== true) return;
  剧情播放器运行时状态.是否请求跳过 = true;
  QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_HINT, "|cffffff00『系统提示』：|r已跳过当前剧情。");
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
