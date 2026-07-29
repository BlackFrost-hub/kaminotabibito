/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const { addDelayedCallback, removeDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export type 次数型伤害免疫类型 =
  | "任意伤害"
  | "物理伤害"
  | "魔法伤害"
  | "真实伤害"
  | "普攻伤害"
  | "纯普攻伤害"
  | "远程伤害"
  | "近战伤害"
  | "技能伤害"
  | "强化伤害"
  | "单体技能伤害"
  | "AOE技能伤害"
  | "装备技能伤害"
  | "非装备技能伤害"
  | "金属性伤害"
  | "木属性伤害"
  | "水属性伤害"
  | "火属性伤害"
  | "雷属性伤害"
  | "光属性伤害"
  | "暗属性伤害";

export type 次数型伤害免疫结束原因 = "次数耗尽" | "到期" | "手动移除" | "清理";

export interface 次数型伤害免疫事件 {
  单位: any;
  攻击者: any;
  被免疫伤害: number;
  剩余次数: number;
  上下文: any;
  控制器: 次数型伤害免疫控制器;
}

export interface 次数型伤害免疫参数 {
  名称?: string;
  单位: any;
  免疫类型?: 次数型伤害免疫类型 | 次数型伤害免疫类型[];
  免疫次数?: number;
  无限次数?: boolean;
  持续秒?: number;
  永久?: boolean;
  最低伤害?: number;
  最低伤害占最大生命比例?: number;
  修正优先级?: number;
  清理?: 机制清理篮子;
  过滤伤害?: (this: void, context: any) => boolean;
  取门槛判定伤害?: (this: void, context: any) => number;
  on抵挡?: (this: void, event: 次数型伤害免疫事件) => void;
  on次数变化?: (this: void, 单位: any, 剩余次数: number, 原次数: number) => void;
  on结束?: (this: void, 单位: any, 原因: 次数型伤害免疫结束原因) => void;
}

export interface 次数型伤害免疫控制器 {
  readonly 名称: string;
  是否生效(): boolean;
  是否无限次数(): boolean;
  是否永久(): boolean;
  读取剩余次数(): number;
  读取剩余毫秒(): number;
  增加次数(次数?: number): number;
  设置次数(次数: number): number;
  设为无限次数(): void;
  刷新持续时间(持续秒: number): void;
  设为永久(): void;
  取消(原因?: "手动移除" | "清理"): void;
}

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

function 规整次数(this: void, 次数: number): number {
  if (次数 == null || 次数 !== 次数 || 次数 <= 0) return 0;
  return math.floor(次数);
}

function 类型匹配(this: void, 类型: 次数型伤害免疫类型, context: any): boolean {
  if (类型 === "任意伤害") return true;
  if (类型 === "物理伤害") return context.isPhysicalDamage === true;
  if (类型 === "魔法伤害") return context.isMagicDamage === true;
  if (类型 === "真实伤害") return context.isTrueDamage === true;
  if (类型 === "普攻伤害") return context.isNormalAttack === true;
  if (类型 === "纯普攻伤害") return context.isNormalAttack === true && context.isSkillAttack !== true && context.isSkillDamage !== true;
  if (类型 === "远程伤害") return context.isRangedAttack === true;
  if (类型 === "近战伤害") return context.isNormalAttack === true && context.isRangedAttack !== true;
  if (类型 === "技能伤害") return context.isSkillDamage === true || context.isSkillAttack === true;
  if (类型 === "强化伤害") return context.isEnhancedDamage === true;
  if (类型 === "单体技能伤害") return context.isSingleTargetSkillDamage === true;
  if (类型 === "AOE技能伤害") return context.isAoeSkillDamage === true;
  if (类型 === "装备技能伤害") return context.isEquipmentSkillDamage === true;
  if (类型 === "非装备技能伤害") return context.isNonEquipmentSkillDamage === true;
  if (类型 === "金属性伤害") return context.isMetalDamage === true;
  if (类型 === "木属性伤害") return context.isWoodDamage === true;
  if (类型 === "水属性伤害") return context.isWaterDamage === true;
  if (类型 === "火属性伤害") return context.isFireDamage === true;
  if (类型 === "雷属性伤害") return context.isThunderDamage === true;
  if (类型 === "光属性伤害") return context.isLightDamage === true;
  return context.isDarkDamage === true;
}

function 任一类型匹配(this: void, 类型配置: 次数型伤害免疫参数["免疫类型"], context: any): boolean {
  if (类型配置 == null) return true;
  if (typeof 类型配置 === "string") return 类型匹配(类型配置, context);
  for (let i = 0; i < 类型配置.length; i++) {
    if (类型匹配(类型配置[i], context)) return true;
  }
  return false;
}

function 计算最低伤害(this: void, 参数: 次数型伤害免疫参数): number {
  let 门槛 = 参数.最低伤害 ?? 0;
  const 最大生命比例 = 参数.最低伤害占最大生命比例 ?? 0;
  if (最大生命比例 > 0 && 参数.单位 != null && 参数.单位 !== 0) {
    const 比例门槛 = GetUnitStateJapi(参数.单位, UNIT_STATE_MAX_LIFE) * 最大生命比例;
    if (比例门槛 > 门槛) 门槛 = 比例门槛;
  }
  return 门槛;
}

class 次数型伤害免疫实现 implements 次数型伤害免疫控制器 {
  readonly 名称: string;
  private 参数: 次数型伤害免疫参数;
  private 修正器ID = 0;
  private 到期回调ID = 0;
  private 到期时间Ms = 0;
  private 剩余次数 = 0;
  private 无限 = false;
  private 永久生效 = false;
  private 已结束 = false;
  private 正在处理伤害 = false;

  constructor(参数: 次数型伤害免疫参数) {
    this.参数 = 参数;
    this.名称 = 参数.名称 ?? "次数型伤害免疫";
    this.无限 = 参数.无限次数 === true;
    this.剩余次数 = 规整次数(参数.免疫次数 ?? 1);
    this.永久生效 = 参数.永久 === true || !(参数.持续秒 != null && 参数.持续秒 > 0);

    const self = this;
    this.修正器ID = registerDamageModifier(function 次数型伤害免疫修正(this: void, context: any): number {
      return self.处理伤害(context);
    }, 参数.修正优先级 ?? 140);

    if (!this.永久生效) this.刷新持续时间(参数.持续秒 ?? 0);
    if (!this.无限 && this.剩余次数 <= 0) this.结束("次数耗尽");
  }

  是否生效(): boolean {
    return !this.已结束;
  }

  是否无限次数(): boolean {
    return this.无限;
  }

  是否永久(): boolean {
    return this.永久生效;
  }

  读取剩余次数(): number {
    return this.无限 ? -1 : this.剩余次数;
  }

  读取剩余毫秒(): number {
    if (this.已结束) return 0;
    if (this.永久生效) return -1;
    const 剩余 = this.到期时间Ms - getServerTime();
    return 剩余 > 0 ? 剩余 : 0;
  }

  增加次数(次数: number = 1): number {
    if (this.已结束 || this.无限) return this.读取剩余次数();
    return this.设置次数(this.剩余次数 + 规整次数(次数));
  }

  设置次数(次数: number): number {
    if (this.已结束) return 0;
    const 原次数 = this.读取剩余次数();
    this.无限 = false;
    this.剩余次数 = 规整次数(次数);
    if (this.参数.on次数变化 != null && 原次数 !== this.剩余次数) {
      this.参数.on次数变化(this.参数.单位, this.剩余次数, 原次数);
    }
    if (this.剩余次数 <= 0) this.结束("次数耗尽");
    return this.剩余次数;
  }

  设为无限次数(): void {
    if (this.已结束 || this.无限) return;
    const 原次数 = this.剩余次数;
    this.无限 = true;
    if (this.参数.on次数变化 != null) this.参数.on次数变化(this.参数.单位, -1, 原次数);
  }

  刷新持续时间(持续秒: number): void {
    if (this.已结束 || !(持续秒 > 0)) return;
    this.清除到期回调();
    this.永久生效 = false;
    this.到期时间Ms = getServerTime() + 持续秒 * 1000;
    const self = this;
    this.到期回调ID = addDelayedCallback(持续秒 * 1000, function 次数型伤害免疫到期(this: void): void {
      self.到期回调ID = 0;
      self.到期时间Ms = 0;
      self.结束("到期");
    });
  }

  设为永久(): void {
    if (this.已结束) return;
    this.清除到期回调();
    this.永久生效 = true;
  }

  取消(原因: "手动移除" | "清理" = "手动移除"): void {
    this.结束(原因);
  }

  private 处理伤害(context: any): number {
    const current = context.currentDamage;
    if (this.已结束 || context.target !== this.参数.单位 || !(current > 0)) return current;
    if (!任一类型匹配(this.参数.免疫类型, context)) return current;
    if (this.参数.过滤伤害 != null && !this.参数.过滤伤害(context)) return current;

    const 判定伤害 = this.参数.取门槛判定伤害 == null ? current : this.参数.取门槛判定伤害(context);
    if (!(判定伤害 >= 计算最低伤害(this.参数))) return current;

    this.正在处理伤害 = true;
    let 次数耗尽 = false;
    if (!this.无限) {
      const 原次数 = this.剩余次数;
      this.剩余次数 = 规整次数(this.剩余次数 - 1);
      次数耗尽 = this.剩余次数 <= 0;
      if (this.参数.on次数变化 != null && 原次数 !== this.剩余次数) {
        this.参数.on次数变化(this.参数.单位, this.剩余次数, 原次数);
      }
    }
    const event: 次数型伤害免疫事件 = {
      单位: this.参数.单位,
      攻击者: context.attacker,
      被免疫伤害: current,
      剩余次数: this.读取剩余次数(),
      上下文: context,
      控制器: this,
    };
    if (this.参数.on抵挡 != null) this.参数.on抵挡(event);
    if (次数耗尽) this.结束("次数耗尽");
    this.正在处理伤害 = false;
    return 0;
  }

  private 结束(原因: 次数型伤害免疫结束原因): void {
    if (this.已结束) return;
    this.已结束 = true;
    this.清除到期回调();
    if (this.正在处理伤害) {
      const self = this;
      addDelayedCallback(0, function 次数型伤害免疫延迟注销(this: void): void {
        self.注销修正器();
      });
    } else {
      this.注销修正器();
    }
    if (this.参数.on结束 != null) this.参数.on结束(this.参数.单位, 原因);
  }

  private 清除到期回调(): void {
    if (this.到期回调ID !== 0) {
      removeDelayedCallback(this.到期回调ID);
      this.到期回调ID = 0;
    }
    this.到期时间Ms = 0;
  }

  private 注销修正器(): void {
    if (this.修正器ID === 0) return;
    unregisterDamageModifier(this.修正器ID);
    this.修正器ID = 0;
  }
}

export function 创建次数型伤害免疫(this: void, 参数: 次数型伤害免疫参数): 次数型伤害免疫控制器 {
  const 控制器 = new 次数型伤害免疫实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(`${控制器.名称}-清理`, function 次数型伤害免疫清理(this: void): void {
      控制器.取消("清理");
    });
  }
  return 控制器;
}
