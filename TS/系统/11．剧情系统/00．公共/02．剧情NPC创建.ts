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

const 中立被动玩家ID = 15;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (this: void, playerId: number) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;

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
}

function 读取已绑定NPC(this: void, 配置: 剧情NPC创建配置): any {
  if (配置.YD表 == null || 配置.YD键 == null || 配置.YD字段 == null) return undefined;
  const unit = YDUserDataGetSafe("string", 配置.YD表, 配置.YD键, 配置.YD类型 ?? "unit");
  return unit == null || unit === 0 ? undefined : unit;
}

function 写入NPC绑定(this: void, 配置: 剧情NPC创建配置, unit: any): void {
  if (配置.YD表 == null || 配置.YD键 == null || 配置.YD字段 == null) return;
  YDUserDataSetSafe("string", 配置.YD表, 配置.YD键, 配置.YD类型 ?? "unit", unit);
}

/** 只负责剧情 NPC 的单位生命周期，不负责任务标记、对话或剧情入口注册。 */
export function 创建剧情NPC单位(this: void, 配置: 剧情NPC创建配置): any {
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

  if (配置.初始化无敌 === true) SetUnitInvulnerable(unit, true);
  if (配置.初始化固定站立 === true) X_FixUnitStandingSafe(unit);
  return unit;
}

export {};
