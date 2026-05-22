/** @noSelfInFile */

declare const gg_snd_1: any;
declare const gg_snd_2: any;
declare const gg_snd_3: any;
declare const gg_snd_4: any;
declare const gg_snd_5: any;
declare const gg_snd_6: any;
declare const gg_snd_7: any;

declare const gg_snd_kelaode1: any;
declare const gg_snd_kelaode2: any;
declare const gg_snd_kelaode3: any;
declare const gg_snd_kelaode4: any;
declare const gg_snd_kelaode5: any;
declare const gg_snd_kelaode6: any;

declare const gg_snd_YakumoYukariAttack1: any;
declare const gg_snd_YakumoYukariAttack2: any;
declare const gg_snd_YakumoYukariAttack3: any;
declare const gg_snd_YakumoYukariAttack4: any;
declare const gg_snd_YakumoYukariAttack5: any;
declare const gg_snd_YakumoYukariMove1: any;
declare const gg_snd_YakumoYukariMove2: any;
declare const gg_snd_YakumoYukariMove3: any;
declare const gg_snd_YakumoYukariMove4: any;
declare const gg_snd_YakumoYukariWhat1: any;
declare const gg_snd_YakumoYukariWhat2: any;
declare const gg_snd_YakumoYukariWhat3: any;
declare const gg_snd_YakumoYukariWhat4: any;
declare const gg_snd_YakumoYukariWhat5: any;
declare const gg_snd_YakumoYukariWhat6: any;
declare const gg_snd_YakumoYukariWhat7: any;

declare const gg_snd_ReiSenattack1: any;
declare const gg_snd_ReiSenattack2: any;
declare const gg_snd_ReiSenattack3: any;
declare const gg_snd_ReiSenattack4: any;
declare const gg_snd_ReiSenattack5: any;
declare const gg_snd_ReiSenlmove1: any;
declare const gg_snd_ReiSenmove2: any;
declare const gg_snd_ReiSenmove3: any;
declare const gg_snd_ReiSenmove4: any;
declare const gg_snd_ReiSenlwhat1: any;
declare const gg_snd_ReiSenlwhat2: any;
declare const gg_snd_ReiSenwhat3: any;
declare const gg_snd_ReiSenwhat4: any;
declare const gg_snd_ReiSenwhat5: any;
declare const gg_snd_ReiSenwhat6: any;

declare const gg_snd_OebkAttack1: any;
declare const gg_snd_Oebk_Attack2: any;
declare const gg_snd_OebkAttack3: any;
declare const gg_snd_OebkAttack4: any;
declare const gg_snd_OebkAttack5: any;
declare const gg_snd_OebkAttack6: any;
declare const gg_snd_OebkMove1: any;
declare const gg_snd_OebkMove2: any;
declare const gg_snd_OebkMove3: any;
declare const gg_snd_OebkMove4: any;

declare const gg_snd_OflyAttack1: any;
declare const gg_snd_OflyAttack2: any;
declare const gg_snd_OflyAttack3: any;
declare const gg_snd_OflyAttack4: any;
declare const gg_snd_OflyAttack5: any;
declare const gg_snd_OflyAttack6: any;
declare const gg_snd_OFLYMove1: any;
declare const gg_snd_OFLYMove2: any;
declare const gg_snd_OFLYMove3: any;
declare const gg_snd_OFLYMove4: any;

declare const gg_snd_PlmljAttack1: any;
declare const gg_snd_PlmljAttack2: any;
declare const gg_snd_PlmljAttack3: any;
declare const gg_snd_PlmljAttack4: any;
declare const gg_snd_PlmljAttack5: any;
declare const gg_snd_PlmljAttack6: any;
declare const gg_snd_PlmljMove1: any;
declare const gg_snd_PlmljMove2: any;
declare const gg_snd_PlmljMove3: any;
declare const gg_snd_PlmljMove4: any;

declare const gg_snd_SlsAttack1: any;
declare const gg_snd_SlsAttack2: any;
declare const gg_snd_SlsAttack3: any;
declare const gg_snd_SlsAttack4: any;
declare const gg_snd_SlsAttack5: any;
declare const gg_snd_SlsAttack6: any;
declare const gg_snd_SLSMove1: any;
declare const gg_snd_SLSMove2: any;
declare const gg_snd_SLSMove3: any;
declare const gg_snd_SLSMove4: any;

declare const gg_snd_TlsAttack1: any;
declare const gg_snd_TlsAttack2: any;
declare const gg_snd_TlsAttack3: any;
declare const gg_snd_TlsAttack4: any;
declare const gg_snd_TlsAttack5: any;
declare const gg_snd_TlsAttack6: any;
declare const gg_snd_TLSMove1: any;
declare const gg_snd_TLSMove2: any;
declare const gg_snd_TLSMove3: any;
declare const gg_snd_TLSMove4: any;

declare const gg_snd_TlwAttack1: any;
declare const gg_snd_TlwAttack2: any;
declare const gg_snd_TlwAttack3: any;
declare const gg_snd_TlwAttack4: any;
declare const gg_snd_TlwAttack5: any;
declare const gg_snd_TlwAttack6: any;
declare const gg_snd_TlwMove1: any;
declare const gg_snd_TlwMove2: any;
declare const gg_snd_TlwMove3: any;
declare const gg_snd_TlwMove4: any;

export interface 英雄指令音效配置 {
  英雄名: string;
  攻击音效列表: any[];
  移动音效列表: any[];
  选中音效列表: any[];
}

