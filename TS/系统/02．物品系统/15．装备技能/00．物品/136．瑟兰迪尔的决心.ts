/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 瑟兰迪尔的决心物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";

const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};

const jass = require("jass.common") as any;
const GetItemTypeId = jass.GetItemTypeId as (whichItem: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (whichUnit: any) => number;

const 瑟兰迪尔的决心配置 = {
  单位类型: "N057",
  持续时间: 30,
  生命值: 5000,
  攻击力: 350,
  护甲: 35,
  缩放: 1.6,
  透明度: 170,
  红: 180,
  绿: 220,
  蓝: 255,
} as const;

function 是瑟兰迪尔的决心物品(this: void, item: any): boolean {
  return item != null && item !== 0 && 瑟兰迪尔的决心物品ID !== 0 && GetItemTypeId(item) === 瑟兰迪尔的决心物品ID;
}

export function 处理瑟兰迪尔的决心使用(this: void, ctx: 物品技能事件上下文): void {
  const caster = ctx.施法单位;
  if (caster == null || caster === 0) return;
  if (!是瑟兰迪尔的决心物品(ctx.物品)) return;
  创建召唤物({
    主人单位: caster,
    单位类型: 瑟兰迪尔的决心配置.单位类型,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    朝向: GetUnitFacing(caster),
    持续时间: 瑟兰迪尔的决心配置.持续时间,
    生命值: 瑟兰迪尔的决心配置.生命值,
    攻击力: 瑟兰迪尔的决心配置.攻击力,
    护甲: 瑟兰迪尔的决心配置.护甲,
    缩放: 瑟兰迪尔的决心配置.缩放,
    透明度: 瑟兰迪尔的决心配置.透明度,
    红: 瑟兰迪尔的决心配置.红,
    绿: 瑟兰迪尔的决心配置.绿,
    蓝: 瑟兰迪尔的决心配置.蓝,
  });
}

export {};
