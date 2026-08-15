--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["黑崎一护BuffID"] = {
    ["卍解"] = "ICH1",
    ["灵压爆发眩晕"] = "ICH2",
    ["瞬步斩眩晕"] = "ICH3",
    ["地蹦裂击减速"] = "ICH4",
    ["地蹦裂击防御"] = "ICH5"
}
____exports["黑崎一护Buff表"] = {
    [____exports["黑崎一护BuffID"]["卍解"]] = {
        buffID = ____exports["黑崎一护BuffID"]["卍解"],
        buffName = "天锁斩月·卍解",
        icon = "BuffIcon\\Hero\\KurosakiIchigo\\ichigo_bankai.blp",
        effect = "",
        type = "Buff:attack:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 0,
        priority = 90,
        canPurge = false,
        tooltip = "卍解状态：月牙天冲强化（350%、无视100%护甲），普攻缩减月牙天冲冷却，移动速度666，A键可触发黑流牙突。"
    },
    [____exports["黑崎一护BuffID"]["灵压爆发眩晕"]] = {
        buffID = ____exports["黑崎一护BuffID"]["灵压爆发眩晕"],
        buffName = "灵压震慑",
        icon = "BuffIcon\\Hero\\KurosakiIchigo\\ichigo_spirit_repulse.blp",
        effect = "",
        type = "Debuff:control:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 75,
        canPurge = false,
        tooltip = "被灵压爆发震慑，眩晕无法行动。"
    },
    [____exports["黑崎一护BuffID"]["瞬步斩眩晕"]] = {
        buffID = ____exports["黑崎一护BuffID"]["瞬步斩眩晕"],
        buffName = "瞬步斩眩晕",
        icon = "BuffIcon\\Hero\\KurosakiIchigo\\ichigo_flash_end_stun.blp",
        effect = "",
        type = "Debuff:control:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 75,
        canPurge = false,
        tooltip = "被瞬步斩命中，短暂眩晕。"
    },
    [____exports["黑崎一护BuffID"]["地蹦裂击减速"]] = {
        buffID = ____exports["黑崎一护BuffID"]["地蹦裂击减速"],
        buffName = "地蹦裂压",
        icon = "BuffIcon\\Hero\\KurosakiIchigo\\ichigo_slow_field.blp",
        effect = "",
        type = "Debuff:magic:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 70,
        canPurge = true,
        tooltip = "被地蹦裂击的灵压笼罩，移动速度与攻击速度降低90%。"
    },
    [____exports["黑崎一护BuffID"]["地蹦裂击防御"]] = {
        buffID = ____exports["黑崎一护BuffID"]["地蹦裂击防御"],
        buffName = "地蹦防御",
        icon = "BuffIcon\\Hero\\KurosakiIchigo\\ichigo_damage_guard.blp",
        effect = "",
        type = "Buff:defense:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 0,
        priority = 60,
        canPurge = false,
        tooltip = "地蹦裂击持续期间，受到的伤害减少50%。"
    }
}
____exports.default = ____exports["黑崎一护Buff表"]
return ____exports
