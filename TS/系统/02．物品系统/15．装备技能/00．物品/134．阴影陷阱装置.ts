/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 单位是英雄, 取单位X, 取单位Y, 播放单位特效 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 创建句柄永久标记 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/23．句柄永久标记";

const { onItemPickup } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { 创建主动陷阱, 默认主动陷阱模型 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.02．主动陷阱模板") as {
  创建主动陷阱: (this: void, 参数: any) => any;
  默认主动陷阱模型: string;
};

const jass = require("jass.common") as any;
const GetItemCharges = jass.GetItemCharges as (item: any) => number;
const SetItemCharges = jass.SetItemCharges as (item: any, charges: number) => void;

const 阴影陷阱触发特效 = "Common\\Effect\\Form\\MagicCircle\\ShadowTrapRune.mdx";
const 纠缠根须目标特效 = "Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl";

const 阴影陷阱已初始化次数 = 创建句柄永久标记("阴影陷阱已初始化次数");

function 初始化阴影陷阱次数(this: void, item: any): void {
  if (!阴影陷阱已初始化次数.标记若不存在(item)) return;
  if (GetItemCharges(item) <= 0) SetItemCharges(item, 物品使用数值配置.阴影陷阱装置.最大次数);
}

function on阴影陷阱装置拾取(this: void, unit: any, item: any): void {
  if (!是否为使用物品(item, 物品使用装备ID.阴影陷阱装置)) return;
  初始化阴影陷阱次数(item);
}

function on阴影陷阱触发(this: void, target: any): void {
  播放单位特效(纠缠根须目标特效, target, "origin", 物品使用数值配置.阴影陷阱装置.控制持续秒数);
}

function 阴影陷阱还有次数(this: void, item: any): boolean {
  初始化阴影陷阱次数(item);
  return GetItemCharges(item) > 0;
}

export function 处理阴影陷阱装置使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.阴影陷阱装置)) return;
  const caster = ctx.施法单位;
  if (!单位是英雄(caster)) return;
  if (!阴影陷阱还有次数(ctx.物品)) return;
  const cfg = 物品使用数值配置.阴影陷阱装置;
  const x = ctx.目标X !== 0 ? ctx.目标X : 取单位X(caster);
  const y = ctx.目标Y !== 0 ? ctx.目标Y : 取单位Y(caster);

  const trap = 创建主动陷阱({
    名称: "阴影陷阱装置",
    施法者: caster,
    X: x,
    Y: y,
    持续秒数: cfg.持续秒数,
    触发半径: cfg.触发半径,
    模型路径: 默认主动陷阱模型,
    缩放: cfg.缩放,
    触发后销毁: true,
    只触发敌人: true,
    控制类型: "roots",
    控制持续秒数: cfg.控制持续秒数,
    触发特效路径: 阴影陷阱触发特效,
    on触发: on阴影陷阱触发,
  });
  if (trap == null) return;
}

onItemPickup(on阴影陷阱装置拾取);

export {};
