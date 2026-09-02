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
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLog = ____require_result_1.debugLog
local setDebug = ____require_result_1.setDebug
local _____73A9_5BB6_82F1_96C4_914D_7F6E_5DE5_5177 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
--- QWERD 显示排查调试开关：true 时输出 D 槽位探测过程（聊天输入 -dc 打一次快照汇总）。
____exports.QWERD_DEBUG = true
setDebug("QWERD调试", ____exports.QWERD_DEBUG)
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
--- 读取命令卡按钮能力 ID 并输出调试日志（-dc 排查用，能看到原始返回）。
____exports["调试读取命令卡按钮能力Id"] = function(x, y)
    local _____6309_94AE_6846_4F53 = DzFrameGetCommandBarButton(y, x)
    local abilityId = _____6309_94AE_6846_4F53 == 0 and 0 or (KKCommandButtonGetAbilityId(_____6309_94AE_6846_4F53) or 0)
    debugLog(
        "QWERD调试",
        (((((("按钮(" .. tostring(x)) .. ",") .. tostring(y)) .. ") frame=") .. tostring(_____6309_94AE_6846_4F53)) .. " abilityId=") .. tostring(abilityId)
    )
    return abilityId
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
    local _____914D_7F6E = _____73A9_5BB6_82F1_96C4_914D_7F6E_5DE5_5177["获取单位玩家英雄配置"](whichHero)
    local dAbilityId = _____914D_7F6E ~= nil and stringToFourCCSafe(_____914D_7F6E["D技能"]) or 0
    if dAbilityId ~= 0 then
        do
            local i = 0
            while i < #____exports["第二排技能槽位表"] do
                local x, y = table.unpack(____exports["第二排技能槽位表"][i + 1], 1, 2)
                if ____exports["读取命令卡按钮能力Id"](x, y) == dAbilityId then
                    return ____exports["第二排技能槽位表"][i + 1]
                end
                i = i + 1
            end
        end
    end
    do
        local i = 0
        while i < #____exports["第二排技能槽位表"] do
            local x, y = table.unpack(____exports["第二排技能槽位表"][i + 1], 1, 2)
            if _____8BFB_53D6_6309_94AE_6280_80FD_70ED_952E(whichHero, x, y) == "D" then
                return ____exports["第二排技能槽位表"][i + 1]
            end
            i = i + 1
        end
    end
    return _____9ED8_8BA4_69FD_4F4D
end
--- -dc 调试入口：转储本地选中英雄的命令卡两排按钮、热键读取结果与快照 D 槽位判定过程。
____exports["调试转储命令卡槽位"] = function(whichHero)
    debugLog("QWERD调试", "========== -dc 命令卡槽位转储开始 ==========")
    debugLog(
        "QWERD调试",
        "hero=" .. tostring(whichHero)
    )
    do
        local i = 0
        while i < #____exports["第二排技能槽位表"] do
            local x, y = table.unpack(____exports["第二排技能槽位表"][i + 1], 1, 2)
            local abilityId = ____exports["读取命令卡按钮能力Id"](x, y)
            local rawHotkey = whichHero ~= nil and whichHero ~= 0 and abilityId ~= 0 and YDWEGetUnitAbilityDataStringSafe(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY) or ""
            debugLog(
                "QWERD调试",
                (((((("第二排(" .. tostring(x)) .. ",") .. tostring(y)) .. ") abilityId=") .. tostring(abilityId)) .. " rawHotkey=") .. tostring(rawHotkey)
            )
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #____exports["命令卡热键槽位表"] - 1 do
            local x, y, _____70ED_952E = table.unpack(____exports["命令卡热键槽位表"][i + 1], 1, 3)
            local abilityId = ____exports["读取命令卡按钮能力Id"](x, y)
            local rawHotkey = whichHero ~= nil and whichHero ~= 0 and abilityId ~= 0 and YDWEGetUnitAbilityDataStringSafe(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY) or ""
            debugLog(
                "QWERD调试",
                (((((((("第三排(" .. tostring(x)) .. ",") .. tostring(y)) .. ") 期望") .. _____70ED_952E) .. " abilityId=") .. tostring(abilityId)) .. " rawHotkey=") .. tostring(rawHotkey)
            )
            i = i + 1
        end
    end
    local dSlot = ____exports["获取D技能槽位"](whichHero)
    debugLog(
        "QWERD调试",
        ((("D技能槽位判定结果 = (" .. tostring(dSlot[1])) .. ",") .. tostring(dSlot[2])) .. ")"
    )
    debugLog("QWERD调试", "========== -dc 命令卡槽位转储结束 ==========")
end
return ____exports
