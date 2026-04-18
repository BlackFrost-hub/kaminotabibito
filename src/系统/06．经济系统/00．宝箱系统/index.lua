--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____01_FF0E_5B9D_7BB1_6838_5FC3 = require("系统.06．经济系统.00．宝箱系统.01．宝箱核心")
    ____exports.onUnitTargetInteractable = ____01_FF0E_5B9D_7BB1_6838_5FC3.onUnitTargetInteractable
    ____exports.onUnitTargetChest = ____01_FF0E_5B9D_7BB1_6838_5FC3.onUnitTargetChest
    ____exports.isUnitOpening = ____01_FF0E_5B9D_7BB1_6838_5FC3.isUnitOpening
    ____exports.isUnitOpeningChest = ____01_FF0E_5B9D_7BB1_6838_5FC3.isUnitOpeningChest
    ____exports.interruptOpening = ____01_FF0E_5B9D_7BB1_6838_5FC3.interruptOpening
    ____exports.interruptChestOpening = ____01_FF0E_5B9D_7BB1_6838_5FC3.interruptChestOpening
    ____exports.STES_EVENT_PREPARE = ____01_FF0E_5B9D_7BB1_6838_5FC3.STES_EVENT_PREPARE
    ____exports.STES_EVENT_OPENED = ____01_FF0E_5B9D_7BB1_6838_5FC3.STES_EVENT_OPENED
    ____exports.YDLOCAL_VAR_OPENER = ____01_FF0E_5B9D_7BB1_6838_5FC3.YDLOCAL_VAR_OPENER
    ____exports.YDLOCAL_VAR_CHEST = ____01_FF0E_5B9D_7BB1_6838_5FC3.YDLOCAL_VAR_CHEST
    ____exports.YDLOCAL_VAR_PRE_OPENER = ____01_FF0E_5B9D_7BB1_6838_5FC3.YDLOCAL_VAR_PRE_OPENER
    ____exports.YDLOCAL_VAR_PRE_CHEST = ____01_FF0E_5B9D_7BB1_6838_5FC3.YDLOCAL_VAR_PRE_CHEST
    ____exports.isInteractable = ____01_FF0E_5B9D_7BB1_6838_5FC3.isInteractable
    ____exports.getOpenTime = ____01_FF0E_5B9D_7BB1_6838_5FC3.getOpenTime
end
do
    local ____02_FF0E_4E8B_4EF6_6CE8_518C = require("系统.06．经济系统.00．宝箱系统.02．事件注册")
    ____exports.registerChestSystemHero = ____02_FF0E_4E8B_4EF6_6CE8_518C.registerChestSystemHero
    ____exports.initChestSystem = ____02_FF0E_4E8B_4EF6_6CE8_518C.initChestSystem
    ____exports.STES_EVENT_UNIT_TARGET_ORDER = ____02_FF0E_4E8B_4EF6_6CE8_518C.STES_EVENT_UNIT_TARGET_ORDER
end
return ____exports
