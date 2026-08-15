/** @noSelfInFile */

import { 坂井悠二技能配置 } from "./00．配置";
import { 坂井悠二BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/05．坂井悠二";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetHeroLevel = jass.GetHeroLevel as (this: void, unit: any) => number;
const GetHeroStr = jass.GetHeroStr as (this: void, hero: any, includeBonuses: boolean) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => boolean;
const CreateUnit = jass.CreateUnit as (this: void, player: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, speed: number) => void;
const GetUnitFlyHeight = (jass.GetUnitFlyHeight ?? ((_u: any): number => 0)) as (this: void, unit: any) => number;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (this: void, unit: any, r: number, g: number, b: number, a: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, modelName: string, unit: any, attachPoint: string) => any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;
const GetRandomReal = jass.GetRandomReal as (this: void, low: number, high: number) => number;
const ForGroup = jass.ForGroup as (this: void, group: any, callback: (this: void) => void) => void;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (this: void, group: any, x: number, y: number, radius: number, filter: any) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const DestroyGroup = jass.DestroyGroup as (this: void, group: any) => void;
const FilterBoolExpr = (jass.Filter ?? ((_f: any) => true)) as (this: void, func: (this: void) => boolean) => any;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;

const 配置 = 坂井悠二技能配置.D;
const 英雄单位类型ID = 坂井悠二技能配置.单位类型ID;
const D技能ID字符串 = 配置.技能ID;
const E技能类型ID = 坂井悠二技能配置.E.技能类型ID;

interface D上下文 {
  施法者: any;
  技能实例ID?: number;
  已启动: boolean;
  鼓舞回调ID: number;
  马甲更新回调ID: number;
  清理回调ID: number;
  施法前英雄飞行高度: number;
  马甲一: any;
  马甲二: any[];
  已鼓舞友军: Record<number, boolean>;
}

const 上下文表: Record<number, D上下文 | undefined> = {};
let 死亡监听已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 获取D上下文(this: void, unit: any): D上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  return 上下文表[id];
}

function 获取或创建D上下文(this: void, unit: any): D上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  const current = 上下文表[id];
  if (current != null) return current;
  const created: D上下文 = {
    施法者: unit,
    已启动: false,
    鼓舞回调ID: 0,
    马甲更新回调ID: 0,
    清理回调ID: 0,
    施法前英雄飞行高度: 0,
    马甲一: null,
    马甲二: [],
    已鼓舞友军: {},
  };
  上下文表[id] = created;
  return created;
}

function 清理D上下文(this: void, context: D上下文): void {
  const caster = context.施法者;

  if (context.鼓舞回调ID !== 0) {
    removePeriodicCallback(context.鼓舞回调ID);
    context.鼓舞回调ID = 0;
  }
  if (context.马甲更新回调ID !== 0) {
    removePeriodicCallback(context.马甲更新回调ID);
    context.马甲更新回调ID = 0;
  }
  if (context.清理回调ID !== 0) {
    removeDelayedCallback(context.清理回调ID);
    context.清理回调ID = 0;
  }

  // 恢复英雄飞行高度
  if (caster != null && caster !== 0 && 单位存活(caster)) {
    SetUnitFlyHeight(caster, context.施法前英雄飞行高度, 0);
    // 恢复 E 冷却
    YDWESetUnitAbilityStateSafe(caster, E技能类型ID, 1, 配置.结束恢复E冷却秒);
    // 清除 D 期间状态
    移除单位指定Buff(caster, 坂井悠二BuffID.D暗属性加成);
    移除单位指定Buff(caster, 坂井悠二BuffID.D期间状态);
  }

  // 清除鼓舞 Buff（按记录）
  for (const [hidStr, 已鼓舞] of Object.entries(context.已鼓舞友军)) {
    if (!已鼓舞) continue;
    const hid = Number(hidStr);
    // 通过句柄反查单位在当前实现中不便，依赖 Buff 超时自动移除（10秒）
    void hid;
  }

  // 删除马甲
  if (context.马甲一 != null && context.马甲一 !== 0) {
    RemoveUnit(context.马甲一);
    context.马甲一 = null;
  }
  for (let i = 0; i < context.马甲二.length; i++) {
    const 马甲 = context.马甲二[i];
    if (马甲 != null && 马甲 !== 0) RemoveUnit(马甲);
  }
  context.马甲二 = [];
  context.已鼓舞友军 = {};

  context.已启动 = false;
  const id = 取单位句柄ID(caster);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
}

