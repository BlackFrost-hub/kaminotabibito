/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 创建单位临时属性效果托管器 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const { 监听指定物品获取丢弃 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听") as {
  监听指定物品获取丢弃: (this: void, itemTypeId: number, 获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void, 丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

const 焰混能量体效果托管器 = 创建单位临时属性效果托管器();
let 已初始化焰混能量体被动 = false;

function 清除焰混能量体(this: void, unit: any): void {
  焰混能量体效果托管器.清除(unit);
  移除单位指定Buff(unit, 常规BuffID.焰混能量体_混焰);
}

function 设置焰混能量体无视魔抗(this: void, unit: any, enabled: boolean): void {
  if (unit == null || unit === 0) return;
  YDUserDataSetSafe("unit", unit, "无视魔抗", "boolean", enabled);
}

function on获得焰混能量体(this: void, unit: any): void {
  设置焰混能量体无视魔抗(unit, true);
}

function on丢弃焰混能量体(this: void, unit: any, _item: any, currentCount: number): void {
  if (currentCount <= 0) 设置焰混能量体无视魔抗(unit, false);
}

export function 处理焰混能量体使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.焰混能量体)) return;
  const unit = ctx.施法单位;
  清除焰混能量体(unit);
  const cfg = 物品使用数值配置.焰混能量体;
  焰混能量体效果托管器.施加(unit, cfg.持续毫秒, [{ 类型: "攻速", 数值: cfg.攻速 }], {
    次数: cfg.普攻次数,
    on清除: function on焰混能量体主动清除(this: void, u: any): void {
      移除单位指定Buff(u, 常规BuffID.焰混能量体_混焰);
    },
  });
  registerManualBuff(unit, 常规BuffID.焰混能量体_混焰, cfg.持续毫秒 / 1000, cfg.攻速显示, {
    sourceUnit: unit,
    effectSourceName: "焰混能量体",
    effectSourceType: "装备",
    effectValue2: cfg.普攻次数,
  });
}

export function 处理焰混能量体伤害(this: void, _target: any, attacker: any, _applied: number, snapshot: any): void {
  if (snapshot == null || snapshot.isNormalAttack !== true) return;
  焰混能量体效果托管器.消耗次数(attacker, 1);
}

export function 初始化焰混能量体被动(this: void): void {
  if (已初始化焰混能量体被动) return;
  已初始化焰混能量体被动 = true;
  监听指定物品获取丢弃(物品使用装备ID.焰混能量体, on获得焰混能量体, on丢弃焰混能量体);
}

export {};
