export * from './00．状态';
export * from './01．誓锋壁进';
export * from './02．盾刃裁决';
export * from './03．断誓践踏';
export * from './04．裂魂坠斩';

import { 誓锋壁进技能状态 } from './01．誓锋壁进';
import { 盾刃裁决技能状态 } from './02．盾刃裁决';
import { 断誓践踏技能状态 } from './03．断誓践踏';
import { 裂魂坠斩技能状态 } from './04．裂魂坠斩';

export const 赤誓灵卫技能状态 = {
  已注册: false,
  正常形态: [誓锋壁进技能状态, 盾刃裁决技能状态],
  变异形态: [断誓践踏技能状态, 裂魂坠斩技能状态],
} as const;
