local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____521D_59CB_5316_547D_4EE4ID, OrderId, _____72C2_6218_58EB_547D_4EE4ID, _____75BE_98CE_6B65_547D_4EE4ID, _____65E0_654C_62A4_7532_547D_4EE4ID, _____663E_793A_547D_4EE4ID, _____52A8_6001_547D_4EE4_7C7B_578B_6620_5C04
function _____521D_59CB_5316_547D_4EE4ID()
    if _____72C2_6218_58EB_547D_4EE4ID == 0 then
        _____72C2_6218_58EB_547D_4EE4ID = OrderId(____exports["无视控制狂战士命令"])
    end
    if _____75BE_98CE_6B65_547D_4EE4ID == 0 then
        _____75BE_98CE_6B65_547D_4EE4ID = OrderId(____exports["无视控制疾风步命令"])
    end
    if _____65E0_654C_62A4_7532_547D_4EE4ID == 0 then
        _____65E0_654C_62A4_7532_547D_4EE4ID = OrderId(____exports["无视控制无敌护甲命令"])
    end
    if _____663E_793A_547D_4EE4ID == 0 then
        _____663E_793A_547D_4EE4ID = OrderId(____exports["无视控制显示命令"])
    end
end
____exports["取无视控制输入类型"] = function(orderId)
    _____521D_59CB_5316_547D_4EE4ID()
    if orderId == _____72C2_6218_58EB_547D_4EE4ID then
        return "狂战士"
    end
    if orderId == _____75BE_98CE_6B65_547D_4EE4ID then
        return "疾风步"
    end
    if orderId == _____65E0_654C_62A4_7532_547D_4EE4ID then
        return "无敌护甲"
    end
    if orderId == _____663E_793A_547D_4EE4ID then
        return "显示"
    end
    local _____52A8_6001_8F93_5165_7C7B_578B = _____52A8_6001_547D_4EE4_7C7B_578B_6620_5C04[orderId]
    if _____52A8_6001_8F93_5165_7C7B_578B ~= nil then
        return _____52A8_6001_8F93_5165_7C7B_578B
    end
    return nil
end
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local fourCcUtil = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local _____5355_4F4D_6307_4EE4_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
____exports["无视控制狂战士技能ID"] = "USKB"
____exports["无视控制疾风步技能ID"] = "USKW"
____exports["无视控制无敌护甲技能ID"] = "USKD"
____exports["无视控制显示技能ID"] = "USKS"
____exports["无视控制无敌护甲技能槽位ID列表"] = {
    "USKD",
    "UD01",
    "UD02",
    "UD03",
    "UD04",
    "UD05",
    "UD06",
    "UD07"
}
____exports["无视控制显示技能槽位ID列表"] = {
    "USKS",
    "UW01",
    "UW02",
    "UW03",
    "UW04",
    "UW05",
    "UW06",
    "UW07"
}
____exports["无视控制狂战士命令"] = "berserk"
____exports["无视控制疾风步命令"] = "windwalk"
____exports["无视控制无敌护甲命令"] = "divineshield"
____exports["无视控制显示命令"] = "reveal"
OrderId = jass.OrderId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local UnitAddAbility = jass.UnitAddAbility
local stringToFourCC = fourCcUtil.stringToFourCC
local DzSetUnitAbilityArea = japi.DzSetUnitAbilityArea
local DzSetUnitAbilityArt = japi.DzSetUnitAbilityArt
local DzSetUnitAbilityBackSwing = japi.DzSetUnitAbilityBackSwing
local DzSetUnitAbilityButtonPos = japi.DzSetUnitAbilityButtonPos
local DzSetUnitAbilityCastPoint = japi.DzSetUnitAbilityCastPoint
local DzSetUnitAbilityCastTime = japi.DzSetUnitAbilityCastTime
local DzSetUnitAbilityCool = japi.DzSetUnitAbilityCool
local DzSetUnitAbilityCost = japi.DzSetUnitAbilityCost
local DzSetUnitAbilityDataA = japi.DzSetUnitAbilityDataA
local DzSetUnitAbilityDataB = japi.DzSetUnitAbilityDataB
local DzSetUnitAbilityDataC = japi.DzSetUnitAbilityDataC
local DzSetUnitAbilityDataD = japi.DzSetUnitAbilityDataD
local DzSetUnitAbilityDataE = japi.DzSetUnitAbilityDataE
local DzSetUnitAbilityDuration = japi.DzSetUnitAbilityDuration
local DzSetUnitAbilityHeroDuration = japi.DzSetUnitAbilityHeroDuration
local DzSetUnitAbilityHotkey = japi.DzSetUnitAbilityHotkey
local DzSetUnitAbilityOrderId = japi.DzSetUnitAbilityOrderId
local DzSetUnitAbilityRange = japi.DzSetUnitAbilityRange
local DzSetUnitAbilityTip = japi.DzSetUnitAbilityTip
local DzSetUnitAbilityUberTip = japi.DzSetUnitAbilityUberTip
local DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate
_____72C2_6218_58EB_547D_4EE4ID = 0
_____75BE_98CE_6B65_547D_4EE4ID = 0
_____65E0_654C_62A4_7532_547D_4EE4ID = 0
_____663E_793A_547D_4EE4ID = 0
local _____5DF2_63A5_5165_5355_4F4D_6307_4EE4_4E8B_4EF6 = false
local _____76D1_542C_5217_8868 = {}
_____52A8_6001_547D_4EE4_7C7B_578B_6620_5C04 = {}
local function _____8F6C_6280_80FDID(id)
    if type(id) == "number" then
        return id
    end
    return stringToFourCC(id)
