--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0EYDWE_51FD_6570 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWESetUnitAbilityDataReal = ____00_FF0EYDWE_51FD_6570.YDWESetUnitAbilityDataReal
local EXSetUnitFacing = ____00_FF0EYDWE_51FD_6570.EXSetUnitFacing
local ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local GS_Suspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_Suspend
local ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570 = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local SUC_IsUnitStructure = ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570.SUC_IsUnitStructure
local SUC_IsValidUnit = ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570.SUC_IsValidUnit
--- Star扩展库 - 快速Buff系统
-- 
-- 提供快速施加控制效果的功能，支持击晕、冰冻、沉默、变形、隐身、缴械等。
-- 需要预先创建马甲单位 SFB_Unit 和相关技能。
-- 
-- 所有接口均接受 sourceUnit（来源单位）参数，用于在 BuffUI 中显示来源信息：
-- - sourceName：来源单位名称
-- 
-- 使用方式：
-- - 直接调用 SFB_setBuff / SFB_setSlow 即可，不需要在外部额外调用 SFB_Init。
-- - SFB_Init 由系统内部自行管理，外部请勿重复调用，否则会泄漏马甲单位。
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local ____require_result_2 = require("系统.05．Buff系统.01．控制抗性.02．控制时间计算")
local calcReducedControlDuration = ____require_result_2.calcReducedControlDuration
local function sym(name)
    local ____G_name_4 = _G[name]
    if ____G_name_4 == nil then
        local ____jglobals_3
        if jglobals then
            ____jglobals_3 = jglobals[name]
        else
            ____jglobals_3 = nil
        end
        ____G_name_4 = ____jglobals_3
    end
    local ____G_name_4_6 = ____G_name_4
    if ____G_name_4_6 == nil then
        local ____jass_5
        if jass then
            ____jass_5 = jass[name]
        else
            ____jass_5 = nil
        end
        ____G_name_4_6 = ____jass_5
    end
    return ____G_name_4_6
end
local function getYDHT()
    local ____sym_result_7 = sym("StarBaseHT")
    if ____sym_result_7 == nil then
        ____sym_result_7 = sym("YDHASH_HANDLE")
    end
    local ____sym_result_7_8 = ____sym_result_7
    if ____sym_result_7_8 == nil then
        ____sym_result_7_8 = sym("YDHT")
    end
    local ____sym_result_7_8_9 = ____sym_result_7_8
    if ____sym_result_7_8_9 == nil then
        ____sym_result_7_8_9 = sym("udg_YDHASH_HANDLE")
    end
    local ____sym_result_7_8_9_10 = ____sym_result_7_8_9
    if ____sym_result_7_8_9_10 == nil then
        ____sym_result_7_8_9_10 = sym("udg_YDHT")
    end
    return ____sym_result_7_8_9_10
end
local YDHT = getYDHT()
____exports.SFB_Unit = nil
local SFB_UNIT_ID = 1648915822
local ABILITY = {
    STUN = 1095975472,
    FREEZE = 1095975476,
    SILENCE = 1095975480,
    POLYMORPH = 1095975545,
    INVIS = 1095975512,
    SLOW = 1095975481
}
local ORDER = {
    STUN = "thunderbolt",
    FREEZE = "creepthunderbolt",
    SILENCE = "silence",
    POLYMORPH = "polymorph",
    INVIS = "invisibility",
    SLOW = 852075
}
local SFB_BUFF_ID = {
    [0] = "C001",
    [1] = "C002",
    [2] = "C003",
    [3] = "C004",
    [4] = "C005",
    [5] = "C006",
    [7] = "C007",
    [21] = "C008",
    [22] = "C009",
    [23] = "C010"
}
local function getUnitSourceName(sourceUnit)
    if sourceUnit == nil or sourceUnit == 0 then
        return ""
    end
    local n = jass.GetUnitName(sourceUnit)
    return type(n) == "string" and n ~= "" and n or ""
end
local function shouldApplyControlReduction(id)
    return id == 0 or id == 1 or id == 2 or id == 5
