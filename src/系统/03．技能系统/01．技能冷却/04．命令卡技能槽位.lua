local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__ParseInt = ____lualib.__TS__ParseInt
local ____exports = {}
---
-- @noSelfInFile
local japi = require("jass.japi")
local ydweAbility = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEGetUnitAbilityDataStringSafe = ____require_result_0.YDWEGetUnitAbilityDataStringSafe
local DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton
local KKCommandButtonGetAbilityId = japi.KKCommandButtonGetAbilityId
____exports["命令卡热键槽位表"] = {
    {0, 2, "Q"},
    {1, 2, "W"},
    {2, 2, "E"},
    {3, 2, "R"},
    {0, 1, "D"}
}
____exports["第二排技能槽位表"] = {{0, 1}, {1, 1}, {2, 1}, {3, 1}}
____exports["解析脚本返回整数"] = function(raw)
    if raw == nil or raw == "" then
        return 0
    end
    if type(raw) == "number" and raw == raw and __TS__NumberIsFinite(__TS__Number(raw)) then
        return raw
    end
    local value = __TS__ParseInt(
        tostring(raw),
        10
    )
    return __TS__NumberIsFinite(__TS__Number(value)) and value or 0
end
____exports["读取命令卡按钮能力Id"] = function(x, y)
    local _____6309_94AE_6846_4F53 = DzFrameGetCommandBarButton(y, x)
    if _____6309_94AE_6846_4F53 == 0 then
        return 0
    end
    return KKCommandButtonGetAbilityId(_____6309_94AE_6846_4F53) or 0
end
____exports["按命令卡推断热键"] = function(abilityId)
    if abilityId == 0 then
        return nil
    end
    do
        local i = 0
        while i < #____exports["命令卡热键槽位表"] do
            local x, y, hotkey = table.unpack(____exports["命令卡热键槽位表"][i + 1], 1, 3)
            if ____exports["读取命令卡按钮能力Id"](x, y) == abilityId then
                return hotkey
            end
            i = i + 1
        end
    end
    return nil
end
local function _____5F52_4E00_5316_70ED_952E(rawHotkey)
    local hotkey = tostring(rawHotkey)
    if hotkey == "Q" or hotkey == "q" then
        return "Q"
    end
    if hotkey == "W" or hotkey == "w" then
        return "W"
    end
    if hotkey == "E" or hotkey == "e" then
        return "E"
    end
    if hotkey == "R" or hotkey == "r" then
        return "R"
    end
    if hotkey == "D" or hotkey == "d" then
        return "D"
    end
    return nil
end
local function _____8BFB_53D6_6309_94AE_6280_80FD_70ED_952E(whichHero, x, y)
    if whichHero == nil or whichHero == 0 then
        return nil
    end
    local abilityId = ____exports["读取命令卡按钮能力Id"](x, y)
    if abilityId == 0 then
        return nil
    end
    local rawHotkey = YDWEGetUnitAbilityDataStringSafe(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY)
    if rawHotkey == nil or rawHotkey == "" then
        return nil
    end
    return _____5F52_4E00_5316_70ED_952E(rawHotkey)
end
____exports["获取D技能槽位"] = function(whichHero)
    local _____9ED8_8BA4_69FD_4F4D = ____exports["第二排技能槽位表"][4]
    do
        local i = 0
        while i < #____exports["第二排技能槽位表"] do
            local x, y = table.unpack(____exports["第二排技能槽位表"][i + 1], 1, 2)
            local _____70ED_952E = _____8BFB_53D6_6309_94AE_6280_80FD_70ED_952E(whichHero, x, y)
            if _____70ED_952E == "D" then
                return ____exports["第二排技能槽位表"][i + 1]
            end
            i = i + 1
        end
    end
    return _____9ED8_8BA4_69FD_4F4D
end
return ____exports
