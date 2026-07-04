/** @noSelfInFile */

import { 临时玩家属性, 取范围友方, 第二章后段Boss战利品装备名, 装备小特效, 播放单位特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";
import { registerManualBuff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

function on菲利斯的统御纹章触发(this: void, event: any): void {
  const attacker = event.攻击者;
  const allies = 取范围友方(attacker, 650);
  for (let i = 0; i < allies.length; i++) {
    临时玩家属性(allies[i], "魔法伤害", 0.10, 6);
    registerManualBuff(allies[i], 常规BuffID.菲利斯的统御纹章_统御号令, 6, 10, {
      sourceName: "菲利斯的统御纹章",
      iconOverride: "Equipment\\Icon\\Item\\phyllis_command_emblem.blp",
    });
    播放单位特效(装备小特效.护盾闪光, allies[i], "origin", 0.8);
  }
}

注册最终伤害触发模板({
  名称: "菲利斯的统御纹章",
  装备名: 第二章后段Boss战利品装备名.菲利斯的统御纹章,
  伤害过滤: "技能",
  冷却秒数: 10,
  冷却前缀: "第二章后段Boss战利品",
  要求双方存活: false,
  on触发: on菲利斯的统御纹章触发,
});

export {};
