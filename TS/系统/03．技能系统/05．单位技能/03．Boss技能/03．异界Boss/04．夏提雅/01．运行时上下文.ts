/** @noSelfInFile */

export type 夏提雅阶段 = '未启动' | 'P1鲜血女武神' | 'P2英灵战乙女' | 'P3真祖血宴' | '复生仪式' | '挑战收束' | '已结束';

export interface 夏提雅运行时上下文 {
  Boss单位?: any;
  阶段: 夏提雅阶段;
  当前猎血目标?: any;
  当前猎血段数: number;
  猎血段数过期时间Ms: number;
  血印句柄列表: any[];
  血宴层数: number;
  英灵战乙女句柄?: any;
  已触发复生: boolean;
  当前大型技能?: string;
  已初始化: boolean;
}

/** 导入本模块不会创建单位、事件、计时器或挑战媒介。 */
export function 创建夏提雅运行时上下文(this: void): 夏提雅运行时上下文 {
  return {
    阶段: '未启动',
    当前猎血段数: 0,
    猎血段数过期时间Ms: 0,
    血印句柄列表: [],
    血宴层数: 0,
    已触发复生: false,
    已初始化: false,
  };
}
