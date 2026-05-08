local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____83B7_53D6_5355_4F4D_5F53_524D_65E0_654C_5C42_6570, _____8BBE_7F6E_5355_4F4D_5F53_524D_65E0_654C_5C42_6570, _____5355_4F4D_4ECD_53EF_64CD_4F5C, _____9500_6BC1_5355_4F4D_65E0_654C_7279_6548, _____5C1D_8BD5_5173_95ED_65E0_654CTick, _____79FB_9664_65E0_654C_5B9E_4F8B, _____65E0_654CTick, offTick10ms, SetUnitInvulnerable, GetUnitTypeId, DestroyEffect, _____6D3B_8DC3_65E0_654C_5B9E_4F8B, _____5355_4F4D_65E0_654C_5C42_6570, _____5355_4F4D_65E0_654C_7279_6548, _____65E0_654CTick_5DF2_542F_52A8
function _____83B7_53D6_5355_4F4D_5F53_524D_65E0_654C_5C42_6570(_____5355_4F4D_53E5_67C4ID)
    return _____5355_4F4D_65E0_654C_5C42_6570[_____5355_4F4D_53E5_67C4ID] or 0
end
function _____8BBE_7F6E_5355_4F4D_5F53_524D_65E0_654C_5C42_6570(_____5355_4F4D_53E5_67C4ID, _____5C42_6570)
    if _____5C42_6570 <= 0 then
        __TS__Delete(_____5355_4F4D_65E0_654C_5C42_6570, _____5355_4F4D_53E5_67C4ID)
        return
    end
    _____5355_4F4D_65E0_654C_5C42_6570[_____5355_4F4D_53E5_67C4ID] = _____5C42_6570
end
function _____5355_4F4D_4ECD_53EF_64CD_4F5C(_____5355_4F4D)
    return _____5355_4F4D ~= nil and GetUnitTypeId(_____5355_4F4D) ~= 0
end
function _____9500_6BC1_5355_4F4D_65E0_654C_7279_6548(_____5355_4F4D_53E5_67C4ID)
    local effect = _____5355_4F4D_65E0_654C_7279_6548[_____5355_4F4D_53E5_67C4ID]
    if effect == nil then
        return
    end
    DestroyEffect(effect)
    __TS__Delete(_____5355_4F4D_65E0_654C_7279_6548, _____5355_4F4D_53E5_67C4ID)
end
function _____5C1D_8BD5_5173_95ED_65E0_654CTick()
    if #_____6D3B_8DC3_65E0_654C_5B9E_4F8B > 0 or not _____65E0_654CTick_5DF2_542F_52A8 then
        return
    end
    _____65E0_654CTick_5DF2_542F_52A8 = false
    offTick10ms(_____65E0_654CTick)
end
function _____79FB_9664_65E0_654C_5B9E_4F8B(index)
    local _____5B9E_4F8B = _____6D3B_8DC3_65E0_654C_5B9E_4F8B[index + 1]
    local _____5F53_524D_5C42_6570 = _____83B7_53D6_5355_4F4D_5F53_524D_65E0_654C_5C42_6570(_____5B9E_4F8B["单位句柄ID"])
    local _____5269_4F59_5C42_6570 = _____5F53_524D_5C42_6570 - 1
    _____8BBE_7F6E_5355_4F4D_5F53_524D_65E0_654C_5C42_6570(_____5B9E_4F8B["单位句柄ID"], _____5269_4F59_5C42_6570)
    if _____5269_4F59_5C42_6570 <= 0 and _____5355_4F4D_4ECD_53EF_64CD_4F5C(_____5B9E_4F8B["单位"]) then
        SetUnitInvulnerable(_____5B9E_4F8B["单位"], false)
        _____9500_6BC1_5355_4F4D_65E0_654C_7279_6548(_____5B9E_4F8B["单位句柄ID"])
    end
    if _____5269_4F59_5C42_6570 <= 0 and not _____5355_4F4D_4ECD_53EF_64CD_4F5C(_____5B9E_4F8B["单位"]) then
        _____9500_6BC1_5355_4F4D_65E0_654C_7279_6548(_____5B9E_4F8B["单位句柄ID"])
    end
    __TS__ArraySplice(_____6D3B_8DC3_65E0_654C_5B9E_4F8B, index, 1)
end
function _____65E0_654CTick()
    do
        local i = #_____6D3B_8DC3_65E0_654C_5B9E_4F8B - 1
        while i >= 0 do
            do
                local _____5B9E_4F8B = _____6D3B_8DC3_65E0_654C_5B9E_4F8B[i + 1]
                if not _____5B9E_4F8B["激活"] then
                    _____79FB_9664_65E0_654C_5B9E_4F8B(i)
                    goto __continue20
                end
                if not _____5355_4F4D_4ECD_53EF_64CD_4F5C(_____5B9E_4F8B["单位"]) then
                    _____5B9E_4F8B["激活"] = false
                    _____79FB_9664_65E0_654C_5B9E_4F8B(i)
                    goto __continue20
                end
                _____5B9E_4F8B["剩余秒数"] = _____5B9E_4F8B["剩余秒数"] - 0.01
                if _____5B9E_4F8B["剩余秒数"] <= 0 then
                    _____5B9E_4F8B["激活"] = false
                    _____79FB_9664_65E0_654C_5B9E_4F8B(i)
                end
            end
            ::__continue20::
            i = i - 1
        end
    end
    _____5C1D_8BD5_5173_95ED_65E0_654CTick()
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
local jass = require("jass.common")
SetUnitInvulnerable = jass.SetUnitInvulnerable
local GetHandleId = jass.GetHandleId
GetUnitTypeId = jass.GetUnitTypeId
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
DestroyEffect = jass.DestroyEffect
local DEFAULT_INVULNERABLE_EFFECT = "Abilities\\Spells\\Human\\DivineShield\\DivineShieldTarget.mdl"
local _____4E0B_4E00_4E2A_65E0_654CID = 1
_____6D3B_8DC3_65E0_654C_5B9E_4F8B = {}
_____5355_4F4D_65E0_654C_5C42_6570 = {}
_____5355_4F4D_65E0_654C_7279_6548 = {}
_____65E0_654CTick_5DF2_542F_52A8 = false
local function _____521B_5EFA_5355_4F4D_65E0_654C_7279_6548(_____5355_4F4D, _____5355_4F4D_53E5_67C4ID)
    if not _____5355_4F4D_4ECD_53EF_64CD_4F5C(_____5355_4F4D) then
        return
    end
    if _____5355_4F4D_65E0_654C_7279_6548[_____5355_4F4D_53E5_67C4ID] ~= nil then
        return
    end
    _____5355_4F4D_65E0_654C_7279_6548[_____5355_4F4D_53E5_67C4ID] = AddSpecialEffectTarget(DEFAULT_INVULNERABLE_EFFECT, _____5355_4F4D, "origin")
