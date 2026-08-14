/** @noSelfInFile */

/**
 * 欧尔贝克 - W：积攒
 *
 * 源 JASS：OEBR 触发器 A0IZ 分支 + 周期回调 Trig_OEBRFunc003Func012T。
 * - 施法后获得「积攒」Buff（B01W，由技能对象数据自动附加，持续 5 秒）。
 * - 攻击力提升 = 攻击力 × (25% + 3% × 等级)（取整），暴击率提升 = 5% + 1% × 等级。
 * - 期间普攻命中会消耗积攒计数（初始 5 次）；计数耗尽、Buff 消失、单位死亡或
 *   5 秒到期任一发生时，自动还原属性加成并结束效果。
 * - 持续期间每 0.15 秒在自身位置播放一次周期性特效。
 */

import { 欧尔贝克单位技能配置 } from "./00．配置";
import { 播放欧尔贝克单位音效 } from "./00A．表现工具";
import { 获取欧尔贝克积攒计数, 设置欧尔贝克积攒计数 } from "./00B．积攒状态";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 临时调整攻击, 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  临时调整攻击: (this: void, 单位: any, 数值: number) => void;
  调整玩家属性: (this: void, 单位: any, 属性名: string, 增量: number) => void;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { 单位拥有原生Buff, 单位是指定类型 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  单位是指定类型: (this: void, unit: any, typeId: number) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    Z轴角度?: number;
    缩放?: number;
    持续秒?: number;
  }) => any;
};

const W技能ID = stringToFourCCSafe(欧尔贝克单位技能配置.W技能ID);
const 欧尔贝克单位类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.单位类型ID);
const 积攒Buff类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.积攒BuffID);

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

interface 积攒状态记录 {
  单位: any;
  周期: number;
  周期回调ID: number;
  到期回调ID: number;
  攻击加成: number;
  暴击加成: number;
}

/** 每单位同时只保留一份积攒效果（重复施法先还原再重开） */
const 积攒状态缓存: Record<number, 积攒状态记录 | undefined> = {};

function 结束积攒(this: void, id: number, record: 积攒状态记录): void {
  if (积攒状态缓存[id] !== record) return;
  if (record.周期回调ID !== 0) removePeriodicCallback(record.周期回调ID);
  if (record.到期回调ID !== 0) removeDelayedCallback(record.到期回调ID);
  // 还原属性加成（临时调整攻击/调整玩家属性均为增量式，取负即还原）
  临时调整攻击(record.单位, -record.攻击加成);
  调整玩家属性(record.单位, "暴击率", -record.暴击加成);
  // 积攒计数清零，结束本次积攒
  设置欧尔贝克积攒计数(record.单位, 0);
  delete 积攒状态缓存[id];
}

function on欧尔贝克W(this: void, caster: any, abilityId: number): void {
  if (abilityId !== W技能ID) return;
  if (!单位是指定类型(caster, 欧尔贝克单位类型ID)) return;

  const cfg = 欧尔贝克单位技能配置.W;
  const level = GetUnitAbilityLevel(caster, W技能ID);
  const 攻击加成 = Math.floor(读取单位攻击力(caster) * (cfg.基础攻击力倍率 + cfg.每级攻击力倍率 * level));
  const 暴击加成 = cfg.基础暴击率 + cfg.每级暴击率 * level;

  const id = GetHandleId(caster);
  const old = 积攒状态缓存[id];
  if (old != null && old.单位 === caster) {
    结束积攒(id, old);
  }

  // 重置积攒计数（普攻命中消耗）
  设置欧尔贝克积攒计数(caster, 欧尔贝克单位技能配置.积攒计数初始值);
  临时调整攻击(caster, 攻击加成);
  调整玩家属性(caster, "暴击率", 暴击加成);
  播放欧尔贝克单位音效(caster, cfg.全局音效键);

  const record: 积攒状态记录 = {
    单位: caster,
    周期: 0,
    周期回调ID: 0,
    到期回调ID: 0,
    攻击加成,
    暴击加成,
  };
  积攒状态缓存[id] = record;

  // 周期：播放特效并检查结束条件（与源 JASS 一致）
  record.周期回调ID = addPeriodicCallback(cfg.周期秒 * 1000, () => {
    if (积攒状态缓存[id] !== record) return;
    if (
      获取欧尔贝克积攒计数(caster) <= 0 ||
      单位拥有原生Buff(caster, 积攒Buff类型ID) !== true ||
      !单位存活(caster) ||
      record.周期 >= cfg.周期计数上限
    ) {
      结束积攒(id, record);
      return;
    }
    record.周期 += 1;
    创建点特效({
      模型路径: cfg.周期特效模型,
      X: GetUnitX(caster),
      Y: GetUnitY(caster),
      Z: 0,
      缩放: cfg.周期特效缩放,
      持续秒: cfg.周期特效持续秒,
    });
  });

  // 兜底到期：确保属性加成一定还原
  record.到期回调ID = addDelayedCallback(cfg.持续秒 * 1000, () => {
    结束积攒(id, record);
  });
}

registerSpellEffectListener(on欧尔贝克W);

export {};
