/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
  getServerTime: (this: void) => number;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { AdjustPlayerStateBJ } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  AdjustPlayerStateBJ: (this: void, delta: number, whichPlayer: any, whichPlayerState: any) => void;
};
const { ModifyGateBJ, ForGroupBJ, SetTimeOfDay } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, gateOperation: number, d: any) => void;
  ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
  SetTimeOfDay: (this: void, whatTime: number) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { SetStackedSoundBJ } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  SetStackedSoundBJ: (this: void, add: boolean, soundHandle: any, rectHandle: any) => void;
};
const { PlaySoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundBJ: (this: void, soundHandle: any) => void;
};
const { ModifyHeroStat } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  ModifyHeroStat: (this: void, whichStat: number, whichHero: any, modifyMethod: number, value: number) => void;
};
const {
  AddItemToStockBJ,
  GetItemOfTypeFromUnitBJ,
} = require("lib.扩展函数.BJ函数.03．物品与库存") as {
  AddItemToStockBJ: (this: void, whichItemId: number, whichUnit: any, currentStock: number, stockMax: number) => void;
  GetItemOfTypeFromUnitBJ: (this: void, whichUnit: any, itemId: number) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { questDB, QuestType, QuestStatus } = require("系统.08．任务系统.01．任务数据") as any;
const { questManager } = require("系统.08．任务系统.02．任务管理器") as any;
const { 创建并冻结剧情Boss预置 } = require("./03．剧情Boss预置桥接") as {
  创建并冻结剧情Boss预置: (this: void, 参数: any) => any;
};
const { 启动Boss战运行 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.03．Boss战运行驱动") as {
  启动Boss战运行: (this: void, bossUnit: any) => void;
};

import type { 剧情动作参数表 } from "./00．剧情动作类型";
import { 读取当前剧情动作上下文, 写入剧情进度 } from "./01．剧情动作上下文";
import { 切换剧情大门, 发送剧情任务消息, 发送剧情小地图信号 } from "./02．剧情动作桥接";

const AddSpecialEffect = jass.AddSpecialEffect as (this: void, modelName: string, x: number, y: number) => any;
const CreateFogModifierRect = jass.CreateFogModifierRect as (
  this: void,
  whichPlayer: any,
  whichState: any,
  where: any,
  useSharedVision: boolean,
  afterUnits: boolean,
) => any;
const CreateItem = jass.CreateItem as (this: void, itemId: number, x: number, y: number) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const DisplayCineFilter = jass.DisplayCineFilter as (this: void, flag: boolean) => void;
const FogModifierStart = jass.FogModifierStart as (this: void, whichFog: any) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetUnitName = jass.GetUnitName as (this: void, whichUnit: any) => string;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, whichUnit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const RemoveDestructable = jass.RemoveDestructable as (this: void, whichDestructable: any) => void;
const RemoveItem = jass.RemoveItem as (this: void, whichItem: any) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const UnitAddItem = jass.UnitAddItem as (this: void, whichUnit: any, whichItem: any) => boolean;
const ShowDestructable = jass.ShowDestructable as (this: void, whichDestructable: any, flag: boolean) => void;

const FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE as number;
const bj_GATEOPERATION_CLOSE = jglobals.bj_GATEOPERATION_CLOSE as number;
const bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN as number;
const bj_HEROSTAT_AGI = jglobals.bj_HEROSTAT_AGI as number;
const bj_HEROSTAT_INT = jglobals.bj_HEROSTAT_INT as number;
const bj_HEROSTAT_STR = jglobals.bj_HEROSTAT_STR as number;
const bj_MODIFYMETHOD_ADD = jglobals.bj_MODIFYMETHOD_ADD as number;
const bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED as number;
const bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED as number;
const bj_QUESTMESSAGE_HINT = jglobals.bj_QUESTMESSAGE_HINT as number;
const bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING as number;
const PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD as number;

const 主线运行时任务ID = "main_story_runtime";
let 当前玩家英雄控制暂停 = false;
let 当前玩家英雄无敌 = false;
const 已创建视野修整器: Record<string, true | undefined> = {};
interface 延迟执行记录 {
  类型: "消息" | "开门";
  文本?: string;
  消息类型?: number;
  重复次数?: number;
  开门对象?: string;
  隐藏阻挡?: string;
}

const 延迟执行任务: Array<{ dueTime: number; 记录: 延迟执行记录 }> = [];
let 延迟执行扫描ID = 0;

function maxNum(this: void, a: number, b: number): number {
  return a > b ? a : b;
}

function 执行延迟记录(this: void, 记录: 延迟执行记录): void {
  if (记录.类型 === "消息" && 记录.文本) {
    const 重复次数 = maxNum(1, 记录.重复次数 ?? 1);
    for (let i = 0; i < 重复次数; i++) {
      QuestMessageBJ(GetPlayersAll(), 记录.消息类型 ?? bj_QUESTMESSAGE_HINT, 记录.文本);
    }
    return;
  }

  if (记录.类型 === "开门") {
    if (记录.开门对象) {
      const destructable = 读取全局句柄(记录.开门对象);
      if (destructable != null && destructable !== 0) {
        切换剧情大门({ 可破坏物全局名: 记录.开门对象, 开关: "打开" });
      }
    }
    if (记录.隐藏阻挡) {
      const hidden = 读取全局句柄(记录.隐藏阻挡);
      if (hidden != null && hidden !== 0) {
        ShowDestructable(hidden, false);
      }
    }
  }
}

function on延迟执行扫描(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < 延迟执行任务.length; i++) {
    const task = 延迟执行任务[i];
    if (now >= task.dueTime) {
      执行延迟记录(task.记录);
      continue;
    }
    延迟执行任务[writeIndex] = task;
    writeIndex++;
  }
  for (let i = 延迟执行任务.length - 1; i >= writeIndex; i--) {
    延迟执行任务.pop();
  }
  if (延迟执行任务.length === 0 && 延迟执行扫描ID !== 0) {
    removePeriodicCallback(延迟执行扫描ID);
    延迟执行扫描ID = 0;
  }
}

