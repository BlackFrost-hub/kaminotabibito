/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { DzDoodadCreate } = require("lib.扩展函数.KK扩展API.00．装饰物函数") as {
  DzDoodadCreate: (this: void, id: number, varId: number, x: number, y: number, z: number, rotate: number, scale: number) => number;
};
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { CinematicModeBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  CinematicModeBJ: (this: void, flag: boolean, whichForce: any) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 创建并冻结剧情Boss预置 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
export { 护卫试炼后回村剧情片段, 教派最终Boss启动剧情片段 } from "../01．第一章/16．第一章最终Boss教派前置";

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, whichUnit: any) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;

function 清理语义单位(this: void, 表: string, 键: string): void {
  const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
    YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  };
  const { YDUserDataClearTable } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
    YDUserDataClearTable: (this: void, tableTypeName: string, tableKey: any) => void;
  };
  const unit = YDUserDataGetSafe("string", 表, 键, "unit");
  if (unit != null && unit !== 0) RemoveUnit(unit);
  YDUserDataClearTable("string", 表);
}

export function 执行护卫试炼后回村(this: void, 参数: 剧情动作参数表): void {
  清理语义单位("ZXCS", "DW");
  清理语义单位("ZXCS2", "DW");
  CinematicModeBJ(true, GetPlayersAll());

  const 长老 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
  if (长老 != null && 长老 !== 0) {
    SetUnitPosition(长老, Number(参数.族长位置X) || -26114.4, Number(参数.族长位置Y) || -28671.3);
    SetUnitFacing(长老, 180);
  }
}

export function 执行教派袭击预置(this: void): void {
  const 神秘人ID = stringToFourCCSafe("n05H");
  const 精灵护卫ID = stringToFourCCSafe("nhef");
  const 精灵守卫ID = stringToFourCCSafe("n01H");
  if (!(神秘人ID > 0) || !(精灵护卫ID > 0) || !(精灵守卫ID > 0)) return;
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 神秘人ID, -26755.1, -28618.6, 0);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵护卫ID, -25907.1, -28413.0, 178);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵护卫ID, -25888.1, -28937.1, 185.47);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵守卫ID, -26119.9, -28926.5, 123.7);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵守卫ID, -25965.7, -29021.4, 180);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵守卫ID, -26065.8, -28460.5, 180);

  const 树木坐标: Array<[number, number]> = [
    [-27676.5, -26406.0], [-27008.7, -26384.5], [-26437.1, -27038.1], [-27524.2, -27604.2], [-27404.8, -28326.7],
    [-26557.1, -28108.3], [-24975.3, -28808.4], [-25385.3, -27834.4], [-23911.9, -29142.2], [-22237.8, -28776.7],
    [-22255.9, -28312.7], [-24574.1, -27746.7], [-23911.9, -29142.2], [-23963.1, -27718.0], [-23632.0, -27698.7],
    [-25487.6, -26993.6], [-24839.6, -26980.8], [-23963.1, -27718.0], [-24464.3, -26590.1], [-23681.3, -26604.5],
    [-23665.1, -27128.5],
  ];
  for (let i = 0; i < 树木坐标.length; i++) {
    const point = 树木坐标[i];
    DzDoodadCreate(stringToFourCCSafe("YOtf"), 1, point[0], point[1], 0, GetRandomDirectionDeg(), 1);
  }
}

export function 执行教派Boss随机姿态(this: void, 参数: 剧情动作参数表): void {
  const roll = GetRandomInt(1, 2);
  const boss名 = roll === 1 ? String(参数.剑士姿态Boss名 ?? "教派剑士") : String(参数.学者姿态Boss名 ?? "教派学者");
  创建并冻结剧情Boss预置({
    Boss键: String(参数.Boss键 ?? "Boss.蒙面人"),
    Boss名: boss名,
    X: Number(参数.出生X) || 0,
    Y: Number(参数.出生Y) || 0,
    朝向: Number(参数.朝向) || 0,
    预创建后暂停: true,
    预创建后无敌: true,
  });
}

export const 第一章最终Boss教派前置剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_护卫试炼后回村": 执行护卫试炼后回村,
  "JLC精灵村_教派袭击预置": 执行教派袭击预置,
  "JLC精灵村_教派Boss随机姿态": 执行教派Boss随机姿态,
};
