/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { createDelayedCall, cancelDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => { id: number };
  cancelDelayedCall: (this: void, handle: { id: number } | number | null | undefined) => void;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 扩散伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.08．扩散伤害.扩散伤害") as {
  扩散伤害: (this: void, 参数: {
    来源单位: any;
    主目标: any;
    伤害值: number;
    扩散半径: number;
    扩散百分比: number;
    是否包含主目标?: boolean;
    攻击类型?: any;
    伤害类型?: any;
    武器类型?: any;
  }) => void;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { getObjectPropertyIntegerSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertyIntegerSafe: (this: void, objectType: number, objectId: number | string, property: string) => number;
};
const { ObjectType } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  ObjectType: { ABILITY: number };
};

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

import { 巨魔大剑物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 巨魔大剑配置 } from "../03．主动技能/02．施法触发/00．施法触发配置";

type 巨魔大剑计时器句柄 = { id: number };

const 巨魔大剑窗口计时器: Map<number, 巨魔大剑计时器句柄> = new Map();
let 已注册巨魔大剑首伤监听 = false;

function 单位持有巨魔大剑(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (巨魔大剑物品ID <= 0) {
    debugLogForce("10．巨魔大剑", "单位持有巨魔大剑", "物品ID<=0", 巨魔大剑物品ID);
    return false;
  }
  const result = UnitHasItemOfTypeBJ(单位, 巨魔大剑物品ID) === true;
  debugLogForce("10．巨魔大剑", "单位持有巨魔大剑", "单位=", 单位, "物品ID=", 巨魔大剑物品ID, "结果=", result);
  return result;
}

function 巨魔大剑条件成立(this: void, 施法单位: any, 技能ID: number): boolean {
  if (!IsUnitType(施法单位, UNIT_TYPE_HERO)) {
    debugLogForce("10．巨魔大剑", "条件不成立", "非英雄单位");
    return false;
  }
  if (!单位持有巨魔大剑(施法单位)) {
    debugLogForce("10．巨魔大剑", "条件不成立", "未持有巨魔大剑");
    return false;
  }
  const DataB1 = getObjectPropertyIntegerSafe(ObjectType.ABILITY, 技能ID, "DataB1");
  debugLogForce("10．巨魔大剑", "条件检查", "技能ID=", 技能ID, "DataB1=", DataB1);
  return DataB1 === 1 || DataB1 === 3;
}

function 获取巨魔大剑窗口键(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位);
}

function 清理巨魔大剑窗口(this: void, 单位: any, 取消计时器: boolean = true): void {
  const 键 = 获取巨魔大剑窗口键(单位);
  if (键 <= 0) return;

  const 句柄 = 巨魔大剑窗口计时器.get(键);
  if (取消计时器 && 句柄 != null) {
    cancelDelayedCall(句柄);
  }
  巨魔大剑窗口计时器.delete(键);
}

function 打开巨魔大剑窗口(this: void, 单位: any): void {
  const 键 = 获取巨魔大剑窗口键(单位);
  if (键 <= 0) {
    debugLogForce("10．巨魔大剑", "打开窗口失败", "键<=0");
    return;
  }

  debugLogForce("10．巨魔大剑", "打开窗口", "单位=", 单位, "键=", 键);
  清理巨魔大剑窗口(单位, true);

  let 句柄: 巨魔大剑计时器句柄 | null = null;
  句柄 = createDelayedCall(巨魔大剑配置.持续时间, function (this: void): void {
    if (句柄 == null) return;
    if (巨魔大剑窗口计时器.get(键) === 句柄) {
      巨魔大剑窗口计时器.delete(键);
      debugLogForce("10．巨魔大剑", "窗口结束", "键=", 键);
    }
  });
  巨魔大剑窗口计时器.set(键, 句柄);
  debugLogForce("10．巨魔大剑", "窗口已设置", "持续时间=", 巨魔大剑配置.持续时间);
}

