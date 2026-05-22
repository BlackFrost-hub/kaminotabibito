--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_95EA_907F_97F3_6548 = require("系统.09．表现系统.10．英雄语音.01．闪避音效.index")
local ____init_82F1_96C4_95EA_907F_97F3_6548 = ____01_FF0E_95EA_907F_97F3_6548["init英雄闪避音效"]
local ____02_FF0E_5347_7EA7_97F3_6548 = require("系统.09．表现系统.10．英雄语音.02．升级音效.index")
local ____init_82F1_96C4_5347_7EA7_97F3_6548 = ____02_FF0E_5347_7EA7_97F3_6548["init英雄升级音效"]
local ____03_FF0E_6B7B_4EA1_97F3_6548 = require("系统.09．表现系统.10．英雄语音.03．死亡音效.index")
local ____init_82F1_96C4_6B7B_4EA1_97F3_6548 = ____03_FF0E_6B7B_4EA1_97F3_6548["init英雄死亡音效"]
local ____04_FF0E_4F7F_7528_7269_54C1_97F3_6548 = require("系统.09．表现系统.10．英雄语音.04．使用物品音效.index")
local ____init_82F1_96C4_4F7F_7528_7269_54C1_97F3_6548 = ____04_FF0E_4F7F_7528_7269_54C1_97F3_6548["init英雄使用物品音效"]
local ____05_FF0E_6307_4EE4_97F3_6548 = require("系统.09．表现系统.10．英雄语音.05．指令音效.index")
local ____init_82F1_96C4_6307_4EE4_97F3_6548 = ____05_FF0E_6307_4EE4_97F3_6548["init英雄指令音效"]
local ____on_82F1_96C4_6307_4EE4_97F3_6548_82F1_96C4_6CE8_518C = ____05_FF0E_6307_4EE4_97F3_6548.onPlayerHeroRegistered
local ____06_FF0E_51FB_6740_97F3_6548 = require("系统.09．表现系统.10．英雄语音.06．击杀音效.index")
local ____init_82F1_96C4_51FB_6740_97F3_6548 = ____06_FF0E_51FB_6740_97F3_6548["init英雄击杀音效"]
local ____07_FF0E_6CBB_7597_97F3_6548 = require("系统.09．表现系统.10．英雄语音.07．治疗音效.index")
local ____init_82F1_96C4_6CBB_7597_97F3_6548 = ____07_FF0E_6CBB_7597_97F3_6548["init英雄治疗音效"]
local ____08_FF0E_72B6_6001_97F3_6548 = require("系统.09．表现系统.10．英雄语音.08．状态音效.index")
local ____init_82F1_96C4_72B6_6001_97F3_6548 = ____08_FF0E_72B6_6001_97F3_6548["init英雄状态音效"]
do
    local ____export = require("系统.09．表现系统.10．英雄语音.01．闪避音效.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.10．英雄语音.02．升级音效.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.10．英雄语音.03．死亡音效.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.10．英雄语音.04．使用物品音效.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.10．英雄语音.05．指令音效.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.10．英雄语音.06．击杀音效.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.10．英雄语音.07．治疗音效.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.10．英雄语音.08．状态音效.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local _____82F1_96C4_8BED_97F3_7CFB_7EDF_5DF2_521D_59CB_5316 = false
function ____exports.init()
    if _____82F1_96C4_8BED_97F3_7CFB_7EDF_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_8BED_97F3_7CFB_7EDF_5DF2_521D_59CB_5316 = true
    ____init_82F1_96C4_95EA_907F_97F3_6548()
    ____init_82F1_96C4_5347_7EA7_97F3_6548()
    ____init_82F1_96C4_6B7B_4EA1_97F3_6548()
    ____init_82F1_96C4_4F7F_7528_7269_54C1_97F3_6548()
    ____init_82F1_96C4_6307_4EE4_97F3_6548()
    ____init_82F1_96C4_51FB_6740_97F3_6548()
    ____init_82F1_96C4_6CBB_7597_97F3_6548()
    ____init_82F1_96C4_72B6_6001_97F3_6548()
end
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    ____on_82F1_96C4_6307_4EE4_97F3_6548_82F1_96C4_6CE8_518C(whichPlayer, whichHero)
end
return ____exports
