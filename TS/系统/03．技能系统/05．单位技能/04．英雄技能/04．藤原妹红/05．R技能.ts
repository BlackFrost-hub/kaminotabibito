/** @noSelfInFile */

import { 藤原妹红单位技能配置 } from "./00．配置";
import {
  播放藤原妹红单位音效,
  播放藤原妹红配置动作,
  创建藤原妹红点特效,
  创建藤原妹红单位特效,
  创建藤原妹红移动特效,
  更新藤原妹红移动特效,
  销毁藤原妹红移动特效,
  type 藤原妹红移动特效,
} from "./00A．表现工具";
import { 关闭藤原妹红符卡模式 } from "./04．E技能";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { CameraSetEQNoiseForPlayer, CameraClearNoiseForPlayer } = require("lib.扩展函数.封装函数.07．镜头函数.01．镜头震动") as {
  CameraSetEQNoiseForPlayer: (this: void, whichPlayer: any, magnitude: number) => void;
  CameraClearNoiseForPlayer: (this: void, whichPlayer: any) => void;
};
const { 开始冲锋, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
  停止位移: (this: void, id: number, reason?: string) => boolean;
};
const { 开始线性升降, 停止单位线性升降 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.03．线性升降系统") as {
  开始线性升降: (this: void, unit: any, params: any) => number;
  停止单位线性升降: (this: void, unit: any, reason?: string) => boolean;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 读取单位攻击力, 读取单位最大生命, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  读取单位最大生命: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { SetUnitVertexColorBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitVertexColorBJ: (this: void, unit: any, red: number, green: number, blue: number, transparency: number) => void;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (this: void, unit: any, enabled: boolean) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const IsUnitRace = jass.IsUnitRace as (this: void, unit: any, race: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const RACE_DEMON = jass.RACE_DEMON as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const BJ_DEGTORAD = (jass.bj_DEGTORAD as number) || 0.017453292519943295;

interface 藤原妹红符卡R运行时上下文 {
  施法者: any;
  目标: any;
  施法者X: number;
  施法者Y: number;
  目标X: number;
  目标Y: number;
  技能实例ID?: number;
  结算回调ID: number;
  收尾回调ID: number;
  镜头清理回调ID: number;
  活跃: boolean;
}

interface 藤原妹红普通R运行时上下文 {
  施法者: any;
  目标?: any;
  目标X: number;
  目标Y: number;
  方向角: number;
  攻击力伤害: number;
  自损生命: number;
  技能实例ID?: number;
  冲锋ID: number;
  携带回调ID: number;
  携带已运行秒: number;
  携带中: boolean;
  已上升: boolean;
  已开始下降: boolean;
  凤凰特效?: 藤原妹红移动特效;
  凤凰二段特效?: 藤原妹红移动特效;
  活跃: boolean;
}

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const 普通R技能ID = stringToFourCCSafe(藤原妹红单位技能配置.普通R技能ID);
const 符卡R技能ID = stringToFourCCSafe(藤原妹红单位技能配置.符卡R技能ID);
const 单位类型ID = stringToFourCCSafe(藤原妹红单位技能配置.单位类型ID);
const 普通R上下文表: Record<number, 藤原妹红普通R运行时上下文 | undefined> = {};
const 符卡R上下文表: Record<number, 藤原妹红符卡R运行时上下文 | undefined> = {};
const 普通R诊断模块 = "藤原妹红普通R诊断";
const 符卡R诊断模块 = "藤原妹红符卡R诊断";

function 取单位句柄ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : (GetHandleId(unit) || 0);
}

function 读取符卡R技能等级(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetUnitAbilityLevel(unit, 符卡R技能ID);
}

function 获取普通R上下文(this: void, unit: any): any {
  return unit;
}

function 普通R目标允许抓取(this: void, _caster: any, target: any): boolean {
  if (!单位存活(target)) return false;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return false;
  return IsUnitType(target, UNIT_TYPE_HERO) || IsUnitRace(target, RACE_DEMON);
}

function 普通R冲锋命中过滤(this: void, movingUnit: any, target: any, _displacementId: number): boolean {
  return 普通R目标允许抓取(movingUnit, target);
}

function 销毁普通R凤凰表现(this: void, context: 藤原妹红普通R运行时上下文): void {
  销毁藤原妹红移动特效(context.凤凰特效);
  销毁藤原妹红移动特效(context.凤凰二段特效);
  context.凤凰特效 = undefined;
  context.凤凰二段特效 = undefined;
}

function 清理普通R(this: void, context: 藤原妹红普通R运行时上下文): void {
  if (!context.活跃) return;
  context.活跃 = false;
  if (context.冲锋ID !== 0) {
    停止位移(context.冲锋ID, "中断");
    context.冲锋ID = 0;
  }
  if (context.携带回调ID !== 0) {
    removePeriodicCallback(context.携带回调ID);
    context.携带回调ID = 0;
  }
  停止单位线性升降(context.施法者, "中断");
  if (context.目标 != null && context.目标 !== 0) {
    停止单位线性升降(context.目标, "中断");
    SetUnitPathing(context.目标, true);
    SetUnitFlyHeight(context.目标, 0, 0);
  }
  SetUnitPathing(context.施法者, true);
  SetUnitFlyHeight(context.施法者, 0, 0);
  SetUnitVertexColorBJ(context.施法者, 100, 100, 100, 0);
  SetUnitTimeScale(context.施法者, 藤原妹红单位技能配置.动作恢复速度);
  销毁普通R凤凰表现(context);
  const unitId = 取单位句柄ID(context.施法者);
  if (普通R上下文表[unitId] === context) delete 普通R上下文表[unitId];
}

function 普通R升空结束(this: void, unit: any, reason: string, _liftId: number): void {
  const context = 普通R上下文表[取单位句柄ID(unit)];
  if (context == null || !context.活跃 || context.已开始下降) return;
  if (reason !== "完成" || context.目标 == null || !单位存活(context.目标)) {
    清理普通R(context);
    return;
  }
  context.已开始下降 = true;
  const cfg = 藤原妹红单位技能配置.普通R;
  开始线性升降(context.施法者, {
    持续时间: cfg.携带下降秒,
    高度变化: -cfg.携带高度,
    暂停单位: false,
    主单位: context.施法者,
  });
  开始线性升降(context.目标, {
    持续时间: cfg.携带下降秒,
    高度变化: -cfg.携带高度,
    暂停单位: false,
    主单位: context.施法者,
  });
}

function 完成普通R携带(this: void, context: 藤原妹红普通R运行时上下文): void {
  if (!context.携带中) return;
  context.携带中 = false;
  if (context.携带回调ID !== 0) {
    removePeriodicCallback(context.携带回调ID);
    context.携带回调ID = 0;
  }
  停止单位线性升降(context.施法者, "中断");
  if (context.目标 != null && context.目标 !== 0) {
    停止单位线性升降(context.目标, "中断");
    SetUnitPathing(context.目标, true);
    SetUnitFlyHeight(context.目标, 0, 0);
  }
  SetUnitPathing(context.施法者, true);
  SetUnitFlyHeight(context.施法者, 0, 0);
  SetUnitVertexColorBJ(context.施法者, 100, 100, 100, 0);
  SetUnitTimeScale(context.施法者, 藤原妹红单位技能配置.动作恢复速度);
  销毁普通R凤凰表现(context);
}

function 普通R携带Tick(this: void, variable?: any): void {
  const context = variable as 藤原妹红普通R运行时上下文 | undefined;
  if (context == null || !context.活跃 || !context.携带中) return;
  if (!单位存活(context.施法者) || context.目标 == null || !单位存活(context.目标)) {
    清理普通R(context);
    return;
  }
  const cfg = 藤原妹红单位技能配置.普通R;
  const step = cfg.每次移动距离;
  const radians = context.方向角 * BJ_DEGTORAD;
  const nextX = GetUnitX(context.施法者) + Cos(radians) * step;
  const nextY = GetUnitY(context.施法者) + Sin(radians) * step;
  SetUnitX(context.施法者, nextX);
  SetUnitY(context.施法者, nextY);
  SetUnitX(context.目标, nextX);
  SetUnitY(context.目标, nextY);
  context.携带已运行秒 += cfg.移动间隔毫秒 * 0.001;
  更新藤原妹红移动特效(context.凤凰特效, nextX, nextY);
  if (context.携带已运行秒 >= cfg.目标飞行秒 * 0.5 && context.凤凰二段特效 == null) {
    context.凤凰二段特效 = 创建藤原妹红移动特效(cfg.凤凰二段特效, nextX, nextY, context.方向角);
  }
  更新藤原妹红移动特效(context.凤凰二段特效, nextX, nextY);
  if (context.携带已运行秒 >= cfg.目标飞行秒) 完成普通R携带(context);
}

function 开始普通R携带(this: void, context: 藤原妹红普通R运行时上下文): void {
  if (!context.活跃 || context.目标 == null || !单位存活(context.目标)) {
    清理普通R(context);
    return;
  }
  const cfg = 藤原妹红单位技能配置.普通R;
  const caster = context.施法者;
  const target = context.目标;
  context.携带中 = true;
  context.携带已运行秒 = 0;
  context.已上升 = true;
  SetUnitPathing(target, false);
  SetUnitVertexColorBJ(caster, 100, 100, 100, 100);
  施加眩晕(caster, target, cfg.抓取后控制秒, "藤原妹红-不死鸟舍身击", "技能");
  context.凤凰特效 = 创建藤原妹红移动特效(cfg.凤凰特效, GetUnitX(caster), GetUnitY(caster), context.方向角);
  开始线性升降(caster, {
    持续时间: cfg.携带升空秒,
    高度变化: cfg.携带高度,
    暂停单位: false,
    主单位: caster,
    结束回调: 普通R升空结束,
  });
  开始线性升降(target, {
    持续时间: cfg.携带升空秒,
    高度变化: cfg.携带高度,
    暂停单位: false,
    主单位: caster,
  });
  context.携带回调ID = addPeriodicCallback(cfg.移动间隔毫秒, 普通R携带Tick, context);
}

function 普通R命中目标(this: void, _unit: any, target: any, displacementId: number): void {
  const context = 普通R上下文表[取单位句柄ID(_unit)];
  if (context == null || !context.活跃 || context.目标 != null) return;
  context.目标 = target;
  context.冲锋ID = displacementId;
  debugLogForce(
    普通R诊断模块,
    "普通R命中目标",
    "施法者",
    取单位句柄ID(_unit),
    "目标",
    取单位句柄ID(target),
    "位移ID",
    displacementId,
  );
}

function 普通R冲锋结束(this: void, unit: any, reason: string, _displacementId: number, _hitTarget?: any): void {
  const context = 普通R上下文表[取单位句柄ID(unit)];
  if (context == null || !context.活跃) return;
  debugLogForce(
    普通R诊断模块,
    "普通R冲锋结束",
    "施法者",
    取单位句柄ID(unit),
    "原因",
    reason,
    "目标",
    取单位句柄ID(context.目标),
  );
  context.冲锋ID = 0;
  if (reason === "命中" && context.目标 != null) {
    开始普通R携带(context);
    return;
  }
  清理普通R(context);
}

function 开始普通R冲锋(this: void, variable?: any): void {
  const context = variable as 藤原妹红普通R运行时上下文 | undefined;
  if (context == null || !context.活跃 || !单位存活(context.施法者)) {
    debugLogForce(普通R诊断模块, "普通R冲锋阶段提前退出", "上下文有效", context != null, "上下文活跃", context?.活跃 === true);
    if (context != null) 清理普通R(context);
    return;
  }
  const cfg = 藤原妹红单位技能配置.普通R;
  debugLogForce(
    普通R诊断模块,
    "普通R进入冲锋阶段",
    "施法者",
    取单位句柄ID(context.施法者),
    "目标X",
    context.目标X,
    "目标Y",
    context.目标Y,
  );
  context.冲锋ID = 开始冲锋(context.施法者, {
    目标X: context.目标X,
    目标Y: context.目标Y,
    距离: cfg.每次移动距离 * (cfg.最大移动秒 / (cfg.移动间隔毫秒 * 0.001)),
    持续时间: cfg.最大移动秒,
    动画序号: cfg.动作编号,
    检查地形: true,
    暂停单位: true,
    禁用碰撞: true,
    命中半径: cfg.捕捉范围,
    只命中敌人: true,
    允许重复命中: false,
    命中后结束: true,
    命中过滤: 普通R冲锋命中过滤,
    命中回调: 普通R命中目标,
    结束回调: 普通R冲锋结束,
  });
  if (context.冲锋ID === 0) 清理普通R(context);
}

function 普通R自损结算(this: void, variable?: any): void {
  const context = variable as 藤原妹红普通R运行时上下文 | undefined;
  if (context == null || !context.活跃 || context.目标 == null || !单位存活(context.目标)) return;
  debugLogForce(
    普通R诊断模块,
    "普通R自损结算",
    "施法者",
    取单位句柄ID(context.施法者),
    "目标",
    取单位句柄ID(context.目标),
    "自损生命",
    context.自损生命,
  );
  const caster = context.施法者;
  const target = context.目标;
  const life = GetUnitState(caster, UNIT_STATE_LIFE);
  SetUnitState(caster, UNIT_STATE_LIFE, life - context.自损生命);
  造成单体技能伤害({
    来源: caster,
    目标: target,
    伤害: context.自损生命 + context.攻击力伤害,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    attack: true,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 普通R技能ID,
    技能实例ID: context.技能实例ID,
    标签: "藤原妹红-不死鸟舍身击",
  });
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const cfg = 藤原妹红单位技能配置.普通R;
  for (let i = 0; i < cfg.命中特效.length; i++) {
    创建藤原妹红点特效(cfg.命中特效[i], x, y, context.方向角);
  }
  清理普通R(context);
}

function 释放藤原妹红普通R(this: void, _context: any, caster: any, skillInstanceId?: number): void {
  const casterId = 取单位句柄ID(caster);
  const casterValid = 单位存活(caster) && casterId !== 0;
  debugLogForce(
    普通R诊断模块,
    "进入普通R入口",
    "施法者",
    casterId,
    "单位类型",
    casterValid ? GetUnitTypeId(caster) : 0,
    "普通R技能数字ID",
    普通R技能ID,
    "施法者有效",
    casterValid,
  );
  if (!casterValid) {
    debugLogForce(普通R诊断模块, "普通R提前退出", "原因", "施法者无效");
    return;
  }
  const unitId = casterId;
  const oldContext = 普通R上下文表[unitId];
  if (oldContext != null) 清理普通R(oldContext);
  const cfg = 藤原妹红单位技能配置.普通R;
  const targetX = GetSpellTargetX();
  const targetY = GetSpellTargetY();
  debugLogForce(
    普通R诊断模块,
    "普通R目标点",
    "施法者",
    unitId,
    "目标X",
    targetX,
    "目标Y",
    targetY,
    "硬直秒",
    cfg.硬直秒,
    "自损延迟秒",
    cfg.自损延迟秒,
  );
  const context: 藤原妹红普通R运行时上下文 = {
    施法者: caster,
    目标X: targetX,
    目标Y: targetY,
    方向角: 两点角度(GetUnitX(caster), GetUnitY(caster), targetX, targetY),
    攻击力伤害: 读取单位攻击力(caster) * cfg.伤害攻击力倍率,
    自损生命: 读取单位最大生命(caster) * cfg.自损最大生命比例,
    技能实例ID: skillInstanceId,
    冲锋ID: 0,
    携带回调ID: 0,
    携带已运行秒: 0,
    携带中: false,
    已上升: false,
    已开始下降: false,
    活跃: true,
  };
  普通R上下文表[unitId] = context;
  播放藤原妹红单位音效(caster, cfg.全局音效键);
  创建藤原妹红单位特效(caster, { 模型路径: cfg.胸口特效, 持续秒: cfg.胸口特效持续秒 }, "chest");
  SetUnitFacing(caster, context.方向角);
  开始硬直(caster, cfg.硬直秒);
  播放藤原妹红配置动作(caster, cfg.动作编号, cfg.动作速度);
  addDelayedCallback(cfg.硬直秒 * 1000, 开始普通R冲锋, context);
  addDelayedCallback(cfg.自损延迟秒 * 1000, 普通R自损结算, context);
  debugLogForce(普通R诊断模块, "普通R上下文已创建", "施法者", unitId, "技能实例ID", skillInstanceId);
}

function 藤原妹红普通R单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  for (const key in 普通R上下文表) {
    const context = 普通R上下文表[Number(key)];
    if (context == null || (context.施法者 !== dyingUnit && context.目标 !== dyingUnit)) continue;
    清理普通R(context);
  }
  const cardContext = 符卡R上下文表[取单位句柄ID(dyingUnit)];
  if (cardContext != null && cardContext.施法者 === dyingUnit) 清理符卡R(cardContext);
}

function 获取符卡R上下文(this: void, unit: any): any {
  return unit;
}

function 符卡R目标允许伤害(this: void, context: 藤原妹红符卡R运行时上下文, target: any): boolean {
  return context.活跃
    && 单位存活(target)
    && !IsUnitType(target, UNIT_TYPE_ANCIENT);
}

function 准备符卡R最大生命伤害(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 藤原妹红符卡R运行时上下文 | undefined;
  if (context == null || !符卡R目标允许伤害(context, target)) return undefined;
  const maximumLife = 读取单位最大生命(target);
  if (!(maximumLife > 0)) return undefined;
  return {
    伤害: maximumLife * 藤原妹红单位技能配置.符卡R.目标最大生命倍率,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  };
}

function 准备符卡R损失生命伤害(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 藤原妹红符卡R运行时上下文 | undefined;
  if (context == null || !符卡R目标允许伤害(context, target)) return undefined;
  const maximumLife = 读取单位最大生命(target);
  let lostLife = maximumLife - GetUnitState(target, UNIT_STATE_LIFE);
  if (lostLife < 0) lostLife = 0;
  if (!(lostLife > 0)) return undefined;
  return {
    伤害: lostLife * 藤原妹红单位技能配置.符卡R.目标已损失生命倍率,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  };
}

function 清除符卡R镜头(this: void, variable?: any): void {
  const context = variable as 藤原妹红符卡R运行时上下文 | undefined;
  if (context == null) return;
  context.镜头清理回调ID = 0;
  if (context.施法者 != null && context.施法者 !== 0) {
    CameraClearNoiseForPlayer(GetOwningPlayer(context.施法者));
  }
}

function 清理符卡R(this: void, context: 藤原妹红符卡R运行时上下文): void {
  if (!context.活跃) return;
  context.活跃 = false;
  if (context.结算回调ID !== 0) {
    removeDelayedCallback(context.结算回调ID);
    context.结算回调ID = 0;
  }
  if (context.收尾回调ID !== 0) {
    removeDelayedCallback(context.收尾回调ID);
    context.收尾回调ID = 0;
  }
  if (context.镜头清理回调ID !== 0) {
    removeDelayedCallback(context.镜头清理回调ID);
    context.镜头清理回调ID = 0;
  }
  CameraClearNoiseForPlayer(GetOwningPlayer(context.施法者));
  SetUnitInvulnerable(context.施法者, false);
  const casterId = 取单位句柄ID(context.施法者);
  if (符卡R上下文表[casterId] === context) delete 符卡R上下文表[casterId];
}

function 符卡R收尾(this: void, variable?: any): void {
  const context = variable as 藤原妹红符卡R运行时上下文 | undefined;
  if (context == null || !context.活跃) return;
  context.收尾回调ID = 0;
  清理符卡R(context);
}

function 结算藤原妹红符卡R(this: void, variable?: any): void {
  const context = variable as 藤原妹红符卡R运行时上下文 | undefined;
  if (context == null || !context.活跃) return;
  context.结算回调ID = 0;
  if (!单位存活(context.施法者)) {
    清理符卡R(context);
    return;
  }

  const cfg = 藤原妹红单位技能配置.符卡R;
  SetUnitInvulnerable(context.施法者, false);
  CameraSetEQNoiseForPlayer(GetOwningPlayer(context.施法者), cfg.镜头震动幅度);
  const targets = 获取范围敌军(context.施法者, context.目标X, context.目标Y, cfg.搜索范围);
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: targets,
    技能ID: 符卡R技能ID,
    技能实例ID: context.技能实例ID,
    来源类型: "单位技能",
    标签: "藤原妹红-符卡R-最大生命伤害",
    每目标处理器: 准备符卡R最大生命伤害,
    变量: context,
  });
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: targets,
    技能ID: 符卡R技能ID,
    技能实例ID: context.技能实例ID,
    来源类型: "单位技能",
    标签: "藤原妹红-符卡R-损失生命伤害",
    每目标处理器: 准备符卡R损失生命伤害,
    变量: context,
  });

  for (let i = 1; i <= cfg.外围特效数量; i++) {
    const angle = cfg.外围特效间隔角度 * i;
    const radians = angle * BJ_DEGTORAD;
    创建藤原妹红点特效(
      cfg.外围特效,
      context.施法者X + Cos(radians) * cfg.外围特效半径,
      context.施法者Y + Sin(radians) * cfg.外围特效半径,
      angle,
    );
  }
  创建藤原妹红点特效(cfg.中心特效, context.目标X, context.目标Y);
  context.镜头清理回调ID = addDelayedCallback(cfg.镜头震动持续秒 * 1000, 清除符卡R镜头, context);
}

