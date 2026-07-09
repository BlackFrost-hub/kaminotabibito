local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0EYDWE_51FD_6570 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWESetUnitAbilityDataReal = ____00_FF0EYDWE_51FD_6570.YDWESetUnitAbilityDataReal
local EXSetUnitFacing = ____00_FF0EYDWE_51FD_6570.EXSetUnitFacing
local ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local GS_Suspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_Suspend
local _____7533_8BF7_5355_4F4D_6682_505C_5360_7528_5B9A_65F6 = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF["申请单位暂停占用定时"]
local ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570 = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local SUC_IsUnitStructure = ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570.SUC_IsUnitStructure
local SUC_IsValidUnit = ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570.SUC_IsValidUnit
--- Star扩展库 - 快速Buff系统共享层
-- 
-- 放这里的内容：
-- - 共享状态
-- - 常量与 Buff 映射
-- - 来源显示解析
-- - 马甲初始化与底层施加逻辑
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local ydweObject = require("lib.扩展函数.YDWE函数.index")
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local miscBj = require("lib.扩展函数.BJ函数.07．杂项")
local fourCcUtil = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local ____require_result_3 = require("系统.05．Buff系统.01．控制抗性.02．控制时间计算")
local calcReducedControlDuration = ____require_result_3.calcReducedControlDuration
local unitRelated = require("lib.扩展函数.自定义扩展函数.00．单位相关")
local _____83B7_53D6_5BF9_8C61_5C5E_6027 = ydweObject.getObjectProperty
local _____7269_4F53_7C7B_578B = ydweObject.ObjectType
local _____5B57_7B26_4E32_8F6C_547D_4EE4ID = miscBj.String2OrderIdBJ
local _____56DB_8272_7801_8F6C_5B57_7B26_4E32 = fourCcUtil.fourCCToString
local _____83B7_53D6_73A9_5BB6_9996_4E2A_82F1_96C4 = unitRelated.getPlayerFirstHero
local YDUserDataGet = YDUserDataGetSafe
local YDUserDataSet = YDUserDataSetSafe
local function sym(name)
    local ____G_name_5 = _G[name]
    if ____G_name_5 == nil then
        local ____jglobals_4
        if jglobals then
            ____jglobals_4 = jglobals[name]
        else
            ____jglobals_4 = nil
        end
        ____G_name_5 = ____jglobals_4
    end
    local ____G_name_5_7 = ____G_name_5
    if ____G_name_5_7 == nil then
        local ____jass_6
        if jass then
            ____jass_6 = jass[name]
        else
            ____jass_6 = nil
        end
        ____G_name_5_7 = ____jass_6
    end
    return ____G_name_5_7
end
local function getYDHT()
    local ____sym_result_8 = sym("StarBaseHT")
    if ____sym_result_8 == nil then
        ____sym_result_8 = sym("YDHASH_HANDLE")
    end
    local ____sym_result_8_9 = ____sym_result_8
    if ____sym_result_8_9 == nil then
        ____sym_result_8_9 = sym("YDHT")
    end
    local ____sym_result_8_9_10 = ____sym_result_8_9
    if ____sym_result_8_9_10 == nil then
        ____sym_result_8_9_10 = sym("udg_YDHASH_HANDLE")
    end
    local ____sym_result_8_9_10_11 = ____sym_result_8_9_10
    if ____sym_result_8_9_10_11 == nil then
        ____sym_result_8_9_10_11 = sym("udg_YDHT")
    end
    return ____sym_result_8_9_10_11
