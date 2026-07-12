/** @noSelfInFile */

import type { BuffData } from '../../../01．Buff表';
import { 米亚Buff表 } from './01．米亚';
import { 卡瑟拉Buff表 } from './02．卡瑟拉';
import { 莫尔特斯Buff表 } from './03．莫尔特斯';
import { 影骨莫特斯Buff表 } from './04．影骨莫特斯';
import { 祖地双灵卫Buff表 } from './05．祖地双灵卫';

export * from './01．米亚';
export * from './02．卡瑟拉';
export * from './03．莫尔特斯';
export * from './04．影骨莫特斯';
export * from './05．祖地双灵卫';

export const 挑战与隐藏BossBuff表: Record<string, BuffData> = {
  ...米亚Buff表,
  ...卡瑟拉Buff表,
  ...莫尔特斯Buff表,
  ...影骨莫特斯Buff表,
  ...祖地双灵卫Buff表,
};