function 释放藤原妹红符卡R(this: void, _context: any, caster: any, skillInstanceId?: number): void {
  const casterValid = 单位存活(caster);
  debugLogForce(
    符卡R诊断模块,
    "进入符卡R入口",
    "施法者",
    取单位句柄ID(caster),
    "单位类型",
    casterValid ? GetUnitTypeId(caster) : 0,
    "符卡R技能等级",
    读取符卡R技能等级(caster),
    "施法者有效",
    casterValid,
  );
  if (!casterValid) {
    debugLogForce(符卡R诊断模块, "符卡R提前退出", "原因", "施法者无效");
    return;
  }
  关闭藤原妹红符卡模式(caster, true);
  const target = GetSpellTargetUnit();
  const targetValid = 单位存活(target);
  debugLogForce(
    符卡R诊断模块,
    "符卡R目标检查",
    "施法者",
    取单位句柄ID(caster),
    "目标",
    取单位句柄ID(target),
    "目标有效",
    targetValid,
  );
  if (!targetValid) {
    debugLogForce(符卡R诊断模块, "符卡R提前退出", "原因", "目标无效");
    return;
  }
  const casterId = 取单位句柄ID(caster);
  const oldContext = 符卡R上下文表[casterId];
  if (oldContext != null) 清理符卡R(oldContext);

  const cfg = 藤原妹红单位技能配置.符卡R;
  const casterX = GetUnitX(caster);
  const casterY = GetUnitY(caster);
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const direction = 两点角度(casterX, casterY, targetX, targetY);
  const context: 藤原妹红符卡R运行时上下文 = {
    施法者: caster,
    目标: target,
    施法者X: casterX,
    施法者Y: casterY,
    目标X: targetX,
    目标Y: targetY,
    技能实例ID: skillInstanceId,
    结算回调ID: 0,
    收尾回调ID: 0,
    镜头清理回调ID: 0,
    活跃: true,
  };
  符卡R上下文表[casterId] = context;

  播放藤原妹红单位音效(caster, cfg.全局音效键);
  施加眩晕(caster, target, cfg.控制秒, "藤原妹红-符卡R", "技能");
  SetUnitFacing(caster, direction);
  SetUnitFacing(target, direction + 180);
  开始硬直(caster, cfg.硬直秒);
  播放藤原妹红配置动作(caster, cfg.动作编号, cfg.动作速度);
  SetUnitInvulnerable(caster, true);
  创建藤原妹红点特效(cfg.进度条特效, casterX, casterY, direction);
  context.结算回调ID = addDelayedCallback(cfg.结算延迟秒 * 1000, 结算藤原妹红符卡R, context);
  context.收尾回调ID = addDelayedCallback(cfg.收尾延迟秒 * 1000, 符卡R收尾, context);
  debugLogForce(
    符卡R诊断模块,
    "符卡R上下文已创建",
    "施法者",
    casterId,
    "目标",
    取单位句柄ID(target),
    "结算延迟秒",
    cfg.结算延迟秒,
    "收尾延迟秒",
    cfg.收尾延迟秒,
  );
}

