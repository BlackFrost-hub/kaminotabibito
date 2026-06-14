local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local ____exports = {}
--- 宝箱系统 - 常量定义
local function stringToFourCC(s)
    local a = #s > 0 and (string.byte(s, 1) or 0 / 0) or 0
    local b = #s > 1 and (string.byte(s, 2) or 0 / 0) or 0
    local c = #s > 2 and (string.byte(s, 3) or 0 / 0) or 0
    local d = #s > 3 and (string.byte(s, 4) or 0 / 0) or 0
    return a * 16777216 + b * 65536 + c * 256 + d
end
____exports["宝箱系统开关"] = true
____exports.CHEST_TYPES = {{
    destructableType = "LTbr",
    openTime = 3,
    name = "盗贼宝箱",
    picks = 1,
    dropMode = {type = "score", range = {min = 100, max = 500}},
    ["主人配置"] = {["单位类型"] = "hfoo", ["准备开启搜索半径"] = 3000, ["开启完成搜索半径"] = 2500},
    ["高级掉落"] = {["随机段"] = {
        {["最小值"] = 1, ["最大值"] = 30, ["动作"] = {{type = "创建物品", ["物品"] = "火把"}, {type = "创建物品二选一", ["物品1"] = "盗贼神符（护甲）", ["物品2"] = "盗贼神符（魔抗）"}}},
        {["最小值"] = 31, ["最大值"] = 55, ["动作"] = {{type = "创建物品", ["物品"] = "金币"}}},
        {["最小值"] = 56, ["最大值"] = 80, ["动作"] = {{type = "按装备等级随机创建", ["候选等级池"] = {
            {["池名"] = "D+级物品池", ["权重"] = 330, ["广播等级文本"] = "D+级"},
            {["池名"] = "D++级物品池", ["权重"] = 220, ["广播等级文本"] = "D++级"},
            {["池名"] = "C-级物品池", ["权重"] = 105, ["广播等级文本"] = "C-级"},
            {["池名"] = "C级物品池", ["权重"] = 88, ["广播等级文本"] = "C级"},
            {["池名"] = "C+级物品池", ["权重"] = 87, ["广播等级文本"] = "C+级"},
            {["池名"] = "C++级物品池", ["权重"] = 70, ["广播等级文本"] = "C++级"},
            {["池名"] = "B-级物品", ["权重"] = 100, ["广播等级文本"] = "B-级"}
        }}, {type = "发送广播提示", ["文本前缀"] = "通过盗贼宝箱开到了"}}},
        {["最小值"] = 81, ["最大值"] = 90, ["动作"] = {{type = "创建物品", ["物品"] = "帝国货币"}}},
        {["最小值"] = 91, ["最大值"] = 100, ["动作"] = {{type = "对开启者施加效果", ["保留当前生命比例"] = 0.3, BuffID = 0, ["Buff持续时间"] = 1.5}}}
    }}
}, {
    destructableType = "B003",
    openTime = 3,
    name = "普通宝箱",
    picks = 1,
    dropMode = {type = "score", range = {min = 100, max = 500}}
}, {destructableType = "BR01", openTime = 3, name = "首领奖励宝箱"}, {
    destructableType = "LTbx",
    openTime = 3,
    name = "木桶",
    picks = 1,
    dropMode = {type = "pool", items = "初心戒指:1.5;初始生命药水:1;初始魔法药水:2", always = "精灵铁剑"}
}}
local _chestTypeIds = __TS__New(Set)
for ____, config in ipairs(____exports.CHEST_TYPES) do
    _chestTypeIds:add(stringToFourCC(config.destructableType))
end
local _chestConfigMap = __TS__New(Map)
for ____, config in ipairs(____exports.CHEST_TYPES) do
    _chestConfigMap:set(
        stringToFourCC(config.destructableType),
        config
    )
end
function ____exports.isChestType(destructableTypeId)
    return _chestTypeIds:has(destructableTypeId)
end
function ____exports.getChestConfig(destructableTypeId)
    return _chestConfigMap:get(destructableTypeId)
end
function ____exports.getChestConfigByString(destructableType)
    return _chestConfigMap:get(stringToFourCC(destructableType))
end
____exports.DEFAULT_OPEN_TIME = 3
____exports.INTERACT_RANGE = 150
____exports.UPDATE_INTERVAL = 0.05
____exports.PROGRESS_BAR_SCALE = 3
____exports.PROGRESS_BAR_HEIGHT_OFFSET = 233
____exports.YDLOCAL_VAR_OPENER = "开启者"
____exports.YDLOCAL_VAR_CHEST = "被开启的宝箱"
____exports.YDLOCAL_VAR_PRE_OPENER = "预开启者"
____exports.YDLOCAL_VAR_PRE_CHEST = "被预开启的宝箱"
____exports.TEXT_OPENING = function(name) return ("正在开启" .. name) .. "..." end
____exports.TEXT_SUCCESS = function(name) return name .. "已开启！" end
____exports.TEXT_INTERRUPTED = function(name) return name .. "开启中断" end
return ____exports