end
local function _____786E_4FDD_65E0_654CTick_542F_52A8()
    if _____65E0_654CTick_5DF2_542F_52A8 then
        return
    end
    _____65E0_654CTick_5DF2_542F_52A8 = true
    onTick10ms(_____65E0_654CTick)
end
____exports["开始无敌帧"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4)
    if _____5355_4F4D == nil or _____6301_7EED_65F6_95F4 <= 0 then
        return 0
    end
    local _____5355_4F4D_53E5_67C4ID = GetHandleId(_____5355_4F4D)
    local ____4E0B_4E00_4E2A_65E0_654CID_1 = _____4E0B_4E00_4E2A_65E0_654CID
    _____4E0B_4E00_4E2A_65E0_654CID = ____4E0B_4E00_4E2A_65E0_654CID_1 + 1
    local _____65B0_5B9E_4F8B = {
        id = ____4E0B_4E00_4E2A_65E0_654CID_1,
        ["单位"] = _____5355_4F4D,
        ["单位句柄ID"] = _____5355_4F4D_53E5_67C4ID,
        ["剩余秒数"] = _____6301_7EED_65F6_95F4,
        ["激活"] = true
    }
    _____6D3B_8DC3_65E0_654C_5B9E_4F8B[#_____6D3B_8DC3_65E0_654C_5B9E_4F8B + 1] = _____65B0_5B9E_4F8B
    _____8BBE_7F6E_5355_4F4D_5F53_524D_65E0_654C_5C42_6570(
        _____5355_4F4D_53E5_67C4ID,
        _____83B7_53D6_5355_4F4D_5F53_524D_65E0_654C_5C42_6570(_____5355_4F4D_53E5_67C4ID) + 1
    )
    if _____5355_4F4D_4ECD_53EF_64CD_4F5C(_____5355_4F4D) then
        SetUnitInvulnerable(_____5355_4F4D, true)
        _____521B_5EFA_5355_4F4D_65E0_654C_7279_6548(_____5355_4F4D, _____5355_4F4D_53E5_67C4ID)
    end
    _____786E_4FDD_65E0_654CTick_542F_52A8()
    return _____65B0_5B9E_4F8B.id
end
____exports["取消无敌帧"] = function(_____65E0_654CID)
    do
        local i = #_____6D3B_8DC3_65E0_654C_5B9E_4F8B - 1
        while i >= 0 do
            do
                local _____5B9E_4F8B = _____6D3B_8DC3_65E0_654C_5B9E_4F8B[i + 1]
                if _____5B9E_4F8B.id ~= _____65E0_654CID then
                    goto __continue29
                end
                _____5B9E_4F8B["激活"] = false
                _____79FB_9664_65E0_654C_5B9E_4F8B(i)
                _____5C1D_8BD5_5173_95ED_65E0_654CTick()
                return true
            end
            ::__continue29::
            i = i - 1
        end
    end
    return false
end
____exports["取消单位所有无敌帧"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil then
        return false
    end
    local _____5355_4F4D_53E5_67C4ID = GetHandleId(_____5355_4F4D)
    local _____5DF2_53D6_6D88 = false
    do
        local i = #_____6D3B_8DC3_65E0_654C_5B9E_4F8B - 1
        while i >= 0 do
            do
                local _____5B9E_4F8B = _____6D3B_8DC3_65E0_654C_5B9E_4F8B[i + 1]
                if _____5B9E_4F8B["单位句柄ID"] ~= _____5355_4F4D_53E5_67C4ID then
                    goto __continue34
                end
                _____5B9E_4F8B["激活"] = false
                _____79FB_9664_65E0_654C_5B9E_4F8B(i)
                _____5DF2_53D6_6D88 = true
            end
            ::__continue34::
            i = i - 1
        end
    end
    _____5C1D_8BD5_5173_95ED_65E0_654CTick()
    return _____5DF2_53D6_6D88
end
____exports["单位是否处于无敌帧中"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil then
        return false
    end
    return _____83B7_53D6_5355_4F4D_5F53_524D_65E0_654C_5C42_6570(GetHandleId(_____5355_4F4D)) > 0
end
____exports["获取单位无敌帧层数"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil then
        return 0
    end
    return _____83B7_53D6_5355_4F4D_5F53_524D_65E0_654C_5C42_6570(GetHandleId(_____5355_4F4D))
end
return ____exports
