/** @noSelfInFile */

import type { BuffData } from '../../../01．Buff表';

export const 安兹乌尔恭BuffID = {
  生命庇护: 'BAZ1',
} as const;

export const 安兹乌尔恭Buff表: Record<string, BuffData> = {
  [安兹乌尔恭BuffID.生命庇护]: {
    buffID: 安兹乌尔恭BuffID.生命庇护,
    buffName: '生命庇护',
    icon: 'BuffIcon\\Boss\\AinzOoalGown\\life_shelter.blp',
    effect: 'Common\\Effect\\Form\\Aura\\AinzLifeShelterStatus.mdx',
    effectMode: 'attach',
    effectAttachPoint: 'overhead',
    effectScale: 0.28,
    type: 'Buff:mechanic:protection',
    interval: 0,
    maxStack: 1,
    stackRule: 'highest',
    stackRefresh: true,
    dispelLevel: 3,
    priority: 95,
    canPurge: false,
    tooltip: '三座生命锚全部激活后获得，免受本轮“女妖哭嚎”的致命伤害。',
  },
};

export default 安兹乌尔恭Buff表;
