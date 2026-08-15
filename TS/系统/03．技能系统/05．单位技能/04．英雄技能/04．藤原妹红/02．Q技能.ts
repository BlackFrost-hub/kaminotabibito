/** @noSelfInFile */

import { 藤原妹红单位技能配置 } from "./00．配置";
import { 藤原妹红BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/04．藤原妹红";
import {
  播放藤原妹红单位音效,
  播放藤原妹红配置动作,
  创建藤原妹红点特效,
  创建藤原妹红单位特效,
  创建藤原妹红移动特效,
  更新藤原妹红移动特效,
  销毁藤原妹红移动特效,
  藤原妹红移动特效,
} from "./00A．表现工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 关闭藤原妹红符卡模式 } from "./04．E技能";

const jass = require("jass.common") as any;
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 开始冲锋, 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
  开始击退: (this: void, unit: any, params: any) => number;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 读取单位攻击力, 读取单位最大生命, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  读取单位最大生命: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerManualBuff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => { effect2?: number } | null;
};
const { SetUnitVertexColorBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitVertexColorBJ: (this: void, unit: any, red: number, green: number, blue: number, transparency: number) => void;
};

const stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe as (this: void, value: string) => number;
const 单位类型ID = stringToFourCCSafe(藤原妹红单位技能配置.单位类型ID);
const 普通Q技能ID = stringToFourCCSafe(藤原妹红单位技能配置.普通Q技能ID);
const 普通Q二段技能ID = stringToFourCCSafe(藤原妹红单位技能配置.普通Q二段技能ID);
const 符卡Q技能ID = stringToFourCCSafe(藤原妹红单位技能配置.符卡Q技能ID);
const 无敌技能ID = stringToFourCCSafe("Avul");

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (this: void, unit: any, enabled: boolean) => void;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const IsUnitRace = jass.IsUnitRace as (this: void, unit: any, race: any) => boolean;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const RACE_DEMON = jass.RACE_DEMON as any;
const DEG_TO_RAD = 0.017453292519943295;

interface 普通Q运行时上下文 {
  施法者: any;
  伤害: number;
  命中单位列表: any[];
  凤凰特效?: 藤原妹红移动特效;
  移动表现回调ID: number;
  携带单位回调ID: number;
  携带单位已移动秒: number;
  携带单位飞行高度: number;
  位移ID: number;
  技能实例ID?: number;
}

interface 符卡Q运行时上下文 {
  施法者: any;
  X: number;
  Y: number;
  方向角: number;
  已移动秒: number;
  伤害: number;
  凤凰特效?: 藤原妹红移动特效;
  移动回调ID: number;
  灼烧回调ID: number;
  灼烧次数: number;
  灼烧单位表: Record<number, true | undefined>;
  灼烧单位列表: any[];
  灼烧实例ID: number;
  技能实例ID?: number;
}

const 普通Q上下文表: Record<number, 普通Q运行时上下文 | undefined> = {};
const 符卡Q上下文表: Record<number, 符卡Q运行时上下文 | undefined> = {};
let 下一个符卡Q灼烧实例ID = 1;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 扣除最大生命(this: void, unit: any, ratio: number): void {
  const currentLife = GetUnitState(unit, UNIT_STATE_LIFE);
  const damage = 读取单位最大生命(unit) * ratio;
  const nextLife = currentLife - damage;
  SetUnitState(unit, UNIT_STATE_LIFE, nextLife > 0 ? nextLife : 0);
}

function 切换至普通Q二段(this: void, caster: any): void {
  const owner = GetOwningPlayer(caster);
  SetPlayerAbilityAvailable(owner, 普通Q技能ID, false);
  UnitAddAbility(caster, 普通Q二段技能ID);
  SetPlayerAbilityAvailable(owner, 普通Q二段技能ID, true);
}

function 恢复普通Q形态(this: void, variable?: any): void {
  const caster = variable as any;
  if (caster == null || caster === 0) return;
  const owner = GetOwningPlayer(caster);
  SetPlayerAbilityAvailable(owner, 普通Q技能ID, true);
  UnitRemoveAbility(caster, 普通Q二段技能ID);
}

