--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 佐佐木小次郎 - 英雄 Buff 表
-- 图标：imports\BuffIcon\Hero\Sasaki\（已生成）
____exports["佐佐木小次郎BuffID"] = {["燕返守卫"] = "ZZM1", ["无心视野"] = "ZZM2"}
____exports["佐佐木小次郎Buff表"] = {[____exports["佐佐木小次郎BuffID"]["燕返守卫"]] = {
    buffID = ____exports["佐佐木小次郎BuffID"]["燕返守卫"],
    buffName = "燕返守卫",
    icon = "BuffIcon\\Hero\\Sasaki\\sasaki_tsubame_guard.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 85,
    canPurge = false,
    tooltip = "燕返防御姿态：0.68 秒内受到伤害时触发燕返反击。"
}, [____exports["佐佐木小次郎BuffID"]["无心视野"]] = {
    buffID = ____exports["佐佐木小次郎BuffID"]["无心视野"],
    buffName = "无心视野",
    icon = "BuffIcon\\Hero\\Sasaki\\sasaki_heartless_sight.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 80,
    canPurge = false,
    tooltip = "瞬移后的 1 秒内，前斩将额外发射一道剑气。"
}}
____exports.default = ____exports["佐佐木小次郎Buff表"]
return ____exports