end
local function getAngleBetweenUnits(u, tu)
    return jass.Atan2(
        jass.GetUnitY(tu) - jass.GetUnitY(u),
        jass.GetUnitX(tu) - jass.GetUnitX(u)
    )
end
function ____exports.SFB_Init()
    if ____exports.SFB_Unit ~= nil and ____exports.SFB_Unit ~= 0 then
        return
    end
    ____exports.SFB_Unit = jass.CreateUnit(
        jass.Player(15),
        SFB_UNIT_ID,
        0,
        0,
        0
    )
    jass.UnitAddAbility(____exports.SFB_Unit, ABILITY.POLYMORPH)
    jass.UnitAddAbility(____exports.SFB_Unit, ABILITY.STUN)
    jass.UnitAddAbility(____exports.SFB_Unit, ABILITY.SLOW)
    jass.UnitAddAbility(____exports.SFB_Unit, ABILITY.SILENCE)
    jass.UnitAddAbility(____exports.SFB_Unit, ABILITY.INVIS)
    jass.UnitAddAbility(____exports.SFB_Unit, ABILITY.FREEZE)
    _G.SFB_Unit = ____exports.SFB_Unit
end
local function onSfbPauseTimerExpire()
    local t = jass.GetExpiredTimer()
    jass.PauseUnit(
        jass.LoadUnitHandle(
            YDHT,
            jass.GetHandleId(t),
            jass.StringHash("单位")
        ),
        false
    )
    jass.RemoveSavedHandle(
        YDHT,
        jass.GetHandleId(t),
        jass.StringHash("单位")
    )
    safeDestroyTimer(nil, t)
end
local function onSfbExpauseTimerExpire()
    local t = jass.GetExpiredTimer()
    japi.EXPauseUnit(
        jass.LoadUnitHandle(
            YDHT,
            jass.GetHandleId(t),
            jass.StringHash("单位")
        ),
        false
    )
    jass.RemoveSavedHandle(
        YDHT,
        jass.GetHandleId(t),
        jass.StringHash("单位")
    )
    safeDestroyTimer(nil, t)