function 普通Q移动表现Tick(this: void, variable?: any): void {
  const context = variable as 普通Q运行时上下文 | undefined;
  if (context == null || context.凤凰特效 == null || !单位存活(context.施法者)) return;
  const cfg = 藤原妹红单位技能配置.普通Q;
  const x = GetUnitX(context.施法者);
  const y = GetUnitY(context.施法者);
  更新藤原妹红移动特效(context.凤凰特效, x, y);
  创建藤原妹红点特效(cfg.移动特效, x, y);
}

function 普通Q携带单位Tick(this: void, variable?: any): void {
  const context = variable as 普通Q运行时上下文 | undefined;
  if (context == null || !单位存活(context.施法者)) return;

  const cfg = 藤原妹红单位技能配置.普通Q;
  context.携带单位已移动秒 += cfg.携带单位更新间隔毫秒 * 0.001;
  if (context.携带单位已移动秒 <= cfg.携带单位抬升阶段秒) {
    context.携带单位飞行高度 += cfg.携带单位高度增量;
  } else if (context.携带单位飞行高度 > 0) {
    context.携带单位飞行高度 -= cfg.携带单位高度增量;
    if (context.携带单位飞行高度 < 0) context.携带单位飞行高度 = 0;
  }

  const x = GetUnitX(context.施法者);
  const y = GetUnitY(context.施法者);
  for (let i = 0; i < context.命中单位列表.length; i++) {
    const target = context.命中单位列表[i];
    if (!单位存活(target)) continue;
    SetUnitX(target, x);
    SetUnitY(target, y);
    SetUnitFlyHeight(target, context.携带单位飞行高度, 0);
  }
}

function 恢复普通Q携带单位(this: void, context: 普通Q运行时上下文): void {
  if (context.携带单位回调ID !== 0) {
    removePeriodicCallback(context.携带单位回调ID);
    context.携带单位回调ID = 0;
  }

  const casterAlive = 单位存活(context.施法者);
  const x = casterAlive ? GetUnitX(context.施法者) : 0;
  const y = casterAlive ? GetUnitY(context.施法者) : 0;
  for (let i = 0; i < context.命中单位列表.length; i++) {
    const target = context.命中单位列表[i];
    if (!单位存活(target)) continue;
    if (casterAlive) {
      SetUnitX(target, x);
      SetUnitY(target, y);
    }
    SetUnitPathing(target, true);
    SetUnitFlyHeight(target, GetUnitDefaultFlyHeight(target), 0);
  }
}

function 普通Q命中过滤(this: void, _movingUnit: any, target: any, _moveId: number): boolean {
  return 单位存活(target)
    && IsUnitType(target, UNIT_TYPE_ANCIENT) !== true
    && IsUnitType(target, UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(target, UNIT_TYPE_STRUCTURE) !== true;
}

function 普通Q命中(this: void, caster: any, target: any, _moveId: number): void {
  const context = 普通Q上下文表[取单位句柄ID(caster)];
  if (context == null || !普通Q命中过滤(caster, target, _moveId)) return;
  context.命中单位列表.push(target);
  施加眩晕(caster, target, 藤原妹红单位技能配置.普通Q.命中控制秒, "藤原妹红-不死鸟附体", "技能");
}

function 准备普通Q伤害(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 普通Q运行时上下文 | undefined;
  if (context == null || !单位存活(target)) return undefined;
  const effects = 藤原妹红单位技能配置.普通Q.命中特效;
  for (let i = 0; i < effects.length; i++) {
    创建藤原妹红单位特效(target, effects[i], effects[i].挂点);
  }
  return {
    伤害: context.伤害,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  };
}

function 处理普通Q冲锋结束(this: void, caster: any, reason: string, moveId: number): void {
  const handleId = 取单位句柄ID(caster);
  const context = 普通Q上下文表[handleId];
  if (context == null || context.位移ID !== moveId) return;
  恢复普通Q携带单位(context);
  delete 普通Q上下文表[handleId];
  if (context.移动表现回调ID !== 0) removePeriodicCallback(context.移动表现回调ID);
  销毁藤原妹红移动特效(context.凤凰特效);
  UnitRemoveAbility(caster, 无敌技能ID);
  SetUnitPathing(caster, true);
  SetUnitVertexColorBJ(caster, 100, 100, 100, 0);

  if (!单位存活(caster) || reason === "死亡" || reason === "主单位死亡") return;
  const cfg = 藤原妹红单位技能配置.普通Q;
  创建藤原妹红点特效(cfg.结束特效, GetUnitX(caster), GetUnitY(caster));
  if (context.命中单位列表.length === 0) {
    YDWESetUnitAbilityStateSafe(caster, 普通Q技能ID, 1, cfg.无命中冷却秒);
    return;
  }
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: context.命中单位列表,
    伤害: context.伤害,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 普通Q技能ID,
    技能实例ID: context.技能实例ID,
    标签: "藤原妹红-不死鸟附体",
    每目标处理器: 准备普通Q伤害,
    变量: context,
  });
}

