/** @noSelfInFile */

import type { BuffData } from '../../../01．Buff表';

export const 教派剑士BuffID = {
  黑洞奔袭: 'BMS1',
  黑洞强化普攻: 'BMS2',
  深渊旋风: 'BMS3',
  魔祭吸魂: 'BMS4',
} as const;

export const 教派剑士Buff表: Record<string, BuffData> = {
  [教派剑士BuffID.黑洞奔袭]: { buffID: 教派剑士BuffID.黑洞奔袭, buffName: '黑洞奔袭', icon: 'BuffIcon\\Boss\\MaskedSwordsman\\black_hole_dash.blp', effect: '', type: 'Buff:state', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: true, dispelLevel: 3, priority: 85, canPurge: false, tooltip: '教派剑士正在奔向黑洞，期间获得闪避并降低韧性。不可驱散。' },
  [教派剑士BuffID.黑洞强化普攻]: { buffID: 教派剑士BuffID.黑洞强化普攻, buffName: '黑洞强化普攻', icon: 'BuffIcon\\Boss\\MaskedSwordsman\\black_hole_empowered_strike.blp', effect: '', type: 'Buff:attack', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: true, dispelLevel: 3, priority: 90, canPurge: false, tooltip: '下一次普通攻击附带暗属性伤害与伤害吸血，命中后消耗。不可驱散。' },
  [教派剑士BuffID.深渊旋风]: { buffID: 教派剑士BuffID.深渊旋风, buffName: '深渊旋风', icon: 'BuffIcon\\Boss\\MaskedSwordsman\\abyssal_cyclone.blp', effect: '', type: 'Buff:channel', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: true, dispelLevel: 3, priority: 85, canPurge: false, tooltip: '教派剑士正在施放深渊旋风并处于魔法免疫状态，可被打断。不可驱散。' },
  [教派剑士BuffID.魔祭吸魂]: { buffID: 教派剑士BuffID.魔祭吸魂, buffName: '魔祭吸魂', icon: 'BuffIcon\\Boss\\MaskedSwordsman\\soul_sacrifice.blp', effect: '', type: 'Buff:damage', interval: 0, maxStack: 1, stackRule: 'highest', stackRefresh: true, dispelLevel: 3, priority: 90, canPurge: false, tooltip: '教派剑士正在进行魔祭吸魂，短时间提高伤害并准备吸收全体生命。不可驱散。' },
};

export default 教派剑士Buff表;
