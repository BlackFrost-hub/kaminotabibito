local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_0["是允许测试玩家"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C = ____require_result_1["注册聊天命令前缀监听"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local GetHeroLevel = jass.GetHeroLevel
local SetHeroLevel = jass.SetHeroLevel
local S2I = jass.S2I
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____82F1_96C4_5347_7EA7_547D_4EE4_524D_7F00 = "-dj"
local function _____53D1_9001_82F1_96C4_5347_7EA7_63D0_793A(player, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        6,
        "[测试] " .. text
    )
end
local function _____662F_5341_8FDB_5236_6570_5B57_5B57_7B26(text)
    return text == "0" or text == "1" or text == "2" or text == "3" or text == "4" or text == "5" or text == "6" or text == "7" or text == "8" or text == "9"
end
local function _____89E3_6790_5FAA_73AF_5347_7EA7_6B21_6570(command)
    local text = __TS__StringTrim(__TS__StringSubstring(command, #_____82F1_96C4_5347_7EA7_547D_4EE4_524D_7F00))
    if __TS__StringSubstring(text, 0, 1) == "+" then
        text = __TS__StringTrim(__TS__StringSubstring(text, 1))
    end
    if text == "" then
        return nil
    end
    do
        local i = 0
        while i < #text do
            if not _____662F_5341_8FDB_5236_6570_5B57_5B57_7B26(__TS__StringSubstring(text, i, i + 1)) then
                return nil
            end
            i = i + 1
        end
    end
    local count = S2I(text)
    if count <= 0 then
        return nil
    end
    return count
end
local function ____on_82F1_96C4_5FAA_73AF_5347_7EA7_547D_4EE4(player, command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local count = _____89E3_6790_5FAA_73AF_5347_7EA7_6B21_6570(command)
    if count == nil then
        _____53D1_9001_82F1_96C4_5347_7EA7_63D0_793A(player, "命令格式：-dj数字，例如：-dj5")
        return
    end
    local hero = getRegisteredPlayerHero(player)
    if hero == nil or hero == 0 then
        _____53D1_9001_82F1_96C4_5347_7EA7_63D0_793A(player, "当前玩家没有已注册英雄")
        return
    end
    local upgradedCount = 0
    do
        local i = 0
        while i < count do
            local previousLevel = GetHeroLevel(hero)
            SetHeroLevel(hero, previousLevel + 1, false)
            if GetHeroLevel(hero) <= previousLevel then
                break
            end
            upgradedCount = upgradedCount + 1
            i = i + 1
        end
    end
    _____53D1_9001_82F1_96C4_5347_7EA7_63D0_793A(
        player,
        (("英雄已逐级提升 " .. tostring(upgradedCount)) .. " 级，当前等级 ") .. tostring(GetHeroLevel(hero))
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C(_____82F1_96C4_5347_7EA7_547D_4EE4_524D_7F00, ____on_82F1_96C4_5FAA_73AF_5347_7EA7_547D_4EE4)
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
debugLogForce("英雄循环升级测试", "已注册监听", "前缀", _____82F1_96C4_5347_7EA7_547D_4EE4_524D_7F00)
return ____exports
