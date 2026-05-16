--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04A_FF0E_5FEB_901FBuff_5171_4EAB = require("lib.扩展函数.Star扩展函数.Star扩展库.04A．快速Buff共享")
local ABILITY = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.ABILITY
local EXSetUnitFacing = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.EXSetUnitFacing
local IssueTargetOrder = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.IssueTargetOrder
local IssueTargetOrderById = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.IssueTargetOrderById
local ORDER = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.ORDER
local SFB_Init = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.SFB_Init
local ____SFB__65BD_52A0_539F_751F_76EE_6807_6280_80FD = ____04A_FF0E_5FEB_901FBuff_5171_4EAB["SFB_施加原生目标技能"]
local SFB_Unit = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.SFB_Unit
local ____SFB__589E_76CABUFF = ____04A_FF0E_5FEB_901FBuff_5171_4EAB["SFB_增益BUFF"]
local ____SFB__65BD_52A0_539F_751F_76EE_6807Buff = ____04A_FF0E_5FEB_901FBuff_5171_4EAB["SFB_施加原生目标Buff"]
local ____SFB__65BD_52A0_6682_505C_7C7BBuff = ____04A_FF0E_5FEB_901FBuff_5171_4EAB["SFB_施加暂停类Buff"]
local ____SFB__8D1F_9762BUFF = ____04A_FF0E_5FEB_901FBuff_5171_4EAB["SFB_负面BUFF"]
local SUC_IsUnitStructure = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.SUC_IsUnitStructure
local SUC_IsValidUnit = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.SUC_IsValidUnit
local YDWESetUnitAbilityDataReal = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.YDWESetUnitAbilityDataReal
local calcReducedControlDuration = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.calcReducedControlDuration
local getAngleBetweenUnits = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.getAngleBetweenUnits
local jass = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.jass
local jglobals = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.jglobals
local registerSfbManualBuff = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.registerSfbManualBuff
local shouldApplyControlReduction = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.shouldApplyControlReduction
local ____04C_FF0E_5FEB_901FBuff_8BC5_5492 = require("lib.扩展函数.Star扩展函数.Star扩展库.04C．快速Buff诅咒")
local ____SFB__65BD_52A0_81EA_5B9A_4E49_8BC5_5492Buff = ____04C_FF0E_5FEB_901FBuff_8BC5_5492["SFB_施加自定义诅咒Buff"]
local ____04D_FF0E_5FEB_901FBuff_5E7B_8C61_7269_54C1 = require("lib.扩展函数.Star扩展函数.Star扩展库.04D．快速Buff幻象物品")
local initItemIllusionSummonBridge = ____04D_FF0E_5FEB_901FBuff_5E7B_8C61_7269_54C1.initItemIllusionSummonBridge
local ____SFB__6E05_7A7A_5E7B_8C61_7269_54C1_4E0A_4E0B_6587 = ____04D_FF0E_5FEB_901FBuff_5E7B_8C61_7269_54C1["SFB_清空幻象物品上下文"]
local ____SFB__8BB0_5F55_5E7B_8C61_7269_54C1_4E0A_4E0B_6587 = ____04D_FF0E_5FEB_901FBuff_5E7B_8C61_7269_54C1["SFB_记录幻象物品上下文"]
function ____exports.SFB_setPositiveBuff(sourceUnit, u, id, time)
    if id == ____SFB__589E_76CABUFF["心灵之火"] then
        ____SFB__65BD_52A0_539F_751F_76EE_6807Buff(
            sourceUnit,
            u,
            id,
            time,
            ABILITY.INNER_FIRE,
            ORDER.INNER_FIRE
        )
    elseif id == ____SFB__589E_76CABUFF["嗜血术"] then
        ____SFB__65BD_52A0_539F_751F_76EE_6807Buff(
            sourceUnit,
            u,
            id,
            time,
            ABILITY.BLOODLUST,
            ORDER.BLOODLUST
        )
    end
