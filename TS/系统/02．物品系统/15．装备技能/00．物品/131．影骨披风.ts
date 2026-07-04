/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 单位是英雄, 播放单位特效 } from "../05．物品使用/00．公共/02．物品使用工具";

const { 施加潜行状态 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.01．潜行状态模板") as {
  施加潜行状态: (this: void, 参数: any) => any;
};

const 影骨潜行烟雾特效 = "Common\\Effect\\Element\\Dark\\ShadowStealthSmoke.mdx";

function on影骨披风潜行开始(this: void, 状态: any): void {
  播放单位特效(影骨潜行烟雾特效, 状态.单位, "origin", 1.2);
}

export function 处理影骨披风使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.影骨披风)) return;
  const unit = ctx.施法单位;
  if (!单位是英雄(unit)) return;
  const cfg = 物品使用数值配置.影骨披风;
  施加潜行状态({
    单位: unit,
    来源单位: unit,
    名称: "影骨披风",
    持续秒数: cfg.持续秒数,
    基础移速百分比: cfg.基础移速百分比,
    破隐伤害倍率: cfg.破隐伤害倍率,
    破隐额外暗属性伤害倍率: cfg.破隐额外暗属性伤害倍率,
    on开始: on影骨披风潜行开始,
  });
}

export {};
