local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local _____53D6_6700_5C0F_503C, _____751F_6210_6807_7B7E_952E, _____4ECE_5217_8868_79FB_9664, _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668, _____6E05_7406_6807_7B7E, _____9500_6BC1_9B54_6CD5_5438_6536_62A4_76FE, ____on_9B54_6CD5_5438_6536_62A4_76FE_4E2D_5FC3_8BA1_65F6_5668Tick, _____662F_5426_6EE1_8DB3_9B54_6CD5_95E8_69DB, _____662F_5426_53EF_5438_6536, _____8BA1_7B97_5438_6536_4F24_5BB3, _____5438_6536_9B54_6CD5_62A4_76FE_4F24_5BB3, ____on_9B54_6CD5_5438_6536_62A4_76FE_4F24_5BB3_4FEE_6B63, _____51CF_5C11_9B54_6CD5_503C, GetUnitState, DestroyEffect, UNIT_STATE_MANA, UNIT_STATE_MAX_MANA, _____9B54_6CD5_5438_6536_62A4_76FE_8868, _____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868, _____9B54_6CD5_5438_6536_62A4_76FE_6807_7B7E_8868, _____5DF2_6CE8_518C_9B54_6CD5_5438_6536_62A4_76FE_4E2D_5FC3_8BA1_65F6_5668
function _____53D6_6700_5C0F_503C(a, b)
    return a < b and a or b
end
function _____751F_6210_6807_7B7E_952E(unitId, label)
    return (tostring(unitId) .. ":") .. label
end
function _____4ECE_5217_8868_79FB_9664(id)
    do
        local i = #_____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868 - 1
        while i >= 0 do
            if _____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868[i + 1] == id then
                __TS__ArraySplice(_____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868, i, 1)
                return
            end
            i = i - 1
        end
    end
end
function _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668()
    if not _____5DF2_6CE8_518C_9B54_6CD5_5438_6536_62A4_76FE_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    if #_____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868 > 0 then
        return
    end
    _____5DF2_6CE8_518C_9B54_6CD5_5438_6536_62A4_76FE_4E2D_5FC3_8BA1_65F6_5668 = false
end
function _____6E05_7406_6807_7B7E(_____5B9E_4F8B)
    if _____5B9E_4F8B["标签"] == nil or _____5B9E_4F8B["标签"] == "" then
        return
    end
    local key = _____751F_6210_6807_7B7E_952E(_____5B9E_4F8B["单位ID"], _____5B9E_4F8B["标签"])
    if _____9B54_6CD5_5438_6536_62A4_76FE_6807_7B7E_8868[key] == _____5B9E_4F8B.id then
        __TS__Delete(_____9B54_6CD5_5438_6536_62A4_76FE_6807_7B7E_8868, key)
    end
end
function _____9500_6BC1_9B54_6CD5_5438_6536_62A4_76FE(id)
    local _____5B9E_4F8B = _____9B54_6CD5_5438_6536_62A4_76FE_8868[id]
    if _____5B9E_4F8B == nil then
        return
    end
    __TS__Delete(_____9B54_6CD5_5438_6536_62A4_76FE_8868, id)
    _____4ECE_5217_8868_79FB_9664(id)
    _____6E05_7406_6807_7B7E(_____5B9E_4F8B)
    if _____5B9E_4F8B["特效"] ~= nil and _____5B9E_4F8B["特效"] ~= 0 then
        DestroyEffect(_____5B9E_4F8B["特效"])
    end
    _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668()
end
function ____on_9B54_6CD5_5438_6536_62A4_76FE_4E2D_5FC3_8BA1_65F6_5668Tick()
    do
        local i = #_____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868 - 1
        while i >= 0 do
            do
                local id = _____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868[i + 1]
                local _____5B9E_4F8B = _____9B54_6CD5_5438_6536_62A4_76FE_8868[id]
                if _____5B9E_4F8B == nil or _____5B9E_4F8B["单位"] == nil or _____5B9E_4F8B["单位"] == 0 then
                    _____9500_6BC1_9B54_6CD5_5438_6536_62A4_76FE(id)
                    goto __continue23
                end
                if not (_____5B9E_4F8B["剩余时间"] > 0) then
                    goto __continue23
                end
                _____5B9E_4F8B["剩余时间"] = _____5B9E_4F8B["剩余时间"] - 0.1
                if _____5B9E_4F8B["剩余时间"] <= 0 then
                    _____9500_6BC1_9B54_6CD5_5438_6536_62A4_76FE(id)
                end
            end
            ::__continue23::
            i = i - 1
        end
    end
    _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668()
