--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.04．伤害系统.04．伤害显示.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____02_FF0E_6838_5FC3_529F_80FD = require("系统.04．伤害系统.04．伤害显示.02．核心功能")
    ____exports.showDamageNumber = ____02_FF0E_6838_5FC3_529F_80FD.showDamageNumber
    ____exports.updateAllDamageDigits = ____02_FF0E_6838_5FC3_529F_80FD.updateAllDamageDigits
    ____exports.hasActiveDigits = ____02_FF0E_6838_5FC3_529F_80FD.hasActiveDigits
end
do
    local ____03_FF0EBoss_6218_7EDF_8BA1 = require("系统.04．伤害系统.04．伤害显示.03．Boss战统计")
    ____exports.updateBossDamageStats = ____03_FF0EBoss_6218_7EDF_8BA1.updateBossDamageStats
    ____exports.isInBossBattle = ____03_FF0EBoss_6218_7EDF_8BA1.isInBossBattle
    ____exports.getBossUnit = ____03_FF0EBoss_6218_7EDF_8BA1.getBossUnit
    ____exports.getPlayerDamageToBoss = ____03_FF0EBoss_6218_7EDF_8BA1.getPlayerDamageToBoss
    ____exports.getPlayerDamageFromBoss = ____03_FF0EBoss_6218_7EDF_8BA1.getPlayerDamageFromBoss
end
do
    local ____04_FF0E_4E8B_4EF6_6CE8_518C = require("系统.04．伤害系统.04．伤害显示.04．事件注册")
    ____exports.initDamageDisplay = ____04_FF0E_4E8B_4EF6_6CE8_518C.initDamageDisplay
end
return ____exports