end
local function _____8F6C_547D_4EE4ID(order)
    if type(order) == "number" then
        return order
    end
    return OrderId(order)
end
local function _____53D6_6280_80FD_9ED8_8BA4_8F93_5165_7C7B_578B(_____6280_80FDID)
    if _____6280_80FDID == _____8F6C_6280_80FDID(____exports["无视控制狂战士技能ID"]) then
        return "狂战士"
    end
    if _____6280_80FDID == _____8F6C_6280_80FDID(____exports["无视控制疾风步技能ID"]) then
        return "疾风步"
    end
    do
        local i = 0
        while i < #____exports["无视控制无敌护甲技能槽位ID列表"] do
            if _____6280_80FDID == _____8F6C_6280_80FDID(____exports["无视控制无敌护甲技能槽位ID列表"][i + 1]) then
                return "无敌护甲"
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #____exports["无视控制显示技能槽位ID列表"] do
            if _____6280_80FDID == _____8F6C_6280_80FDID(____exports["无视控制显示技能槽位ID列表"][i + 1]) then
                return "显示"
            end
            i = i + 1
        end
    end
    return "无敌护甲"
end
local function _____5DF2_6CE8_518C(callback)
    do
        local i = 0
        while i < #_____76D1_542C_5217_8868 do
            if _____76D1_542C_5217_8868[i + 1] == callback then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____5206_53D1_65E0_89C6_63A7_5236_8F93_5165(unit, orderId, _____8F93_5165_65B9_5F0F, x, y)
    local _____8F93_5165_7C7B_578B = ____exports["取无视控制输入类型"](orderId)
    if _____8F93_5165_7C7B_578B == nil then
        return
    end
    local event = {
        ["单位"] = unit,
        ["命令ID"] = orderId,
        ["输入类型"] = _____8F93_5165_7C7B_578B,
        ["输入方式"] = _____8F93_5165_65B9_5F0F,
        ["目标点X"] = x,
        ["目标点Y"] = y
    }
    do
        local i = 0
        while i < #_____76D1_542C_5217_8868 do
            local callback = _____76D1_542C_5217_8868[i + 1]
            if callback ~= nil then
                callback(event)
            end
            i = i + 1
        end
    end
