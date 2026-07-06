local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local ____exports = {}
local _____53D6_539F_751F_8840_6761_5E27, _____9690_85CF_5355_4F4D_539F_751F_8840_6761, _____9650_523601, _____5355_4F4D_5B58_6D3B, _____5355_4F4D_53EF_6CE8_518C_8840_6761, _____53D6_5934_9876_9AD8_5EA6, _____5E94_663E_793A_540D_5B57, _____53BB_9664_9B54_517D_989C_8272_7801, _____53D6_8840_6761_540D_5B57_6587_672C, _____53D6_751F_547D_8D34_56FE, _____66F4_65B0_751F_547D_8D34_56FE, _____9690_85CF_62A4_76FE_5206_6BB5, _____7ED1_5B9A_5E27_5230_5355_4F4D, _____6FC0_6D3B_7ED1_5B9A_663E_793A, _____8C03_6574_6839_6846_5C3A_5BF8, _____521D_59CB_5316_5E27_5185_5BB9, jass, GetHandleId, IsUnitType, IsUnitEnemy, GetLocalPlayer, GetUnitAbilityLevel, GetUnitState, GetUnitLevel, GetUnitName, GetUnitTypeId, DzFrameShow, DzFrameSetSize, DzFrameSetTexture, DzFrameSetText, DzFrameBindWidget, DzSetUnitPreselectUIVisible, DzFrameGetUnitHpBar, _____751F_547D_72B6_6001, _____6700_5927_751F_547D_72B6_6001, _____6700_5927_9B54_6CD5_72B6_6001, _____8757_866B_6280_80FDID, _____5355_4F4D_8840_6761_8868, _____5355_4F4DID_5217_8868
local ____00_FF0E_5E38_91CF = require("系统.09．表现系统.13．单位头顶血条.00．常量")
local _____542F_7528_5355_4F4D_5934_9876_8840_6761 = ____00_FF0E_5E38_91CF["启用单位头顶血条"]
local _____8840_6761_5237_65B0_95F4_9694Tick = ____00_FF0E_5E38_91CF["血条刷新间隔Tick"]
local _____8840_6761_5C3A_5BF8 = ____00_FF0E_5E38_91CF["血条尺寸"]
local _____8840_6761_8D44_6E90 = ____00_FF0E_5E38_91CF["血条资源"]
local ____03_FF0E_8840_6761_6C60 = require("系统.09．表现系统.13．单位头顶血条.03．血条池")
local _____53D6_5355_4F4D_8840_6761_5E27_7EC4 = ____03_FF0E_8840_6761_6C60["取单位血条帧组"]
local _____56DE_6536_5355_4F4D_8840_6761_5E27_7EC4 = ____03_FF0E_8840_6761_6C60["回收单位血条帧组"]
function _____53D6_539F_751F_8840_6761_5E27(unit)
    return DzFrameGetUnitHpBar(unit)
end
function _____9690_85CF_5355_4F4D_539F_751F_8840_6761(unit)
    if unit == nil or unit == 0 then
        return
    end
    DzSetUnitPreselectUIVisible(unit, false)
    local hpBar = _____53D6_539F_751F_8840_6761_5E27(unit)
    if hpBar == nil or hpBar == 0 then
        return
    end
    DzFrameShow(hpBar, false)
end
function _____9650_523601(value)
    if not (value > 0) then
        return 0
    end
    if value > 1 then
        return 1
    end
    return value
end
function _____5355_4F4D_5B58_6D3B(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if GetUnitTypeId(unit) == 0 then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_DEAD) then
        return false
    end
    return GetUnitState(unit, _____751F_547D_72B6_6001) > 0.405
end
function _____5355_4F4D_53EF_6CE8_518C_8840_6761(unit)
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE) then
        return false
    end
    if GetUnitAbilityLevel(unit, _____8757_866B_6280_80FDID) > 0 then
        return false
    end
    return true
