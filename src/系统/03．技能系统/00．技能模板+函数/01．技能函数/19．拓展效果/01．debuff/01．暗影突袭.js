/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统");
const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统");
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口");
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口");
const { 创建追踪插值轨迹 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index");
const { isSameUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const buffTableMod = require("系统.05．Buff系统.01．Buff表");
const GetHandleId = jass.GetHandleId;
const GetUnitState = jass.GetUnitState;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFacing = jass.GetUnitFacing;
const GetUnitName = jass.GetUnitName;
const UnitDamageTarget = jass.UnitDamageTarget;
const CreateTimer = jass.CreateTimer;
const DestroyTimer = jass.DestroyTimer;
const GetExpiredTimer = jass.GetExpiredTimer;
const TimerStart = jass.TimerStart;
const R2I = jass.R2I;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const 暗影突袭BuffID = "C025";
const 暗影突袭弹幕模型 = "Abilities\\Spells\\NightElf\\shadowstrike\\ShadowStrikeMissile.mdl";
function 读取Buff图标(BuffID) {
    const meta = buffTableMod.buffs[BuffID];
    return meta != null && meta.icon != null && meta.icon !== "" ? meta.icon : undefined;
}
function 读取Buff特效(BuffID) {
    const meta = buffTableMod.buffs[BuffID];
    return meta != null && meta.effect != null && meta.effect !== "" ? meta.effect : undefined;
}
const 暗影突袭毒素计时表 = {};
const 暗影突袭毒素标记表 = {};
function 暗影突袭向上取整秒数(duration) {
    const 整秒 = R2I(duration);
    if (duration > 整秒)
        return 整秒 + 1;
    return 整秒 > 0 ? 整秒 : 1;
}
function 暗影突袭毒素结束() {
    const timer = GetExpiredTimer();
    const timerId = GetHandleId(timer);
    delete 暗影突袭毒素计时表[timerId];
    DestroyTimer(timer);
}
function 暗影突袭毒素tick() {
    const timer = GetExpiredTimer();
    const timerId = GetHandleId(timer);
    const state = 暗影突袭毒素计时表[timerId];
    if (state == null) {
        DestroyTimer(timer);
        return;
    }
    if (getBuffRuntime(state.target, state.buffID) == null) {
        暗影突袭毒素结束();
        return;
    }
    if (state.remainingTicks <= 0) {
        暗影突袭毒素结束();
        return;
    }
    state.remainingTicks -= 1;
    const target = state.target;
    if (target != null && target !== 0 && GetUnitState(target, UNIT_STATE_LIFE) > 0.405) {
        const targetHid = GetHandleId(target);
        暗影突袭毒素标记表[targetHid] = (暗影突袭毒素标记表[targetHid] ?? 0) + 1;
        debugLogForce("暗影突袭", "毒素tick", "source:", state.source, "target:", target, "damage:", state.damagePerTick, "remaining:", state.remainingTicks);
        UnitDamageTarget(state.source, target, state.damagePerTick, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS);
        const current = 暗影突袭毒素标记表[targetHid] ?? 0;
        if (current <= 1) {
            delete 暗影突袭毒素标记表[targetHid];
        }
        else {
            暗影突袭毒素标记表[targetHid] = current - 1;
        }
    }
    if (state.remainingTicks <= 0) {
        暗影突袭毒素结束();
    }
}
function on暗影突袭Buff移除(unit, buffID, _row) {
    if (unit == null || unit === 0 || buffID === "")
        return;
    for (const key in 暗影突袭毒素计时表) {
        const state = 暗影突袭毒素计时表[key];
        if (state == null)
            continue;
        if (state.target !== unit || state.buffID !== buffID)
            continue;
        delete 暗影突袭毒素计时表[key];
    }
}
export function 是否为暗影突袭毒素伤害(unit) {
    if (unit == null || unit === 0)
        return false;
    const hid = GetHandleId(unit);
    return (暗影突袭毒素标记表[hid] ?? 0) > 0;
}
export function 标记暗影突袭毒素伤害(unit, callback) {
    if (unit == null || unit === 0) {
        callback();
        return;
    }
    const hid = GetHandleId(unit);
    暗影突袭毒素标记表[hid] = (暗影突袭毒素标记表[hid] ?? 0) + 1;
    try {
        callback();
    }
    finally {
        const current = 暗影突袭毒素标记表[hid] ?? 0;
        if (current <= 1) {
            delete 暗影突袭毒素标记表[hid];
        }
        else {
            暗影突袭毒素标记表[hid] = current - 1;
        }
    }
}
export function 施加暗影突袭减益(source, target, 参数 = {}) {
    if (source == null || source === 0 || target == null || target === 0)
        return;
    const duration = 参数.duration ?? 2.0;
    const damagePerSecond = 参数.damagePerSecond ?? 500;
    const slowAttack = 参数.slowAttack ?? 0.3;
    const slowMove = 参数.slowMove ?? 0.3;
    const buffID = 参数.buffID ?? 暗影突袭BuffID;
    debugLogForce("暗影突袭", "施加减益", "source:", source, "target:", target, "duration:", duration, "dps:", damagePerSecond);
    registerManualBuff(target, buffID, duration, 0, {
        sourceName: 参数.sourceName ?? GetUnitName(source),
        iconOverride: 参数.iconOverride ?? 读取Buff图标(buffID),
        effectModelOverride: 参数.effectModelOverride ?? 读取Buff特效(buffID),
        onRemove: on暗影突袭Buff移除,
    });
    SFB_setSlow(source, target, slowAttack, slowMove, duration);
    const timer = CreateTimer();
    const timerId = GetHandleId(timer);
    暗影突袭毒素计时表[timerId] = {
        source,
        target,
        buffID,
        remainingTicks: 暗影突袭向上取整秒数(duration),
        damagePerTick: damagePerSecond,
    };
    TimerStart(timer, 1.0, true, 暗影突袭毒素tick);
}
export function 创建暗影突袭追踪(source, target, 参数 = {}) {
    if (source == null || source === 0 || target == null || target === 0)
        return;
    debugLogForce("暗影突袭", "准备创建追踪弹幕", "source:", source, "target:", target, "sourcePos=(", GetUnitX(source), ",", GetUnitY(source), ")", "targetPos=(", GetUnitX(target), ",", GetUnitY(target), ")");
    let 已施加 = false;
    function 暗影突袭弹幕命中(命中单位) {
        if (已施加)
            return;
        已施加 = true;
        debugLogForce("暗影突袭", "弹幕命中", "source:", source, "target:", 命中单位);
        施加暗影突袭减益(source, 命中单位, 参数.减益 ?? {});
    }
    function 暗影突袭到达目标点() {
        if (已施加)
            return;
        if (target == null || target === 0)
            return;
        已施加 = true;
        debugLogForce("暗影突袭", "到达目标点补命中", "source:", source, "target:", target);
        施加暗影突袭减益(source, target, 参数.减益 ?? {});
    }
    function 暗影突袭结束(原因) {
        debugLogForce("暗影突袭", "结束", "source:", source, "target:", target, "原因:", 原因);
    }
    function 暗影突袭目标筛选(目标单位) {
        return isSameUnit(目标单位, target);
    }
    创建原生弹幕({
        所有者: source,
        X: GetUnitX(source),
        Y: GetUnitY(source),
        方向角: GetUnitFacing(source),
        指定目标: target,
        速度: 参数.速度 ?? 1500,
        轨迹采样器: 创建追踪插值轨迹(target, 参数.命中半径 ?? 100),
        命中半径: 参数.命中半径 ?? 100,
        生命周期: 参数.生命周期 ?? 8,
        碰撞消失: true,
        最大距离: 参数.最大距离 ?? 5000,
        模型: 参数.模型 ?? 暗影突袭弹幕模型,
        附着特效模型: 参数.模型 ?? 暗影突袭弹幕模型,
        影响目标: "全部",
        目标筛选: 暗影突袭目标筛选,
        最大总命中次数: 1,
        每单位最大命中次数: 1,
        on到达目标点: 暗影突袭到达目标点,
        on命中: 暗影突袭弹幕命中,
        on命中单位: 暗影突袭弹幕命中,
        on结束: 暗影突袭结束,
    });
}
