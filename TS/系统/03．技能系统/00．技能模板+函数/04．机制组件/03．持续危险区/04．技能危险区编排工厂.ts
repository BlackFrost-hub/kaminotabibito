/** @noSelfInFile */
/**
 * 技能危险区编排工厂（M-04）
 *
 * 组合 持续危险区域 / 线段危险区 / 多波延迟AOE，提供统一配置入口：
 * - 模式：圆形（持续危险区域）、线段（线段危险区）、多波（多波延迟AOE）
 * - 固定点 / 单位锚点 / 路径起点（圆形锚点单位、线段起点坐标）
 * - 预警 / 落点 / 持续 / 周期 / 销毁阶段回调（透传到底层对应回调）
 * - 清理篮子统一收束；技能实例 ID 透传（通过回调变量/上下文，不在工厂内创建重复实例）
 *
 * 禁止：新写几何算法、接管十六夜 RR、在工厂内写具体伤害公式或 Buff 名称。
 * 缺口：独立"地面路径持续区域"模板不存在——路径类行为由线段危险区近似或调用方私有实现，登记。
 */

import { 创建持续危险区域, type 持续危险区域实例 } from "./01．持续危险区域";
import { 创建线段危险区, type 线段危险区实例 } from "./02．线段危险区";
import { 创建多波延迟AOE, type 多波延迟AOE实例, type 多波延迟AOE参数 } from "./03．多波延迟AOE";
import { 创建地面路径持续区域, type 地面路径持续区域实例 } from "../../00．技能模板/03．路径技能模板/00．地面路径持续区域";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

export type 技能危险区编排模式 = "圆形" | "线段" | "路径" | "多波";

export interface 技能危险区编排参数 {
  /** 显式模式 */
  模式: 技能危险区编排模式;
  名称: string;
  所有者?: any;
  /** 圆形：固定点或锚点单位 */
  X?: number;
  Y?: number;
  锚点单位?: any;
  半径?: number;
  /** 线段：起点坐标 + 方向角 + 长度 + 宽度 */
  起点X?: number;
  起点Y?: number;
  方向角?: number;
  长度?: number;
  宽度?: number;
  /** 路径：复用地面路径持续区域模板的分段铺设参数 */
  路径长度?: number;
  路径半径?: number;
  段间距?: number;
  铺设间隔?: number;
  伤害模式?: "分段区域" | "整体矩形";
  周期伤害类型?: any;
  /** 线段：参与单位列表提供者（缺省空列表） */
  单位列表?: (this: void, 变量?: any) => any[];
  /** 持续时长（圆形/线段） */
  持续秒?: number;
  检测间隔?: number;
  影响目标?: "敌方" | "友方" | "全部";
  模型路径?: string;
  特效高度?: number;
  特效缩放?: number;
  显示提示圈?: boolean;
  周期伤害?: number;
  周期伤害去重间隔?: number;
  /** 多波：波次列表（透传 03．多波延迟AOE） */
  波次列表?: any[];
  Tick间隔毫秒?: number;
  /** 清理篮子（多波模式透传） */
  清理?: 机制清理篮子;
  /** 技能实例 ID：透传到回调上下文，工厂不创建重复实例 */
  技能实例ID?: number;
  on进入?: (this: void, 单位: any, 变量?: any) => void;
  on离开?: (this: void, 单位: any, 变量?: any) => void;
  on周期?: (this: void, 单位: any, 变量?: any) => void;
  on落点?: (this: void, 变量?: any) => void;
  on销毁?: (this: void, 变量?: any) => void;
  /** 多波专用语义回调；未提供时兼容使用 on落点/on周期。 */
  on预警?: (this: void, 波次: any, 序号: number) => void;
  on触发?: (this: void, 波次: any, 序号: number) => void;
}

export interface 技能危险区编排实例 {
  /** 销毁/停止危险区 */
  销毁(this: void): void;
  /** 多波模式：停止后续波次 */
  停止(this: void): void;
}

/**
 * 创建技能危险区（编排入口）。
 */
