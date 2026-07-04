/** @noSelfInFile */

import { 临时受到治疗率, 开始通用护盾, 取范围友方, 取最大生命, 取当前生命, 第二章后段Boss战利品装备名 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制";
import { registerManualBuff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

function on攻城号令圣印触发(this: void, event: any): void {
  const attacker = event.攻击者;
  const allies = 取范围友方(attacker, 650);
  for (let i = 0; i < allies.length; i++) {
    const unit = allies[i];
    临时受到治疗率(unit, 0.16, 6);
    registerManualBuff(unit, 常规BuffID.攻城号令圣印_攻城号令, 6, 16, {
      sourceName: "攻城号令圣印",
      iconOverride: "Equipment\\Icon\\Item\\siege_command_signet.blp",
    });
    if (取当前生命(unit) < 取最大生命(unit) * 0.5) 开始通用护盾(attacker, unit, 850, 5, "攻城号令圣印");
  }
}

注册最终伤害触发模板({
  名称: "攻城号令圣印",
  装备名: 第二章后段Boss战利品装备名.攻城号令圣印,
  伤害过滤: "技能",
  冷却秒数: 12,
  冷却前缀: "第二章后段Boss战利品",
  要求双方存活: false,
  on触发: on攻城号令圣印触发,
});

export {};
