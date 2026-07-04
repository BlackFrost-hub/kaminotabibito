/** @noSelfInFile */

import { 取范围敌人, 造成装备伤害, 播放单位特效, 取攻击力, 第二章后段Boss战利品装备名, 装备伤害类型 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";

function on电鳗共生指环触发(this: void, event: any): void {
  const target = event.目标;
  const attacker = event.攻击者;
  const enemies = 取范围敌人(attacker, target, 420);
  let count = 0;
  for (let i = 0; i < enemies.length && count < 3; i++) {
    播放单位特效("Abilities\\Weapons\\Bolt\\BoltImpact.mdl", enemies[i], "origin", 0.6);
    造成装备伤害(attacker, enemies[i], 取攻击力(attacker) * 0.35, 装备伤害类型.闪电);
    count++;
  }
}

注册最终伤害触发模板({
  名称: "电鳗共生指环",
  装备名: 第二章后段Boss战利品装备名.电鳗共生指环,
  伤害过滤: "技能",
  冷却秒数: 8,
  冷却前缀: "第二章后段Boss战利品",
  要求双方存活: false,
  on触发: on电鳗共生指环触发,
});

export {};