end
function ____exports.SFB_setNegativeBuff(sourceUnit, u, id, time)
    if shouldApplyControlReduction(id) then
        time = calcReducedControlDuration(u, time)
        if time <= 0 then
            return
        end
    end
    if id == ____SFB__8D1F_9762BUFF["残废"] then
        ____SFB__65BD_52A0_539F_751F_76EE_6807Buff(
            sourceUnit,
            u,
            id,
            time,
            ABILITY.CRIPPLE,
            ORDER.CRIPPLE
        )
    elseif id == ____SFB__8D1F_9762BUFF["精灵之火"] then
        ____SFB__65BD_52A0_539F_751F_76EE_6807Buff(
            sourceUnit,
            u,
            id,
            time,
            ABILITY.FAERIE_FIRE,
            ORDER.FAERIE_FIRE
        )
    elseif id == ____SFB__8D1F_9762BUFF["诅咒"] then
        ____SFB__65BD_52A0_81EA_5B9A_4E49_8BC5_5492Buff(sourceUnit, u, time)
    elseif id == ____SFB__8D1F_9762BUFF["睡眠"] then
        ____SFB__65BD_52A0_539F_751F_76EE_6807Buff(
            sourceUnit,
            u,
            id,
            time,
            ABILITY.SLEEP,
            ORDER.SLEEP
        )
    elseif id == ____SFB__8D1F_9762BUFF["纠缠根须"] then
        ____SFB__65BD_52A0_539F_751F_76EE_6807Buff(
            sourceUnit,
            u,
            id,
            time,
            ABILITY.ENTANGLING_ROOTS,
            ORDER.ENTANGLING_ROOTS
        )
    elseif id == ____SFB__8D1F_9762BUFF["飓风"] then
        ____SFB__65BD_52A0_539F_751F_76EE_6807Buff(
            sourceUnit,
            u,
            id,
            time,
            ABILITY.CYCLONE,
            ORDER.CYCLONE
        )
    elseif id == ____SFB__8D1F_9762BUFF["寄生"] then
        ____SFB__65BD_52A0_539F_751F_76EE_6807Buff(
            sourceUnit,
            u,
            id,
            time,
            ABILITY.PARASITE,
            ORDER.PARASITE
        )
    end
end
function ____exports.SFB_setBuff(sourceUnit, u, id, time)
    if not SUC_IsValidUnit(nil, u) or time == 0 then
        return
    end
    if SUC_IsUnitStructure(nil, u) then
        return
    end
    if u == SFB_Unit then
        return
    end
    if time <= 0 then
        return
    end
    if id == ____SFB__589E_76CABUFF["心灵之火"] or id == ____SFB__589E_76CABUFF["嗜血术"] then
        ____exports.SFB_setPositiveBuff(sourceUnit, u, id, time)
        return
    end
    if id == ____SFB__8D1F_9762BUFF["残废"] or id == ____SFB__8D1F_9762BUFF["精灵之火"] or id == ____SFB__8D1F_9762BUFF["诅咒"] or id == ____SFB__8D1F_9762BUFF["睡眠"] or id == ____SFB__8D1F_9762BUFF["纠缠根须"] or id == ____SFB__8D1F_9762BUFF["飓风"] or id == ____SFB__8D1F_9762BUFF["寄生"] then
        ____exports.SFB_setNegativeBuff(sourceUnit, u, id, time)
        return
    end
    if shouldApplyControlReduction(id) then
        time = calcReducedControlDuration(u, time)
        if time <= 0 then
            return
        end
    end
    if id >= 21 then
        ____SFB__65BD_52A0_6682_505C_7C7BBuff(sourceUnit, u, id, time)
        return
    end
    local caster = SFB_Unit
    if caster == nil or caster == 0 then
        return
    end
    local fac = getAngleBetweenUnits(caster, u)
    EXSetUnitFacing(nil, caster, fac)
    jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac)
    local abilityId
    local orderStr
    repeat
        local ____switch38 = id
        local ____cond38 = ____switch38 == 0
        if ____cond38 then
            abilityId = ABILITY.STUN
            orderStr = ORDER.STUN
            break
        end
        ____cond38 = ____cond38 or ____switch38 == 1
        if ____cond38 then
            abilityId = ABILITY.FREEZE
            orderStr = ORDER.FREEZE
            break
        end
        ____cond38 = ____cond38 or ____switch38 == 2
        if ____cond38 then
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
        ____cond38 = ____cond38 or ____switch38 == 3
        if ____cond38 then
            abilityId = ABILITY.POLYMORPH
            orderStr = ORDER.POLYMORPH
            break
        end
        ____cond38 = ____cond38 or ____switch38 == 4
        if ____cond38 then
            abilityId = ABILITY.INVIS
            orderStr = ORDER.INVIS
            break
        end
        ____cond38 = ____cond38 or ____switch38 == 5
        if ____cond38 then
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
    registerSfbManualBuff(
        sourceUnit,
        u,
        id,
        time,
        0
    )
    if type(orderStr) == "string" then
        IssueTargetOrder(caster, orderStr, u)
    else
        IssueTargetOrderById(caster, orderStr, u)
    end
