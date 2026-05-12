local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
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
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local SetTextTagText = jass.SetTextTagText
local SetTextTagPosUnit = jass.SetTextTagPosUnit
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
local function _____683C_5F0F_5316_4EC7_6068_503C(_____4EC7_6068_503C)
    local _____5341_500D_6574_6570 = R2I(_____4EC7_6068_503C * 10 + 0.5)
    local _____6574_6570_90E8_5206 = R2I(_____5341_500D_6574_6570 / 10)
    local _____5C0F_6570_90E8_5206 = _____5341_500D_6574_6570 - _____6574_6570_90E8_5206 * 10
    return (tostring(_____6574_6570_90E8_5206) .. ".") .. tostring(_____5C0F_6570_90E8_5206)
end
local function _____6784_5EFA_4EC7_6068_6587_672C(_____76EE_6807_5355_4F4D, _____4EC7_6068_503C)
    return (("目标：" .. GetUnitName(_____76EE_6807_5355_4F4D)) .. "|n仇恨值：") .. _____683C_5F0F_5316_4EC7_6068_503C(_____4EC7_6068_503C)
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
    local keys = __TS__ObjectKeys(_____4EC7_6068_663E_793A_8868)
    local _____4ECD_6709_663E_793A = false
    do
        local i = 0
        while i < #keys do
            do
                local _____654C_4EBAID = __TS__ParseInt(keys[i + 1], 10)
                if __TS__NumberIsNaN(__TS__Number(_____654C_4EBAID)) then
                    goto __continue13
                end
                local _____6570_636E = _____4EC7_6068_663E_793A_8868[_____654C_4EBAID]
                if _____6570_636E == nil or _____6570_636E.textTag == nil or _____6570_636E["跟随单位"] == nil or _____6570_636E["跟随单位"] == 0 then
                    ____exports["清除仇恨显示ById"](_____654C_4EBAID)
                    goto __continue13
                end
                if IsUnitType(_____6570_636E["跟随单位"], UNIT_TYPE_DEAD) then
                    ____exports["清除仇恨显示ById"](_____654C_4EBAID)
                    goto __continue13
                end
                SetTextTagPosUnit(_____6570_636E.textTag, _____6570_636E["跟随单位"], _____6587_5B57_9AD8_5EA6)
                _____4ECD_6709_663E_793A = true
            end
            ::__continue13::
            i = i + 1
        end
    end
    if not _____4ECD_6709_663E_793A and _____8DDF_968F_56DE_8C03ID ~= 0 then
        local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
        local removePeriodicCallback = ____require_result_2.removePeriodicCallback
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
    local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
    local addPeriodicCallback = ____require_result_3.addPeriodicCallback
    _____8DDF_968F_56DE_8C03ID = addPeriodicCallback(_____8DDF_968F_5237_65B0_6BEB_79D2, ____on_4EC7_6068_663E_793ATick)
end
____exports["更新仇恨显示"] = function(_____654C_4EBA, _____76EE_6807_5355_4F4D, _____4EC7_6068_503C)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return
    end
    if _____654C_4EBA == nil or _____654C_4EBA == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
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
    _____786E_4FDD_4EC7_6068_663E_793ATick_5DF2_542F_52A8()
end
____exports["清除所有仇恨显示"] = function()
    local keys = __TS__ObjectKeys(_____4EC7_6068_663E_793A_8868)
    do
        local i = 0
        while i < #keys do
            local _____654C_4EBAID = __TS__ParseInt(keys[i + 1], 10)
            if not __TS__NumberIsNaN(__TS__Number(_____654C_4EBAID)) then
                ____exports["清除仇恨显示ById"](_____654C_4EBAID)
            end
            i = i + 1
        end
    end
    if _____8DDF_968F_56DE_8C03ID ~= 0 then
        local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
        local removePeriodicCallback = ____require_result_4.removePeriodicCallback
        removePeriodicCallback(_____8DDF_968F_56DE_8C03ID)
        _____8DDF_968F_56DE_8C03ID = 0
    end
end
return ____exports
