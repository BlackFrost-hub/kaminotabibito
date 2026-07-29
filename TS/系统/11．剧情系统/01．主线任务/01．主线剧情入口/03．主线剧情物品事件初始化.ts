/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { onItemPickup, onItemUse } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemUse: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
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

import type { 主线剧情物品事件配置, 主线剧情物品事件触发方式 } from "./00．主线剧情入口类型";
import { 主线剧情物品事件配置表 } from "./05．主线剧情事件配置表";
import { 读取剧情进度, 写入剧情进度 } from "../00．剧情系统核心工具/01．剧情动作上下文";
import { 更新主线任务UI } from "../00．剧情系统核心工具/06．剧情通用执行工具";
import { 发布主线节点目标 } from "../00．剧情系统核心工具/10．标准剧情动作";
import { 播放主线剧情片段 } from "../02．剧情步骤/02．剧情步骤播放器";

const GetItemTypeId = jass.GetItemTypeId as (this: void, whichItem: any) => number;
const GetUnitName = jass.GetUnitName as (this: void, whichUnit: any) => string;
const IsUnitInGroup = jass.IsUnitInGroup as (this: void, whichUnit: any, whichGroup: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, whichUnitType: any) => boolean;
const RemoveItem = jass.RemoveItem as (this: void, whichItem: any) => void;

const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET as number;
let 已初始化主线剧情物品事件 = false;

function 获取玩家英雄单位组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

function 是玩家英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (IsUnitType(unit, UNIT_TYPE_HERO) !== true) return false;
  const 玩家英雄单位组 = 获取玩家英雄单位组();
  if (玩家英雄单位组 == null || 玩家英雄单位组 === 0) return false;
  return IsUnitInGroup(unit, 玩家英雄单位组) === true;
}

function 获取物品事件配置类型ID(this: void, 配置: 主线剧情物品事件配置): number {
  if (配置.物品名 != null && 配置.物品名 !== "") {
    return stringToFourCCSafe(按名字反查物品ID(配置.物品名));
  }
  if (配置.物品ID != null && 配置.物品ID !== "") {
    return stringToFourCCSafe(配置.物品ID);
  }
  return 0;
}

function 命中物品事件配置(this: void, 配置: 主线剧情物品事件配置, 触发方式: 主线剧情物品事件触发方式, unit: any, item: any): boolean {
  if (配置.触发方式 !== 触发方式) return false;
  if (unit == null || unit === 0) return false;
  if (item == null || item === 0) return false;
  if (读取剧情进度() !== 配置.需要剧情进度) return false;
  if (!是玩家英雄(unit)) return false;

  const 物品类型ID = 获取物品事件配置类型ID(配置);
  if (!(物品类型ID > 0)) return false;
  if (配置.按持有物品校验 === true) {
    return UnitHasItemOfTypeBJ(unit, 物品类型ID) === true;
  }
  return GetItemTypeId(item) === 物品类型ID;
}

function 执行物品事件配置(this: void, 配置: 主线剧情物品事件配置, unit: any, item: any): void {
  if (配置.移除触发物品 === true) {
    RemoveItem(item);
  }

  写入剧情进度(配置.目标剧情进度);
  if (配置.剧情片段ID != null && 配置.剧情片段ID !== "") {
    播放主线剧情片段(配置.剧情片段ID, {
      片段ID: 配置.剧情片段ID,
      触发配置名: 配置.配置名,
      触发单位: unit,
    });
    return;
  }

  if (配置.对白文本 != null && 配置.对白文本 !== "") {
    TransmissionFromUnitWithNameBJ(GetPlayersAll(), null, GetUnitName(unit), null, 配置.对白文本, bj_TIMETYPE_SET, 5.0, true);
  }
  if (发布主线节点目标(配置.目标剧情进度)) return;
  if (配置.任务描述 != null && 配置.任务提示 != null) {
    更新主线任务UI(配置.任务描述, 配置.任务提示);
  }
}

function 处理主线剧情物品事件(this: void, 触发方式: 主线剧情物品事件触发方式, unit: any, item: any): void {
  for (let i = 0; i < 主线剧情物品事件配置表.length; i++) {
    const 配置 = 主线剧情物品事件配置表[i];
    if (!命中物品事件配置(配置, 触发方式, unit, item)) continue;
    执行物品事件配置(配置, unit, item);
    return;
  }
}

function on主线剧情物品拾取(this: void, unit: any, item: any): void {
  处理主线剧情物品事件("拾取", unit, item);
}

function on主线剧情物品使用(this: void, unit: any, item: any): void {
  处理主线剧情物品事件("使用", unit, item);
}

export function 初始化主线剧情物品事件(this: void): void {
  if (已初始化主线剧情物品事件) return;
  已初始化主线剧情物品事件 = true;
  onItemPickup(on主线剧情物品拾取);
  onItemUse(on主线剧情物品使用);
}
