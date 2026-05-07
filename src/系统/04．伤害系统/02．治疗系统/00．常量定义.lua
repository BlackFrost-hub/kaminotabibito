--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 治疗系统总开关
-- true: 启用，false: 禁用（doHeal直接返回0）
____exports.HEAL_SYSTEM_ENABLED = true
--- STES 事件名称（必须与JASS端一致）
____exports.HEAL_EVENTS = {REQUEST = "治疗事件", HEAL = "任意单位被治疗", SHOW_DAMAGE = "数值显示"}
--- STES「治疗事件」入口参数键名
____exports.HEAL_REQUEST_KEYS = {
    AMOUNT = "HealAmount",
    TARGET = "HealTarget",
    SOURCE = "HealSource",
    SOURCE_PLAYER = "HealSourcePlayer",
    EFFECT = "HealEffect"
}
--- STES「任意单位被治疗」结果事件参数键名
____exports.HEAL_RESULT_KEYS = {AMOUNT = "HealAmount", TARGET = "HealUnit", SOURCE = "HealSource"}
--- STES「数值显示」事件参数键名
____exports.HEAL_SHOW_KEYS = {
    AMOUNT = "Real",
    TARGET = "Unit",
    RED = "red",
    GREEN = "green",
    BLUE = "blue"
}
--- 治疗统计与旧 JASS 对齐用到的键名
____exports.HEAL_STATS_KEYS = {
    PLAYER_TOTAL_HEAL = "治疗量",
    PLAYER_GROUP_TABLE = "玩家",
    PLAYER_GROUP_FORCE = "玩家组",
    BOSS_BATTLE_TABLE = "Boss战",
    BOSS_BATTLE_UNIT = "单位"
}
--- 默认治疗特效路径
____exports.DEFAULT_HEAL_EFFECT_PATH = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl"
--- 治疗漂浮文字颜色 RGB
____exports.HEAL_TEXT_COLOR = {red = 20, green = 100, blue = 20}
--- 治疗率属性名（治疗别人时生效，如0.2=+20%）
____exports.ATTR_HEAL_RATE = "治疗率"
--- 受到治疗率属性名（被治疗时生效，如0.1=+10%）
____exports.ATTR_RECEIVED_HEAL_RATE = "受到的治疗率"
return ____exports
