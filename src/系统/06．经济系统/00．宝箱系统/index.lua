--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
    ____exports.CHEST_TYPES = ____00_FF0E_5E38_91CF_5B9A_4E49.CHEST_TYPES
    ____exports.DEFAULT_OPEN_TIME = ____00_FF0E_5E38_91CF_5B9A_4E49.DEFAULT_OPEN_TIME
    ____exports.INTERACT_RANGE = ____00_FF0E_5E38_91CF_5B9A_4E49.INTERACT_RANGE
    ____exports.UPDATE_INTERVAL = ____00_FF0E_5E38_91CF_5B9A_4E49.UPDATE_INTERVAL
    ____exports.PROGRESS_BAR_SCALE = ____00_FF0E_5E38_91CF_5B9A_4E49.PROGRESS_BAR_SCALE
    ____exports.PROGRESS_BAR_HEIGHT_OFFSET = ____00_FF0E_5E38_91CF_5B9A_4E49.PROGRESS_BAR_HEIGHT_OFFSET
    ____exports.EVENT_PLAYER_PREPARE_OPEN_CHEST = ____00_FF0E_5E38_91CF_5B9A_4E49.EVENT_PLAYER_PREPARE_OPEN_CHEST
    ____exports.EVENT_CHEST_OPENED = ____00_FF0E_5E38_91CF_5B9A_4E49.EVENT_CHEST_OPENED
    ____exports.YDLOCAL_VAR_OPENER = ____00_FF0E_5E38_91CF_5B9A_4E49.YDLOCAL_VAR_OPENER
    ____exports.YDLOCAL_VAR_CHEST = ____00_FF0E_5E38_91CF_5B9A_4E49.YDLOCAL_VAR_CHEST
    ____exports.YDLOCAL_VAR_PRE_OPENER = ____00_FF0E_5E38_91CF_5B9A_4E49.YDLOCAL_VAR_PRE_OPENER
    ____exports.YDLOCAL_VAR_PRE_CHEST = ____00_FF0E_5E38_91CF_5B9A_4E49.YDLOCAL_VAR_PRE_CHEST
    ____exports.TEXT_OPENING = ____00_FF0E_5E38_91CF_5B9A_4E49.TEXT_OPENING
    ____exports.TEXT_SUCCESS = ____00_FF0E_5E38_91CF_5B9A_4E49.TEXT_SUCCESS
    ____exports.TEXT_INTERRUPTED = ____00_FF0E_5E38_91CF_5B9A_4E49.TEXT_INTERRUPTED
    ____exports.isChestType = ____00_FF0E_5E38_91CF_5B9A_4E49.isChestType
    ____exports.getChestConfig = ____00_FF0E_5E38_91CF_5B9A_4E49.getChestConfig
    ____exports.getChestConfigByString = ____00_FF0E_5E38_91CF_5B9A_4E49.getChestConfigByString
end
do
    local ____03_FF0E_5B9D_7BB1_6838_5FC3 = require("系统.06．经济系统.00．宝箱系统.03．宝箱核心")
    ____exports.onUnitTargetInteractable = ____03_FF0E_5B9D_7BB1_6838_5FC3.onUnitTargetInteractable
    ____exports.onUnitTargetChest = ____03_FF0E_5B9D_7BB1_6838_5FC3.onUnitTargetChest
    ____exports.isUnitOpening = ____03_FF0E_5B9D_7BB1_6838_5FC3.isUnitOpening
    ____exports.isUnitOpeningChest = ____03_FF0E_5B9D_7BB1_6838_5FC3.isUnitOpeningChest
    ____exports.interruptOpening = ____03_FF0E_5B9D_7BB1_6838_5FC3.interruptOpening
    ____exports.interruptChestOpening = ____03_FF0E_5B9D_7BB1_6838_5FC3.interruptChestOpening
    ____exports.STES_EVENT_PREPARE = ____03_FF0E_5B9D_7BB1_6838_5FC3.STES_EVENT_PREPARE
    ____exports.STES_EVENT_OPENED = ____03_FF0E_5B9D_7BB1_6838_5FC3.STES_EVENT_OPENED
    ____exports.isInteractable = ____03_FF0E_5B9D_7BB1_6838_5FC3.isInteractable
    ____exports.getOpenTime = ____03_FF0E_5B9D_7BB1_6838_5FC3.getOpenTime
end
do
    local ____02_FF0E_4E8B_4EF6_6CE8_518C = require("系统.06．经济系统.00．宝箱系统.02．事件注册")
    ____exports.registerChestSystemHero = ____02_FF0E_4E8B_4EF6_6CE8_518C.registerChestSystemHero
    ____exports.initChestSystem = ____02_FF0E_4E8B_4EF6_6CE8_518C.initChestSystem
    ____exports.STES_EVENT_UNIT_TARGET_ORDER = ____02_FF0E_4E8B_4EF6_6CE8_518C.STES_EVENT_UNIT_TARGET_ORDER
end
do
    local ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E = require("系统.06．经济系统.00．宝箱系统.01．宝箱掉落配置")
    ____exports.executeChestDrop = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E.executeChestDrop
    ____exports.createDropItem = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E.createDropItem
    ____exports.dropItemsFromChest = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E.dropItemsFromChest
    ____exports.dropItemsByDestructable = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E.dropItemsByDestructable
end
return ____exports
