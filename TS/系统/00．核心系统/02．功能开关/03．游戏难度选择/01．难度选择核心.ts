/** @noSelfInFile */

import 游戏难度配置表, {
  游戏难度全局变量名,
  游戏难度配置,
  游戏难度选择延迟秒,
  弱点数量全局变量名,
} from "./00．难度配置表";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
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
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { addDelayedCallback, setGameDifficulty } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  setGameDifficulty: (this: void, difficulty: number) => void;
};
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, trigger: any, callback: () => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, trigger: any) => void;
};

export type 游戏难度选择状态 = {
  是否已初始化: boolean;
  是否已弹窗: boolean;
  是否已锁定选择: boolean;
  当前难度值?: number;
  当前难度标题?: string;
};

type 难度按钮记录 = {
  按钮: any;
  配置: 游戏难度配置;
};

const 模块名 = "游戏难度选择";
const 中立敌对玩家 = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE);
const 显示对话框玩家 = jass.Player(0);
const 第一个难度使者玩家 = jass.Player(7);
const 对话框标题 = "请选择游戏难度";
const 难度使者创建X = -607.1;
const 难度使者创建Y = 6.1;
const 难度使者朝向 = 0;
const 队伍复活表名 = "团队复活";
const 队伍复活次数键 = "次数";

const AddPlayerTechResearched = jass.AddPlayerTechResearched as (whichPlayer: any, techid: number, levels: number) => void;
const CreateTrigger = jass.CreateTrigger as () => any;
const DialogDestroy = jass.DialogDestroy as (whichDialog: any) => void;
const DialogAddButton = jass.DialogAddButton as (whichDialog: any, buttonText: string, hotkey: number) => any;
const DialogClear = jass.DialogClear as (whichDialog: any) => void;
const DialogCreate = jass.DialogCreate as () => any;
const DialogDisplay = jass.DialogDisplay as (whichPlayer: any, whichDialog: any, flag: boolean) => void;
const GetClickedButton = jass.GetClickedButton as () => any;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetPlayerName = jass.GetPlayerName as (whichPlayer: any) => string;
const GetTriggerPlayer = jass.GetTriggerPlayer as () => any;
const Player = jass.Player as (playerId: number) => any;
const SetUnitAbilityLevel = jass.SetUnitAbilityLevel as (whichUnit: any, abilcode: number, level: number) => number;
const TriggerRegisterDialogEvent = jass.TriggerRegisterDialogEvent as (whichTrigger: any, whichDialog: any) => any;

const 当前状态: 游戏难度选择状态 = {
  是否已初始化: false,
  是否已弹窗: false,
  是否已锁定选择: false,
};

let 难度选择对话框: any = null;
let 难度选择触发器: any = null;
let 难度按钮记录表: 难度按钮记录[] = [];

function 记录错误(this: void, ...args: any[]): void {
  debugLogForce(模块名, ...args);
}

function 获取游戏难度配置映射(this: void, 按钮: any): 游戏难度配置 | undefined {
  for (let i = 0; i < 难度按钮记录表.length; i++) {
    const 记录 = 难度按钮记录表[i];
    if (记录.按钮 === 按钮) return 记录.配置;
  }
  return undefined;
}

function 获取所有玩家句柄(this: void): any {
  return GetPlayersAll();
}

function 解析单位类型ID(this: void, 单位名: string | undefined): number {
  const rawId = 单位名 == null ? undefined : 按名字反查总单位ID(单位名);
  if (rawId == null || rawId === "") {
    记录错误("单位反查失败", 单位名 ?? "<empty>");
    return 0;
  }
  return stringToFourCCSafe(rawId);
}

function 解析技能类型ID(this: void, 技能名: string | undefined): number {
  const rawId = 技能名 == null ? undefined : 按名字反查技能ID(技能名);
  if (rawId == null || rawId === "") {
    记录错误("技能反查失败", 技能名 ?? "<empty>");
    return 0;
  }
  return stringToFourCCSafe(rawId);
}

function 设置全局难度变量(this: void, 配置: 游戏难度配置): void {
  (jglobals as any)[游戏难度全局变量名] = 配置.难度值;
  (jglobals as any)[弱点数量全局变量名] = 配置.弱点数量;
  setGameDifficulty(配置.难度值);
}

function 设置团队复活次数(this: void, 配置: 游戏难度配置): void {
  YDUserDataSetSafe("string", 队伍复活表名, 队伍复活次数键, "integer", 配置.团队复活次数);
}

function 应用敌方科技(this: void, 配置: 游戏难度配置): void {
  if (
    配置.敌方普通生命科技ID != null &&
    配置.敌方普通生命科技ID !== "" &&
    (配置.敌方普通生命科技等级 ?? 0) > 0
  ) {
    AddPlayerTechResearched(中立敌对玩家, stringToFourCCSafe(配置.敌方普通生命科技ID), 配置.敌方普通生命科技等级 ?? 0);
  }
  if (
    配置.敌方精英Boss生命科技ID != null &&
    配置.敌方精英Boss生命科技ID !== "" &&
    (配置.敌方精英Boss生命科技等级 ?? 0) > 0
  ) {
    AddPlayerTechResearched(
      中立敌对玩家,
      stringToFourCCSafe(配置.敌方精英Boss生命科技ID),
      配置.敌方精英Boss生命科技等级 ?? 0
    );
  }
}

