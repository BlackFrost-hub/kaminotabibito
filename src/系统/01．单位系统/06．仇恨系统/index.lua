--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.06．仇恨系统.01．仇恨计算")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.06．仇恨系统.02．目标选择")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.06．仇恨系统.03．仇恨驱动")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.06．仇恨系统.04．仇恨显示")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.01．仇恨计算")
local _____6CE8_518C_4F24_5BB3_4EC7_6068_56DE_8C03 = ____require_result_0["注册伤害仇恨回调"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.03．仇恨驱动")
local _____521D_59CB_5316_4EC7_6068_7CFB_7EDF = ____require_result_1["初始化仇恨系统"]
_____6CE8_518C_4F24_5BB3_4EC7_6068_56DE_8C03()
_____521D_59CB_5316_4EC7_6068_7CFB_7EDF()
return ____exports
