/** @noSelfInFile */

import { 造成装备伤害, 取攻击力, 第二章后段Boss战利品装备名, 装备伤害类型 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";

function on荆棘行者披风触发(this: void, event: any): void {
  const target = event.目标;
  const attacker = event.攻击者;
  造成装备伤害(target, attacker, 取攻击力(target) * 0.25, 装备伤害类型.自然);
}

注册最终伤害触发模板({
  名称: "荆棘行者披风",
  装备名: 第二章后段Boss战利品装备名.荆棘行者披风,
  持有者: "受击者",
  伤害过滤: "纯普攻",
  要求双方存活: false,
  on触发: on荆棘行者披风触发,
});

export {};
