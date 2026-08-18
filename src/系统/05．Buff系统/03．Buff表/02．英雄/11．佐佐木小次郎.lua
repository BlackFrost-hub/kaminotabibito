--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 佐佐木小次郎 - 英雄 Buff 表
-- 图标：imports\BuffIcon\Hero\Sasaki\（已生成）
____exports["佐佐木小次郎BuffID"] = {["燕返守卫"] = "ZZM1", ["无心视野"] = "ZZM2", ["止水"] = "ZZM3", ["宗和的心得"] = "ZZM4"}
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
}, [____exports["佐佐木小次郎BuffID"]["止水"]] = {
    buffID = ____exports["佐佐木小次郎BuffID"]["止水"],
    buffName = "止水",
    icon = "war3mapImported\\Sasaki-E.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 90,
    canPurge = false,
    tooltip = "止水引导期间受到的伤害减少 50%；完整引导后恢复生命并获得攻击提升。"
}, [____exports["佐佐木小次郎BuffID"]["宗和的心得"]] = {
    buffID = ____exports["佐佐木小次郎BuffID"]["宗和的心得"],
    buffName = "宗和的心得",
    icon = "war3mapImported\\Sasaki-E.blp",
    effect = "",
    type = "Buff:physical:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 80,
    canPurge = false,
    tooltip = "完整施展止水后的 12 秒内，攻击力提高 14%。"
}}
____exports.default = ____exports["佐佐木小次郎Buff表"]
return ____exports
