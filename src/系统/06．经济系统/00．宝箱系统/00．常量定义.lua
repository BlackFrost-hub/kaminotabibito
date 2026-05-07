local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_0.stringToFourCC
--- 宝箱系统开关（设为 false 可关闭整个宝箱系统）
____exports["宝箱系统开关"] = false
--- 宝箱类型配置表（在此添加所有宝箱类型）
____exports.CHEST_TYPES = {{
    destructableType = "B00Z",
    openTime = 3,
    name = "普通宝箱",
    picks = 1,
    dropMode = {type = "score", range = {min = 100, max = 500}}
}, {
    destructableType = "B003",
    openTime = 3,
    name = "普通宝箱",
    picks = 1,
    dropMode = {type = "score", range = {min = 100, max = 500}}
}}
--- 可破坏物类型ID集合（用于快速判断）
local _chestTypeIds = __TS__New(Set)
for ____, config in ipairs(____exports.CHEST_TYPES) do
    _chestTypeIds:add(stringToFourCC(nil, config.destructableType))
end
--- 可破坏物类型ID到配置的映射
local _chestConfigMap = __TS__New(Map)
for ____, config in ipairs(____exports.CHEST_TYPES) do
    _chestConfigMap:set(
        stringToFourCC(nil, config.destructableType),
        config
    )
end
--- 检查可破坏物类型ID是否为宝箱
function ____exports.isChestType(destructableTypeId)
    return _chestTypeIds:has(destructableTypeId)
end
--- 通过可破坏物类型ID获取宝箱配置
function ____exports.getChestConfig(destructableTypeId)
    return _chestConfigMap:get(destructableTypeId)
end
--- 通过可破坏物类型字符串获取宝箱配置
function ____exports.getChestConfigByString(destructableType)
    return _chestConfigMap:get(stringToFourCC(nil, destructableType))
end
--- 默认开启时间（秒）
____exports.DEFAULT_OPEN_TIME = 3
--- 检测范围（单位与目标的距离）
____exports.INTERACT_RANGE = 150
--- 计时器检测间隔（秒）
____exports.UPDATE_INTERVAL = 0.05
--- 进度条单位缩放
____exports.PROGRESS_BAR_SCALE = 3
--- 进度条飞行高度偏移
____exports.PROGRESS_BAR_HEIGHT_OFFSET = 233
--- STES事件名：玩家准备开启宝箱
____exports.EVENT_PLAYER_PREPARE_OPEN_CHEST = "玩家准备开启宝箱"
--- STES事件名：宝箱被开启
____exports.EVENT_CHEST_OPENED = "宝箱被开启"
--- YDLocal变量名：开启者
____exports.YDLOCAL_VAR_OPENER = "开启者"
--- YDLocal变量名：被开启的宝箱
____exports.YDLOCAL_VAR_CHEST = "被开启的宝箱"
--- YDLocal变量名：预开启者
____exports.YDLOCAL_VAR_PRE_OPENER = "预开启者"
--- YDLocal变量名：被预开启的宝箱
____exports.YDLOCAL_VAR_PRE_CHEST = "被预开启的宝箱"
--- 提示文字：正在开启
____exports.TEXT_OPENING = function(name) return ("正在开启" .. name) .. "..." end
--- 提示文字：开启成功
____exports.TEXT_SUCCESS = function(name) return name .. "已开启！" end
--- 提示文字：开启中断
____exports.TEXT_INTERRUPTED = function(name) return name .. "开启中断" end
return ____exports
