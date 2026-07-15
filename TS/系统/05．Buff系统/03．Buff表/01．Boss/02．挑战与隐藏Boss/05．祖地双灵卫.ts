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
    buffID: 祖地双灵卫BuffID.双灵同誓, buffName: '双灵同誓', icon: 'Boss\\AncestralTwinSpiritGuards\\Icon\\BTNAzureShadeGuard.blp', effect: '', type: 'Buff:mechanic:protection', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: true, dispelLevel: 3, priority: 90, canPurge: false,
    tooltip: '双方生命差过大，低血守卫受到同誓保护，部分伤害由另一名守卫分担。',
  },
  [祖地双灵卫BuffID.双蚀共鸣]: {
    buffID: 祖地双灵卫BuffID.双蚀共鸣, buffName: '双蚀共鸣', icon: 'Boss\\AncestralTwinSpiritGuards\\Icon\\BTNRedOathMutant.blp', effect: '', type: 'Buff:phase:protection', interval: 0, maxStack: 3, stackRule: 'stack', stackRefresh: true, dispelLevel: 3, priority: 95, canPurge: false,
    tooltip: '每层共鸣降低受到的伤害；完成双钥净化会移除一层。',
  },
  [祖地双灵卫BuffID.灵魂崩解]: {
    buffID: 祖地双灵卫BuffID.灵魂崩解, buffName: '灵魂崩解', icon: 'Boss\\AncestralTwinSpiritGuards\\Icon\\BTNAzureShadeMutant.blp', effect: '', type: 'Buff:mechanic:downed', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: false, dispelLevel: 3, priority: 100, canPurge: false,
    tooltip: '暂时停止行动。必须在同步窗口内令另一名守卫也进入崩解，否则将被同伴回灌。',
  },
  [祖地双灵卫BuffID.净化反冲]: {
    buffID: 祖地双灵卫BuffID.净化反冲, buffName: '净化反冲', icon: 'Boss\\AncestralTwinSpiritGuards\\Icon\\BTNRedOathGuard.blp', effect: '', type: 'Debuff:mechanic:vulnerable', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: true, dispelLevel: 3, priority: 85, canPurge: false,
    tooltip: '净化节点反冲使守卫短时间承受额外伤害。',
  },
};

export default 祖地双灵卫Buff表;