export function 创建技能危险区(this: void, 参数: 技能危险区编排参数): 技能危险区编排实例 | undefined {
  const 变量 = 参数.技能实例ID;

  if (参数.模式 === "圆形") {
    const 区域 = 创建持续危险区域({
      X: 参数.X ?? 0,
      Y: 参数.Y ?? 0,
      锚点单位: 参数.锚点单位,
      半径: 参数.半径 ?? 300,
      持续时间: 参数.持续秒 ?? 3,
      检测间隔: 参数.检测间隔,
      影响目标: 参数.影响目标 ?? "敌方",
      所有者: 参数.所有者,
      清理: 参数.清理,
      模型路径: 参数.模型路径,
      特效高度: 参数.特效高度,
      特效缩放: 参数.特效缩放,
      显示提示圈: 参数.显示提示圈 ?? true,
      周期伤害: 参数.周期伤害,
      周期伤害去重间隔: 参数.周期伤害去重间隔,
      回调上下文ID: 变量,
      on进入: 参数.on进入,
      on离开: 参数.on离开,
      on周期: 参数.on周期,
      on销毁: 参数.on销毁,
    });
    if (区域 == null) return undefined;
    return {
      销毁: function (this: void): void { 区域.销毁(); },
      停止: function (this: void): void { 区域.销毁(); },
    };
  }

  if (参数.模式 === "线段") {
    const 线段 = 创建线段危险区({
      清理: 参数.清理,
      名称: 参数.名称,
      起点X: 参数.起点X ?? 0,
      起点Y: 参数.起点Y ?? 0,
      方向角: 参数.方向角 ?? 0,
      长度: 参数.长度 ?? 500,
      宽度: 参数.宽度 ?? 200,
      持续秒: 参数.持续秒 ?? 3,
      Tick间隔毫秒: 参数.Tick间隔毫秒,
      单位列表: 参数.单位列表 ?? function 线段空单位列表(this: void): any[] { return []; },
      变量,
      提示圈: 参数.显示提示圈 === false ? false : undefined,
      on进入: 参数.on进入,
      on离开: 参数.on离开,
      on周期: 参数.on周期,
      on结束: 参数.on销毁,
    });
    if (线段 == null) return undefined;
    return {
      销毁: function (this: void): void { 线段.停止(); },
      停止: function (this: void): void { 线段.停止(); },
    };
  }

  if (参数.模式 === "路径") {
    const 路径: 地面路径持续区域实例 = 创建地面路径持续区域({
      清理: 参数.清理,
      起点X: 参数.起点X ?? 参数.X ?? 0,
      起点Y: 参数.起点Y ?? 参数.Y ?? 0,
      方向角: 参数.方向角 ?? 0,
      路径长度: 参数.路径长度 ?? 参数.长度 ?? 500,
      路径半径: 参数.路径半径 ?? 参数.宽度 ?? 100,
      段间距: 参数.段间距,
      铺设间隔: 参数.铺设间隔,
      区域持续时间: 参数.持续秒 ?? 3,
      伤害模式: 参数.伤害模式,
      检测间隔: 参数.检测间隔,
      周期伤害: 参数.周期伤害,
      周期伤害类型: 参数.周期伤害类型,
      影响目标: 参数.影响目标,
      所有者: 参数.所有者,
      模型路径: 参数.模型路径,
      特效高度: 参数.特效高度,
      显示提示圈: 参数.显示提示圈,
      on全部铺设完成: function 技能危险区路径铺设完成(this: void, 实例ID: number): void {
        if (参数.on落点 != null) 参数.on落点({ 技能实例ID: 变量, 路径实例ID: 实例ID });
      },
      on销毁: function 技能危险区路径销毁(this: void, 实例ID: number): void {
        if (参数.on销毁 != null) 参数.on销毁({ 技能实例ID: 变量, 路径实例ID: 实例ID });
      },
    });
    return {
      销毁: function (this: void): void { 路径.销毁(); },
      停止: function (this: void): void { 路径.销毁(); },
    };
  }

  if (参数.模式 === "多波") {
    if (参数.波次列表 == null || 参数.波次列表.length <= 0) return undefined;
    const aoe: 多波延迟AOE实例 = 创建多波延迟AOE({
      清理: 参数.清理,
      名称: 参数.名称,
      波次列表: 参数.波次列表,
      Tick间隔毫秒: 参数.Tick间隔毫秒,
       on预警: function (this: void, 波次: any, 序号: number): void {
        if (参数.on预警 != null) 参数.on预警(波次, 序号);
        else if (参数.on落点 != null) 参数.on落点({ 波次, 序号, 技能实例ID: 变量 });
      },
      on触发: function (this: void, 波次: any, 序号: number): void {
        if (参数.on触发 != null) 参数.on触发(波次, 序号);
        else if (参数.on周期 != null) 参数.on周期(波次, { 序号, 技能实例ID: 变量 });
      },
      on结束: function (this: void): void {
        if (参数.on销毁 != null) 参数.on销毁({ 技能实例ID: 变量 });
      },
    });
    if (aoe == null) return undefined;
    return {
      销毁: function (this: void): void { aoe.停止(); },
      停止: function (this: void): void { aoe.停止(); },
    };
  }

  return undefined;
}
