/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 打开首领奖励选择界面 } = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面") as {
  打开首领奖励选择界面: (this: void, 奖励池ID: string, 玩家: any) => void;
};
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const ForGroup = jass.ForGroup as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass.GetEnumUnit as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const CreateDestructable = jass.CreateDestructable as (objectid: number, x: number, y: number, face: number, scale: number, variation: number) => any;
const DestructableRestoreLife = jass.DestructableRestoreLife as (d: any, life: number, birth: boolean) => void;

export const 通用首领奖励宝箱可破坏物ID = "BZX4";
export const 通用首领奖励宝箱生命值 = 9999;

export type 宝箱首领奖励打开范围 = "开启者" | "所有玩家英雄";

interface 宝箱首领奖励实例配置 {
  奖励池ID: string;
  打开范围: 宝箱首领奖励打开范围;
}

const 宝箱实例奖励池 = new Map<number, 宝箱首领奖励实例配置>();
let 当前宝箱首领奖励池ID = "";

function stringToFourCC(this: void, s: string): number {
  const a = s.length > 0 ? s.charCodeAt(0) : 0;
  const b = s.length > 1 ? s.charCodeAt(1) : 0;
  const c = s.length > 2 ? s.charCodeAt(2) : 0;
  const d = s.length > 3 ? s.charCodeAt(3) : 0;
  return a * 16777216 + b * 65536 + c * 256 + d;
}

function on打开所有玩家英雄首领奖励(this: void): void {
  const 英雄 = GetEnumUnit();
  if (英雄 == null || 英雄 === 0 || 当前宝箱首领奖励池ID === "") return;
  打开首领奖励选择界面(当前宝箱首领奖励池ID, GetOwningPlayer(英雄));
}

function 取实例配置(this: void, 宝箱: any): 宝箱首领奖励实例配置 | undefined {
  if (宝箱 == null || 宝箱 === 0) return undefined;
  return 宝箱实例奖励池.get(GetHandleId(宝箱));
}

export function 绑定宝箱首领奖励池(
  this: void,
  宝箱: any,
  奖励池ID: string,
  打开范围: 宝箱首领奖励打开范围 = "所有玩家英雄"
): void {
  if (宝箱 == null || 宝箱 === 0 || 奖励池ID == null || 奖励池ID === "") return;
  const handleId = GetHandleId(宝箱);
  宝箱实例奖励池.set(handleId, { 奖励池ID, 打开范围 });
  DestructableRestoreLife(宝箱, 通用首领奖励宝箱生命值, true);
}

export function 创建首领奖励宝箱(
  this: void,
  奖励池ID: string,
  x: number,
  y: number,
  打开范围: 宝箱首领奖励打开范围 = "所有玩家英雄"
): any {
  const 宝箱 = CreateDestructable(stringToFourCC(通用首领奖励宝箱可破坏物ID), x, y, 0, 1, 0);
  绑定宝箱首领奖励池(宝箱, 奖励池ID, 打开范围);
  return 宝箱;
}

export function 触发宝箱首领奖励(this: void, cfg: any, 开启者: any, 宝箱?: any): boolean {
  const 实例配置 = 取实例配置(宝箱);
  const 奖励池ID = 实例配置?.奖励池ID ?? cfg?.首领奖励池ID;
  if (奖励池ID == null || 奖励池ID === "") {
    return false;
  }

  if (宝箱 != null && 宝箱 !== 0) 宝箱实例奖励池.delete(GetHandleId(宝箱));
  const 打开范围 = 实例配置?.打开范围 ?? cfg?.首领奖励打开范围;

  if (打开范围 === "所有玩家英雄") {
    const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
    if (玩家英雄组 == null || 玩家英雄组 === 0) return true;
    当前宝箱首领奖励池ID = 奖励池ID;
    ForGroup(玩家英雄组, on打开所有玩家英雄首领奖励);
    当前宝箱首领奖励池ID = "";
    return true;
  }

  if (开启者 != null && 开启者 !== 0) {
    打开首领奖励选择界面(奖励池ID, GetOwningPlayer(开启者));
  }
  return true;
}

export { 绑定宝箱首领奖励池 as bindBossRewardChestPool };
export { 创建首领奖励宝箱 as createBossRewardChest };
