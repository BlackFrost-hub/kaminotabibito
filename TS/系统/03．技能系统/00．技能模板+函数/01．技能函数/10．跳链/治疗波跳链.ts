/** @noSelfInFile */
/**
 * 治疗波跳链
 *
 * 使用纯跳链系统实现治疗波效果：
 * - 每次跳到下一个友方单位
 * - 使用治疗系统
 * - 到达目标时播放治疗波特效
 * - 每次跳跃间隔0.05秒
 */

const { 开始纯跳链 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.纯跳链系统") as {
  开始纯跳链: (this: void, 参数: any) => any;
};

const { DEFAULT_HEAL_EFFECT_PATH } = require("系统.04．伤害系统.02．治疗系统.00．常量定义") as {
  DEFAULT_HEAL_EFFECT_PATH: string;
};

const 默认治疗波特效 = DEFAULT_HEAL_EFFECT_PATH;
const 默认治疗波闪电代码 = "HWPB";
const 默认每跳最大距离 = 600;
const 默认跳跃间隔 = 0.10;
const 默认最大跳数 = 7;

export interface 治疗波参数 {
  起始目标: any;
  来源单位?: any;
  最大跳数: number;
  初始治疗量: number;
  影响目标?: "敌方" | "友方" | "全部";
  每跳最大距离?: number;
  每跳衰减系数?: number;
  允许重复治疗?: boolean;
  跳跃间隔?: number;
  治疗特效路径?: string;
  闪电效果代码?: string;
  目标筛选?: (this: void, 单位: any, 当前目标: any, 已完成跳数: number) => boolean;
  每跳回调?: (this: void, 单位: any, 治疗量: number, 当前跳数: number) => void;
  结束回调?: (this: void, 已完成的跳数: number) => void;
}

export function 发起治疗波跳链(参数: 治疗波参数): any {
  const 治疗特效 = 参数.治疗特效路径 ?? 默认治疗波特效;

  let 每跳回调Wrapper: ((单位: any, 数值: number, 当前跳数: number, 跳链ID: number) => void) | undefined;
  if (参数.每跳回调 != null) {
    const 每跳回调 = 参数.每跳回调;
    每跳回调Wrapper = (单位: any, 数值: number, 当前跳数: number, 跳链ID: number): void => {
      每跳回调(单位, 数值, 当前跳数);
    };
  }

  let 结束回调Wrapper: ((原因: any, 已完成跳数: number, 跳链ID: number) => void) | undefined;
  if (参数.结束回调 != null) {
    const 结束回调 = 参数.结束回调;
    结束回调Wrapper = (原因: any, 已完成跳数: number, 跳链ID: number): void => {
      结束回调(已完成跳数);
    };
  }

  const 跳链参数: any = {
    起始目标: 参数.起始目标,
    来源单位: 参数.来源单位,
    模式: "治疗",
    影响目标: 参数.影响目标 ?? "友方",
    最大跳数: 参数.最大跳数 ?? 默认最大跳数,
    每跳最大距离: 参数.每跳最大距离 ?? 默认每跳最大距离,
    初始数值: 参数.初始治疗量,
    每跳衰减系数: 参数.每跳衰减系数 ?? 0,
    允许重复命中: 参数.允许重复治疗,
    跳跃间隔: 参数.跳跃间隔 ?? 默认跳跃间隔,
    闪电效果代码: 参数.闪电效果代码 ?? 默认治疗波闪电代码,
    闪电持续时间: undefined,
    治疗特效路径: 治疗特效,
    目标筛选: 参数.目标筛选,
    每跳回调: 每跳回调Wrapper,
    结束回调: 结束回调Wrapper,
  };

  return 开始纯跳链(跳链参数);
}

export {};
