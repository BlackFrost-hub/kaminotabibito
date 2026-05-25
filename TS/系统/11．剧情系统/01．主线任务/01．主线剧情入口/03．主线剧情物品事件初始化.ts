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

import { 读取剧情进度, 写入剧情进度 } from "../00．剧情系统核心工具/01．剧情动作上下文";
import { 更新主线任务UI } from "../00．剧情系统核心工具/06．剧情通用执行工具";
import { 播放主线剧情片段 } from "../02．剧情步骤";

const GetItemTypeId = jass.GetItemTypeId as (this: void, whichItem: any) => number;
const GetPlayersAll = jass.GetPlayersAll as (this: void) => any;
const GetUnitName = jass.GetUnitName as (this: void, whichUnit: any) => string;
const IsUnitInGroup = jass.IsUnitInGroup as (this: void, whichUnit: any, whichGroup: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, whichUnitType: any) => boolean;
const RemoveItem = jass.RemoveItem as (this: void, whichItem: any) => void;

const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET as number;
const 狩猎食人魔任务物品类型ID = stringToFourCCSafe(按名字反查物品ID("接受任务-|cffff0000狩猎食人魔（等级24）|r"));
const 魔法信件物品类型ID = stringToFourCCSafe("texp");
const CS触发进度 = 9;
const CS目标进度 = 10;
const ZX02触发进度 = 28;
const ZX02目标进度 = 29;
const ZX02对白文本 = "这件物品中残留着异常的魔力波动，应该能作为新的线索。先带回王城，请克林姆德王确认。";
const ZX02任务描述 = "返回王城，将新发现的魔力线索交给克林姆德王。";
const ZX02任务提示 = "|cffffff00『主线目标』：|r返回|cffff99cc『克林姆德王城』|r。";
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

function on狩猎食人魔任务物品拾取(this: void, unit: any, item: any): void {
  if (unit == null || unit === 0) return;
  if (item == null || item === 0) return;
  if (读取剧情进度() !== CS触发进度) return;
  if (狩猎食人魔任务物品类型ID <= 0) return;
  if (GetItemTypeId(item) !== 狩猎食人魔任务物品类型ID) return;
  if (!是玩家英雄(unit)) return;

  RemoveItem(item);
  写入剧情进度(CS目标进度);
  播放主线剧情片段("jlc_snake_ogre_task_accept", {
    片段ID: "jlc_snake_ogre_task_accept",
    触发配置名: "剧情传送CS",
    触发单位: unit,
  });
}

function on魔法信件物品使用(this: void, unit: any, item: any): void {
  if (unit == null || unit === 0) return;
  if (item == null || item === 0) return;
  if (读取剧情进度() !== ZX02触发进度) return;
  if (魔法信件物品类型ID <= 0) return;
  if (UnitHasItemOfTypeBJ(unit, 魔法信件物品类型ID) !== true) return;

  if (!是玩家英雄(unit)) return;

  写入剧情进度(ZX02目标进度);
  TransmissionFromUnitWithNameBJ(GetPlayersAll(), null, GetUnitName(unit), null, ZX02对白文本, bj_TIMETYPE_SET, 5.0, true);
  更新主线任务UI(ZX02任务描述, ZX02任务提示);
}

export function 初始化主线剧情物品事件(this: void): void {
  if (已初始化主线剧情物品事件) return;
  已初始化主线剧情物品事件 = true;
  onItemPickup(on狩猎食人魔任务物品拾取);
  onItemUse(on魔法信件物品使用);
}
