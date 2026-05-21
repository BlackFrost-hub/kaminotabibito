/** @noSelfInFile */
/**
 * 扩展控制系统
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const jglobals = require("jass.globals");
const { String2OrderIdBJ } = require("lib.扩展函数.BJ函数.07．杂项");
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
const { calcReducedControlDuration, isExcludedFromControlResist } = require("系统.05．Buff系统.01．控制抗性.index");
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统");
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff");
const { addDelayedCallback, addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const { registerTargetOrderListener, registerPointOrderListener, registerImmediateOrderListener, } = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心");
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { 获取扩展控制定义, 获取控制效果定义, 默认魅惑跟随半径, 魅惑特效模型, 恐惧特效模型, 默认恐惧逃离距离, 默认恐惧移动速度, 默认恐惧随机半径, 扩展控制特效挂点, } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.控制效果定义");
const GetHandleId = jass.GetHandleId;
const GetUnitName = jass.GetUnitName;
const GetUnitCurrentOrder = jass.GetUnitCurrentOrder;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
const DestroyEffect = jass.DestroyEffect;
const IssueTargetOrder = jass.IssueTargetOrder;
const IssuePointOrder = jass.IssuePointOrder;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitMoveSpeed = jass.GetUnitMoveSpeed;
const GetRandomReal = jass.GetRandomReal;
const Atan2 = jass.Atan2;
const Cos = jass.Cos;
const Sin = jass.Sin;
const IsUnitType = jass.IsUnitType;
const SetUnitMoveSpeed = jass.SetUnitMoveSpeed;
const UnitDamageTarget = jass.UnitDamageTarget;
const DzSetUnitDisableControlOrder = japi.DzSetUnitDisableControlOrder;
const DzGetUnitDisableControlOrder = japi.DzGetUnitDisableControlOrder;
const DzUnitOrdersForceStop = japi.DzUnitOrdersForceStop;
const DzUnitDisableAttack = japi.DzUnitDisableAttack;
const 模块名 = "扩展控制系统";
const bj_DEGTORAD = (jglobals.bj_DEGTORAD ?? 0.017453292519943295);
const bj_RADTODEG = (jglobals.bj_RADTODEG ?? 57.29577951308232);
const 扩展控制映射表 = {};
const 扩展控制目标ID列表 = [];
const 待执行反伤队列 = [];
let 已初始化 = false;
let 正在发布覆盖命令 = false;
let 反伤结算已排队 = false;
let 攻击命令ID = 0;
function 取单位ID(单位) {
    if (单位 == null || 单位 === 0)
        return 0;
    return GetHandleId(单位) || 0;
}
function 单位有效且存活(单位) {
    if (单位 == null || 单位 === 0)
        return false;
    return IsUnitType(单位, jass.UNIT_TYPE_DEAD) !== true;
}
function 取目标列表索引(目标ID) {
    for (let i = 0; i < 扩展控制目标ID列表.length; i++) {
        if (扩展控制目标ID列表[i] === 目标ID)
            return i;
    }
    return -1;
}
function 加入目标ID(目标ID) {
    if (取目标列表索引(目标ID) >= 0)
        return;
    扩展控制目标ID列表.push(目标ID);
}
function 移除目标ID(目标ID) {
    const index = 取目标列表索引(目标ID);
    if (index < 0)
        return;
    扩展控制目标ID列表.splice(index, 1);
}
function 计算平方距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return dx * dx + dy * dy;
}
function 计算极坐标X(x, angle, distance) {
    return x + Cos(angle * bj_DEGTORAD) * distance;
}
function 计算极坐标Y(y, angle, distance) {
    return y + Sin(angle * bj_DEGTORAD) * distance;
}
function 取不低于下限(数值, 下限) {
    if (数值 < 下限)
        return 下限;
    return 数值;
}
function 清理扩展控制记录(目标ID, 记录) {
    if (记录.目标单位引用 != null && 记录.目标单位引用 !== 0) {
        if (记录.特效句柄 != null && 记录.特效句柄 !== 0) {
            DestroyEffect(记录.特效句柄);
            记录.特效句柄 = null;
        }
        if (记录.类型 === "charm" || 记录.类型 === "fear") {
            DzUnitDisableAttack(记录.目标单位引用, false);
        }
        if (记录.类型 === "fear") {
            SetUnitMoveSpeed(记录.目标单位引用, 记录.原本移动速度);
        }
        DzSetUnitDisableControlOrder(记录.目标单位引用, 记录.原本屏蔽控制命令);
        移除单位指定Buff(记录.目标单位引用, 记录.BuffID);
    }
    delete 扩展控制映射表[目标ID];
    移除目标ID(目标ID);
}
function 内部清除扩展控制(目标ID, 指定类型) {
    const 记录 = 扩展控制映射表[目标ID];
    if (记录 == null)
        return false;
    if (指定类型 != null && 记录.类型 !== 指定类型)
        return false;
    清理扩展控制记录(目标ID, 记录);
    debugLogForce(模块名, "清除扩展控制", "目标ID=", 目标ID, "类型=", 记录.类型);
    return true;
}
function 执行嘲讽行为(记录, 当前时间) {
    const 目标单位 = 记录.目标单位引用;
    const 来源单位 = 记录.来源单位引用;
    if (!单位有效且存活(目标单位) || !单位有效且存活(来源单位))
        return;
    if (攻击命令ID === 0)
        攻击命令ID = String2OrderIdBJ("attack");
    记录.下次行为时间 = 当前时间 + 250;
    if ((GetUnitCurrentOrder(目标单位) || 0) === 攻击命令ID)
        return;
    正在发布覆盖命令 = true;
    IssueTargetOrder(目标单位, "attack", 来源单位);
    正在发布覆盖命令 = false;
}
function 执行魅惑行为(记录, 当前时间) {
    const 目标单位 = 记录.目标单位引用;
    const 来源单位 = 记录.来源单位引用;
    if (!单位有效且存活(目标单位) || !单位有效且存活(来源单位))
        return;
    记录.下次行为时间 = 当前时间 + 200;
    const 目标X = GetUnitX(目标单位);
    const 目标Y = GetUnitY(目标单位);
    const 来源X = GetUnitX(来源单位);
    const 来源Y = GetUnitY(来源单位);
    if (计算平方距离(目标X, 目标Y, 来源X, 来源Y) <= 记录.跟随半径 * 记录.跟随半径)
        return;
    正在发布覆盖命令 = true;
    IssuePointOrder(目标单位, "move", 来源X, 来源Y);
    正在发布覆盖命令 = false;
}
function 执行恐惧逃离行为(记录, 当前时间) {
    const 目标单位 = 记录.目标单位引用;
    const 来源单位 = 记录.来源单位引用;
    if (!单位有效且存活(目标单位) || !单位有效且存活(来源单位))
        return;
    记录.下次行为时间 = 当前时间 + 300;
    const 目标X = GetUnitX(目标单位);
    const 目标Y = GetUnitY(目标单位);
    const 来源X = GetUnitX(来源单位);
    const 来源Y = GetUnitY(来源单位);
    const dx = 目标X - 来源X;
    const dy = 目标Y - 来源Y;
    let 角度 = GetRandomReal(0, 360);
    if (dx * dx + dy * dy > 1.0) {
        角度 = Atan2(dy, dx) * bj_RADTODEG;
    }
    正在发布覆盖命令 = true;
    IssuePointOrder(目标单位, "move", 计算极坐标X(目标X, 角度, 记录.逃离距离), 计算极坐标Y(目标Y, 角度, 记录.逃离距离));
    正在发布覆盖命令 = false;
}
function 执行恐惧随机行为(记录, 当前时间) {
    const 目标单位 = 记录.目标单位引用;
    if (!单位有效且存活(目标单位))
        return;
    记录.下次行为时间 = 当前时间 + 450;
    const 目标X = GetUnitX(目标单位);
    const 目标Y = GetUnitY(目标单位);
    const 随机角度 = GetRandomReal(0, 360);
    正在发布覆盖命令 = true;
    IssuePointOrder(目标单位, "move", 计算极坐标X(目标X, 随机角度, 记录.随机半径), 计算极坐标Y(目标Y, 随机角度, 记录.随机半径));
    正在发布覆盖命令 = false;
}
function 执行恐惧行为(记录, 当前时间) {
    if (记录.恐惧模式 === "随机乱跑") {
        执行恐惧随机行为(记录, 当前时间);
        return;
    }
    执行恐惧逃离行为(记录, 当前时间);
}
function 扩展控制驱动Tick() {
    const 当前时间 = getServerTime();
    let index = 0;
    while (index < 扩展控制目标ID列表.length) {
        const 目标ID = 扩展控制目标ID列表[index];
        const 记录 = 扩展控制映射表[目标ID];
        if (记录 == null) {
            扩展控制目标ID列表.splice(index, 1);
            continue;
        }
        if (!单位有效且存活(记录.目标单位引用) || !单位有效且存活(记录.来源单位引用) || 记录.到期时间 <= 当前时间) {
            清理扩展控制记录(目标ID, 记录);
            continue;
        }
        if (当前时间 >= 记录.下次行为时间) {
            if (记录.类型 === "taunt") {
                执行嘲讽行为(记录, 当前时间);
            }
            else if (记录.类型 === "charm") {
                执行魅惑行为(记录, 当前时间);
            }
            else {
                执行恐惧行为(记录, 当前时间);
            }
        }
        index++;
    }
}
function on目标指令(unit, orderId, targetUnit, _targetItem, _targetDestructable) {
    if (正在发布覆盖命令)
        return;
    if (攻击命令ID === 0)
        攻击命令ID = String2OrderIdBJ("attack");
    const 记录 = 扩展控制映射表[取单位ID(unit)];
    if (记录 == null || 记录.类型 !== "taunt")
        return;
    if (orderId === 攻击命令ID && 取单位ID(targetUnit) === 记录.来源单位ID)
        return;
    正在发布覆盖命令 = true;
    IssueTargetOrder(unit, "attack", 记录.来源单位引用);
    正在发布覆盖命令 = false;
}
function on点指令(unit, orderId, _x, _y) {
    if (正在发布覆盖命令)
        return;
    if (攻击命令ID === 0)
        攻击命令ID = String2OrderIdBJ("attack");
    const 记录 = 扩展控制映射表[取单位ID(unit)];
    if (记录 == null || 记录.类型 !== "taunt")
        return;
    if (orderId === 攻击命令ID)
        return;
    正在发布覆盖命令 = true;
    IssueTargetOrder(unit, "attack", 记录.来源单位引用);
    正在发布覆盖命令 = false;
}
function on立即指令(unit, orderId) {
    if (正在发布覆盖命令)
        return;
    if (攻击命令ID === 0)
        攻击命令ID = String2OrderIdBJ("attack");
    const 记录 = 扩展控制映射表[取单位ID(unit)];
    if (记录 == null || 记录.类型 !== "taunt")
        return;
    if (orderId === 攻击命令ID)
        return;
    正在发布覆盖命令 = true;
    IssueTargetOrder(unit, "attack", 记录.来源单位引用);
    正在发布覆盖命令 = false;
}
function flush反伤队列() {
    反伤结算已排队 = false;
    while (待执行反伤队列.length > 0) {
        const 记录 = 待执行反伤队列.shift();
        if (记录 == null)
            continue;
        if (!单位有效且存活(记录.攻击者))
            continue;
        if (记录.伤害 <= 0)
            continue;
        UnitDamageTarget(记录.攻击者, 记录.攻击者, 记录.伤害, false, false, jass.ATTACK_TYPE_CHAOS, jass.DAMAGE_TYPE_UNIVERSAL, null);
    }
}
function schedule反伤(attacker, damage) {
    if (!单位有效且存活(attacker) || damage <= 0)
        return;
    待执行反伤队列.push({ 攻击者: attacker, 伤害: damage });
    if (反伤结算已排队)
        return;
    反伤结算已排队 = true;
    addDelayedCallback(0, flush反伤队列);
}
function on反伤最终伤害(target, attacker, applied, damageType) {
    if (applied <= 0 || !单位有效且存活(attacker) || !单位有效且存活(target))
        return;
    if (damageType == null || damageType.isNormalAttack !== true)
        return;
    const 记录 = 扩展控制映射表[取单位ID(attacker)];
    if (记录 == null || 记录.类型 !== "taunt" || 记录.反伤倍率 <= 0)
        return;
    if (取单位ID(target) !== 记录.来源单位ID)
        return;
    schedule反伤(attacker, applied * 记录.反伤倍率);
}
function 确保初始化() {
    if (已初始化)
        return;
    已初始化 = true;
    registerTargetOrderListener(on目标指令);
    registerPointOrderListener(on点指令);
    registerImmediateOrderListener(on立即指令);
    registerAppliedFinalDamageListener(on反伤最终伤害);
    addPeriodicCallback(100, 扩展控制驱动Tick);
}
function 规范化扩展控制参数(参数) {
    if (typeof 参数 === "number") {
        return { 持续时间: 参数 };
    }
    return 参数;
}
function 取持续时间(参数) {
    if (typeof 参数 === "number")
        return 参数;
    return 参数.持续时间 ?? 0;
}
function 构建扩展控制记录(类型, 来源单位, 目标单位, 实际持续时间, 参数) {
    const 定义 = 获取扩展控制定义(类型);
    const 记录 = {
        类型,
        来源单位ID: 取单位ID(来源单位),
        来源单位引用: 来源单位,
        目标单位引用: 目标单位,
        BuffID: 定义.BuffID,
        到期时间: getServerTime() + 实际持续时间 * 1000,
        下次行为时间: 0,
        原本屏蔽控制命令: DzGetUnitDisableControlOrder(目标单位) === true,
        反伤倍率: 0,
        跟随半径: 默认魅惑跟随半径,
        恐惧模式: "逃离施法者",
        逃离距离: 默认恐惧逃离距离,
        随机半径: 默认恐惧随机半径,
        原本移动速度: GetUnitMoveSpeed(目标单位) || 0,
        恐惧移动速度: 默认恐惧移动速度,
        特效句柄: null,
    };
    if (类型 === "taunt") {
        记录.反伤倍率 = (参数.反伤倍率 ?? 0);
    }
    else if (类型 === "charm") {
        记录.跟随半径 = (参数.跟随半径 ?? 默认魅惑跟随半径);
    }
    else {
        记录.恐惧模式 = (参数.模式 ?? "逃离施法者");
        记录.逃离距离 = (参数.逃离距离 ?? 默认恐惧逃离距离);
        记录.随机半径 = (参数.随机半径 ?? 默认恐惧随机半径);
        记录.恐惧移动速度 = 取不低于下限((参数.移动速度 ?? 默认恐惧移动速度), 默认恐惧移动速度);
    }
    return 记录;
}
function 生效扩展控制首帧(记录) {
    DzSetUnitDisableControlOrder(记录.目标单位引用, true);
    DzUnitOrdersForceStop(记录.目标单位引用, true);
    if (记录.类型 === "taunt") {
        正在发布覆盖命令 = true;
        IssueTargetOrder(记录.目标单位引用, "attack", 记录.来源单位引用);
        正在发布覆盖命令 = false;
        return;
    }
    if (记录.类型 === "charm") {
        记录.特效句柄 = AddSpecialEffectTarget(魅惑特效模型, 记录.目标单位引用, 扩展控制特效挂点);
        DzUnitDisableAttack(记录.目标单位引用, true);
        正在发布覆盖命令 = true;
        IssuePointOrder(记录.目标单位引用, "move", GetUnitX(记录.来源单位引用), GetUnitY(记录.来源单位引用));
        正在发布覆盖命令 = false;
        return;
    }
    记录.特效句柄 = AddSpecialEffectTarget(恐惧特效模型, 记录.目标单位引用, 扩展控制特效挂点);
    DzUnitDisableAttack(记录.目标单位引用, true);
    SetUnitMoveSpeed(记录.目标单位引用, 记录.恐惧移动速度);
    if (记录.恐惧模式 === "随机乱跑") {
        执行恐惧随机行为(记录, getServerTime());
        return;
    }
    执行恐惧逃离行为(记录, getServerTime());
}
export function 施加扩展控制(来源单位或Self, 目标单位或来源单位, 类型或目标单位, 参数或类型, 兼容参数) {
    let 来源单位 = 来源单位或Self;
    let 目标单位 = 目标单位或来源单位;
    let 类型 = 类型或目标单位;
    let 参数 = 参数或类型;
    if (兼容参数 != null) {
        来源单位 = 目标单位或来源单位;
        目标单位 = 类型或目标单位;
        类型 = 参数或类型;
        参数 = 兼容参数;
    }
    if (!单位有效且存活(来源单位) || !单位有效且存活(目标单位) || 参数 == null)
        return 0;
    const 规范参数 = 规范化扩展控制参数(参数);
    let 实际持续时间 = 取持续时间(规范参数);
    if (实际持续时间 <= 0)
        return 0;
    if (!isExcludedFromControlResist(目标单位)) {
        实际持续时间 = calcReducedControlDuration(目标单位, 实际持续时间);
    }
    if (实际持续时间 <= 0)
        return 0;
    const 定义 = 获取控制效果定义(类型);
    if (定义 == null)
        return 0;
    const 目标ID = 取单位ID(目标单位);
    if (目标ID === 0)
        return 0;
    if (定义.类型分类 === "快速控制") {
        if (定义.快速控制ID == null)
            return 0;
        施加快速控制Buff(来源单位, 目标单位, 定义.快速控制ID, 实际持续时间);
        debugLogForce(模块名, "施加扩展控制", "类型=", 类型, "来源=", 取单位ID(来源单位), "目标=", 目标ID, "持续=", 实际持续时间);
        return 目标ID;
    }
    确保初始化();
    if (扩展控制映射表[目标ID] != null) {
        内部清除扩展控制(目标ID);
    }
    const 记录 = 构建扩展控制记录(类型, 来源单位, 目标单位, 实际持续时间, 规范参数);
    扩展控制映射表[目标ID] = 记录;
    加入目标ID(目标ID);
    registerManualBuff(目标单位, 记录.BuffID, 实际持续时间, 0, { sourceName: GetUnitName(来源单位) });
    生效扩展控制首帧(记录);
    debugLogForce(模块名, "施加扩展控制", "类型=", 类型, "来源=", 取单位ID(来源单位), "目标=", 目标ID, "持续=", 实际持续时间);
    return 目标ID;
}
export function AOE施加扩展控制(来源单位或Self, 中心X或来源单位, 中心Y或中心X, 半径或中心Y, 类型或半径, 参数或类型, 兼容参数) {
    let 来源单位 = 来源单位或Self;
    let 中心X = 中心X或来源单位;
    let 中心Y = 中心Y或中心X;
    let 半径 = 半径或中心Y;
    let 类型 = 类型或半径;
    let 参数 = 参数或类型;
    if (兼容参数 != null) {
        来源单位 = 中心X或来源单位;
        中心X = 中心Y或中心X;
        中心Y = 半径或中心Y;
        半径 = 类型或半径;
        类型 = 参数或类型;
        参数 = 兼容参数;
    }
    if (!单位有效且存活(来源单位))
        return [];
    const 目标列表 = getEnemyUnitsInRange(来源单位, 中心X, 中心Y, 半径);
    const 结果 = [];
    for (let i = 0; i < 目标列表.length; i++) {
        const 目标 = 目标列表[i];
        if (!单位有效且存活(目标))
            continue;
        const id = 施加扩展控制(来源单位, 目标, 类型, 参数);
        if (id !== 0)
            结果.push(id);
    }
    return 结果;
}
export function 移除扩展控制(目标单位或Self, 类型或目标单位, 兼容类型) {
    const 目标单位 = 兼容类型 == null ? 目标单位或Self : 类型或目标单位;
    const 类型 = 兼容类型 ?? 类型或目标单位;
    const 目标ID = 取单位ID(目标单位);
    if (目标ID === 0)
        return false;
    return 内部清除扩展控制(目标ID, 类型);
}
export function 单位是否处于扩展控制(目标单位或Self, 类型或目标单位, 兼容类型) {
    const 目标单位 = 兼容类型 == null ? 目标单位或Self : 类型或目标单位;
    const 类型 = 兼容类型 ?? 类型或目标单位;
    const 记录 = 扩展控制映射表[取单位ID(目标单位)];
    if (记录 == null)
        return false;
    if (类型 != null && 记录.类型 !== 类型)
        return false;
    return true;
}
export function 获取扩展控制来源单位(目标单位或Self, 类型或目标单位, 兼容类型) {
    const 目标单位 = 兼容类型 == null ? 目标单位或Self : 类型或目标单位;
    const 类型 = (兼容类型 ?? 类型或目标单位);
    const 记录 = 扩展控制映射表[取单位ID(目标单位)];
    if (记录 == null || 记录.类型 !== 类型)
        return null;
    return 记录.来源单位引用;
}
export function 施加嘲讽(来源单位或Self, 目标单位或来源单位, 参数或目标单位, 兼容参数) {
    let 来源单位 = 来源单位或Self;
    let 目标单位 = 目标单位或来源单位;
    let 参数 = 参数或目标单位;
    if (兼容参数 != null) {
        来源单位 = 目标单位或来源单位;
        目标单位 = 参数或目标单位;
        参数 = 兼容参数;
    }
    return 施加扩展控制(来源单位, 目标单位, "taunt", 参数);
}
export function AOE施加嘲讽(来源单位或Self, 中心X或来源单位, 中心Y或中心X, 半径或中心Y, 参数或半径, 兼容参数) {
    let 来源单位 = 来源单位或Self;
    let 中心X = 中心X或来源单位;
    let 中心Y = 中心Y或中心X;
    let 半径 = 半径或中心Y;
    let 参数 = 参数或半径;
    if (兼容参数 != null) {
        来源单位 = 中心X或来源单位;
        中心X = 中心Y或中心X;
        中心Y = 半径或中心Y;
        半径 = 参数或半径;
        参数 = 兼容参数;
    }
    return AOE施加扩展控制(来源单位, 中心X, 中心Y, 半径, "taunt", 参数);
}
export function 移除嘲讽(目标单位或Self, 兼容目标单位) {
    return 移除扩展控制(兼容目标单位 ?? 目标单位或Self, "taunt");
}
export function 单位是否被嘲讽(目标单位或Self, 兼容目标单位) {
    return 单位是否处于扩展控制(兼容目标单位 ?? 目标单位或Self, "taunt");
}
export function 获取嘲讽来源单位(目标单位或Self, 兼容目标单位) {
    return 获取扩展控制来源单位(兼容目标单位 ?? 目标单位或Self, "taunt");
}
export function 施加魅惑(来源单位或Self, 目标单位或来源单位, 参数或目标单位, 兼容参数) {
    let 来源单位 = 来源单位或Self;
    let 目标单位 = 目标单位或来源单位;
    let 参数 = 参数或目标单位;
    if (兼容参数 != null) {
        来源单位 = 目标单位或来源单位;
        目标单位 = 参数或目标单位;
        参数 = 兼容参数;
    }
    return 施加扩展控制(来源单位, 目标单位, "charm", 参数);
}
export function AOE施加魅惑(来源单位或Self, 中心X或来源单位, 中心Y或中心X, 半径或中心Y, 参数或半径, 兼容参数) {
    let 来源单位 = 来源单位或Self;
    let 中心X = 中心X或来源单位;
    let 中心Y = 中心Y或中心X;
    let 半径 = 半径或中心Y;
    let 参数 = 参数或半径;
    if (兼容参数 != null) {
        来源单位 = 中心X或来源单位;
        中心X = 中心Y或中心X;
        中心Y = 半径或中心Y;
        半径 = 参数或半径;
        参数 = 兼容参数;
    }
    return AOE施加扩展控制(来源单位, 中心X, 中心Y, 半径, "charm", 参数);
}
export function 移除魅惑(目标单位或Self, 兼容目标单位) {
    return 移除扩展控制(兼容目标单位 ?? 目标单位或Self, "charm");
}
export function 单位是否被魅惑(目标单位或Self, 兼容目标单位) {
    return 单位是否处于扩展控制(兼容目标单位 ?? 目标单位或Self, "charm");
}
export function 获取魅惑来源单位(目标单位或Self, 兼容目标单位) {
    return 获取扩展控制来源单位(兼容目标单位 ?? 目标单位或Self, "charm");
}
export function 施加恐惧(来源单位或Self, 目标单位或来源单位, 参数或目标单位, 兼容参数) {
    let 来源单位 = 来源单位或Self;
    let 目标单位 = 目标单位或来源单位;
    let 参数 = 参数或目标单位;
    if (兼容参数 != null) {
        来源单位 = 目标单位或来源单位;
        目标单位 = 参数或目标单位;
        参数 = 兼容参数;
    }
    return 施加扩展控制(来源单位, 目标单位, "fear", 参数);
}
export function AOE施加恐惧(来源单位或Self, 中心X或来源单位, 中心Y或中心X, 半径或中心Y, 参数或半径, 兼容参数) {
    let 来源单位 = 来源单位或Self;
    let 中心X = 中心X或来源单位;
    let 中心Y = 中心Y或中心X;
    let 半径 = 半径或中心Y;
    let 参数 = 参数或半径;
    if (兼容参数 != null) {
        来源单位 = 中心X或来源单位;
        中心X = 中心Y或中心X;
        中心Y = 半径或中心Y;
        半径 = 参数或半径;
        参数 = 兼容参数;
    }
    return AOE施加扩展控制(来源单位, 中心X, 中心Y, 半径, "fear", 参数);
}
export function 移除恐惧(目标单位或Self, 兼容目标单位) {
    return 移除扩展控制(兼容目标单位 ?? 目标单位或Self, "fear");
}
export function 单位是否被恐惧(目标单位或Self, 兼容目标单位) {
    return 单位是否处于扩展控制(兼容目标单位 ?? 目标单位或Self, "fear");
}
export function 获取恐惧来源单位(目标单位或Self, 兼容目标单位) {
    return 获取扩展控制来源单位(兼容目标单位 ?? 目标单位或Self, "fear");
}
