/** @noSelfInFile */

import type { BuffData } from '../../../01．Buff表';

export const 祖地双灵卫BuffID = {
  双灵同誓: 'BTG1',
  双蚀共鸣: 'BTG2',
  灵魂崩解: 'BTG3',
  净化反冲: 'BTG4',
} as const;

export const 祖地双灵卫Buff表: Record<string, BuffData> = {
  [祖地双灵卫BuffID.双灵同誓]: {
    buffID: 祖地双灵卫BuffID.双灵同誓, buffName: '双灵同誓', icon: 'BuffIcon\\Boss\\AncestralTwinSpiritGuards\\twin_spirit_oath.blp', effect: '', type: 'Buff:mechanic:protection', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: true, dispelLevel: 3, priority: 90, canPurge: false,
    tooltip: '生命比例差达到15%时生效。低血守卫受到的伤害降低55%；减伤后的伤害再有25%转移给高血守卫。原始伤害100点时，低血守卫承受33.75点，高血守卫承受11.25点。生命比例差降至10%或以下时解除。',
  },
  [祖地双灵卫BuffID.双蚀共鸣]: {
    buffID: 祖地双灵卫BuffID.双蚀共鸣, buffName: '双蚀共鸣', icon: 'BuffIcon\\Boss\\AncestralTwinSpiritGuards\\twin_corruption_resonance.blp', effect: '', type: 'Buff:phase:protection', interval: 0, maxStack: 3, stackRule: 'stack', stackRefresh: true, dispelLevel: 3, priority: 95, canPurge: false,
    tooltip: '最多3层。每层使受到的伤害降低8%：3层时实际承受76%，2层时实际承受84%，1层时实际承受92%，0层时实际承受100%。每完成1次双钥净化移除1层。',
  },
  [祖地双灵卫BuffID.灵魂崩解]: {
    buffID: 祖地双灵卫BuffID.灵魂崩解, buffName: '灵魂崩解', icon: 'BuffIcon\\Boss\\AncestralTwinSpiritGuards\\soul_collapse.blp', effect: 'Common\\Effect\\Form\\Debuff\\SpiritGuardSoulCollapse.mdx', effectMode: 'attach', effectAttachPoint: 'origin', effectScale: 0.28, type: 'Buff:mechanic:downed', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: false, dispelLevel: 3, priority: 100, canPurge: false,
    tooltip: '生命降至最大生命的5%时进入灵魂崩解，暂停行动并锁定在5%生命。常规同步窗口为14秒，全部净化后为18秒；窗口内另一名守卫未降至5%时，当前守卫恢复至最大生命的22%。',
  },
  [祖地双灵卫BuffID.净化反冲]: {
    buffID: 祖地双灵卫BuffID.净化反冲, buffName: '净化反冲', icon: 'BuffIcon\\Boss\\AncestralTwinSpiritGuards\\purification_recoil.blp', effect: 'Common\\Effect\\Form\\Debuff\\SpiritGuardPurificationRecoil.mdx', effectMode: 'attach', effectAttachPoint: 'origin', effectScale: 0.22, effectHeight: 75, type: 'Debuff:mechanic:vulnerable', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: true, dispelLevel: 3, priority: 85, canPurge: false,
    tooltip: '完成净化后持续5秒，受到的伤害提高12%。',
  },
};

export default 祖地双灵卫Buff表;
