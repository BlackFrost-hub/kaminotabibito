/** @noSelfInFile */

import type { BuffData } from '../../01．Buff表';
import { 主线BossBuff表 } from './01．主线Boss/index';
import { 挑战与隐藏BossBuff表 } from './02．挑战与隐藏Boss/index';
import { 异界BossBuff表 } from './03．异界Boss/index';

export * from './01．主线Boss/index';
export * from './02．挑战与隐藏Boss/index';
export * from './03．异界Boss/index';

export const BossBuff表: Record<string, BuffData> = {
  ...主线BossBuff表,
  ...挑战与隐藏BossBuff表,
  ...异界BossBuff表,
};

export default BossBuff表;
