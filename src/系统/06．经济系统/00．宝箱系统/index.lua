--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
require("系统.06．经济系统.00．宝箱系统.09．宝箱主人台词")
do
    local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
    ____exports.CHEST_TYPES = ____00_FF0E_5E38_91CF_5B9A_4E49.CHEST_TYPES
    ____exports.DEFAULT_OPEN_TIME = ____00_FF0E_5E38_91CF_5B9A_4E49.DEFAULT_OPEN_TIME
    ____exports.INTERACT_RANGE = ____00_FF0E_5E38_91CF_5B9A_4E49.INTERACT_RANGE
    ____exports.UPDATE_INTERVAL = ____00_FF0E_5E38_91CF_5B9A_4E49.UPDATE_INTERVAL
    ____exports.PROGRESS_BAR_SCALE = ____00_FF0E_5E38_91CF_5B9A_4E49.PROGRESS_BAR_SCALE
    ____exports.PROGRESS_BAR_HEIGHT_OFFSET = ____00_FF0E_5E38_91CF_5B9A_4E49.PROGRESS_BAR_HEIGHT_OFFSET
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
    ____exports.isInteractable = ____03_FF0E_5B9D_7BB1_6838_5FC3.isInteractable
    ____exports.getOpenTime = ____03_FF0E_5B9D_7BB1_6838_5FC3.getOpenTime
end
do
    local ____04_FF0E_51C6_5907_5F00_542F_56DE_8C03 = require("系统.06．经济系统.00．宝箱系统.04．准备开启回调")
    ____exports["注册宝箱准备开启回调"] = ____04_FF0E_51C6_5907_5F00_542F_56DE_8C03["注册宝箱准备开启回调"]
    ____exports["触发宝箱准备开启回调"] = ____04_FF0E_51C6_5907_5F00_542F_56DE_8C03["触发宝箱准备开启回调"]
end
do
    local ____05_FF0E_5F00_542F_4E2D_56DE_8C03 = require("系统.06．经济系统.00．宝箱系统.05．开启中回调")
    ____exports["注册宝箱开启中回调"] = ____05_FF0E_5F00_542F_4E2D_56DE_8C03["注册宝箱开启中回调"]
    ____exports["触发宝箱开启中回调"] = ____05_FF0E_5F00_542F_4E2D_56DE_8C03["触发宝箱开启中回调"]
end
do
    local ____06_FF0E_5F00_542F_5B8C_6210_56DE_8C03 = require("系统.06．经济系统.00．宝箱系统.06．开启完成回调")
    ____exports["注册宝箱开启完成回调"] = ____06_FF0E_5F00_542F_5B8C_6210_56DE_8C03["注册宝箱开启完成回调"]
    ____exports["触发宝箱开启完成回调"] = ____06_FF0E_5F00_542F_5B8C_6210_56DE_8C03["触发宝箱开启完成回调"]
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
    ____exports["执行宝箱掉落"] = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E["执行宝箱掉落"]
    ____exports.createDropItem = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E.createDropItem
    ____exports["创建掉落物品"] = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E["创建掉落物品"]
    ____exports.dropItemsFromChest = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E.dropItemsFromChest
    ____exports["宝箱位置掉落"] = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E["宝箱位置掉落"]
    ____exports.dropItemsByDestructable = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E.dropItemsByDestructable
    ____exports["按可破坏物掉落"] = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E["按可破坏物掉落"]
    ____exports.dropItemsByChestConfig = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E.dropItemsByChestConfig
    ____exports["按宝箱配置掉落"] = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E["按宝箱配置掉落"]
    ____exports.dropItemsFromChestConfig = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E.dropItemsFromChestConfig
    ____exports["宝箱配置掉落"] = ____01_FF0E_5B9D_7BB1_6389_843D_914D_7F6E["宝箱配置掉落"]
end
do
    local ____10_FF0E_9996_9886_5956_52B1_5B9D_7BB1 = require("系统.06．经济系统.00．宝箱系统.10．首领奖励宝箱")
    ____exports["通用首领奖励宝箱可破坏物ID"] = ____10_FF0E_9996_9886_5956_52B1_5B9D_7BB1["通用首领奖励宝箱可破坏物ID"]
    ____exports["通用首领奖励宝箱生命值"] = ____10_FF0E_9996_9886_5956_52B1_5B9D_7BB1["通用首领奖励宝箱生命值"]
    ____exports["绑定宝箱首领奖励池"] = ____10_FF0E_9996_9886_5956_52B1_5B9D_7BB1["绑定宝箱首领奖励池"]
    ____exports["创建首领奖励宝箱"] = ____10_FF0E_9996_9886_5956_52B1_5B9D_7BB1["创建首领奖励宝箱"]
    ____exports["触发宝箱首领奖励"] = ____10_FF0E_9996_9886_5956_52B1_5B9D_7BB1["触发宝箱首领奖励"]
end
return ____exports
