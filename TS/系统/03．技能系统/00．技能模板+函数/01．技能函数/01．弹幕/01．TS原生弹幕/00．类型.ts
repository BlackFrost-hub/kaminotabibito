/** @noSelfInFile */
/**
 * TS 原生弹幕 - 类型定义
 *
 * 设计目标：单位作为弹幕物理载体，特效只做表现。
 *
 * 弹幕马甲分类约定：
 * - 古树：蝗虫弹幕单位。
 * - 机械 + 守卫：弹幕或技能弹道。
 * - 牛头人：不可被阻挡的弹幕。
 * - 移除 Aloc：可被攻击摧毁，即有血条的弹幕单位。
 *
 * 默认马甲为古树 + 机械 + 守卫；不可阻挡和是否保留 Aloc 由底层运行时动态处理。
 * 移动时优先使用 SetUnitX/Y，避免蝗虫单位经 SetUnitPosition 后被代码选取。
 */

export type 原生弹幕影响目标 = "敌方" | "友方" | "全部";
export type 原生弹幕轨迹类型 = "直线" | "追踪";
export type 原生弹幕结束原因 = "完成" | "命中消失" | "距离结束" | "生命周期结束" | "单位死亡" | "被阻挡" | "手动销毁";

export type 原生弹幕目标筛选 = (this: void, 目标单位: any, 弹幕ID: number) => boolean;
export type 原生弹幕命中回调 = (this: void, 目标单位: any, 弹幕ID: number) => void;
export type 原生弹幕结束回调 = (this: void, 原因: 原生弹幕结束原因, 弹幕ID: number) => void;
export type 原生弹幕到达目标点回调 = (this: void, 弹幕ID: number, 原因: "完成" | "距离结束") => void;
export type 原生弹幕阻挡回调 = (this: void, 来源单位: any, 伤害值: number, 弹幕ID: number) => void;
export type 原生弹幕被击落回调 = (this: void, 击杀者: any, 弹幕ID: number) => void;
export type 原生弹幕轨迹采样器 = (this: void, 实例: 原生弹幕内部实例, delta: number) => 原生弹幕轨迹采样结果;

export interface 原生弹幕轨迹采样结果 {
  X: number;
  Y: number;
  Z?: number;
  方向角?: number;
  完成?: boolean;
}

export interface 原生弹幕STES配置 {
  命中事件名?: string;
  结束事件名?: string;
  阻挡事件名?: string;
}

export interface 原生弹幕参数 {
  所有者: any;
  所属玩家?: any;
  弹幕单位?: any;
  弹幕单位类型?: number;
  X?: number;
  Y?: number;
  方向角?: number;
  速度: number;
  延迟发射?: number;

  轨迹类型?: 原生弹幕轨迹类型;
  轨迹采样器?: 原生弹幕轨迹采样器;
  指定目标?: any;
  追踪转向速度?: number;
  显式改向后锁定方向?: boolean;

  最大距离?: number;
  生命周期?: number;
  命中半径?: number;
  影响目标?: 原生弹幕影响目标;
  允许命中所有者?: boolean;
  碰撞消失?: boolean;
  每单位最大命中次数?: number;
  最大总命中次数?: number;

  伤害值?: number;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
  来源类型?: "单位技能" | "Boss技能" | "召唤物技能" | "其他";
  技能ID?: number;
  技能实例ID?: number;
  技能标签?: string;
  伤害形态?: "单体" | "AOE" | "未知";
  参与技能伤害加成?: boolean;

  弹幕生命值?: number;
  被阻挡时销毁?: boolean;
  /** true 时动态添加“牛头人”分类，表示弹幕不可被阻挡逻辑摧毁。 */
  不可阻挡?: boolean;
  /** true 时移除蝗虫技能，让弹幕马甲可被普通攻击选中并摧毁。 */
  可被攻击摧毁?: boolean;
  /** 兼容短名，推荐后续优先用“可被攻击摧毁”。 */
  可被摧毁?: boolean;

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
  /** 语义别名：命中单位时触发，和 on命中 同时支持。 */
  on命中单位?: 原生弹幕命中回调;
  on结束?: 原生弹幕结束回调;
  /** 到达轨迹终点或最大距离终点时触发；生命周期结束、手动销毁、被阻挡不触发。 */
  on到达目标点?: 原生弹幕到达目标点回调;
  on阻挡?: 原生弹幕阻挡回调;
  /** 弹幕单位被外部击杀时触发，可拿到击杀者；随后仍会统一触发 on结束("单位死亡", 弹幕ID)。 */
  on被击落?: 原生弹幕被击落回调;
  STES?: 原生弹幕STES配置;
}

export interface 原生弹幕实例 {
  readonly 弹幕ID: number;
  readonly 弹幕单位: any;
  获取剩余生命(this: void): number;
  造成阻挡伤害(this: void, 伤害值: number, 来源单位?: any): boolean;
  销毁(this: void, 原因?: 原生弹幕结束原因): void;
}

export interface 原生弹幕内部实例 {
  id: number;
  参数: 原生弹幕参数;
  弹幕单位: any;
  当前X: number;
  当前Y: number;
  当前方向角: number;
  当前速度: number;
  当前伤害值: number;
  已飞行距离: number;
  已运行时间: number;
  剩余生命: number;
  弹射次数: number;
  已结束: boolean;
  附着特效?: any;
  命中规则状态: any;
}
