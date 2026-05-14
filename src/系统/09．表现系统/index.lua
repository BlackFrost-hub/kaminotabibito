--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.09．表现系统.03．UI属性系统.index")
local initUiAttributeSystem = ____index.init
local ____index = require("系统.09．表现系统.06．广播提示消息.index")
local _____521D_59CB_5316_5E7F_64AD_63D0_793A_6D88_606F_7CFB_7EDF = ____index["初始化广播提示消息系统"]
local ____index = require("系统.09．表现系统.07．游戏说明手册.index")
local initGameManual = ____index.init
do
    local ____export = require("系统.09．表现系统.01．UI工具.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.00．初始化UI")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.04．翻页UI预研.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.05．仇恨面板.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.06．广播提示消息.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.07．游戏说明手册.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.09．表现系统.02．对话框系统.index")
local _____539F_751FUI = require("系统.09．表现系统.00．初始化UI")
function ____exports.init(self)
    if type(_____539F_751FUI.initNativeUI) == "function" then
        _____539F_751FUI:initNativeUI()
    end
    initUiAttributeSystem()
    _____521D_59CB_5316_5E7F_64AD_63D0_793A_6D88_606F_7CFB_7EDF()
    initGameManual()
end
return ____exports
