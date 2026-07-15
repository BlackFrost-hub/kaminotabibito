/** @noSelfInFile */

import type { BuffData } from '../../../01．Buff表';

export const 安兹乌尔恭BuffID = {
  生命庇护: 'BAZ1',
} as const;

export const 安兹乌尔恭Buff表: Record<string, BuffData> = {
  [安兹乌尔恭BuffID.生命庇护]: {
    buffID: 安兹乌尔恭BuffID.生命庇护,
    buffName: '生命庇护',
    icon: 'ReplaceableTextures\\CommandButtons\\BTNResurrection.blp',
    effect: '',
    type: 'Buff:mechanic:protection',
    interval: 0,
    maxStack: 1,
    stackRule: 'highest',
    stackRefresh: true,
    dispelLevel: 3,
    priority: 95,
    canPurge: false,
    tooltip: '三座生命锚点已经响应英魂誓约，本次女妖哭嚎不会造成致命伤害。',
  },
};

export default 安兹乌尔恭Buff表;
