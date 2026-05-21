/** @noSelfInFile */

import type { 攻击效果上下文 } from "../08．攻击效果/00．公共/00．攻击效果类型";
import { 注册攻击效果配置 } from "../08．攻击效果/00．公共/02．攻击效果注册表";
import { 施加攻击效果眩晕 } from "../08．攻击效果/00．公共/01．攻击效果工具";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const { 施加单体护甲降低Buff } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.04．护甲降低") as {
  施加单体护甲降低Buff: (this: void, source: any, target: any, params: { 持续时间: number; 护甲: number; 叠加键?: string }) => boolean;
};

const 沙之猎弓目标冷却: Record<string, number> = {};
const 取服务器时间 = require("系统.00．核心系统.05．中心计时器") as { getServerTime: (this: void) => number };

const getServerTime = 取服务器时间.getServerTime;

function 执行沙之猎弓(this: void, 上下文: 攻击效果上下文): void {
  const sourceId = GetHandleId(上下文.source);
  const targetId = GetHandleId(上下文.target);
  const key = String(sourceId) + ":" + String(targetId);
  const now = getServerTime();
  const last = 沙之猎弓目标冷却[key];
  if (last != null && now - last < 6000) return;
  沙之猎弓目标冷却[key] = now;

  施加单体护甲降低Buff(上下文.source, 上下文.target, {
    持续时间: 6,
    护甲: 15,
    叠加键: "沙之猎弓",
  });
  施加攻击效果眩晕(上下文.source, 上下文.target, 1);
}

注册攻击效果配置({
  装备名: "沙之猎弓",
  触发侧: "攻击者",
  效果类型: "护甲削减",
  仅普通攻击: true,
  最小距离: 500,
  自定义执行: 执行沙之猎弓,
});

export {};
