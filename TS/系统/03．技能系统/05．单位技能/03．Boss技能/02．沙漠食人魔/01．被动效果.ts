/** @noSelfInFile */

const {
  转四位ID,
  单位拥有原生Buff,
  读取单位累计实数,
  写入单位累计实数,
  注册指定单位暴击率修正,
  注册指定单位暴击后监听,
} = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  转四位ID: (this: void, rawIdText: string) => number;
  单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  读取单位累计实数: (this: void, unit: any, key: string) => number;
  写入单位累计实数: (this: void, unit: any, key: string, value: number) => void;
  注册指定单位暴击率修正: (this: void, unitTypeId: number, handler: (this: void, context: any) => number | undefined) => void;
  注册指定单位暴击后监听: (this: void, unitTypeId: number, handler: (this: void, record: any, applied: number, snapshot: any) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
const { 沙漠食人魔单位技能配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．沙漠食人魔.00．配置") as {
  沙漠食人魔单位技能配置: {
    单位ID: string;
    触发BuffID: string;
    累计键: string;
    暴击加成系数: number;
    清空键: string;
  };
};

const jass = require("jass.common") as any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;

const 沙漠食人魔单位类型ID = 转四位ID(沙漠食人魔单位技能配置.单位ID);
const 沙漠食人魔触发BuffID = 转四位ID(沙漠食人魔单位技能配置.触发BuffID);

function 目标是已注册玩家英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  return getRegisteredPlayerHero(owner) === unit;
}

function 沙漠食人魔暴击率修正(this: void, context: any): number {
  if (!单位拥有原生Buff(context.attacker, 沙漠食人魔触发BuffID)) return context.暴击率;
  if (!目标是已注册玩家英雄(context.target)) return context.暴击率;
  const stack = 读取单位累计实数(context.target, 沙漠食人魔单位技能配置.累计键);
  if (!(stack > 0)) return context.暴击率;
  return context.暴击率 + stack * 沙漠食人魔单位技能配置.暴击加成系数;
}

function 沙漠食人魔暴击后处理(this: void, record: any, _applied: number, _snapshot: any): void {
  if (!单位拥有原生Buff(record.attacker, 沙漠食人魔触发BuffID)) return;
  if (!目标是已注册玩家英雄(record.target)) return;
  写入单位累计实数(record.target, 沙漠食人魔单位技能配置.累计键, 0);
  写入单位累计实数(record.target, 沙漠食人魔单位技能配置.清空键, 0);
}

export function 注册沙漠食人魔被动效果(this: void): void {
  注册指定单位暴击率修正(沙漠食人魔单位类型ID, 沙漠食人魔暴击率修正);
  注册指定单位暴击后监听(沙漠食人魔单位类型ID, 沙漠食人魔暴击后处理);
}

注册沙漠食人魔被动效果();
