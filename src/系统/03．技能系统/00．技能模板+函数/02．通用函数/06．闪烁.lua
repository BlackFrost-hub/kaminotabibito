local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5355_4F4D_5B58_6D3B, _____64AD_653E_95EA_70C1_7279_6548, _____672C_5730_4E3A_5355_4F4D_62E5_6709_8005_91CD_65B0_9009_4E2D_5355_4F4D, _____7ED3_675F_95EA_70C1_5B9E_4F8B, ____on_95EA_70C1Tick, jass, offTick10ms, YDWETimerDestroyEffect, AddSpecialEffect, GetOwningPlayer, GetLocalPlayer, ClearSelection, SelectUnit, ShowUnit, PauseUnit, SetUnitFacing, SetUnitPosition, GetUnitState, TICK_INTERVAL, UNIT_ALIVE_LIFE, _____6D3B_52A8_95EA_70C1_5217_8868, _____95EA_70C1_6620_5C04, _____5DF2_6CE8_518C_95EA_70C1Tick
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____5C1D_8BD5_963B_6B62_81EA_8EAB_4F4D_79FB_6280_80FD = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["尝试阻止自身位移技能"]
function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and GetUnitState(unit, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
function _____64AD_653E_95EA_70C1_7279_6548(_____6A21_578B, x, y, _____751F_547D_5468_671F)
    if _____6A21_578B == nil or _____6A21_578B == "" then
        return
    end
    local effect = AddSpecialEffect(_____6A21_578B, x, y)
    if effect == nil or effect == 0 then
        return
    end
    YDWETimerDestroyEffect(nil, _____751F_547D_5468_671F, effect)
end
function _____672C_5730_4E3A_5355_4F4D_62E5_6709_8005_91CD_65B0_9009_4E2D_5355_4F4D(_____5355_4F4D)
    local _____62E5_6709_8005 = GetOwningPlayer(_____5355_4F4D)
    if GetLocalPlayer() == _____62E5_6709_8005 then
        ClearSelection()
        SelectUnit(_____5355_4F4D, true)
    end
end
function _____7ED3_675F_95EA_70C1_5B9E_4F8B(_____5B9E_4F8B, _____662F_5426_5B8C_6210)
    __TS__Delete(_____95EA_70C1_6620_5C04, _____5B9E_4F8B.ID)
    local idx = __TS__ArrayIndexOf(_____6D3B_52A8_95EA_70C1_5217_8868, _____5B9E_4F8B)
    if idx >= 0 then
        __TS__ArraySplice(_____6D3B_52A8_95EA_70C1_5217_8868, idx, 1)
    end
    if _____662F_5426_5B8C_6210 and _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
        SetUnitPosition(_____5B9E_4F8B["单位"], _____5B9E_4F8B["目标X"], _____5B9E_4F8B["目标Y"])
        if _____5B9E_4F8B["朝向"] ~= nil then
            SetUnitFacing(_____5B9E_4F8B["单位"], _____5B9E_4F8B["朝向"])
        end
        ShowUnit(_____5B9E_4F8B["单位"], true)
        if _____5B9E_4F8B["闪烁期间暂停单位"] and not _____5B9E_4F8B["单位原本已暂停"] then
            PauseUnit(_____5B9E_4F8B["单位"], false)
        end
        _____64AD_653E_95EA_70C1_7279_6548(_____5B9E_4F8B["结束特效"], _____5B9E_4F8B["目标X"], _____5B9E_4F8B["目标Y"], _____5B9E_4F8B["特效生命周期"])
        if _____5B9E_4F8B["结束后选中单位"] then
            _____672C_5730_4E3A_5355_4F4D_62E5_6709_8005_91CD_65B0_9009_4E2D_5355_4F4D(_____5B9E_4F8B["单位"])
        end
    elseif _____5B9E_4F8B["闪烁期间暂停单位"] and _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) and not _____5B9E_4F8B["单位原本已暂停"] then
        PauseUnit(_____5B9E_4F8B["单位"], false)
        ShowUnit(_____5B9E_4F8B["单位"], true)
    end
    if #_____6D3B_52A8_95EA_70C1_5217_8868 == 0 and _____5DF2_6CE8_518C_95EA_70C1Tick then
        _____5DF2_6CE8_518C_95EA_70C1Tick = false
        offTick10ms(____on_95EA_70C1Tick)
    end
end
function ____on_95EA_70C1Tick()
    local i = 0
    while i < #_____6D3B_52A8_95EA_70C1_5217_8868 do
        do
            local _____5B9E_4F8B = _____6D3B_52A8_95EA_70C1_5217_8868[i + 1]
            if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
                _____7ED3_675F_95EA_70C1_5B9E_4F8B(_____5B9E_4F8B, false)
                goto __continue17
            end
            _____5B9E_4F8B["剩余时间"] = _____5B9E_4F8B["剩余时间"] - TICK_INTERVAL
            if _____5B9E_4F8B["剩余时间"] <= 0 then
                _____7ED3_675F_95EA_70C1_5B9E_4F8B(_____5B9E_4F8B, true)
                goto __continue17
            end
            i = i + 1
        end
        ::__continue17::
    end
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
local ____require_result_1 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
YDWETimerDestroyEffect = ____require_result_1.YDWETimerDestroyEffect
AddSpecialEffect = jass.AddSpecialEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
GetOwningPlayer = jass.GetOwningPlayer
GetLocalPlayer = jass.GetLocalPlayer
ClearSelection = jass.ClearSelection
SelectUnit = jass.SelectUnit
ShowUnit = jass.ShowUnit
PauseUnit = jass.PauseUnit
local IsUnitPaused = jass.IsUnitPaused
SetUnitFacing = jass.SetUnitFacing
SetUnitPosition = jass.SetUnitPosition
GetUnitState = jass.GetUnitState
TICK_INTERVAL = 0.01
UNIT_ALIVE_LIFE = 0.405
_____6D3B_52A8_95EA_70C1_5217_8868 = {}
_____95EA_70C1_6620_5C04 = {}
local _____4E0B_4E00_4E2A_95EA_70C1ID = 1
_____5DF2_6CE8_518C_95EA_70C1Tick = false
local function _____6CE8_518C_95EA_70C1Tick()
    if _____5DF2_6CE8_518C_95EA_70C1Tick then
        return
    end
    _____5DF2_6CE8_518C_95EA_70C1Tick = true
    onTick10ms(____on_95EA_70C1Tick)
