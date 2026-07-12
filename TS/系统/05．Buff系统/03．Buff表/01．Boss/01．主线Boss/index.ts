/** @noSelfInFile */

import type { BuffData } from '../../../01．Buff表';
import { 瑟兰迪尔Buff表 } from './01．瑟兰迪尔';
import { 巴尔扎罗斯Buff表 } from './02．巴尔扎罗斯';
import { 菲尼克斯尔Buff表 } from './03．菲尼克斯尔';
import { 树魔首领Buff表 } from './04．树魔首领';
import { 菲利斯Buff表 } from './05．菲利斯';
import { 里科特Buff表 } from './06．里科特';
import { 亚伦柯斯Buff表 } from './07．亚伦柯斯';

export * from './01．瑟兰迪尔';
export * from './02．巴尔扎罗斯';
export * from './03．菲尼克斯尔';
export * from './04．树魔首领';
export * from './05．菲利斯';
export * from './06．里科特';
export * from './07．亚伦柯斯';

export const 主线BossBuff表: Record<string, BuffData> = {
  ...瑟兰迪尔Buff表,
  ...巴尔扎罗斯Buff表,
  ...菲尼克斯尔Buff表,
  ...树魔首领Buff表,
  ...菲利斯Buff表,
  ...里科特Buff表,
  ...亚伦柯斯Buff表,
};
