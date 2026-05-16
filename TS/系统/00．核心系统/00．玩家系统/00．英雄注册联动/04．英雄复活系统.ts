/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { udg_FHD?: any; [key: string]: any };

const YDWE模块 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
  YDUserDataSet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string, value: any) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { X_IsTerrainWalkable } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_IsTerrainWalkable: (this: void, x: number, y: number) => boolean;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};

function 移动镜头到玩家(this: void, 玩家: any, x: number, y: number): void {
  StarOther_PanCameraToTimedForPlayer(玩家, x, y, 0.1);
}
const GetUnitX = jass.GetUnitX as (unit: any) => number;  
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const ReviveHeroLoc = jass.ReviveHeroLoc as (whichHero: any, loc: any, showExp: boolean) => void;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetRandomDirectionDeg = jass.GetRandomDirectionDeg as () => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const Location = jass.Location as (x: number, y: number) => any;
const RemoveLocation = jass.RemoveLocation as (loc: any) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;

const 复活延迟秒 = 10.0;
const 复活半径 = 400.0;
const 最大尝试次数 = 8;
const 复活次数属性 = "次数";
const 复活次数表 = "团队复活";
const Boss战表 = "Boss战";
const Boss战单位属性 = "单位";

const 设置测试次数 = true;
const 测试复活次数 = 10;
let 已注册死亡 = false;

function 是否有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 是玩家英雄(this: void, unit: any): boolean {
  if (!是否有效(unit)) return false;
  return getRegisteredPlayerHero(GetOwningPlayer(unit)) === unit;
}

function 寻找可通行复活点(this: void, boss: any): { x: number; y: number } | null {
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);

  for (let i = 0; i < 最大尝试次数; i++) {
    const 角度度 = GetRandomDirectionDeg();
    const 弧度 = 角度度 * 0.01745329252;
    const x = bx + GetRandomReal(0, 复活半径) * Cos(弧度);
    const y = by + GetRandomReal(0, 复活半径) * Sin(弧度);

    if (X_IsTerrainWalkable(x, y)) {
      return { x, y };
    }
  }

  return null;
}

function 执行复活(this: void, dyingUnit: any): void {
  if (!是否有效(dyingUnit)) return;
  if (!是玩家英雄(dyingUnit)) return;
  if (jass.IsUnitType(dyingUnit, jass.UNIT_TYPE_DEAD) !== true) return;

  const 剩余次数 = YDWE模块.YDUserDataGet("string", 复活次数表, 复活次数属性, "integer") as number | undefined;
  if (剩余次数 != null && 剩余次数 <= 0) return;

  if (剩余次数 != null) {
    YDWE模块.YDUserDataSet("string", 复活次数表, 复活次数属性, "integer", 剩余次数 - 1);
  }

  const boss = YDWE模块.YDUserDataGet("string", Boss战表, Boss战单位属性, "unit");
  if (是否有效(boss)) {
    const pos = 寻找可通行复活点(boss);
    if (pos == null) return;

    const loc = Location(pos.x, pos.y);
    ReviveHeroLoc(dyingUnit, loc, true);
    RemoveLocation(loc);
    SetUnitInvulnerable(dyingUnit, false);
    addDelayedCallback(0, function(this: void): void {
      移动镜头到玩家(GetOwningPlayer(dyingUnit), pos.x, pos.y);
    });
  } else {
    const 复活点 = g.udg_FHD;
    if (!是否有效(复活点)) return;
    ReviveHeroLoc(dyingUnit, 复活点, true);
    addDelayedCallback(0, function(this: void): void {
      移动镜头到玩家(GetOwningPlayer(dyingUnit), GetUnitX(dyingUnit), GetUnitY(dyingUnit));
    });
  }
}

function 英雄死亡延迟复活(this: void, dyingUnit: any, 击杀者: any): void {
  if (!是玩家英雄(dyingUnit)) return;
  addDelayedCallback(复活延迟秒 * 1000, function(this: void): void {
    执行复活(dyingUnit);
  });
}

export function 初始化英雄复活(this: void): void {
  if (已注册死亡) return;
  已注册死亡 = true;

  if (设置测试次数) {
    YDWE模块.YDUserDataSet("string", 复活次数表, 复活次数属性, "integer", 测试复活次数);
  }

  const 死亡模块 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心");
  (死亡模块.registerDeathListener as (cb: Function) => void)(英雄死亡延迟复活);
}

export {};
