--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 移速超过该值时挂上龙卷提示特效
____exports.MOVE_SPEED_THRESHOLD = 400
--- 龙卷提示模型（与地图资源路径一致）
____exports.TORNADO_EFFECT_MODEL = "Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl"
--- 绑定挂点
____exports.TORNADO_ATTACH_POINT = "origin"
--- 中心计时器 tick 为 10ms；每 N 次 tick 执行一轮同步（默认 5 => 0.05s）
____exports.EXEC_EVERY_TICKS = 5
--- YDUserData：玩家英雄单位组（与 JASS 初始化一致）
____exports.YD_TABLE_TYPE_PLAYER_HERO = "string"
____exports.YD_TABLE_KEY_PLAYER_HERO = "玩家英雄"
____exports.YD_ATTR_HERO_GROUP = "单位组"
____exports.YD_VALUE_TYPE_GROUP = "group"
return ____exports
