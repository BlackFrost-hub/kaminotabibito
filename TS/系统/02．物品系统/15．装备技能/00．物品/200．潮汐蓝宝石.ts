/** @noSelfInFile */
// 祖地秘境·环境互动掉落：潮汐蓝宝石（主动·活水回蓝，复用无目标壳 IN14，独立冷却间隔组）
// 活水回蓝：立即恢复25%最大魔法值，并在5秒内魔法恢复提高100%；冷却25秒。
// 实现选型：通用物品技能槽 + 装备冷却显示 + 施加临时属性效果（玩家属性"魔法恢复%"）。
// 魔法值操作遵守 JASS/JAPI 边界：当前魔法经 JASS SetUnitState 写入，最大魔法经 JAPI GetUnitStateJapi 读取。

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果";
import {
    取装备冷却键,
    装备冷却中,
    进入装备冷却并显示,
    播放单位特效,
    祖地秘境战利品装备名,
} from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;

const 蓝宝石回蓝特效 = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl";

export function 处理潮汐蓝宝石使用(this: void, ctx: 物品技能事件上下文): void {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.潮汐蓝宝石)) return;
    const unit = ctx.施法单位;
    const cfg = 物品使用数值配置.潮汐蓝宝石;
    const 冷却键 = 取装备冷却键(unit, 祖地秘境战利品装备名.潮汐蓝宝石, "物品使用");
    if (装备冷却中(冷却键)) return;
    进入装备冷却并显示(冷却键, cfg.冷却秒, unit, 祖地秘境战利品装备名.潮汐蓝宝石);

    const 最大魔法 = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA);
    const 当前魔法 = GetUnitState(unit, jass.UNIT_STATE_MANA);
    SetUnitState(unit, jass.UNIT_STATE_MANA, 当前魔法 + 最大魔法 * cfg.魔法百分比);
    施加临时属性效果(unit, cfg.恢复持续毫秒, [
        { 类型: "玩家属性", 属性名: "魔法恢复%", 数值: cfg.恢复提升 },
    ]);
    播放单位特效(蓝宝石回蓝特效, unit, "origin", 1.2, 0.9);
}

export {};