function 释放藤原妹红普通Q(this: void, _context: any, caster: any, skillInstanceId?: number): void {
  const cfg = 藤原妹红单位技能配置.普通Q;
  扣除最大生命(caster, cfg.生命消耗最大生命比例);
  切换至普通Q二段(caster);
  播放藤原妹红单位音效(caster, cfg.全局音效键);
  const startX = GetUnitX(caster);
  const startY = GetUnitY(caster);
  const targetX = GetSpellTargetX();
  const targetY = GetSpellTargetY();
  const direction = 两点角度(startX, startY, targetX, targetY);
  const context: 普通Q运行时上下文 = {
    施法者: caster,
    伤害: 读取单位攻击力(caster) + 读取单位最大生命(caster) * cfg.命中伤害最大生命倍率,
    命中单位列表: [],
    移动表现回调ID: 0,
    携带单位回调ID: 0,
    携带单位已移动秒: 0,
    携带单位飞行高度: 0,
    位移ID: 0,
    技能实例ID: skillInstanceId,
  };
  context.凤凰特效 = 创建藤原妹红移动特效(cfg.凤凰特效, startX, startY, direction);
  UnitAddAbility(caster, 无敌技能ID);
  SetUnitVertexColorBJ(caster, 100, 100, 100, 100);
  SetUnitPathing(caster, false);
  普通Q上下文表[取单位句柄ID(caster)] = context;
  创建藤原妹红点特效(cfg.移动特效, startX, startY);
  context.移动表现回调ID = addPeriodicCallback(cfg.移动特效.触发间隔秒 * 1000, 普通Q移动表现Tick, context);
  context.携带单位回调ID = addPeriodicCallback(cfg.携带单位更新间隔毫秒, 普通Q携带单位Tick, context);
  context.位移ID = 开始冲锋(caster, {
    角度: direction,
    距离: cfg.最大移动距离,
    每秒速度: cfg.每次移动距离 / (cfg.移动间隔毫秒 * 0.001),
    持续时间: cfg.最大移动秒,
    检查地形: true,
    朝向跟随位移: true,
    暂停单位: false,
    禁用碰撞: true,
    命中半径: cfg.捕捉范围,
    只命中敌人: true,
    允许重复命中: false,
    命中后结束: false,
    命中过滤: 普通Q命中过滤,
    命中回调: 普通Q命中,
    结束回调: 处理普通Q冲锋结束,
  });
  if (context.位移ID <= 0) 处理普通Q冲锋结束(caster, "中断", context.位移ID);
  addDelayedCallback(cfg.形态恢复秒 * 1000, 恢复普通Q形态, caster);
}

interface 普通Q二段命中变量 {
  施法者: any;
  配置: typeof 藤原妹红单位技能配置.普通Q二段;
  攻击力: number;
}

function 普通Q二段目标过滤(this: void, target: any): boolean {
  return 单位存活(target)
    && IsUnitType(target, UNIT_TYPE_ANCIENT) !== true
    && IsUnitType(target, UNIT_TYPE_MECHANICAL) !== true;
}

function 准备普通Q二段伤害(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 普通Q二段命中变量 | undefined;
  if (context == null || !普通Q二段目标过滤(target)) return undefined;
  const isHeroOrDemon = IsUnitType(target, UNIT_TYPE_HERO) === true || IsUnitRace(target, RACE_DEMON) === true;
  const multiplier = isHeroOrDemon
    ? context.配置.伤害英雄恶魔攻击力倍率
    : context.配置.伤害普通敌人攻击力倍率;
  return {
    伤害: context.攻击力 * multiplier,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  };
}