function 安排延迟执行(this: void, 秒数: number, 记录: 延迟执行记录): void {
  if (!(秒数 > 0)) {
    执行延迟记录(记录);
    return;
  }
  延迟执行任务.push({ dueTime: getServerTime() + 秒数 * 1000, 记录 });
  if (延迟执行扫描ID === 0) {
    延迟执行扫描ID = addPeriodicCallback(10, on延迟执行扫描);
  }
}

function 取参数文本(this: void, 参数: 剧情动作参数表, key: string): string {
  const value = 参数[key];
  if (typeof value === "string") return value;
  if (typeof value === "number" || typeof value === "boolean") return String(value);
  return "";
}

function 取参数数字(this: void, 参数: 剧情动作参数表, key: string): number {
  const value = 参数[key];
  if (typeof value === "number") return value;
  if (typeof value === "string") return Number(value) || 0;
  return 0;
}

function 取参数布尔(this: void, 参数: 剧情动作参数表, key: string): boolean {
  return 参数[key] === true;
}

function 分割名称列表(this: void, value: string): string[] {
  if (value === "") return [];
  return value.split(",").map((item) => item.trim()).filter((item) => item.length > 0);
}

function 读取全局句柄(this: void, 变量名: string): any {
  if (变量名 === "") return null;
  return jglobals[变量名] ?? null;
}

