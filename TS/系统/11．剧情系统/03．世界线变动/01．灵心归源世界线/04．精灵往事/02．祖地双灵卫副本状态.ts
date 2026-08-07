/** @noSelfInFile */

export type 祖地双灵卫试炼类型 = "持续伤害" | "单次伤害" | "治疗";

export interface 祖地双灵卫试炼状态 {
  已完成: boolean;
  锁定玩家ID: number;
  开始时间毫秒: number;
  累计数值: number;
  目标单位: any;
  进度UI: any;
}

export interface 祖地双灵卫副本状态类型 {
  已初始化: boolean;
  任务已接受: boolean;
  守门放行广播进行中: boolean;
  守门放行触发英雄: any;
  守门已放行: boolean;
  试炼已创建: boolean;
  试炼全部完成已派发: boolean;
  传送点已创建: boolean;
  传送点特效: any;
  传送点触发器: any;
  传送点区域: any;
  Boss场景已触发: boolean;
  Boss场景触发英雄: any;
  Boss战已启动: boolean;
  Boss击败数: number;
  Boss战已完成: boolean;
  奖励已提交: boolean;
  守门单位: any;
  本思雅单位: any;
  埃德里安单位: any;
  Boss单位列表: any[];
  试炼: Record<祖地双灵卫试炼类型, 祖地双灵卫试炼状态>;
}

function 创建空试炼状态(this: void): 祖地双灵卫试炼状态 {
  return {
    已完成: false,
    锁定玩家ID: -1,
    开始时间毫秒: 0,
    累计数值: 0,
    目标单位: null,
    进度UI: null,
  };
}

export const 祖地双灵卫副本状态: 祖地双灵卫副本状态类型 = {
  已初始化: false,
  任务已接受: false,
  守门放行广播进行中: false,
  守门放行触发英雄: null,
  守门已放行: false,
  试炼已创建: false,
  试炼全部完成已派发: false,
  传送点已创建: false,
  传送点特效: null,
  传送点触发器: null,
  传送点区域: null,
  Boss场景已触发: false,
  Boss场景触发英雄: null,
  Boss战已启动: false,
  Boss击败数: 0,
  Boss战已完成: false,
  奖励已提交: false,
  守门单位: null,
  本思雅单位: null,
  埃德里安单位: null,
  Boss单位列表: [],
  试炼: {
    持续伤害: 创建空试炼状态(),
    单次伤害: 创建空试炼状态(),
    治疗: 创建空试炼状态(),
  },
};

export function 祖地双灵卫试炼是否全部完成(this: void): boolean {
  return 祖地双灵卫副本状态.试炼.持续伤害.已完成
    && 祖地双灵卫副本状态.试炼.单次伤害.已完成
    && 祖地双灵卫副本状态.试炼.治疗.已完成;
}
