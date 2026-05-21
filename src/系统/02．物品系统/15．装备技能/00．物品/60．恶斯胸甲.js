/** @noSelfInFile */
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 取句柄ID, 取当前生命, 设置生命, 造成火焰伤害 } from "../05．物品使用/00．公共/02．物品使用工具";
const 窗口表 = {};
const 到期队列 = [];
const 后续伤害队列 = [];
function 清除恶斯胸甲窗口() {
    const unit = 到期队列.shift();
    const id = 取句柄ID(unit);
    if (id !== 0)
        delete 窗口表[id];
}
function 执行恶斯胸甲后续伤害() {
    const item = 后续伤害队列.shift();
    if (item == null)
        return;
    造成火焰伤害(item.来源, item.目标, item.伤害);
}
export function 处理恶斯胸甲使用(ctx) {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.恶斯胸甲))
        return;
    const unit = ctx.施法单位;
    const currentLife = 取当前生命(unit);
    let cost = currentLife * 物品使用数值配置.恶斯胸甲.当前生命消耗比例;
    if (cost < 物品使用数值配置.恶斯胸甲.最低消耗)
        cost = 物品使用数值配置.恶斯胸甲.最低消耗;
    if (cost > currentLife - 1)
        cost = currentLife - 1;
    if (cost > 0)
        设置生命(unit, currentLife - cost);
    窗口表[取句柄ID(unit)] = { 消耗生命: cost };
    到期队列.push(unit);
    addDelayedCallback(物品使用数值配置.恶斯胸甲.持续毫秒, 清除恶斯胸甲窗口);
}
export function 处理恶斯胸甲伤害修正(context) {
    const attacker = context.attacker;
    const id = 取句柄ID(attacker);
    const state = id === 0 ? undefined : 窗口表[id];
    if (state == null)
        return context.currentDamage;
    if (!(context.currentDamage > 物品使用数值配置.恶斯胸甲.触发伤害阈值))
        return context.currentDamage;
    delete 窗口表[id];
    后续伤害队列.push({
        来源: attacker,
        目标: context.target,
        伤害: state.消耗生命 * 物品使用数值配置.恶斯胸甲.后续伤害倍率,
    });
    addDelayedCallback(0, 执行恶斯胸甲后续伤害);
    return context.currentDamage * 物品使用数值配置.恶斯胸甲.伤害提升倍率;
}