end
local function _____5206_53D1_65E0_76EE_6807_65E0_89C6_63A7_5236_8F93_5165(unit, orderId)
    _____5206_53D1_65E0_89C6_63A7_5236_8F93_5165(unit, orderId, "无目标")
end
local function _____5206_53D1_70B9_76EE_6807_65E0_89C6_63A7_5236_8F93_5165(unit, orderId, x, y)
    _____5206_53D1_65E0_89C6_63A7_5236_8F93_5165(
        unit,
        orderId,
        "点目标",
        x,
        y
    )
end
local function _____786E_4FDD_63A5_5165_5355_4F4D_6307_4EE4_4E8B_4EF6()
    if _____5DF2_63A5_5165_5355_4F4D_6307_4EE4_4E8B_4EF6 then
        return
    end
    _____5DF2_63A5_5165_5355_4F4D_6307_4EE4_4E8B_4EF6 = true
    _____521D_59CB_5316_547D_4EE4ID()
    _____5355_4F4D_6307_4EE4_4E8B_4EF6_4E2D_5FC3.registerImmediateOrderListener(_____5206_53D1_65E0_76EE_6807_65E0_89C6_63A7_5236_8F93_5165)
    _____5355_4F4D_6307_4EE4_4E8B_4EF6_4E2D_5FC3.registerPointOrderListener(_____5206_53D1_70B9_76EE_6807_65E0_89C6_63A7_5236_8F93_5165)
end
____exports["是否无视控制输入命令"] = function(orderId)
    _____521D_59CB_5316_547D_4EE4ID()
    return orderId == _____72C2_6218_58EB_547D_4EE4ID or orderId == _____75BE_98CE_6B65_547D_4EE4ID or orderId == _____65E0_654C_62A4_7532_547D_4EE4ID or orderId == _____663E_793A_547D_4EE4ID or _____52A8_6001_547D_4EE4_7C7B_578B_6620_5C04[orderId] ~= nil
end
____exports["注册无视控制输入命令"] = function(_____547D_4EE4, _____8F93_5165_7C7B_578B)
    local _____547D_4EE4ID = _____8F6C_547D_4EE4ID(_____547D_4EE4)
    if _____547D_4EE4ID ~= 0 then
        _____52A8_6001_547D_4EE4_7C7B_578B_6620_5C04[_____547D_4EE4ID] = _____8F93_5165_7C7B_578B
    end
    return _____547D_4EE4ID
