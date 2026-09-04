/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

/**
 * 伊蕾娜 - 英雄 Buff 表（执行计划 A1/A9 登记）
 *
 * Rawcode 取 E01D-E01G：英雄 Buff 段 E00D-E01C 已被既有英雄占用，本表为下一段空闲编号。
 * 图标尚未制作 BLP，统一使用魔兽原生占位图标；不得填写 output/imagegen PNG 路径。
 * 登记不等于实现：旅途见闻/魔法弹强化/镜界结界/魔法变式的真实效果分别由
 * 23．伊蕾娜 的 02/04/07 号文件接入伤害、保护与变式消费逻辑。
 */
export const 伊蕾娜BuffID = {
  /** 旅途见闻（自身增益/资源；层数=当前见闻条数，最多 3） */
  旅途见闻: "E01D",
  /** 魔法弹强化（自身短期增益；表示下一次有效普攻将消费一条见闻） */
  魔法弹强化: "E01E",
  /** 镜界结界（自身增益；W 真实保护窗口） */
  镜界结界: "E01F",
  /** 魔法变式（自身增益；D 当前变式待消耗状态） */
  魔法变式: "E01G",
} as const;

export const 伊蕾娜Buff表: Record<string, BuffData> = {
  [伊蕾娜BuffID.旅途见闻]: {
    buffID: 伊蕾娜BuffID.旅途见闻,
    buffName: "旅途见闻",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaLvTuJianWen.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 3,
    stackRule: "stack",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "记录最近的施法见闻（风行/镜界/远行），最多 3 条，每条 12 秒。",
  },
  [伊蕾娜BuffID.魔法弹强化]: {
    buffID: 伊蕾娜BuffID.魔法弹强化,
    buffName: "魔法弹强化",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaMoFaDanQiangHua.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 3,
    stackRule: "stack",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "强化魔法弹（最多 3 条见闻，每条 12 秒）：下一次普攻追加魔法伤害。",
  },
  [伊蕾娜BuffID.镜界结界]: {
    buffID: 伊蕾娜BuffID.镜界结界,
    buffName: "镜界结界",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaJingJieJieJie.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 90,
    canPurge: false,
    tooltip: "镜界护符 4 秒：偏折一次主要攻击；结束时使周围敌人减速 35%、1.5 秒。",
  },
  [伊蕾娜BuffID.魔法变式]: {
    buffID: 伊蕾娜BuffID.魔法变式,
    buffName: "魔法变式",
    icon: "ReplaceableTextures\\CommandButtons\\HeroBuff\\Irena\\BTNIrenaMoFaShuYeMian.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 85,
    canPurge: false,
    tooltip: "已选变式，下一次 Q/W/E/R 采用（保留最多 30 秒）：迅行/镜界/灰烬。",
  },
};

export {};
