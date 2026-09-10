/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 常规BuffID } from "../00．Buff登记";

export const 灼热食用Buff表: Record<string, BuffData> = {
  [常规BuffID.灼热食用]: {
    buffID: 常规BuffID.灼热食用,
    buffName: "灼热",
    icon: "BuffIcon\\Equipment\\scorching-buff-64.blp",
    effect: "",
    type: "Buff:equipment:attribute",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 0,
    priority: 5,
    canPurge: false,
    tooltip: "品尝了烤熔岩灵鱼，在time秒内火属性伤害提高data%。",
  },
};

export default 灼热食用Buff表;
