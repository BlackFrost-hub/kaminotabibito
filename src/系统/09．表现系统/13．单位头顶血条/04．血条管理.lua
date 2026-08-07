local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local Set = ____lualib.Set
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
local ____00_FF0E_5E38_91CF = require("系统.09．表现系统.13．单位头顶血条.00．常量")
local _____542F_7528_5355_4F4D_5934_9876_8840_6761 = ____00_FF0E_5E38_91CF["启用单位头顶血条"]
local _____8840_6761_5237_65B0_95F4_9694Tick = ____00_FF0E_5E38_91CF["血条刷新间隔Tick"]
local _____8840_6761_521B_5EFA_6BCF_6279_6570_91CF = ____00_FF0E_5E38_91CF["血条创建每批数量"]
local _____8840_6761_5C3A_5BF8 = ____00_FF0E_5E38_91CF["血条尺寸"]
local _____8840_6761_8D44_6E90 = ____00_FF0E_5E38_91CF["血条资源"]
local ____03_FF0E_8840_6761_6C60 = require("系统.09．表现系统.13．单位头顶血条.03．血条池")
local _____53D6_5355_4F4D_8840_6761_5E27_7EC4 = ____03_FF0E_8840_6761_6C60["取单位血条帧组"]
local _____56DE_6536_5355_4F4D_8840_6761_5E27_7EC4 = ____03_FF0E_8840_6761_6C60["回收单位血条帧组"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local _____53EF_653B_51FB_6467_6BC1_5F39_5E55_5355_4F4D_7C7B_578B = ____require_result_2["可攻击摧毁弹幕单位类型"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.index")
local _____67E5_8BE2_5355_4F4D_53EF_663E_793A_62A4_76FE_503C = ____require_result_3["查询单位可显示护盾值"]
local _____67E5_8BE2_5355_4F4D_62A4_76FE_5217_8868 = ____require_result_3["查询单位护盾列表"]
local _____62A4_76FE_7C7B_578B = ____require_result_3["护盾类型"]
local ____require_result_4 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterEnterRectSimple = ____require_result_4.TriggerRegisterEnterRectSimple
local GetHandleId = jass.GetHandleId
local GetWorldBounds = jass.GetWorldBounds
local GetTriggerUnit = jass.GetTriggerUnit
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local CreateGroup = jass.CreateGroup
local GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local DestroyGroup = jass.DestroyGroup
local IsUnitType = jass.IsUnitType
local IsUnitEnemy = jass.IsUnitEnemy
local GetLocalPlayer = jass.GetLocalPlayer
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitState = jass.GetUnitState
local GetUnitLevel = jass.GetUnitLevel
local GetUnitName = jass.GetUnitName
local GetUnitTypeId = jass.GetUnitTypeId
local R2I = jass.R2I
local CreateTimer = jass.CreateTimer
local DestroyTimer = jass.DestroyTimer
local GetExpiredTimer = jass.GetExpiredTimer
local TimerStart = jass.TimerStart
local DzFrameShow = japi.DzFrameShow
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetText = japi.DzFrameSetText
local DzFrameBindWidget = japi.DzFrameBindWidget
local DzDisableUnitPreselectUi = japi.DzDisableUnitPreselectUi
local DzSetUnitPreselectUIVisible = japi.DzSetUnitPreselectUIVisible
local DzFrameGetUnitHpBar = japi.DzFrameGetUnitHpBar
local _____751F_547D_72B6_6001 = jass.UNIT_STATE_LIFE
local _____6700_5927_751F_547D_72B6_6001 = jass.UNIT_STATE_MAX_LIFE
local _____9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MANA
local _____6700_5927_9B54_6CD5_72B6_6001 = jass.UNIT_STATE_MAX_MANA
local _____5355_4F4D_6B7B_4EA1_7C7B_578B = jass.UNIT_TYPE_DEAD
local _____5355_4F4D_82F1_96C4_7C7B_578B = jass.UNIT_TYPE_HERO
local _____5355_4F4D_53E4_6811_7C7B_578B = jass.UNIT_TYPE_ANCIENT
local _____8757_866B_6280_80FDID = stringToFourCCSafe("Aloc")
local _____5355_4F4D_8840_6761_8868 = __TS__New(Map)
local _____5355_4F4DID_5217_8868 = {}
local _____82F1_96C4_6B7B_4EA1_9690_85CF_8840_6761ID_96C6_5408 = __TS__New(Set)
local _____5F85_521B_5EFA_5355_4F4D_961F_5217 = {}
local _____5F85_521B_5EFA_5355_4F4DID_96C6_5408 = __TS__New(Set)
local g = _G
local _____5DF2_521D_59CB_5316 = false
local ____tick_8BA1_6570 = 0
local _____5F85_521B_5EFA_5355_4F4D_8BFB_53D6_7D22_5F15 = 0
local function _____53D6_539F_751F_8840_6761_5E27(unit)
    return DzFrameGetUnitHpBar(unit)
end
local function _____9690_85CF_5355_4F4D_539F_751F_8840_6761(unit)
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
local function _____9650_523601(value)
    if not (value > 0) then
        return 0
    end
    if value > 1 then
        return 1
    end
    return value
end
local function _____5355_4F4D_5B58_6D3B(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if GetUnitTypeId(unit) == 0 then
        return false
    end
    if IsUnitType(unit, _____5355_4F4D_6B7B_4EA1_7C7B_578B) then
        return false
    end
    return GetUnitState(unit, _____751F_547D_72B6_6001) > 0.405
end
local function _____5355_4F4D_53EF_6CE8_518C_8840_6761(unit)
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    if GetUnitAbilityLevel(unit, _____8757_866B_6280_80FDID) > 0 then
        return false
    end
    if IsUnitType(unit, _____5355_4F4D_53E4_6811_7C7B_578B) and GetUnitTypeId(unit) ~= _____53EF_653B_51FB_6467_6BC1_5F39_5E55_5355_4F4D_7C7B_578B then
        return false
    end
    return true
end
local function _____52A0_5165_5F85_521B_5EFA_5355_4F4D(unit)
    if not _____5355_4F4D_53EF_6CE8_518C_8840_6761(unit) then
        return
    end
    local unitId = GetHandleId(unit)
    if unitId == 0 or _____5355_4F4D_8840_6761_8868:has(unitId) or _____5F85_521B_5EFA_5355_4F4DID_96C6_5408:has(unitId) then
        return
    end
    _____9690_85CF_5355_4F4D_539F_751F_8840_6761(unit)
    _____5F85_521B_5EFA_5355_4F4DID_96C6_5408:add(unitId)
    _____5F85_521B_5EFA_5355_4F4D_961F_5217[#_____5F85_521B_5EFA_5355_4F4D_961F_5217 + 1] = unit
end
local function _____53D6_5934_9876_9AD8_5EA6(unit, isHero)
    if isHero then
        return _____8840_6761_5C3A_5BF8["英雄头顶高度"]
    end
    local level = GetUnitLevel(unit)
    if level >= 30 then
        return _____8840_6761_5C3A_5BF8["Boss头顶高度"]
    end
    return _____8840_6761_5C3A_5BF8["默认头顶高度"]
end
local function _____5E94_663E_793A_540D_5B57(isHero, unit)
    if isHero then
        return true
    end
    return GetUnitLevel(unit) >= 30
end
local function _____53BB_9664_9B54_517D_989C_8272_7801(text)
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
                        goto __continue27
                    end
                    if next == "c" or next == "C" then
                        i = i + 9
                        goto __continue27
                    end
                end
                result = result .. ch
            end
            ::__continue27::
            i = i + 1
        end
    end
    return result
end
local function _____53D6_8840_6761_540D_5B57_6587_672C(unit)
    return ("|cffffe6a8" .. _____53BB_9664_9B54_517D_989C_8272_7801(GetUnitName(unit))) .. "|r"
end
local function _____81EA_52A8_6CE8_518C_5355_4F4D_5934_9876_8840_6761(unit)
    if not _____5355_4F4D_53EF_6CE8_518C_8840_6761(unit) then
        return
    end
    _____52A0_5165_5F85_521B_5EFA_5355_4F4D(unit)
end
local function _____53D6_751F_547D_8D34_56FE(unit, lifePct)
    local localPlayer = GetLocalPlayer()
    if IsUnitEnemy(unit, localPlayer) then
        return _____8840_6761_8D44_6E90["敌方生命"]
    end
    if lifePct <= 0.6 then
        local index = R2I(lifePct * 20)
        return _____8840_6761_8D44_6E90["生命低血渐变"][(index < 0 and 0 or (index > 12 and 12 or index)) + 1]
    end
    return _____8840_6761_8D44_6E90["友方生命"]
end
local function _____66F4_65B0_751F_547D_8D34_56FE(binding, lifePct)
    local texture = _____53D6_751F_547D_8D34_56FE(binding["单位"], lifePct)
    if binding["生命贴图缓存"] == texture then
        return
    end
    binding["生命贴图缓存"] = texture
    DzFrameSetTexture(binding["帧"].life, texture, 0)
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
local function _____8BA1_7B97_6709_6548_751F_547D_663E_793A_53C2_6570(life, maxLife, shield)
    local safeMaxLife = maxLife > 1 and maxLife or 1
    local safeLife = life > 0 and life or 0
    local safeShield = shield > 0 and shield or 0
    local effectiveLife = safeLife + safeShield
    local displayCapacity = effectiveLife > safeMaxLife and effectiveLife or safeMaxLife
    return {
        ["实际生命比例"] = _____9650_523601(safeLife / safeMaxLife),
        ["生命显示比例"] = _____9650_523601(safeLife / displayCapacity),
        ["护盾值"] = safeShield,
        ["显示容量"] = displayCapacity
    }
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
                    goto __continue58
                end
                local found = false
                do
                    local j = 0
                    while j < #result do
                        if result[j + 1]["类型"] == shield["类型"] then
                            local ____result_index_5, _____6570_503C_6 = result[j + 1], "数值"
                            ____result_index_5[_____6570_503C_6] = ____result_index_5[_____6570_503C_6] + shield["当前值"]
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
            ::__continue58::
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
local function _____9690_85CF_62A4_76FE_5206_6BB5(binding, startIndex)
    do
        local i = startIndex
        while i < #binding["帧"].shields do
            DzFrameShow(binding["帧"].shields[i + 1], false)
            i = i + 1
        end
    end
end
local function _____5237_65B0_62A4_76FE_5206_6BB5(binding, lifeDisplayPct, displayCapacity, shield)
    if not (shield > 0) then
        _____9690_85CF_62A4_76FE_5206_6BB5(binding, 0)
        return
    end
    local segments = _____5408_5E76_62A4_76FE_663E_793A_5206_6BB5(binding["单位"])
    if #segments <= 0 then
        _____9690_85CF_62A4_76FE_5206_6BB5(binding, 0)
        return
    end
    local totalVisiblePct = _____9650_523601(shield / displayCapacity)
    local startPct = lifeDisplayPct
    local usedPct = 0
    local frameIndex = 0
    do
        local i = 0
        while i < #segments and frameIndex < #binding["帧"].shields do
            local segmentPct = _____9650_523601(segments[i + 1]["数值"] / displayCapacity)
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
local function _____7ED1_5B9A_5E27_5230_5355_4F4D(_____5E27, unit, height)
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
local function _____9690_85CF_7ED1_5B9A(binding)
    DzFrameShow(binding["帧"].root, false)
end
local function _____6FC0_6D3B_7ED1_5B9A_663E_793A(binding)
    DzFrameShow(binding["帧"].root, true)
    DzFrameShow(
        binding["帧"].name,
        _____5E94_663E_793A_540D_5B57(binding["是否英雄"], binding["单位"])
    )
end
local function _____8C03_6574_6839_6846_5C3A_5BF8(binding)
    DzFrameSetSize(binding["帧"].root, _____8840_6761_5C3A_5BF8["根宽"], binding["最大魔法缓存"] > 0 and _____8840_6761_5C3A_5BF8["根高"] or _____8840_6761_5C3A_5BF8["仅生命根高"])
end
local function _____521D_59CB_5316_5E27_5185_5BB9(binding)
    local _____5E27 = binding["帧"]
    local unit = binding["单位"]
    local display = _____8BA1_7B97_6709_6548_751F_547D_663E_793A_53C2_6570(
        GetUnitState(unit, _____751F_547D_72B6_6001),
        binding["最大生命缓存"],
        _____67E5_8BE2_5355_4F4D_53EF_663E_793A_62A4_76FE_503C(unit)
    )
    binding["生命缓降比例"] = display["生命显示比例"]
    _____66F4_65B0_751F_547D_8D34_56FE(binding, display["实际生命比例"])
    DzFrameSetSize(_____5E27.life, _____8840_6761_5C3A_5BF8["内条宽"] * display["生命显示比例"], _____8840_6761_5C3A_5BF8["生命高"])
    DzFrameSetSize(_____5E27.lifeLag, 0, _____8840_6761_5C3A_5BF8["生命高"])
    DzFrameSetText(
        _____5E27.name,
        _____53D6_8840_6761_540D_5B57_6587_672C(unit)
    )
    _____8C03_6574_6839_6846_5C3A_5BF8(binding)
    DzFrameShow(_____5E27.mana, binding["最大魔法缓存"] > 0)
    DzFrameShow(_____5E27.lifeLag, false)
    _____5237_65B0_62A4_76FE_5206_6BB5(binding, display["生命显示比例"], display["显示容量"], display["护盾值"])
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
    local maxLife = GetUnitStateJapi(unit, _____6700_5927_751F_547D_72B6_6001)
    local maxMana = GetUnitStateJapi(unit, _____6700_5927_9B54_6CD5_72B6_6001)
    local isHero = IsUnitType(unit, _____5355_4F4D_82F1_96C4_7C7B_578B)
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
local function _____6CE8_9500_5355_4F4D_5934_9876_8840_6761(unitId)
    local binding = _____5355_4F4D_8840_6761_8868:get(unitId)
    if binding == nil then
        return
    end
    _____82F1_96C4_6B7B_4EA1_9690_85CF_8840_6761ID_96C6_5408:delete(unitId)
    _____9690_85CF_7ED1_5B9A(binding)
    _____56DE_6536_5355_4F4D_8840_6761_5E27_7EC4(binding["帧"])
    _____5355_4F4D_8840_6761_8868:delete(unitId)
end
local function _____5237_65B0_751F_547D_9B54_6CD5(binding)
    local unit = binding["单位"]
    local life = GetUnitState(unit, _____751F_547D_72B6_6001)
    local maxLifeNow = GetUnitStateJapi(unit, _____6700_5927_751F_547D_72B6_6001)
    if maxLifeNow > 1 then
        binding["最大生命缓存"] = maxLifeNow
    end
    local maxLife = binding["最大生命缓存"] > 1 and binding["最大生命缓存"] or 1
    local display = _____8BA1_7B97_6709_6548_751F_547D_663E_793A_53C2_6570(
        life,
        maxLife,
        _____67E5_8BE2_5355_4F4D_53EF_663E_793A_62A4_76FE_503C(unit)
    )
    local lifeWidth = _____8840_6761_5C3A_5BF8["内条宽"] * display["生命显示比例"]
    _____66F4_65B0_751F_547D_8D34_56FE(binding, display["实际生命比例"])
    DzFrameSetSize(binding["帧"].life, lifeWidth, _____8840_6761_5C3A_5BF8["生命高"])
    _____66F4_65B0_751F_547D_7F13_964D(binding, display["生命显示比例"])
    _____5237_65B0_62A4_76FE_5206_6BB5(binding, display["生命显示比例"], display["显示容量"], display["护盾值"])
    local maxManaNow = GetUnitStateJapi(unit, _____6700_5927_9B54_6CD5_72B6_6001)
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
local function _____5904_7406_5F85_521B_5EFA_5355_4F4D()
    local _____672C_8F6E_68C0_67E5_6570_91CF = 0
    while _____672C_8F6E_68C0_67E5_6570_91CF < _____8840_6761_521B_5EFA_6BCF_6279_6570_91CF and _____5F85_521B_5EFA_5355_4F4D_8BFB_53D6_7D22_5F15 < #_____5F85_521B_5EFA_5355_4F4D_961F_5217 do
        do
            local unit = _____5F85_521B_5EFA_5355_4F4D_961F_5217[_____5F85_521B_5EFA_5355_4F4D_8BFB_53D6_7D22_5F15 + 1]
            _____5F85_521B_5EFA_5355_4F4D_8BFB_53D6_7D22_5F15 = _____5F85_521B_5EFA_5355_4F4D_8BFB_53D6_7D22_5F15 + 1
            _____672C_8F6E_68C0_67E5_6570_91CF = _____672C_8F6E_68C0_67E5_6570_91CF + 1
            local unitId = GetHandleId(unit)
            if unitId ~= 0 then
                _____5F85_521B_5EFA_5355_4F4DID_96C6_5408:delete(unitId)
            end
            if not _____5355_4F4D_53EF_6CE8_518C_8840_6761(unit) then
                goto __continue97
            end
            if unitId == 0 or _____5355_4F4D_8840_6761_8868:has(unitId) then
                goto __continue97
            end
            ____exports["注册单位头顶血条"](unit)
        end
        ::__continue97::
    end
    if _____5F85_521B_5EFA_5355_4F4D_8BFB_53D6_7D22_5F15 >= #_____5F85_521B_5EFA_5355_4F4D_961F_5217 then
        __TS__ArraySetLength(_____5F85_521B_5EFA_5355_4F4D_961F_5217, 0)
        _____5F85_521B_5EFA_5355_4F4D_8BFB_53D6_7D22_5F15 = 0
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
    _____5904_7406_5F85_521B_5EFA_5355_4F4D()
    local writeIndex = 0
    do
        local i = 0
        while i < #_____5355_4F4DID_5217_8868 do
            do
                local unitId = _____5355_4F4DID_5217_8868[i + 1]
                local binding = _____5355_4F4D_8840_6761_8868:get(unitId)
                if binding == nil then
                    goto __continue106
                end
                if not _____5355_4F4D_5B58_6D3B(binding["单位"]) then
                    if binding["是否英雄"] and GetUnitTypeId(binding["单位"]) ~= 0 then
                        if not _____82F1_96C4_6B7B_4EA1_9690_85CF_8840_6761ID_96C6_5408:has(unitId) then
                            _____82F1_96C4_6B7B_4EA1_9690_85CF_8840_6761ID_96C6_5408:add(unitId)
                            _____9690_85CF_7ED1_5B9A(binding)
                        end
                        _____5355_4F4DID_5217_8868[writeIndex + 1] = unitId
                        writeIndex = writeIndex + 1
                        goto __continue106
                    end
                    _____6CE8_9500_5355_4F4D_5934_9876_8840_6761(unitId)
                    goto __continue106
                end
                _____5355_4F4DID_5217_8868[writeIndex + 1] = unitId
                writeIndex = writeIndex + 1
                if _____82F1_96C4_6B7B_4EA1_9690_85CF_8840_6761ID_96C6_5408:has(unitId) then
                    _____82F1_96C4_6B7B_4EA1_9690_85CF_8840_6761ID_96C6_5408:delete(unitId)
                    _____521D_59CB_5316_5E27_5185_5BB9(binding)
                    _____6FC0_6D3B_7ED1_5B9A_663E_793A(binding)
                end
                _____9690_85CF_5355_4F4D_539F_751F_8840_6761(binding["单位"])
                _____5237_65B0_751F_547D_9B54_6CD5(binding)
            end
            ::__continue106::
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
    _____81EA_52A8_6CE8_518C_5355_4F4D_5934_9876_8840_6761(unit)
end
local function _____6CE8_518C_5DF2_6709_5355_4F4D()
    local group = CreateGroup()
    GroupEnumUnitsInRect(
        group,
        GetWorldBounds(),
        nil
    )
    local unit = FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(group, unit)
        _____81EA_52A8_6CE8_518C_5355_4F4D_5934_9876_8840_6761(unit)
        unit = FirstOfGroup(group)
    end
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
