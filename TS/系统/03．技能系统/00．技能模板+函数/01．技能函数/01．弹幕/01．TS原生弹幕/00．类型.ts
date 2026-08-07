/** @noSelfInFile */
/**
 * TS 原生弹幕 - 类型定义
 *
 * 设计目标：同时支持单位物理载体与无单位壳的纯特效载体。
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
import type { 英雄技能距离修正上下文 } from "../../../04．机制组件/11．技能属性修正";

export type 原生弹幕影响目标 = "敌方" | "友方" | "全部";
export type 原生弹幕轨迹类型 = "直线" | "追踪";
export type 原生弹幕载体模式 = "单位" | "特效";
export type 原生弹幕结束原因 = "完成" | "命中消失" | "距离结束" | "生命周期结束" | "单位死亡" | "被阻挡" | "手动销毁";

export type 原生弹幕目标筛选 = (this: void, 目标单位: any, 弹幕ID: number) => boolean;
export type 原生弹幕命中回调 = (this: void, 目标单位: any, 弹幕ID: number) => void;
export type 原生弹幕结束回调 = (this: void, 原因: 原生弹幕结束原因, 弹幕ID: number) => void;
export type 原生弹幕到达目标点回调 = (this: void, 弹幕ID: number, 原因: "完成" | "距离结束") => void;
export type 原生弹幕Tick回调 = (this: void, 实例: 原生弹幕内部实例, delta: number) => void;
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

export interface 原生弹幕附加特效参数 {
  模型: string;
  附着点?: string;
  /** 始终跟随弹幕单位的坐标、高度和朝向；开启后，未单独设置的缩放继承主弹幕缩放。 */
  跟随主弹幕参数?: boolean;
  /** 根据每 Tick 的水平位移与 Z 高度差自动设置 Pitch；仅独立附加特效支持。 */
  跟随轨迹俯仰?: boolean;
  /** 只修正模型视觉朝向，不改变弹幕的移动方向。 */
  朝向角偏移?: number;
  /** 创建后立即设置一次特效动画序号；不在移动 Tick 中重复播放。 */
  动画索引?: number;
  /** 创建后立即播放一次指定动画名称；不在移动 Tick 中重复播放。 */
  动画名称?: string;
  动画链接?: string;
  /** 创建时传给特效实例的动画播放速度。 */
  动画速度?: number;
  缩放?: number;
  /** 允许表现模型使用非均匀缩放；未填写的轴回退到统一缩放。 */
  缩放X?: number;
  缩放Y?: number;
  缩放Z?: number;
  红?: number;
  绿?: number;
  蓝?: number;
  透明度?: number;
}

export interface 原生弹幕参数 {
  所有者: any;
  /** 默认“单位”；“特效”模式不创建单位壳，仍支持轨迹、命中、伤害和回调。 */
  载体模式?: 原生弹幕载体模式;
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
  英雄技能距离修正?: 英雄技能距离修正上下文;
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
  可攻击摧毁?: boolean;
  /** 兼容旧字段；新代码优先使用“可攻击摧毁”。 */
  可被攻击摧毁?: boolean;
  /** 兼容短名，推荐后续优先用“可被攻击摧毁”。 */
  可被摧毁?: boolean;

  弹射?: boolean;
  弹射角度?: number;
  随机弹射?: boolean;
  弹射次数上限?: number;
  弹射衰减?: number;

  模型?: string;
  /** 附加特效槽位最多两个；贝塞尔等自定义轨迹同样复用这组参数。 */
  附加特效1?: 原生弹幕附加特效参数;
  附加特效2?: 原生弹幕附加特效参数;
  /** 兼容旧接口：等价于占用附加特效1。 */
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
  /** 每个原生弹幕驱动 Tick 在移动后触发一次；适合残影、轨迹采样等表现扩展。 */
  onTick?: 原生弹幕Tick回调;
  on阻挡?: 原生弹幕阻挡回调;
  /** 弹幕单位被外部击杀时触发，可拿到击杀者；随后仍会统一触发 on结束("单位死亡", 弹幕ID)。 */
  on被击落?: 原生弹幕被击落回调;
  STES?: 原生弹幕STES配置;
}

export interface 原生弹幕实例 {
  readonly 弹幕ID: number;
  /** 纯特效模式下为 null。 */
  readonly 弹幕单位: any;
  readonly 弹幕特效1: any;
  readonly 弹幕特效2: any;
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
  当前Z: number;
  当前方向角: number;
  当前速度: number;
  当前伤害值: number;
  已飞行距离: number;
  已运行时间: number;
  剩余生命: number;
  弹射次数: number;
  已结束: boolean;
  附加特效1?: any;
  附加特效2?: any;
  命中规则状态: any;
}
