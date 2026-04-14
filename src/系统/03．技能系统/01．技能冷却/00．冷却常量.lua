--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 通用冷却缩减上限
-- 玩家的「冷却缩减」属性上限
-- 默认：0.33（33%）
-- 修改示例：改为0.40表示40%上限
-- 
-- 注意：可通过「冷却缩减加成」属性突破此上限
____exports.COOLDOWN_REDUCTION_CAP = 0.33
--- 技能独立冷却上限配置
-- 
-- key: 技能ID（字符串形式，如 'A0IM'）
-- value: 冷却上限
____exports.SKILL_COOLDOWN_CAPS = {A0IM = 0.25, A0IP = 0.2, A0DG = 0.33}
--- 完全排除的技能ID（不参与冷却缩减）
____exports.COOLDOWN_BLACKLIST = {
    "A0FW",
    "A01W",
    "A0IN",
    "A0IO",
    "A0J8",
    "A0K5",
    "A0JP",
    "A0J3",
    "A0K6",
    "A0KR",
    "0005"
}
--- 独立设置冷却的技能（在各自技能触发中处理）
____exports.INDEPENDENT_COOLDOWN_SKILLS = {"A0EA", "A0DB", "A0DG"}
return ____exports
