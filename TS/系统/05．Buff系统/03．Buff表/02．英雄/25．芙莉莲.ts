/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

export const 芙莉莲BuffID = {
  /** 魔力隐匿：静默蓄势完成（下一次 Q/R 强化）；不改变可见性 */
  魔力隐匿: "E020",
  /** 解析中：目标正被芙莉莲解析（内部状态的外显标记） */
  解析中: "E021",
  /** 解析完成：目标已被两种解析记录锁定，可被 Q/R 破防消费 */
  解析完成: "E022",
  /** 演算魔弹：下一次普攻强化窗口 */
  演算魔弹: "E023",
} as const;

export const 芙莉莲Buff表: Record<string, BuffData> = {
  [芙莉莲BuffID.魔力隐匿]: {
    buffID: 芙莉莲BuffID.魔力隐匿,
    buffName: "魔力隐匿",
    icon: "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
    effect: "",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:magic:stealth",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 70,
    canPurge: false,
    tooltip: "魔力压制完成：下一次 Q/R 获得射程与首击强化；施放技能、普攻或受打断后解除。",
  },
  [芙莉莲BuffID.解析中]: {
    buffID: 芙莉莲BuffID.解析中,
    buffName: "解析中",
    icon: "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
    effect: "",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Debuff:magic:mark",
    interval: 0,
    maxStack: 2,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 72,
    canPurge: false,
    tooltip: "正被芙莉莲解析：两种不同解析记录后进入解析完成。",
  },
  [芙莉莲BuffID.解析完成]: {
    buffID: 芙莉莲BuffID.解析完成,
    buffName: "解析完成",
    icon: "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
    effect: "",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Debuff:magic:mark",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 75,
    canPurge: false,
    tooltip: "已被完全解析：下一次被 Q/R 命中时承受破防强化并清除全部解析。",
  },
  [芙莉莲BuffID.演算魔弹]: {
    buffID: 芙莉莲BuffID.演算魔弹,
    buffName: "演算魔弹",
    icon: "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
    effect: "",
    effectMode: "attach",
    effectAttachPoint: "origin",
    effectScale: 1,
    type: "Buff:magic:attack",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 73,
    canPurge: false,
    tooltip: "下一次普攻获得演算强化：命中解析目标追加魔法伤害并减少 Q/W 冷却。",
  },
};