export function 读取语义单位引用(this: void, 引用: string): any {
  if (引用 === "") return null;
  const splitIndex = 引用.indexOf(".");
  if (splitIndex >= 0) {
    const tableName = 引用.substring(0, splitIndex);
    const keyName = 引用.substring(splitIndex + 1);
    if (tableName !== "" && keyName !== "") {
      return YDUserDataGetSafe("string", tableName, keyName, "unit");
    }
  }

  const 候选表名列表 = ["主线NPC", "ZX", "Boss", "Boss战", "jq"];
  for (let i = 0; i < 候选表名列表.length; i++) {
    const unit = YDUserDataGetSafe("string", 候选表名列表[i], 引用, "unit");
    if (unit != null && unit !== 0) return unit;
  }

  const 全局句柄 = 读取全局句柄(引用);
  if (全局句柄 != null && 全局句柄 !== 0) return 全局句柄;
  return null;
}

export function 读取触发单位(this: void): any {
  const 上下文 = 读取当前剧情动作上下文();
  return 上下文.触发单位;
}

function 从单位移除指定物品(this: void, unit: any, 物品名: string): boolean {
  if (unit == null || unit === 0 || 物品名 === "") return false;
  const itemTypeId = stringToFourCCSafe(按名字反查物品ID(物品名));
  if (!(itemTypeId > 0)) return false;
  if (!UnitHasItemOfTypeBJ(unit, itemTypeId)) return false;
  const item = GetItemOfTypeFromUnitBJ(unit, itemTypeId);
  if (item == null || item === 0) return false;
  RemoveItem(item);
  return true;
}

function on设置枚举英雄暂停无敌(this: void): void {
  const unit = GetEnumUnit();
  if (unit == null || unit === 0) return;
  PauseUnit(unit, 当前玩家英雄控制暂停);
  SetUnitInvulnerable(unit, 当前玩家英雄无敌);
}

function 向商店添加物品(this: void, unit: any, 物品名列表: string): void {
  if (unit == null || unit === 0 || 物品名列表 === "") return;
  const items = 分割名称列表(物品名列表);
  for (let i = 0; i < items.length; i++) {
    const rawId = 按名字反查物品ID(items[i]);
    const itemTypeId = stringToFourCCSafe(rawId);
    if (!(itemTypeId > 0)) continue;
    AddItemToStockBJ(itemTypeId, unit, 1, 1);
  }
}

function 调整全部玩家金币(this: void, delta: number): void {
  for (let playerId = 0; playerId < 8; playerId++) {
    AdjustPlayerStateBJ(delta, Player(playerId), PLAYER_STATE_RESOURCE_GOLD);
  }
}

export function 设置玩家英雄组控制状态(this: void, 暂停: boolean, 无敌: boolean): void {
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 == null || 玩家英雄组 === 0) return;
  当前玩家英雄控制暂停 = 暂停;
  当前玩家英雄无敌 = 无敌;
  ForGroupBJ(玩家英雄组, on设置枚举英雄暂停无敌);
}

export function 设置触发单位控制状态(this: void, 暂停: boolean, 无敌: boolean): void {
  const unit = 读取触发单位();
  if (unit == null || unit === 0) return;
  PauseUnit(unit, 暂停);
  SetUnitInvulnerable(unit, 无敌);
}

export function 停止触发单位(this: void): void {
  const unit = 读取触发单位();
  if (unit == null || unit === 0) return;
  IssueImmediateOrder(unit, "stop");
}

export function 给全部玩家添加区域视野(this: void, rectVarName: string): void {
  const rectHandle = 读取全局句柄(rectVarName);
  if (rectHandle == null || rectHandle === 0) return;

  for (let playerId = 0; playerId < 8; playerId++) {
    const key = `${rectVarName}#${playerId}`;
    if (已创建视野修整器[key]) continue;
    const fogModifier = CreateFogModifierRect(Player(playerId), FOG_OF_WAR_VISIBLE, rectHandle, true, false);
    if (fogModifier == null || fogModifier === 0) continue;
    FogModifierStart(fogModifier);
    已创建视野修整器[key] = true;
  }
}

export function 给全部玩家添加多个区域视野(this: void, rectVarNames: string): void {
  const 列表 = 分割名称列表(rectVarNames);
  for (let i = 0; i < 列表.length; i++) {
    给全部玩家添加区域视野(列表[i]);
  }
}

