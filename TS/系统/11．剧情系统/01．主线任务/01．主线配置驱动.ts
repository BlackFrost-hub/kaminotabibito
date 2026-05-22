/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, f: any, messageType: number, message: string) => void;
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
    wait: boolean
  ) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { ENABLE_QUEST_MAINLINE_DRIVER } = require("系统.08．任务系统.00．任务系统二分开关") as {
  ENABLE_QUEST_MAINLINE_DRIVER: boolean;
};
const { questDB, QuestType, QuestStatus } = require("系统.08．任务系统.01．任务数据") as any;
const { questManager } = require("系统.08．任务系统.02．任务管理器") as any;
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import { 可直接迁移剧情主线任务配置表, type 剧情主线任务配置 } from "./00．主线任务配置表";

const CreateTimer = jass.CreateTimer as (this: void) => any;
const GetExpiredTimer = jass.GetExpiredTimer as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitLoc = jass.GetUnitLoc as (this: void, whichUnit: any) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const RemoveLocation = jass.RemoveLocation as (this: void, whichLocation: any) => void;
const R2I = jass.R2I as (this: void, r: number) => number;

const 主线运行时任务ID = "main_story_runtime";
const 主线驱动模块名 = "11．剧情系统-主线配置驱动";

interface 延迟动作上下文 {
  代码: string;
  触发单位: any;
}

const 延迟动作上下文表: Record<number, 延迟动作上下文 | undefined> = {};

let 主线驱动已初始化 = false;
let 主线驱动正在执行 = false;

function 读取剧情进度(this: void): number {
  return Number(YDUserDataGetSafe("string", "剧情进度", "整数", "integer")) || 0;
}

function 写入剧情进度(this: void, value: number): void {
  YDUserDataSetSafe("string", "剧情进度", "整数", "integer", value);
}

function 确保主线运行时任务(this: void): void {
  if (questDB.getQuest(主线运行时任务ID)) return;

  questDB.registerQuest({
    id: 主线运行时任务ID,
    type: QuestType.MAIN,
    title: "主线任务",
    description: "剧情进行中",
    objectives: [{ id: "stage", description: "推进主线剧情", current: 0, required: 1, completed: false }],
    rewards: [],
    status: QuestStatus.UNDISCOVERED,
    icon: "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
    createdAt: os.time(),
    updatedAt: os.time(),
  });
  questDB.acceptQuest(0, 主线运行时任务ID);
}

function 刷新主线任务UI(this: void, 任务描述?: string, 提示文本?: string): void {
  const 任务 = (questDB as any).globalData?.quests?.get(主线运行时任务ID);
  if (任务 != null) {
    if (typeof 任务描述 === "string" && 任务描述 !== "") {
      任务.description = 任务描述;
    }
    任务.updatedAt = os.time();
  }

  const 刷新函数 = (questManager as any).triggerUIRefresh;
  if (typeof 刷新函数 === "function") {
    刷新函数.call(questManager, 0, 主线运行时任务ID);
  }

  if (typeof 提示文本 === "string" && 提示文本 !== "") {
    QuestMessageBJ(GetPlayersAll(), jglobals.bj_QUESTMESSAGE_UPDATED, 提示文本);
  }
}

function 解析对话预览(this: void, dialogPreview?: string): Array<{ 说话者: string; 文本: string }> {
  if (!dialogPreview) return [];
  const 结果: Array<{ 说话者: string; 文本: string }> = [];
  const 行列表 = dialogPreview.split("\n");
  for (let i = 0; i < 行列表.length; i++) {
    const line = 行列表[i].trim();
    if (line === "") continue;

    const dot = line.indexOf(".");
    if (dot <= 0) continue;
    const 序号文本 = line.substring(0, dot).trim();
    if (序号文本 === "" || Number(序号文本) <= 0) continue;

    const 主体 = line.substring(dot + 1).trim();
    let 分隔符位置 = 主体.indexOf("：");
    if (分隔符位置 < 0) 分隔符位置 = 主体.indexOf(":");
    if (分隔符位置 <= 0) continue;

    const 说话者 = 主体.substring(0, 分隔符位置).trim();
    const 文本 = 主体.substring(分隔符位置 + 1).trim();
    if (说话者 === "" || 文本 === "") continue;
    结果.push({ 说话者, 文本 });
  }

  return 结果;
}

function 计算对话持续秒数(this: void, 文本: string): number {
  const t = 1 + R2I(文本.length / 10);
  if (t < 2) return 2;
  if (t > 12) return 12;
  return t;
}

function 播放主线对话(this: void, dialogPreview?: string): void {
  const 对话列表 = 解析对话预览(dialogPreview);
  for (let i = 0; i < 对话列表.length; i++) {
    const 对话 = 对话列表[i];
    TransmissionFromUnitWithNameBJ(
      GetPlayersAll(),
      null,
      对话.说话者,
      null,
      对话.文本,
      jglobals.bj_TIMETYPE_SET,
      计算对话持续秒数(对话.文本),
      true,
    );
  }
}

