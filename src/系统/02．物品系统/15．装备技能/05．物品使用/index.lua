--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.00．物品使用装备名")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____03_FF0E_7269_54C1_4F7F_7528_6838_5FC3 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.03．物品使用核心")
    ____exports["初始化装备物品使用链"] = ____03_FF0E_7269_54C1_4F7F_7528_6838_5FC3["初始化装备物品使用链"]
end
return ____exports
