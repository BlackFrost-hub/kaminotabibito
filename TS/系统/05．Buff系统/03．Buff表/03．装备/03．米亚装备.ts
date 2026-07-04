/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 常规BuffID } from "../00．Buff登记";

export const 米亚装备Buff表: Record<string, BuffData> = {
  [常规BuffID.灵猫步伐之靴_灵猫跃步]: {
    buffID: 常规BuffID.灵猫步伐之靴_灵猫跃步,
    buffName: "灵猫跃步",
    icon: "Equipment\\Icon\\Shoes\\spirit_cat_steps_boots.blp",
    effect: "",
    type: "Buff:equipment:attribute",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 0,
    priority: 5,
    canPurge: false,
    tooltip: "受到了「灵猫跃步」，在time秒内移动速度提高data%。",
  },
};

export default 米亚装备Buff表;