end
function _____662F_5426_6EE1_8DB3_9B54_6CD5_95E8_69DB(_____5F53_524D_9B54_6CD5, _____6700_5927_9B54_6CD5, _____6700_4F4E_9B54_6CD5_767E_5206_6BD4, _____6700_4F4E_9B54_6CD5_56FA_5B9A_503C)
    local _____89E6_53D1_95E8_69DB = _____6700_5927_9B54_6CD5 * _____6700_4F4E_9B54_6CD5_767E_5206_6BD4 + _____6700_4F4E_9B54_6CD5_56FA_5B9A_503C
    return _____5F53_524D_9B54_6CD5 > _____89E6_53D1_95E8_69DB
end
function _____662F_5426_53EF_5438_6536(_____5B9E_4F8B, _____53D7_51FB_5355_4F4D, context)
    if _____5B9E_4F8B == nil then
        return false
    end
    if _____53D7_51FB_5355_4F4D == nil or _____53D7_51FB_5355_4F4D == 0 then
        return false
    end
    if _____5B9E_4F8B["单位"] ~= _____53D7_51FB_5355_4F4D then
        return false
    end
    if _____5B9E_4F8B["仅非物理伤害"] ~= false and context.isPhysicalDamage then
        return false
    end
    if not (_____5B9E_4F8B["每点魔法吸收伤害"] > 0) then
        return false
    end
    local _____5F53_524D_9B54_6CD5 = GetUnitState(_____53D7_51FB_5355_4F4D, UNIT_STATE_MANA)
    if not (_____5F53_524D_9B54_6CD5 > 0) then
        return false
    end
    local _____6700_5927_9B54_6CD5 = GetUnitState(_____53D7_51FB_5355_4F4D, UNIT_STATE_MAX_MANA)
    if not (_____6700_5927_9B54_6CD5 > 0) then
        return false
    end
    if not _____662F_5426_6EE1_8DB3_9B54_6CD5_95E8_69DB(_____5F53_524D_9B54_6CD5, _____6700_5927_9B54_6CD5, _____5B9E_4F8B["最低魔法百分比"] or 0, _____5B9E_4F8B["最低魔法固定值"] or 0) then
        return false
    end
    return context.currentDamage > 0
end
function _____8BA1_7B97_5438_6536_4F24_5BB3(_____5B9E_4F8B, _____53D7_51FB_5355_4F4D, _____4F24_5BB3_503C)
    if not (_____4F24_5BB3_503C > 0) then
        return 0
    end
    local _____6BD4_4F8B_4E0A_9650 = (_____5B9E_4F8B["伤害吸收比例"] == nil or _____5B9E_4F8B["伤害吸收比例"] <= 0) and _____4F24_5BB3_503C or _____4F24_5BB3_503C * _____5B9E_4F8B["伤害吸收比例"]
    local _____5F53_524D_9B54_6CD5 = GetUnitState(_____53D7_51FB_5355_4F4D, UNIT_STATE_MANA)
    local _____9B54_6CD5_4E0A_9650 = _____5F53_524D_9B54_6CD5 * _____5B9E_4F8B["每点魔法吸收伤害"]
    return _____53D6_6700_5C0F_503C(
        _____4F24_5BB3_503C,
        _____53D6_6700_5C0F_503C(_____6BD4_4F8B_4E0A_9650, _____9B54_6CD5_4E0A_9650)
    )