end
____exports["配置无视控制技能壳子"] = function(_____914D_7F6E)
    local _____5355_4F4D = _____914D_7F6E["单位"]
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    local _____6280_80FDID = _____8F6C_6280_80FDID(_____914D_7F6E["技能ID"])
    if _____6280_80FDID == 0 then
        return 0
    end
    if _____914D_7F6E["自动添加"] ~= false and GetUnitAbilityLevel(_____5355_4F4D, _____6280_80FDID) <= 0 then
        UnitAddAbility(_____5355_4F4D, _____6280_80FDID)
    end
    if _____914D_7F6E["图标"] ~= nil then
        DzSetUnitAbilityArt(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["图标"])
    end
    if _____914D_7F6E["提示"] ~= nil then
        DzSetUnitAbilityTip(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["提示"])
    end
    if _____914D_7F6E["扩展提示"] ~= nil then
        DzSetUnitAbilityUberTip(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["扩展提示"])
    end
    if _____914D_7F6E["热键"] ~= nil then
        DzSetUnitAbilityHotkey(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["热键"])
    end
    if _____914D_7F6E["按钮X"] ~= nil and _____914D_7F6E["按钮Y"] ~= nil then
        DzSetUnitAbilityButtonPos(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["按钮X"], _____914D_7F6E["按钮Y"])
    end
    if _____914D_7F6E["冷却"] ~= nil then
        DzSetUnitAbilityCool(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["冷却"], _____914D_7F6E["最大冷却"] or _____914D_7F6E["冷却"])
    end
    if _____914D_7F6E["魔法消耗"] ~= nil then
        DzSetUnitAbilityCost(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["魔法消耗"])
    end
    if _____914D_7F6E["施法距离"] ~= nil then
        DzSetUnitAbilityRange(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["施法距离"])
    end
    if _____914D_7F6E["施法区域"] ~= nil then
        DzSetUnitAbilityArea(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["施法区域"])
    end
    if _____914D_7F6E["持续时间"] ~= nil then
        DzSetUnitAbilityDuration(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["持续时间"])
    end
    if _____914D_7F6E["英雄持续时间"] ~= nil then
        DzSetUnitAbilityHeroDuration(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["英雄持续时间"])
    end
    if _____914D_7F6E["施法前摇"] ~= nil then
        DzSetUnitAbilityCastPoint(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["施法前摇"])
    end
    if _____914D_7F6E["施法时间"] ~= nil then
        DzSetUnitAbilityCastTime(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["施法时间"])
    end
    if _____914D_7F6E["后摇"] ~= nil then
        DzSetUnitAbilityBackSwing(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["后摇"])
    end
    if _____914D_7F6E["数据A"] ~= nil then
        DzSetUnitAbilityDataA(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["数据A"])
    end
    if _____914D_7F6E["数据B"] ~= nil then
        DzSetUnitAbilityDataB(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["数据B"])
    end
    if _____914D_7F6E["数据C"] ~= nil then
        DzSetUnitAbilityDataC(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["数据C"])
    end
    if _____914D_7F6E["数据D"] ~= nil then
        DzSetUnitAbilityDataD(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["数据D"])
    end
    if _____914D_7F6E["数据E"] ~= nil then
        DzSetUnitAbilityDataE(_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["数据E"])
    end
    if _____914D_7F6E["命令"] ~= nil then
        local _____547D_4EE4ID = ____exports["注册无视控制输入命令"](
            _____914D_7F6E["命令"],
            _____914D_7F6E["输入类型"] or _____53D6_6280_80FD_9ED8_8BA4_8F93_5165_7C7B_578B(_____6280_80FDID)
        )
        DzSetUnitAbilityOrderId(_____5355_4F4D, _____6280_80FDID, _____547D_4EE4ID)
    end
    if _____914D_7F6E["刷新"] ~= false then
        DzSetUnitAbilityUpdate(_____5355_4F4D, _____6280_80FDID)
    end
    return _____6280_80FDID
end
____exports["注册无视控制输入监听"] = function(callback)
    if type(callback) ~= "function" then
        return
    end
    _____786E_4FDD_63A5_5165_5355_4F4D_6307_4EE4_4E8B_4EF6()
    if not _____5DF2_6CE8_518C(callback) then
        _____76D1_542C_5217_8868[#_____76D1_542C_5217_8868 + 1] = callback
    end
end
____exports["注销无视控制输入监听"] = function(callback)
    local index = __TS__ArrayIndexOf(_____76D1_542C_5217_8868, callback)
    if index >= 0 then
        __TS__ArraySplice(_____76D1_542C_5217_8868, index, 1)
    end
    if #_____76D1_542C_5217_8868 == 0 and _____5DF2_63A5_5165_5355_4F4D_6307_4EE4_4E8B_4EF6 then
        _____5355_4F4D_6307_4EE4_4E8B_4EF6_4E2D_5FC3.unregisterImmediateOrderListener(_____5206_53D1_65E0_76EE_6807_65E0_89C6_63A7_5236_8F93_5165)
        _____5355_4F4D_6307_4EE4_4E8B_4EF6_4E2D_5FC3.unregisterPointOrderListener(_____5206_53D1_70B9_76EE_6807_65E0_89C6_63A7_5236_8F93_5165)
        _____5DF2_63A5_5165_5355_4F4D_6307_4EE4_4E8B_4EF6 = false
    end
end
return ____exports
