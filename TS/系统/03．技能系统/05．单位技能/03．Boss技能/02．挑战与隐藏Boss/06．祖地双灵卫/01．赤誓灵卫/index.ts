export * from './00．状态';
export * from './01．灵印折步';
export * from './02．月纹缚魂';
export * from './03．断誓践踏';
export * from './04．裂魂坠斩';

import { 灵印折步技能状态 } from './01．灵印折步';
import { 月纹缚魂技能状态 } from './02．月纹缚魂';
import { 断誓践踏技能状态 } from './03．断誓践踏';
import { 裂魂坠斩技能状态 } from './04．裂魂坠斩';

export const 赤誓灵卫技能状态 = {
  已注册: true,
  正常形态: [灵印折步技能状态, 月纹缚魂技能状态],
  变异形态: [断誓践踏技能状态, 裂魂坠斩技能状态],
} as const;
