--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["影骨莫特斯单位技能配置"] = {
    ["单位ID"] = "N01Y",
    ["单位名称"] = "影骨·莫特斯",
    ["Boss单位ID"] = "N01Y",
    ["技能壳"] = {
        ["阴影穿梭"] = "AN00",
        ["骸骨召唤"] = "AN01",
        ["暗影禁锢"] = "AT06",
        ["幽影爆发"] = "AN02",
        ["盗贼的遗产"] = "AN03"
    },
    ["主动技能提示"] = {
        {["技能ID"] = "AN00", ["提示"] = "阴影穿梭", ["扩展提示"] = "短暂隐入阴影后瞬移到随机玩家附近，并强化下一次背刺。"},
        {["技能ID"] = "AN01", ["提示"] = "骸骨召唤", ["扩展提示"] = "从地面连续召唤骷髅盗贼，死亡后会重组为骸骨战士。"},
        {["技能ID"] = "AT06", ["提示"] = "暗影禁锢", ["扩展提示"] = "在目标脚下生成暗影法阵，延迟后禁锢范围内玩家。"},
        {["技能ID"] = "AN02", ["提示"] = "幽影爆发", ["扩展提示"] = "大幅降低玩家视野并进入幽灵形态，召唤大量亡灵仆从。"},
        {["技能ID"] = "AN03", ["提示"] = "盗贼的遗产", ["扩展提示"] = "在场地生成可开启宝箱，开启后莫特斯获得攻击增益。"}
    },
    ["广播持续时间Ms"] = 4200,
    ["配音裁断距离"] = 4000,
    ["配音生成配置"] = {
        ["显示台词字段"] = "台词",
        ["配音台词字段"] = "配音台词",
        ["声线名称"] = "Gork - Terrifying & Dark Creature",
        ["声线ID"] = "PRfCKe8kdrG3nuXOAnoH",
        ["模型ID"] = "eleven_v3",
        ["语言"] = "en",
        ["整体提示词"] = "A cunning undead desert bandit chief, reduced to bone but still ruling a vicious gang of skeletal thieves. Dry hollow resonance, sly criminal charm, predatory amusement, greed, and sudden backstabbing menace. Keep every line intelligible and purposeful, as if giving orders to a practiced crew. He is not a giant demon, not a noble vampire, not a comic goblin, and not a mindless skeleton.",
        ["说明"] = "影骨莫特斯使用 Gork 表现骸骨亡灵质感，同时通过较高稳定度和清晰短句保留邪恶盗贼首领的可听懂台词。人格重点是贪婪、背刺、团伙号令和阴影债务；不要把 Creature Vocal 怪叫当成正式 Voice。"
    },
    ["台词"] = {
        ["开场"] = {"每一枚金币都会留下踪迹……而每一条踪迹，最后都会通向我的手中。"},
        ["阴影穿梭"] = {"盯紧你面前的影子……我会从你的背后出现。"},
        ["骸骨召唤"] = {"都给我爬起来，懒骨头们。偷走他们的金币、胆量和最后一口气。"},
        ["暗影禁锢"] = {"别挣扎了。你的影子，已经被我钉在地上。"},
        ["幽影爆发"] = {"黑暗降临。我的伙计们，在无人看见的地方最擅长办事。"},
        ["盗贼的遗产"] = {"盗贼的遗产就在那里。打开它……然后付出代价。"},
        ["死亡"] = {"呵……金币归你们。欠下的债，影子迟早会来收。"}
    },
    ["配音台词"] = {
        ["开场"] = {"[dry sinister amusement] Every coin leaves a trail... [possessive menace] and every trail ends in my hands."},
        ["阴影穿梭"] = {"[taunting whisper] Keep your eyes on the shadow before you... [backstabbing menace] I will be behind you."},
        ["骸骨召唤"] = {"[rasping gang command] Up, you lazy bones! [vicious delight] Steal their gold, their courage, and their final breath!"},
        ["暗影禁锢"] = {"[coldly amused] Do not struggle. [cruel certainty] I have nailed your shadow to the ground."},
        ["幽影爆发"] = {"[sinister command] Let darkness fall. [predatory amusement] My crew does its best work where no one can see."},
        ["盗贼的遗产"] = {"[tempting mockery] A thief's inheritance lies before you. Open it... [dark warning] and pay the price."},
        ["死亡"] = {"[broken chuckle] Keep the gold... [fading threat] the shadows will collect the debt."}
    },
    ["配音资源"] = {
        ["开场"] = {"Sound\\Boss\\ShadowboneMortes\\Voice\\shadowbone_mortes_opening_every_coin_trail_gork_01_v3.mp3"},
        ["阴影穿梭"] = {"Sound\\Boss\\ShadowboneMortes\\Voice\\shadowbone_mortes_shadow_slip_behind_you_gork_01_v3.mp3"},
        ["骸骨召唤"] = {"Sound\\Boss\\ShadowboneMortes\\Voice\\shadowbone_mortes_skeletal_summon_steal_all_gork_01_v3.mp3"},
        ["暗影禁锢"] = {"Sound\\Boss\\ShadowboneMortes\\Voice\\shadowbone_mortes_shadow_bind_nailed_gork_01_v3.mp3"},
        ["幽影爆发"] = {"Sound\\Boss\\ShadowboneMortes\\Voice\\shadowbone_mortes_phantom_burst_crew_in_dark_gork_01_v3.mp3"},
        ["盗贼的遗产"] = {"Sound\\Boss\\ShadowboneMortes\\Voice\\shadowbone_mortes_legacy_open_pay_price_gork_01_v3.mp3"},
        ["死亡"] = {"Sound\\Boss\\ShadowboneMortes\\Voice\\shadowbone_mortes_defeat_shadows_collect_debt_gork_01_v3.mp3"}
    }
}
return ____exports
