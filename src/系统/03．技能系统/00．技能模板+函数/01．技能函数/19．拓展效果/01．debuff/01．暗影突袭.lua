local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_2.getBuffRuntime
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setSlow = ____require_result_3.SFB_setSlow
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_4["创建原生弹幕"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index")
local _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9 = ____require_result_5["创建追踪插值轨迹"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isSameUnit = ____require_result_6.isSameUnit
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitName = jass.GetUnitName
local UnitDamageTarget = jass.UnitDamageTarget
local CreateTimer = jass.CreateTimer
local DestroyTimer = jass.DestroyTimer
local GetExpiredTimer = jass.GetExpiredTimer
local TimerStart = jass.TimerStart
local R2I = jass.R2I
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6697_5F71_7A81_88ADBuffID = "C025"
local _____6697_5F71_7A81_88AD_5F39_5E55_6A21_578B = "Abilities\\Spells\\NightElf\\shadowstrike\\ShadowStrikeMissile.mdl"
local function _____8BFB_53D6Buff_56FE_6807(BuffID)
    local meta = buffTableMod.buffs[BuffID]
    return meta ~= nil and meta.icon ~= nil and meta.icon ~= "" and meta.icon or nil
end
local function _____8BFB_53D6Buff_7279_6548(BuffID)
    local meta = buffTableMod.buffs[BuffID]
    return meta ~= nil and meta.effect ~= nil and meta.effect ~= "" and meta.effect or nil
end
local _____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868 = {}
local _____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868 = {}
local function _____6697_5F71_7A81_88AD_5411_4E0A_53D6_6574_79D2_6570(duration)
    local _____6574_79D2 = R2I(duration)
    if duration > _____6574_79D2 then
        return _____6574_79D2 + 1
    end
    return _____6574_79D2 > 0 and _____6574_79D2 or 1
end
local function _____6697_5F71_7A81_88AD_6BD2_7D20_7ED3_675F()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)
    __TS__Delete(_____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868, timerId)
    DestroyTimer(timer)
end
local function _____6697_5F71_7A81_88AD_6BD2_7D20tick()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)
    local state = _____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868[timerId]
    if state == nil then
        DestroyTimer(timer)
        return
    end
    if getBuffRuntime(state.target, state.buffID) == nil then
        _____6697_5F71_7A81_88AD_6BD2_7D20_7ED3_675F()
        return
    end
    if state.remainingTicks <= 0 then
        _____6697_5F71_7A81_88AD_6BD2_7D20_7ED3_675F()
        return
    end
    state.remainingTicks = state.remainingTicks - 1
    local target = state.target
    if target ~= nil and target ~= 0 and GetUnitState(target, UNIT_STATE_LIFE) > 0.405 then
        local targetHid = GetHandleId(target)
        _____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[targetHid] = (_____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[targetHid] or 0) + 1
        debugLogForce(
            "暗影突袭",
            "毒素tick",
            "source:",
            state.source,
            "target:",
            target,
            "damage:",
            state.damagePerTick,
            "remaining:",
            state.remainingTicks
        )
        UnitDamageTarget(
            state.source,
            target,
            state.damagePerTick,
            false,
            false,
            ATTACK_TYPE_NORMAL,
            DAMAGE_TYPE_POISON,
            WEAPON_TYPE_WHOKNOWS
        )
        local current = _____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[targetHid] or 0
        if current <= 1 then
            __TS__Delete(_____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868, targetHid)
        else
            _____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[targetHid] = current - 1
        end
    end
    if state.remainingTicks <= 0 then
        _____6697_5F71_7A81_88AD_6BD2_7D20_7ED3_675F()
    end
end
local function ____on_6697_5F71_7A81_88ADBuff_79FB_9664(unit, buffID, _row)
    if unit == nil or unit == 0 or buffID == "" then
        return
    end
    for key in pairs(_____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868) do
        do
            local state = _____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868[key]
            if state == nil then
                goto __continue17
            end
            if state.target ~= unit or state.buffID ~= buffID then
                goto __continue17
            end
            __TS__Delete(_____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868, key)
        end
        ::__continue17::
    end
