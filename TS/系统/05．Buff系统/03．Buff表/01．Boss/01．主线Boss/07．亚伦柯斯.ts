/** @noSelfInFile */

import type { BuffData } from '../../../01．Buff表';

export const 亚伦柯斯BuffID = {
  旧誓加护: 'BAK1',
  不灭军魂: 'BAK2',
} as const;

export const 亚伦柯斯Buff表: Record<string, BuffData> = {
  [亚伦柯斯BuffID.旧誓加护]: {
    buffID: 亚伦柯斯BuffID.旧誓加护,
    buffName: '旧誓加护',
    icon: 'BuffIcon\\Boss\\Aronkos\\old_oath_protection.blp',
    effect: '',
    type: 'Buff:phase:protection',
    interval: 0,
    maxStack: 3,
    stackRule: 'highest',
    stackRefresh: true,
    dispelLevel: 3,
    priority: 95,
    canPurge: false,
    tooltip: 'P2期间持续至对应墓碑安魂或阶段结束，最多3层。每座未安魂墓碑提供18%减伤；1层为18%、2层为36%、3层为54%，并使亚伦柯斯生命无法低于最大生命值的35%。不可驱散。',
  },
  [亚伦柯斯BuffID.不灭军魂]: {
    buffID: 亚伦柯斯BuffID.不灭军魂,
    buffName: '不灭军魂',
    icon: 'BuffIcon\\Boss\\Aronkos\\undying_military_soul.blp',
    effect: '',
    type: 'Buff:phase:empower',
    interval: 0,
    maxStack: 1,
    stackRule: 'highest',
    stackRefresh: false,
    dispelLevel: 3,
    priority: 90,
    canPurge: false,
    tooltip: 'P3开启后持续至战斗结束，技能间隔缩短12%。生命值≤10%时触发一次最终强化：按触发瞬间当前攻击力×20%换算为固定攻击力增量（不是基础攻击力或总攻击力百分比），攻速+15%，控制免疫2秒、施法无敌1.2秒；不恢复生命。不可驱散。',
  },
};

export default 亚伦柯斯Buff表;