end
function _____53D6_5934_9876_9AD8_5EA6(unit, isHero)
    if isHero then
        return _____8840_6761_5C3A_5BF8["英雄头顶高度"]
    end
    local level = GetUnitLevel(unit)
    if level >= 30 then
        return _____8840_6761_5C3A_5BF8["Boss头顶高度"]
    end
    return _____8840_6761_5C3A_5BF8["默认头顶高度"]
end
function _____5E94_663E_793A_540D_5B57(isHero, unit)
    if isHero then
        return true
    end
    return GetUnitLevel(unit) >= 30
end
function _____53BB_9664_9B54_517D_989C_8272_7801(text)
    local result = ""
    do
        local i = 0
        while i < #text do
            do
                local ch = __TS__StringCharAt(text, i)
                if ch == "|" and i + 1 < #text then
                    local next = __TS__StringCharAt(text, i + 1)
                    if next == "r" or next == "R" then
                        i = i + 1
                        goto __continue24
                    end
                    if next == "c" or next == "C" then
                        i = i + 9
                        goto __continue24
                    end
                end
                result = result .. ch
            end
            ::__continue24::
            i = i + 1
        end
    end
    return result
end
function _____53D6_8840_6761_540D_5B57_6587_672C(unit)
    return ("|cffffe6a8" .. _____53BB_9664_9B54_517D_989C_8272_7801(GetUnitName(unit))) .. "|r"
end
function _____53D6_751F_547D_8D34_56FE(unit, lifePct)
    local localPlayer = GetLocalPlayer()
    if IsUnitEnemy(unit, localPlayer) then
        return _____8840_6761_8D44_6E90["敌方生命"]
    end
    if lifePct <= 0.6 then
        local index = math.floor(lifePct * 20)
        return _____8840_6761_8D44_6E90["生命低血渐变"][(index < 0 and 0 or (index > 12 and 12 or index)) + 1]
    end
    return _____8840_6761_8D44_6E90["友方生命"]
end
function _____66F4_65B0_751F_547D_8D34_56FE(binding, lifePct)
    local texture = _____53D6_751F_547D_8D34_56FE(binding["单位"], lifePct)
    if binding["生命贴图缓存"] == texture then
        return
    end
    binding["生命贴图缓存"] = texture
    DzFrameSetTexture(binding["帧"].life, texture, 0)
end
function _____9690_85CF_62A4_76FE_5206_6BB5(binding, startIndex)
    do
        local i = startIndex
        while i < #binding["帧"].shields do
            DzFrameShow(binding["帧"].shields[i + 1], false)
            i = i + 1
        end
    end
end
function _____7ED1_5B9A_5E27_5230_5355_4F4D(_____5E27, unit, height)
    DzFrameBindWidget(
        _____5E27.root,
        unit,
        0,
        0,
        height,
        0,
        0,
        false,
        true,
        false
    )
end
function _____6FC0_6D3B_7ED1_5B9A_663E_793A(binding)
    DzFrameShow(binding["帧"].root, true)
    DzFrameShow(
        binding["帧"].name,
        _____5E94_663E_793A_540D_5B57(binding["是否英雄"], binding["单位"])
    )
end
function _____8C03_6574_6839_6846_5C3A_5BF8(binding)
    DzFrameSetSize(binding["帧"].root, _____8840_6761_5C3A_5BF8["根宽"], binding["最大魔法缓存"] > 0 and _____8840_6761_5C3A_5BF8["根高"] or _____8840_6761_5C3A_5BF8["仅生命根高"])
