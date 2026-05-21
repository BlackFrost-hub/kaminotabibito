/** @noSelfInFile */
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围友军, 取单位X, 取单位Y, 临时调整攻击 } from "../05．物品使用/00．公共/02．物品使用工具";
const 回退队列 = [];
function 回退精灵号角加成() {
    const item = 回退队列.shift();
    if (item == null)
        return;
    临时调整攻击(item.单位, -item.攻击);
}
export function 处理精灵号角使用(ctx) {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.精灵号角))
        return;
    const cfg = 物品使用数值配置.号角;
    const unit = ctx.施法单位;
    const count = 获取范围友军(unit, 取单位X(unit), 取单位Y(unit), cfg.半径).length;
    if (count <= 0)
        return;
    const attack = cfg.精灵号角每单位攻击 * count;
    临时调整攻击(unit, attack);
    回退队列.push({ 单位: unit, 攻击: attack });
    addDelayedCallback(cfg.持续毫秒, 回退精灵号角加成);
}
