/** @noSelfInFile */
// 祖地秘境·环境互动掉落：守灵人指环（主动·守灵守护，复用单位目标壳 IU14，独立冷却间隔组）
// 守灵守护：为一名友方目标施加持有者智力×3的护盾，持续5秒；冷却20秒，施法距离700码。
// 实现选型：通用物品技能槽 + 装备冷却显示 + 开始通用护盾（黑翼守护重盾同型）。

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品 } from "../05．物品使用/00．公共/02．物品使用工具";
import {
    取装备冷却键,
    装备冷却中,
    进入装备冷却并显示,
    单位存活,
    是敌对单位,
    开始通用护盾,
    播放单位特效,
    装备小特效,
    祖地秘境战利品装备名,
} from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
const jass = require("jass.common") as any;

const GetHeroInt = jass.GetHeroInt as (unit: any, includeBonuses: boolean) => number;

export function 处理守灵人指环使用(this: void, ctx: 物品技能事件上下文): void {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.守灵人指环)) return;
    const caster = ctx.施法单位;
    const target = ctx.目标单位;
    // 目标允许 ground,air,friend,self,nonsapper；这里再兜底校验存活与友方。
    if (target == null || target === 0 || !单位存活(target)) return;
    if (target !== caster && 是敌对单位(caster, target)) return;
    const cfg = 物品使用数值配置.守灵人指环;
    const 冷却键 = 取装备冷却键(caster, 祖地秘境战利品装备名.守灵人指环, "物品使用");
    if (装备冷却中(冷却键)) return;
    进入装备冷却并显示(冷却键, cfg.冷却秒, caster, 祖地秘境战利品装备名.守灵人指环);

    开始通用护盾(caster, target, GetHeroInt(caster, true) * cfg.智力倍率, cfg.持续秒, "守灵守护");
    播放单位特效(装备小特效.护盾闪光, target, "origin", 2, 0.6);
}

export {};