function 执行鼓舞(this: void, context?: any): void {
  const ctx = context as D上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    清理D上下文(ctx);
    return;
  }

  const 范围 = 配置.鼓舞.范围;
  const owner = GetOwningPlayer(caster);
  const group = CreateGroup();
  GroupEnumUnitsInRange(group, GetUnitX(caster), GetUnitY(caster), 范围, null);

  ForGroup(group, function 遍历友军(this: void): void {
    const u = GetEnumUnit();
    if (u == null || u === 0) return;
    if (u === caster) return;
    if (!IsUnitAlly(u, owner)) return;
    if (IsUnitType(u, UNIT_TYPE_DEAD) || IsUnitType(u, UNIT_TYPE_STRUCTURE)) return;
    if (!单位存活(u)) return;

    // 鼓舞 Buff
    registerManualBuff(u, 坂井悠二BuffID.D鼓舞, 配置.持续秒, 配置.鼓舞.攻击力基础倍率, {
      来源: caster,
      来源类型: "技能",
      标签: "坂井悠二-D-鼓舞",
    });
    const hid = 取单位句柄ID(u);
    if (hid !== 0) ctx.已鼓舞友军[hid] = true;
  });
  DestroyGroup(group);
}

function 更新马甲二位置(this: void, context?: any): void {
  const ctx = context as D上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) return;

  const 中心X = GetUnitX(caster);
  const 中心Y = GetUnitY(caster);
  const 施法者面向 = GetUnitFacing(caster);

  for (let i = 0; i < ctx.马甲二.length; i++) {
    const 马甲 = ctx.马甲二[i];
    if (马甲 == null || 马甲 === 0) continue;
    // 简单的环绕：固定偏移 + 施法者朝向
    const 初始 = 配置.马甲二.初始[i];
    const 距离 = (初始 as any).距离 ?? 600;
    const 角度 = ((初始 as any).角度 ?? 0) + 施法者面向;
    const 弧度 = 角度 * (3.14159265358979 / 180);
    const x = 中心X + 距离 * Math.cos(弧度);
    const y = 中心Y + 距离 * Math.sin(弧度);
    SetUnitPosition(马甲, x, y);
    SetUnitFacing(马甲, 角度 + 180);
  }
}

function 创建马甲(this: void, context: D上下文): void {
  const caster = context.施法者;
  const owner = GetOwningPlayer(caster);
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const 施法者面向 = GetUnitFacing(caster);

  // 第一层马甲（待查字段占位，跳过当无 ID 时）
  if (配置.马甲一.单位类型ID !== "待查") {
    const 四CC = stringToFourCC(配置.马甲一.单位类型ID);
    const 马甲 = CreateUnit(owner, 四CC, x, y, 施法者面向);
    context.马甲一 = 马甲;
    if (马甲 != null && 马甲 !== 0) {
      SetUnitAnimationByIndex(马甲, 配置.马甲一.动画编号);
      SetUnitTimeScale(马甲, 配置.马甲一.时间缩放);
      SetUnitScale(马甲, 配置.马甲一.缩放, 配置.马甲一.缩放, 配置.马甲一.缩放);
      SetUnitVertexColor(马甲, 配置.马甲一.颜色.红, 配置.马甲一.颜色.绿, 配置.马甲一.颜色.蓝, 配置.马甲一.颜色.透明度);
      SetUnitFlyHeight(马甲, 配置.马甲一.飞行高度增量 + GetUnitFlyHeight(caster), 0);
      AddSpecialEffectTarget(配置.马甲一.特效.模型路径, 马甲, 配置.马甲一.特效.挂点);
    }
  }

  // 第二层马甲 ×5
  for (let i = 0; i < 配置.马甲二.数量; i++) {
    if (配置.马甲二.单位类型ID === "待查") {
      context.马甲二.push(null);
      continue;
    }
    const 四CC = stringToFourCC(配置.马甲二.单位类型ID);
    const 马甲 = CreateUnit(owner, 四CC, x, y, 施法者面向);
    context.马甲二.push(马甲);
    if (马甲 != null && 马甲 !== 0) {
      SetUnitAnimationByIndex(马甲, 配置.马甲二.动画编号);
      SetUnitTimeScale(马甲, 配置.马甲二.时间缩放);
      SetUnitScale(马甲, 配置.马甲二.缩放, 配置.马甲二.缩放, 配置.马甲二.缩放);
      SetUnitVertexColor(马甲, 配置.马甲二.颜色.红, 配置.马甲二.颜色.绿, 配置.马甲二.颜色.蓝, 配置.马甲二.颜色.透明度);
      SetUnitFlyHeight(马甲, 配置.马甲二.飞行高度增量 + GetUnitFlyHeight(caster), 0);
      for (let j = 0; j < 配置.马甲二.特效.length; j++) {
        const 特效配置 = 配置.马甲二.特效[j];
        AddSpecialEffectTarget(特效配置.模型路径, 马甲, 特效配置.挂点);
      }
    }
  }
}