end
____exports.YDHT = getYDHT()
____exports.SFB_Unit = nil
local SFB_UNIT_ID = 1648915822
local UnitAddAbility = jass.UnitAddAbility
local GetHandleId = jass.GetHandleId
____exports.IssueTargetOrder = jass.IssueTargetOrder
____exports.IssueTargetOrderById = jass.IssueTargetOrderById
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local ____SFB__5DF2_6DFB_52A0_6280_80FD = {}
____exports.ABILITY = {
    STUN = 1095975472,
    FREEZE = 1095975476,
    SILENCE = 1095975480,
    POLYMORPH = 1095975545,
    INVIS = 1095975512,
    SLOW = 1095975481,
    ITEM_ILLUSION = 1095977292,
    INNER_FIRE = 1095975497,
    BLOODLUST = 1095975500,
    CRIPPLE = 1095975491,
    FAERIE_FIRE = 1095975494,
    CURSE = 1095975506,
    SLEEP = 1095975507,
    ENTANGLING_ROOTS = 1095975508,
    CYCLONE = 1095975496,
    PARASITE = 1095975504
}
____exports.ORDER = {
    STUN = "thunderbolt",
    FREEZE = "creepthunderbolt",
    SILENCE = "silence",
    POLYMORPH = "polymorph",
    INVIS = "invisibility",
    ITEM_ILLUSION = 852274,
    SLOW = 852075,
    INNER_FIRE = "innerfire",
    BLOODLUST = "bloodlust",
    CRIPPLE = "cripple",
    FAERIE_FIRE = "faeriefire",
    CURSE = "curse",
    SLEEP = "sleep",
    ENTANGLING_ROOTS = "entanglingroots",
    CYCLONE = "cyclone",
    PARASITE = "parasite"
}
____exports["SFB_增益BUFF"] = {["心灵之火"] = 31, ["嗜血术"] = 32}
____exports["SFB_负面BUFF"] = {
    ["残废"] = 41,
    ["精灵之火"] = 42,
    ["诅咒"] = 43,
    ["睡眠"] = 44,
    ["纠缠根须"] = 45,
    ["飓风"] = 46,
    ["寄生"] = 47
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
    [23] = "C010",
    [31] = "C011",
    [32] = "C012",
    [41] = "C013",
    [42] = "C014",
    [43] = "C015",
    [44] = "C016",
    [45] = "C017",
    [46] = "C018",
    [47] = "C024"
}
local NATIVE_BUFF = {
    STUN = 1112560453,
    FREEZE = 1114010234,
    SILENCE = 1112437609,
    POLYMORPH = 1114664057,
    INVIS = 1114205814,
    SLOW = 1114860655,
    INNER_FIRE = 1114205798,
    BLOODLUST = 1113746543,
    CRIPPLE = 1113813609,
    FAERIE_FIRE = 1114005861,
    CURSE = 1113813619,
    SLEEP_MAIN = 1112896364,
    SLEEP_PAUSE = 1112896368,
    SLEEP_STUN = 1114993524,
    ENTANGLING_ROOTS = 1111844210,
    CYCLONE_MAIN = 1113815395,
    CYCLONE_EXTRA = 1113815346,
    PARASITE = 1112436833,
    ITEM_ILLUSION = 1112107372
}
local abilityOrderIdCache = {}
local SFB_NATIVE_BUFF_IDS = {
    [0] = {NATIVE_BUFF.STUN},
    [1] = {NATIVE_BUFF.FREEZE},
    [2] = {NATIVE_BUFF.SILENCE},
    [3] = {NATIVE_BUFF.POLYMORPH},
    [4] = {NATIVE_BUFF.INVIS},
    [5] = {NATIVE_BUFF.SILENCE},
    [7] = {NATIVE_BUFF.SLOW},
    [31] = {NATIVE_BUFF.INNER_FIRE},
    [32] = {NATIVE_BUFF.BLOODLUST},
    [41] = {NATIVE_BUFF.CRIPPLE},
    [42] = {NATIVE_BUFF.FAERIE_FIRE},
    [43] = {NATIVE_BUFF.CURSE},
    [44] = {NATIVE_BUFF.SLEEP_MAIN, NATIVE_BUFF.SLEEP_PAUSE, NATIVE_BUFF.SLEEP_STUN},
    [45] = {NATIVE_BUFF.ENTANGLING_ROOTS},
    [46] = {NATIVE_BUFF.CYCLONE_MAIN, NATIVE_BUFF.CYCLONE_EXTRA},
    [47] = {NATIVE_BUFF.PARASITE}
}
local function getBuffDisplaySourceUnit(sourceUnit)
    if sourceUnit == nil or sourceUnit == 0 then
        return ""
    end
    local owner = GetOwningPlayer(sourceUnit)
    if owner ~= nil and owner ~= 0 then
        local playerId = GetPlayerId(owner)
        if playerId >= 0 and playerId <= 5 then
            local hero = _____83B7_53D6_73A9_5BB6_9996_4E2A_82F1_96C4(owner)
            if hero ~= nil and hero ~= 0 then
                return hero
            end
        end
    end
    return sourceUnit
end
function ____exports.getUnitSourceName(sourceUnit, fallbackUnit)
    local displayUnit = getBuffDisplaySourceUnit(sourceUnit)
    if displayUnit == nil or displayUnit == 0 or displayUnit == "" then
        displayUnit = getBuffDisplaySourceUnit(fallbackUnit)
    end
    if displayUnit == nil or displayUnit == 0 then
        return ""
    end
    local n = GetUnitName(displayUnit)
    return type(n) == "string" and n ~= "" and n or ""
