local ____lualib = require("lualib_bundle")
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local DestroyFloatText, _____4EC7_6068_663E_793A_8868
____exports["清除仇恨显示ById"] = function(_____654C_4EBAID)
    if _____654C_4EBAID == 0 then
        return
    end
    local _____6570_636E = _____4EC7_6068_663E_793A_8868[_____654C_4EBAID]
    if _____6570_636E == nil then
        return
    end
    if _____6570_636E.textTag ~= nil then
        DestroyFloatText(_____6570_636E.textTag)
    end
    __TS__Delete(_____4EC7_6068_663E_793A_8868, _____654C_4EBAID)
end
--- 04．仇恨显示
-- 
-- 给有仇恨表的敌人显示头顶跟随文字：
-- - 目标：XX
-- - 仇恨值：XXX
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
local CreateFloatTextOnUnit = ____require_result_0.CreateFloatTextOnUnit
DestroyFloatText = ____require_result_0.DestroyFloatText
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local _____529F_80FD_5F00_5173 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitName = jass.GetUnitName
local SetTextTagText = jass.SetTextTagText
local SetTextTagPosUnit = jass.SetTextTagPosUnit
local SetTextTagVisibility = jass.SetTextTagVisibility
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local R2I = jass.R2I
_____4EC7_6068_663E_793A_8868 = {}
local _____6587_5B57_9AD8_5EA6 = 50
local _____6587_5B57_5C3A_5BF8_9AD8_5EA6 = 9 * 0.0023
local _____8DDF_968F_5237_65B0_6BEB_79D2 = 40
local _____8DDF_968F_56DE_8C03ID = 0
local _____5DF2_6CE8_518C_6B7B_4EA1_6E05_7406 = false
local function _____53D6_5355_4F4DID(u)
    if u == nil or u == 0 then
        return 0
    end
    return GetHandleId(u) or 0
