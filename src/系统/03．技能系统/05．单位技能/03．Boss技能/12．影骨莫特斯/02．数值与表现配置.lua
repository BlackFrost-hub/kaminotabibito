--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["影骨莫特斯数值与表现配置"] = {
    ["阶段阈值"] = {["P2生命比例"] = 0.7, ["P3生命比例"] = 0.4},
    ["阴影穿梭"] = {
        ["间隔秒"] = 8,
        ["消失秒"] = 1,
        ["无敌秒"] = 0.5,
        ["出现距离"] = 300,
        ["背刺角度"] = 90,
        ["背刺伤害倍率"] = 2.5,
        ["正面减伤比例"] = 0.5
    },
    ["骸骨召唤"] = {
        ["冷却秒"] = 20,
        ["最少召唤数"] = 2,
        ["最多召唤数"] = 4,
        ["重组延迟秒"] = 3,
        ["骸骨战士生命倍率"] = 1.5,
        ["骷髅盗贼单位类型"] = "nsog",
        ["骷髅射手单位类型"] = "nska",
        ["骸骨战士单位类型"] = "nsoc",
        ["召唤偏移半径"] = 160,
        ["骷髅持续秒"] = 18,
        ["骸骨战士持续秒"] = 24,
        ["骷髅生命值"] = 2400,
        ["骸骨战士生命值"] = 3600,
        ["骷髅攻击力"] = 180,
        ["符咒持续秒"] = 18,
        ["符咒拾取半径"] = 140,
        ["偷金币固定值"] = 100,
        ["偷金币当前比例"] = 0.02,
        ["贫血惩罚Boss攻击力比例"] = 1.2,
        ["贫血惩罚目标最大生命比例"] = 0.04
    },
    ["暗影禁锢"] = {
        ["触发间隔最小秒"] = 8,
        ["触发间隔最大秒"] = 16,
        ["目标搜索半径"] = 2500,
        ["预警秒"] = 0.9,
        ["半径"] = 320,
        ["禁锢秒"] = 4,
        ["摧毁后剩余秒"] = 1,
        ["法阵单位类型"] = "e08P",
        ["法阵生命值"] = 1800,
        ["法阵缩放"] = 1.15
    },
    ["幽影爆发"] = {
        ["冷却秒"] = 40,
        ["持续秒"] = 20,
        ["物理承伤降低"] = 0.4,
        ["魔法承伤提高"] = 0.4,
        ["视野降低"] = 1600,
        ["召唤间隔秒"] = 0.3,
        ["召唤持续秒"] = 2.4,
        ["召唤中心X"] = 28040.6,
        ["召唤中心Y"] = -22451.2,
        ["召唤半径"] = 700,
        ["结束召唤物损血比例"] = 0.9
    },
    ["盗贼的遗产"] = {
        ["冷却秒"] = 40,
        ["宝箱数量"] = 4,
        ["开启引导秒"] = 3,
        ["每个宝箱Boss攻击提高"] = 0.03,
        ["宝箱可破坏物ID"] = "B00Z",
        ["宝箱点"] = {{X = 27458.8, Y = -21999.7, ["朝向"] = 325}, {X = 27438.5, Y = -22829, ["朝向"] = 45}, {X = 28497.1, Y = -22002, ["朝向"] = 225}, {X = 28374.8, Y = -22860.5, ["朝向"] = 135}}
    }
}
____exports["影骨莫特斯音效配置"] = {
    ["默认裁断距离"] = 1800,
    ["怪物拟声"] = {
        ["标识"] = "ShadowboneMortesCreature",
        ["音效路径列表"] = {"Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbones_rogue_eerie_creature_call_01.mp3", "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbones_rogue_eerie_creature_call_02.mp3", "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbones_rogue_eerie_creature_call_03.mp3"},
        ["冷却Ms"] = 8000,
        ["关键机制触发概率百分比"] = 35,
        ["爆发触发概率百分比"] = 55
    },
    ["阴影穿梭"] = {["消失残影"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_shadow_slip_vanish_01.mp3", ["落点闪现"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_shadow_slip_reappear_03_novocal.mp3", ["背刺命中"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_backstab_hit_01.mp3"},
    ["骸骨召唤"] = {["骷髅盗贼出生"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_skeletal_rogue_summon_03_eerie_overlap.mp3", ["骸骨战士重组列表"] = {"Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_skeleton_reform_warrior_07_overlap_from0_layer_01_64k.mp3", "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_skeleton_reform_warrior_07_overlap_from0_layer_02_64k.mp3", "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_skeleton_reform_warrior_07_overlap_from0_layer_04_64k.mp3"}},
    ["暗影禁锢"] = {["预警"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_shadow_bind_warning_01.mp3", ["法阵生效"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_shadow_bind_lock_03_rune_hum.mp3"},
    ["幽影爆发"] = {["领域展开"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_phantom_burst_field_open_01.mp3", ["召唤潮开始"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_phantom_minion_wave_spawn_07_war3_refs_short155.mp3"},
    ["盗贼的遗产"] = {["宝箱出现"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_legacy_chest_08_land05_appear02.mp3", ["增益回流"] = "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_legacy_chest_open_power_gain_06_war3_soft.mp3"}
}
____exports["影骨莫特斯表现配置"] = {
    ["阴影穿梭残影"] = "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx",
    ["阴影穿梭落点"] = "Common\\Effect\\Element\\Dark\\dark001.mdx",
    ["背刺命中"] = "Common\\Effect\\Form\\ClawMark\\reapers_claws_purple.mdx",
    ["骸骨召唤预警"] = "Common\\Effect\\Form\\MagicCircle\\HellRune2.mdx",
    ["骷髅出生"] = "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl",
    ["骸骨战士重组"] = "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl",
    ["骸骨符咒掉落"] = "Objects\\InventoryItems\\runicobject\\runicobject.mdl",
    ["骸骨符咒拾取"] = "Common\\Effect\\Form\\MagicCircle\\VampireSeal.mdx",
    ["暗影禁锢法阵"] = "Common\\Effect\\Form\\MagicCircle\\VampireSeal.mdx",
    ["暗影禁锢预警"] = "resource\\models\\Tip\\skillTip\\mr.war3_ring.mdx",
    ["暗影禁锢摧毁"] = "Common\\Effect\\Element\\Dark\\shadowslam(normal size).mdx",
    ["幽影爆发开场"] = "Common\\Effect\\Form\\Explosion\\ShadowBurstDome.mdx",
    ["幽灵形态持续"] = "Common\\Effect\\Element\\Dark\\darkharvest.mdx",
    ["暗影强化召唤物"] = "Common\\Effect\\Form\\Aura\\LightningAura.mdx",
    ["盗贼遗产宝箱"] = "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl",
    ["宝箱出现"] = "Common\\Effect\\Element\\Dark\\dark001.mdx"
}
return ____exports