function 获取扩散伤害类型(this: void, snapshot: any): { 攻击类型: any; 伤害类型: any; 武器类型: any } {
  const 默认攻击类型 = jass.ATTACK_TYPE_NORMAL;
  const 默认伤害类型 = jass.DAMAGE_TYPE_NORMAL;
  if (snapshot == null) {
    return { 攻击类型: 默认攻击类型, 伤害类型: 默认伤害类型, 武器类型: null };
  }

  if (snapshot.isTrueDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_MIND, 武器类型: null };
  }
  if (snapshot.isEnhancedDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_ENHANCED, 武器类型: null };
  }
  if (snapshot.isFireDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_FIRE, 武器类型: null };
  }
  if (snapshot.isThunderDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_LIGHTNING, 武器类型: null };
  }
  if (snapshot.isLightDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_DIVINE, 武器类型: null };
  }
  if (snapshot.isDarkDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_SHADOW_STRIKE, 武器类型: null };
  }
  if (snapshot.isWoodDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_PLANT, 武器类型: null };
  }
  if (snapshot.isWaterDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_COLD, 武器类型: null };
  }
  if (snapshot.isMetalDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_POISON, 武器类型: null };
  }
  if (snapshot.isSkillAttack === true || snapshot.isSkillDamage === true || snapshot.isMagicDamage === true) {
    return { 攻击类型: 默认攻击类型, 伤害类型: jass.DAMAGE_TYPE_MAGIC, 武器类型: null };
  }
  return { 攻击类型: 默认攻击类型, 伤害类型: 默认伤害类型, 武器类型: null };
}

function 处理巨魔大剑首伤(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  debugLogForce("10．巨魔大剑", "首伤回调", "target=", target, "attacker=", attacker, "applied=", applied);
  if (target == null || attacker == null || !(applied > 0)) {
    debugLogForce("10．巨魔大剑", "首伤跳过", "参数无效");
    return;
  }
  if (!单位持有巨魔大剑(attacker)) {
    debugLogForce("10．巨魔大剑", "首伤跳过", "攻击者未持有巨魔大剑");
    return;
  }

  const 键 = 获取巨魔大剑窗口键(attacker);
  if (键 <= 0) {
    debugLogForce("10．巨魔大剑", "首伤跳过", "键<=0");
    return;
  }
  const 句柄 = 巨魔大剑窗口计时器.get(键);
  if (句柄 == null) {
    debugLogForce("10．巨魔大剑", "首伤跳过", "无窗口句柄");
    return;
  }

  debugLogForce("10．巨魔大剑", "首伤触发", "source=", attacker, "target=", target, "applied=", applied, "键=", 键);
  巨魔大剑窗口计时器.delete(键);
  cancelDelayedCall(句柄);

  const x = GetUnitX(target);
  const y = GetUnitY(target);
  createTimedEffect(巨魔大剑配置.扩散特效路径, x, y, 0, 巨魔大剑配置.扩散特效持续时间);

  const 类型 = 获取扩散伤害类型(snapshot);
  debugLogForce("10．巨魔大剑", "扩散伤害", "扩散半径=", 巨魔大剑配置.扩散半径, "扩散百分比=", 巨魔大剑配置.扩散百分比);
  扩散伤害({
    来源单位: attacker,
    主目标: target,
    伤害值: applied,
    扩散半径: 巨魔大剑配置.扩散半径,
    扩散百分比: 巨魔大剑配置.扩散百分比,
    是否包含主目标: false,
    攻击类型: 类型.攻击类型,
    伤害类型: 类型.伤害类型,
    武器类型: 类型.武器类型,
  });
}

function 初始化巨魔大剑首伤监听(this: void): void {
  if (已注册巨魔大剑首伤监听) return;
  已注册巨魔大剑首伤监听 = true;
  registerAppliedFinalDamageListener(处理巨魔大剑首伤);
}

export function 处理巨魔大剑施法(this: void, 施法单位: any, 技能ID: number, 目标单位: any): void {
  debugLogForce("10．巨魔大剑", "进入", "处理巨魔大剑施法");
  初始化巨魔大剑首伤监听();
  if (!巨魔大剑条件成立(施法单位, 技能ID)) return;
  if (目标单位 == null || 目标单位 === 0) return;
  打开巨魔大剑窗口(施法单位);
}

初始化巨魔大剑首伤监听();

export {};
