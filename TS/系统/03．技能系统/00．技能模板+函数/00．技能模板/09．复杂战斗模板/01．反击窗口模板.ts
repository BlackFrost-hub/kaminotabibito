/** @noSelfInFile */

import { 单位是否在来源正面扇区, 单位是否在来源背后扇区 } from "../../04．机制组件/10．复杂战斗通用机制/08．方位判定工具";
import type { 机制清理篮子 } from "../../04．机制组件/06．机制清理/01．机制清理篮子";

export interface DamageModifierContext {
  target: any;
  attacker: any;
  baseDamage: number;
  currentDamage: number;
  isNormalAttack: boolean;
  isSkillAttack: boolean;
  isSkillDamage: boolean;
}

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: DamageModifierContext) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

export interface 反击窗口模板参数 {
  清理?: 机制清理篮子;
  名称: string;
  单位: any;
  持续秒: number;
  正面减伤角度?: number;
  正面伤害倍率?: number;
  背后破招角度?: number;
  背后受伤倍率?: number;
  仅普攻?: boolean;
  仅技能伤害?: boolean;
  触发条件?: (this: void, context: DamageModifierContext) => boolean;
  修正优先级?: number;
  on反击?: (this: void, context: DamageModifierContext, 修改后伤害: number) => void;
  on破招?: (this: void, context: DamageModifierContext, 修改后伤害: number) => void;
  on结束?: (this: void, 原因: "到期" | "破招" | "手动取消") => void;
}

export interface 反击窗口模板实例 {
  取消(原因?: "到期" | "破招" | "手动取消"): void;
}

class 反击窗口模板实现 implements 反击窗口模板实例 {
  private 参数: 反击窗口模板参数;
  private 修正ID = 0;
  private 到期ID = 0;
  private 已结束 = false;

  constructor(参数: 反击窗口模板参数) {
    this.参数 = 参数;
    const self = this;
    this.修正ID = registerDamageModifier(function 反击窗口伤害修正(this: void, context: DamageModifierContext): number {
      return self.处理伤害(context);
    }, 参数.修正优先级 ?? 40);
    this.到期ID = addDelayedCallback(参数.持续秒 * 1000, function 反击窗口到期(this: void): void {
      self.取消("到期");
    });
  }

  取消(原因: "到期" | "破招" | "手动取消" = "手动取消"): void {
    if (this.已结束) return;
    this.已结束 = true;
    if (this.修正ID !== 0) {
      unregisterDamageModifier(this.修正ID);
      this.修正ID = 0;
    }
    if (this.到期ID !== 0) {
      removeDelayedCallback(this.到期ID);
      this.到期ID = 0;
    }
    if (this.参数.on结束 != null) this.参数.on结束(原因);
  }

  private 处理伤害(context: DamageModifierContext): number {
    if (this.已结束 || context.target !== this.参数.单位) return context.currentDamage;
    if (this.参数.仅普攻 === true && context.isNormalAttack !== true) return context.currentDamage;
    if (this.参数.仅技能伤害 === true && context.isSkillDamage !== true && context.isSkillAttack !== true) return context.currentDamage;
    if (this.参数.触发条件 != null && !this.参数.触发条件(context)) return context.currentDamage;

    let result = context.currentDamage;
    if (this.参数.背后破招角度 != null && 单位是否在来源背后扇区(this.参数.单位, context.attacker, this.参数.背后破招角度)) {
      result = result * (this.参数.背后受伤倍率 ?? 1);
      if (this.参数.on破招 != null) this.参数.on破招(context, result);
      this.取消("破招");
      return result;
    }

    if (this.参数.正面减伤角度 != null && 单位是否在来源正面扇区(this.参数.单位, context.attacker, this.参数.正面减伤角度)) {
      result = result * (this.参数.正面伤害倍率 ?? 1);
      if (this.参数.on反击 != null) this.参数.on反击(context, result);
      return result;
    }

    return result;
  }
}

export function 创建反击窗口模板(this: void, 参数: 反击窗口模板参数): 反击窗口模板实例 {
  const 实例 = new 反击窗口模板实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 反击窗口模板清理(this: void): void {
      实例.取消("手动取消");
    });
  }
  return 实例;
}
