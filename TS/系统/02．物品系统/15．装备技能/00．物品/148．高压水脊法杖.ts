/** @noSelfInFile */

import { 是元素伤害, 造成装备伤害, 播放单位特效, 取攻击力, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";

function 高压水脊法杖过滤(this: void, event: any): boolean {
  return 是元素伤害(event.伤害快照, 装备伤害类型.水);
}

function on高压水脊法杖触发(this: void, event: any): void {
  const target = event.目标;
  const attacker = event.攻击者;
  播放单位特效(装备小特效.湿痕, target, "origin", 1);
  造成装备伤害(attacker, target, 取攻击力(attacker) * 0.6, 装备伤害类型.水);
}

注册最终伤害触发模板({
  名称: "高压水脊法杖",
  装备名: 第二章后段Boss战利品装备名.高压水脊法杖,
  伤害过滤: "技能",
  冷却秒数: 9,
  冷却前缀: "第二章后段Boss战利品",
  要求双方存活: false,
  自定义过滤: 高压水脊法杖过滤,
  on触发: on高压水脊法杖触发,
});

export {};
