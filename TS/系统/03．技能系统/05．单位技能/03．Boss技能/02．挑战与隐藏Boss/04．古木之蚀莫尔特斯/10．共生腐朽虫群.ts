/** @noSelfInFile */

import { 增加玩家腐败值, 清除玩家腐败值, 取腐败值最高玩家, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 单位有效, 极坐标X, 极坐标Y, 距离XY } from "./16．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 执行Boss单体技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import {
  创建限次周期执行器,
  创建周期行为,
  type 限次周期执行器实例,
  type 周期行为实例,
} from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/22．限次周期执行器";

const { 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};
const jass = require("jass.common") as any;

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const 虫尸拾取调试模块 = "莫尔特斯-虫尸拾取";

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const KillUnit = jass.KillUnit as (unit: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建战斗内拾取物 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.06．战斗内拾取物") as {
  创建战斗内拾取物: (this: void, 参数: any) => any;
};
const { 扩展_设特效速度 } = require("平台扩展API动作") as {
  扩展_设特效速度: (this: void, effect: any, speed: number) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 莫尔特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯") as {
  莫尔特斯BuffID: { 腐败虫尸净化: string };
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};
interface 甲虫追击实例 {
  context: 莫尔特斯运行时上下文;
  甲虫单位: any;
  接触目标: any;
  接触Ticks: number;
  周期?: 周期行为实例;
  技能实例ID?: number;
}

interface 莫尔特斯虫尸变量 {
  context: 莫尔特斯运行时上下文;
  已销毁?: boolean;
  X?: number;
  Y?: number;
  已输出拾取候选日志?: boolean;
}

interface 莫尔特斯甲虫死亡变量 {
  context: 莫尔特斯运行时上下文;
}

interface 莫尔特斯虫尸生成变量 {
  context: 莫尔特斯运行时上下文;
  X: number;
  Y: number;
}

interface 莫尔特斯虫尸冻结变量 {
  特效: any;
  拾取物变量: 莫尔特斯虫尸变量;
}

interface 共生腐朽虫群释放选项 {
  召唤后延迟击杀全部甲虫?: boolean;
}

interface 共生腐朽虫群结算变量 {
  context: 莫尔特斯运行时上下文;
  释放选项?: 共生腐朽虫群释放选项;
}

interface 共生腐朽虫群测试击杀变量 {
  context: 莫尔特斯运行时上下文;
  甲虫单位列表: any[];
  下一个索引: number;
  周期?: 限次周期执行器实例;
}

function 取甲虫目标(this: void, context: 莫尔特斯运行时上下文): any {
  const target = 取腐败值最高玩家(context);
  if (单位有效(target)) return target;
  return 获取Boss技能随机敌对英雄(context.Boss单位);
}

function 莫尔特斯虫尸可拾取单位(this: void, variable?: any): any[] {
  const data = variable as 莫尔特斯虫尸变量 | undefined;
  if (data == null) return [];
  const result = 获取Boss技能敌对英雄列表(data.context.Boss单位);
  const extraUnits = data.context.测试额外虫尸拾取单位;
  const shouldLog = data.已输出拾取候选日志 !== true;
  if (shouldLog) {
    debugLogForce(
      虫尸拾取调试模块,
      "候选列表扫描",
      "尸体坐标=",
      data.X,
      data.Y,
      "正式候选数=",
      result.length,
      "额外候选数=",
      extraUnits == null ? "nil" : extraUnits.length,
      "拾取半径=",
      莫尔特斯数值与表现配置.共生腐朽虫群.虫尸拾取半径,
    );
    if (extraUnits != null) {
      for (let i = 0; i < extraUnits.length; i++) {
        const unit = extraUnits[i];
        const valid = 单位有效(unit);
        if (valid && data.X != null && data.Y != null) {
          const unitX = GetUnitX(unit);
          const unitY = GetUnitY(unit);
          debugLogForce(
            虫尸拾取调试模块,
            "额外候选",
            "索引=",
            i,
            "单位=",
            unit,
            "有效=",
            true,
            "单位坐标=",
            unitX,
            unitY,
            "距离=",
            距离XY(data.X, data.Y, unitX, unitY),
          );
        } else {
          debugLogForce(虫尸拾取调试模块, "额外候选", "索引=", i, "单位=", unit, "有效=", valid);
        }
      }
    }
  }
  if (extraUnits == null) {
    if (shouldLog) {
      debugLogForce(虫尸拾取调试模块, "候选列表完成", "总候选数=", result.length);
      data.已输出拾取候选日志 = true;
    }
    return result;
  }
  for (let i = 0; i < extraUnits.length; i++) {
    const unit = extraUnits[i];
    if (!单位有效(unit)) continue;
    let exists = false;
    for (let j = 0; j < result.length; j++) {
      if (result[j] === unit) {
        exists = true;
        break;
      }
    }
    if (!exists) result.push(unit);
  }
  if (shouldLog) {
    debugLogForce(虫尸拾取调试模块, "候选列表完成", "总候选数=", result.length);
    data.已输出拾取候选日志 = true;
  }
  return result;
}

