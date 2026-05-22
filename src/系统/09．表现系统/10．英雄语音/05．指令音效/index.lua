--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_82F1_96C4_6307_4EE4_97F3_6548 = require("系统.09．表现系统.10．英雄语音.05．指令音效.01．英雄指令音效")
local ____init_82F1_96C4_6307_4EE4_97F3_6548_7CFB_7EDF = ____01_FF0E_82F1_96C4_6307_4EE4_97F3_6548["init英雄指令音效系统"]
local ____on_82F1_96C4_6307_4EE4_97F3_6548_82F1_96C4_6CE8_518C = ____01_FF0E_82F1_96C4_6307_4EE4_97F3_6548.onPlayerHeroRegistered
do
    local ____export = require("系统.09．表现系统.10．英雄语音.05．指令音效.00．配置")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.10．英雄语音.05．指令音效.01．英雄指令音效")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local _____82F1_96C4_6307_4EE4_97F3_6548_6A21_5757_5DF2_521D_59CB_5316 = false
____exports["init英雄指令音效"] = function()
    if _____82F1_96C4_6307_4EE4_97F3_6548_6A21_5757_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_6307_4EE4_97F3_6548_6A21_5757_5DF2_521D_59CB_5316 = true
    ____init_82F1_96C4_6307_4EE4_97F3_6548_7CFB_7EDF()
end
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    ____on_82F1_96C4_6307_4EE4_97F3_6548_82F1_96C4_6CE8_518C(whichPlayer, whichHero)
end
return ____exports