function 创建难度使者(this: void, owner: any, 单位类型ID: number, 技能类型ID: number, 技能等级: number): any {
  if (单位类型ID <= 0) return null;
  const unit = 创建单位并登记排泄安全(owner, 单位类型ID, 难度使者创建X, 难度使者创建Y, 难度使者朝向);
  if (unit == null || unit === 0) {
    记录错误("创建难度使者失败", "owner=", GetHandleId(owner), "unitTypeId=", 单位类型ID);
    return null;
  }
  if (技能类型ID > 0 && 技能等级 > 0) {
    SetUnitAbilityLevel(unit, 技能类型ID, 技能等级);
  }
  return unit;
}

function 应用难度使者光环(this: void, 配置: 游戏难度配置): void {
  const 单位类型ID = 解析单位类型ID(配置.难度使者单位名);
  const 技能类型ID = 解析技能类型ID(配置.敌方攻击光环技能名);
  const 技能等级 = 配置.敌方攻击光环等级 ?? 0;
  if (单位类型ID <= 0) return;

  创建难度使者(第一个难度使者玩家, 单位类型ID, 技能类型ID, 技能等级);
  创建难度使者(中立敌对玩家, 单位类型ID, 技能类型ID, 技能等级);
}

function 发送难度选择公告(this: void, 选择玩家: any, 配置: 游戏难度配置): void {
  const 玩家名 = 选择玩家 != null && 选择玩家 !== 0 ? GetPlayerName(选择玩家) : "未知玩家";
  const 玩家组 = 获取所有玩家句柄();
  if (玩家组 == null || 玩家组 === 0) {
    记录错误("GetPlayersAll 不可用，跳过难度公告");
    return;
  }
  QuestMessageBJ(
    玩家组,
    jglobals.bj_QUESTMESSAGE_WARNING ?? 12,
    `|cffffff00『系统消息』：|r玩家${玩家名}选择了难度${配置.难度值}『${配置.难度标题}』，${配置.公告文本}`
  );
}

function 销毁难度对话框(this: void): void {
  if (难度选择对话框 != null && 难度选择对话框 !== 0) {
    DialogDisplay(显示对话框玩家, 难度选择对话框, false);
    DialogClear(难度选择对话框);
    DialogDestroy(难度选择对话框);
    难度选择对话框 = null;
  }
  if (难度选择触发器 != null && 难度选择触发器 !== 0) {
    safeDestroyTrigger(难度选择触发器);
    难度选择触发器 = null;
  }
  难度按钮记录表 = [];
}

function 应用游戏难度(this: void, 配置: 游戏难度配置, 选择玩家: any): void {
  当前状态.是否已锁定选择 = true;
  当前状态.当前难度值 = 配置.难度值;
  当前状态.当前难度标题 = 配置.难度标题;

  设置团队复活次数(配置);
  设置全局难度变量(配置);
  应用敌方科技(配置);
  应用难度使者光环(配置);
  发送难度选择公告(选择玩家, 配置);
  销毁难度对话框();
}

function on难度对话框点击(this: void): void {
  if (当前状态.是否已锁定选择) return;
  const 点击按钮 = GetClickedButton();
  if (点击按钮 == null || 点击按钮 === 0) return;
  const 配置 = 获取游戏难度配置映射(点击按钮);
  if (配置 == null) {
    记录错误("无法匹配被点击的难度按钮");
    return;
  }
  应用游戏难度(配置, GetTriggerPlayer());
}

function 添加难度按钮(this: void, 对话框: any, 配置: 游戏难度配置): void {
  const 热键字符 = String(配置.难度值).charCodeAt(0);
  const 按钮 = DialogAddButton(对话框, 配置.按钮文本, 热键字符);
  难度按钮记录表.push({ 按钮, 配置 });
}

export function 显示游戏难度选择对话框(this: void): void {
  if (当前状态.是否已弹窗 || 当前状态.是否已锁定选择) return;
  当前状态.是否已弹窗 = true;

  难度选择对话框 = DialogCreate();
  if (难度选择对话框 == null || 难度选择对话框 === 0) {
    记录错误("创建难度对话框失败");
    return;
  }

  jass.DialogSetMessage(难度选择对话框, 对话框标题);
  for (let i = 0; i < 游戏难度配置表.length; i++) {
    添加难度按钮(难度选择对话框, 游戏难度配置表[i]);
  }

  难度选择触发器 = CreateTrigger();
  if (难度选择触发器 == null || 难度选择触发器 === 0) {
    记录错误("创建难度对话框触发器失败");
    销毁难度对话框();
    return;
  }

  TriggerRegisterDialogEvent(难度选择触发器, 难度选择对话框);
  safeTriggerAddAction(难度选择触发器, on难度对话框点击);
  DialogDisplay(显示对话框玩家, 难度选择对话框, true);
}

export function 获取游戏难度配置表(this: void): ReadonlyArray<游戏难度配置> {
  return 游戏难度配置表;
}

export function 获取游戏难度选择延迟秒(this: void): number {
  return 游戏难度选择延迟秒;
}

export function 获取游戏难度选择状态(this: void): 游戏难度选择状态 {
  return 当前状态;
}

export function 初始化游戏难度选择(this: void): void {
  if (当前状态.是否已初始化) return;
  当前状态.是否已初始化 = true;
  addDelayedCallback(游戏难度选择延迟秒 * 1000, 显示游戏难度选择对话框);
}

export {};
