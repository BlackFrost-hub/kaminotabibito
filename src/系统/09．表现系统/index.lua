--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.09．表现系统.01．UI工具.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.03．UI属性系统.index")
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
local _____539F_751FUI = require("系统.09．表现系统.00．初始化UI")
_____539F_751FUI:initNativeUI()
local ____UI_5C5E_6027_7CFB_7EDF = require("系统.09．表现系统.03．UI属性系统.index")
--- 初始化表现系统
function ____exports.init(self)
    if type(____UI_5C5E_6027_7CFB_7EDF.init) == "function" then
        ____UI_5C5E_6027_7CFB_7EDF:init()
    end
end
return ____exports