function 移除行内块注释(this: void, s: string): string {
  let 结果 = s;
  while (true) {
    const left = 结果.indexOf("/*");
    if (left < 0) break;
    const right = 结果.indexOf("*/", left + 2);
    if (right < 0) {
      结果 = 结果.substring(0, left);
      break;
    }
    结果 = 结果.substring(0, left) + 结果.substring(right + 2);
  }
  return 结果;
}

function 清理动作代码(this: void, raw: string): string {
  let 结果 = 移除行内块注释(raw).trim();
  if (结果 === "") return "";
  if (结果.indexOf("//") === 0) return "";
  if (结果.indexOf("call ") === 0) 结果 = 结果.substring(5).trim();
  if (结果.indexOf("set ") === 0) 结果 = 结果.substring(4).trim();
  return 结果;
}

function 解析动作时间轴(this: void, timeline?: string): Array<{ 延迟秒: number; 代码: string }> {
  if (!timeline) return [];
  const 结果: Array<{ 延迟秒: number; 代码: string }> = [];
  const 行列表 = timeline.split("\n");
  for (let i = 0; i < 行列表.length; i++) {
    const line = 行列表[i].trim();
    if (line === "") continue;
    const dot = line.indexOf(".");
    if (dot <= 0) continue;

    const 延迟秒 = Number(line.substring(0, dot).trim());
    if (延迟秒 !== 延迟秒) continue;

    const 代码 = 清理动作代码(line.substring(dot + 1));
    if (代码 === "") continue;
    结果.push({ 延迟秒, 代码 });
  }
  return 结果;
}

function 创建主线执行环境(this: void, 触发单位: any): any {
  const 全局 = globalThis as any;
  let 缓存位置: any = null;

  const env: any = {
    __triggerUnit: 触发单位,
    string: "string",
    integer: "integer",
    real: "real",
    unit: "unit",
    group: "group",
    player: "player",
    boolean: "boolean",
    GetTriggerUnit: () => 触发单位,
    YDLocal1Get: (ty: string, key: string): any => {
      if (typeof 全局.YDLocal1Get === "function") return 全局.YDLocal1Get(ty, key);
      if (ty === "location" && key === "单位位置" && 触发单位 != null && 触发单位 !== 0) {
        if (缓存位置 == null) 缓存位置 = GetUnitLoc(触发单位);
        return 缓存位置;
      }
      return null;
    },
  };

  if (typeof 全局.setmetatable === "function") {
    全局.setmetatable(env, { __index: 全局 });
  }
  return env;
}

function 清理主线执行环境(this: void, env: any): void {
  if (env == null) return;
  const 位置 = env.YDLocal1Get != null ? env.YDLocal1Get("location", "单位位置") : null;
  if (位置 != null && 位置 !== 0) {
    RemoveLocation(位置);
  }
}

function 规范化条件表达式(this: void, expr: string): string {
  let 结果 = expr;
  结果 = 结果.split("\\\"").join("\"");
  结果 = 结果.split("GetTriggerUnit()").join("__triggerUnit");
  return 结果;
}

function 判断主线条件(this: void, expr: string, 触发单位: any): boolean {
  const loadFn = (globalThis as any).loadstring;
  const setfenvFn = (globalThis as any).setfenv;
  if (typeof loadFn !== "function" || typeof setfenvFn !== "function") return false;

  const fn = loadFn("return (" + 规范化条件表达式(expr) + ")");
  if (fn == null) return false;

  const env = 创建主线执行环境(触发单位);
  setfenvFn(fn, env);
  try {
    return fn() === true;
  } catch (_err) {
    return false;
  } finally {
    清理主线执行环境(env);
  }
}

function 执行主线动作代码(this: void, 代码: string, 触发单位: any): void {
  const loadFn = (globalThis as any).loadstring;
  const setfenvFn = (globalThis as any).setfenv;
  if (typeof loadFn !== "function" || typeof setfenvFn !== "function") return;

  const fn = loadFn(代码);
  if (fn == null) {
    debugLogForce(主线驱动模块名, "[动作编译失败]", 代码);
    return;
  }

  const env = 创建主线执行环境(触发单位);
  setfenvFn(fn, env);
  try {
    fn();
  } catch (err) {
    debugLogForce(主线驱动模块名, "[动作执行失败]", 代码, tostring(err));
  } finally {
    清理主线执行环境(env);
  }
}

function on主线延迟动作计时器到期(this: void): void {
  const t = GetExpiredTimer();
  if (t == null || t === 0) return;
  const hid = GetHandleId(t);
  const 上下文 = 延迟动作上下文表[hid];
  delete 延迟动作上下文表[hid];
  safeDestroyTimer(t);
  if (上下文 == null) return;
  执行主线动作代码(上下文.代码, 上下文.触发单位);
}

