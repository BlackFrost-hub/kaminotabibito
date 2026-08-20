/** @noSelfInFile */

import { 坂井悠二技能配置 } from "./00．配置";
import { 坂井悠二BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/05．坂井悠二";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活, 取单位ID, 极坐标X, 极坐标Y } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 向下取整整数 } from "../../../00．技能模板+函数/02．通用函数/24．整数与时间换算";
import { 确保单位可设置飞行高度 } from "../../../00．技能模板+函数/01．技能函数/03．跳跃·击飞/01．跳跃系统/00．共享";
import { 技能强制调试输出 } from "../../../00．技能模板+函数/02．通用函数/04．调试输出";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
};
const { 临时调整攻击, 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
  调整玩家属性: (this: void, unit: any, name: string, delta: number) => void;
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
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, speed: number) => void;
const GetUnitFlyHeight = (jass.GetUnitFlyHeight ?? ((_u: any): number => 0)) as (this: void, unit: any) => number;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const { SetUnitVertexColorBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitVertexColorBJ: (this: void, unit: any, red: number, green: number, blue: number, transparency: number) => void;
};
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, modelName: string, unit: any, attachPoint: string) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const DzSetUnitModel = japi.DzSetUnitModel as (this: void, unit: any, modelPath: string) => void;
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
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const GetUnitMoveSpeed = jass.GetUnitMoveSpeed as (this: void, unit: any) => number;
const SetUnitMoveSpeed = jass.SetUnitMoveSpeed as (this: void, unit: any, speed: number) => void;
const ConvertUnitState = jass.ConvertUnitState as (this: void, stateId: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const UNIT_STATE_ATTACK1_BASE = ConvertUnitState(0x12);

const 配置 = 坂井悠二技能配置.D;
const 英雄单位类型ID = 坂井悠二技能配置.单位类型ID;
const D技能ID字符串 = 配置.技能ID;
const E技能类型ID = 坂井悠二技能配置.E.技能类型ID;
const D日志模块 = "坂井悠二D排查";

interface D上下文 {
  施法者: any;
  技能实例ID?: number;
  已启动: boolean;
  鼓舞回调ID: number;
  马甲更新回调ID: number;
  特效附加回调ID: number;
  清理回调ID: number;
  施法前英雄飞行高度: number;
  马甲一: any;
  马甲一特效: any;
  马甲二参数: {
    马甲: any;
    距离: number;
    角度: number;
    角度符号: number;
    面向角度: number;
    蛇身特效: any;
    光束特效: any;
  }[];
  已鼓舞友军: Record<number, { 单位: any; 攻击加成: number }>;
  暗属性伤害已应用: boolean;
  移速最大化技能由D添加: boolean;
  主周期计数: number;
}

const 上下文表: Record<number, D上下文 | undefined> = {};
let 死亡监听已注册 = false;

function 获取D上下文(this: void, unit: any): D上下文 | undefined {
  const id = 取单位ID(unit);
  if (id === 0) return undefined;
  return 上下文表[id];
}

function 获取或创建D上下文(this: void, unit: any): D上下文 | undefined {
  const id = 取单位ID(unit);
  if (id === 0) return undefined;
  const current = 上下文表[id];
  if (current != null) return current;
  const created: D上下文 = {
    施法者: unit,
    已启动: false,
    鼓舞回调ID: 0,
    马甲更新回调ID: 0,
    特效附加回调ID: 0,
    清理回调ID: 0,
    施法前英雄飞行高度: 0,
    马甲一: null,
    马甲一特效: null,
    马甲二参数: [],
    已鼓舞友军: {},
    暗属性伤害已应用: false,
    移速最大化技能由D添加: false,
    主周期计数: 0,
  };
  上下文表[id] = created;
  return created;
}

function 清除单个鼓舞(this: void, context: D上下文, hid: number): void {
  const record = context.已鼓舞友军[hid];
  if (record == null) return;
  delete context.已鼓舞友军[hid];
  const unit = record.单位;
  if (unit == null || unit === 0) return;
  临时调整攻击(unit, -record.攻击加成);
  SetUnitMoveSpeed(unit, GetUnitMoveSpeed(unit) - 配置.鼓舞.移动速度加值);
  移除单位指定Buff(unit, 坂井悠二BuffID.D鼓舞);
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
  if (context.特效附加回调ID !== 0) {
    removeDelayedCallback(context.特效附加回调ID);
    context.特效附加回调ID = 0;
  }
  if (context.清理回调ID !== 0) {
    removeDelayedCallback(context.清理回调ID);
    context.清理回调ID = 0;
  }

  if (caster != null && caster !== 0) {
    if (单位存活(caster)) {
      SetUnitFlyHeight(caster, context.施法前英雄飞行高度, 0);
      YDWESetUnitAbilityStateSafe(caster, E技能类型ID, 1, 配置.结束恢复E冷却秒);
    }
    if (context.暗属性伤害已应用) {
      调整玩家属性(caster, "暗属性伤害", -配置.期间.暗属性伤害);
      context.暗属性伤害已应用 = false;
    }
    if (context.移速最大化技能由D添加) {
      UnitRemoveAbility(caster, stringToFourCC(配置.期间.移速最大化技能ID));
      context.移速最大化技能由D添加 = false;
    }
    移除单位指定Buff(caster, 坂井悠二BuffID.D暗属性加成);
    移除单位指定Buff(caster, 坂井悠二BuffID.D期间状态);
  }

  for (const hidStr in context.已鼓舞友军) {
    清除单个鼓舞(context, Number(hidStr));
  }

  // 源 JASS 先逐个销毁附加特效，再删除承载马甲；只 RemoveUnit 会让旧蛇身残留到下一次施放。
  if (context.马甲一特效 != null && context.马甲一特效 !== 0) {
    DestroyEffect(context.马甲一特效);
    context.马甲一特效 = null;
  }
  if (context.马甲一 != null && context.马甲一 !== 0) {
    RemoveUnit(context.马甲一);
    context.马甲一 = null;
  }
  for (let i = 0; i < context.马甲二参数.length; i++) {
    const 参数 = context.马甲二参数[i];
    if (参数.蛇身特效 != null && 参数.蛇身特效 !== 0) DestroyEffect(参数.蛇身特效);
    if (参数.光束特效 != null && 参数.光束特效 !== 0) DestroyEffect(参数.光束特效);
    const 马甲 = 参数.马甲;
    if (马甲 != null && 马甲 !== 0) RemoveUnit(马甲);
  }
  context.马甲二参数 = [];
  context.已鼓舞友军 = {};

  技能强制调试输出(D日志模块, "清理D上下文完成");

  context.已启动 = false;
  const id = 取单位ID(caster);
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

  for (const hidStr in ctx.已鼓舞友军) {
    const hid = Number(hidStr);
    const record = ctx.已鼓舞友军[hid];
    if (record != null && !单位存活(record.单位)) 清除单个鼓舞(ctx, hid);
  }

  const group = CreateGroup();
  GroupEnumUnitsInRange(group, GetUnitX(caster), GetUnitY(caster), 范围, null);

  ForGroup(group, function 遍历友军(this: void): void {
    const u = GetEnumUnit();
    if (u == null || u === 0) return;
    if (u === caster) return;
    if (!IsUnitAlly(u, owner)) return;
    if (IsUnitType(u, UNIT_TYPE_DEAD) || IsUnitType(u, UNIT_TYPE_STRUCTURE)) return;
    if (!单位存活(u)) return;
    const hid = 取单位ID(u);
    if (hid === 0 || ctx.已鼓舞友军[hid] != null) return;

    const 攻击加成 = 向下取整整数((Number(GetUnitStateJapi(u, UNIT_STATE_ATTACK1_BASE)) || 0) * 配置.鼓舞.攻击力基础倍率);
    临时调整攻击(u, 攻击加成);
    SetUnitMoveSpeed(u, GetUnitMoveSpeed(u) + 配置.鼓舞.移动速度加值);
    registerManualBuff(u, 坂井悠二BuffID.D鼓舞, 配置.持续秒, 配置.鼓舞.攻击力基础倍率, {
      来源: caster,
      来源类型: "技能",
      标签: "坂井悠二-D-鼓舞",
    });
    ctx.已鼓舞友军[hid] = { 单位: u, 攻击加成 };
  });
  DestroyGroup(group);
}

// 主更新周期（0.05s，源 Func024T/Func025Func013T）：
// 保持英雄飞行高度 500+原高度；马甲一跟随英雄；马甲二按创建时随机参数跟随马甲一
function 更新D马甲群(this: void, context?: any): void {
  const ctx = context as D上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    技能强制调试输出(D日志模块, "主周期终止：施法者无效/死亡");
    清理D上下文(ctx);
    return;
  }

  // 源每 tick 重置英雄高度，防止高度回落
  SetUnitFlyHeight(caster, ctx.施法前英雄飞行高度 + 配置.英雄飞行高度增量, 0);

  // 马甲一跟随英雄（位置+面向）
  const 马甲一 = ctx.马甲一;
  if (马甲一 != null && 马甲一 !== 0) {
    SetUnitX(马甲一, GetUnitX(caster));
    SetUnitY(马甲一, GetUnitY(caster));
    SetUnitFacing(马甲一, GetUnitFacing(caster));
  }

  // 马甲二跟随马甲一：位置 = 马甲一 + 距离×投影(马甲一面向+180±角度)，面向 = 马甲一面向+面向角度
  if (马甲一 != null && 马甲一 !== 0) {
    const 一X = GetUnitX(马甲一);
    const 一Y = GetUnitY(马甲一);
    const 一面向 = GetUnitFacing(马甲一);
    for (let i = 0; i < ctx.马甲二参数.length; i++) {
      const 参 = ctx.马甲二参数[i];
      if (参.马甲 == null || 参.马甲 === 0) continue;
      const 角度3 = 一面向 + 180 + 参.角度符号 * 参.角度;
      SetUnitX(参.马甲, 极坐标X(一X, 角度3, 参.距离));
      SetUnitY(参.马甲, 极坐标Y(一Y, 角度3, 参.距离));
      SetUnitFacing(参.马甲, 一面向 + 参.面向角度);
    }
  }

  ctx.主周期计数 = ctx.主周期计数 + 1;
  // 每 20 tick（约 1 秒）输出一条，避免刷屏；含马甲存活诊断（短命马甲死亡会连带销毁绑定特效）
  if (ctx.主周期计数 % 20 === 1) {
    let 马甲二存活数 = 0;
    for (let i = 0; i < ctx.马甲二参数.length; i++) {
      if (ctx.马甲二参数[i].马甲 != null && ctx.马甲二参数[i].马甲 !== 0 && 单位存活(ctx.马甲二参数[i].马甲)) 马甲二存活数++;
    }
    技能强制调试输出(D日志模块, "主周期", "计数", ctx.主周期计数, "英雄高度", GetUnitFlyHeight(caster), "马甲一存活", ctx.马甲一 != null && ctx.马甲一 !== 0 && 单位存活(ctx.马甲一), "马甲二存活", 马甲二存活数);
  }
}

