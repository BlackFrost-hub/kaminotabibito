/** @noSelfInFile */

import type { 攻击效果上下文 } from "../08．攻击效果/00．公共/00．攻击效果类型";
import { 注册攻击效果配置 } from "../08．攻击效果/00．公共/02．攻击效果注册表";
import { 取单位对单位冷却键, 装备冷却就绪, 进入装备冷却 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, source: any, target: any, type: string, params: any) => number;
};

function 执行执法者徽记沉默(this: void, ctx: 攻击效果上下文): void {
  const key = 取单位对单位冷却键(ctx.source, ctx.target, "执法者徽记");
  if (!装备冷却就绪(key)) return;
  进入装备冷却(key, 8);
  施加扩展控制(ctx.source, ctx.target, "silence", { 持续时间: 2 });
}

注册攻击效果配置({
  装备名: "执法者徽记",
  触发侧: "攻击者",
  效果类型: "额外伤害",
  仅普通攻击: true,
  概率: 0.1,
  自定义执行: 执行执法者徽记沉默,
});

export {};
