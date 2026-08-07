--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.09．表现系统.10．英雄语音.08．状态音效.00．配置")
local _____4F4E_8840_72B6_6001_97F3_6548_914D_7F6E_5217_8868 = ____00_FF0E_914D_7F6E["低血状态音效配置列表"]
local _____53D7_4F24_8BED_97F3_51B7_5374_79D2 = ____00_FF0E_914D_7F6E["受伤语音冷却秒"]
local _____53D7_4F24_8BED_97F3_5B57_6BB5 = ____00_FF0E_914D_7F6E["受伤语音字段"]
local _____6218_51B5_52A3_52BF_8BED_97F3_51B7_5374_79D2 = ____00_FF0E_914D_7F6E["战况劣势语音冷却秒"]
local _____6218_51B5_52A3_52BF_8BED_97F3_5B57_6BB5 = ____00_FF0E_914D_7F6E["战况劣势语音字段"]
local _____6218_51B5_52A3_52BF_97F3_6548_914D_7F6E_5217_8868 = ____00_FF0E_914D_7F6E["战况劣势音效配置列表"]
local _____72B6_6001_4E0D_4F73_8BED_97F3_5B57_6BB5 = ____00_FF0E_914D_7F6E["状态不佳语音字段"]
local _____72B6_6001_97F3_6548_4F24_5BB3_5EF6_8FDF_6BEB_79D2 = ____00_FF0E_914D_7F6E["状态音效伤害延迟毫秒"]
local _____72B6_6001_97F3_6548_914D_7F6E_5217_8868 = ____00_FF0E_914D_7F6E["状态音效配置列表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名")
local _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0 = ____require_result_2["单位是否匹配玩家英雄名称"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local getServerTime = ____require_result_4.getServerTime
local GetLocalPlayer = jass.GetLocalPlayer
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomInt = jass.GetRandomInt
local GetUnitStateJass = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local IsUnitInGroup = jass.IsUnitInGroup
local IsUnitType = jass.IsUnitType
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local SetSoundVolume = jass.SetSoundVolume
local SetSoundPosition = jass.SetSoundPosition
local StartSound = jass.StartSound
local StopSound = jass.StopSound
local _____5EF6_8FDF_72B6_6001_97F3_6548_961F_5217 = {}
local _____51B7_5374_961F_5217 = {}
local _____72B6_6001_97F3_6548_5DF2_521D_59CB_5316 = false
local _____5EF6_8FDF_72B6_6001_97F3_6548_5DF2_8C03_5EA6 = false
local function _____53D6_6700_5927_751F_547D(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local value = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE)
    return value > 0 and value or 0
end
local function _____53D6_5F53_524D_751F_547D(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local value = GetUnitStateJass(unit, jass.UNIT_STATE_LIFE)
    return value > 0 and value or 0
end
local function _____53D6_6700_5927_9B54_6CD5(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local value = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA)
    return value > 0 and value or 0
end
local function _____53D6_5F53_524D_751F_547D_767E_5206_6BD4(unit)
    local maxLife = _____53D6_6700_5927_751F_547D(unit)
    if maxLife <= 0 then
        return 0
    end
    return _____53D6_5F53_524D_751F_547D(unit) * 100 / maxLife
end
local function _____53D6_5F53_524D_9B54_6CD5_767E_5206_6BD4(unit)
    local maxMana = _____53D6_6700_5927_9B54_6CD5(unit)
    if maxMana <= 0 then
        return 100
    end
    local mana = GetUnitStateJass(unit, jass.UNIT_STATE_MANA)
    return mana * 100 / maxMana
end
local function _____662F_6CE8_518C_73A9_5BB6_82F1_96C4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    return getRegisteredPlayerHero(owner) == unit
end
local function _____5355_4F4D_662F_5426_8840_6761Boss_7EC4_6210_5458(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local bossGroup = YDUserDataGetSafe("string", "血条Boss", "单位组", "group")
    if bossGroup == nil or bossGroup == 0 then
        return false
    end
    return IsUnitInGroup(unit, bossGroup)
end
local function _____662F_82F1_96C4_6216_8840_6761Boss(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_HERO) then
        return true
    end
    return _____5355_4F4D_662F_5426_8840_6761Boss_7EC4_6210_5458(unit)
end
local function _____76EE_6807_6EE1_8DB3_72B6_6001_97F3_6548_524D_7F6E(target, applied)
    if applied < 0.1 then
        return false
    end
    if target == nil or target == 0 then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_DEAD) then
        return false
    end
    return _____662F_6CE8_518C_73A9_5BB6_82F1_96C4(target)
end
local function _____968F_673A_53D6_97F3_6548(soundList)
    if #soundList <= 0 then
        return nil
    end
    if #soundList == 1 then
        return soundList[1]
    end
    local index = GetRandomInt(1, #soundList) - 1
    return soundList[index + 1]
end
local function _____672C_5730_64AD_653E_5355_4F4D_8BED_97F3(unit, soundHandle)
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return
    end
    if GetLocalPlayer() ~= owner then
        return
    end
    StartSound(soundHandle)
end
local function _____64AD_653E_5355_4F4D3D_97F3_6548(unit, soundHandle)
    SetSoundVolume(soundHandle, 100)
    SetSoundPosition(
        soundHandle,
        GetUnitX(unit),
        GetUnitY(unit),
        GetUnitFlyHeight(unit)
    )
    StartSound(soundHandle)
end
local function _____64AD_653E_72B6_6001_97F3_6548(unit, soundHandle, _____662F_54263D)
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    if _____662F_54263D then
        _____64AD_653E_5355_4F4D3D_97F3_6548(unit, soundHandle)
        return
    end
    _____672C_5730_64AD_653E_5355_4F4D_8BED_97F3(unit, soundHandle)
end
local function _____53D6_53D7_4F24_914D_7F6E(unit)
    do
        local i = 0
        while i < #_____72B6_6001_97F3_6548_914D_7F6E_5217_8868 do
            local config = _____72B6_6001_97F3_6548_914D_7F6E_5217_8868[i + 1]
            if _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0(unit, config["英雄名"]) then
                return config
            end
            i = i + 1
        end
    end
    return nil
end
local function _____53D6_6218_51B5_52A3_52BF_914D_7F6E(unit)
    do
        local i = 0
        while i < #_____6218_51B5_52A3_52BF_97F3_6548_914D_7F6E_5217_8868 do
            local config = _____6218_51B5_52A3_52BF_97F3_6548_914D_7F6E_5217_8868[i + 1]
            if _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0(unit, config["英雄名"]) then
                return config
            end
            i = i + 1
        end
    end
    return nil
end
local function _____662F_5426_51B7_5374_4E2D(unit, _____5B57_6BB5)
    return YDUserDataGetSafe("unit", unit, _____5B57_6BB5, "boolean") == true
end
local function _____5904_7406_72B6_6001_97F3_6548_51B7_5374_5230_671F()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #_____51B7_5374_961F_5217 do
            do
                local record = _____51B7_5374_961F_5217[i + 1]
                if record["单位"] == nil or record["单位"] == 0 then
                    goto __continue47
                end
                if record["到期时间"] <= now then
                    YDUserDataSetSafe(
                        "unit",
                        record["单位"],
                        record["字段"],
                        "boolean",
                        false
                    )
                    goto __continue47
                end
                _____51B7_5374_961F_5217[writeIndex + 1] = record
                writeIndex = writeIndex + 1
            end
            ::__continue47::
            i = i + 1
        end
    end
    do
        local i = #_____51B7_5374_961F_5217 - 1
        while i >= writeIndex do
            table.remove(_____51B7_5374_961F_5217)
            i = i - 1
        end
    end
end
local function _____8FDB_5165_72B6_6001_97F3_6548_51B7_5374(unit, _____5B57_6BB5, _____51B7_5374_79D2)
    YDUserDataSetSafe(
        "unit",
        unit,
        _____5B57_6BB5,
        "boolean",
        true
    )
    _____51B7_5374_961F_5217[#_____51B7_5374_961F_5217 + 1] = {
        ["单位"] = unit,
        ["字段"] = _____5B57_6BB5,
        ["到期时间"] = getServerTime() + _____51B7_5374_79D2 * 1000
    }
    addDelayedCallback(_____51B7_5374_79D2 * 1000, _____5904_7406_72B6_6001_97F3_6548_51B7_5374_5230_671F)
end
local function _____5C1D_8BD5_64AD_653E_6218_51B5_52A3_52BF_8BED_97F3(record, maxLife)
    local target = record["目标"]
    local source = record["来源"]
    if source == nil or source == 0 then
        return
    end
    if not _____662F_82F1_96C4_6216_8840_6761Boss(source) then
        return
    end
    if _____662F_5426_51B7_5374_4E2D(target, _____6218_51B5_52A3_52BF_8BED_97F3_5B57_6BB5) then
        return
    end
    if record["伤害"] < maxLife * 0.01 then
        return
    end
    if _____53D6_5F53_524D_751F_547D_767E_5206_6BD4(target) > 30 then
        return
    end
    if _____53D6_5F53_524D_751F_547D_767E_5206_6BD4(source) < 75 then
        return
    end
    if _____53D6_5F53_524D_9B54_6CD5_767E_5206_6BD4(source) < 30 then
        return
    end
    local config = _____53D6_6218_51B5_52A3_52BF_914D_7F6E(target)
    if config == nil then
        return
    end
    local soundHandle = _____968F_673A_53D6_97F3_6548(config["音效列表"])
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    _____64AD_653E_72B6_6001_97F3_6548(target, soundHandle, config["是否3D"])
    _____8FDB_5165_72B6_6001_97F3_6548_51B7_5374(target, _____6218_51B5_52A3_52BF_8BED_97F3_5B57_6BB5, _____6218_51B5_52A3_52BF_8BED_97F3_51B7_5374_79D2)
end
local function _____5C1D_8BD5_64AD_653E_53D7_4F24_8BED_97F3(record, maxLife)
    local target = record["目标"]
    if _____662F_5426_51B7_5374_4E2D(target, _____53D7_4F24_8BED_97F3_5B57_6BB5) then
        return
    end
    if record["伤害"] < maxLife * 0.07 then
        return
    end
    local config = _____53D6_53D7_4F24_914D_7F6E(target)
    if config == nil then
        return
    end
    local heavy = record["伤害"] >= maxLife * 0.12 and _____53D6_5F53_524D_751F_547D_767E_5206_6BD4(target) <= 40
    local soundList = heavy and config["重伤音效列表"] or config["普通受伤音效列表"]
    local soundHandle = _____968F_673A_53D6_97F3_6548(soundList)
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    _____64AD_653E_72B6_6001_97F3_6548(target, soundHandle, config["是否3D"])
    _____8FDB_5165_72B6_6001_97F3_6548_51B7_5374(target, _____53D7_4F24_8BED_97F3_5B57_6BB5, _____53D7_4F24_8BED_97F3_51B7_5374_79D2)
end
local function _____5C1D_8BD5_64AD_653E_4F4E_8840_72B6_6001_8BED_97F3(target)
    if _____662F_5426_51B7_5374_4E2D(target, _____72B6_6001_4E0D_4F73_8BED_97F3_5B57_6BB5) then
        return
    end
    local lifePercent = _____53D6_5F53_524D_751F_547D_767E_5206_6BD4(target)
    do
        local i = 0
        while i < #_____4F4E_8840_72B6_6001_97F3_6548_914D_7F6E_5217_8868 do
            do
                local config = _____4F4E_8840_72B6_6001_97F3_6548_914D_7F6E_5217_8868[i + 1]
                if lifePercent < config["最小生命百分比"] or lifePercent > config["最大生命百分比"] then
                    goto __continue71
                end
                if not _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0(target, config["英雄名"]) then
                    goto __continue71
                end
                local soundHandle = _____968F_673A_53D6_97F3_6548(config["音效列表"])
                if soundHandle == nil or soundHandle == 0 then
                    return
                end
                if config["停止音效"] ~= nil and config["停止音效"] ~= 0 then
                    StopSound(config["停止音效"], false, false)
                end
                _____64AD_653E_72B6_6001_97F3_6548(target, soundHandle, config["是否3D"])
                _____8FDB_5165_72B6_6001_97F3_6548_51B7_5374(target, _____72B6_6001_4E0D_4F73_8BED_97F3_5B57_6BB5, config["冷却秒"])
                return
            end
            ::__continue71::
            i = i + 1
        end
    end
end
local function _____5904_7406_5EF6_8FDF_72B6_6001_97F3_6548_961F_5217()
    _____5EF6_8FDF_72B6_6001_97F3_6548_5DF2_8C03_5EA6 = false
    while #_____5EF6_8FDF_72B6_6001_97F3_6548_961F_5217 > 0 do
        do
            local record = table.remove(_____5EF6_8FDF_72B6_6001_97F3_6548_961F_5217, 1)
            if record == nil then
                goto __continue77
            end
            local target = record["目标"]
            if not _____76EE_6807_6EE1_8DB3_72B6_6001_97F3_6548_524D_7F6E(target, record["伤害"]) then
                goto __continue77
            end
            local maxLife = _____53D6_6700_5927_751F_547D(target)
            if maxLife <= 0 then
                goto __continue77
            end
            _____5C1D_8BD5_64AD_653E_6218_51B5_52A3_52BF_8BED_97F3(record, maxLife)
            _____5C1D_8BD5_64AD_653E_53D7_4F24_8BED_97F3(record, maxLife)
            _____5C1D_8BD5_64AD_653E_4F4E_8840_72B6_6001_8BED_97F3(target)
        end
        ::__continue77::
    end
end
local function _____72B6_6001_97F3_6548_6700_7EC8_4F24_5BB3_56DE_8C03(target, attacker, applied, _snapshot)
    if not _____76EE_6807_6EE1_8DB3_72B6_6001_97F3_6548_524D_7F6E(target, applied) then
        return
    end
    _____5EF6_8FDF_72B6_6001_97F3_6548_961F_5217[#_____5EF6_8FDF_72B6_6001_97F3_6548_961F_5217 + 1] = {["目标"] = target, ["来源"] = attacker, ["伤害"] = applied}
    if _____5EF6_8FDF_72B6_6001_97F3_6548_5DF2_8C03_5EA6 then
        return
    end
    _____5EF6_8FDF_72B6_6001_97F3_6548_5DF2_8C03_5EA6 = true
    addDelayedCallback(_____72B6_6001_97F3_6548_4F24_5BB3_5EF6_8FDF_6BEB_79D2, _____5904_7406_5EF6_8FDF_72B6_6001_97F3_6548_961F_5217)
end
____exports["init英雄状态音效"] = function()
    if _____72B6_6001_97F3_6548_5DF2_521D_59CB_5316 then
        return
    end
    _____72B6_6001_97F3_6548_5DF2_521D_59CB_5316 = true
    registerAppliedFinalDamageListener(_____72B6_6001_97F3_6548_6700_7EC8_4F24_5BB3_56DE_8C03)
end
return ____exports