function 延迟附加D马甲特效(this: void, context?: any): void {
  const ctx = context as D上下文 | undefined;
  if (ctx == null) return;
  ctx.特效附加回调ID = 0;
  if (!ctx.已启动 || ctx.施法者 == null || ctx.施法者 === 0 || !单位存活(ctx.施法者)) return;

  const 马甲一 = ctx.马甲一;
  if (马甲一 != null && 马甲一 !== 0 && 单位存活(马甲一)) {
    ctx.马甲一特效 = AddSpecialEffectTarget(配置.马甲一.特效.模型路径, 马甲一, 配置.马甲一.特效.挂点);
    技能强制调试输出(D日志模块, "延迟附加马甲一特效", "模型", 配置.马甲一.特效.模型路径, "特效句柄", ctx.马甲一特效);
  }

  let 成功马甲数 = 0;
  for (let i = 0; i < ctx.马甲二参数.length; i++) {
    const 马甲 = ctx.马甲二参数[i].马甲;
    if (马甲 == null || 马甲 === 0 || !单位存活(马甲)) continue;
    for (let j = 0; j < 配置.马甲二.特效.length; j++) {
      const 特效配置 = 配置.马甲二.特效[j];
      const 特效句柄 = AddSpecialEffectTarget(特效配置.模型路径, 马甲, 特效配置.挂点);
      if (j === 0) ctx.马甲二参数[i].蛇身特效 = 特效句柄;
      else if (j === 1) ctx.马甲二参数[i].光束特效 = 特效句柄;
      if (i === 0) 技能强制调试输出(D日志模块, "延迟附加马甲二特效", "模型", 特效配置.模型路径, "特效句柄", 特效句柄);
    }
    成功马甲数++;
  }
  技能强制调试输出(D日志模块, "D马甲特效延迟附加完成", "等待秒", 配置.马甲模型刷新等待秒, "蛇身马甲数", 成功马甲数);
}

