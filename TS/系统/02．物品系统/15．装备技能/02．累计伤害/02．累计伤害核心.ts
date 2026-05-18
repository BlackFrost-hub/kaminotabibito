/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 处理回沙之书累计 } = require("系统.02．物品系统.15．装备技能.00．物品.01．回沙之书") as {
  处理回沙之书累计: (this: void, target: any, attacker: any, applied: number) => void;
};
const { 处理女妖头饰累计 } = require("系统.02．物品系统.15．装备技能.00．物品.02．女妖头饰") as {
  处理女妖头饰累计: (this: void, target: any, attacker: any, applied: number) => void;
};

let 已初始化 = false;

function onAppliedFinalDamage(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  debugLogForce("累计伤害核心", "收到最终伤害", "target:", target, "attacker:", attacker, "applied:", applied, "isTrueDamage:", snapshot?.isTrueDamage);
  debugLogForce("累计伤害核心", "前置判断", "applied>0:", applied > 0, "isTrueDamage:", snapshot?.isTrueDamage);
  if (!(applied > 0)) {
    debugLogForce("累计伤害核心", "applied=", applied, "不大于0，跳过");
    return;
  }
  if (snapshot != null && snapshot.isTrueDamage === true) {
    debugLogForce("累计伤害核心", "真实伤害，跳过");
    return;
  }
  debugLogForce("累计伤害核心", "准备调用回沙之书累计");
  处理回沙之书累计(target, attacker, applied);
  debugLogForce("累计伤害核心", "回沙之书累计调用完成");
  debugLogForce("累计伤害核心", "准备调用女妖头饰累计");
  处理女妖头饰累计(target, attacker, applied);
  debugLogForce("累计伤害核心", "女妖头饰累计调用完成");
}

export function init累计伤害(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  debugLogForce("累计伤害核心", "已初始化并注册最终伤害监听");
  registerAppliedFinalDamageListener(onAppliedFinalDamage);
}

init累计伤害();

export {};
