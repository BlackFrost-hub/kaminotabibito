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
        {["技能ID"] = "AN00", ["提示"] = "阴影穿梭", ["扩展提示"] = "约1秒后在随机玩家附近300码现身，强化下一次纯普通攻击为2.5倍背刺；玩家正面朝向莫特斯时背刺最终伤害降低50%。（面向Boss并及时走位。）"},
        {["技能ID"] = "AN01", ["提示"] = "骸骨召唤", ["扩展提示"] = "3秒内分3批共召唤4个骷髅；每次普攻偷取100金币+当前金币2%，金币低于目标最大生命值时追加莫特斯攻击力120%+目标最大生命值4%的伤害。P1/P2全灭后3秒重组1个骸骨战士，P3不重组。（优先击杀召唤物。）"},
        {["技能ID"] = "AT06", ["提示"] = "暗影禁锢", ["扩展提示"] = "0.9秒预警后在目标脚下生成半径320码法阵，禁锢4秒；法阵可被攻击，摧毁后剩余禁锢仅1秒。（离开预警圈，队友集火法阵。）"},
        {["技能ID"] = "AN02", ["提示"] = "幽影爆发", ["扩展提示"] = "P1/P2冷却40秒、P3冷却26秒；持续20秒，玩家视野减少1600，莫特斯物理承伤降至60%、魔法承伤提高至140%；每0.3秒生成1个召唤物，2.4秒内共8个，召唤物持续25秒，结束时存活召唤物损失90%当前生命且不致死。（优先处理召唤物。）"},
        {["技能ID"] = "AN03", ["提示"] = "盗贼的遗产", ["扩展提示"] = "每0.5秒在4个固定点生成1个宝箱，共4个；开启引导3秒。每开1个按开启前莫特斯当前攻击力的3%追加固定攻击力，永久最多4层；10%概率触发陷阱，开启者生命保留30%并眩晕1.5秒。（开箱时注意Boss集火。）"}
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
        ["开场"] = {"每一枚金币都会留下踪迹……而每一条踪迹，最后都会通向我的手中。（准备面对背刺、骸骨召唤与宝箱陷阱！）"},
        ["阴影穿梭"] = {"盯紧你面前的影子……我会从你的背后出现。（约1秒后在随机玩家附近300码现身，面向莫特斯可将背刺最终伤害减半！）"},
        ["骸骨召唤"] = {"都给我爬起来，懒骨头们。（3秒内分3批召唤4个骷髅；优先击杀，P1/P2全灭后3秒还会重组，P3不会重组！）"},
        ["暗影禁锢"] = {"别挣扎了。你的影子，已经被我钉在地上。（0.9秒后半径320法阵禁锢4秒；离开预警圈并集火法阵！）"},
        ["幽影爆发"] = {"黑暗降临。我的伙计们，在无人看见的地方最擅长办事。（幽影持续20秒，视野减少1600；物理只承受60%、魔法承受140%，优先处理召唤物！）"},
        ["盗贼的遗产"] = {"盗贼的遗产就在那里。打开它……然后付出代价。（每0.5秒出现1个宝箱，共4个，开启需3秒；有10%概率触发陷阱，注意走位！）"},
        ["死亡"] = {"呵……金币归你们。欠下的债，影子迟早会来收。（战斗结束，莫特斯专属状态与视野压制已解除。）"}
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
