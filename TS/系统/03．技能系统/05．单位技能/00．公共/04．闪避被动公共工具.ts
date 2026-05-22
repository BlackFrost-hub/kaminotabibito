/** @noSelfInFile */

const { registerDodgeAppliedFinalDamageListener } = require("系统.04．伤害系统.05．闪避系统.01．闪避核心") as {
  registerDodgeAppliedFinalDamageListener: (this: void, callback: (this: void, record: any, applied: number, snapshot: any) => void) => void;
};
const {
  单位是指定类型,
  读取单位攻击力,
  对单位造成暗影伤害,
  获取范围敌军,
  在坐标播放特效,
} = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  单位是指定类型: (this: void, unit: any, typeId: number) => boolean;
  读取单位攻击力: (this: void, unit: any) => number;
  对单位造成暗影伤害: (this: void, source: any, target: any, amount: number) => void;
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
  在坐标播放特效: (this: void, model: string, x: number, y: number, z: number, size: number, lifeSec: number) => void;
};

export type 指定单位闪避后处理器 = (this: void, record: any, applied: number, snapshot: any) => void;

export function 注册指定单位闪避后监听(this: void, unitTypeId: number, handler: 指定单位闪避后处理器): void {
  function 闪避后监听包装(this: void, record: any, applied: number, snapshot: any): void {
    if (!单位是指定类型(record?.target, unitTypeId)) return;
    handler(record, applied, snapshot);
  }

  registerDodgeAppliedFinalDamageListener(闪避后监听包装);
}

export function 以攻击力倍率造成范围暗影伤害(this: void, source: any, x: number, y: number, radius: number, damageRate: number): void {
  if (source == null || source === 0 || !(radius > 0) || !(damageRate > 0)) return;
  const damage = 读取单位攻击力(source) * damageRate;
  if (!(damage > 0)) return;
  const targets = 获取范围敌军(source, x, y, radius);
  for (let i = 0; i < targets.length; i++) {
    对单位造成暗影伤害(source, targets[i], damage);
  }
}

export function 播放灵力意识体爆点特效(this: void, x: number, y: number): void {
  在坐标播放特效("war3mapImported\\superdarkflash.mdl", x, y, 35, 1.1, 1.1);
  在坐标播放特效("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", x, y, 35, 1.1, 0.1);
}

export function init闪避被动公共工具(this: void): void {
}
