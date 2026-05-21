/** @noSelfInFile */
const jass = require("jass.common");
const UnitDamageTarget = jass.UnitDamageTarget;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel;
const IsUnitPaused = jass.IsUnitPaused;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const { SFB_setEntanglingRoots, SFB_setParasite } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统");
const BUFF_纠缠根须 = 0x42456572;
const BUFF_寄生 = 0x424E7061;
const 默认伤害间隔 = 1;
const 持续时间补偿 = 0.05;
const 持续伤害实例表 = {};
const 持续伤害ID列表 = [];
let 下一个持续伤害ID = 0;
let 持续伤害回调ID = 0;
function 转数字(value) {
    if (value == null || value === false || value === "")
        return 0;
    const n = typeof value === "number" ? value : Number(value);
    return n !== n ? 0 : n;
}
function 读取来源单位(参数) {
    return 参数.来源单位 ?? 参数.BuffSource;
}
function 读取目标单位(参数) {
    return 参数.目标单位 ?? 参数.BuffTarget;
}
function 读取持续时间(参数) {
    const time = 转数字(参数.持续时间 ?? 参数.time);
    return time > 0 ? time + 持续时间补偿 : 0;
}
function 读取伤害间隔(参数) {
    const interval = 转数字(参数.伤害间隔 ?? 参数.DamageInterval);
    return interval > 0 ? interval : 默认伤害间隔;
}
function 注册持续伤害(来源单位, 目标单位, 伤害, 伤害间隔, BuffID) {
    if (目标单位 == null || 目标单位 === 0)
        return 0;
    if (伤害 <= 0)
        return 0;
    const id = ++下一个持续伤害ID;
    const now = getServerTime();
    持续伤害实例表[id] = {
        ID: id,
        来源单位,
        目标单位,
        伤害,
        伤害间隔毫秒: 伤害间隔 * 1000,
        下次伤害时间: now + 伤害间隔 * 1000,
        BuffID,
    };
    持续伤害ID列表.push(id);
    确保持续伤害系统启动();
    return id;
}
function 移除持续伤害(id) {
    if (持续伤害实例表[id] == null)
        return;
    delete 持续伤害实例表[id];
    const index = 持续伤害ID列表.indexOf(id);
    if (index >= 0)
        持续伤害ID列表.splice(index, 1);
    if (持续伤害ID列表.length === 0 && 持续伤害回调ID !== 0) {
        removePeriodicCallback(持续伤害回调ID);
        持续伤害回调ID = 0;
    }
}
function 确保持续伤害系统启动() {
    if (持续伤害回调ID !== 0)
        return;
    持续伤害回调ID = addPeriodicCallback(100, 持续伤害系统Tick);
}
function 持续伤害系统Tick() {
    const now = getServerTime();
    let index = 0;
    while (index < 持续伤害ID列表.length) {
        const id = 持续伤害ID列表[index];
        const 实例 = 持续伤害实例表[id];
        if (实例 == null || 实例.目标单位 == null || 实例.目标单位 === 0) {
            移除持续伤害(id);
            continue;
        }
        if (GetUnitAbilityLevel(实例.目标单位, 实例.BuffID) <= 0) {
            移除持续伤害(id);
            continue;
        }
        if (!IsUnitPaused(实例.目标单位) && now >= 实例.下次伤害时间) {
            UnitDamageTarget(实例.来源单位, 实例.目标单位, 实例.伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS);
            实例.下次伤害时间 = now + 实例.伤害间隔毫秒;
        }
        if (index < 持续伤害ID列表.length && 持续伤害ID列表[index] === id)
            index++;
    }
}
export function 施加禁锢(参数) {
    const 来源单位 = 读取来源单位(参数);
    const 目标单位 = 读取目标单位(参数);
    const 持续时间 = 读取持续时间(参数);
    if (目标单位 == null || 目标单位 === 0 || 持续时间 <= 0)
        return;
    SFB_setEntanglingRoots(来源单位, 目标单位, 持续时间);
    注册持续伤害(来源单位, 目标单位, 转数字(参数.伤害 ?? 参数.HitDamage), 读取伤害间隔(参数), BUFF_纠缠根须);
}
export function 施加寄生(参数) {
    const 来源单位 = 读取来源单位(参数);
    const 目标单位 = 读取目标单位(参数);
    const 持续时间 = 读取持续时间(参数);
    if (目标单位 == null || 目标单位 === 0 || 持续时间 <= 0)
        return;
    SFB_setParasite(来源单位, 目标单位, 持续时间);
    注册持续伤害(来源单位, 目标单位, 转数字(参数.伤害 ?? 参数.HitDamage), 读取伤害间隔(参数), BUFF_寄生);
}