end
function ____exports.normalizeRealValue(value)
    if value == nil or value == false or value == "" then
        return 0
    end
    local n = type(value) == "number" and value or __TS__Number(value)
    return n ~= n and 0 or n
end
function ____exports.shouldApplyControlReduction(id)
    return id == 0 or id == 1 or id == 2 or id == 5 or id == ____exports["SFB_负面BUFF"]["睡眠"] or id == ____exports["SFB_负面BUFF"]["纠缠根须"] or id == ____exports["SFB_负面BUFF"]["飓风"]
end
function ____exports.registerSfbManualBuff(sourceUnit, u, id, time, effectValue)
    local buffID = SFB_BUFF_ID[id]
    if buffID == nil or buffID == "" then
        return
    end
    registerManualBuff(
        u,
        buffID,
        time,
        effectValue,
        {
            sourceName = ____exports.getUnitSourceName(sourceUnit, u),
            nativeBuffAbilityIds = SFB_NATIVE_BUFF_IDS[id]
        }
    )
end
function ____exports.getSfbBuffId(id)
    return SFB_BUFF_ID[id]
end
function ____exports.getAngleBetweenUnits(u, tu)
    return jass.Atan2(
        jass.GetUnitY(tu) - jass.GetUnitY(u),
        jass.GetUnitX(tu) - jass.GetUnitX(u)
    )
end
local function getAbilityOrderId(abilityId, fallbackOrderStr)
    local cached = abilityOrderIdCache[abilityId]
    if cached ~= nil and cached ~= 0 then
        return cached
    end
    if type(fallbackOrderStr) == "number" and fallbackOrderStr ~= 0 then
        abilityOrderIdCache[abilityId] = fallbackOrderStr
        return fallbackOrderStr
    end
    local abilityIdStr = _____56DB_8272_7801_8F6C_5B57_7B26_4E32(abilityId)
    local orderStr = abilityIdStr ~= "" and _____83B7_53D6_5BF9_8C61_5C5E_6027(_____7269_4F53_7C7B_578B.ABILITY, abilityIdStr, "Order") or ""
    if orderStr == nil or orderStr == "" then
        orderStr = fallbackOrderStr
    end
    if orderStr == nil or orderStr == "" then
        return 0
    end
    if type(orderStr) ~= "string" then
        return 0
    end
    local orderId = _____5B57_7B26_4E32_8F6C_547D_4EE4ID(orderStr)
    if orderId ~= 0 then
        abilityOrderIdCache[abilityId] = orderId
    end
    return orderId
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
    UnitAddAbility(____exports.SFB_Unit, ____exports.ABILITY.POLYMORPH)
    UnitAddAbility(____exports.SFB_Unit, ____exports.ABILITY.STUN)
    UnitAddAbility(____exports.SFB_Unit, ____exports.ABILITY.SLOW)
    UnitAddAbility(____exports.SFB_Unit, ____exports.ABILITY.SILENCE)
    UnitAddAbility(____exports.SFB_Unit, ____exports.ABILITY.INVIS)
    UnitAddAbility(____exports.SFB_Unit, ____exports.ABILITY.FREEZE)
    UnitAddAbility(____exports.SFB_Unit, ____exports.ABILITY.ITEM_ILLUSION)
    UnitAddAbility(____exports.SFB_Unit, ____exports.ABILITY.PARASITE)
    ____SFB__5DF2_6DFB_52A0_6280_80FD[____exports.ABILITY.POLYMORPH] = true
    ____SFB__5DF2_6DFB_52A0_6280_80FD[____exports.ABILITY.STUN] = true
    ____SFB__5DF2_6DFB_52A0_6280_80FD[____exports.ABILITY.SLOW] = true
    ____SFB__5DF2_6DFB_52A0_6280_80FD[____exports.ABILITY.SILENCE] = true
    ____SFB__5DF2_6DFB_52A0_6280_80FD[____exports.ABILITY.INVIS] = true
    ____SFB__5DF2_6DFB_52A0_6280_80FD[____exports.ABILITY.FREEZE] = true
    ____SFB__5DF2_6DFB_52A0_6280_80FD[____exports.ABILITY.ITEM_ILLUSION] = true
    ____SFB__5DF2_6DFB_52A0_6280_80FD[____exports.ABILITY.PARASITE] = true
    _G.SFB_Unit = ____exports.SFB_Unit
