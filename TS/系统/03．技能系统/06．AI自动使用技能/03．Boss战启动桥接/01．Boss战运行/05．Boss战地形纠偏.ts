/** @noSelfInFile */

import type { Boss战运行上下文 } from "./01．Boss战运行上下文";

const jass = require("jass.common") as any;

const { RectContainsUnit } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  RectContainsUnit: (this: void, rectHandle: any, whichUnit: any) => boolean;
};
const { IsUnitPausedBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as {
  IsUnitPausedBJ: (this: void, unit: any) => boolean;
};
const { 单位是否正在原生施法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态") as {
  单位是否正在原生施法: (this: void, unit: any) => boolean;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (whichUnit: any, x: number, y: number) => void;
const IsTerrainPathable = jass.IsTerrainPathable as (x: number, y: number, pathingType: number) => boolean;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const ForGroup = jass.ForGroup as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass.GetEnumUnit as () => any;

const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as number;
const 玩家地形纠偏步长 = 150;
const 玩家地形纠偏最大步数 = 24;

let 当前纠偏矩形: any = null;
let 当前目标X = 0;
let 当前目标Y = 0;

function 读取玩家英雄组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

function on快速纠偏玩家英雄(this: void): void {
  const unit = GetEnumUnit();
  if (unit == null || unit === 0) return;
  if (单位是否正在原生施法(unit)) return;
  if (IsUnitPausedBJ(unit)) return;
  if (当前纠偏矩形 != null && 当前纠偏矩形 !== 0 && !RectContainsUnit(当前纠偏矩形, unit)) return;
  if (!IsTerrainPathable(GetUnitX(unit), GetUnitY(unit), PATHING_TYPE_WALKABILITY)) return;

  let currentX = GetUnitX(unit);
  let currentY = GetUnitY(unit);
  for (let i = 0; i < 玩家地形纠偏最大步数; i++) {
    const dx = 当前目标X - currentX;
    const dy = 当前目标Y - currentY;
    const distSq = dx * dx + dy * dy;
    if (distSq <= 0.01) break;

    const dist = SquareRoot(distSq);
    if (dist <= 0.01) break;

    const move = dist < 玩家地形纠偏步长 ? dist : 玩家地形纠偏步长;
    currentX += (dx / dist) * move;
    currentY += (dy / dist) * move;
    SetUnitPosition(unit, currentX, currentY);

    if (!IsTerrainPathable(GetUnitX(unit), GetUnitY(unit), PATHING_TYPE_WALKABILITY)) {
      return;
    }
  }
}

export function 纠偏玩家英雄位置到Boss(this: void, context: Boss战运行上下文): void {
  const 玩家英雄组 = 读取玩家英雄组();
  if (玩家英雄组 == null || 玩家英雄组 === 0) return;
  if (context.地点矩形 == null || context.地点矩形 === 0) return;

  当前纠偏矩形 = context.地点矩形;
  当前目标X = GetUnitX(context.Boss单位);
  当前目标Y = GetUnitY(context.Boss单位);
  ForGroup(玩家英雄组, on快速纠偏玩家英雄);
}
