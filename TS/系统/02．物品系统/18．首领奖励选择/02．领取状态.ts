/** @noSelfInFile */

import { 首领奖励领取记录 } from "./00．类型定义";

const 首领奖励领取记录表: 首领奖励领取记录[] = [];

function 查找领取记录序号(this: void, 奖励池ID: string, 玩家ID: number): number {
  for (let 序号 = 0; 序号 < 首领奖励领取记录表.length; 序号++) {
    const 记录 = 首领奖励领取记录表[序号];
    if (记录.奖励池ID === 奖励池ID && 记录.玩家ID === 玩家ID) return 序号;
  }
  return -1;
}

export function 是否已领取首领奖励(
  this: void,
  奖励池ID: string,
  玩家ID: number
): boolean {
  return 查找领取记录序号(奖励池ID, 玩家ID) >= 0;
}

export function 标记首领奖励已领取(
  this: void,
  奖励池ID: string,
  玩家ID: number,
  已选装备名: string[]
): boolean {
  if (是否已领取首领奖励(奖励池ID, 玩家ID)) return false;
  首领奖励领取记录表.push({ 奖励池ID, 玩家ID, 已选装备名 });
  return true;
}

export function 获取首领奖励领取记录(
  this: void,
  奖励池ID: string,
  玩家ID: number
): 首领奖励领取记录 | null {
  const 序号 = 查找领取记录序号(奖励池ID, 玩家ID);
  if (序号 < 0) return null;
  return 首领奖励领取记录表[序号];
}

export function 清除首领奖励领取记录(
  this: void,
  奖励池ID: string,
  玩家ID: number
): boolean {
  const 序号 = 查找领取记录序号(奖励池ID, 玩家ID);
  if (序号 < 0) return false;
  首领奖励领取记录表.splice(序号, 1);
  return true;
}
