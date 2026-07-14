export * from './00．状态';
export * from './01．誓锋壁进';
export * from './02．盾刃裁决';
export * from './03．失名祷潮';
export * from './04．记忆剥落';

import { 誓锋壁进技能状态 } from './01．誓锋壁进';
import { 盾刃裁决技能状态 } from './02．盾刃裁决';
import { 失名祷潮技能状态 } from './03．失名祷潮';
import { 记忆剥落技能状态 } from './04．记忆剥落';

export const 苍影灵卫技能状态 = {
  已注册: false,
  正常形态: [誓锋壁进技能状态, 盾刃裁决技能状态],
  变异形态: [失名祷潮技能状态, 记忆剥落技能状态],
} as const;
