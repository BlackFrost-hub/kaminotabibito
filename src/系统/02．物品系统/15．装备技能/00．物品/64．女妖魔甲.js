/** @noSelfInFile */
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 调整玩家属性 } from "../05．物品使用/00．公共/02．物品使用工具";
const 回退队列 = [];
function 回退女妖魔甲魔法伤害() {
    const unit = 回退队列.shift();
    if (unit == null || unit === 0)
        return;
    调整玩家属性(unit, "魔法伤害", -物品使用数值配置.女妖魔甲.魔法伤害提升);
}
export function 处理女妖魔甲使用(ctx) {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.女妖魔甲))
        return;
    const unit = ctx.施法单位;
    调整玩家属性(unit, "魔法伤害", 物品使用数值配置.女妖魔甲.魔法伤害提升);
    回退队列.push(unit);
    addDelayedCallback(物品使用数值配置.女妖魔甲.持续毫秒, 回退女妖魔甲魔法伤害);
}