function 普通Q二段命中后(this: void, target: any, _index: number, success: boolean, variable?: any): void {
  const context = variable as 普通Q二段命中变量 | undefined;
  if (!success || context == null || !普通Q二段目标过滤(target)) return;
  施加眩晕(context.施法者, target, context.配置.控制秒, "藤原妹红-超高温羽毛", "技能");
  开始击退(target, {
    来源单位: context.施法者,
    主单位: context.施法者,
    主单位死亡时中断: true,
    距离: context.配置.击退距离,
    持续时间: context.配置.击退持续秒,
    检查地形: true,
    禁用碰撞: true,
    暂停单位: false,
  });
}

function 释放藤原妹红普通Q二段(this: void, _context: any, caster: any, skillInstanceId?: number): void {
  const cfg = 藤原妹红单位技能配置.普通Q二段;
  扣除最大生命(caster, cfg.生命消耗最大生命比例);
  播放藤原妹红单位音效(caster, cfg.全局音效键);
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const angleStep = cfg.环形特效间隔角度 * DEG_TO_RAD;
  for (let i = 1; i <= 9; i++) {
    const angle = i * angleStep;
    for (let j = 0; j < cfg.环形特效半径列表.length; j++) {
      const radius = cfg.环形特效半径列表[j];
      创建藤原妹红点特效({
        模型路径: cfg.环形特效模型路径,
        Z: 0,
        缩放: cfg.环形特效缩放,
        持续秒: cfg.环形特效持续秒,
      }, x + radius * Cos(angle), y + radius * Sin(angle));
    }
  }
  const context: 普通Q二段命中变量 = { 施法者: caster, 配置: cfg, 攻击力: 读取单位攻击力(caster) };
  const targets = getEnemyUnitsInRange(caster, x, y, cfg.搜索范围);
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 普通Q二段技能ID,
    技能实例ID: skillInstanceId,
    标签: "藤原妹红-超高温羽毛",
    每目标处理器: 准备普通Q二段伤害,
    每目标结算后处理器: 普通Q二段命中后,
    变量: context,
  });
  恢复普通Q形态(caster);
}

function 符卡Q命中过滤(this: void, target: any, caster: any): boolean {
  return target != null
    && target !== 0
    && target !== caster
    && 单位存活(target)
    && IsUnitType(target, UNIT_TYPE_ANCIENT) !== true
    && IsUnitType(target, UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(target, UNIT_TYPE_STRUCTURE) !== true;
}

function 记录符卡Q目标(this: void, context: 符卡Q运行时上下文, target: any): boolean {
  const targetId = 取单位句柄ID(target);
  if (targetId === 0 || context.灼烧单位表[targetId] === true) return false;
  context.灼烧单位表[targetId] = true;
  context.灼烧单位列表.push(target);
  return true;
}

function 准备符卡Q首次伤害(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 符卡Q运行时上下文 | undefined;
  if (context == null || !符卡Q命中过滤(target, context.施法者)) return undefined;
  return {
    伤害: context.伤害 * 藤原妹红单位技能配置.符卡Q.首次伤害攻击力倍率,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  };
}

function 准备符卡Q灼烧伤害(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 符卡Q运行时上下文 | undefined;
  if (context == null || !符卡Q命中过滤(target, context.施法者)) return undefined;
  const burnBuff = getBuffRuntime(target, 藤原妹红BuffID.符卡Q灼烧);
  if (burnBuff == null || burnBuff.effect2 !== context.灼烧实例ID) return undefined;
  const effects = 藤原妹红单位技能配置.符卡Q.灼烧命中特效;
  for (let i = 0; i < effects.length; i++) {
    创建藤原妹红单位特效(target, effects[i], effects[i].挂点);
  }
  return {
    伤害: context.伤害 * 藤原妹红单位技能配置.符卡Q.灼烧伤害攻击力倍率,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  };
}

function 登记符卡Q灼烧Buff(this: void, context: 符卡Q运行时上下文): void {
  const cfg = 藤原妹红单位技能配置.符卡Q;
  const 持续秒 = cfg.灼烧间隔秒 * cfg.灼烧次数 + cfg.灼烧Buff额外宽限秒;
  const 每跳伤害 = context.伤害 * cfg.灼烧伤害攻击力倍率;
  for (let i = 0; i < context.灼烧单位列表.length; i++) {
    const target = context.灼烧单位列表[i];
    if (!符卡Q命中过滤(target, context.施法者)) continue;
    registerManualBuff(target, 藤原妹红BuffID.符卡Q灼烧, 持续秒, 每跳伤害, {
      sourceName: "藤原妹红-符卡Q",
      effectSourceName: "符卡Q灼烧",
      effectSourceType: "技能",
      effectValue2: context.灼烧实例ID,
    });
  }
}

function 符卡Q灼烧Tick(this: void, variable?: any): void {
  const context = variable as 符卡Q运行时上下文 | undefined;
  if (context == null) return;
  const cfg = 藤原妹红单位技能配置.符卡Q;
  if (context.灼烧次数 >= cfg.灼烧次数) {
    if (context.灼烧回调ID !== 0) removePeriodicCallback(context.灼烧回调ID);
    context.灼烧回调ID = 0;
    delete 符卡Q上下文表[取单位句柄ID(context.施法者)];
    return;
  }
    context.灼烧次数 += 1;
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: context.灼烧单位列表,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 符卡Q技能ID,
    技能实例ID: context.技能实例ID,
    标签: "藤原妹红-符卡Q灼烧",
    每目标处理器: 准备符卡Q灼烧伤害,
    变量: context,
  });
}

