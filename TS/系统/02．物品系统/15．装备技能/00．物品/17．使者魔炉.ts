/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  单位是否有效且敌对: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 注册持有型范围光环 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.01．范围光环") as {
  注册持有型范围光环: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    半径: number;
    目标类型: "友军含自己" | "友军不含自己" | "敌人";
    去重类型?: "单位" | "玩家";
    排除无敌?: boolean;
    最小生命值?: number;
    额外筛选?: (this: void, target: any, holder: any) => boolean;
    应用目标效果: (this: void, target: any, holder: any, currentCount: number) => void;
    移除目标效果: (this: void, target: any, holder: any, currentCount: number) => void;
  }) => void;
};
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 调整玩家属性 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  调整玩家属性: (this: void, unit: any, attrName: string, delta: number) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, model: string, unit: any, attachPoint: string) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (this: void, effect: any, size: number) => void;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 使者魔炉物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者魔炉配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

const 命中率字段 = "命中率";
const 玩家英雄单位组键 = "单位组";
const 特效驱动间隔毫秒 = 20;
const 恢复驱动间隔毫秒 = 50;
const 光环同步间隔毫秒 = 100;

interface 使者魔炉特效上下文 {
  特效: any;
  次数: number;
  下次触发时间: number;
}

interface 使者魔炉恢复上下文 {
  特效: any;
  目标列表: any[];
  到期时间: number;
}

const 使者魔炉特效上下文列表: 使者魔炉特效上下文[] = [];
const 使者魔炉恢复上下文列表: 使者魔炉恢复上下文[] = [];
let 已注册使者魔炉特效驱动 = false;
let 已注册使者魔炉恢复驱动 = false;

function 是否为使者魔炉(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 使者魔炉物品ID;
}

function 调整命中率(this: void, 单位: any, 变化值: number): void {
  if (单位 == null || 单位 === 0) return;
  const 已存值 = YDUserDataGet("unit", 单位, 命中率字段, "real");
  const 当前值 = 已存值 == null ? 0 : 已存值 as number;
  YDUserDataSet("unit", 单位, 命中率字段, "real", 当前值 + 变化值);
}

function 获取玩家英雄单位组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", 玩家英雄单位组键, "group");
}

function 单位属于玩家英雄单位组(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  const 玩家英雄单位组 = 获取玩家英雄单位组();
  if (玩家英雄单位组 == null || 玩家英雄单位组 === 0) return false;
  return jass.IsUnitInGroup(单位, 玩家英雄单位组) === true;
}

function 移除特效放大上下文(this: void, 特效: any): void {
  if (特效 == null || 特效 === 0) return;
  for (let i = 使者魔炉特效上下文列表.length - 1; i >= 0; i--) {
    if (使者魔炉特效上下文列表[i].特效 === 特效) {
      使者魔炉特效上下文列表.splice(i, 1);
    }
  }
}

function on使者魔炉特效驱动(this: void): void {
  const 当前时间 = getServerTime();
  for (let i = 使者魔炉特效上下文列表.length - 1; i >= 0; i--) {
    const 上下文 = 使者魔炉特效上下文列表[i];
    if (上下文.特效 == null || 上下文.特效 === 0) {
      使者魔炉特效上下文列表.splice(i, 1);
      continue;
    }
    if (当前时间 < 上下文.下次触发时间) continue;
    上下文.次数 += 1;
    if (上下文.次数 >= 使者魔炉配置.特效放大次数) {
      使者魔炉特效上下文列表.splice(i, 1);
      continue;
    }
    EXSetEffectSize(上下文.特效, 使者魔炉配置.特效放大基值 + 上下文.次数);
    上下文.下次触发时间 = 当前时间 + 使者魔炉配置.特效放大周期 * 1000;
  }
}