function 注册藤原妹红符卡R(this: void): void {
  debugLogForce(
    符卡R诊断模块,
    "注册R监听",
    "单位类型ID",
    藤原妹红单位技能配置.单位类型ID,
    "符卡R技能ID",
    藤原妹红单位技能配置.符卡R技能ID,
    "符卡R数字ID",
    符卡R技能ID,
  );
  注册单位技能壳监听({
    名称: "藤原妹红-符卡R",
    单位类型ID,
    技能ID: 符卡R技能ID,
    获取或创建上下文: 获取符卡R上下文,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 藤原妹红单位技能配置.技能实例持续秒,
    释放技能: 释放藤原妹红符卡R,
  });
}

注册藤原妹红符卡R();

export function 注册藤原妹红普通R(this: void): void {
  注册单位技能壳监听({
    名称: "藤原妹红-不死鸟舍身击",
    单位类型ID,
    技能ID: 普通R技能ID,
    获取或创建上下文: 获取普通R上下文,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 藤原妹红单位技能配置.技能实例持续秒,
    释放技能: 释放藤原妹红普通R,
  });
  registerDeathListener(藤原妹红普通R单位死亡);
}

注册藤原妹红普通R();

debugLogForce(普通R诊断模块, "R模块已加载并完成监听注册");

export const 藤原妹红普通R技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "抓取后携带目标，1.35秒自损与强化单体伤害",
} as const;

export {};
