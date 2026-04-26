--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.09．表现系统.03．UI属性系统.index")
local initUiAttributeSystem = ____index.init
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
require("系统.09．表现系统.02．对话框系统.index")
local _____539F_751FUI = require("系统.09．表现系统.00．初始化UI")
function ____exports.init(self)
    if type(_____539F_751FUI.initNativeUI) == "function" then
        _____539F_751FUI:initNativeUI()
    end
    initUiAttributeSystem()
end
return ____exports
