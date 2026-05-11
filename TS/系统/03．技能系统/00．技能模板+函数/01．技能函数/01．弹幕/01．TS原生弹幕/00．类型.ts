/**
 * TS 原生弹幕 - 类型定义
 *
 * 设计目标：单位作为弹幕物理载体，特效只做表现。
 */

export type 原生弹幕影响目标 = "敌方" | "友方" | "全部";
export type 原生弹幕轨迹类型 = "直线" | "追踪";
export type 原生弹幕结束原因 = "完成" | "命中消失" | "距离结束" | "生命周期结束" | "单位死亡" | "被阻挡" | "手动销毁";

export type 原生弹幕目标筛选 = (this: void, 目标单位: any, 弹幕ID: number) => boolean;
export type 原生弹幕命中回调 = (this: void, 目标单位: any, 弹幕ID: number) => void;
export type 原生弹幕结束回调 = (this: void, 原因: 原生弹幕结束原因, 弹幕ID: number) => void;
export type 原生弹幕阻挡回调 = (this: void, 来源单位: any, 伤害值: number, 弹幕ID: number) => void;

export interface 原生弹幕STES配置 {
  命中事件名?: string;
  结束事件名?: string;
  阻挡事件名?: string;
}

export interface 原生弹幕参数 {
  所有者: any;
  弹幕单位?: any;
  弹幕单位类型?: number;
  X?: number;
  Y?: number;
  方向角?: number;
  速度: number;

  轨迹类型?: 原生弹幕轨迹类型;
  指定目标?: any;
  追踪转向速度?: number;

  最大距离?: number;
  生命周期?: number;
  命中半径?: number;
  影响目标?: 原生弹幕影响目标;
  碰撞消失?: boolean;
  每单位最大命中次数?: number;
  最大总命中次数?: number;

  伤害值?: number;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;

  弹幕生命值?: number;
  被阻挡时销毁?: boolean;

  弹射?: boolean;
  弹射角度?: number;
  随机弹射?: boolean;
  弹射次数上限?: number;
  弹射衰减?: number;

  模型?: string;
  附着特效模型?: string;
  附着点?: string;
  缩放?: number;
  飞行高度?: number;
  禁用碰撞?: boolean;
  死亡时移除单位?: boolean;

  目标筛选?: 原生弹幕目标筛选;
  on命中?: 原生弹幕命中回调;
  on结束?: 原生弹幕结束回调;
  on阻挡?: 原生弹幕阻挡回调;
  STES?: 原生弹幕STES配置;
}

export interface 原生弹幕实例 {
  readonly 弹幕ID: number;
  readonly 弹幕单位: any;
  获取剩余生命(): number;
  造成阻挡伤害(伤害值: number, 来源单位?: any): boolean;
  销毁(原因?: 原生弹幕结束原因): void;
}

export interface 原生弹幕内部实例 {
  id: number;
  参数: 原生弹幕参数;
  弹幕单位: any;
  当前X: number;
  当前Y: number;
  当前方向角: number;
  已飞行距离: number;
  已运行时间: number;
  剩余生命: number;
  弹射次数: number;
  已结束: boolean;
  附着特效?: any;
  命中规则状态: any;
}