function 创建马甲(this: void, context: D上下文): void {
  const caster = context.施法者;
  const owner = GetOwningPlayer(caster);
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const 施法者面向 = GetUnitFacing(caster);
  const 施法前高度 = context.施法前英雄飞行高度;

  // 第一层马甲（头部承载，跟随英雄）
  const 一四CC = stringToFourCC(配置.马甲一.单位类型ID);
  const 马甲一 = CreateUnit(owner, 一四CC, x, y, 施法者面向);
  context.马甲一 = 马甲一;
  技能强制调试输出(D日志模块, "创建马甲一", "四CC", 一四CC, "ID字符串", 配置.马甲一.单位类型ID, "结果", 马甲一);
  if (马甲一 != null && 马甲一 !== 0) {
    DzSetUnitModel(马甲一, 配置.马甲载体模型路径);
    // HP 满值保障：最大生命+当前生命拉满，防止中途死亡（绑定特效会随单位销毁）
    SetUnitState(马甲一, UNIT_STATE_MAX_LIFE, 配置.马甲一.HP保障值);
    SetUnitState(马甲一, UNIT_STATE_LIFE, 配置.马甲一.HP保障值);
    SetUnitAnimationByIndex(马甲一, 配置.马甲一.动画编号);
    SetUnitTimeScale(马甲一, 配置.马甲一.时间缩放);
    SetUnitScale(马甲一, 配置.马甲一.缩放, 配置.马甲一.缩放, 配置.马甲一.缩放);
    SetUnitVertexColorBJ(马甲一, 配置.马甲一.颜色.红, 配置.马甲一.颜色.绿, 配置.马甲一.颜色.蓝, 配置.马甲一.颜色.透明度);
    SetUnitFlyHeight(马甲一, 配置.马甲一.飞行高度增量 + 施法前高度, 0);
    // 源：UnitAddAbility(马甲, "技能")，真身 S00B；"技能2"当前地图无注册不接入
    UnitAddAbility(马甲一, stringToFourCC(配置.马甲一.绑定技能1));
  }

  // 第二层马甲 ×5（蛇身，跟随马甲一；参数创建时随机一次性定死，源 ydul_i=1..5）
  const 二四CC = stringToFourCC(配置.马甲二.单位类型ID);
  for (let i = 0; i < 配置.马甲二.数量; i++) {
    const 初始: any = 配置.马甲二.初始[i];
    // 滚参数：第1个固定（距离600/角度0/面向180）；其余随机
    let 距离: number;
    let 角度: number;
    let 面向角度: number;
    if (初始.距离 != null) {
      距离 = 初始.距离;
      角度 = 初始.角度 ?? 0;
      面向角度 = 初始.面向角度 ?? 0;
    } else {
      距离 = 400 + GetRandomReal(200, 600); // 源 400 + Random(200,600)
      角度 = GetRandomReal(1, 60);
      面向角度 = 初始.面向角度 != null ? 初始.面向角度 : GetRandomReal(-90, 90);
    }
    const 角度符号 = 角度 < 31 ? 1 : -1; // 源：角度<31 取 +，否则 -
    // 初始位置按马甲一当前状态投影
    const 角度3 = 施法者面向 + 180 + 角度符号 * 角度;
    const 初始X = 极坐标X(x, 角度3, 距离);
    const 初始Y = 极坐标Y(y, 角度3, 距离);

    const 马甲 = CreateUnit(owner, 二四CC, 初始X, 初始Y, 施法者面向 + 面向角度);
    context.马甲二参数.push({ 马甲, 距离, 角度, 角度符号, 面向角度, 蛇身特效: null, 光束特效: null });
    技能强制调试输出(D日志模块, "创建马甲二", "序号", i + 1, "结果", 马甲, "距离", 距离, "角度", 角度, "符号", 角度符号);
    if (马甲 != null && 马甲 !== 0) {
      DzSetUnitModel(马甲, 配置.马甲载体模型路径);
      SetUnitState(马甲, UNIT_STATE_MAX_LIFE, 配置.马甲一.HP保障值);
      SetUnitState(马甲, UNIT_STATE_LIFE, 配置.马甲一.HP保障值);
      SetUnitAnimationByIndex(马甲, 配置.马甲二.动画编号);
      SetUnitTimeScale(马甲, 配置.马甲二.时间缩放);
      SetUnitScale(马甲, 配置.马甲二.缩放, 配置.马甲二.缩放, 配置.马甲二.缩放);
      SetUnitVertexColorBJ(马甲, 配置.马甲二.颜色.红, 配置.马甲二.颜色.绿, 配置.马甲二.颜色.蓝, 配置.马甲二.颜色.透明度);
      SetUnitFlyHeight(马甲, 配置.马甲二.飞行高度增量 + 施法前高度, 0);
    }
  }

  context.特效附加回调ID = addDelayedCallback(
    配置.马甲模型刷新等待秒 * 1000,
    延迟附加D马甲特效 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

function 释放D技能(this: void, context: D上下文, caster: any, 技能实例ID?: number): void {
  技能强制调试输出(D日志模块, "释放D入口", "施法者", caster, "实例ID", 技能实例ID, "已启动", context.已启动);
  if (context.已启动) return;

  // 前置条件（源：力量>300 且 等级>40）
  const 等级 = GetHeroLevel(caster);
  const 力量 = GetHeroStr(caster, true);
  if (等级 < 配置.条件.最低英雄等级 || 力量 <= 配置.条件.最低力量) {
    技能强制调试输出(D日志模块, "条件不满足被拒", "等级", 等级, "需要", 配置.条件.最低英雄等级, "力量", 力量, "需要大于", 配置.条件.最低力量);
    return;
  }

  context.已启动 = true;
  context.技能实例ID = 技能实例ID;
  context.施法前英雄飞行高度 = GetUnitFlyHeight(caster);

  // 启用飞行高度能力（源 YDWEFlyEnable；项目底层标准做法：加/移除 Arav，与跳跃/线性升降系统同款）：
  // 地面单位不做此步，SetUnitFlyHeight 数值生效但视觉不升高——此前高度不升的根源
  确保单位可设置飞行高度(caster);
  // 英雄飞行高度 +500
  SetUnitFlyHeight(caster, context.施法前英雄飞行高度 + 配置.英雄飞行高度增量, 0);
  技能强制调试输出(D日志模块, "飞行启用", "施法前高度", context.施法前英雄飞行高度, "目标高度", context.施法前英雄飞行高度 + 配置.英雄飞行高度增量, "当前高度", GetUnitFlyHeight(caster));

  // D 期间状态 Buff（标记 D 激活）
  registerManualBuff(caster, 坂井悠二BuffID.D期间状态, 配置.持续秒, 1, {
    来源: caster,
    来源类型: "技能",
    标签: "坂井悠二-D-状态",
  });

  // 属性真源：装备属性表中的“暗属性伤害”，不是旧 JASS 私有键“暗属性伤害加成”。
  调整玩家属性(caster, "暗属性伤害", 配置.期间.暗属性伤害);
  context.暗属性伤害已应用 = true;
  registerManualBuff(caster, 坂井悠二BuffID.D暗属性加成, 配置.持续秒, 配置.期间.暗属性伤害, {
    来源: caster,
    来源类型: "技能",
    标签: "坂井悠二-D-暗属性",
  });

  // 源 JASS：开启 D 立即刷新一次 E；D 期间每次 E 施放后再固定为 2.5 秒。
  YDWESetUnitAbilityStateSafe(caster, E技能类型ID, 1, 0);

  const 移速最大化技能ID = stringToFourCC(配置.期间.移速最大化技能ID);
  if (GetUnitAbilityLevel(caster, 移速最大化技能ID) <= 0) {
    context.移速最大化技能由D添加 = UnitAddAbility(caster, 移速最大化技能ID);
  }

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

  // 马甲位置更新（0.05秒主周期：保高度+马甲一跟随+马甲二跟随）
  context.马甲更新回调ID = addPeriodicCallback(
    配置.马甲二.更新周期秒 * 1000,
    更新D马甲群 as unknown as (this: void, variable?: any) => void,
    context,
  );

  // 10秒后清理
  context.清理回调ID = addDelayedCallback(
    配置.持续秒 * 1000,
    清理D到期 as unknown as (this: void, variable?: any) => void,
    context,
  );
  技能强制调试输出(D日志模块, "启动完成", "鼓舞回调ID", context.鼓舞回调ID, "主周期回调ID", context.马甲更新回调ID, "清理回调ID", context.清理回调ID);
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
  已完成实现: true,
  伤害形态: "无直接伤害，提供 10秒强化状态 + 友军鼓舞",
  期间效果: "暗属性+30%、E冷却固定2.5秒、飞行启用+高度500（主周期保持）、骑蛇表现（马甲一头+马甲二×5蛇身跟随）、每1秒鼓舞800范围友军",
  前置条件: "等级≥40、力量>300",
} as const;