end
function _____521D_59CB_5316_5E27_5185_5BB9(binding)
    local _____5E27 = binding["帧"]
    local unit = binding["单位"]
    local lifePct = _____9650_523601(GetUnitState(unit, _____751F_547D_72B6_6001) / binding["最大生命缓存"])
    binding["生命缓降比例"] = lifePct
    _____66F4_65B0_751F_547D_8D34_56FE(binding, lifePct)
    DzFrameSetSize(_____5E27.life, _____8840_6761_5C3A_5BF8["内条宽"] * lifePct, _____8840_6761_5C3A_5BF8["生命高"])
    DzFrameSetSize(_____5E27.lifeLag, 0, _____8840_6761_5C3A_5BF8["生命高"])
    DzFrameSetText(
        _____5E27.name,
        _____53D6_8840_6761_540D_5B57_6587_672C(unit)
    )
    _____8C03_6574_6839_6846_5C3A_5BF8(binding)
    DzFrameShow(_____5E27.mana, binding["最大魔法缓存"] > 0)
    DzFrameShow(_____5E27.lifeLag, false)
    _____9690_85CF_62A4_76FE_5206_6BB5(binding, 0)
    _____7ED1_5B9A_5E27_5230_5355_4F4D(
        _____5E27,
        unit,
        _____53D6_5934_9876_9AD8_5EA6(unit, binding["是否英雄"])
    )
    _____9690_85CF_5355_4F4D_539F_751F_8840_6761(unit)
