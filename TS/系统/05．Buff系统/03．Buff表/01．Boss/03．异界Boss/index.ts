/** @noSelfInFile */

import type { BuffData } from '../../../01．Buff表';
import { 安兹乌尔恭Buff表 } from './01．安兹乌尔恭';
import { 夏提雅Buff表 } from './02．夏提雅';

export * from './01．安兹乌尔恭';
export * from './02．夏提雅';

export const 异界BossBuff表: Record<string, BuffData> = {
  ...安兹乌尔恭Buff表,
  ...夏提雅Buff表,
};
