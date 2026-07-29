--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_58F0_97F3_6A21_578B = require("lib.扩展函数.封装函数.02．音效系统.01．声音模型")
local SoundModel = ____01_FF0E_58F0_97F3_6A21_578B.SoundModel
local ____02_FF0E_97F3_6548_6C60 = require("lib.扩展函数.封装函数.02．音效系统.02．音效池")
local setDefaultSoundModel = ____02_FF0E_97F3_6548_6C60.setDefaultSoundModel
local ____05_FF0EUI_97F3_6548 = require("lib.扩展函数.封装函数.02．音效系统.05．UI音效")
local DEFAULT_UI_CLICK_SOUND = ____05_FF0EUI_97F3_6548.DEFAULT_UI_CLICK_SOUND
local prewarmUiClickSound = ____05_FF0EUI_97F3_6548.prewarmUiClickSound
do
    local ____export = require("lib.扩展函数.封装函数.02．音效系统.01．声音模型")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.02．音效系统.04．MP3音效播放")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.02．音效系统.05．UI音效")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.02．音效系统.06．参数设置")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.02．音效系统.07．原生任务音效")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
function ____exports.initSound3DII(self)
    setDefaultSoundModel(SoundModel:create())
    prewarmUiClickSound(DEFAULT_UI_CLICK_SOUND)
end
____exports.initSound3DII(nil)
return ____exports