function 执行主线动作时间轴(this: void, timeline: string | undefined, 触发单位: any): void {
  const 条目列表 = 解析动作时间轴(timeline);
  for (let i = 0; i < 条目列表.length; i++) {
    const 条目 = 条目列表[i];
    if (条目.延迟秒 <= 0) {
      执行主线动作代码(条目.代码, 触发单位);
      continue;
    }

    const t = CreateTimer();
    if (t == null || t === 0) continue;
    const hid = GetHandleId(t);
    延迟动作上下文表[hid] = { 代码: 条目.代码, 触发单位 };
    safeTimerStart(t, 条目.延迟秒, false, on主线延迟动作计时器到期);
  }
}

function 收集已注册玩家英雄列表(this: void): any[] {
  const 结果: any[] = [];
  for (let i = 0; i < 8; i++) {
    const 英雄 = getRegisteredPlayerHero(Player(i));
    if (英雄 != null && 英雄 !== 0) {
      结果.push(英雄);
    }
  }
  return 结果;
}

function 命中前置阶段(this: void, 配置: 剧情主线任务配置, 当前阶段: number): boolean {
  if (配置.fromStage == null || 配置.fromStage === "*") return true;
  return Number(配置.fromStage) === 当前阶段;
}

function 提取疑似函数名(this: void, text: string): string[] {
  const 结果: string[] = [];
  const n = text.length;
  let i = 0;
  while (i < n) {
    const ch = text.charCodeAt(i);
    const 是起始字符 = (ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122) || ch === 95;
    if (!是起始字符) {
      i++;
      continue;
    }
    const start = i;
    i++;
    while (i < n) {
      const c = text.charCodeAt(i);
      const 是标识符字符 = (c >= 65 && c <= 90) || (c >= 97 && c <= 122) || (c >= 48 && c <= 57) || c === 95;
      if (!是标识符字符) break;
      i++;
    }
    let j = i;
    while (j < n && (text.charAt(j) === " " || text.charAt(j) === "\t")) j++;
    if (j < n && text.charAt(j) === "(") {
      结果.push(text.substring(start, i));
    }
  }
  return 结果;
}

function 是已知函数(this: void, name: string): boolean {
  const 全局 = globalThis as any;
  if (typeof 全局[name] === "function") return true;
  if (typeof jass[name] === "function") return true;
  return false;
}

function 输出主线兼容诊断(this: void): void {
  const 条件缺失 = new Set<string>();
  const 动作缺失 = new Set<string>();

  for (let i = 0; i < 可直接迁移剧情主线任务配置表.length; i++) {
    const 配置 = 可直接迁移剧情主线任务配置表[i];
    const 条件文本 = 配置.condition ?? "";
    const 动作文本 = 配置.actionTimeline ?? "";

    const 条件函数 = 提取疑似函数名(条件文本);
    for (let j = 0; j < 条件函数.length; j++) {
      const name = 条件函数[j];
      if (!是已知函数(name)) 条件缺失.add(name);
    }

    const 动作函数 = 提取疑似函数名(动作文本);
    for (let j = 0; j < 动作函数.length; j++) {
      const name = 动作函数[j];
      if (!是已知函数(name)) 动作缺失.add(name);
    }
  }

  debugLogForce(主线驱动模块名, "[兼容诊断] 条件缺失函数数量", 条件缺失.size);
  debugLogForce(主线驱动模块名, "[兼容诊断] 动作缺失函数数量", 动作缺失.size);
}

function 主线推进Tick(this: void): void {
  if (主线驱动正在执行) return;
  主线驱动正在执行 = true;

  const 当前阶段 = 读取剧情进度();
  const 英雄列表 = 收集已注册玩家英雄列表();

  for (let i = 0; i < 可直接迁移剧情主线任务配置表.length; i++) {
    const 配置 = 可直接迁移剧情主线任务配置表[i];
    if (配置.enabled === false) continue;
    if (!命中前置阶段(配置, 当前阶段)) continue;
    if (配置.condition == null || 配置.condition === "") continue;

    let 命中英雄: any = null;
    for (let j = 0; j < 英雄列表.length; j++) {
      const 英雄 = 英雄列表[j];
      if (判断主线条件(配置.condition, 英雄)) {
        命中英雄 = 英雄;
        break;
      }
    }
    if (命中英雄 == null || 命中英雄 === 0) continue;

    if (typeof 配置.toStage === "number") {
      写入剧情进度(配置.toStage);
    }
    执行主线动作时间轴(配置.actionTimeline, 命中英雄);
    播放主线对话(配置.dialogPreview);
    刷新主线任务UI(配置.questDescText, 配置.questMsgText);
    break;
  }

  主线驱动正在执行 = false;
}

export function init主线剧情配置驱动(this: void): void {
  if (!ENABLE_QUEST_MAINLINE_DRIVER) return;
  if (主线驱动已初始化) return;
  主线驱动已初始化 = true;

  确保主线运行时任务();
  输出主线兼容诊断();
  addPeriodicCallback(300, 主线推进Tick);
}

export {};