end
____exports["是否为暗影突袭毒素伤害"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local hid = GetHandleId(unit)
    return (_____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[hid] or 0) > 0
end
____exports["标记暗影突袭毒素伤害"] = function(unit, callback)
    if unit == nil or unit == 0 then
        callback()
        return
    end
    local hid = GetHandleId(unit)
    _____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[hid] = (_____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[hid] or 0) + 1
    do
        local ____try, ____error = pcall(function()
            callback()
        end)
        do
            local current = _____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[hid] or 0
            if current <= 1 then
                __TS__Delete(_____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868, hid)
            else
                _____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[hid] = current - 1
            end
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
____exports["施加暗影突袭减益"] = function(source, target, _____53C2_6570)
    if _____53C2_6570 == nil then
        _____53C2_6570 = {}
    end
    if source == nil or source == 0 or target == nil or target == 0 then
        return
    end
    local duration = _____53C2_6570.duration or 2
    local damagePerSecond = _____53C2_6570.damagePerSecond or 500
    local slowAttack = _____53C2_6570.slowAttack or 0.3
    local slowMove = _____53C2_6570.slowMove or 0.3
    local buffID = _____53C2_6570.buffID or _____6697_5F71_7A81_88ADBuffID
    debugLogForce(
        "暗影突袭",
        "施加减益",
        "source:",
        source,
        "target:",
        target,
        "duration:",
        duration,
        "dps:",
        damagePerSecond
    )
    registerManualBuff(
        target,
        buffID,
        duration,
        0,
        {
            sourceName = _____53C2_6570.sourceName or GetUnitName(source),
            iconOverride = _____53C2_6570.iconOverride or _____8BFB_53D6Buff_56FE_6807(buffID),
            effectModelOverride = _____53C2_6570.effectModelOverride or _____8BFB_53D6Buff_7279_6548(buffID),
            onRemove = ____on_6697_5F71_7A81_88ADBuff_79FB_9664
        }
    )
    SFB_setSlow(
        source,
        target,
        slowAttack,
        slowMove,
        duration
    )
    local timer = CreateTimer()
    local timerId = GetHandleId(timer)
    _____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868[timerId] = {
        source = source,
        target = target,
        buffID = buffID,
        remainingTicks = _____6697_5F71_7A81_88AD_5411_4E0A_53D6_6574_79D2_6570(duration),
        damagePerTick = damagePerSecond
    }
    TimerStart(timer, 1, true, _____6697_5F71_7A81_88AD_6BD2_7D20tick)
end
____exports["创建暗影突袭追踪"] = function(source, target, _____53C2_6570)
    if _____53C2_6570 == nil then
        _____53C2_6570 = {}
    end
    if source == nil or source == 0 or target == nil or target == 0 then
        return
    end
    debugLogForce(
        "暗影突袭",
        "准备创建追踪弹幕",
        "source:",
        source,
        "target:",
        target,
        "sourcePos=(",
        GetUnitX(source),
        ",",
        GetUnitY(source),
        ")",
        "targetPos=(",
        GetUnitX(target),
        ",",
        GetUnitY(target),
        ")"
    )
    local _____5DF2_65BD_52A0 = false
    local function _____6697_5F71_7A81_88AD_5F39_5E55_547D_4E2D(_____547D_4E2D_5355_4F4D)
        if _____5DF2_65BD_52A0 then
            return
        end
        _____5DF2_65BD_52A0 = true
        debugLogForce(
            "暗影突袭",
            "弹幕命中",
            "source:",
            source,
            "target:",
            _____547D_4E2D_5355_4F4D
        )
        ____exports["施加暗影突袭减益"](source, _____547D_4E2D_5355_4F4D, _____53C2_6570["减益"] or ({}))
    end
    local function _____6697_5F71_7A81_88AD_5230_8FBE_76EE_6807_70B9()
        if _____5DF2_65BD_52A0 then
            return
        end
        if target == nil or target == 0 then
            return
        end
        _____5DF2_65BD_52A0 = true
        debugLogForce(
            "暗影突袭",
            "到达目标点补命中",
            "source:",
            source,
            "target:",
            target
        )
        ____exports["施加暗影突袭减益"](source, target, _____53C2_6570["减益"] or ({}))
    end
    local function _____6697_5F71_7A81_88AD_7ED3_675F(_____539F_56E0)
        debugLogForce(
            "暗影突袭",
            "结束",
            "source:",
            source,
            "target:",
            target,
            "原因:",
            _____539F_56E0
        )
    end
    local function _____6697_5F71_7A81_88AD_76EE_6807_7B5B_9009(_____76EE_6807_5355_4F4D)
        return isSameUnit(_____76EE_6807_5355_4F4D, target)
    end
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = source,
        X = GetUnitX(source),
        Y = GetUnitY(source),
        ["方向角"] = GetUnitFacing(source),
        ["指定目标"] = target,
        ["速度"] = _____53C2_6570["速度"] or 1500,
        ["轨迹采样器"] = _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9(target, _____53C2_6570["命中半径"] or 100),
        ["命中半径"] = _____53C2_6570["命中半径"] or 100,
        ["生命周期"] = _____53C2_6570["生命周期"] or 8,
        ["碰撞消失"] = true,
        ["最大距离"] = _____53C2_6570["最大距离"] or 5000,
        ["模型"] = _____53C2_6570["模型"] or _____6697_5F71_7A81_88AD_5F39_5E55_6A21_578B,
        ["附着特效模型"] = _____53C2_6570["模型"] or _____6697_5F71_7A81_88AD_5F39_5E55_6A21_578B,
        ["影响目标"] = "全部",
        ["目标筛选"] = _____6697_5F71_7A81_88AD_76EE_6807_7B5B_9009,
        ["最大总命中次数"] = 1,
        ["每单位最大命中次数"] = 1,
        ["on到达目标点"] = _____6697_5F71_7A81_88AD_5230_8FBE_76EE_6807_70B9,
        ["on命中"] = _____6697_5F71_7A81_88AD_5F39_5E55_547D_4E2D,
        ["on命中单位"] = _____6697_5F71_7A81_88AD_5F39_5E55_547D_4E2D,
        ["on结束"] = _____6697_5F71_7A81_88AD_7ED3_675F
    })
end
return ____exports
