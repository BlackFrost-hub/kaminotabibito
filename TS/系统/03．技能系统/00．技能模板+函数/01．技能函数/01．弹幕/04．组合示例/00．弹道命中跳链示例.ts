/** @noSelfInFile */
/**
 * 弹幕组合示例：弹道命中后触发弹道跳链。
 *
 * 这是模板级示例，不自动注册聊天测试，避免加载即产生业务副作用。
 */

import { 创建原生弹幕 } from "../01．TS原生弹幕/index";
import { 开始弹道跳链 } from "../02．弹道跳链/index";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (this: void, u: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, u: any) => number;

export interface 弹道命中跳链示例参数 {
  施法者: any;
  初始目标: any;
  弹幕速度?: number;
  主弹伤害?: number;
  跳链伤害?: number;
  跳链次数?: number;
  跳链搜索半径?: number;
  弹幕单位类型?: number;
  附着特效模型?: string;
}

export function 发射弹道命中跳链示例(this: void, 参数: 弹道命中跳链示例参数): void {
  if (参数.施法者 == null || 参数.施法者 === 0) return;
  if (参数.初始目标 == null || 参数.初始目标 === 0) return;

  创建原生弹幕({
    所有者: 参数.施法者,
    X: GetUnitX(参数.施法者),
    Y: GetUnitY(参数.施法者),
    方向角: GetUnitFacing(参数.施法者),
    弹幕单位类型: 参数.弹幕单位类型,
    附着特效模型: 参数.附着特效模型,
    速度: 参数.弹幕速度 ?? 700,
    轨迹类型: "追踪",
    指定目标: 参数.初始目标,
    命中半径: 80,
    伤害值: 参数.主弹伤害 ?? 100,
    碰撞消失: true,
    生命周期: 4,
    目标筛选: function 主弹目标筛选(this: void, 单位: any): boolean {
      return 单位 === 参数.初始目标;
    },
    on命中: function 主弹命中后跳链(this: void, 目标单位: any): void {
      开始弹道跳链({
        施法者: 参数.施法者,
        初始目标: 目标单位,
        跳跃次数: 参数.跳链次数 ?? 3,
        搜索半径: 参数.跳链搜索半径 ?? 500,
        弹幕速度: 参数.弹幕速度 ?? 700,
        命中半径: 80,
        伤害值: 参数.跳链伤害 ?? 60,
        每跳伤害系数: 0.8,
        每单位只命中一次: true,
        弹幕单位类型: 参数.弹幕单位类型,
        附着特效模型: 参数.附着特效模型,
      });
    },
  });
}
