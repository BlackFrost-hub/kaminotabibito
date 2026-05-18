local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setSlow = ____require_result_2.SFB_setSlow
local ____jass_3 = jass
local GetHandleId = ____jass_3.GetHandleId
local GetUnitState = ____jass_3.GetUnitState
local GetUnitX = ____jass_3.GetUnitX
local GetUnitY = ____jass_3.GetUnitY
local GetUnitName = ____jass_3.GetUnitName
local GetOwningPlayer = ____jass_3.GetOwningPlayer
local UnitDamageTarget = ____jass_3.UnitDamageTarget
local CreateTimer = ____jass_3.CreateTimer
local DestroyTimer = ____jass_3.DestroyTimer
local GetExpiredTimer = ____jass_3.GetExpiredTimer
local TimerStart = ____jass_3.TimerStart
local UNIT_STATE_LIFE = ____jass_3.UNIT_STATE_LIFE
local ATTACK_TYPE_NORMAL = ____jass_3.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_POISON = ____jass_3.DAMAGE_TYPE_POISON
local WEAPON_TYPE_WHOKNOWS = ____jass_3.WEAPON_TYPE_WHOKNOWS
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_4["创建原生弹幕"]
local _____6697_5F71_7A81_88ADBuffID = "C025"
local _____6697_5F71_7A81_88AD_56FE_6807 = "ReplaceableTextures\\CommandButtons\\BTNShadowStrike.blp"
local _____6697_5F71_7A81_88AD_7279_6548 = "AbilitiesSpellsNightElfshadowstrikeshadowstrike.mdl"
local _____6697_5F71_7A81_88AD_5F39_5E55_6A21_578B = "AbilitiesSpellsNightElfshadowstrikeShadowStrikeMissile.mdl"
local _____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868 = {}
local _____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868 = {}
local function _____6697_5F71_7A81_88AD_6BD2_7D20_7ED3_675F()
    local timer = GetExpiredTimer(nil)
    local timerId = GetHandleId(nil, timer)
    __TS__Delete(_____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868, timerId)
    DestroyTimer(nil, timer)
end
local function _____6697_5F71_7A81_88AD_6BD2_7D20tick()
    local timer = GetExpiredTimer(nil)
    local timerId = GetHandleId(nil, timer)
    local state = _____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868[timerId]
    if state == nil then
        DestroyTimer(nil, timer)
        return
    end
    if state.remainingTicks <= 0 then
        _____6697_5F71_7A81_88AD_6BD2_7D20_7ED3_675F()
        return
    end
    state.remainingTicks = state.remainingTicks - 1
    local target = state.target
    if target ~= nil and target ~= 0 and GetUnitState(nil, target, UNIT_STATE_LIFE) > 0.405 then
        local targetHid = GetHandleId(nil, target)
        _____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[targetHid] = (_____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[targetHid] or 0) + 1
        UnitDamageTarget(
            nil,
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
____exports["是否为暗影突袭毒素伤害"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local hid = GetHandleId(nil, unit)
    return (_____6697_5F71_7A81_88AD_6BD2_7D20_6807_8BB0_8868[hid] or 0) > 0
end
____exports["标记暗影突袭毒素伤害"] = function(unit, callback)
    if unit == nil or unit == 0 then
        callback()
        return
    end
    local hid = GetHandleId(nil, unit)
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
    local slowAttack = _____53C2_6570.slowAttack or 30
    local slowMove = _____53C2_6570.slowMove or 30
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
        _____53C2_6570.buffID or _____6697_5F71_7A81_88ADBuffID,
        duration,
        0,
        {
            sourceName = _____53C2_6570.sourceName or GetUnitName(nil, source),
            iconOverride = _____53C2_6570.iconOverride or _____6697_5F71_7A81_88AD_56FE_6807,
            effectModelOverride = _____53C2_6570.effectModelOverride or _____6697_5F71_7A81_88AD_7279_6548
        }
    )
    SFB_setSlow(
        source,
        target,
        slowAttack,
        slowMove,
        duration
    )
    local timer = CreateTimer(nil)
    local timerId = GetHandleId(nil, timer)
    _____6697_5F71_7A81_88AD_6BD2_7D20_8BA1_65F6_8868[timerId] = {
        source = source,
        target = target,
        remainingTicks = math.max(
            1,
            math.ceil(duration)
        ),
        damagePerTick = damagePerSecond
    }
    TimerStart(
        nil,
        timer,
        1,
        true,
        _____6697_5F71_7A81_88AD_6BD2_7D20tick
    )
end
____exports["创建暗影突袭追踪"] = function(source, target, _____53C2_6570)
    if _____53C2_6570 == nil then
        _____53C2_6570 = {}
    end
    if source == nil or source == 0 or target == nil or target == 0 then
        return
    end
    local function _____6697_5F71_7A81_88AD_5F39_5E55_547D_4E2D(_____547D_4E2D_5355_4F4D)
        ____exports["施加暗影突袭减益"](source, _____547D_4E2D_5355_4F4D, _____53C2_6570["减益"] or ({}))
    end
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = source,
        X = GetUnitX(nil, source),
        Y = GetUnitY(nil, source),
        ["速度"] = _____53C2_6570["速度"] or 1500,
        ["轨迹类型"] = _____53C2_6570["轨迹类型"] or "追踪",
        ["指定目标"] = target,
        ["命中半径"] = _____53C2_6570["命中半径"] or 80,
        ["生命周期"] = _____53C2_6570["生命周期"] or 4,
        ["碰撞消失"] = true,
        ["最大距离"] = _____53C2_6570["最大距离"] or 5000,
        ["模型"] = _____53C2_6570["模型"] or _____6697_5F71_7A81_88AD_5F39_5E55_6A21_578B,
        ["on命中单位"] = _____6697_5F71_7A81_88AD_5F39_5E55_547D_4E2D
    })
end
return ____exports
