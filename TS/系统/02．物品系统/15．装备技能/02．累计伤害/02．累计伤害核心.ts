/** @noSelfInFile */

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 处理回沙之书累计 } = require("系统.02．物品系统.15．装备技能.00．物品.01．回沙之书") as {
  处理回沙之书累计: (this: void, target: any, attacker: any, applied: number) => void;
};
const { 处理女妖头饰累计 } = require("系统.02．物品系统.15．装备技能.00．物品.02．女妖头饰") as {
  处理女妖头饰累计: (this: void, target: any, attacker: any, applied: number) => void;
};
import { 装备调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

let 已初始化 = false;

//跳过精神伤害和≤1的伤害
function onAppliedFinalDamage(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied >= 1)) {
    return;
  }
  if (snapshot != null && snapshot.isTrueDamage === true) {
    return;
  }
  处理回沙之书累计(target, attacker, applied);
  处理女妖头饰累计(target, attacker, applied);
}

export function init累计伤害(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  装备调试日志("累计伤害核心", "已初始化并注册最终伤害监听");
  registerAppliedFinalDamageListener(onAppliedFinalDamage);
}

init累计伤害();

export {};
