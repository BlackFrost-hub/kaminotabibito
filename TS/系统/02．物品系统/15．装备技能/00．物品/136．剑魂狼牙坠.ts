/** @noSelfInFile */

import { 造成装备伤害, 恢复生命魔法, 播放点特效, 取单位X, 取单位Y, 取攻击力, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";

function on剑魂狼牙坠触发(this: void, event: any): void {
  const target = event.目标;
  const attacker = event.攻击者;
  播放点特效(装备小特效.小风爆, 取单位X(target), 取单位Y(target), 0.8);
  造成装备伤害(attacker, target, 取攻击力(attacker) * 0.35, 装备伤害类型.风);
  恢复生命魔法(attacker, attacker, 0, 80, true);
}

注册最终伤害触发模板({
  名称: "剑魂狼牙坠",
  装备名: 第二章后段Boss战利品装备名.剑魂狼牙坠,
  伤害过滤: "技能",
  概率: 0.15,
  要求双方存活: false,
  on触发: on剑魂狼牙坠触发,
});

export {};
