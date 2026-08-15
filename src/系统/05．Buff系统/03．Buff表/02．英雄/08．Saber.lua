--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.SaberBuffID = {
    ["风王硬直"] = "SBR1",
    ["风王减速"] = "SBR2",
    ["风王冲击硬直"] = "SBR3",
    ["魔力放出"] = "SBR4",
    ["阿瓦隆"] = "SBR5"
}
____exports["SaberBuff表"] = {
    [____exports.SaberBuffID["风王硬直"]] = {
        buffID = ____exports.SaberBuffID["风王硬直"],
        buffName = "风王硬直",
        icon = "BuffIcon\\Hero\\Saber\\saber_wind_control.blp",
        effect = "",
        type = "Debuff:control:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 75,
        canPurge = false,
        tooltip = "被风王结界的斩击命中，短暂无法行动。"
    },
    [____exports.SaberBuffID["风王减速"]] = {
        buffID = ____exports.SaberBuffID["风王减速"],
        buffName = "风王减速",
        icon = "BuffIcon\\Hero\\Saber\\saber_wind_slow.blp",
        effect = "",
        type = "Debuff:magic:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 70,
        canPurge = true,
        ["data属性名"] = "移动速度",
        tooltip = "被风王铁锤的龙卷风席卷，移动速度降低99%。"
    },
    [____exports.SaberBuffID["风王冲击硬直"]] = {
        buffID = ____exports.SaberBuffID["风王冲击硬直"],
        buffName = "风王冲击硬直",
        icon = "BuffIcon\\Hero\\Saber\\saber_impact_stun.blp",
        effect = "",
        type = "Debuff:control:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 75,
        canPurge = false,
        tooltip = "被魔力放出强化的风王冲击命中，硬直且无法闪避。"
    },
    [____exports.SaberBuffID["魔力放出"]] = {
        buffID = ____exports.SaberBuffID["魔力放出"],
        buffName = "魔力放出",
        icon = "BuffIcon\\Hero\\Saber\\saber_mana_release.blp",
        effect = "",
        type = "Buff:attack:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 60,
        canPurge = true,
        ["data属性名"] = "攻击力",
        tooltip = "魔力放出：攻击力提升25%，普通攻击附带25%魔法伤害，风王铁锤获得强化。"
    },
    [____exports.SaberBuffID["阿瓦隆"]] = {
        buffID = ____exports.SaberBuffID["阿瓦隆"],
        buffName = "遥远的理想乡",
        icon = "BuffIcon\\Hero\\Saber\\saber_avalon.blp",
        effect = "",
        type = "Buff:defense:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 0,
        priority = 90,
        canPurge = false,
        tooltip = "阿瓦隆的守护：持续恢复生命与魔法，免疫伤害，誓约胜利之剑威力变化。"
    }
}
____exports.default = ____exports["SaberBuff表"]
return ____exports