end
local function _____5355_4F4D_53E5_67C4_4ECD_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0
end
local function _____83B7_53D6_6709_5E8F_4EC7_6068_663E_793A_654C_4EBAID_5217_8868()
    local result = {}
    for key in pairs(_____4EC7_6068_663E_793A_8868) do
        local id = __TS__ParseInt(key, 10)
        if not __TS__NumberIsNaN(__TS__Number(id)) then
            result[#result + 1] = id
        end
    end
    __TS__ArraySort(result)
    return result
end
local function _____683C_5F0F_5316_4EC7_6068_503C(_____4EC7_6068_503C)
    local _____5B89_5168_4EC7_6068_503C = type(_____4EC7_6068_503C) == "number" and _____4EC7_6068_503C == _____4EC7_6068_503C and _____4EC7_6068_503C or 0
    local _____5341_500D_6574_6570 = R2I(_____5B89_5168_4EC7_6068_503C * 10 + 0.5)
    local _____6574_6570_90E8_5206 = R2I(_____5341_500D_6574_6570 / 10)
    local _____5C0F_6570_90E8_5206 = _____5341_500D_6574_6570 - _____6574_6570_90E8_5206 * 10
    return (tostring(_____6574_6570_90E8_5206) .. ".") .. tostring(_____5C0F_6570_90E8_5206)
end
local function _____6784_5EFA_4EC7_6068_6587_672C(_____76EE_6807_5355_4F4D, _____4EC7_6068_503C)
    local _____5355_4F4D_53E5_67C4_4ECD_6709_6548_result_2
    if _____5355_4F4D_53E5_67C4_4ECD_6709_6548(_____76EE_6807_5355_4F4D) then
        _____5355_4F4D_53E5_67C4_4ECD_6709_6548_result_2 = GetUnitName(_____76EE_6807_5355_4F4D)
    else
        _____5355_4F4D_53E5_67C4_4ECD_6709_6548_result_2 = nil
    end
    local _____5355_4F4D_540D = _____5355_4F4D_53E5_67C4_4ECD_6709_6548_result_2
    local _____5B89_5168_5355_4F4D_540D = _____5355_4F4D_540D ~= nil and _____5355_4F4D_540D ~= "" and _____5355_4F4D_540D or "未知目标"
    return (("目标：" .. _____5B89_5168_5355_4F4D_540D) .. "|n仇恨值：") .. _____683C_5F0F_5316_4EC7_6068_503C(_____4EC7_6068_503C)
end
local function _____672C_5730_73A9_5BB6_662F_5426_663E_793A_4EC7_6068_6587_5B57()
    return _____529F_80FD_5F00_5173["本地玩家是否开启仇恨文字"]()
end
local function _____5E94_7528_672C_673A_4EC7_6068_6587_5B57_53EF_89C1_6027(textTag)
    if textTag == nil or textTag == 0 then
        return
    end
    SetTextTagVisibility(
        textTag,
        _____672C_5730_73A9_5BB6_662F_5426_663E_793A_4EC7_6068_6587_5B57()
    )
end
local function _____83B7_53D6_6216_521B_5EFA_4EC7_6068_6587_5B57(_____654C_4EBAID, _____654C_4EBA)
    local _____73B0_6709 = _____4EC7_6068_663E_793A_8868[_____654C_4EBAID]
    if _____73B0_6709 ~= nil and _____73B0_6709.textTag ~= nil then
        _____73B0_6709["跟随单位"] = _____654C_4EBA
        return _____73B0_6709.textTag
    end
    local _____65B0_6587_5B57 = CreateFloatTextOnUnit(_____654C_4EBA, "", {
        size = 9,
        red = 255,
        green = 150,
        blue = 60,
        alpha = 0,
        duration = 0,
        permanent = true,
        speedX = 0,
        speedY = 0,
        height = _____6587_5B57_9AD8_5EA6
    })
    if _____65B0_6587_5B57 == nil then
        return nil
    end
    _____5E94_7528_672C_673A_4EC7_6068_6587_5B57_53EF_89C1_6027(_____65B0_6587_5B57)
    _____4EC7_6068_663E_793A_8868[_____654C_4EBAID] = {textTag = _____65B0_6587_5B57, ["跟随单位"] = _____654C_4EBA}
    return _____65B0_6587_5B57
end
local function ____on_4EC7_6068_663E_793A_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(dyingUnit)
    if _____654C_4EBAID == 0 then
        return
    end
    ____exports["清除仇恨显示ById"](_____654C_4EBAID)
end
local function ____on_4EC7_6068_663E_793ATick()
    local _____654C_4EBAID_5217_8868 = _____83B7_53D6_6709_5E8F_4EC7_6068_663E_793A_654C_4EBAID_5217_8868()
    local _____4ECD_6709_663E_793A = false
    do
        local i = 0
        while i < #_____654C_4EBAID_5217_8868 do
            do
                local _____654C_4EBAID = _____654C_4EBAID_5217_8868[i + 1]
                local _____6570_636E = _____4EC7_6068_663E_793A_8868[_____654C_4EBAID]
                if _____6570_636E == nil or _____6570_636E.textTag == nil or _____6570_636E["跟随单位"] == nil or _____6570_636E["跟随单位"] == 0 then
                    ____exports["清除仇恨显示ById"](_____654C_4EBAID)
                    goto __continue21
                end
                if not _____5355_4F4D_53E5_67C4_4ECD_6709_6548(_____6570_636E["跟随单位"]) or IsUnitType(_____6570_636E["跟随单位"], UNIT_TYPE_DEAD) then
                    ____exports["清除仇恨显示ById"](_____654C_4EBAID)
                    goto __continue21
                end
                SetTextTagPosUnit(_____6570_636E.textTag, _____6570_636E["跟随单位"], _____6587_5B57_9AD8_5EA6)
                _____5E94_7528_672C_673A_4EC7_6068_6587_5B57_53EF_89C1_6027(_____6570_636E.textTag)
                _____4ECD_6709_663E_793A = true
            end
            ::__continue21::
            i = i + 1
        end
    end
    if not _____4ECD_6709_663E_793A and _____8DDF_968F_56DE_8C03ID ~= 0 then
        local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
        local removePeriodicCallback = ____require_result_3.removePeriodicCallback
        removePeriodicCallback(_____8DDF_968F_56DE_8C03ID)
        _____8DDF_968F_56DE_8C03ID = 0
    end
end
local function _____786E_4FDD_4EC7_6068_663E_793ATick_5DF2_542F_52A8()
    if not _____5DF2_6CE8_518C_6B7B_4EA1_6E05_7406 then
        _____5DF2_6CE8_518C_6B7B_4EA1_6E05_7406 = true
        registerDeathListener(____on_4EC7_6068_663E_793A_5355_4F4D_6B7B_4EA1)
    end
    if _____8DDF_968F_56DE_8C03ID ~= 0 then
        return
    end
    local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
    local addPeriodicCallback = ____require_result_4.addPeriodicCallback
    _____8DDF_968F_56DE_8C03ID = addPeriodicCallback(_____8DDF_968F_5237_65B0_6BEB_79D2, ____on_4EC7_6068_663E_793ATick)
end
____exports["更新仇恨显示"] = function(_____654C_4EBA, _____76EE_6807_5355_4F4D, _____4EC7_6068_503C)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return
    end
    if not _____5355_4F4D_53E5_67C4_4ECD_6709_6548(_____654C_4EBA) or not _____5355_4F4D_53E5_67C4_4ECD_6709_6548(_____76EE_6807_5355_4F4D) then
        ____exports["清除仇恨显示ById"](_____654C_4EBAID)
        return
    end
    if IsUnitType(_____654C_4EBA, UNIT_TYPE_DEAD) or IsUnitType(_____76EE_6807_5355_4F4D, UNIT_TYPE_DEAD) then
        ____exports["清除仇恨显示ById"](_____654C_4EBAID)
        return
    end
    local _____6587_5B57 = _____83B7_53D6_6216_521B_5EFA_4EC7_6068_6587_5B57(_____654C_4EBAID, _____654C_4EBA)
    if _____6587_5B57 == nil then
        return
    end
    SetTextTagText(
        _____6587_5B57,
        _____6784_5EFA_4EC7_6068_6587_672C(_____76EE_6807_5355_4F4D, _____4EC7_6068_503C),
        _____6587_5B57_5C3A_5BF8_9AD8_5EA6
    )
    SetTextTagPosUnit(_____6587_5B57, _____654C_4EBA, _____6587_5B57_9AD8_5EA6)
    _____5E94_7528_672C_673A_4EC7_6068_6587_5B57_53EF_89C1_6027(_____6587_5B57)
    _____786E_4FDD_4EC7_6068_663E_793ATick_5DF2_542F_52A8()
end
____exports["清除所有仇恨显示"] = function()
    local _____654C_4EBAID_5217_8868 = _____83B7_53D6_6709_5E8F_4EC7_6068_663E_793A_654C_4EBAID_5217_8868()
    do
        local i = 0
        while i < #_____654C_4EBAID_5217_8868 do
            ____exports["清除仇恨显示ById"](_____654C_4EBAID_5217_8868[i + 1])
            i = i + 1
        end
    end
    if _____8DDF_968F_56DE_8C03ID ~= 0 then
        local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
        local removePeriodicCallback = ____require_result_5.removePeriodicCallback
        removePeriodicCallback(_____8DDF_968F_56DE_8C03ID)
        _____8DDF_968F_56DE_8C03ID = 0
    end
end
return ____exports
