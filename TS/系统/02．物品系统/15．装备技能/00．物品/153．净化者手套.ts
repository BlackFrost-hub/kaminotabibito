/** @noSelfInFile */

import { 净化负面, 临时治疗率, 播放单位特效, 第二章后段Boss战利品装备名, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";
import { registerManualBuff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

function on净化者手套触发(this: void, event: any): void {
  const attacker = event.攻击者;
  let duration = 4;
  let value = 10;
  if (净化负面(attacker)) {
    duration = 6;
    value = 22;
    临时治疗率(attacker, 0.22, duration);
  } else {
    临时治疗率(attacker, 0.10, duration);
  }
  registerManualBuff(attacker, 常规BuffID.净化者手套_净化增幅, duration, value, {
    sourceName: "净化者手套",
    iconOverride: "Equipment\\Icon\\Gloves\\purifier_gloves.blp",
  });
  播放单位特效(装备小特效.护盾闪光, attacker, "origin", 0.8);
}

注册最终伤害触发模板({
  名称: "净化者手套",
  装备名: 第二章后段Boss战利品装备名.净化者手套,
  伤害过滤: "技能",
  概率: 0.22,
  冷却秒数: 8,
  冷却前缀: "第二章后段Boss战利品",
  要求双方存活: false,
  on触发: on净化者手套触发,
});

export {};
