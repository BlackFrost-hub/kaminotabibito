/** @noSelfInFile */

import { 主动物品调试日志, 延迟执行 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const jass = require("jass.common") as any;

const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  单位是否有效且敌对: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 启动特效步进缩放, 移除特效步进缩放 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效") as {
  启动特效步进缩放: (this: void, effect: any, baseSize: number, maxCount: number, periodSeconds: number, stepSize?: number) => void;
  移除特效步进缩放: (this: void, effect: any) => void;
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
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, model: string, unit: any, attachPoint: string) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 使者魔炉物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者魔炉配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 调整玩家属性, 调整单位属性 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const 命中率字段 = "命中率";
const 使者魔炉致盲BuffID = "C042";
const 光环同步间隔毫秒 = 100;

function 是否为使者魔炉(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 使者魔炉物品ID;
}

function 调整命中率(this: void, 单位: any, 变化值: number): void {
  调整单位属性(单位, 命中率字段, 变化值);
}

function 启动特效放大(this: void, 特效: any): void {
  if (特效 == null || 特效 === 0) return;
  启动特效步进缩放(
    特效,
    使者魔炉配置.特效放大基值,
    使者魔炉配置.特效放大次数,
    使者魔炉配置.特效放大周期
  );
}

function 启动命中恢复(this: void, 特效: any, 目标列表: any[]): void {
  延迟执行(使者魔炉配置.恢复延迟 * 1000, function on使者魔炉命中恢复(this: void): void {
    for (let j = 0; j < 目标列表.length; j++) {
      调整命中率(目标列表[j], 使者魔炉配置.命中率削减);
    }
    移除特效步进缩放(特效);
    if (特效 != null && 特效 !== 0) {
      DestroyEffect(特效);
    }
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
    额外筛选: 是玩家英雄组单位,
    应用目标效果: 应用使者魔炉光环,
    移除目标效果: 移除使者魔炉光环,
  });
}

export function 处理使者魔炉使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("18．使者魔炉", "进入", "处理使者魔炉使用");

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
    registerManualBuff(敌人, 使者魔炉致盲BuffID, 使者魔炉配置.恢复延迟, 使者魔炉配置.命中率削减 * 100, {
      sourceUnit: 施法单位,
      effectSourceName: "使者魔炉",
      effectSourceType: "装备",
      iconOverride: "ReplaceableTextures\\CommandButtons\\BTN000230.blp",
    });
    命中目标列表.push(敌人);
  }
  启动命中恢复(特效, 命中目标列表);
}

初始化使者魔炉光环();

export {};
