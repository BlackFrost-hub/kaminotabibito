/** @noSelfInFile */

import { 雅儿贝德技能状态 } from './01．护卫雅儿贝德/index';

export const 安兹守护者模式状态 = {
  已完成设计: true,
  已完成实现: false,
  已注册: false,
  护卫技能: 雅儿贝德技能状态,
  语义: '雅儿贝德作为长期护卫介入，玩家通过压低护卫生命换取安兹减伤下降与阶段大招更易破解。',
} as const;
