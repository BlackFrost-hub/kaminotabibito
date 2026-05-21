/** @noSelfInFile */
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 临时调整攻击 } from "../05．物品使用/00．公共/02．物品使用工具";
const 回退队列 = [];
function 回退浴血药剂攻击() {
    const unit = 回退队列.shift();
    if (unit == null || unit === 0)
        return;
    临时调整攻击(unit, -物品使用数值配置.浴血药剂.攻击增加);
}
export function 处理浴血药剂使用(ctx) {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.浴血药剂))
        return;
    const unit = ctx.施法单位;
    临时调整攻击(unit, 物品使用数值配置.浴血药剂.攻击增加);
    回退队列.push(unit);
    addDelayedCallback(物品使用数值配置.浴血药剂.持续毫秒, 回退浴血药剂攻击);
}
