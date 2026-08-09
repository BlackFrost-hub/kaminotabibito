--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local ____require_result_0 = require("系统.12．测试系统.00．测试系统开关")
local _____6D4B_8BD5_7CFB_7EDF_603B_5F00_5173 = ____require_result_0["测试系统总开关"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____8BBE_7F6E_804A_5929_547D_4EE4_6CE8_518C_6743_9650 = ____require_result_1["设置聊天命令注册权限"]
local ____require_result_2 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_2["是允许测试玩家"]
--- 通用技能模板测试默认关闭；Boss 等其他测试仍由总开关控制。
local _____6280_80FD_6A21_677F_6D4B_8BD5_542F_7528 = true
if _____6D4B_8BD5_7CFB_7EDF_603B_5F00_5173 and _____6280_80FD_6A21_677F_6D4B_8BD5_542F_7528 then
    _____8BBE_7F6E_804A_5929_547D_4EE4_6CE8_518C_6743_9650(_____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6)
    require("系统.03．技能系统.00．技能模板+函数.03．技能测试.index")
    _____8BBE_7F6E_804A_5929_547D_4EE4_6CE8_518C_6743_9650(nil)
end
return ____exports