end
____exports["开始闪烁"] = function(_____5355_4F4D, _____53C2_6570)
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) then
        return 0
    end
    if _____5C1D_8BD5_963B_6B62_81EA_8EAB_4F4D_79FB_6280_80FD(_____5355_4F4D) then
        return 0
    end
    local _____6301_7EED_65F6_95F4 = _____53C2_6570["持续时间"] > 0 and _____53C2_6570["持续时间"] or 0
    local _____7279_6548_751F_547D_5468_671F = _____53C2_6570["特效生命周期"] ~= nil and _____53C2_6570["特效生命周期"] > 0 and _____53C2_6570["特效生命周期"] or 1
    local _____95EA_70C1_671F_95F4_6682_505C_5355_4F4D = _____53C2_6570["闪烁期间暂停单位"] ~= false
    local _____7ED3_675F_540E_9009_4E2D_5355_4F4D = _____53C2_6570["结束后选中单位"] ~= false
    local _____5F53_524DX = GetUnitX(_____5355_4F4D)
    local _____5F53_524DY = GetUnitY(_____5355_4F4D)
    _____64AD_653E_95EA_70C1_7279_6548(_____53C2_6570["开始特效"], _____5F53_524DX, _____5F53_524DY, _____7279_6548_751F_547D_5468_671F)
    local _____539F_672C_5DF2_6682_505C = IsUnitPaused(_____5355_4F4D)
    if _____95EA_70C1_671F_95F4_6682_505C_5355_4F4D and not _____539F_672C_5DF2_6682_505C then
        PauseUnit(_____5355_4F4D, true)
    end
    ShowUnit(_____5355_4F4D, false)
    if _____6301_7EED_65F6_95F4 <= 0 then
        SetUnitPosition(_____5355_4F4D, _____53C2_6570["目标X"], _____53C2_6570["目标Y"])
        if _____53C2_6570["朝向"] ~= nil then
            SetUnitFacing(_____5355_4F4D, _____53C2_6570["朝向"])
        else
            SetUnitFacing(
                _____5355_4F4D,
                GetUnitFacing(_____5355_4F4D)
            )
        end
        ShowUnit(_____5355_4F4D, true)
        if _____95EA_70C1_671F_95F4_6682_505C_5355_4F4D and not _____539F_672C_5DF2_6682_505C then
            PauseUnit(_____5355_4F4D, false)
        end
        _____64AD_653E_95EA_70C1_7279_6548(_____53C2_6570["结束特效"], _____53C2_6570["目标X"], _____53C2_6570["目标Y"], _____7279_6548_751F_547D_5468_671F)
        if _____7ED3_675F_540E_9009_4E2D_5355_4F4D then
            _____672C_5730_4E3A_5355_4F4D_62E5_6709_8005_91CD_65B0_9009_4E2D_5355_4F4D(_____5355_4F4D)
        end
        return 0
    end
    local id = _____4E0B_4E00_4E2A_95EA_70C1ID
    _____4E0B_4E00_4E2A_95EA_70C1ID = _____4E0B_4E00_4E2A_95EA_70C1ID + 1
    local _____5B9E_4F8B = {
        ID = id,
        ["单位"] = _____5355_4F4D,
        ["目标X"] = _____53C2_6570["目标X"],
        ["目标Y"] = _____53C2_6570["目标Y"],
        ["剩余时间"] = _____6301_7EED_65F6_95F4,
        ["朝向"] = _____53C2_6570["朝向"],
        ["结束特效"] = _____53C2_6570["结束特效"],
        ["特效生命周期"] = _____7279_6548_751F_547D_5468_671F,
        ["闪烁期间暂停单位"] = _____95EA_70C1_671F_95F4_6682_505C_5355_4F4D,
        ["结束后选中单位"] = _____7ED3_675F_540E_9009_4E2D_5355_4F4D,
        ["单位原本已暂停"] = _____539F_672C_5DF2_6682_505C
    }
    _____6D3B_52A8_95EA_70C1_5217_8868[#_____6D3B_52A8_95EA_70C1_5217_8868 + 1] = _____5B9E_4F8B
    _____95EA_70C1_6620_5C04[id] = _____5B9E_4F8B
    _____6CE8_518C_95EA_70C1Tick()
    return id
end
____exports["停止闪烁"] = function(id)
    local _____5B9E_4F8B = _____95EA_70C1_6620_5C04[id]
    if not _____5B9E_4F8B then
        return
    end
    _____7ED3_675F_95EA_70C1_5B9E_4F8B(_____5B9E_4F8B, false)
end
return ____exports
