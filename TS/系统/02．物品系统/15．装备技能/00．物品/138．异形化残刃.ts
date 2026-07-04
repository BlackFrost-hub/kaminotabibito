/** @noSelfInFile */

import { 造成装备伤害, 播放单位特效, 监听装备丢弃清理, 第二章后段Boss战利品装备名, 装备伤害类型 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";
const { 按比例移除当前生命 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除") as {
  按比例移除当前生命: (this: void, target: any, ratio: number, nonlethal?: boolean) => number;
};

const 异形化残刃内置CD秒 = 5;
let 异形化残刃派生伤害中 = false;

function 造成异形化残刃额外伤害(this: void, source: any, target: any, amount: number): void {
  if (!(amount > 0)) return;
  异形化残刃派生伤害中 = true;
  造成装备伤害(source, target, amount, 装备伤害类型.暗影);
  异形化残刃派生伤害中 = false;
}

function 异形化残刃过滤(this: void): boolean {
  return 异形化残刃派生伤害中 !== true;
}

function on异形化残刃触发(this: void, event: any): void {
  const attacker = event.攻击者;
  const target = event.目标;
  按比例移除当前生命(attacker, 0.05, true);
  播放单位特效("Common\\Effect\\Element\\Dark\\ShadowHitBurst.mdx", target, "origin", 0.8);
  造成异形化残刃额外伤害(attacker, target, event.本次伤害 * 0.3);
}

const 异形化残刃触发 = 注册最终伤害触发模板({
  名称: "异形化残刃",
  装备名: 第二章后段Boss战利品装备名.异形化残刃,
  伤害过滤: "技能",
  次数阈值: 5,
  冷却秒数: 异形化残刃内置CD秒,
  冷却前缀: "第二章后段Boss战利品",
  要求双方存活: false,
  自定义过滤: 异形化残刃过滤,
  on触发: on异形化残刃触发,
});

监听装备丢弃清理(第二章后段Boss战利品装备名.异形化残刃, function 清空异形化残刃能量(this: void, unit: any): void {
  异形化残刃触发.清空(unit);
});

export {};
