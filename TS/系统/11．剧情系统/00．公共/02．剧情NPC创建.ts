/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 添加单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 暂停并设置无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
};

const 中立被动玩家ID = 15;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (this: void, playerId: number) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;

const 剧情NPC创建诊断模块 = "剧情NPC创建诊断";

export interface 剧情NPC创建配置 {
  单位ID: string;
  X: number;
  Y: number;
  朝向: number;
  玩家ID?: number;
  YD表?: string;
  YD键?: string;
  YD字段?: string;
  YD类型?: "unit";
  初始化无敌?: boolean;
  初始化固定站立?: boolean;
  登记死亡排泄?: boolean;
  /** 默认不发布命令；场景演员通常配置为 stop。 */
  初始化命令?: string | false;
  /** 非空时使用来源计数暂停；可与初始化无敌组合为安全待战状态。 */
  初始化暂停来源?: string;
}

export type 剧情场景单位配置 = 剧情NPC创建配置;

function 读取已绑定NPC(this: void, 配置: 剧情NPC创建配置): any {
  if (配置.YD表 == null || 配置.YD键 == null || 配置.YD字段 == null) return undefined;
  const unit = YDUserDataGetSafe("string", 配置.YD表, 配置.YD键, 配置.YD类型 ?? "unit");
  return unit == null || unit === 0 ? undefined : unit;
}

function 写入NPC绑定(this: void, 配置: 剧情NPC创建配置, unit: any): void {
  if (配置.YD表 == null || 配置.YD键 == null || 配置.YD字段 == null) return;
  YDUserDataSetSafe("string", 配置.YD表, 配置.YD键, 配置.YD类型 ?? "unit", unit);
}

/** 配置化创建或复用场景单位；不负责任务标记、对白和入口监听。 */
export function 创建剧情场景单位(this: void, 配置: 剧情场景单位配置): any {
  let unit = 读取已绑定NPC(配置);
  if (unit == null) {
    const owner = Player(配置.玩家ID ?? 中立被动玩家ID);
    const unitTypeId = stringToFourCCSafe(配置.单位ID);
    if (!(unitTypeId > 0)) return null;
    debugLogForce(
      剧情NPC创建诊断模块,
      "CreateUnit前",
      "单位ID", 配置.单位ID,
      "单位码", unitTypeId,
      "配置玩家ID", 配置.玩家ID ?? 中立被动玩家ID,
      "实际玩家ID", GetPlayerId(owner),
      "X", 配置.X,
      "Y", 配置.Y,
      "朝向", 配置.朝向,
      "YD表", 配置.YD表 ?? "",
      "YD键", 配置.YD键 ?? "",
      "死亡排泄", 配置.登记死亡排泄 === true,
    );
    unit = 配置.登记死亡排泄 === true
      ? 创建单位并登记排泄安全(owner, unitTypeId, 配置.X, 配置.Y, 配置.朝向)
      : CreateUnit(owner, unitTypeId, 配置.X, 配置.Y, 配置.朝向);
    if (unit == null) return null;
    写入NPC绑定(配置, unit);
  }

  if (配置.初始化命令 !== undefined && 配置.初始化命令 !== false) {
    IssueImmediateOrder(unit, 配置.初始化命令);
  }
  const 暂停来源 = 配置.初始化暂停来源 ?? "";
  if (暂停来源 !== "") {
    if (配置.初始化无敌 === true) 暂停并设置无敌安全(unit, 暂停来源);
    else 添加单位暂停(unit, 暂停来源);
  } else if (配置.初始化无敌 === true) {
    SetUnitInvulnerable(unit, true);
  }
  if (配置.初始化固定站立 === true) X_FixUnitStandingSafe(unit);
  return unit;
}

export interface 剧情单位站位配置 {
  X: number;
  Y: number;
  朝向: number;
  /** 默认 stop；传入 false 时只定位和转向。 */
  命令?: string | false;
}

/** 统一复用单位的场景站位动作；创建新单位时优先直接使用创建剧情场景单位配置。 */
export function 定位剧情单位(this: void, unit: any, 站位: 剧情单位站位配置): boolean {
  if (unit == null || unit === 0) return false;
  SetUnitPosition(unit, 站位.X, 站位.Y);
  SetUnitFacing(unit, 站位.朝向);
  const 命令 = 站位.命令 === undefined ? "stop" : 站位.命令;
  if (命令 !== false) IssueImmediateOrder(unit, 命令);
  return true;
}

export function 批量创建剧情场景单位(this: void, 配置列表: readonly 剧情场景单位配置[]): any[] {
  const 结果: any[] = [];
  for (let i = 0; i < 配置列表.length; i++) {
    const unit = 创建剧情场景单位(配置列表[i]);
    if (unit != null && unit !== 0) 结果.push(unit);
  }
  return 结果;
}

/** 兼容现有 NPC 配置；新场景演员、入口单位和待战单位统一调用场景单位接口。 */
export function 创建剧情NPC单位(this: void, 配置: 剧情NPC创建配置): any {
  return 创建剧情场景单位(配置);
}

export {};
