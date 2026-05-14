local ____lualib = require("lualib_bundle")
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringReplace = ____lualib.__TS__StringReplace
local ____exports = {}
local ____01_FF0E_516C_5F0F_914D_7F6E = require("系统.03．技能系统.07．动态技能文本.01．公式配置")
local _____5C5E_6027_540D_79F0_5217_8868 = ____01_FF0E_516C_5F0F_914D_7F6E["属性名称列表"]
local ____02_FF0E_5C5E_6027_8BA1_7B97 = require("系统.03．技能系统.07．动态技能文本.02．属性计算")
local _____8BA1_7B97_516C_5F0F_4F24_5BB3 = ____02_FF0E_5C5E_6027_8BA1_7B97["计算公式伤害"]
--- 动态技能文本 - 核心业务逻辑
-- 
-- 遍历本地玩家选中单位的命令卡技能，动态替换描述中的公式为实际伤害数值
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_0.debugLog
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local DzGetUnitAbilityUberTip = japi.DzGetUnitAbilityUberTip
local DzSetUnitAbilityUberTip = japi.DzSetUnitAbilityUberTip
local DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate
local DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton
local KKCommandButtonGetAbilityId = japi.KKCommandButtonGetAbilityId
local MODULE_NAME = "动态技能文本"
--- 命令卡技能槽位坐标映射：[列, 行]
local _____547D_4EE4_5361_6280_80FD_69FD_4F4D = {
    {0, 2},
    {1, 2},
    {2, 2},
    {3, 2},
    {0, 1}
}
local function isValidHandle(handle)
    return handle ~= nil and handle ~= 0
end
--- 通过命令卡面板XY坐标获取技能ID
local function getUnitAbilityIds()
    local ids = {}
    do
        local i = 0
        while i < #_____547D_4EE4_5361_6280_80FD_69FD_4F4D do
            local x, y = table.unpack(_____547D_4EE4_5361_6280_80FD_69FD_4F4D[i + 1], 1, 2)
            local btn = DzFrameGetCommandBarButton(y, x)
            if btn ~= 0 then
                local abilId = KKCommandButtonGetAbilityId(btn)
                if abilId ~= 0 then
                    ids[#ids + 1] = abilId
                end
            end
            i = i + 1
        end
    end
    return ids
end
--- 从字符串中提取数字倍率
-- 例如："×3" -> "3", "×50%" -> "50%"
local function _____63D0_53D6_500D_7387(text, _____5C5E_6027_540D_79F0)
    local _____524D_7F00 = _____5C5E_6027_540D_79F0 .. "×"
    local _____8D77_59CB_4F4D_7F6E = (string.find(text, _____524D_7F00, nil, true) or 0) - 1
    if _____8D77_59CB_4F4D_7F6E < 0 then
        return nil
    end
    local _____6570_5B57_8D77_59CB = _____8D77_59CB_4F4D_7F6E + #_____524D_7F00
    local _____6570_5B57_7ED3_675F = _____6570_5B57_8D77_59CB
    while _____6570_5B57_7ED3_675F < #text do
        local _____5B57_7B26 = __TS__StringCharAt(text, _____6570_5B57_7ED3_675F)
        if _____5B57_7B26 >= "0" and _____5B57_7B26 <= "9" or _____5B57_7B26 == "." then
            _____6570_5B57_7ED3_675F = _____6570_5B57_7ED3_675F + 1
        elseif _____5B57_7B26 == "%" then
            _____6570_5B57_7ED3_675F = _____6570_5B57_7ED3_675F + 1
            break
        else
            break
        end
    end
    if _____6570_5B57_7ED3_675F == _____6570_5B57_8D77_59CB then
        return nil
    end
    return __TS__StringSubstring(text, _____6570_5B57_8D77_59CB, _____6570_5B57_7ED3_675F)
end
--- 动态替换技能提示中的公式
-- 例如：智力×3 -> 150（假设英雄智力50）
local function _____66FF_6362_516C_5F0F(unit, tip)
    local result = tip
    do
        local i = 0
        while i < #_____5C5E_6027_540D_79F0_5217_8868 do
            local _____5C5E_6027_540D_79F0 = _____5C5E_6027_540D_79F0_5217_8868[i + 1]
            local _____500D_7387 = _____63D0_53D6_500D_7387(result, _____5C5E_6027_540D_79F0)
            while _____500D_7387 ~= nil do
                local _____5B8C_6574_5339_914D = (_____5C5E_6027_540D_79F0 .. "×") .. _____500D_7387
                local _____4F24_5BB3 = _____8BA1_7B97_516C_5F0F_4F24_5BB3(unit, _____5C5E_6027_540D_79F0, _____500D_7387)
                local _____66FF_6362_503C = tostring(_____4F24_5BB3)
                result = __TS__StringReplace(result, _____5B8C_6574_5339_914D, _____66FF_6362_503C)
                debugLog(nil, MODULE_NAME, (("替换 " .. _____5B8C_6574_5339_914D) .. " -> ") .. _____66FF_6362_503C)
                _____500D_7387 = _____63D0_53D6_500D_7387(result, _____5C5E_6027_540D_79F0)
            end
            i = i + 1
        end
    end
    return result
end
--- 处理单个技能的提示文本
local function _____5904_7406_6280_80FD_63D0_793A(unit, abilityId)
    local currentTip = DzGetUnitAbilityUberTip(unit, abilityId)
    if not currentTip then
        return false
    end
    local newTip = _____66FF_6362_516C_5F0F(unit, currentTip)
    if newTip ~= currentTip then
        DzSetUnitAbilityUberTip(unit, abilityId, newTip)
        DzSetUnitAbilityUpdate(unit, abilityId)
        return true
    end
    return false
end
--- 检查本地主控单位的命令卡技能
____exports["检查英雄技能"] = function(hero)
    if not isValidHandle(hero) then
        return
    end
    local abilityIds = getUnitAbilityIds()
    do
        local i = 0
        while i < #abilityIds do
            local level = GetUnitAbilityLevel(hero, abilityIds[i + 1])
            if level > 0 then
                _____5904_7406_6280_80FD_63D0_793A(hero, abilityIds[i + 1])
            end
            i = i + 1
        end
    end
end
return ____exports
