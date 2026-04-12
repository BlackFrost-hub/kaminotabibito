--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local timer = require("lib.扩展函数.封装函数.05．泄露审计.02．计时器审计")
local group = require("lib.扩展函数.封装函数.05．泄露审计.03．单位组审计")
local trigger = require("lib.扩展函数.封装函数.05．泄露审计.04．触发器审计")
local effect = require("lib.扩展函数.封装函数.05．泄露审计.05．特效审计")
local rect = require("lib.扩展函数.封装函数.05．泄露审计.06．矩形审计")
local sound = require("lib.扩展函数.封装函数.05．泄露审计.07．音效审计")
local texttag = require("lib.扩展函数.封装函数.05．泄露审计.08．漂浮文字审计")
local ____09_FF0E_6253_5370_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.09．打印统计")
local dump = ____09_FF0E_6253_5370_7EDF_8BA1.dump
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.01．核心统计")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.02．计时器审计")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.03．单位组审计")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.04．触发器审计")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.05．特效审计")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.06．矩形审计")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.07．音效审计")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.08．漂浮文字审计")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.09．打印统计")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.封装函数.05．泄露审计.10．聊天命令")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
____exports.LeakWatcher = {
    createTimer = timer.createTimer,
    destroyTimer = timer.destroyTimer,
    createGroup = group.createGroup,
    destroyGroup = group.destroyGroup,
    createTrigger = trigger.createTrigger,
    destroyTrigger = trigger.destroyTrigger,
    trackEffect = effect.trackEffect,
    destroyEffect = effect.destroyEffect,
    trackRect = rect.trackRect,
    removeRect = rect.removeRect,
    createSound = sound.createSound,
    killSoundWhenDone = sound.killSoundWhenDone,
    releaseSound = sound.releaseSound,
    stopSoundAndKill = sound.stopSoundAndKill,
    createTextTag = texttag.createTextTag,
    destroyTextTag = texttag.destroyTextTag,
    dump = dump
}
return ____exports