function on使者魔炉恢复驱动(this: void): void {
  const 当前时间 = getServerTime();
  for (let i = 使者魔炉恢复上下文列表.length - 1; i >= 0; i--) {
    const 上下文 = 使者魔炉恢复上下文列表[i];
    if (当前时间 < 上下文.到期时间) continue;
    for (let j = 0; j < 上下文.目标列表.length; j++) {
      调整命中率(上下文.目标列表[j], 使者魔炉配置.命中率削减);
    }
    移除特效放大上下文(上下文.特效);
    if (上下文.特效 != null && 上下文.特效 !== 0) {
      DestroyEffect(上下文.特效);
    }
    使者魔炉恢复上下文列表.splice(i, 1);
  }
}

function 确保使者魔炉特效驱动已注册(this: void): void {
  if (已注册使者魔炉特效驱动) return;
  已注册使者魔炉特效驱动 = true;
  addPeriodicCallback(特效驱动间隔毫秒, on使者魔炉特效驱动);
}

function 确保使者魔炉恢复驱动已注册(this: void): void {
  if (已注册使者魔炉恢复驱动) return;
  已注册使者魔炉恢复驱动 = true;
  addPeriodicCallback(恢复驱动间隔毫秒, on使者魔炉恢复驱动);
}

function 启动特效放大(this: void, 特效: any): void {
  if (特效 == null || 特效 === 0) return;
  确保使者魔炉特效驱动已注册();
  使者魔炉特效上下文列表.push({
    特效,
    次数: 0,
    下次触发时间: getServerTime() + 使者魔炉配置.特效放大周期 * 1000,
  });
}

function 启动命中恢复(this: void, 特效: any, 目标列表: any[]): void {
  确保使者魔炉恢复驱动已注册();
  使者魔炉恢复上下文列表.push({
    特效,
    目标列表,
    到期时间: getServerTime() + 使者魔炉配置.恢复延迟 * 1000,
  });
}

function 应用使者魔炉光环(this: void, 目标单位: any, _持有者: any, currentCount: number): void {
  调整玩家属性(目标单位, "魔法伤害", 使者魔炉配置.光环魔法伤害提升 * currentCount);
  调整玩家属性(目标单位, "魔法恢复", 使者魔炉配置.光环魔法恢复提升 * currentCount);
}

function 移除使者魔炉光环(this: void, 目标单位: any, _持有者: any, currentCount: number): void {
  调整玩家属性(目标单位, "魔法伤害", -使者魔炉配置.光环魔法伤害提升 * currentCount);
  调整玩家属性(目标单位, "魔法恢复", -使者魔炉配置.光环魔法恢复提升 * currentCount);
}

function 初始化使者魔炉光环(this: void): void {
  if (使者魔炉物品ID === 0) return;
  注册持有型范围光环({
    物品类型ID: 使者魔炉物品ID,
    间隔毫秒: 光环同步间隔毫秒,
    半径: 使者魔炉配置.光环半径,
    目标类型: "友军含自己",
    去重类型: "玩家",
    额外筛选: 单位属于玩家英雄单位组,
    应用目标效果: 应用使者魔炉光环,
    移除目标效果: 移除使者魔炉光环,
  });
}

export function 处理使者魔炉使用(this: void, 上下文: 物品技能事件上下文): void {
  debugLogForce("18．使者魔炉", "进入", "处理使者魔炉使用");

  if (!是否为使者魔炉(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  const 特效 = AddSpecialEffectTarget(使者魔炉配置.特效路径, 目标单位, 使者魔炉配置.特效挂点);
  if (特效 != null && 特效 !== 0) {
    启动特效放大(特效);
  }

  const 命中目标列表: any[] = [];
  const 敌人列表 = 获取坐标范围敌人(施法单位, GetUnitX(目标单位), GetUnitY(目标单位), 使者魔炉配置.作用范围);
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!单位是否有效且敌对(敌人, 施法单位)) continue;
    调整命中率(敌人, -使者魔炉配置.命中率削减);
    命中目标列表.push(敌人);
  }
  启动命中恢复(特效, 命中目标列表);
}

初始化使者魔炉光环();

export {};
