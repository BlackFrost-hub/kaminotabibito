/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 暂停并设置无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
};
const 剧情Boss预置暂停来源 = "剧情系统:Boss预置";

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 启动剧情Boss战 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接") as {
  启动剧情Boss战: (this: void, bossUnit: any, 参数?: { 触发单位?: any; 暂停来源?: string }) => boolean;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};

import type { 剧情动作参数表 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";

const Player = jass.Player as (this: void, whichPlayer: number) => any;

const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

let 已初始化进度03核心 = false;

function 读取地精巫师Boss(this: void): any {
  return YDUserDataGetSafe("string", "Boss", "地精巫师", "unit");
}

function Boss仍是前导状态(this: void, bossUnit: any): boolean {
  return bossUnit != null && bossUnit !== 0 && IsUnitAliveBJ(bossUnit);
}

export function 执行地精祭祀Boss前导激活(this: void, 参数: 剧情动作参数表): void {
  const bossUnit = 读取地精巫师Boss();
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (读取剧情进度() !== 2 || !Boss仍是前导状态(bossUnit) || !是玩家英雄组单位(触发单位)) return;
  const 血条Boss组 = YDUserDataGetSafe("string", "血条Boss", "单位组", "group");
  if (血条Boss组 != null && 血条Boss组 !== 0) {
    const GroupAddUnit = jass.GroupAddUnit as (this: void, whichGroup: any, whichUnit: any) => boolean;
    GroupAddUnit(血条Boss组, bossUnit);
  }
  const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
  SetUnitOwner(bossUnit, Player(PLAYER_NEUTRAL_AGGRESSIVE), true);
  暂停并设置无敌安全(bossUnit, 剧情Boss预置暂停来源);
}

export function 执行地精祭祀Boss战正式注册(this: void, 参数: 剧情动作参数表): void {
  const bossUnit = 读取地精巫师Boss();
  if (bossUnit == null || bossUnit === 0 || !IsUnitAliveBJ(bossUnit)) return;
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  启动剧情Boss战(bossUnit, { 触发单位, 暂停来源: 剧情Boss预置暂停来源 });
}

export const 地精祭祀Boss前导剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_地精祭祀Boss前导激活": 执行地精祭祀Boss前导激活,
  "JLC精灵村_地精祭祀Boss战正式注册": 执行地精祭祀Boss战正式注册,
};

export function 初始化进度03_地精祭祀Boss前导核心(this: void): void {
  if (已初始化进度03核心) return;
  已初始化进度03核心 = true;
}
