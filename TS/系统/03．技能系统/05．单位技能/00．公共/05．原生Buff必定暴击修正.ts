/** @noSelfInFile */

const {
  单位拥有原生Buff,
  转四位ID,
  注册指定单位暴击率修正,
} = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  转四位ID: (this: void, rawIdText: string) => number;
  注册指定单位暴击率修正: (this: void, unitTypeId: number, handler: (this: void, context: any) => number | undefined) => void;
};

const { registerCritRateModifier } = require("系统.04．伤害系统.06．暴击系统.01．暴击核心") as {
  registerCritRateModifier: (this: void, callback: (this: void, context: any) => number) => void;
};

const 强制暴击BuffID = 转四位ID("B00U");

export function 注册目标带原生Buff时必定暴击(this: void, unitTypeId: number, buffId: number): void {
  function 必定暴击修正(this: void, context: any): number {
    if (单位拥有原生Buff(context.target, buffId)) return 1;
    return context.暴击率;
  }

  注册指定单位暴击率修正(unitTypeId, 必定暴击修正);
}

export function 注册攻击者带原生Buff时必定暴击(this: void, buffId: number): void {
  function 必定暴击修正(this: void, context: any): number {
    if (单位拥有原生Buff(context.attacker, buffId)) return 1;
    return context.暴击率;
  }

  registerCritRateModifier(必定暴击修正);
}

export function init原生Buff必定暴击修正(this: void): void {
  注册攻击者带原生Buff时必定暴击(强制暴击BuffID);
}

init原生Buff必定暴击修正();
