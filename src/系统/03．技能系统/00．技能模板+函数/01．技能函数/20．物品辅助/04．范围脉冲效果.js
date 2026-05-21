/** @noSelfInFile */
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { 监听指定物品获取丢弃, 获取单位当前持有指定物品数量, } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听");
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const IsUnitType = jass.IsUnitType;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const 范围脉冲实例表 = [];
let 已注册范围脉冲中心 = false;
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
        return;
    }
    配置.单位状态[unitId] = { 单位: unit, 数量: currentCount };
    if (previousCount <= 0) {
        配置.下次触发时间 = getServerTime();
    }
}
function 处理丢弃(配置, unit, _item, currentCount) {
    const unitId = 获取单位ID(unit);
    if (unitId === 0)
        return;
    if (currentCount <= 0) {
        delete 配置.单位状态[unitId];
        return;
    }
    配置.单位状态[unitId] = { 单位: unit, 数量: currentCount };
}
function on范围脉冲效果Tick() {
    const now = getServerTime();
    for (let i = 0; i < 范围脉冲实例表.length; i++) {
        const 配置 = 范围脉冲实例表[i];
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
                continue;
            }
            状态.数量 = currentCount;
            const x = GetUnitX(状态.单位);
            const y = GetUnitY(状态.单位);
            const units = getUnitsInRange(x, y, 配置.半径);
            for (let j = 0; j < units.length; j++) {
                const target = units[j];
                if (target == null || target === 0)
                    continue;
                if (配置.排除自身 !== false && target === 状态.单位)
                    continue;
                if (IsUnitType(target, UNIT_TYPE_DEAD) === true)
                    continue;
                if (配置.目标过滤 != null && 配置.目标过滤(状态.单位, target, currentCount) !== true)
                    continue;
                配置.脉冲回调(状态.单位, target, currentCount);
            }
        }
        for (let j = 0; j < 待清理.length; j++) {
            delete 配置.单位状态[待清理[j]];
        }
    }
}
function 确保中心已注册() {
    if (已注册范围脉冲中心)
        return;
    已注册范围脉冲中心 = true;
    addPeriodicCallback(100, on范围脉冲效果Tick);
}
export function 注册范围脉冲效果(参数) {
    if (参数 == null ||
        参数.物品类型ID === 0 ||
        参数.间隔毫秒 <= 0 ||
        参数.半径 <= 0 ||
        参数.脉冲回调 == null) {
        return;
    }
    确保中心已注册();
    const 配置 = {
        ...参数,
        下次触发时间: getServerTime() + 参数.间隔毫秒,
        单位状态: {},
    };
    范围脉冲实例表.push(配置);
    监听指定物品获取丢弃(参数.物品类型ID, (unit, item, currentCount, previousCount) => 处理获得(配置, unit, item, currentCount, previousCount), (unit, item, currentCount, _previousCount) => 处理丢弃(配置, unit, item, currentCount));
}
