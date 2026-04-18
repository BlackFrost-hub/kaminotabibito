local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_0.stringToFourCC
--- 可交互目标类型列表（可扩展）
____exports.INTERACTABLE_TYPES = {{destructableType = "B00Z", openTime = 3, name = "宝箱"}}
--- 可交互目标类型ID集合（运行时生成，用于快速判断）
local _interactableTypeIds = __TS__New(Set)
for ____, config in ipairs(____exports.INTERACTABLE_TYPES) do
    _interactableTypeIds:add(stringToFourCC(nil, config.destructableType))
end
--- 可交互目标开启时间映射（类型ID -> 开启时间）
local _openTimeMap = __TS__New(Map)
for ____, config in ipairs(____exports.INTERACTABLE_TYPES) do
    _openTimeMap:set(
        stringToFourCC(nil, config.destructableType),
        config.openTime
    )
end
--- 可交互目标名称映射（类型ID -> 名称）
local _nameMap = __TS__New(Map)
for ____, config in ipairs(____exports.INTERACTABLE_TYPES) do
    _nameMap:set(
        stringToFourCC(nil, config.destructableType),
        config.name
    )
end
--- 检查可破坏物类型ID是否为可交互目标
function ____exports.isInteractableType(destructableTypeId)
    return _interactableTypeIds:has(destructableTypeId)
end
--- 获取可交互目标的开启时间
function ____exports.getInteractableOpenTime(destructableTypeId)
    return _openTimeMap:get(destructableTypeId) or ____exports.DEFAULT_OPEN_TIME
end
--- 获取可交互目标的名称
function ____exports.getInteractableName(destructableTypeId)
    return _nameMap:get(destructableTypeId) or "未知"
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
--- YDLocal变量名 - 开启者
____exports.YDLOCAL_VAR_OPENER = "开启者"
--- YDLocal变量名 - 被开启的宝箱
____exports.YDLOCAL_VAR_CHEST = "被开启的宝箱"
--- YDLocal变量名 - 预开启者
____exports.YDLOCAL_VAR_PRE_OPENER = "预开启者"
--- YDLocal变量名 - 被预开启的宝箱
____exports.YDLOCAL_VAR_PRE_CHEST = "被预开启的宝箱"
--- 文本提示
____exports.TEXT_OPENING = "开启宝箱中..."
____exports.TEXT_SUCCESS = "宝箱被打开了！"
____exports.TEXT_INTERRUPTED = "宝箱开启失败！"
return ____exports
