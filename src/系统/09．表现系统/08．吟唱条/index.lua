--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
require("系统.09．表现系统.08．吟唱条.05．吟唱条STES桥接")
do
    local ____export = require("系统.09．表现系统.08．吟唱条.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.08．吟唱条.01．类型")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.08．吟唱条.02．UI创建")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____03_FF0E_541F_5531_6761_6838_5FC3 = require("系统.09．表现系统.08．吟唱条.03．吟唱条核心")
    ____exports["启动吟唱条"] = ____03_FF0E_541F_5531_6761_6838_5FC3["启动吟唱条"]
    ____exports["关闭吟唱条核心"] = ____03_FF0E_541F_5531_6761_6838_5FC3["关闭吟唱条"]
    ____exports["获取吟唱条状态"] = ____03_FF0E_541F_5531_6761_6838_5FC3["获取吟唱条状态"]
end
do
    local ____export = require("系统.09．表现系统.08．吟唱条.04．数字格式化")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.08．吟唱条.05．吟唱条STES桥接")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____06_FF0E_5BF9_5916_63A5_53E3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
    ____exports["显示吟唱条"] = ____06_FF0E_5BF9_5916_63A5_53E3["显示吟唱条"]
    ____exports["关闭吟唱条"] = ____06_FF0E_5BF9_5916_63A5_53E3["关闭吟唱条"]
    ____exports["显示常规技能吟唱条"] = ____06_FF0E_5BF9_5916_63A5_53E3["显示常规技能吟唱条"]
    ____exports["显示大招吟唱条"] = ____06_FF0E_5BF9_5916_63A5_53E3["显示大招吟唱条"]
    ____exports["显示场地常驻AOE吟唱条"] = ____06_FF0E_5BF9_5916_63A5_53E3["显示场地常驻AOE吟唱条"]
    ____exports["显示致命惩罚吟唱条"] = ____06_FF0E_5BF9_5916_63A5_53E3["显示致命惩罚吟唱条"]
    ____exports["显示场地AOE吟唱条"] = ____06_FF0E_5BF9_5916_63A5_53E3["显示场地AOE吟唱条"]
end
return ____exports