function 清理符卡Q(this: void, context: 符卡Q运行时上下文): void {
  if (context.移动回调ID !== 0) removePeriodicCallback(context.移动回调ID);
  context.移动回调ID = 0;
  if (context.灼烧回调ID !== 0) removePeriodicCallback(context.灼烧回调ID);
  context.灼烧回调ID = 0;
  销毁藤原妹红移动特效(context.凤凰特效);
  delete 符卡Q上下文表[取单位句柄ID(context.施法者)];
}

function 符卡Q移动Tick(this: void, variable?: any): void {
  const context = variable as 符卡Q运行时上下文 | undefined;
  if (context == null) return;
  const cfg = 藤原妹红单位技能配置.符卡Q;
  if (!单位存活(context.施法者)) {
    清理符卡Q(context);
    return;
  }
  if (context.已移动秒 >= cfg.最大移动秒) {
    if (context.移动回调ID !== 0) removePeriodicCallback(context.移动回调ID);
    context.移动回调ID = 0;
    if (context.灼烧单位列表.length > 0) {
      登记符卡Q灼烧Buff(context);
      context.灼烧回调ID = addPeriodicCallback(cfg.灼烧间隔秒 * 1000, 符卡Q灼烧Tick, context);
    } else {
      delete 符卡Q上下文表[取单位句柄ID(context.施法者)];
      销毁藤原妹红移动特效(context.凤凰特效);
    }
    return;
  }

  const step = cfg.每次移动距离;
  const radians = context.方向角 * DEG_TO_RAD;
  context.X += step * Cos(radians);
  context.Y += step * Sin(radians);
  context.已移动秒 += cfg.移动间隔毫秒 * 0.001;
  更新藤原妹红移动特效(context.凤凰特效, context.X, context.Y);
  for (let i = 0; i < cfg.移动特效.length; i++) {
    创建藤原妹红点特效(cfg.移动特效[i], context.X, context.Y);
  }

  const candidates = getEnemyUnitsInRange(context.施法者, context.X, context.Y, cfg.捕捉范围);
  const newTargets: any[] = [];
  for (let i = 0; i < candidates.length; i++) {
    const target = candidates[i];
    if (符卡Q命中过滤(target, context.施法者) && 记录符卡Q目标(context, target)) newTargets.push(target);
  }
  if (newTargets.length > 0) {
    造成批量AOE技能伤害({
      来源: context.施法者,
      目标列表: newTargets,
      伤害类型: DAMAGE_TYPE_FIRE,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: 符卡Q技能ID,
      技能实例ID: context.技能实例ID,
      标签: "藤原妹红-符卡Q首次命中",
      每目标处理器: 准备符卡Q首次伤害,
      变量: context,
    });
  }
}