function 播放莫尔特斯虫尸拾取驱散特效(this: void, picker: any): void {
  if (!单位有效(picker)) return;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  创建点特效({
    模型路径: cfg.虫尸拾取驱散特效路径,
    X: GetUnitX(picker),
    Y: GetUnitY(picker),
    缩放: cfg.虫尸拾取驱散特效缩放,
    持续秒: cfg.虫尸拾取驱散特效持续秒,
  });
}

function 莫尔特斯虫尸拾取(this: void, picker: any, 实例: any, variable?: any): void {
  const data = variable as 莫尔特斯虫尸变量 | undefined;
  if (data == null) return;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  const pickerX = 单位有效(picker) ? GetUnitX(picker) : undefined;
  const pickerY = 单位有效(picker) ? GetUnitY(picker) : undefined;
  debugLogForce(
    虫尸拾取调试模块,
    "拾取命中",
    "拾取单位=",
    picker,
    "尸体坐标=",
    data.X,
    data.Y,
    "拾取单位坐标=",
    pickerX,
    pickerY,
    "距离=",
    data.X != null && data.Y != null && pickerX != null && pickerY != null
      ? 距离XY(data.X, data.Y, pickerX, pickerY)
      : "nil",
  );
  if (实例 != null && 实例.特效 != null && 实例.特效 !== 0) {
    扩展_设特效速度(实例.特效, cfg.虫尸特效正常播放速度);
  }
  播放莫尔特斯虫尸拾取驱散特效(picker);
  const amount = 莫尔特斯数值与表现配置.腐败值.虫尸清除值;
  清除玩家腐败值(data.context, picker, amount);
  registerManualBuff(picker, 莫尔特斯BuffID.腐败虫尸净化, 3, amount, {
    sourceName: "莫尔特斯-腐败虫尸",
  });
}

function 莫尔特斯虫尸销毁(this: void, 实例: any, 原因: any, variable?: any): void {
  const data = variable as 莫尔特斯虫尸变量 | undefined;
  if (data == null) return;
  data.已销毁 = true;
  debugLogForce(虫尸拾取调试模块, "尸体销毁", "实例=", 实例 == null ? "nil" : 实例.ID, "原因=", 原因, "尸体坐标=", data.X, data.Y);
}

function 冻结莫尔特斯虫尸特效(this: void, variable?: any): void {
  const data = variable as 莫尔特斯虫尸冻结变量 | undefined;
  if (data == null || data.拾取物变量.已销毁 === true) return;
  if (data.特效 == null || data.特效 === 0) return;
  扩展_设特效速度(data.特效, 0);
}

function 创建虫尸拾取物(this: void, context: 莫尔特斯运行时上下文, x: number, y: number): void {
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  const 拾取物变量: 莫尔特斯虫尸变量 = { context, 已销毁: false, X: x, Y: y };
  const 实例 = 创建战斗内拾取物({
    清理: context.清理,
    名称: "莫尔特斯-腐败虫尸",
    X: x,
    Y: y,
    模型路径: cfg.虫尸模型路径,
    缩放: 0.55,
    持续秒: cfg.虫尸持续秒,
    拾取半径: cfg.虫尸拾取半径,
    变量: 拾取物变量,
    可拾取单位列表: 莫尔特斯虫尸可拾取单位,
    on拾取: 莫尔特斯虫尸拾取,
    on销毁: 莫尔特斯虫尸销毁,
  });
  if (实例 == null || 实例.特效 == null || 实例.特效 === 0) {
    debugLogForce(虫尸拾取调试模块, "尸体创建失败", "尸体坐标=", x, y);
    return;
  }
  debugLogForce(
    虫尸拾取调试模块,
    "尸体创建成功",
    "实例=",
    实例.ID,
    "尸体坐标=",
    x,
    y,
    "拾取半径=",
    cfg.虫尸拾取半径,
    "测试额外候选数=",
    context.测试额外虫尸拾取单位 == null ? "nil" : context.测试额外虫尸拾取单位.length,
  );
  扩展_设特效速度(实例.特效, cfg.虫尸特效播放速度);
  const 冻结ID = addDelayedCallback(cfg.虫尸特效冻结延迟秒 * 1000, 冻结莫尔特斯虫尸特效, {
    特效: 实例.特效,
    拾取物变量,
  } as 莫尔特斯虫尸冻结变量);
  context.清理.登记延迟回调("莫尔特斯-腐败虫尸动画冻结", 冻结ID);
}

