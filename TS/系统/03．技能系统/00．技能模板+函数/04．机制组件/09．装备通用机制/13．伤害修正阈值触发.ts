/** @noSelfInFile */

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const {
  单位持有装备,
  取装备冷却键,
  装备冷却就绪,
  进入装备冷却并显示,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却") as {
  单位持有装备: (this: void, unit: any, 装备名: string) => boolean;
  取装备冷却键: (this: void, unit: any, tag: string, 前缀?: string) => string;
  装备冷却就绪: (this: void, key: string) => boolean;
  进入装备冷却并显示: (this: void, key: string, 秒数: number, unit: any, 装备名: string) => void;
};
const { 取最大生命 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.09．装备战斗判断") as {
  取最大生命: (this: void, unit: any) => number;
};

export type 伤害修正阈值持有者 = "受击者" | "攻击者";

export interface 伤害修正阈值事件 {
  单位: any;
  受击者: any;
  攻击者: any;
  当前伤害: number;
  阈值: number;
  上下文: any;
  配置: 伤害修正阈值参数;
}

export interface 伤害修正阈值参数 {
  名称?: string;
  装备名: string;
  持有者?: 伤害修正阈值持有者;
  固定阈值?: number;
  最大生命比例阈值?: number;
  冷却秒数?: number;
  冷却标签?: string;
  冷却前缀?: string;
  伤害倍率?: number;
  优先级?: number;
  过滤伤害?: (this: void, event: 伤害修正阈值事件) => boolean;
  on触发?: (this: void, event: 伤害修正阈值事件) => void;
  计算伤害?: (this: void, event: 伤害修正阈值事件) => number;
}

export interface 伤害修正阈值控制器 {
  readonly 名称: string;
  停止(): void;
}

class 伤害修正阈值实现 implements 伤害修正阈值控制器 {
  readonly 名称: string;
  private readonly 配置: 伤害修正阈值参数;
  private readonly 修正ID: number;
  private 已停止 = false;

  constructor(配置: 伤害修正阈值参数) {
    this.名称 = 配置.名称 ?? 配置.装备名;
    this.配置 = 配置;
    const self = this;
    this.修正ID = registerDamageModifier(function 伤害修正阈值回调(this: void, context: any): number {
      return self.修正(context);
    }, 配置.优先级 ?? 30);
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    unregisterDamageModifier(this.修正ID);
  }

  private 修正(context: any): number {
    const current = context.currentDamage;
    if (this.已停止 || !(current > 0)) return current;
    const holder = this.取持有者(context);
    if (holder == null || holder === 0) return current;
    if (!单位持有装备(holder, this.配置.装备名)) return current;
    const threshold = this.计算阈值(holder);
    if (threshold > 0 && current < threshold) return current;

    const event: 伤害修正阈值事件 = {
      单位: holder,
      受击者: context.target,
      攻击者: context.attacker,
      当前伤害: current,
      阈值: threshold,
      上下文: context,
      配置: this.配置,
    };
    if (this.配置.过滤伤害 != null && !this.配置.过滤伤害(event)) return current;
    if (!this.冷却通过并记录(holder)) return current;
    if (this.配置.on触发 != null) this.配置.on触发(event);
    if (this.配置.计算伤害 != null) return this.配置.计算伤害(event);
    return current * (this.配置.伤害倍率 ?? 1);
  }

  private 取持有者(context: any): any {
    return (this.配置.持有者 ?? "受击者") === "攻击者" ? context.attacker : context.target;
  }

  private 计算阈值(unit: any): number {
    let threshold = this.配置.固定阈值 ?? 0;
    const ratio = this.配置.最大生命比例阈值 ?? 0;
    if (ratio > 0) {
      const hpThreshold = 取最大生命(unit) * ratio;
      if (threshold <= 0 || hpThreshold < threshold) threshold = hpThreshold;
    }
    return threshold;
  }

  private 冷却通过并记录(unit: any): boolean {
    const cd = this.配置.冷却秒数 ?? 0;
    if (!(cd > 0)) return true;
    const tag = this.配置.冷却标签 ?? this.配置.名称 ?? this.配置.装备名;
    const key = 取装备冷却键(unit, tag, this.配置.冷却前缀 ?? "装备伤害修正阈值");
    if (!装备冷却就绪(key)) return false;
    进入装备冷却并显示(key, cd, unit, this.配置.装备名);
    return true;
  }
}

export function 创建伤害修正阈值触发(this: void, 配置: 伤害修正阈值参数): 伤害修正阈值控制器 {
  return new 伤害修正阈值实现(配置);
}

export {};