end
____exports["SFB_增益BUFF"] = ____SFB__589E_76CABUFF
____exports["SFB_负面BUFF"] = ____SFB__8D1F_9762BUFF
____exports.SFB_Unit = SFB_Unit
____exports.SFB_Init = SFB_Init
initItemIllusionSummonBridge()
function ____exports.SFB_setInnerFire(sourceUnit, u, time)
    ____exports.SFB_setPositiveBuff(sourceUnit, u, ____SFB__589E_76CABUFF["心灵之火"], time)
end
function ____exports.SFB_setBloodlust(sourceUnit, u, time)
    ____exports.SFB_setPositiveBuff(sourceUnit, u, ____SFB__589E_76CABUFF["嗜血术"], time)
end
function ____exports.SFB_setCripple(sourceUnit, u, time)
    ____exports.SFB_setNegativeBuff(sourceUnit, u, ____SFB__8D1F_9762BUFF["残废"], time)
end
function ____exports.SFB_setFaerieFire(sourceUnit, u, time)
    ____exports.SFB_setNegativeBuff(sourceUnit, u, ____SFB__8D1F_9762BUFF["精灵之火"], time)
end
function ____exports.SFB_setCurse(sourceUnit, u, time)
    ____exports.SFB_setNegativeBuff(sourceUnit, u, ____SFB__8D1F_9762BUFF["诅咒"], time)
end
function ____exports.SFB_setSleep(sourceUnit, u, time)
    ____exports.SFB_setNegativeBuff(sourceUnit, u, ____SFB__8D1F_9762BUFF["睡眠"], time)
end
function ____exports.SFB_setEntanglingRoots(sourceUnit, u, time)
    ____exports.SFB_setNegativeBuff(sourceUnit, u, ____SFB__8D1F_9762BUFF["纠缠根须"], time)
end
function ____exports.SFB_setCyclone(sourceUnit, u, time)
    ____exports.SFB_setNegativeBuff(sourceUnit, u, ____SFB__8D1F_9762BUFF["飓风"], time)
end
function ____exports.SFB_setParasite(sourceUnit, u, time)
    ____exports.SFB_setNegativeBuff(sourceUnit, u, ____SFB__8D1F_9762BUFF["寄生"], time)
end
--- 对目标施放“幻象物品”技能。
-- 
-- 这不是 Buff，不进入 BuffUI，也不占用现有快速 Buff 类型编号。
-- 默认持续时间 15 秒；如果母技能字段可被正常读取，会同步写入普通/英雄持续时间。
function ____exports.SFB_setItemIllusion(sourceUnit, u, time)
    if time == nil then
        time = 15
    end
    ____SFB__8BB0_5F55_5E7B_8C61_7269_54C1_4E0A_4E0B_6587(sourceUnit, u, time)
    local ok = ____SFB__65BD_52A0_539F_751F_76EE_6807_6280_80FD(u, ABILITY.ITEM_ILLUSION, ORDER.ITEM_ILLUSION, time)
    if not ok then
        ____SFB__6E05_7A7A_5E7B_8C61_7269_54C1_4E0A_4E0B_6587()
    end
    return ok
end
--- 快速 Buff 通用入口。
-- 
-- 参数顺序固定为：来源单位 -> 目标单位 -> Buff类型 -> 持续时间。
-- 后续技能优先用这个函数，避免直接调用 `SFB_setBuff(null, ...)` 导致 BuffUI 来源显示为“未知”。
____exports["SFB_施加通用Buff"] = function(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, ____Buff_7C7B_578B, _____6301_7EED_65F6_95F4)
    ____exports.SFB_setBuff(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, ____Buff_7C7B_578B, _____6301_7EED_65F6_95F4)
end
function ____exports.SFB_setSlow(sourceUnit, u, as, ms, time)
    if not SUC_IsValidUnit(nil, u) or time == 0 then
        return
    end
    if SUC_IsUnitStructure(nil, u) then
        return
    end
    if u == SFB_Unit then
        return
    end
    if time <= 0 then
        return
    end
    local caster = SFB_Unit
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
    registerSfbManualBuff(
        sourceUnit,
        u,
        7,
        time,
        ms
    )
    IssueTargetOrderById(caster, ORDER.SLOW, u)
end
return ____exports
