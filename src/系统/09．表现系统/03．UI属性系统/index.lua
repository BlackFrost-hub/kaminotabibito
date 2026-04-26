--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.09．表现系统.03．UI属性系统.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.03．UI属性系统.01．属性工具")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____02_FF0E_9762_677F_6E32_67D3 = require("系统.09．表现系统.03．UI属性系统.02．面板渲染")
    ____exports.createUiFrames = ____02_FF0E_9762_677F_6E32_67D3.createUiFrames
    ____exports.showDamagePanel = ____02_FF0E_9762_677F_6E32_67D3.showDamagePanel
    ____exports.updateDamagePanel = ____02_FF0E_9762_677F_6E32_67D3.updateDamagePanel
    ____exports.updateDetailPanels = ____02_FF0E_9762_677F_6E32_67D3.updateDetailPanels
end
do
    local ____export = require("系统.09．表现系统.03．UI属性系统.03．系统入口")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local ____require_result_0 = require("系统.09．表现系统.03．UI属性系统.03．系统入口")
local initUiAttributeSystem = ____require_result_0.initUiAttributeSystem
function ____exports.init()
    initUiAttributeSystem(nil)
end
return ____exports