end
____exports["注册单位头顶血条"] = function(unit)
    if not _____542F_7528_5355_4F4D_5934_9876_8840_6761 then
        return
    end
    if not _____5355_4F4D_53EF_6CE8_518C_8840_6761(unit) then
        return
    end
    local unitId = GetHandleId(unit)
    if unitId == 0 then
        return
    end
    if _____5355_4F4D_8840_6761_8868:has(unitId) then
        return
    end
    local _____5E27 = _____53D6_5355_4F4D_8840_6761_5E27_7EC4()
    if _____5E27 == nil then
        return
    end
    local maxLife = GetUnitState(unit, _____6700_5927_751F_547D_72B6_6001)
    local maxMana = GetUnitState(unit, _____6700_5927_9B54_6CD5_72B6_6001)
    local isHero = IsUnitType(unit, jass.UNIT_TYPE_HERO)
    local binding = {
        ["单位"] = unit,
        ["单位ID"] = unitId,
        ["帧"] = _____5E27,
        ["最大生命缓存"] = maxLife > 1 and maxLife or 1,
        ["最大魔法缓存"] = maxMana > 0 and maxMana or 0,
        ["是否英雄"] = isHero,
        ["生命贴图缓存"] = "",
        ["生命缓降比例"] = 1,
        ["护盾贴图缓存"] = {}
    }
    _____5355_4F4D_8840_6761_8868:set(unitId, binding)
    _____5355_4F4DID_5217_8868[#_____5355_4F4DID_5217_8868 + 1] = unitId
    _____9690_85CF_5355_4F4D_539F_751F_8840_6761(unit)
    _____521D_59CB_5316_5E27_5185_5BB9(binding)
    _____6FC0_6D3B_7ED1_5B9A_663E_793A(binding)
end
jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.index")
local _____67E5_8BE2_5355_4F4D_53EF_663E_793A_62A4_76FE_503C = ____require_result_2["查询单位可显示护盾值"]
local _____67E5_8BE2_5355_4F4D_62A4_76FE_5217_8868 = ____require_result_2["查询单位护盾列表"]
local _____62A4_76FE_7C7B_578B = ____require_result_2["护盾类型"]
local ____require_result_3 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterEnterRectSimple = ____require_result_3.TriggerRegisterEnterRectSimple
GetHandleId = jass.GetHandleId
local GetWorldBounds = jass.GetWorldBounds
local GetTriggerUnit = jass.GetTriggerUnit
local GetEnumUnit = jass.GetEnumUnit
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local CreateGroup = jass.CreateGroup
local GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect
local ForGroup = jass.ForGroup
local DestroyGroup = jass.DestroyGroup
IsUnitType = jass.IsUnitType
IsUnitEnemy = jass.IsUnitEnemy
local GetOwningPlayer = jass.GetOwningPlayer
GetLocalPlayer = jass.GetLocalPlayer
GetUnitAbilityLevel = jass.GetUnitAbilityLevel
GetUnitState = jass.GetUnitState
GetUnitLevel = jass.GetUnitLevel
GetUnitName = jass.GetUnitName
GetUnitTypeId = jass.GetUnitTypeId
local CreateTimer = jass.CreateTimer
local DestroyTimer = jass.DestroyTimer
local GetExpiredTimer = jass.GetExpiredTimer
local TimerStart = jass.TimerStart
DzFrameShow = japi.DzFrameShow
DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetPoint = japi.DzFrameSetPoint
DzFrameSetTexture = japi.DzFrameSetTexture
DzFrameSetText = japi.DzFrameSetText
DzFrameBindWidget = japi.DzFrameBindWidget
local DzDisableUnitPreselectUi = japi.DzDisableUnitPreselectUi
DzSetUnitPreselectUIVisible = japi.DzSetUnitPreselectUIVisible
DzFrameGetUnitHpBar = japi.DzFrameGetUnitHpBar
_____751F_547D_72B6_6001 = jass.UNIT_STATE_LIFE
_____6700_5927_751F_547D_72B6_6001 = jass.UNIT_STATE_MAX_LIFE
local _____9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MANA
_____6700_5927_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MAX_MANA
_____8757_866B_6280_80FDID = stringToFourCCSafe("Aloc")
_____5355_4F4D_8840_6761_8868 = __TS__New(Map)
_____5355_4F4DID_5217_8868 = {}
local g = _G
local _____5DF2_521D_59CB_5316 = false
local ____tick_8BA1_6570 = 0
local function _____5355_4F4D_662F_4F18_5148_8840_6761_5355_4F4D(unit)
    if IsUnitType(unit, jass.UNIT_TYPE_HERO) then
        return true
    end
    return GetUnitLevel(unit) >= 30
end
local function _____81EA_52A8_6CE8_518C_5355_4F4D_5934_9876_8840_6761(unit)
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return
    end
    _____9690_85CF_5355_4F4D_539F_751F_8840_6761(unit)
    ____exports["注册单位头顶血条"](unit)
end
local function _____66F4_65B0_751F_547D_7F13_964D(binding, lifePct)
    if lifePct >= binding["生命缓降比例"] then
        binding["生命缓降比例"] = lifePct
    else
        local nextPct = binding["生命缓降比例"] - _____8840_6761_5C3A_5BF8["生命缓降追赶比例"]
        binding["生命缓降比例"] = nextPct > lifePct and nextPct or lifePct
    end
    local lagPct = binding["生命缓降比例"] - lifePct
    if lagPct > 0.003 then
        DzFrameSetPoint(
            binding["帧"].lifeLag,
            0,
            binding["帧"].root,
            0,
            _____8840_6761_5C3A_5BF8["内条左偏移"] + _____8840_6761_5C3A_5BF8["内条宽"] * lifePct,
            _____8840_6761_5C3A_5BF8["生命Y"]
        )
        DzFrameSetSize(binding["帧"].lifeLag, _____8840_6761_5C3A_5BF8["内条宽"] * lagPct, _____8840_6761_5C3A_5BF8["生命高"])
        DzFrameShow(binding["帧"].lifeLag, true)
    else
        DzFrameShow(binding["帧"].lifeLag, false)
    end
end
local function _____53D6_62A4_76FE_8D34_56FE(shieldType)
    if shieldType == _____62A4_76FE_7C7B_578B["物理"] then
        return _____8840_6761_8D44_6E90["护盾"]["物理"]
    end
    if shieldType == _____62A4_76FE_7C7B_578B["魔法"] then
        return _____8840_6761_8D44_6E90["护盾"]["魔法"]
    end
    if shieldType == _____62A4_76FE_7C7B_578B["强化"] then
        return _____8840_6761_8D44_6E90["护盾"]["强化"]
    end
    if shieldType == _____62A4_76FE_7C7B_578B["火"] then
        return _____8840_6761_8D44_6E90["护盾"]["火"]
    end
    if shieldType == _____62A4_76FE_7C7B_578B["水"] or shieldType == _____62A4_76FE_7C7B_578B["冰"] then
        return _____8840_6761_8D44_6E90["护盾"]["水冰"]
    end
    if shieldType == _____62A4_76FE_7C7B_578B["雷"] then
        return _____8840_6761_8D44_6E90["护盾"]["雷"]
    end
    if shieldType == _____62A4_76FE_7C7B_578B["金"] or shieldType == _____62A4_76FE_7C7B_578B["毒"] then
        return _____8840_6761_8D44_6E90["护盾"]["金毒"]
    end
    if shieldType == _____62A4_76FE_7C7B_578B["木"] or shieldType == _____62A4_76FE_7C7B_578B["风"] then
        return _____8840_6761_8D44_6E90["护盾"]["木风"]
    end
    if shieldType == _____62A4_76FE_7C7B_578B["光"] then
        return _____8840_6761_8D44_6E90["护盾"]["光"]
    end
    if shieldType == _____62A4_76FE_7C7B_578B["暗"] then
        return _____8840_6761_8D44_6E90["护盾"]["暗"]
    end
    return _____8840_6761_8D44_6E90["护盾"]["通用"]
end
local function _____5408_5E76_62A4_76FE_663E_793A_5206_6BB5(unit)
    local list = _____67E5_8BE2_5355_4F4D_62A4_76FE_5217_8868(unit)
    local result = {}
    do
        local i = 0
        while i < #list do
            do
                local shield = list[i + 1]
                if shield == nil or not shield["显示护盾条"] or not (shield["当前值"] > 0) then
                    goto __continue56
                end
                local found = false
                do
                    local j = 0
                    while j < #result do
                        if result[j + 1]["类型"] == shield["类型"] then
                            local ____result_index_4, _____6570_503C_5 = result[j + 1], "数值"
                            ____result_index_4[_____6570_503C_5] = ____result_index_4[_____6570_503C_5] + shield["当前值"]
                            found = true
                            break
                        end
                        j = j + 1
                    end
                end
                if not found then
                    result[#result + 1] = {["类型"] = shield["类型"], ["数值"] = shield["当前值"]}
                end
            end
            ::__continue56::
            i = i + 1
        end
    end
    return result
end
local function _____66F4_65B0_62A4_76FE_5206_6BB5_8D34_56FE(binding, index, shieldType)
    local texture = _____53D6_62A4_76FE_8D34_56FE(shieldType)
    if binding["护盾贴图缓存"][index + 1] == texture then
        return
    end
    binding["护盾贴图缓存"][index + 1] = texture
    DzFrameSetTexture(binding["帧"].shields[index + 1], texture, 0)
end
local function _____5237_65B0_62A4_76FE_5206_6BB5(binding, lifePct, maxLife)
    local shield = _____67E5_8BE2_5355_4F4D_53EF_663E_793A_62A4_76FE_503C(binding["单位"])
    if not (shield > 0) then
        _____9690_85CF_62A4_76FE_5206_6BB5(binding, 0)
        return
    end
    local segments = _____5408_5E76_62A4_76FE_663E_793A_5206_6BB5(binding["单位"])
    if #segments <= 0 then
        _____9690_85CF_62A4_76FE_5206_6BB5(binding, 0)
        return
    end
    local shieldPct = _____9650_523601(shield / maxLife)
    local emptyPct = _____9650_523601(1 - lifePct)
    local totalVisiblePct = emptyPct > 0.001 and (shieldPct > emptyPct and emptyPct or shieldPct) or shieldPct
    local startPct = emptyPct > 0.001 and lifePct or 1 - totalVisiblePct
    local usedPct = 0
    local frameIndex = 0
    do
        local i = 0
        while i < #segments and frameIndex < #binding["帧"].shields do
            local segmentPct = _____9650_523601(segments[i + 1]["数值"] / maxLife)
            if frameIndex == #binding["帧"].shields - 1 then
                segmentPct = totalVisiblePct - usedPct
            elseif usedPct + segmentPct > totalVisiblePct then
                segmentPct = totalVisiblePct - usedPct
            end
            if not (segmentPct > 0) then
                break
            end
            local frame = binding["帧"].shields[frameIndex + 1]
            _____66F4_65B0_62A4_76FE_5206_6BB5_8D34_56FE(binding, frameIndex, segments[i + 1]["类型"])
            DzFrameSetPoint(
                frame,
                0,
                binding["帧"].root,
                0,
                _____8840_6761_5C3A_5BF8["内条左偏移"] + _____8840_6761_5C3A_5BF8["内条宽"] * (startPct + usedPct),
                _____8840_6761_5C3A_5BF8["生命Y"]
            )
            DzFrameSetSize(frame, _____8840_6761_5C3A_5BF8["内条宽"] * segmentPct, _____8840_6761_5C3A_5BF8["生命高"])
            DzFrameShow(frame, true)
            usedPct = usedPct + segmentPct
            frameIndex = frameIndex + 1
            if usedPct >= totalVisiblePct then
                break
            end
            i = i + 1
        end
    end
    _____9690_85CF_62A4_76FE_5206_6BB5(binding, frameIndex)
end
local function _____9690_85CF_7ED1_5B9A(binding)
    DzFrameShow(binding["帧"].root, false)
end
local function _____6CE8_9500_5355_4F4D_5934_9876_8840_6761(unitId)
    local binding = _____5355_4F4D_8840_6761_8868:get(unitId)
    if binding == nil then
        return
    end
    _____9690_85CF_7ED1_5B9A(binding)
    _____56DE_6536_5355_4F4D_8840_6761_5E27_7EC4(binding["帧"])
    _____5355_4F4D_8840_6761_8868:delete(unitId)
end
local function _____5237_65B0_751F_547D_9B54_6CD5(binding)
    local unit = binding["单位"]
    local life = GetUnitState(unit, _____751F_547D_72B6_6001)
    local maxLifeNow = GetUnitState(unit, _____6700_5927_751F_547D_72B6_6001)
    if maxLifeNow > 1 then
        binding["最大生命缓存"] = maxLifeNow
    end
    local maxLife = binding["最大生命缓存"] > 1 and binding["最大生命缓存"] or 1
    local lifePct = _____9650_523601(life / maxLife)
    local lifeWidth = _____8840_6761_5C3A_5BF8["内条宽"] * lifePct
    _____66F4_65B0_751F_547D_8D34_56FE(binding, lifePct)
    DzFrameSetSize(binding["帧"].life, lifeWidth, _____8840_6761_5C3A_5BF8["生命高"])
    _____66F4_65B0_751F_547D_7F13_964D(binding, lifePct)
    _____5237_65B0_62A4_76FE_5206_6BB5(binding, lifePct, maxLife)
    local maxManaNow = GetUnitState(unit, _____6700_5927_9B54_6CD5_72B6_6001)
    if maxManaNow > 0 then
        binding["最大魔法缓存"] = maxManaNow
    end
    _____8C03_6574_6839_6846_5C3A_5BF8(binding)
    if binding["最大魔法缓存"] > 0 then
        local manaPct = _____9650_523601(GetUnitState(unit, _____9B54_6CD5_72B6_6001) / binding["最大魔法缓存"])
        DzFrameSetSize(binding["帧"].mana, _____8840_6761_5C3A_5BF8["内条宽"] * manaPct, _____8840_6761_5C3A_5BF8["魔法高"])
        DzFrameShow(binding["帧"].mana, true)
    else
        DzFrameShow(binding["帧"].mana, false)
    end
end
local function _____5237_65B0_6240_6709_5355_4F4D_5934_9876_8840_6761()
    if not _____542F_7528_5355_4F4D_5934_9876_8840_6761 then
        return
    end
    ____tick_8BA1_6570 = ____tick_8BA1_6570 + 1
    if ____tick_8BA1_6570 < _____8840_6761_5237_65B0_95F4_9694Tick then
        return
    end
    ____tick_8BA1_6570 = 0
    local writeIndex = 0
    do
        local i = 0
        while i < #_____5355_4F4DID_5217_8868 do
            do
                local unitId = _____5355_4F4DID_5217_8868[i + 1]
                local binding = _____5355_4F4D_8840_6761_8868:get(unitId)
                if binding == nil then
                    goto __continue98
                end
                if not _____5355_4F4D_5B58_6D3B(binding["单位"]) then
                    _____6CE8_9500_5355_4F4D_5934_9876_8840_6761(unitId)
                    goto __continue98
                end
                _____5355_4F4DID_5217_8868[writeIndex + 1] = unitId
                writeIndex = writeIndex + 1
                _____9690_85CF_5355_4F4D_539F_751F_8840_6761(binding["单位"])
                _____5237_65B0_751F_547D_9B54_6CD5(binding)
            end
            ::__continue98::
            i = i + 1
        end
    end
    do
        local i = #_____5355_4F4DID_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____5355_4F4DID_5217_8868)
            i = i - 1
        end
    end
end
local function ____on_5355_4F4D_8FDB_5165_5730_56FE()
    local unit = GetTriggerUnit()
    _____9690_85CF_5355_4F4D_539F_751F_8840_6761(unit)
    _____81EA_52A8_6CE8_518C_5355_4F4D_5934_9876_8840_6761(unit)
end
local function ____on_679A_4E3E_521D_59CB_5355_4F4D()
    local unit = GetEnumUnit()
    _____81EA_52A8_6CE8_518C_5355_4F4D_5934_9876_8840_6761(unit)
end
local function ____on_679A_4E3E_9690_85CF_539F_751F_8840_6761()
    _____9690_85CF_5355_4F4D_539F_751F_8840_6761(GetEnumUnit())
end
local function _____9690_85CF_5DF2_6709_5355_4F4D_539F_751F_8840_6761()
    local group = CreateGroup()
    GroupEnumUnitsInRect(
        group,
        GetWorldBounds(),
        nil
    )
    ForGroup(group, ____on_679A_4E3E_9690_85CF_539F_751F_8840_6761)
    DestroyGroup(group)
end
local function _____6CE8_518C_5DF2_6709_5355_4F4D()
    local group = CreateGroup()
    GroupEnumUnitsInRect(
        group,
        GetWorldBounds(),
        nil
    )
    ForGroup(group, ____on_679A_4E3E_521D_59CB_5355_4F4D)
    DestroyGroup(group)
end
local function _____6CE8_518C_8FDB_5165_4E8B_4EF6()
    local trig = CreateTrigger()
    TriggerRegisterEnterRectSimple(
        trig,
        GetWorldBounds()
    )
    TriggerAddAction(trig, ____on_5355_4F4D_8FDB_5165_5730_56FE)
end
local function _____5EF6_8FDF_521D_59CB_5316_5355_4F4D_5934_9876_8840_6761()
    local timer = GetExpiredTimer()
    if timer ~= nil and timer ~= 0 then
        DestroyTimer(timer)
    end
    DzDisableUnitPreselectUi()
    _____9690_85CF_5DF2_6709_5355_4F4D_539F_751F_8840_6761()
    _____6CE8_518C_5DF2_6709_5355_4F4D()
    _____6CE8_518C_8FDB_5165_4E8B_4EF6()
    onTick10ms(_____5237_65B0_6240_6709_5355_4F4D_5934_9876_8840_6761)
end
function ____exports.initUnitHeadHealthBar()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    if not _____542F_7528_5355_4F4D_5934_9876_8840_6761 then
        return
    end
    local timer = CreateTimer()
    TimerStart(timer, 0.05, false, _____5EF6_8FDF_521D_59CB_5316_5355_4F4D_5934_9876_8840_6761)
end
local function _____5168_5C40_6CE8_518C_5355_4F4D_5934_9876_8840_6761_5165_53E3(unit)
    ____exports["注册单位头顶血条"](unit)
end
g._registerUnitHeadHealthBar = _____5168_5C40_6CE8_518C_5355_4F4D_5934_9876_8840_6761_5165_53E3
return ____exports
