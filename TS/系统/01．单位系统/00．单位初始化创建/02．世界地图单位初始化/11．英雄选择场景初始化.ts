/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 获取矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  获取矩形区域: (this: void, 名称: string) => any;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (
    this: void,
    owner: any,
    unitTypeId: number,
    x: number,
    y: number,
    facing: number,
  ) => any;
};
const { getObjectPropertySafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertySafe: (this: void, objectType: number, objectId: number | string, property: string) => string;
  YDUserDataSetSafe: (
    this: void,
    tableType: string,
    tableKey: any,
    attr: string,
    valueType: string,
    value: any,
  ) => void;
};
const { ModifyHeroSkillPoints } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  ModifyHeroSkillPoints: (this: void, whichHero: any, modifyMethod: number, value: number) => boolean;
};
const { ForGroupBJ, GetUnitsInRectMatching } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
  GetUnitsInRectMatching: (this: void, whichRect: any, filter: any) => any;
};
const { RectContainsUnit } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  RectContainsUnit: (this: void, whichRect: any, whichUnit: any) => boolean;
};
const { 设单位头像模型 } = require("平台扩展API动作") as {
  设单位头像模型: (this: void, 单位: any, 模型路径: string) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};

const Player = jass.Player as (this: void, playerId: number) => any;
const CreateTimer = jass.CreateTimer as (this: void) => any;
const DestroyTimer = jass.DestroyTimer as (this: void, whichTimer: any) => void;
const TimerStart = jass.TimerStart as (
  this: void,
  whichTimer: any,
  timeout: number,
  periodic: boolean,
  handlerFunc: any,
) => void;
const CreateTimerDialog = jass.CreateTimerDialog as (this: void, whichTimer: any) => any;
const DestroyTimerDialog = jass.DestroyTimerDialog as (this: void, whichDialog: any) => void;
const TimerDialogSetTitle = jass.TimerDialogSetTitle as (this: void, whichDialog: any, title: string) => void;
const TimerDialogDisplay = jass.TimerDialogDisplay as (this: void, whichDialog: any, display: boolean) => void;
const CreateFogModifierRect = jass.CreateFogModifierRect as (
  this: void,
  whichPlayer: any,
  whichState: any,
  where: any,
  useSharedVision: boolean,
  afterUnits: boolean,
) => any;
const FogModifierStart = jass.FogModifierStart as (this: void, whichFog: any) => void;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, whichType: number) => boolean;
const GetFilterUnit = jass.GetFilterUnit as (this: void) => any;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetTriggerEventId = jass.GetTriggerEventId as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const SelectUnit = jass.SelectUnit as (this: void, whichUnit: any, flag: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, whichUnit: any, abilityId: number) => boolean;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const DestroyTrigger = jass.DestroyTrigger as (this: void, whichTrigger: any) => void;
const TriggerRegisterUnitEvent = jass.TriggerRegisterUnitEvent as (
  this: void,
  whichTrigger: any,
  whichUnit: any,
  whichEvent: any,
) => any;
const TriggerRegisterTimerEventSingle = jass.TriggerRegisterTimerEventSingle as (
  this: void,
  whichTrigger: any,
  timeout: number,
) => any;
const TriggerAddCondition = jass.TriggerAddCondition as (this: void, whichTrigger: any, condition: any) => any;
const Condition = jass.Condition as (callback: (this: void) => boolean) => any;

const FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE as number;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as number;
const EVENT_UNIT_SPELL_CHANNEL = jass.EVENT_UNIT_SPELL_CHANNEL as any;
const EVENT_GAME_TIMER_EXPIRED = jass.EVENT_GAME_TIMER_EXPIRED as any;
const YDWE_OBJECT_TYPE_UNIT = 2;
const NEUTRAL_PASSIVE_PLAYER_ID = jass.PLAYER_NEUTRAL_PASSIVE as number;
const HERO_SKILL_VIEW_ABILITY_ID = 0x416E6532;
const HERO_SKILL_POINT_SUB = jglobals.bj_MODIFYMETHOD_SUB as number;

interface 英雄展示配置 {
  名称: string;
  单位ID: string;
  X: number;
  Y: number;
  朝向: number;
  头像?: string;
}

const 第一批英雄展示配置: 英雄展示配置[] = [
  { 名称: "克劳德", 单位ID: "E05V", X: -29248.4, Y: 27608.3, 朝向: 270, 头像: "war3mapImported\\YXXX-KLD.mdx" },
  { 名称: "坂井悠二", 单位ID: "H00M", X: -29698.2, Y: 27623.9, 朝向: 270, 头像: "war3mapImported\\YXXX-BJUE.mdx" },
  { 名称: "阿劳伦特", 单位ID: "H00F", X: -28229.0, Y: 28929.2, 朝向: 345 },
];