end
function _____5438_6536_9B54_6CD5_62A4_76FE_4F24_5BB3(_____5B9E_4F8B, _____53D7_51FB_5355_4F4D, _____4F24_5BB3_503C)
    local _____5438_6536_91CF = _____8BA1_7B97_5438_6536_4F24_5BB3(_____5B9E_4F8B, _____53D7_51FB_5355_4F4D, _____4F24_5BB3_503C)
    if not (_____5438_6536_91CF > 0) then
        return 0
    end
    local _____9700_8981_9B54_6CD5 = _____5438_6536_91CF / _____5B9E_4F8B["每点魔法吸收伤害"]
    _____51CF_5C11_9B54_6CD5_503C(
        _____53D7_51FB_5355_4F4D,
        _____9700_8981_9B54_6CD5,
        _____5B9E_4F8B["显示文本"] == true,
        _____5B9E_4F8B["是否有特效"] ~= false,
        _____5B9E_4F8B["特效路径"]
    )
    return _____5438_6536_91CF
end
function ____on_9B54_6CD5_5438_6536_62A4_76FE_4F24_5BB3_4FEE_6B63(context)
    local _____53D7_51FB_5355_4F4D = context.target
    if _____53D7_51FB_5355_4F4D == nil or _____53D7_51FB_5355_4F4D == 0 or not (context.currentDamage > 0) then
        return context.currentDamage
    end
    do
        local i = #_____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868 - 1
        while i >= 0 do
            do
                local id = _____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868[i + 1]
                local _____5B9E_4F8B = _____9B54_6CD5_5438_6536_62A4_76FE_8868[id]
                if _____5B9E_4F8B == nil or _____5B9E_4F8B["单位"] == nil or _____5B9E_4F8B["单位"] == 0 then
                    _____9500_6BC1_9B54_6CD5_5438_6536_62A4_76FE(id)
                    goto __continue49
                end
                if not _____662F_5426_53EF_5438_6536(_____5B9E_4F8B, _____53D7_51FB_5355_4F4D, context) then
                    goto __continue49
                end
                local _____5438_6536_91CF = _____5438_6536_9B54_6CD5_62A4_76FE_4F24_5BB3(_____5B9E_4F8B, _____53D7_51FB_5355_4F4D, context.currentDamage)
                if not (_____5438_6536_91CF > 0) then
                    goto __continue49
                end
                context.currentDamage = context.currentDamage - _____5438_6536_91CF
                if not (context.currentDamage > 0) then
                    return 0
                end
            end
            ::__continue49::
            i = i - 1
        end
    end
    return context.currentDamage
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
_____51CF_5C11_9B54_6CD5_503C = ____require_result_2["减少魔法值"]
local ____jass_3 = jass
local AddSpecialEffectTarget = ____jass_3.AddSpecialEffectTarget
local GetHandleId = jass.GetHandleId
GetUnitState = jass.GetUnitState
DestroyEffect = jass.DestroyEffect
UNIT_STATE_MANA = jass.UNIT_STATE_MANA
UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
_____9B54_6CD5_5438_6536_62A4_76FE_8868 = {}
_____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868 = {}
_____9B54_6CD5_5438_6536_62A4_76FE_6807_7B7E_8868 = {}
local _____5DF2_6CE8_518C_9B54_6CD5_5438_6536_62A4_76FE_4F24_5BB3_76D1_542C = false
_____5DF2_6CE8_518C_9B54_6CD5_5438_6536_62A4_76FE_4E2D_5FC3_8BA1_65F6_5668 = false
local _____4E0B_4E00_4E2A_9B54_6CD5_5438_6536_62A4_76FEID = 1
local _____9ED8_8BA4_9B54_6CD5_5438_6536_7279_6548_8DEF_5F84 = "war3mapImported\\Energy Shield.mdl"
local _____9ED8_8BA4_9B54_6CD5_5438_6536_7279_6548_6302_70B9 = "origin"
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____786E_4FDD_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_9B54_6CD5_5438_6536_62A4_76FE_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_9B54_6CD5_5438_6536_62A4_76FE_4E2D_5FC3_8BA1_65F6_5668 = true
    addPeriodicCallback(100, ____on_9B54_6CD5_5438_6536_62A4_76FE_4E2D_5FC3_8BA1_65F6_5668Tick)
end
local function _____786E_4FDD_4F24_5BB3_76D1_542C()
    if _____5DF2_6CE8_518C_9B54_6CD5_5438_6536_62A4_76FE_4F24_5BB3_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_9B54_6CD5_5438_6536_62A4_76FE_4F24_5BB3_76D1_542C = true
    registerDamageModifier(____on_9B54_6CD5_5438_6536_62A4_76FE_4F24_5BB3_4FEE_6B63, 90)