function 延迟创建莫尔特斯虫尸(this: void, variable?: any): void {
  const data = variable as 莫尔特斯虫尸生成变量 | undefined;
  if (data == null) return;
  创建虫尸拾取物(data.context, data.X, data.Y);
}

function 创建甲虫爆炸特效(this: void, context: 莫尔特斯运行时上下文, x: number, y: number): any {
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  return 创建点特效({
    模型路径: cfg.爆炸特效路径,
    X: x,
    Y: y,
    缩放: cfg.爆炸特效缩放,
    持续秒: cfg.爆炸特效持续秒,
  });
}

function 爆炸甲虫(this: void, data: 甲虫追击实例): void {
  const boss = data.context.Boss单位;
  const target = data.接触目标;
  if (!单位有效(boss) || !单位有效(target)) return;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  创建甲虫爆炸特效(data.context, GetUnitX(target), GetUnitY(target));
  执行Boss单体技能伤害({
    来源: boss,
    目标: target,
    伤害公式: { 来源攻击力比例: cfg.爆炸伤害Boss攻击力比例 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_PLANT,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    技能实例ID: data.技能实例ID,
    标签: "莫尔特斯共生腐朽虫群",
  });
  增加玩家腐败值(data.context, target, cfg.爆炸腐败值);
}

function 排队击杀共生腐朽虫群甲虫(this: void, _执行次数: number, variable?: any): boolean {
  const data = variable as 共生腐朽虫群测试击杀变量 | undefined;
  if (data == null || data.甲虫单位列表 == null) return false;
  if (data.下一个索引 >= data.甲虫单位列表.length) {
    return false;
  }
  const beetle = data.甲虫单位列表[data.下一个索引];
  data.下一个索引 += 1;
  if (单位有效(beetle)) {
    创建甲虫爆炸特效(data.context, GetUnitX(beetle), GetUnitY(beetle));
    KillUnit(beetle);
  }
  return data.下一个索引 < data.甲虫单位列表.length;
}

function 延迟击杀共生腐朽虫群甲虫(this: void, variable?: any): void {
  const data = variable as 共生腐朽虫群测试击杀变量 | undefined;
  if (data == null || data.context == null || data.甲虫单位列表 == null || data.甲虫单位列表.length === 0) return;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  data.下一个索引 = 0;
  data.周期 = 创建限次周期执行器({
    名称: "莫尔特斯测试-7-2-排队击杀甲虫",
    间隔毫秒: cfg.测试击杀间隔毫秒,
    最大执行次数: data.甲虫单位列表.length,
    变量: data,
    清理: data.context.清理,
    onTick: 排队击杀共生腐朽虫群甲虫,
  });
}

function 甲虫追击Tick(this: void, data: 甲虫追击实例): boolean {
  const beetle = data.甲虫单位;
  if (!单位有效(beetle) || !单位有效(data.context.Boss单位)) {
    return false;
  }
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  const target = 取甲虫目标(data.context);
  if (!单位有效(target)) return true;
  IssueTargetOrder(beetle, "attack", target);
  const dx = GetUnitX(beetle) - GetUnitX(target);
  const dy = GetUnitY(beetle) - GetUnitY(target);
  if (dx * dx + dy * dy <= cfg.接触半径 * cfg.接触半径) {
    if (data.接触目标 === target) data.接触Ticks = data.接触Ticks + 1;
    else {
      data.接触目标 = target;
      data.接触Ticks = 1;
    }
    if (data.接触Ticks >= cfg.接触爆炸秒) {
      爆炸甲虫(data);
      KillUnit(beetle);
      return false;
    }
  } else {
    data.接触目标 = null;
    data.接触Ticks = 0;
  }
  return true;
}

function 莫尔特斯甲虫追击周期(this: void, _执行次数: number, variable?: any): boolean {
  const data = variable as 甲虫追击实例 | undefined;
  if (data == null) return false;
  return 甲虫追击Tick(data);
}

function 莫尔特斯甲虫死亡(this: void, unit: any, _击杀者: any, variable?: any): void {
  const data = variable as 莫尔特斯甲虫死亡变量 | undefined;
  if (data == null) return;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  RemoveUnit(unit);
  debugLogForce(虫尸拾取调试模块, "原始甲虫单位已移除", "单位=", unit, "尸体坐标=", x, y);
  const delayedId = addDelayedCallback(cfg.虫尸死亡后延迟秒 * 1000, 延迟创建莫尔特斯虫尸, {
    context: data.context,
    X: x,
    Y: y,
  } as 莫尔特斯虫尸生成变量);
  data.context.清理.登记延迟回调("莫尔特斯-腐败虫尸生成", delayedId);
}

function 创建腐化甲虫(this: void, context: 莫尔特斯运行时上下文, angle: number, 技能实例ID?: number): any {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  const x = 极坐标X(GetUnitX(boss), angle, 360);
  const y = 极坐标Y(GetUnitY(boss), angle, 360);
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "莫尔特斯-腐化甲虫",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.甲虫单位类型,
    模型路径: cfg.甲虫模型路径,
    X: x,
    Y: y,
    朝向: angle,
    最大生命: cfg.甲虫生命值,
    缩放: cfg.甲虫缩放,
    变量: { context } as 莫尔特斯甲虫死亡变量,
    on死亡: 莫尔特斯甲虫死亡,
  });
  if (instance == null || !单位有效(instance.单位)) return undefined;
  临时调整攻击(instance.单位, cfg.甲虫攻击力);
  const data: 甲虫追击实例 = {
    context,
    甲虫单位: instance.单位,
    接触目标: null,
    接触Ticks: 0,
    技能实例ID,
  };
  data.周期 = 创建周期行为({
    名称: "莫尔特斯-甲虫追击",
    间隔毫秒: cfg.追击刷新间隔毫秒,
    变量: data,
    清理: context.清理,
    onTick: 莫尔特斯甲虫追击周期,
  });
  return instance.单位;
}

