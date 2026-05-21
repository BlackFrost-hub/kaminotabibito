/** @noSelfInFile */
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围尸体, 取单位X, 取单位Y, 取最大生命, 取最大魔法, 执行治疗, 单位所在点是荒芜, 播放点特效 } from "../05．物品使用/00．公共/02．物品使用工具";
export function 处理亡灵魔鞋使用(ctx) {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.亡灵魔鞋))
        return;
    const unit = ctx.施法单位;
    const cfg = 物品使用数值配置.亡灵魔鞋;
    const x = 取单位X(unit);
    const y = 取单位Y(unit);
    const corpses = 获取范围尸体(x, y, cfg.半径);
    for (const target of corpses) {
        播放点特效("Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", 取单位X(target), 取单位Y(target));
    }
    const deadCount = corpses.length;
    const heal = 取最大生命(unit) * cfg.每尸体生命比例 * deadCount;
    const mana = 单位所在点是荒芜(unit) ? 取最大魔法(unit) * cfg.荒芜魔法比例 : 0;
    if (heal > 0 || mana > 0)
        执行治疗(unit, unit, heal, mana);
}
