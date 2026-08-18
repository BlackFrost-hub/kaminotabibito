--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["十六夜咲夜BuffID"] = {
    ["个人空间时间缓速"] = "SKY1",
    ["完美空间时间停止"] = "SKY2",
    ["咲夜的世界"] = "SKY3",
    ["夜雾幻影目标封锁"] = "SKY4",
    ["夜雾幻影无敌免控"] = "SKY5",
    ["收缩世界目标封印"] = "SKY6",
    ["收缩世界吟唱"] = "SKY7",
    ["光速跃迁锁定"] = "SKY8",
    ["完美女仆反击窗口"] = "SKY9"
}
local function _____72B6_6001Buff(id, name, icon, tooltip, negative)
    if negative == nil then
        negative = false
    end
    return {
        buffID = id,
        buffName = name,
        icon = "BuffIcon\\Hero\\IzayoiSakuya\\" .. icon,
        effect = "",
        type = negative and "Debuff:magic:negative" or "Buff:magic:skill",
        interval = 0,
        maxStack = 1,
        stackRule = "highest",
        stackRefresh = true,
        dispelLevel = 3,
        priority = 80,
        canPurge = false,
        tooltip = tooltip
    }
end
____exports["十六夜咲夜Buff表"] = {
    [____exports["十六夜咲夜BuffID"]["个人空间时间缓速"]] = _____72B6_6001Buff(
        ____exports["十六夜咲夜BuffID"]["个人空间时间缓速"],
        "个人空间时间缓速",
        "private_square_slow.blp",
        "处于个人空间：时间流速、移动和攻击速度降低。",
        true
    ),
    [____exports["十六夜咲夜BuffID"]["完美空间时间停止"]] = _____72B6_6001Buff(
        ____exports["十六夜咲夜BuffID"]["完美空间时间停止"],
        "完美空间时间停止",
        "perfect_square_stop.blp",
        "处于完美空间：时间完全停止。",
        true
    ),
    [____exports["十六夜咲夜BuffID"]["咲夜的世界"]] = _____72B6_6001Buff(____exports["十六夜咲夜BuffID"]["咲夜的世界"], "咲夜的世界", "sakuya_world.blp", "完美空间展开中，部分符卡获得强化演出。"),
    [____exports["十六夜咲夜BuffID"]["夜雾幻影目标封锁"]] = _____72B6_6001Buff(
        ____exports["十六夜咲夜BuffID"]["夜雾幻影目标封锁"],
        "夜雾幻影目标封锁",
        "night_mist_target_seal.blp",
        "被夜雾幻影杀人鬼锁定，时间停止。",
        true
    ),
    [____exports["十六夜咲夜BuffID"]["夜雾幻影无敌免控"]] = _____72B6_6001Buff(____exports["十六夜咲夜BuffID"]["夜雾幻影无敌免控"], "夜雾幻影无敌免控", "night_mist_invulnerability.blp", "夜雾幻影杀人鬼演出期间无敌并免受控制。"),
    [____exports["十六夜咲夜BuffID"]["收缩世界目标封印"]] = _____72B6_6001Buff(
        ____exports["十六夜咲夜BuffID"]["收缩世界目标封印"],
        "收缩世界目标封印",
        "deflation_world_target_seal.blp",
        "生命与魔法被收缩世界封存在施法瞬间。",
        true
    ),
    [____exports["十六夜咲夜BuffID"]["收缩世界吟唱"]] = _____72B6_6001Buff(____exports["十六夜咲夜BuffID"]["收缩世界吟唱"], "收缩世界吟唱", "deflation_world_channel.blp", "正在吟唱收缩的世界。"),
    [____exports["十六夜咲夜BuffID"]["光速跃迁锁定"]] = _____72B6_6001Buff(
        ____exports["十六夜咲夜BuffID"]["光速跃迁锁定"],
        "光速跃迁锁定",
        "lightspeed_leap_lock.blp",
        "被光速跃迁飞刀环绕锁定。",
        true
    ),
    [____exports["十六夜咲夜BuffID"]["完美女仆反击窗口"]] = _____72B6_6001Buff(____exports["十六夜咲夜BuffID"]["完美女仆反击窗口"], "完美女仆反击窗口", "perfect_maid_counter.blp", "短时间内可反击远距离攻击。")
}
____exports.default = ____exports["十六夜咲夜Buff表"]
return ____exports
