/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 常规BuffID } from "../00．Buff登记";

export const 使者系列装备Buff表: Record<string, BuffData> = {
  [常规BuffID.使者魔炉_致盲]: {
    buffID: 常规BuffID.使者魔炉_致盲,
    buffName: "致盲",
    icon: "ReplaceableTextures\\CommandButtons\\BTN000230.blp",
    effect: "",
    type: "Debuff:equipment:attribute",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 1,
    priority: 5,
    canPurge: true,
    tooltip: "受到了「使者魔炉」的致盲影响，在time秒内命中率降低data%。",
  },
};

export default 使者系列装备Buff表;
