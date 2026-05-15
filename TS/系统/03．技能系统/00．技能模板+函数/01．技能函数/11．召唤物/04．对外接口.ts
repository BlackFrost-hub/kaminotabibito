/** @noSelfInFile */
/**
 * 召唤物系统 - 对外入口
 */

const jass = require("jass.common") as any;

const GetLocationX = jass.GetLocationX as (loc: any) => number;
const GetLocationY = jass.GetLocationY as (loc: any) => number;
const RemoveLocation = jass.RemoveLocation as (loc: any) => void;
const bj_UNIT_FACING = jass.bj_UNIT_FACING ?? 270.0;

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (s: string | undefined | null) => number;
};
const { fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  fourCCToString: (fourcc: number) => string;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import type { 召唤物输入参数, 规范化召唤物参数 } from "./01．类型";
import { 创建召唤物核心 } from "./02．召唤物核心";

const 模块名 = "召唤物入口";

function 绝对值(value: number): number {
  return value >= 0 ? value : -value;
}

function 是否有效单位四字码(this: void, rawcode: number): boolean {
  if (!(rawcode > 0)) return false;
  const slkTable = ((globalThis as any).slk?.unit ?? null) as Record<string, any> | null;
  if (slkTable == null) return false;
  const id = fourCCToString(rawcode);
  return slkTable[id] != null;
}

function 尝试纠正单位四字码(this: void, rawcode: number): number {
  if (!(rawcode > 0)) return rawcode;
  if (是否有效单位四字码(rawcode)) return rawcode;

  let best = 0;
  let bestDelta = 999999;
  let delta = -127;
  while (delta <= 127) {
    const candidate = rawcode + delta;
    if (candidate > 0 && 是否有效单位四字码(candidate)) {
      const absDelta = 绝对值(delta);
      if (absDelta < bestDelta) {
        best = candidate;
        bestDelta = absDelta;
        if (absDelta === 0) break;
      }
    }
    delta += 1;
  }

  if (best !== 0 && best !== rawcode) {
    debugLogForce(
      模块名,
      "纠正损坏 unitType",
      "raw=", rawcode,
      "rawStr=", fourCCToString(rawcode),
      "fixed=", best,
      "fixedStr=", fourCCToString(best),
    );
    return best;
  }

  return rawcode;
}

function 归一化单位类型(单位类型: string | number | undefined): number | undefined {
  if (typeof 单位类型 === "number" && 单位类型 !== 0) return 尝试纠正单位四字码(单位类型);
  if (typeof 单位类型 === "string" && 单位类型.length === 4) return stringToFourCC(单位类型);
  return undefined;
}

function 解析位置X(参数: 召唤物输入参数): number {
  if (参数.X != null) return 参数.X;
  if (参数.x != null) return 参数.x;
  const loc = 参数.位置 ?? 参数.loc;
  if (loc != null && loc !== 0) return GetLocationX(loc);
  return 0;
}

function 解析位置Y(参数: 召唤物输入参数): number {
  if (参数.Y != null) return 参数.Y;
  if (参数.y != null) return 参数.y;
  const loc = 参数.位置 ?? 参数.loc;
  if (loc != null && loc !== 0) return GetLocationY(loc);
  return 0;
}

function 解析朝向(参数: 召唤物输入参数): number | undefined {
  if (参数.朝向 != null) return 参数.朝向;
  if (参数.面向 != null) return 参数.面向;
  if (参数.facing != null) return 参数.facing;
  if (参数.fac != null) return 参数.fac;
  return undefined;
}

function 解析飞行高度(参数: 召唤物输入参数): number | undefined {
  if (参数.飞行高度 != null) return 参数.飞行高度;
  if (参数.z != null) return 参数.z;
  if (参数.moveHeight != null) return 参数.moveHeight;
  if (参数.MoveHeight != null) return 参数.MoveHeight;
  return undefined;
}

function 解析模型文件(参数: 召唤物输入参数): string | undefined {
  if (参数.模型文件 != null && 参数.模型文件 !== "") return 参数.模型文件;
  if (参数.模型路径 != null && 参数.模型路径 !== "") return 参数.模型路径;
  if (参数.ModelFileID != null && 参数.ModelFileID !== "") return 参数.ModelFileID;
  return undefined;
}

function 规范化召唤物参数输入(参数: 召唤物输入参数): 规范化召唤物参数 {
  return {
    主人单位: 参数.主人单位 ?? 参数.Master,
    所属玩家: 参数.所属玩家 ?? 参数.player,
    单位类型: 归一化单位类型(参数.单位类型 ?? 参数.unitType ?? 参数.uid),
    召唤物单位: 参数.召唤物单位 ?? 参数.Summon,
    X: 解析位置X(参数),
    Y: 解析位置Y(参数),
    位置: 参数.位置 ?? 参数.loc,
    朝向: 解析朝向(参数),
    持续时间: 参数.持续时间 ?? 参数.time,
    飞行高度: 解析飞行高度(参数),
    模型文件: 解析模型文件(参数),
    生命值: 参数.生命值 ?? 参数.HP,
    生命恢复: 参数.生命恢复 ?? 参数.regenHP,
    攻击力: 参数.攻击力 ?? 参数.AttackPower,
    攻击间隔: 参数.攻击间隔 ?? 参数.atkCd,
    护甲: 参数.护甲 ?? 参数.def,
    缩放: 参数.缩放 ?? 参数.size,
    透明度: 参数.透明度 ?? 参数.alpha,
    红: 参数.红 ?? 参数.red,
    绿: 参数.绿 ?? 参数.green,
    蓝: 参数.蓝 ?? 参数.blue,
    是否移除地点: 参数.是否移除地点 ?? 参数.removeLoc ?? 参数.b,
  };
}

export function 创建召唤物(this: void, 参数: 召唤物输入参数): any {
  const 规范化参数 = 规范化召唤物参数输入(参数);
  if (规范化参数.朝向 == null) {
    规范化参数.朝向 = bj_UNIT_FACING;
  }

  const 召唤物 = 创建召唤物核心(规范化参数);

  if (规范化参数.是否移除地点 && 规范化参数.位置 != null && 规范化参数.位置 !== 0) {
    RemoveLocation(规范化参数.位置);
  }

  return 召唤物;
}

export function 快捷创建召唤物(
  this: void,
  主人单位: any,
  单位类型: string | number,
  X: number,
  Y: number,
  持续时间: number,
  额外参数?: Omit<召唤物输入参数, "主人单位" | "单位类型" | "X" | "Y" | "持续时间">
): any {
  return 创建召唤物({
    主人单位,
    单位类型,
    X,
    Y,
    持续时间,
    ...额外参数,
  });
}

export function SUO_CreateUnit_Loc(
  this: void,
  所属玩家: any,
  uid: string | number,
  loc: any,
  z: number,
  fac: number,
  alpha: number,
  red: number,
  green: number,
  blue: number,
  time: number,
  b: boolean
): any {
  return 创建召唤物({
    所属玩家,
    uid,
    loc,
    z,
    fac,
    alpha,
    red,
    green,
    blue,
    time,
    b,
  });
}

export function 创建召唤物并套用JASS模板(this: void, 参数: 召唤物输入参数): any {
  return 创建召唤物(参数);
}
