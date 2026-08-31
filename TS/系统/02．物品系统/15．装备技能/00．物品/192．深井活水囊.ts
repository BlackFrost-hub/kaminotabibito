/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 取装备冷却键, 装备冷却中, 进入装备冷却并显示 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const { 施加持续恢复生命魔法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.01．持续恢复生命魔法") as {
  施加持续恢复生命魔法: (this: void, 来源单位: any, 目标单位: any, 参数: {
    BuffID: string;
    图标路径: string;
    特效路径: string;
    特效挂点: string;
    特效键: string;
    持续时间: number;
    间隔: number;
    每跳生命恢复: number;
    每跳魔法恢复: number;
    效果来源名称?: string;
    效果来源类型?: "装备" | "技能";
  }) => void;
};

const 深井活水囊ID = 物品使用装备ID.深井活水囊;
const 深井活水囊配置 = 物品使用数值配置.深井活水囊;

export function 处理深井活水囊使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 深井活水囊ID)) return;
  const unit = ctx.施法单位;
  const 冷却键 = 取装备冷却键(unit, "深井活水囊", "物品使用");
  if (装备冷却中(冷却键)) return;
  进入装备冷却并显示(冷却键, 深井活水囊配置.冷却毫秒 / 1000, unit, "深井活水囊");

  施加持续恢复生命魔法(unit, unit, {
    BuffID: "C027",
    图标路径: "ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp",
    特效路径: "Abilities\\Spells\\NightElf\\Rejuvenation\\RejuvenationTarget.mdl",
    特效挂点: "origin",
    特效键: "深井活水囊",
    持续时间: 1,
    间隔: 1,
    每跳生命恢复: GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE) * 深井活水囊配置.生命百分比,
    每跳魔法恢复: GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA) * 深井活水囊配置.魔法百分比,
    效果来源名称: "深井活水囊",
    效果来源类型: "装备",
  });
}

export {};
