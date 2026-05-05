--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 百分比消耗阈值（超过此值视为非通魔面板技能）
____exports.PERCENT_COST_THRESHOLD = 0.9
--- 爱德华配置键。
-- 当前逻辑仍使用前半段显示名作为 YDUserData 缓存键，后半段用于统一格式预留。
____exports.EDWARD_UNIT_CONFIG_KEY = "爱德华|H00Q"
--- 特殊单位消耗处理配置表
-- key: 游戏中显示名|内部单位ID
____exports.SPECIAL_UNIT_COST_CONFIG = {}
return ____exports
