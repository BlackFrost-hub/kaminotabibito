--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
--- 无视魔抗的单位类型 ID 列表
-- 这些单位类型的攻击将无视目标的魔抗
____exports.IGNORE_MAGIC_RESIST_UNIT_TYPE_IDS = {stringToFourCC("E000")}
--- 无视魔抗的物品 ID 列表
-- 拥有这些物品的单位攻击时将无视目标魔抗
____exports.IGNORE_MAGIC_RESIST_ITEM_TYPE_IDS = {stringToFourCC("I06Q")}
--- 普攻吸血特殊单位类型 ID 列表
-- 这些单位在魔法攻击时也能触发普攻吸血
____exports.NORMAL_ATTACK_LIFESTEAL_SPECIAL_UNIT_IDS = {stringToFourCC("E000")}
return ____exports
