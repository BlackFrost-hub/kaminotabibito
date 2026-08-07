/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 瑟兰迪尔的决心物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 读取单位攻击力 } from "../../../03．技能系统/00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 设置物品CD } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};

const jass = require("jass.common") as any;
const GetItemTypeId = jass.GetItemTypeId as (whichItem: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (whichUnit: any) => number;
const GetUnitName = jass.GetUnitName as (whichUnit: any) => string;

const 瑟兰迪尔的决心配置 = {
  单位类型: "e08P",
  ModelFileID: "war3mapImported\\ArcherGryphonKotSHV1.01.mdl",
  持续时间: 30,
  生命值: 5000,
  攻击力: 350,
  召唤者攻击力继承比例: 0.25,
  atkCd: 2.0,
  range: 600,
  missileModel: "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareMissile.mdl",
  missileSpeed: 900,
  acquireRange: 1200,
  护甲: 35,
  缩放: 1.6,
  透明度: 170,
  红: 180,
  绿: 220,
  蓝: 255,
} as const;

const 瑟兰迪尔的决心主动技能壳ID = "IN00";
const 瑟兰迪尔的决心冷却秒数 = 120;

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
    单位名称: GetUnitName(caster) + "的水元素",
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    朝向: GetUnitFacing(caster),
    ModelFileID: 瑟兰迪尔的决心配置.ModelFileID,
    持续时间: 瑟兰迪尔的决心配置.持续时间,
    生命值: 瑟兰迪尔的决心配置.生命值,
    攻击力: 瑟兰迪尔的决心配置.攻击力 + 读取单位攻击力(caster) * 瑟兰迪尔的决心配置.召唤者攻击力继承比例,
    atkCd: 瑟兰迪尔的决心配置.atkCd,
    range: 瑟兰迪尔的决心配置.range,
    missileModel: 瑟兰迪尔的决心配置.missileModel,
    missileSpeed: 瑟兰迪尔的决心配置.missileSpeed,
    acquireRange: 瑟兰迪尔的决心配置.acquireRange,
    护甲: 瑟兰迪尔的决心配置.护甲,
    缩放: 瑟兰迪尔的决心配置.缩放,
    透明度: 瑟兰迪尔的决心配置.透明度,
    红: 瑟兰迪尔的决心配置.红,
    绿: 瑟兰迪尔的决心配置.绿,
    蓝: 瑟兰迪尔的决心配置.蓝,
  });
  设置物品CD({
    unit: caster,
    item: ctx.物品,
    秒数: 瑟兰迪尔的决心冷却秒数,
    范围: "主动",
    主动技能ID: 瑟兰迪尔的决心主动技能壳ID,
    主动最大冷却秒数: 瑟兰迪尔的决心冷却秒数,
  });
}

export {};