export function 更新主线任务UI(this: void, 任务描述: string, 提示文本: string): void {
  if (!questDB.getQuest(主线运行时任务ID)) {
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

  const 任务 = (questDB as any).globalData?.quests?.get(主线运行时任务ID);
  if (任务 != null && 任务描述 !== "") {
    任务.description = 任务描述;
    任务.updatedAt = os.time();
  }

  const 刷新函数 = (questManager as any).triggerUIRefresh;
  if (typeof 刷新函数 === "function") {
    刷新函数.call(questManager, 0, 主线运行时任务ID);
  }

  if (提示文本 !== "") {
    QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, 提示文本);
  }
}

export function 按名字创建物品到单位位置(this: void, 物品名: string, unit: any): any {
  if (unit == null || unit === 0) return null;
  const itemTypeId = stringToFourCCSafe(按名字反查物品ID(物品名));
  if (!(itemTypeId > 0)) return null;
  return CreateItem(itemTypeId, GetUnitX(unit), GetUnitY(unit));
}

export function 按名字给触发单位物品(this: void, 物品名: string): void {
  const unit = 读取触发单位();
  if (unit == null || unit === 0) return;
  const itemTypeId = stringToFourCCSafe(按名字反查物品ID(物品名));
  if (!(itemTypeId > 0)) return;
  const item = CreateItem(itemTypeId, 0, 0);
  if (item == null || item === 0) return;
  UnitAddItem(unit, item);
}

export function 触发单位增加基础全属性(this: void, value: number, 提示模板: string): void {
  const unit = 读取触发单位();
  if (unit == null || unit === 0) return;
  ModifyHeroStat(bj_HEROSTAT_STR, unit, bj_MODIFYMETHOD_ADD, value);
  ModifyHeroStat(bj_HEROSTAT_AGI, unit, bj_MODIFYMETHOD_ADD, value);
  ModifyHeroStat(bj_HEROSTAT_INT, unit, bj_MODIFYMETHOD_ADD, value);
  const message = 提示模板.replace("{英雄名}", GetUnitName(unit)).replace("{value}", String(value));
  发送剧情任务消息({ 消息类型: bj_QUESTMESSAGE_ITEMACQUIRED, 文本: message });
}

