/** @noSelfInFile */

import type { 雅儿贝德运行状态 } from './01．护卫雅儿贝德/00．状态';

export type 安兹挑战模式 = '至尊的试炼' | '守护者介入';
export type 安兹阶段 = '未启动' | 'P1至尊的审视' | 'P2死亡支配者' | 'P3死亡是众生的终点' | '挑战收束' | '已结束';

/** 导入本模块不会创建单位、事件、计时器或挑战媒介。 */
export interface 安兹运行时上下文 {
  安兹单位?: any;
  雅儿贝德?: 雅儿贝德运行状态;
  模式: 安兹挑战模式;
  阶段: 安兹阶段;
  当前大型技能?: string;
  时间停止中: boolean;
  天空坠落已释放: boolean;
  一切生命的终点已释放: boolean;
  挑战已结束: boolean;
  已初始化: boolean;
}

export function 创建安兹运行时上下文(this: void, 模式: 安兹挑战模式): 安兹运行时上下文 {
  return {
    模式,
    阶段: '未启动',
    时间停止中: false,
    天空坠落已释放: false,
    一切生命的终点已释放: false,
    挑战已结束: false,
    已初始化: false,
  };
}
