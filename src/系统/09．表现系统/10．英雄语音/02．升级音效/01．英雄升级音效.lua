local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.09．表现系统.10．英雄语音.02．升级音效.00．配置")
local _____82F1_96C4_5347_7EA7_97F3_6548_914D_7F6E_5217_8868 = ____00_FF0E_914D_7F6E["英雄升级音效配置列表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.06．英雄升级事件中心")
local registerHeroLevelListener = ____require_result_0.registerHeroLevelListener
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local ____require_result_2 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_914D_7F6E = ____require_result_2["获取单位玩家英雄配置"]
local ____require_result_3 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名")
local _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0 = ____require_result_3["单位是否匹配玩家英雄名称"]
local GetLocalPlayer = jass.GetLocalPlayer
local GetOwningPlayer = jass.GetOwningPlayer
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local StartSound = jass.StartSound
local _____82F1_96C4_5347_7EA7_97F3_6548_5DF2_521D_59CB_5316 = false
local function _____53D6_5355_4F4D_5339_914D_540D_5217_8868(unit)
    local config = _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_914D_7F6E(unit)
    if config == nil then
        return {}
    end
    local result = {}
    local ____config_Name_4 = config.Name
    if ____config_Name_4 == nil then
        ____config_Name_4 = ""
    end
    local name = __TS__StringTrim(tostring(____config_Name_4))
    local ____config_Propernames_5 = config.Propernames
    if ____config_Propernames_5 == nil then
        ____config_Propernames_5 = ""
    end
    local proper = __TS__StringTrim(tostring(____config_Propernames_5))
    if name ~= "" then
        result[#result + 1] = name
    end
    if proper ~= "" then
        result[#result + 1] = proper
    end
    return result
end
local function _____5339_914D_5347_7EA7_97F3_6548_914D_7F6E(unit)
    do
        local i = 0
        while i < #_____82F1_96C4_5347_7EA7_97F3_6548_914D_7F6E_5217_8868 do
            local config = _____82F1_96C4_5347_7EA7_97F3_6548_914D_7F6E_5217_8868[i + 1]
            if _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0(unit, config["英雄名"]) then
                return config
            end
            i = i + 1
        end
    end
    return nil
end
local function _____672C_5730_64AD_653E_5347_7EA7_97F3_6548(unit, soundHandle)
    if soundHandle == nil then
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
local function ____on_82F1_96C4_5347_7EA7_8BED_97F3(heroUnit)
    if heroUnit == nil or heroUnit == 0 then
        return
    end
    local owner = GetOwningPlayer(heroUnit)
    if owner == nil or owner == 0 then
        return
    end
    local registeredHero = YDUserDataGetSafe("player", owner, "英雄", "unit")
    if registeredHero == nil or registeredHero == 0 then
        return
    end
    if registeredHero ~= heroUnit and GetHandleId(registeredHero) ~= GetHandleId(heroUnit) then
        return
    end
    if IsUnitType(heroUnit, jass.UNIT_TYPE_DEAD) then
        return
    end
    local config = _____5339_914D_5347_7EA7_97F3_6548_914D_7F6E(heroUnit)
    if config == nil then
        return
    end
    _____672C_5730_64AD_653E_5347_7EA7_97F3_6548(heroUnit, config["播放音效"])
end
____exports["init英雄升级音效系统"] = function()
    if _____82F1_96C4_5347_7EA7_97F3_6548_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_5347_7EA7_97F3_6548_5DF2_521D_59CB_5316 = true
    registerHeroLevelListener(____on_82F1_96C4_5347_7EA7_8BED_97F3)
end
return ____exports
