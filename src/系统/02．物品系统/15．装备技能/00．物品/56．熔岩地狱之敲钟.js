/** @noSelfInFile */
const jass = require("jass.common");
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const GetHeroInt = jass.GetHeroInt;
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围敌人, 取单位X, 取单位Y, 取当前魔法, 取最大魔法, 设置魔法, 施加减速, 造成火焰伤害, 施加眩晕 } from "../05．物品使用/00．公共/02．物品使用工具";
const 结算队列 = [];
function 结算熔岩地狱之敲钟() {
    const item = 结算队列.shift();
    if (item == null)
        return;
    const damage = GetHeroInt(item.来源, true) * 物品使用数值配置.地狱敲钟.智力伤害倍率;
    for (const target of item.目标列表) {
        造成火焰伤害(item.来源, target, damage);
        施加眩晕(item.来源, target, 物品使用数值配置.地狱敲钟.熔岩眩晕);
    }
}
export function 处理熔岩地狱之敲钟使用(ctx) {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.熔岩地狱之敲钟))
        return;
    const cfg = 物品使用数值配置.地狱敲钟;
    const unit = ctx.施法单位;
    设置魔法(unit, 取当前魔法(unit) - (取最大魔法(unit) * cfg.消耗最大魔法比例 + cfg.消耗固定魔法));
    const targets = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), cfg.半径);
    for (const target of targets) {
        施加减速(unit, target, cfg.熔岩减速, cfg.熔岩延迟毫秒 / 1000);
    }
    结算队列.push({ 来源: unit, 目标列表: targets });
    addDelayedCallback(cfg.熔岩延迟毫秒, 结算熔岩地狱之敲钟);
}
