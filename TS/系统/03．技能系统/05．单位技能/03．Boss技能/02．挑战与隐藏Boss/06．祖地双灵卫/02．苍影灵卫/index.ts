export * from './00．状态';
export * from './01．灵印折步';
export * from './02．月纹缚魂';
export * from './03．失名祷潮';
export * from './04．记忆剥落';

import { 灵印折步技能状态 } from './01．灵印折步';
import { 月纹缚魂技能状态 } from './02．月纹缚魂';
import { 失名祷潮技能状态 } from './03．失名祷潮';
import { 记忆剥落技能状态 } from './04．记忆剥落';

export const 苍影灵卫技能状态 = {
  已注册: false,
  正常形态: [灵印折步技能状态, 月纹缚魂技能状态],
  变异形态: [失名祷潮技能状态, 记忆剥落技能状态],
} as const;
