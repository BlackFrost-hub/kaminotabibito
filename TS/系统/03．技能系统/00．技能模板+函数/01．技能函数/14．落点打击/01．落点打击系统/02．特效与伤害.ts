/** @noSelfInFile */
/**
 * 落点打击系统 - 提示特效、命中特效、伤害结算
 */

import {
  AddSpecialEffect, DestroyEffect,
  UnitDamageTarget,
  type 落点打击内部实例,
  默认落雷特效, 默认攻击类型, 默认伤害类型, 默认武器类型,
  单位是否受影响,
} from "./00．共享";

const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { 单位是否还能命中, 记录单位命中 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则") as {
  单位是否还能命中: (this: void, 状态: any, 单位: any) => boolean;
  记录单位命中: (this: void, 状态: any, 单位: any) => boolean;
};

export function 创建落点提示特效(参数: any, 落点: { X: number; Y: number; 触发延迟: number }): void {
  if (参数.提示圈 === false || 参数.提示特效启用 === false) {
    return;
  }

  const 提示半径 = 参数.提示半径 ?? 参数.伤害半径;
  if (提示半径 <= 0 || 落点.触发延迟 <= 0) {
    return;
  }

  const 自定义提示圈 = 参数.提示圈 != null ? 参数.提示圈 : {};
  创建技能提示圈({
    ...自定义提示圈,
    类型: 自定义提示圈.类型 ?? "渐变圆形",
    X: 自定义提示圈.X ?? 落点.X,
    Y: 自定义提示圈.Y ?? 落点.Y,
    半径: 自定义提示圈.半径 ?? 提示半径,
    持续时间: 自定义提示圈.持续时间 ?? 落点.触发延迟,
    动画速度: 自定义提示圈.动画速度 ?? 参数.提示特效动画速度,
    来源单位: 自定义提示圈.来源单位 ?? 参数.所有者,
  });
}

function 创建落点命中特效(参数: any, X: number, Y: number): void {
  const 模型路径 = 参数.落点特效模型 ?? 默认落雷特效;
  const 特效 = AddSpecialEffect(模型路径, X, Y);
  if (特效 != null && 特效 !== 0) {
    DestroyEffect(特效);
  }
}

export function 结算单次落点伤害(实例: 落点打击内部实例, 落点序号: number): void {
  const 落点 = 实例.落点列表[落点序号];
  if (落点 == null) {
    return;
  }

  创建落点命中特效(实例.参数, 落点.X, 落点.Y);
  实例.参数.on单次生效?.(落点.X, 落点.Y, 落点序号 + 1, 实例.id);

  const 伤害值 = 实例.参数.伤害值 ?? 0;
  if (伤害值 > 0 && 实例.参数.伤害半径 > 0) {
    const 单位列表 = getUnitsInRange(落点.X, 落点.Y, 实例.参数.伤害半径);
    for (const 单位 of 单位列表) {
      if (!单位是否受影响(单位, 实例.参数)) {
        continue;
      }
      if (!单位是否还能命中(实例.命中规则状态, 单位)) {
        continue;
      }

      UnitDamageTarget(
        实例.参数.所有者 ?? 单位,
        单位,
        伤害值,
        false,
        false,
        实例.参数.攻击类型 ?? 默认攻击类型,
        实例.参数.伤害类型 ?? 默认伤害类型,
        实例.参数.武器类型 ?? 默认武器类型
      );
      记录单位命中(实例.命中规则状态, 单位);
      实例.参数.on单次命中?.(单位, 落点序号 + 1, 实例.id);
    }
  }
}