end
local function _____521B_5EFA_7279_6548(_____5B9E_4F8B)
    if _____5B9E_4F8B["是否有特效"] == false then
        return
    end
    local path = _____5B9E_4F8B["特效路径"] and _____5B9E_4F8B["特效路径"] ~= "" and _____5B9E_4F8B["特效路径"] or _____9ED8_8BA4_9B54_6CD5_5438_6536_7279_6548_8DEF_5F84
    local attach = _____5B9E_4F8B["特效挂点"] and _____5B9E_4F8B["特效挂点"] ~= "" and _____5B9E_4F8B["特效挂点"] or _____9ED8_8BA4_9B54_6CD5_5438_6536_7279_6548_6302_70B9
    local effect = AddSpecialEffectTarget(path, _____5B9E_4F8B["单位"], attach)
    if effect ~= nil and effect ~= 0 then
        _____5B9E_4F8B["特效"] = effect
    end
end
____exports["开始魔法吸收护盾"] = function(_____53C2_6570)
    local _____5355_4F4D = _____53C2_6570["单位"]
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return 0
    end
    if not (_____53C2_6570["每点魔法吸收伤害"] > 0) then
        return 0
    end
    if _____53C2_6570["标签"] ~= nil and _____53C2_6570["标签"] ~= "" then
        local key = _____751F_6210_6807_7B7E_952E(_____5355_4F4DID, _____53C2_6570["标签"])
        local _____5DF2_6709ID = _____9B54_6CD5_5438_6536_62A4_76FE_6807_7B7E_8868[key]
        if _____5DF2_6709ID ~= nil and _____5DF2_6709ID > 0 then
            _____9500_6BC1_9B54_6CD5_5438_6536_62A4_76FE(_____5DF2_6709ID)
        end
    end
    local ____4E0B_4E00_4E2A_9B54_6CD5_5438_6536_62A4_76FEID_4 = _____4E0B_4E00_4E2A_9B54_6CD5_5438_6536_62A4_76FEID
    _____4E0B_4E00_4E2A_9B54_6CD5_5438_6536_62A4_76FEID = ____4E0B_4E00_4E2A_9B54_6CD5_5438_6536_62A4_76FEID_4 + 1
    local id = ____4E0B_4E00_4E2A_9B54_6CD5_5438_6536_62A4_76FEID_4
    local _____5B9E_4F8B = __TS__ObjectAssign({}, _____53C2_6570, {
        id = id,
        ["单位"] = _____5355_4F4D,
        ["单位ID"] = _____5355_4F4DID,
        ["剩余时间"] = _____53C2_6570["持续时间"] or 0,
        ["特效"] = 0
    })
    _____9B54_6CD5_5438_6536_62A4_76FE_8868[id] = _____5B9E_4F8B
    _____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868[#_____9B54_6CD5_5438_6536_62A4_76FEID_5217_8868 + 1] = id
    if _____53C2_6570["标签"] ~= nil and _____53C2_6570["标签"] ~= "" then
        _____9B54_6CD5_5438_6536_62A4_76FE_6807_7B7E_8868[_____751F_6210_6807_7B7E_952E(_____5355_4F4DID, _____53C2_6570["标签"])] = id
    end
    _____521B_5EFA_7279_6548(_____5B9E_4F8B)
    _____786E_4FDD_4F24_5BB3_76D1_542C()
    _____786E_4FDD_4E2D_5FC3_8BA1_65F6_5668()
    return id
end
____exports["移除魔法吸收护盾"] = function(id)
    if not (id > 0) then
        return
    end
    _____9500_6BC1_9B54_6CD5_5438_6536_62A4_76FE(id)
end
____exports["移除单位魔法吸收护盾"] = function(_____5355_4F4D, _____6807_7B7E)
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID == 0 or _____6807_7B7E == "" then
        return
    end
    local key = _____751F_6210_6807_7B7E_952E(_____5355_4F4DID, _____6807_7B7E)
    local id = _____9B54_6CD5_5438_6536_62A4_76FE_6807_7B7E_8868[key]
    if id == nil or not (id > 0) then
        return
    end
    _____9500_6BC1_9B54_6CD5_5438_6536_62A4_76FE(id)
end
return ____exports
