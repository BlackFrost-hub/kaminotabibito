--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 护盾类型
____exports.ShieldType = ShieldType or ({})
____exports.ShieldType.General = 0
____exports.ShieldType[____exports.ShieldType.General] = "General"
____exports.ShieldType.Physical = 1
____exports.ShieldType[____exports.ShieldType.Physical] = "Physical"
____exports.ShieldType.Magical = 2
____exports.ShieldType[____exports.ShieldType.Magical] = "Magical"
--- 类型优先级：专用护盾 > 通用护盾
____exports["类型优先级"] = {[____exports.ShieldType.Physical] = 100, [____exports.ShieldType.Magical] = 100, [____exports.ShieldType.General] = 50}
--- 默认抵挡优先级
____exports["默认抵挡优先级"] = 50
return ____exports
