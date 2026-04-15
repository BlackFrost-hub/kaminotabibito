--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 系统启用开关，true启用，false禁用（默认禁用）
____exports.AI_SKILL_SYSTEM_ENABLED = false
--- AI检测周期（秒）
____exports.AI_CHECK_INTERVAL = 0.5
--- 单位死亡事件ID
____exports.AI_EVENT_ID_UNIT_DEATH = 52
--- 玩家数量
____exports.AI_PLAYER_COUNT = 16
--- 中立敌对玩家ID
____exports.AI_PLAYER_NEUTRAL_AGGRESSIVE = 12
--- 中立被动玩家ID
____exports.AI_PLAYER_NEUTRAL_PASSIVE = 15
--- 无目标技能（立即施放）
____exports.TARGET_TYPE_NONE = 0
--- 点目标技能
____exports.TARGET_TYPE_POINT = 1
--- 单位目标技能
____exports.TARGET_TYPE_UNIT = 2
--- 最低优先级
____exports.PRIORITY_LOWEST = 0
--- 低优先级
____exports.PRIORITY_LOW = 25
--- 普通优先级
____exports.PRIORITY_NORMAL = 50
--- 高优先级
____exports.PRIORITY_HIGH = 75
--- 最高优先级
____exports.PRIORITY_HIGHEST = 100
--- 控制技能优先级（最高）
____exports.PRIORITY_CONTROL = 100
--- 伤害技能优先级（高）
____exports.PRIORITY_DAMAGE = 75
--- 辅助技能优先级（普通）
____exports.PRIORITY_SUPPORT = 50
--- 治疗技能优先级（高）
____exports.PRIORITY_HEAL = 80
--- 默认施法距离（当无法从技能获取时）
____exports.DEFAULT_CAST_RANGE = 600
--- 默认魔法消耗检查阈值
____exports.DEFAULT_MANA_THRESHOLD = 0
--- 默认冷却时间（秒）
____exports.DEFAULT_COOLDOWN = 0
--- 通魔技能命令ID
-- 注意：这些值需要根据实际地图中的技能确认
-- 当前为占位值，后续需要根据实际情况修改
____exports.ORDER_ID_CHANNEL_MAGIC = 0
--- 通魔技能ID
-- 注意：需要根据实际地图中的技能确认
____exports.ABILITY_ID_CHANNEL_MAGIC = 0
return ____exports