export function 执行通用剧情动作(this: void, 参数: 剧情动作参数表): void {
  const 设置进度 = 取参数数字(参数, "设置剧情进度") || 取参数数字(参数, "目标进度");
  if (设置进度 > 0) 写入剧情进度(设置进度);

  if (取参数布尔(参数, "开启电影模式")) {
    const { CinematicModeBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
      CinematicModeBJ: (this: void, cineMode: boolean, forForce: any) => void;
    };
    CinematicModeBJ(true, GetPlayersAll());
  }
  if (取参数布尔(参数, "关闭电影模式")) {
    const { CinematicModeBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
      CinematicModeBJ: (this: void, cineMode: boolean, forForce: any) => void;
    };
    CinematicModeBJ(false, GetPlayersAll());
  }

  if (取参数布尔(参数, "玩家英雄组暂停") || 取参数布尔(参数, "玩家英雄组无敌")) {
    设置玩家英雄组控制状态(true, true);
  }
  if (取参数布尔(参数, "玩家英雄组恢复控制") || 取参数布尔(参数, "玩家英雄组取消无敌")) {
    设置玩家英雄组控制状态(false, false);
  }
  if (取参数布尔(参数, "触发单位恢复控制") || 取参数布尔(参数, "触发单位取消无敌")) {
    设置触发单位控制状态(false, false);
  }

  if (取参数布尔(参数, "关闭电影滤镜")) {
    DisplayCineFilter(false);
  }
  if (取参数布尔(参数, "时间设为午夜")) {
    SetTimeOfDay(0);
  }

  const 任务描述 = 取参数文本(参数, "任务描述");
  const 任务提示 = 取参数文本(参数, "任务更新提示") || 取参数文本(参数, "任务更新");
  if (任务描述 !== "" || 任务提示 !== "") 更新主线任务UI(任务描述, 任务提示);

  const 小地图X = 取参数数字(参数, "小地图X") || 取参数数字(参数, "小地图坐标X");
  const 小地图Y = 取参数数字(参数, "小地图Y") || 取参数数字(参数, "小地图坐标Y");
  if (小地图X !== 0 || 小地图Y !== 0) {
    发送剧情小地图信号({
      X: 小地图X,
      Y: 小地图Y,
      持续时间: 取参数数字(参数, "小地图持续时间") || 20,
    });
  }

  const 视野矩形 = 取参数文本(参数, "视野矩形") || 取参数文本(参数, "可见区域") || 取参数文本(参数, "解锁视野");
  if (视野矩形 !== "") 给全部玩家添加多个区域视野(视野矩形);
  const 可见区域1 = 取参数文本(参数, "可见区域1");
  const 可见区域2 = 取参数文本(参数, "可见区域2");
  if (可见区域1 !== "") 给全部玩家添加区域视野(可见区域1);
  if (可见区域2 !== "") 给全部玩家添加区域视野(可见区域2);

  const NPC引用 = 取参数文本(参数, "NPC") || 取参数文本(参数, "长老单位");
  const npcUnit = NPC引用 !== "" ? 读取语义单位引用(NPC引用) : null;
  const 触发单位 = 读取触发单位();
  if (npcUnit != null && npcUnit !== 0) {
    if (触发单位 != null && 触发单位 !== 0) {
      if (取参数文本(参数, "NPC转向目标") !== "" || 取参数文本(参数, "NPC转向触发单位") !== "") {
        SetUnitFacing(npcUnit, GetUnitFacing(触发单位));
      }
      if (取参数文本(参数, "触发单位转向目标") !== "" || 取参数文本(参数, "触发单位转向耗时") !== "") {
        SetUnitFacing(触发单位, GetUnitFacing(npcUnit));
      }
    }
    const 商店物品 = 取参数文本(参数, "商店新增物品");
    if (商店物品 !== "") {
      向商店添加物品(npcUnit, 商店物品);
    }
    if (取参数布尔(参数, "将NPC设为玩家控制")) {
      SetUnitOwner(npcUnit, Player(6), true);
    }
  }

  const 需要物品 = 取参数文本(参数, "需要物品") || 取参数文本(参数, "需要物品名");
  if (需要物品 !== "") {
    if (触发单位 == null || 触发单位 === 0) return;
    if (!从单位移除指定物品(触发单位, 需要物品)) return;
  }

  const 开门对象 = 取参数文本(参数, "开门对象");
  if (开门对象 !== "") {
    const destructable = 读取全局句柄(开门对象);
    if (destructable != null && destructable !== 0) ModifyGateBJ(bj_GATEOPERATION_OPEN, destructable);
  }
  const 隐藏阻挡 = 取参数文本(参数, "隐藏阻挡");
  if (隐藏阻挡 !== "") {
    const destructable = 读取全局句柄(隐藏阻挡);
    if (destructable != null && destructable !== 0) ShowDestructable(destructable, false);
  }
  const 可破坏物全局名 = 取参数文本(参数, "可破坏物全局名");
  if (可破坏物全局名 !== "") {
    切换剧情大门({
      可破坏物全局名,
      开关: 取参数文本(参数, "开关") === "关闭" ? "关闭" : "打开",
    });
  }
  const 破坏物 = 取参数文本(参数, "破坏物") || 取参数文本(参数, "移除阻挡");
  if (破坏物 !== "") {
    const destructable = 读取全局句柄(破坏物);
    if (destructable != null && destructable !== 0) RemoveDestructable(destructable);
  }

  const 物品名 = 取参数文本(参数, "物品名") || 取参数文本(参数, "掉落物品名") || 取参数文本(参数, "奖励物品名");
  if (物品名 !== "") 按名字给触发单位物品(物品名);

  const 扣除金币 = 取参数数字(参数, "扣除金币");
  if (扣除金币 !== 0 && 触发单位 != null && 触发单位 !== 0) {
    AdjustPlayerStateBJ(-扣除金币, GetOwningPlayer(触发单位), PLAYER_STATE_RESOURCE_GOLD);
  }
  const 发放金币 = 取参数数字(参数, "发放金币");
  if (发放金币 !== 0) {
    调整全部玩家金币(发放金币);
  }

  const 预警文本 = 取参数文本(参数, "预警文本");
  const 延迟秒数 = 取参数数字(参数, "延迟秒数")
    || 取参数数字(参数, "延迟开门秒")
    || (预警文本 !== "" ? 4 : 0);
  const 延迟提示 = 取参数文本(参数, "延迟提示") || 取参数文本(参数, "延迟消息") || 预警文本;
  if (延迟提示 !== "") {
    const 延迟消息类型标记 = 取参数文本(参数, "延迟消息类型");
    const 消息类型 = 延迟消息类型标记 === "WARNING" || 预警文本 !== ""
      ? bj_QUESTMESSAGE_WARNING
      : bj_QUESTMESSAGE_HINT;
    const 重复次数 = maxNum(1, 取参数数字(参数, "延迟消息重复次数") || (预警文本 !== "" ? 2 : 1));
    安排延迟执行(延迟秒数, {
      类型: "消息",
      文本: 延迟提示,
      消息类型,
      重复次数,
    });
  }
  if (开门对象 !== "" && 延迟秒数 > 0) {
    安排延迟执行(延迟秒数, {
      类型: "开门",
      开门对象,
      隐藏阻挡,
    });
  }

  const Boss键 = 取参数文本(参数, "Boss键");
  const Boss名 = 取参数文本(参数, "Boss名");
  const 需要预创建Boss = Boss名 !== "" && ((取参数数字(参数, "注册范围") > 0) || 取参数布尔(参数, "预创建后暂停") || 取参数布尔(参数, "预创建后无敌") || 取参数文本(参数, "范围触发剧情片段ID") !== "");
  if (需要预创建Boss) {
    创建并冻结剧情Boss预置({
      Boss键,
      Boss名,
      X: 取参数数字(参数, "X"),
      Y: 取参数数字(参数, "Y"),
      朝向: 取参数数字(参数, "朝向"),
      注册范围: 取参数数字(参数, "注册范围"),
      预创建后暂停: 取参数布尔(参数, "预创建后暂停"),
      预创建后无敌: 取参数布尔(参数, "预创建后无敌"),
      范围触发配置名: 取参数文本(参数, "范围触发配置名"),
      范围触发剧情片段ID: 取参数文本(参数, "范围触发剧情片段ID") || undefined,
      需要剧情进度: 取参数数字(参数, "触发进度") || undefined,
    });
  }

  const 需要启动Boss = (Boss键 !== "" || Boss名 !== "") && (取参数文本(参数, "注册Boss技能事件") !== "" || 取参数文本(参数, "Boss战绑定单位字段") !== "" || 取参数文本(参数, "Boss战战斗音乐") !== "" || 取参数文本(参数, "Boss战胜利音乐") !== "" || 取参数文本(参数, "Boss战地点字段") !== "" || 取参数文本(参数, "Boss战地点") !== "");
  if (需要启动Boss) {
    const bossUnit = 读取语义单位引用(Boss键 !== "" ? Boss键 : `Boss.${Boss名}`);
    if (bossUnit != null && bossUnit !== 0) {
      YDUserDataSetSafe("string", "Boss战", "绑定单位", "unit", bossUnit);
      if (触发单位 != null && 触发单位 !== 0) {
        YDUserDataSetSafe("string", "Boss战", "触发玩家", "unit", 触发单位);
      }

      const 战斗音乐变量名 = 取参数文本(参数, "Boss战战斗音乐");
      if (战斗音乐变量名 !== "") {
        const 音频句柄 = 读取全局句柄(战斗音乐变量名);
        if (音频句柄 != null && 音频句柄 !== 0) {
          YDUserDataSetSafe("string", "Boss战", "战斗音乐", "sound", 音频句柄);
        }
      }
      const 胜利音乐变量名 = 取参数文本(参数, "Boss战胜利音乐");
      if (胜利音乐变量名 !== "") {
        const 音频句柄 = 读取全局句柄(胜利音乐变量名);
        if (音频句柄 != null && 音频句柄 !== 0) {
          YDUserDataSetSafe("string", "Boss战", "胜利音乐", "sound", 音频句柄);
        }
      }
      const 地点变量名 = 取参数文本(参数, "Boss战地点字段") || 取参数文本(参数, "Boss战地点");
      if (地点变量名 !== "") {
        const rectHandle = 读取全局句柄(地点变量名);
        if (rectHandle != null && rectHandle !== 0) {
          YDUserDataSetSafe("string", "Boss战", "地点", "rect", rectHandle);
        }
      }
      启动Boss战运行(bossUnit);
    }
  }

  const 模型路径 = 取参数文本(参数, "模型路径");
  if (模型路径 !== "") {
    const x = 取参数数字(参数, "X") || (触发单位 != null && 触发单位 !== 0 ? GetUnitX(触发单位) : 0);
    const y = 取参数数字(参数, "Y") || (触发单位 != null && 触发单位 !== 0 ? GetUnitY(触发单位) : 0);
    AddSpecialEffect(模型路径, x, y);
  }

  const 触发单位命令 = 取参数文本(参数, "触发单位发布命令");
  if (触发单位命令 !== "") {
    if (触发单位 != null && 触发单位 !== 0) IssueImmediateOrder(触发单位, 触发单位命令);
  }

  const 触发单位X = 取参数数字(参数, "触发单位X");
  const 触发单位Y = 取参数数字(参数, "触发单位Y");
  if ((触发单位X !== 0 || 触发单位Y !== 0) && 触发单位 != null && 触发单位 !== 0) {
    SetUnitPosition(触发单位, 触发单位X, 触发单位Y);
  }

  const 停止区域音乐 = 取参数文本(参数, "停止区域音乐") || 取参数文本(参数, "关闭区域音乐");
  if (停止区域音乐 !== "") 切换区域音乐表达式(停止区域音乐, false);
  const 开始区域音乐 = 取参数文本(参数, "开始音乐") || 取参数文本(参数, "开启区域音乐");
  if (开始区域音乐 !== "") 切换区域音乐表达式(开始区域音乐, true);
  const 播放音效 = 取参数文本(参数, "播放音效") || 取参数文本(参数, "播放音效变量名");
  if (播放音效 !== "") 播放音效表达式(播放音效);
}

function 切换区域音乐表达式(this: void, expr: string, add: boolean): void {
  const list = expr.split(";");
  for (let i = 0; i < list.length; i++) {
    const item = list[i].trim();
    if (item.length === 0) continue;
    const at = item.indexOf("@");
    if (at < 0) continue;
    const soundVarName = item.substring(0, at).trim();
    const rectVarName = item.substring(at + 1).trim();
    const soundHandle = 读取全局句柄(soundVarName);
    const rectHandle = 读取全局句柄(rectVarName);
    if (soundHandle == null || soundHandle === 0 || rectHandle == null || rectHandle === 0) continue;
    SetStackedSoundBJ(add, soundHandle, rectHandle);
  }
}

function 播放音效表达式(this: void, expr: string): void {
  const list = expr.split(";");
  for (let i = 0; i < list.length; i++) {
    const soundVarName = list[i].trim();
    if (soundVarName.length === 0) continue;
    const soundHandle = 读取全局句柄(soundVarName);
    if (soundHandle == null || soundHandle === 0) continue;
    PlaySoundBJ(soundHandle);
  }
}
