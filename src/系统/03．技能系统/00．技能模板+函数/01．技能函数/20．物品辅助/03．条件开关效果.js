/** @noSelfInFile */
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const { 监听指定物品获取丢弃, 获取单位当前持有指定物品数量, } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听");
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
const 条件开关实例表 = [];
let 已注册条件开关中心 = false;
function 获取单位ID(unit) {
    if (unit == null || unit === 0)
        return 0;
    return GetHandleId(unit) || 0;
}
function 切换条件状态(配置, 状态) {
    if (状态.数量 <= 0) {
        if (状态.已开启) {
            状态.已开启 = false;
            配置.关闭回调?.(状态.单位, 状态.数量);
        }
        return;
    }
    const 应开启 = 配置.条件回调(状态.单位, 状态.数量);
    if (应开启 && !状态.已开启) {
        状态.已开启 = true;
        配置.开启回调(状态.单位, 状态.数量);
        return;
    }
    if (!应开启 && 状态.已开启) {
        状态.已开启 = false;
        配置.关闭回调?.(状态.单位, 状态.数量);
    }
}
function 处理获得(配置, unit, _item, currentCount, previousCount) {
    const unitId = 获取单位ID(unit);
    if (unitId === 0)
        return;
    if (currentCount <= 0) {
        const 状态 = 配置.单位状态[unitId];
        if (状态 != null && 状态.已开启) {
            状态.已开启 = false;
            配置.关闭回调?.(unit, previousCount);
        }
        delete 配置.单位状态[unitId];
        return;
    }
    const 状态 = 配置.单位状态[unitId] ?? { 单位: unit, 数量: currentCount, 已开启: false };
    状态.单位 = unit;
    状态.数量 = currentCount;
    配置.单位状态[unitId] = 状态;
    切换条件状态(配置, 状态);
}
function 处理丢弃(配置, unit, _item, currentCount, previousCount) {
    const unitId = 获取单位ID(unit);
    if (unitId === 0)
        return;
    if (currentCount <= 0) {
        const 状态 = 配置.单位状态[unitId];
        if (状态 != null && 状态.已开启) {
            状态.已开启 = false;
            配置.关闭回调?.(unit, previousCount);
        }
        delete 配置.单位状态[unitId];
        return;
    }
    const 状态 = 配置.单位状态[unitId] ?? { 单位: unit, 数量: currentCount, 已开启: false };
    状态.单位 = unit;
    状态.数量 = currentCount;
    配置.单位状态[unitId] = 状态;
    切换条件状态(配置, 状态);
}
function on条件开关效果Tick() {
    const now = getServerTime();
    for (let i = 0; i < 条件开关实例表.length; i++) {
        const 配置 = 条件开关实例表[i];
        if (now < 配置.下次触发时间)
            continue;
        配置.下次触发时间 = now + 配置.检查间隔毫秒;
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
                if (状态.已开启) {
                    状态.已开启 = false;
                    配置.关闭回调?.(状态.单位, 状态.数量);
                }
                待清理.push(unitId);
                continue;
            }
            状态.数量 = currentCount;
            切换条件状态(配置, 状态);
        }
        for (let j = 0; j < 待清理.length; j++) {
            delete 配置.单位状态[待清理[j]];
        }
    }
}
function 确保中心已注册() {
    if (已注册条件开关中心)
        return;
    已注册条件开关中心 = true;
    addPeriodicCallback(100, on条件开关效果Tick);
}
export function 注册持有型条件开关效果(参数) {
    if (参数 == null ||
        参数.物品类型ID === 0 ||
        参数.检查间隔毫秒 <= 0 ||
        参数.条件回调 == null ||
        参数.开启回调 == null) {
        return;
    }
    确保中心已注册();
    const 配置 = {
        ...参数,
        下次触发时间: getServerTime() + 参数.检查间隔毫秒,
        单位状态: {},
    };
    条件开关实例表.push(配置);
    监听指定物品获取丢弃(参数.物品类型ID, (unit, item, currentCount, previousCount) => 处理获得(配置, unit, item, currentCount, previousCount), (unit, item, currentCount, previousCount) => 处理丢弃(配置, unit, item, currentCount, previousCount));
}