const 第二批英雄展示配置: 英雄展示配置[] = [
  { 名称: "Saber", 单位ID: "H00H", X: -29707.4, Y: 27257.5, 朝向: 0, 头像: "war3mapImported\\YYXX-saber.mdx" },
  { 名称: "逆回十六夜", 单位ID: "H00J", X: -29532.3, Y: 27618.7, 朝向: 270, 头像: "war3mapImported\\YXXX-NHSLY.mdx" },
  { 名称: "安斯艾尔", 单位ID: "Hart", X: -27288.2, Y: 28870.6, 朝向: 180 },
  { 名称: "藤原妹红", 单位ID: "H00R", X: -25513.4, Y: 29042.4, 朝向: 135, 头像: "war3mapImported\\YXXX-TYMH.mdx" },
  { 名称: "佐佐木小次郎", 单位ID: "H00S", X: -29387.4, Y: 27638.1, 朝向: 270, 头像: "war3mapImported\\YXXX-ZZMXCL.mdx" },
  { 名称: "欧尔贝克", 单位ID: "H012", X: -27498.7, Y: 29001.8, 朝向: 270 },
  { 名称: "蕾米莉亚", 单位ID: "E08J", X: -26070.4, Y: 29275.0, 朝向: 235, 头像: "war3mapImported\\YXXX-LMLY.mdx" },
];

const 第三批英雄展示配置: 英雄展示配置[] = [
  { 名称: "十六夜咲夜", 单位ID: "E001", X: -25940.2, Y: 29242.0, 朝向: 252.1, 头像: "war3mapImported\\YXXX-SLYXY.mdx" },
  { 名称: "铃仙", 单位ID: "E07R", X: -25674.0, Y: 29219.7, 朝向: 270, 头像: "war3mapImported\\YXXX-LX.mdx" },
  { 名称: "黑崎一护", 单位ID: "E006", X: -29109.4, Y: 27615.0, 朝向: 270, 头像: "war3mapImported\\YXXX-HQYH.mdx" },
];

const 第四批英雄展示配置: 英雄展示配置[] = [
  { 名称: "鹿目圆香", 单位ID: "E004", X: -29615.3, Y: 26957.7, 朝向: 350.5, 头像: "war3mapImported\\YXXX-XY.mdx" },
  { 名称: "八云紫", 单位ID: "H00P", X: -25811.7, Y: 29394.2, 朝向: 270, 头像: "war3mapImported\\YXXX-BYZ.mdx" },
  { 名称: "一方通行", 单位ID: "H00I", X: -29330.4, Y: 26855.3, 朝向: 90, 头像: "war3mapImported\\YXXX-YFTX.mdx" },
  { 名称: "云端", 单位ID: "E03I", X: -25618.8, Y: 27476.1, 朝向: 135 },
  { 名称: "欧菲莉亚", 单位ID: "H013", X: -29679.9, Y: 29203.4, 朝向: 0, 头像: "war3mapImported\\XX5.mdx" },
  { 名称: "提米诺斯", 单位ID: "H015", X: -29311.9, Y: 29083.5, 朝向: 180, 头像: "war3mapImported\\XX2.mdx" },
  { 名称: "塞拉斯", 单位ID: "H014", X: -28797.8, Y: 28265.8, 朝向: 237.8, 头像: "war3mapImported\\XX4.mdx" },
];

let 英雄选择场景已初始化 = false;
let 英雄选择计时器: any = null;
let 英雄选择计时器窗口: any = null;
let 英雄技能查看触发: any = null;

function 创建英雄展示单位(this: void, 配置: 英雄展示配置): any {
  const 单位 = 创建单位并登记排泄安全(
    Player(NEUTRAL_PASSIVE_PLAYER_ID),
    stringToFourCC(配置.单位ID),
    配置.X,
    配置.Y,
    配置.朝向,
  );
  if (单位 != null && 单位 !== 0 && 配置.头像 != null) {
    设单位头像模型(单位, 配置.头像);
  }
  return 单位;
}

function stringToFourCC(this: void, value: string): number {
  return stringToFourCCSafe(value);
}

function 创建英雄展示批次(this: void, 配置表: 英雄展示配置[]): void {
  for (let i = 0; i < 配置表.length; i++) {
    创建英雄展示单位(配置表[i]);
  }
}

function 初始化选择场景视野(this: void): void {
  const 选择区域 = 获取矩形区域("英雄选择区域");
  if (选择区域 == null || 选择区域 === 0) return;
  for (let 玩家ID = 0; 玩家ID < 4; 玩家ID++) {
    const 视野修正器 = CreateFogModifierRect(Player(玩家ID), FOG_OF_WAR_VISIBLE, 选择区域, true, false);
    if (视野修正器 != null && 视野修正器 !== 0) FogModifierStart(视野修正器);
  }
}