end
--- 设置单位Buff效果
-- 
-- @param sourceUnit 来源单位（用于BuffUI显示来源信息和玩家名）
-- @param u 目标单位
-- @param id Buff类型：
-- 0=击晕, 1=冰冻, 2=沉默, 3=变形, 4=隐身, 5=缴械
-- 21=硬直, 22=暂停, 23=EX暂停
-- @param time 持续时间（秒）
function ____exports.SFB_setBuff(sourceUnit, u, id, time)
    if not SUC_IsValidUnit(nil, u) or time == 0 then
        return
    end
    if SUC_IsUnitStructure(nil, u) then
        return
    end
    if u == ____exports.SFB_Unit then
        return
    end
    if time <= 0 then
        return
    end
    local sourceName = getUnitSourceName(sourceUnit)
    if shouldApplyControlReduction(id) then
        time = calcReducedControlDuration(nil, u, time)
        if time <= 0 then
            return
        end
    end
    if id >= 21 then
        local buffID = SFB_BUFF_ID[id]
        if buffID ~= nil and buffID ~= "" then
            registerManualBuff(
                nil,
                u,
                buffID,
                time,
                0,
                {sourceName = sourceName}
            )
        end
        if id == 21 then
            GS_Suspend(u, time)
        elseif id == 22 then
            local tempTimer = jass.CreateTimer()
            jass.SaveUnitHandle(
                YDHT,
                jass.GetHandleId(tempTimer),
                jass.StringHash("单位"),
                u
            )
            jass.PauseUnit(u, true)
            safeTimerStart(
                nil,
                tempTimer,
                time,
                false,
                onSfbPauseTimerExpire
            )
        elseif id == 23 then
            local tempTimer = jass.CreateTimer()
            jass.SaveUnitHandle(
                YDHT,
                jass.GetHandleId(tempTimer),
                jass.StringHash("单位"),
                u
            )
            japi.EXPauseUnit(u, true)
            safeTimerStart(
                nil,
                tempTimer,
                time,
                false,
                onSfbExpauseTimerExpire
            )
        end
        return
    end
    local caster = ____exports.SFB_Unit
    if caster == nil or caster == 0 then
        return
    end
    local fac = getAngleBetweenUnits(caster, u)
    EXSetUnitFacing(nil, caster, fac)
    jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac)
    local abilityId
    local orderStr
    repeat
        local ____switch25 = id
        local ____cond25 = ____switch25 == 0
        if ____cond25 then
            abilityId = ABILITY.STUN
            orderStr = ORDER.STUN
            break
        end
        ____cond25 = ____cond25 or ____switch25 == 1
        if ____cond25 then
            abilityId = ABILITY.FREEZE
            orderStr = ORDER.FREEZE
            break
        end
        ____cond25 = ____cond25 or ____switch25 == 2
        if ____cond25 then
            abilityId = ABILITY.SILENCE
            orderStr = ORDER.SILENCE
            YDWESetUnitAbilityDataReal(
                nil,
                caster,
                abilityId,
                1,
                108,
                8
            )
            break
        end
        ____cond25 = ____cond25 or ____switch25 == 3
        if ____cond25 then
            abilityId = ABILITY.POLYMORPH
            orderStr = ORDER.POLYMORPH
            break
        end
        ____cond25 = ____cond25 or ____switch25 == 4
        if ____cond25 then
            abilityId = ABILITY.INVIS
            orderStr = ORDER.INVIS
            break
        end
        ____cond25 = ____cond25 or ____switch25 == 5
        if ____cond25 then
            abilityId = ABILITY.SILENCE
            orderStr = ORDER.SILENCE
            YDWESetUnitAbilityDataReal(
                nil,
                caster,
                abilityId,
                1,
                108,
                7
            )
            break
        end
        do
            return
        end
    until true
    YDWESetUnitAbilityDataReal(
        nil,
        caster,
        abilityId,
        1,
        102,
        time
    )
    YDWESetUnitAbilityDataReal(
        nil,
        caster,
        abilityId,
        1,
        103,
        time
    )
    local buffID = SFB_BUFF_ID[id]
    if buffID ~= nil and buffID ~= "" then
        registerManualBuff(
            nil,
            u,
            buffID,
            time,
            0,
            {sourceName = sourceName}
        )
    end
    if type(orderStr) == "string" then
        jass.IssueTargetOrder(caster, orderStr, u)
    else
        jass.IssueTargetOrderById(caster, orderStr, u)
    end
end
--- 设置单位减速效果
-- 
-- @param sourceUnit 来源单位（用于BuffUI显示来源信息和玩家名）
-- @param u 目标单位
-- @param as 降低攻速百分比
-- @param ms 降低移速百分比
-- @param time 持续时间（秒）
function ____exports.SFB_setSlow(sourceUnit, u, as, ms, time)
    if not SUC_IsValidUnit(nil, u) or time == 0 then
        return
    end
    if SUC_IsUnitStructure(nil, u) then
        return
    end
    if u == ____exports.SFB_Unit then
        return
    end
    if time <= 0 then
        return
    end
    local caster = ____exports.SFB_Unit
    if caster == nil or caster == 0 then
        return
    end
    local fac = getAngleBetweenUnits(caster, u)
    EXSetUnitFacing(nil, caster, fac)
    jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac)
    YDWESetUnitAbilityDataReal(
        nil,
        caster,
        ABILITY.SLOW,
        1,
        108,
        ms
    )
    YDWESetUnitAbilityDataReal(
        nil,
        caster,
        ABILITY.SLOW,
        1,
        109,
        as
    )
    YDWESetUnitAbilityDataReal(
        nil,
        caster,
        ABILITY.SLOW,
        1,
        102,
        time
    )
    YDWESetUnitAbilityDataReal(
        nil,
        caster,
        ABILITY.SLOW,
        1,
        103,
        time
    )
    local sourceName = getUnitSourceName(sourceUnit)
    registerManualBuff(
        nil,
        u,
        "C007",
        time,
        ms,
        {sourceName = sourceName}
    )
    jass.IssueTargetOrderById(caster, ORDER.SLOW, u)
end
____exports.SFB_Init()
return ____exports
