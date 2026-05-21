/** @noSelfInFile */
import { 单位持有攻击效果装备, 单位有效存活, 攻击者类型满足, 距离满足限制, 命中概率通过, 取攻击力, 攻击效果造成伤害, } from "../08．攻击效果/00．公共/01．攻击效果工具";
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index");
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
const 装备名 = "|cffcc99ff黑暗猎人手套|r";
const 命中率字段 = "命中率";
const 触发概率 = 0.15;
const 冷却毫秒 = 8000;
const 最大攻击距离 = 200;
const 攻击力系数 = 2;
const 致盲持续毫秒 = 1000;
const 致盲命中率变化 = -1;
const 冷却表 = {};
const 致盲恢复列表 = [];
let 致盲恢复Tick已注册 = false;
function 取单位句柄ID(unit) {
    if (unit == null || unit === 0)
        return 0;
    return GetHandleId(unit);
}
function 调整命中率(unit, value) {
    if (unit == null || unit === 0 || value === 0)
        return;
    const currentRaw = YDUserDataGet("unit", unit, 命中率字段, "real");
    const current = typeof currentRaw === "number" ? currentRaw : 0;
    YDUserDataSet("unit", unit, 命中率字段, "real", current + value);
}
function on黑暗猎人手套致盲恢复Tick() {
    const now = getServerTime();
    for (let i = 致盲恢复列表.length - 1; i >= 0; i--) {
        const record = 致盲恢复列表[i];
        if (now < record.expireTime)
            continue;
        调整命中率(record.target, record.restoreValue);
        致盲恢复列表.splice(i, 1);
    }
}
function 确保注册致盲恢复Tick() {
    if (致盲恢复Tick已注册)
        return;
    致盲恢复Tick已注册 = true;
    addPeriodicCallback(100, on黑暗猎人手套致盲恢复Tick);
}
function 施加黑暗猎人手套致盲(target) {
    if (!单位有效存活(target))
        return;
    调整命中率(target, 致盲命中率变化);
    致盲恢复列表.push({
        target,
        restoreValue: -致盲命中率变化,
        expireTime: getServerTime() + 致盲持续毫秒,
    });
    确保注册致盲恢复Tick();
}
function 冷却通过(attacker) {
    const id = 取单位句柄ID(attacker);
    if (id === 0)
        return false;
    const now = getServerTime();
    const last = 冷却表[id];
    if (last != null && now - last < 冷却毫秒)
        return false;
    冷却表[id] = now;
    return true;
}
function on黑暗猎人手套最终伤害(target, attacker, applied, snapshot) {
    if (!(applied > 0))
        return;
    if (snapshot == null || snapshot.isNormalAttack !== true || snapshot.isTrueDamage === true)
        return;
    if (!单位有效存活(attacker) || !单位有效存活(target))
        return;
    if (!单位持有攻击效果装备(attacker, 装备名))
        return;
    if (!攻击者类型满足(attacker, "近战"))
        return;
    if (!距离满足限制(attacker, target, undefined, 最大攻击距离))
        return;
    if (!命中概率通过(触发概率))
        return;
    if (!冷却通过(attacker))
        return;
    施加黑暗猎人手套致盲(target);
    攻击效果造成伤害(attacker, target, 取攻击力(attacker) * 攻击力系数, "暗影");
}
registerAppliedFinalDamageListener(on黑暗猎人手套最终伤害);
