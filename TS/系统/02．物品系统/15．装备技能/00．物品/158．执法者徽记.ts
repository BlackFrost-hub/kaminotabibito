/** @noSelfInFile */

import type { 攻击效果上下文 } from "../08．攻击效果/00．公共/00．攻击效果类型";
import { 注册攻击效果配置 } from "../08．攻击效果/00．公共/02．攻击效果注册表";

const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, source: any, target: any, type: string, params: any) => number;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const 执法者徽记目标冷却: Record<string, number | undefined> = {};

function 取执法者徽记冷却键(this: void, source: any, target: any): string {
  if (source == null || source === 0 || target == null || target === 0) return "";
  return String(GetHandleId(source)) + ":" + String(GetHandleId(target));
}

function 执行执法者徽记沉默(this: void, ctx: 攻击效果上下文): void {
  const key = 取执法者徽记冷却键(ctx.source, ctx.target);
  if (key === "") return;
  const now = getServerTime();
  const last = 执法者徽记目标冷却[key];
  if (last != null && now - last < 8000) return;
  执法者徽记目标冷却[key] = now;
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
