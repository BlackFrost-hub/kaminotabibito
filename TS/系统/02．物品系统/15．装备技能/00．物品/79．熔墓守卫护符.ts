/** @noSelfInFile */

import { 熔墓守卫护符配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { 单位所在点是荒芜, 取最大生命, 执行治疗 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  单位所在点是荒芜: (this: void, unit: any) => boolean;
  取最大生命: (this: void, unit: any) => number;
  执行治疗: (this: void, source: any, target: any, heal: number, mana?: number) => void;
};

function on熔墓守卫护符周期(this: void, unit: any, currentCount: number): void {
  if (!单位所在点是荒芜(unit)) return;
  执行治疗(unit, unit, 取最大生命(unit) * 熔墓守卫护符配置.荒芜恢复最大生命比例 * currentCount, 0);
}

function 初始化熔墓守卫护符(this: void): void {
  if (获得物品装备ID.熔墓守卫护符 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.熔墓守卫护符,
    间隔毫秒: 熔墓守卫护符配置.间隔毫秒,
    周期回调: on熔墓守卫护符周期,
  });
}

初始化熔墓守卫护符();

export {};
