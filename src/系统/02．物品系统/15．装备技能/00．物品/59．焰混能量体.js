/** @noSelfInFile */
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 取句柄ID, 临时调整攻速 } from "../05．物品使用/00．公共/02．物品使用工具";
const 剩余普攻次数 = {};
const 激活表 = {};
const 回退队列 = [];
function 清除焰混能量体(unit) {
    const id = 取句柄ID(unit);
    if (id === 0 || 激活表[id] !== true)
        return;
    delete 激活表[id];
    delete 剩余普攻次数[id];
    临时调整攻速(unit, -物品使用数值配置.焰混能量体.攻速);
}
function 焰混能量体到期() {
    const unit = 回退队列.shift();
    if (unit == null || unit === 0)
        return;
    清除焰混能量体(unit);
}
export function 处理焰混能量体使用(ctx) {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.焰混能量体))
        return;
    const unit = ctx.施法单位;
    const id = 取句柄ID(unit);
    if (id === 0)
        return;
    清除焰混能量体(unit);
    激活表[id] = true;
    剩余普攻次数[id] = 物品使用数值配置.焰混能量体.普攻次数;
    临时调整攻速(unit, 物品使用数值配置.焰混能量体.攻速);
    回退队列.push(unit);
    addDelayedCallback(物品使用数值配置.焰混能量体.持续毫秒, 焰混能量体到期);
}
export function 处理焰混能量体伤害(_target, attacker, _applied, snapshot) {
    if (snapshot == null || snapshot.isNormalAttack !== true)
        return;
    const id = 取句柄ID(attacker);
    if (id === 0 || 激活表[id] !== true)
        return;
    const remain = (剩余普攻次数[id] ?? 0) - 1;
    if (remain <= 0) {
        清除焰混能量体(attacker);
    }
    else {
        剩余普攻次数[id] = remain;
    }
}
