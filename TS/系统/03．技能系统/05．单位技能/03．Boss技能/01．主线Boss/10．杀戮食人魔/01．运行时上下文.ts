/** @noSelfInFile */

import type { 机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理';
import { 创建单位运行时上下文工厂 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂';

export interface 疼痛复仇增伤层记录 {
  ID: number;
  到期毫秒: number;
}

export interface 杀戮食人魔运行时上下文 {
  Boss单位: any;
  清理: 机制清理篮子;
  增伤累计伤害: number;
  解控累计伤害: number;
  下一增伤层ID: number;
  增伤层列表: 疼痛复仇增伤层记录[];
  心脏掌握冷却结束毫秒: number;
  束缚目标: any;
  束缚闪电: any;
  束缚周期ID: number;
  束缚反伤中: boolean;
  束缚清理已登记: boolean;
}

function 创建杀戮食人魔上下文(this: void, boss: any, 清理: 机制清理篮子): 杀戮食人魔运行时上下文 {
  return {
    Boss单位: boss,
    清理,
    增伤累计伤害: 0,
    解控累计伤害: 0,
    下一增伤层ID: 1,
    增伤层列表: [],
    心脏掌握冷却结束毫秒: 0,
    束缚目标: null,
    束缚闪电: null,
    束缚周期ID: 0,
    束缚反伤中: false,
    束缚清理已登记: false,
  };
}

const 杀戮食人魔上下文工厂 = 创建单位运行时上下文工厂<杀戮食人魔运行时上下文>({
  名称: '杀戮食人魔',
  创建上下文: 创建杀戮食人魔上下文,
  死亡时自动清理: true,
});

export function 获取杀戮食人魔上下文(this: void, boss: any): 杀戮食人魔运行时上下文 | undefined {
  return 杀戮食人魔上下文工厂.获取(boss);
}

export function 获取或创建杀戮食人魔上下文(this: void, boss: any): 杀戮食人魔运行时上下文 | undefined {
  return 杀戮食人魔上下文工厂.获取或创建(boss);
}

export function 获取全部杀戮食人魔上下文(this: void): 杀戮食人魔运行时上下文[] {
  return 杀戮食人魔上下文工厂.获取全部();
}

export function 清理杀戮食人魔上下文(this: void, boss: any): void {
  杀戮食人魔上下文工厂.清理上下文(boss);
}
