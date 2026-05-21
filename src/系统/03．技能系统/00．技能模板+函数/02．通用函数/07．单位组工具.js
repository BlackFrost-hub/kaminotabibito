/** @noSelfInFile */
/**
 * 通用函数 - 单位组便捷工具
 *
 * 提供单位组快照、伤害、Buff、过滤、排序等常用操作。
 * 统一收敛重复的 `快照单位组` 逻辑，并集成快速Buff系统。
 */
const jass = require("jass.common");
const { SFB_setBuff, SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统");
// ─── 单位组快照 ──────────────────────────────────────────
const ForGroup = jass["ForGroup"];
const GetEnumUnit = jass["GetEnumUnit"];
let 快照缓存 = [];
function 收集成员() {
    const 单位 = GetEnumUnit();
    if (单位 != null && 单位 !== 0) {
        快照缓存.push(单位);
    }
}
/**
 * 将 JASS 单位组转为数组快照。
 * 使用 ForGroup + GetEnumUnit，与旧 JASS 模板兼容。
 */
export function 快照单位组(单位组) {
    if (单位组 == null || 单位组 === 0)
        return [];
    快照缓存 = [];
    ForGroup(单位组, 收集成员);
    const 结果 = 快照缓存;
    快照缓存 = [];
    return 结果;
}
// ─── 单位组造成伤害 ──────────────────────────────────────
/**
 * 对单位组内所有单位造成伤害
 * @param 单位列表 单位数组（可用 快照单位组 或 getUnitsInRange 的返回值）
 * @param 来源 伤害来源单位
 * @param 伤害值 伤害数值
 * @param 伤害类型 可选，默认 DAMAGE_TYPE_NORMAL
 */
export function 单位组造成伤害(单位列表, 来源, 伤害值, 伤害类型) {
    if (!单位列表 || 单位列表.length === 0)
        return;
    if (伤害值 <= 0)
        return;
    const 类型 = 伤害类型 ?? jass.DAMAGE_TYPE_NORMAL;
    for (const 单位 of 单位列表) {
        jass.UnitDamageTarget(来源 ?? 单位, 单位, 伤害值, false, false, jass.ATTACK_TYPE_NORMAL, 类型, jass.WEAPON_TYPE_WHOKNOWS);
    }
}
/**
 * 对单位组内所有单位施加控制 Buff
 * @param 单位列表 单位数组
 * @param 来源 Buff来源单位（用于BuffUI显示）
 * @param 控制ID Buff类型
 * @param 持续时间 秒
 */
export function 单位组施加控制(单位列表, 来源, 控制ID, 持续时间) {
    if (!单位列表 || 单位列表.length === 0)
        return;
    if (持续时间 <= 0)
        return;
    for (const 单位 of 单位列表) {
        SFB_setBuff(来源, 单位, 控制ID, 持续时间);
    }
}
/**
 * 对单位组内所有单位施加减速
 * @param 单位列表 单位数组
 * @param 来源 Buff来源单位
 * @param 降低攻速 百分比
 * @param 降低移速 百分比
 * @param 持续时间 秒
 */
export function 单位组施加减速(单位列表, 来源, 降低攻速, 降低移速, 持续时间) {
    if (!单位列表 || 单位列表.length === 0)
        return;
    if (持续时间 <= 0)
        return;
    for (const 单位 of 单位列表) {
        SFB_setSlow(来源, 单位, 降低攻速, 降低移速, 持续时间);
    }
}
// ─── 单位组过滤 ─────────────────────────────────────────
/**
 * 按条件过滤单位数组
 * @param 单位列表 单位数组
 * @param 条件 过滤函数，返回 true 保留
 */
export function 单位组过滤(单位列表, 条件) {
    if (!单位列表)
        return [];
    const 结果 = [];
    for (const 单位 of 单位列表) {
        if (条件(单位))
            结果.push(单位);
    }
    return 结果;
}
/**
 * 只保留敌方单位
 */
export function 过滤敌方(单位列表, 所有者) {
    return 单位组过滤(单位列表, (u) => jass.IsUnitEnemy(u, 所有者));
}
/**
 * 只保留友方单位（不含自身）
 */
export function 过滤友方排除自身(单位列表, 所有者) {
    return 单位组过滤(单位列表, (u) => u !== 所有者 && jass.IsUnitAlly(u, 所有者));
}
// ─── 单位组排序 ─────────────────────────────────────────
/**
 * 按距离指定坐标从近到远排序
 */
export function 单位组按距离排序(单位列表, 中心X, 中心Y) {
    if (!单位列表)
        return [];
    const 拷贝 = [...单位列表];
    拷贝.sort((a, b) => {
        const dxA = jass.GetUnitX(a) - 中心X;
        const dyA = jass.GetUnitY(a) - 中心Y;
        const dxB = jass.GetUnitX(b) - 中心X;
        const dyB = jass.GetUnitY(b) - 中心Y;
        return (dxA * dxA + dyA * dyA) - (dxB * dxB + dyB * dyB);
    });
    return 拷贝;
}
/**
 * 按生命值从低到高排序
 */
export function 单位组按生命排序(单位列表) {
    if (!单位列表)
        return [];
    const 拷贝 = [...单位列表];
    拷贝.sort((a, b) => {
        return jass.GetUnitState(a, jass.UNIT_STATE_LIFE)
            - jass.GetUnitState(b, jass.UNIT_STATE_LIFE);
    });
    return 拷贝;
}