function 结算莫尔特斯共生腐朽虫群(this: void, variable?: any): void {
  const data = variable as 共生腐朽虫群结算变量 | undefined;
  if (data == null || !单位有效(data.context.Boss单位)) return;
  const context = data.context;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  播放Boss坐标音效(莫尔特斯音效配置.共生腐朽虫群.甲虫入场, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 莫尔特斯音效配置.默认裁断距离);
  const 技能实例ID = 创建独立技能伤害实例({
    来源类型: "Boss技能",
    标签: "莫尔特斯共生腐朽虫群",
    持续时间秒: cfg.接触爆炸秒 + 12,
  });
  const 甲虫单位列表: any[] = [];
  for (let i = 0; i < cfg.甲虫数量; i++) {
    const beetle = 创建腐化甲虫(context, i * 90, 技能实例ID);
    if (单位有效(beetle)) 甲虫单位列表.push(beetle);
  }
  if (data.释放选项 != null && data.释放选项.召唤后延迟击杀全部甲虫 === true && 甲虫单位列表.length > 0) {
    const delayedId = addDelayedCallback(2000, 延迟击杀共生腐朽虫群甲虫, {
      context,
      甲虫单位列表,
      下一个索引: 0,
      周期ID: 0,
    });
    context.清理.登记延迟回调("莫尔特斯测试-7-2-击杀甲虫", delayedId);
  }
}

export function 释放莫尔特斯共生腐朽虫群(this: void, context: 莫尔特斯运行时上下文, 释放选项?: 共生腐朽虫群释放选项): boolean {
  if (!单位有效(context.Boss单位)) return false;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  启动基础施法时间线({
    名称: "莫尔特斯-共生腐朽虫群",
    施法者: context.Boss单位,
    硬直秒: cfg.动作播放秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.动作播放秒,
      颜色ID: 3,
      标题文本: "共生腐朽虫群",
      提示文本: "腐化甲虫将在读条结束后涌出",
    },
    清理: context.清理,
    on生效: function 莫尔特斯共生腐朽虫群时间线生效(this: void): void {
      结算莫尔特斯共生腐朽虫群({ context, 释放选项 } as 共生腐朽虫群结算变量);
    },
  });
  return true;
}

export function 测试释放莫尔特斯共生腐朽虫群并延迟击杀(this: void, context: 莫尔特斯运行时上下文): boolean {
  return 释放莫尔特斯共生腐朽虫群(context, { 召唤后延迟击杀全部甲虫: true });
}