function 释放D技能(this: void, context: D上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动) return;

  // 前置条件
  const 等级 = GetHeroLevel(caster);
  if (等级 < 配置.条件.最低英雄等级) return;
  const 力量 = GetHeroStr(caster, true);
  if (力量 <= 配置.条件.最低力量) return;
  // 神门阶段==4 的判断：由调用方或独立状态标记，本实现简化为仅检查等级+力量

  context.已启动 = true;
  context.技能实例ID = 技能实例ID;
  context.施法前英雄飞行高度 = GetUnitFlyHeight(caster);

  // 英雄飞行高度 +500
  SetUnitFlyHeight(caster, context.施法前英雄飞行高度 + 配置.英雄飞行高度增量, 0);

  // D 期间状态 Buff（标记 D 激活）
  registerManualBuff(caster, 坂井悠二BuffID.D期间状态, 配置.持续秒, 1, {
    来源: caster,
    来源类型: "技能",
    标签: "坂井悠二-D-状态",
  });

  // 暗属性伤害 +30%
  registerManualBuff(caster, 坂井悠二BuffID.D暗属性加成, 配置.持续秒, 配置.期间.暗属性伤害加成, {
    来源: caster,
    来源类型: "技能",
    标签: "坂井悠二-D-暗属性",
  });

  // E 冷却改为 2.5秒
  YDWESetUnitAbilityStateSafe(caster, E技能类型ID, 1, 配置.期间.E技能冷却秒);

  // 创建马甲
  创建马甲(context);

  // 鼓舞周期（每 1秒）
  context.鼓舞回调ID = addPeriodicCallback(
    配置.鼓舞.更新周期秒 * 1000,
    执行鼓舞 as unknown as (this: void, variable?: any) => void,
    context,
  );
  // 立即执行一次
  执行鼓舞(context);

  // 马甲位置更新（0.05秒）
  context.马甲更新回调ID = addPeriodicCallback(
    配置.马甲二.更新周期秒 * 1000,
    更新马甲二位置 as unknown as (this: void, variable?: any) => void,
    context,
  );

  // 10秒后清理
  context.清理回调ID = addDelayedCallback(
    配置.持续秒 * 1000,
    清理D到期 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

function 清理D到期(this: void, context?: any): void {
  const ctx = context as D上下文 | undefined;
  if (ctx != null) 清理D上下文(ctx);
}

function D可释放(this: void, context: D上下文): boolean {
  return !context.已启动 && context.鼓舞回调ID === 0;
}

function D单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 获取D上下文(dyingUnit);
  if (context != null) 清理D上下文(context);
}

export function 注册坂井悠二D(this: void): void {
  注册单位技能壳监听({
    名称: "坂井悠二-祭礼之蛇（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: D技能ID字符串,
    获取或创建上下文: 获取或创建D上下文,
    可释放: D可释放,
    释放技能: 释放D技能,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 配置.持续秒 + 1,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(D单位死亡);
  }
}

注册坂井悠二D();

export const 坂井悠二D技能状态 = {
  已完成设计: true,
  已完成实现: false, // 马甲类型/绑定技能/移速最大化 字段待回填
  伤害形态: "无直接伤害，提供 10秒强化状态 + 友军鼓舞",
  期间效果: "暗属性+30%、E冷却固定2.5秒、飞行高度+500、每1秒鼓舞800范围友军",
  前置条件: "等级≥40、力量>300（神门阶段==4 由外部状态判定）",
} as const;
