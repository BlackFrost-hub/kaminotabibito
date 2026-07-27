/** @noSelfInFile */

import { 注册攻击效果配置 } from "../08．攻击效果/00．公共/02．攻击效果注册表";
import type { 攻击效果上下文 } from "../08．攻击效果/00．公共/00．攻击效果类型";

const { 施加移速提升Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加移速提升Buff: (this: void, source: any, target: any, params: {
    持续时间: number;
    基础移速百分比?: number;
    效果来源名称?: string;
    效果来源类型?: "装备" | "技能";
  }) => boolean;
};

function 触发血浴右腿移速提升(this: void, ctx: 攻击效果上下文): void {
  施加移速提升Buff(ctx.source, ctx.source, {
    持续时间: 3,
    基础移速百分比: 0.1,
    效果来源名称: "血浴之母的第一条右腿",
    效果来源类型: "装备",
  });
}

注册攻击效果配置({
  装备名: "血浴之母的第一条右腿",
  触发侧: "攻击者",
  效果类型: "额外伤害",
  最大距离: 200,
  自定义执行: 触发血浴右腿移速提升,
});

export {};