end
local function ____SFB__786E_4FDD_9A6C_7532_6280_80FD(abilityId)
    if ____SFB__5DF2_6DFB_52A0_6280_80FD[abilityId] then
        return true
    end
    local caster = ____exports.SFB_Unit
    if caster == nil or caster == 0 then
        return false
    end
    if not UnitAddAbility(caster, abilityId) then
        return false
    end
    ____SFB__5DF2_6DFB_52A0_6280_80FD[abilityId] = true
    return true
end
____exports["SFB_施加原生目标Buff"] = function(sourceUnit, u, id, time, abilityId, orderStr)
    if not SUC_IsValidUnit(u) or time <= 0 then
        return
    end
    if SUC_IsUnitStructure(u) then
        return
    end
    if u == ____exports.SFB_Unit then
        return
    end
    local caster = ____exports.SFB_Unit
    if caster == nil or caster == 0 then
        return
    end
    if not ____SFB__786E_4FDD_9A6C_7532_6280_80FD(abilityId) then
        return
    end
    local fac = ____exports.getAngleBetweenUnits(caster, u)
    EXSetUnitFacing(nil, caster, fac)
    jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac)
    SetUnitX(
        caster,
        GetUnitX(u)
    )
    SetUnitY(
        caster,
        GetUnitY(u)
    )
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
    if abilityId == ____exports.ABILITY.PARASITE then
        YDWESetUnitAbilityDataReal(
            nil,
            caster,
            abilityId,
            1,
            105,
            0
        )
        YDWESetUnitAbilityDataReal(
            nil,
            caster,
            abilityId,
            1,
            107,
            999999
        )
    end
    ____exports.registerSfbManualBuff(
        sourceUnit,
        u,
        id,
        time,
        0
    )
    ____exports.IssueTargetOrder(caster, orderStr, u)
end
____exports["SFB_施加原生目标技能"] = function(u, abilityId, orderStr, _____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 == nil then
        _____6301_7EED_65F6_95F4 = 0
    end
    if not SUC_IsValidUnit(u) then
        return false
    end
    if SUC_IsUnitStructure(u) then
        return false
    end
    if u == ____exports.SFB_Unit then
        return false
    end
    local caster = ____exports.SFB_Unit
    if caster == nil or caster == 0 then
        return false
    end
    if not ____SFB__786E_4FDD_9A6C_7532_6280_80FD(abilityId) then
        return false
    end
    local fac = ____exports.getAngleBetweenUnits(caster, u)
    EXSetUnitFacing(nil, caster, fac)
    jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac)
    if _____6301_7EED_65F6_95F4 > 0 then
        YDWESetUnitAbilityDataReal(
            nil,
            caster,
            abilityId,
            1,
            102,
            _____6301_7EED_65F6_95F4
        )
        YDWESetUnitAbilityDataReal(
            nil,
            caster,
            abilityId,
            1,
            103,
            _____6301_7EED_65F6_95F4
        )
    end
    local orderId = getAbilityOrderId(abilityId, orderStr)
    if orderId ~= 0 then
        return ____exports.IssueTargetOrderById(caster, orderId, u) == true
    end
    local ____temp_12
    if type(orderStr) == "string" then
        ____temp_12 = ____exports.IssueTargetOrder(caster, orderStr, u) == true
    else
        ____temp_12 = false
    end
    return ____temp_12
end
____exports["SFB_施加暂停类Buff"] = function(sourceUnit, u, id, time)
    ____exports.registerSfbManualBuff(
        sourceUnit,
        u,
        id,
        time,
        0
    )
    if id == 21 then
        GS_Suspend(u, time)
    elseif id == 22 then
        _____7533_8BF7_5355_4F4D_6682_505C_5360_7528_5B9A_65F6(u, "SFB_Pause", time, "刷新")
    elseif id == 23 then
        _____7533_8BF7_5355_4F4D_6682_505C_5360_7528_5B9A_65F6(u, "SFB_EXPause", time, "刷新")
    end
end
____exports.SFB_Init()
____exports.EXSetUnitFacing = EXSetUnitFacing
____exports.GetPlayerId = GetPlayerId
____exports.GetOwningPlayer = GetOwningPlayer
____exports.GS_Suspend = GS_Suspend
____exports.SUC_IsUnitStructure = SUC_IsUnitStructure
____exports.SUC_IsValidUnit = SUC_IsValidUnit
____exports.YDWESetUnitAbilityDataReal = YDWESetUnitAbilityDataReal
____exports.calcReducedControlDuration = calcReducedControlDuration
____exports.japi = japi
____exports.jass = jass
____exports.jglobals = jglobals
____exports.registerManualBuff = registerManualBuff
____exports.safeDestroyTimer = safeDestroyTimer
____exports.safeTimerStart = safeTimerStart
return ____exports