function 是英雄展示单位(this: void): boolean {
  return IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) === true;
}

function 初始化英雄技能查看单位(this: void): void {
  const 选取单位 = GetEnumUnit();
  if (选取单位 == null || 选取单位 === 0) return;
  const 模型 = getObjectPropertySafe(YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId(选取单位), "file");
  YDUserDataSetSafe("unit", 选取单位, "模型", "string", 模型);
  UnitAddAbility(选取单位, HERO_SKILL_VIEW_ABILITY_ID);
  ModifyHeroSkillPoints(选取单位, HERO_SKILL_POINT_SUB, 1);
  if (英雄技能查看触发 == null || 英雄技能查看触发 === 0) return;
  TriggerRegisterUnitEvent(英雄技能查看触发, 选取单位, EVENT_UNIT_SPELL_CHANNEL);
}

function 英雄技能查看触发条件(this: void): boolean {
  if (GetTriggerEventId() === EVENT_GAME_TIMER_EXPIRED) {
    if (英雄技能查看触发 != null && 英雄技能查看触发 !== 0) {
      DestroyTrigger(英雄技能查看触发);
      英雄技能查看触发 = null;
    }
    return true;
  }
  const 触发单位 = GetTriggerUnit();
  const 选择区域 = 获取矩形区域("英雄选择区域");
  if (
    触发单位 != null &&
    触发单位 !== 0 &&
    GetOwningPlayer(触发单位) === Player(NEUTRAL_PASSIVE_PLAYER_ID) &&
    选择区域 != null &&
    选择区域 !== 0 &&
    RectContainsUnit(选择区域, 触发单位) === true
  ) {
    IssueImmediateOrder(触发单位, "stop");
    SelectUnit(触发单位, false);
  }
  return true;
}

function 准备英雄技能查看(this: void): void {
  const 选择区域 = 获取矩形区域("英雄选择区域");
  if (选择区域 == null || 选择区域 === 0) return;
  const 英雄组 = GetUnitsInRectMatching(选择区域, Condition(是英雄展示单位));
  if (英雄组 == null || 英雄组 === 0) return;
  英雄技能查看触发 = CreateTrigger();
  if (英雄技能查看触发 == null || 英雄技能查看触发 === 0) {
    DestroyGroup(英雄组);
    return;
  }
  ForGroupBJ(英雄组, 初始化英雄技能查看单位);
  TriggerRegisterTimerEventSingle(英雄技能查看触发, 300.0);
  TriggerAddCondition(英雄技能查看触发, Condition(英雄技能查看触发条件));
  DestroyGroup(英雄组);
}

function 创建第二批英雄展示(this: void): void {
  创建英雄展示批次(第二批英雄展示配置);
}

function 创建第三批英雄展示(this: void): void {
  创建英雄展示批次(第三批英雄展示配置);
}

function 创建第四批英雄展示(this: void): void {
  创建英雄展示批次(第四批英雄展示配置);
}

function 清理英雄选择场景计时器(this: void): void {
  if (英雄选择计时器窗口 != null && 英雄选择计时器窗口 !== 0) {
    TimerDialogDisplay(英雄选择计时器窗口, false);
    DestroyTimerDialog(英雄选择计时器窗口);
    英雄选择计时器窗口 = null;
  }
  if (英雄选择计时器 != null && 英雄选择计时器 !== 0) {
    DestroyTimer(英雄选择计时器);
    英雄选择计时器 = null;
  }
}

function 初始化英雄选择场景(this: void): void {
  初始化选择场景视野();

  英雄选择计时器 = CreateTimer();
  英雄选择计时器窗口 = CreateTimerDialog(英雄选择计时器);
  if (英雄选择计时器窗口 != null && 英雄选择计时器窗口 !== 0) {
    TimerDialogSetTitle(英雄选择计时器窗口, "TRIGSTR_007");
    TimerDialogDisplay(英雄选择计时器窗口, true);
  }
  TimerStart(英雄选择计时器, 180.0, false, undefined);

  创建英雄展示批次(第一批英雄展示配置);
  addDelayedCallback(900, 创建第二批英雄展示);
  addDelayedCallback(1650, 创建第三批英雄展示);
  addDelayedCallback(2400, 创建第四批英雄展示);
  addDelayedCallback(4900, 准备英雄技能查看);
  addDelayedCallback(179900, 清理英雄选择场景计时器);
}

export function 初始化世界地图英雄选择场景(this: void): void {
  if (英雄选择场景已初始化) return;
  英雄选择场景已初始化 = true;
  addDelayedCallback(100, 初始化英雄选择场景);
}

export function 获取英雄选择场景初始化状态(this: void): boolean {
  return 英雄选择场景已初始化;
}
