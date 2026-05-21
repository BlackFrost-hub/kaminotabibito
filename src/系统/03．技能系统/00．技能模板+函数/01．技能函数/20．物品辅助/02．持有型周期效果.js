/** @noSelfInFile */
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const { 监听指定物品获取丢弃, 获取单位当前持有指定物品数量, } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听");
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
const GetItemTypeId = jass.GetItemTypeId;
const 持有型周期效果实例表 = [];
const 已注册监听物品类型 = {};
let 已注册持有型周期效果中心 = false;
function 获取单位ID(unit) {
    if (unit == null || unit === 0)
        return 0;
    return GetHandleId(unit) || 0;
}
function 处理获得(配置, unit, _item, currentCount, previousCount) {
    const unitId = 获取单位ID(unit);
    if (unitId === 0)
        return;
    if (currentCount <= 0) {
        delete 配置.单位状态[unitId];
        if (previousCount > 0) {
            配置.丢弃回调?.(unit, previousCount);
        }
        return;
    }
    配置.单位状态[unitId] = { 单位: unit, 数量: 1 };
    if (previousCount <= 0) {
        配置.获取回调?.(unit, 1);
    }
}
function 处理丢弃(配置, unit, _item, currentCount, previousCount) {
    const unitId = 获取单位ID(unit);
    if (unitId === 0)
        return;
    if (currentCount <= 0) {
        delete 配置.单位状态[unitId];
        if (previousCount > 0) {
            配置.丢弃回调?.(unit, previousCount);
        }
        return;
    }
    配置.单位状态[unitId] = { 单位: unit, 数量: 1 };
}
function on持有型周期效果Tick() {
    const now = getServerTime();
    for (let i = 0; i < 持有型周期效果实例表.length; i++) {
        const 配置 = 持有型周期效果实例表[i];
        if (now < 配置.下次触发时间)
            continue;
        配置.下次触发时间 = now + 配置.间隔毫秒;
        const 待清理 = [];
        for (const unitKey in 配置.单位状态) {
            const unitId = Number(unitKey);
            const 状态 = 配置.单位状态[unitId];
            if (状态 == null || 状态.单位 == null || 状态.单位 === 0) {
                待清理.push(unitId);
                continue;
            }
            const currentCount = 获取单位当前持有指定物品数量(状态.单位, 配置.物品类型ID);
            if (currentCount <= 0) {
                待清理.push(unitId);
                配置.丢弃回调?.(状态.单位, 状态.数量);
                continue;
            }
            状态.数量 = 1;
            配置.周期回调(状态.单位, 1);
        }
        for (let j = 0; j < 待清理.length; j++) {
            delete 配置.单位状态[待清理[j]];
        }
    }
}
function 确保持有型周期效果中心已注册() {
    if (已注册持有型周期效果中心)
        return;
    已注册持有型周期效果中心 = true;
    addPeriodicCallback(100, on持有型周期效果Tick);
}
function on持有型周期效果获取(unit, item, currentCount, previousCount) {
    if (item == null || item === 0)
        return;
    const itemTypeId = GetItemTypeId(item);
    for (let i = 0; i < 持有型周期效果实例表.length; i++) {
        const 配置 = 持有型周期效果实例表[i];
        if (配置.物品类型ID === itemTypeId) {
            处理获得(配置, unit, item, currentCount, previousCount);
        }
    }
}
function on持有型周期效果丢弃(unit, item, currentCount, previousCount) {
    if (item == null || item === 0)
        return;
    const itemTypeId = GetItemTypeId(item);
    for (let i = 0; i < 持有型周期效果实例表.length; i++) {
        const 配置 = 持有型周期效果实例表[i];
        if (配置.物品类型ID === itemTypeId) {
            处理丢弃(配置, unit, item, currentCount, previousCount);
        }
    }
}
export function 注册持有型周期效果(参数) {
    if (参数 == null || 参数.物品类型ID === 0 || 参数.间隔毫秒 <= 0 || 参数.周期回调 == null)
        return;
    确保持有型周期效果中心已注册();
    const 配置 = {
        ...参数,
        下次触发时间: getServerTime() + 参数.间隔毫秒,
        单位状态: {},
    };
    持有型周期效果实例表.push(配置);
    if (已注册监听物品类型[参数.物品类型ID] !== true) {
        已注册监听物品类型[参数.物品类型ID] = true;
        监听指定物品获取丢弃(参数.物品类型ID, on持有型周期效果获取, on持有型周期效果丢弃);
    }
}