function 开始符卡Q移动(this: void, variable?: any): void {
  const context = variable as 符卡Q运行时上下文 | undefined;
  if (context == null || !单位存活(context.施法者)) {
    if (context != null) 清理符卡Q(context);
    return;
  }
  const cfg = 藤原妹红单位技能配置.符卡Q;
  context.凤凰特效 = 创建藤原妹红移动特效(cfg.凤凰特效, context.X, context.Y, context.方向角);
  context.移动回调ID = addPeriodicCallback(cfg.移动间隔毫秒, 符卡Q移动Tick, context);
}

function 释放藤原妹红符卡Q(this: void, _context: any, caster: any, skillInstanceId?: number): void {
  const cfg = 藤原妹红单位技能配置.符卡Q;
  关闭藤原妹红符卡模式(caster, true);
  播放藤原妹红单位音效(caster, cfg.全局音效键);
  const startX = GetUnitX(caster);
  const startY = GetUnitY(caster);
  const direction = 两点角度(startX, startY, GetSpellTargetX(), GetSpellTargetY());
  开始硬直(caster, cfg.硬直秒);
  播放藤原妹红配置动作(caster, cfg.动作编号, cfg.动作速度);
  SetUnitFacing(caster, direction);
  const context: 符卡Q运行时上下文 = {
    施法者: caster,
    X: startX,
    Y: startY,
    方向角: direction,
    已移动秒: 0,
    伤害: 读取单位攻击力(caster),
    移动回调ID: 0,
    灼烧回调ID: 0,
    灼烧次数: 0,
    灼烧单位表: {},
    灼烧单位列表: [],
    灼烧实例ID: 下一个符卡Q灼烧实例ID,
    技能实例ID: skillInstanceId,
  };
  下一个符卡Q灼烧实例ID += 1;
  符卡Q上下文表[取单位句柄ID(caster)] = context;
  addDelayedCallback(cfg.启动延迟秒 * 1000, 开始符卡Q移动, context);
}

function 藤原妹红Q单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const unitId = 取单位句柄ID(dyingUnit);
  const normalContext = 普通Q上下文表[unitId];
  if (normalContext != null) {
    恢复普通Q携带单位(normalContext);
    if (normalContext.移动表现回调ID !== 0) removePeriodicCallback(normalContext.移动表现回调ID);
    销毁藤原妹红移动特效(normalContext.凤凰特效);
    delete 普通Q上下文表[unitId];
  }
  const cardContext = 符卡Q上下文表[unitId];
  if (cardContext != null) 清理符卡Q(cardContext);
}

function 获取藤原妹红技能上下文(this: void, unit: any): any {
  return unit;
}

export function 注册藤原妹红Q技能(this: void): void {
  注册单位技能壳监听({
    名称: "藤原妹红-不死鸟附体",
    单位类型ID: 单位类型ID,
    技能ID: 普通Q技能ID,
    获取或创建上下文: 获取藤原妹红技能上下文,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 藤原妹红单位技能配置.技能实例持续秒,
    释放技能: 释放藤原妹红普通Q,
  });
  注册单位技能壳监听({
    名称: "藤原妹红-超高温羽毛",
    单位类型ID: 单位类型ID,
    技能ID: 普通Q二段技能ID,
    获取或创建上下文: 获取藤原妹红技能上下文,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 藤原妹红单位技能配置.技能实例持续秒,
    释放技能: 释放藤原妹红普通Q二段,
  });
  注册单位技能壳监听({
    名称: "藤原妹红-符卡Q",
    单位类型ID: 单位类型ID,
    技能ID: 符卡Q技能ID,
    获取或创建上下文: 获取藤原妹红技能上下文,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 藤原妹红单位技能配置.技能实例持续秒,
    释放技能: 释放藤原妹红符卡Q,
  });
  registerDeathListener(藤原妹红Q单位死亡);
}

注册藤原妹红Q技能();

export const 藤原妹红Q技能状态 = {
  已完成设计: true,
  已完成实现: true,
  普通Q: "位移系统冲锋命中记录，结束时统一火焰伤害并恢复技能形态",
  普通Q二段: "配置化环形表现、分目标伤害倍率、眩晕与击退",
  符卡Q: "纯凤凰表现特效投射，首次命中后每秒三次灼烧",
} as const;

export {};