export const 英雄指令音效配置列表: readonly 英雄指令音效配置[] = [
  {
    英雄名: "cloud",
    攻击音效列表: [gg_snd_kelaode3, gg_snd_kelaode6],
    移动音效列表: [],
    选中音效列表: [gg_snd_kelaode1, gg_snd_kelaode2, gg_snd_kelaode4, gg_snd_kelaode5],
  },
  {
    英雄名: "八云紫",
    攻击音效列表: [gg_snd_YakumoYukariAttack1, gg_snd_YakumoYukariAttack2, gg_snd_YakumoYukariAttack3, gg_snd_YakumoYukariAttack4, gg_snd_YakumoYukariAttack5],
    移动音效列表: [gg_snd_YakumoYukariMove1, gg_snd_YakumoYukariMove2, gg_snd_YakumoYukariMove3, gg_snd_YakumoYukariMove4],
    选中音效列表: [gg_snd_YakumoYukariWhat1, gg_snd_YakumoYukariWhat2, gg_snd_YakumoYukariWhat3, gg_snd_YakumoYukariWhat4, gg_snd_YakumoYukariWhat5, gg_snd_YakumoYukariWhat6, gg_snd_YakumoYukariWhat7],
  },
  {
    英雄名: "铃仙",
    攻击音效列表: [gg_snd_ReiSenattack1, gg_snd_ReiSenattack2, gg_snd_ReiSenattack3, gg_snd_ReiSenattack4, gg_snd_ReiSenattack5],
    移动音效列表: [gg_snd_ReiSenlmove1, gg_snd_ReiSenmove2, gg_snd_ReiSenmove3, gg_snd_ReiSenmove4],
    选中音效列表: [gg_snd_ReiSenlwhat1, gg_snd_ReiSenlwhat2, gg_snd_ReiSenwhat3, gg_snd_ReiSenwhat4, gg_snd_ReiSenwhat5, gg_snd_ReiSenwhat6],
  },
  {
    英雄名: "亚瑟王",
    攻击音效列表: [],
    移动音效列表: [gg_snd_1, gg_snd_2, gg_snd_7],
    选中音效列表: [gg_snd_3, gg_snd_4, gg_snd_6, gg_snd_5],
  },
  {
    英雄名: "欧尔贝克",
    攻击音效列表: [gg_snd_OebkAttack1, gg_snd_Oebk_Attack2, gg_snd_OebkAttack3, gg_snd_OebkAttack4, gg_snd_OebkAttack5, gg_snd_OebkAttack6],
    移动音效列表: [gg_snd_OebkMove1, gg_snd_OebkMove2, gg_snd_OebkMove3, gg_snd_OebkMove4],
    选中音效列表: [],
  },
  {
    英雄名: "欧菲莉亚",
    攻击音效列表: [gg_snd_OflyAttack1, gg_snd_OflyAttack2, gg_snd_OflyAttack3, gg_snd_OflyAttack4, gg_snd_OflyAttack5, gg_snd_OflyAttack6],
    移动音效列表: [gg_snd_OFLYMove1, gg_snd_OFLYMove2, gg_snd_OFLYMove3, gg_snd_OFLYMove4],
    选中音效列表: [],
  },
  {
    英雄名: "普里姆萝洁",
    攻击音效列表: [gg_snd_PlmljAttack1, gg_snd_PlmljAttack2, gg_snd_PlmljAttack3, gg_snd_PlmljAttack4, gg_snd_PlmljAttack5, gg_snd_PlmljAttack6],
    移动音效列表: [gg_snd_PlmljMove1, gg_snd_PlmljMove2, gg_snd_PlmljMove3, gg_snd_PlmljMove4],
    选中音效列表: [],
  },
  {
    英雄名: "塞拉斯",
    攻击音效列表: [gg_snd_SlsAttack1, gg_snd_SlsAttack2, gg_snd_SlsAttack3, gg_snd_SlsAttack4, gg_snd_SlsAttack5, gg_snd_SlsAttack6],
    移动音效列表: [gg_snd_SLSMove1, gg_snd_SLSMove2, gg_snd_SLSMove3, gg_snd_SLSMove4],
    选中音效列表: [],
  },
  {
    英雄名: "特蕾莎",
    攻击音效列表: [gg_snd_TlsAttack1, gg_snd_TlsAttack2, gg_snd_TlsAttack3, gg_snd_TlsAttack4, gg_snd_TlsAttack5, gg_snd_TlsAttack6],
    移动音效列表: [gg_snd_TLSMove1, gg_snd_TLSMove2, gg_snd_TLSMove3, gg_snd_TLSMove4],
    选中音效列表: [],
  },
  {
    英雄名: "泰里翁",
    攻击音效列表: [gg_snd_TlwAttack1, gg_snd_TlwAttack2, gg_snd_TlwAttack3, gg_snd_TlwAttack4, gg_snd_TlwAttack5, gg_snd_TlwAttack6],
    移动音效列表: [gg_snd_TlwMove1, gg_snd_TlwMove2, gg_snd_TlwMove3, gg_snd_TlwMove4],
    选中音效列表: [],
  },
] as const;

export const 英雄指令音效攻击冷却 = 10;
export const 英雄指令音效移动冷却 = 16;
export const 英雄指令音效选中冷却 = 25;
export const 英雄指令音效正在冷却 = 2;

export const 英雄指令音效单位字段 = "指令语音";
export const 英雄目标点指令音效单位字段 = "目标点指令语音";
export const 英雄被选择音效单位字段 = "被选择语音";
export const 英雄正在语音单位字段 = "正在语音";
export const 英雄指令音效定时器字段 = "英雄指令音效单位";
export const 英雄指令音效定时器键字段 = "英雄指令音效键";
