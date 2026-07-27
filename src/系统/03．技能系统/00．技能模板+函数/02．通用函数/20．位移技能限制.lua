--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetOwningPlayer = jass.GetOwningPlayer
local GetLocalPlayer = jass.GetLocalPlayer
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitPosition = jass.SetUnitPosition
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local DzFrameGetUnitMessage = japi.DzFrameGetUnitMessage
local DzSimpleMessageFrameAddMessage = japi.DzSimpleMessageFrameAddMessage
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local getBuffIdsOnUnit = ____require_result_1.getBuffIdsOnUnit
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
local ____require_result_2 = require("系统.05．Buff系统.02．Buff数据表.00．Buff数据表")
local ____Buff_6570_636E_8868 = ____require_result_2["Buff数据表"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local _____4F4D_79FB_5C01_9501_63D0_793A_6587_672C = "当前无法使用位移技能"
local _____4F4D_79FB_5C01_9501_63D0_793A_989C_8272 = 4294967040
local _____4F4D_79FB_5C01_9501_63D0_793A_6301_7EED_65F6_95F4 = 1.2
local _____4F4D_79FB_5C01_9501_63D0_793A_95F4_9694Ms = 800
local _____4F4D_79FB_5C01_9501_63D0_793A_51B7_5374 = {}
local _____539F_751F_4F4D_79FB_5C01_9501Buff_7F13_5B58 = nil
local _____6218_6597_81EA_8EAB_4F4D_79FB_76D1_542C_5217_8868 = {}
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
local function _____83B7_53D6_539F_751F_4F4D_79FB_5C01_9501Buff_5408_96C6()
    if _____539F_751F_4F4D_79FB_5C01_9501Buff_7F13_5B58 ~= nil then
        return _____539F_751F_4F4D_79FB_5C01_9501Buff_7F13_5B58
    end
    local result = {}
    for rawId in pairs(____Buff_6570_636E_8868) do
        do
            local meta = ____Buff_6570_636E_8868[rawId]
            if meta == nil or meta["禁止位移"] ~= true then
                goto __continue5
            end
            local buffId = stringToFourCCSafe(rawId)
            if buffId ~= 0 then
                result[#result + 1] = buffId
            end
        end
        ::__continue5::
    end
    _____539F_751F_4F4D_79FB_5C01_9501Buff_7F13_5B58 = result
    return result
end
local function _____5355_4F4D_62E5_6709_539F_751F_4F4D_79FB_5C01_9501Buff(unit)
    local list = _____83B7_53D6_539F_751F_4F4D_79FB_5C01_9501Buff_5408_96C6()
    do
        local i = 0
        while i < #list do
            if GetUnitAbilityLevel(unit, list[i + 1]) > 0 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____5355_4F4D_62E5_6709Buff_8868_4F4D_79FB_5C01_9501Buff(unit)
    local ids = getBuffIdsOnUnit(unit)
    do
        local i = 0
        while i < #ids do
            do
                local meta = buffTableMod.buffs[ids[i + 1]]
                if meta == nil then
                    goto __continue15
                end
                if meta["禁止位移"] == true then
                    return true
                end
            end
            ::__continue15::
            i = i + 1
        end
    end
    return false
end
____exports["单位是否被位移封锁控制"] = function(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return false
    end
    return _____5355_4F4D_62E5_6709_539F_751F_4F4D_79FB_5C01_9501Buff(unit) or _____5355_4F4D_62E5_6709Buff_8868_4F4D_79FB_5C01_9501Buff(unit)
end
____exports["提示无法使用位移技能"] = function(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return
    end
    if GetLocalPlayer() ~= GetOwningPlayer(unit) then
        return
    end
    local handleId = GetHandleId(unit) or 0
    local now = getServerTime()
    local _____4E0B_6B21_63D0_793A_65F6_95F4 = _____4F4D_79FB_5C01_9501_63D0_793A_51B7_5374[handleId] or 0
    if now < _____4E0B_6B21_63D0_793A_65F6_95F4 then
        return
    end
    _____4F4D_79FB_5C01_9501_63D0_793A_51B7_5374[handleId] = now + _____4F4D_79FB_5C01_9501_63D0_793A_95F4_9694Ms
    DzSimpleMessageFrameAddMessage(
        DzFrameGetUnitMessage(),
        _____4F4D_79FB_5C01_9501_63D0_793A_6587_672C,
        _____4F4D_79FB_5C01_9501_63D0_793A_989C_8272,
        _____4F4D_79FB_5C01_9501_63D0_793A_6301_7EED_65F6_95F4,
        false
    )
end
____exports["尝试阻止自身位移技能"] = function(unit)
    if not ____exports["单位是否被位移封锁控制"](unit) then
        return false
    end
    ____exports["提示无法使用位移技能"](unit)
    return true
end
____exports["注册战斗自身位移完成监听"] = function(listener)
    _____6218_6597_81EA_8EAB_4F4D_79FB_76D1_542C_5217_8868[#_____6218_6597_81EA_8EAB_4F4D_79FB_76D1_542C_5217_8868 + 1] = listener
end
____exports["通知战斗自身位移完成"] = function(unit, _____8D77_70B9X, _____8D77_70B9Y, _____7EC8_70B9X, _____7EC8_70B9Y)
    do
        local i = 0
        while i < #_____6218_6597_81EA_8EAB_4F4D_79FB_76D1_542C_5217_8868 do
            _____6218_6597_81EA_8EAB_4F4D_79FB_76D1_542C_5217_8868[i + 1](
                unit,
                _____8D77_70B9X,
                _____8D77_70B9Y,
                _____7EC8_70B9X,
                _____7EC8_70B9Y
            )
            i = i + 1
        end
    end
end
____exports["执行战斗自身位移到坐标"] = function(unit, x, y)
    if not _____5355_4F4D_6709_6548(unit) then
        return false
    end
    if ____exports["尝试阻止自身位移技能"](unit) then
        return false
    end
    local _____8D77_70B9X = GetUnitX(unit)
    local _____8D77_70B9Y = GetUnitY(unit)
    SetUnitX(unit, x)
    SetUnitY(unit, y)
    ____exports["通知战斗自身位移完成"](
        unit,
        _____8D77_70B9X,
        _____8D77_70B9Y,
        GetUnitX(unit),
        GetUnitY(unit)
    )
    return true
end
____exports["执行战斗自身传送到坐标"] = function(unit, x, y)
    if not _____5355_4F4D_6709_6548(unit) then
        return false
    end
    if ____exports["尝试阻止自身位移技能"](unit) then
        return false
    end
    local _____8D77_70B9X = GetUnitX(unit)
    local _____8D77_70B9Y = GetUnitY(unit)
    SetUnitPosition(unit, x, y)
    ____exports["通知战斗自身位移完成"](
        unit,
        _____8D77_70B9X,
        _____8D77_70B9Y,
        GetUnitX(unit),
        GetUnitY(unit)
    )
    return true
end
return ____exports
