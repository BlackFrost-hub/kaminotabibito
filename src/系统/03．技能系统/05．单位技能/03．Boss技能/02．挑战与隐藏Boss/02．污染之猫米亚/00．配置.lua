--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["米亚单位技能配置"] = {
    ["单位ID"] = "N00V",
    ["单位名"] = "污染之猫·腐化者米亚",
    ["Boss单位ID"] = "N00V",
    ["腐化爪击技能"] = "AT14",
    ["污水喷吐技能"] = "AN00",
    ["主动技能提示"] = {{["技能ID"] = "AT14", ["提示"] = "腐化爪击"}, {["技能ID"] = "AN00", ["提示"] = "污水喷吐"}},
    ["腐化核心单位ID"] = "MYC0",
    ["广播持续时间Ms"] = 4200,
    ["配音裁断距离"] = 4000,
    ["配音生成配置"] = {
        ["显示台词字段"] = "台词",
        ["配音台词字段"] = "配音台词",
        ["声线名称"] = "Ilinca - Vampire Countess",
        ["声线ID"] = "FcZStbCG9g9QxDlJioSD",
        ["模型ID"] = "eleven_v3",
        ["语言"] = "en",
        ["整体提示词"] = "A corrupted magical cat spirit, feminine dark fantasy voice, elegant but sickly, soft playful menace, pained and obsessive, once a sacred elven familiar now twisted by polluted water. Speak clearly, with intimate unease and a faint wet cavern reverb. Not a witch, not a demon, not a human scream.",
        ["说明"] = "系统消息/广播显示继续使用中文台词；AI Voice 生成使用英文配音台词。米亚的配音台词不做旁白播报，系统提示类中文会转写成米亚本人能说的英文句子。情绪标签仅适用于 eleven_v3。"
    },
    BuffID = {["腐化感染"] = "BMI1", ["污染标记"] = "BMI2", ["平台超载"] = "BMI3", ["腐化黏液涂层"] = "BMI4"},
    ["模型"] = {Boss = "Boss\\PollutionCat Corruptor Mia\\BAIHU.mdx"},
    ["特效"] = {
        ["入出水水花"] = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",
        ["入出水毒雾1"] = "Common\\Effect\\Element\\poison\\Nature'sFury.mdx",
        ["入出水毒雾2"] = "Common\\Effect\\Element\\poison\\LegionStrike.mdx",
        ["腐化残留云"] = "Common\\Effect\\Element\\poison\\radioactivecloud_2c.mdx",
        ["腐化低层"] = "Units\\Undead\\PlagueCloud\\PlagueCloudtarget.mdl",
        ["腐化中层"] = "war3mapImported\\Acid Ex.mdx",
        ["腐化高层"] = "Common\\Effect\\Element\\poison\\Pestilence.mdx",
        ["平台预警底圈"] = "Common\\Effect\\Form\\MagicCircle\\Mage aura.mdx",
        ["终极污染核心模型"] = "Common\\Effect\\Element\\poison\\Earth_Leaf fall.mdx",
        ["终极污染核心附着"] = "Common\\Effect\\Element\\Dark\\Soul Aura.mdx",
        ["终极污染Boss引导"] = "Common\\Effect\\Form\\MagicCircle\\Channeling (2).mdx",
        ["终极污染中心柱"] = "war3mapImported\\darkpillar.mdx",
        ["终极污染完成冲击"] = "Common\\Effect\\Element\\Dark\\shadowslam(normal size).mdx",
        ["终极污染完成毒爆"] = "Common\\Effect\\Element\\poison\\GhostShockCaster.mdx"
    },
    ["台词"] = {
        ["开场"] = {"纯净...刺痛...水必须是...黑色的...", "这样...就不痛了..."},
        ["转阶段2"] = {"系统提示：米亚跳入了中央水池！战斗进入第二阶段！", "水会记住痛。你们也会。"},
        ["转阶段3"] = {"别洗掉...别洗掉我...", "米亚甩出了身上的黏液，全场玩家腐化 +1。"},
        ["腐化爪击"] = {"米亚盯上了最远的玩家！", "爪痕会留下来。"},
        ["污水喷吐"] = {"米亚正在蓄力喷吐！快躲开！", "喝下去...就不会干净了。"},
        ["灵猫分身"] = {
            "米亚召唤了幻影！优先击杀！",
            "影子也会渴。",
            "小影子...回来，回到我肚子里。",
            "甜的...脏东西也可以很甜。",
            "别碰我的影子！"
        },
        ["污染标记"] = {"你最脏...也最香。", "别洗掉，我喜欢这个味道。", "碎掉了？那就由我喝干净。"},
        ["污染脉冲"] = {
            "水池在呼吸...听见了吗？",
            "上去，快上去...下面要涨潮了。",
            "第一圈。",
            "第二圈...别下来。",
            "第三圈...水快够到了。",
            "全都染上吧！"
        },
        ["污水柱爆发"] = {"脚下在笑。", "别站在那里。", "噗！", "泡泡破了，泥还在。"},
        ["腐化转移"] = {"米亚正在污染安全区！离开目标平台！", "这里，也要变黑。"},
        ["平台超载惩罚"] = {"挤在一起？脏得更快。", "别推开呀，我喜欢你们贴在一起。"},
        ["腐化黏液涂层"] = {"靠近我，就会黏住。", "爪子碰到泥了。", "全身都要有我的味道。", "痛…但污水流得更快了。"},
        ["终极污染"] = {
            "米亚正在污染整个水源！快打碎腐化核心！",
            "所有水...都归于腐化。",
            "守住我的核心，不许打碎！",
            "第一口，喝下去。",
            "第二口，别吐出来。",
            "最后一口…马上就不痛了。",
            "别碰那个！",
            "不、不可以…就差一点！",
            "水…又变清了？好痛！好痛！",
            "好了…全都黑了。"
        },
        ["死亡"] = {"水...终于安静了..."}
    },
    ["配音台词"] = {
        ["开场"] = {"[pained whisper] Purity... it burns... [obsessive relief] The water must be... black...", "[softly relieved] Like this... [fading comfort] it doesn't hurt anymore..."},
        ["转阶段2"] = {"[sickly sweet] Deeper now... into the pool. [possessive whisper] Let the clean water learn my color.", "[torn with pain] The water remembers pain. [furious curse] So will you!"},
        ["转阶段3"] = {"[frightened whisper] Don't wash it away... don't wash me away...", "[pained delight] It spills from me... all of it. [obsessive] Let it cling to you."},
        ["腐化爪击"] = {"[playful whisper] I see you, little one... so far away.", "[playful menace] The scar will stay."},
        ["污水喷吐"] = {"[sickly breath] My throat is full... [warning] move, if you still want to stay clean.", "[sickly sweet] Drink it... [darkly amused] and you will never be clean again."},
        ["灵猫分身"] = {
            "[softly calling] Come out, little shadows. [hungry whisper] They have clean hands.",
            "[whispering] Even shadows get thirsty.",
            "[softly calling] Little shadow... come back. [possessive] Back into my belly.",
            "[sickly sweet] Sweet... [delighted whisper] even filthy things can be sweet.",
            "[angry and afraid] Don't touch my shadow!"
        },
        ["污染标记"] = {"[obsessive] You are the filthiest... [sickly sweet] and the sweetest.", "[softly possessive] Don't wash it off. [intimate whisper] I like that smell.", "[pained delight] Broken already? [hungry] Then I'll drink you clean."},
        ["污染脉冲"] = {
            "[whispering] The pool is breathing... [closer] can you hear it?",
            "[urgent but soft] Up. Hurry up... [warning] the water is rising below.",
            "[coldly] The first wave.",
            "[warning] The second... don't come down.",
            "[whispering closer] The third... [eager] the water is almost touching you.",
            "[ecstatic] Let it stain everything!"
        },
        ["污水柱爆发"] = {"[playful whisper] The ground is laughing.", "[soft warning] Don't stand there.", "[quick playful] Pop!", "[sickly sweet] The bubble burst, but the mud remains."},
        ["腐化转移"] = {"[obsessive whisper] Not safe. Not clean. [cold] Not anymore.", "[obsessive] This place, too... must turn black."},
        ["平台超载惩罚"] = {"[teasing menace] All huddled together? [delighted] You'll rot even faster.", "[softly amused] Don't push away. [possessive whisper] I like you close together."},
        ["腐化黏液涂层"] = {"[softly] Come close, and you'll stick.", "[pained playful] My claws touched the mud.", "[obsessive] Every inch of you should smell like me.", "[pained] It hurts... [excited whisper] but the filthy water flows faster."},
        ["终极污染"] = {
            "[panicked warning] The whole spring is mine now. [commanding] Break nothing. Touch nothing.",
            "[solemn and sickly] All water... [obsessive] belongs to corruption.",
            "[panicked] Guard my core. [desperate] Don't let them break it!",
            "[whispering command] First sip. Drink it down.",
            "[softly cruel] Second sip. Don't spit it out.",
            "[pained relief] The final sip... [softly relieved] soon it won't hurt anymore.",
            "[frightened] Don't touch that!",
            "[desperate] No, no... [pleading] I'm so close!",
            "[breaking in pain] The water... is clear again? [crying out] It hurts! It hurts!",
            "[relieved] Good... [hollow whisper] now everything is black."
        },
        ["死亡"] = {"[fading] The water... [peaceful] is quiet at last..."}
    },
    ["配音资源"] = {
        ["开场"] = {"Sound\\Boss\\Mia\\Voice\\mia_opening_purity_burns_ilinca_02_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_opening_no_hurt_anymore_ilinca_02_v3.mp3"},
        ["转阶段2"] = {"Sound\\Boss\\Mia\\Voice\\mia_phase2_pool_learn_color_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_phase2_water_remembers_pain_ilinca_02_v3.mp3"},
        ["转阶段3"] = {"Sound\\Boss\\Mia\\Voice\\mia_phase3_dont_wash_me_away_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_phase3_spills_cling_ilinca_01_v3.mp3"},
        ["腐化爪击"] = {"Sound\\Boss\\Mia\\Voice\\mia_claw_far_target_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_claw_scar_stays_ilinca_01_v3.mp3"},
        ["污水喷吐"] = {"Sound\\Boss\\Mia\\Voice\\mia_spit_throat_full_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_spit_never_clean_ilinca_01_v3.mp3"},
        ["灵猫分身"] = {
            "Sound\\Boss\\Mia\\Voice\\mia_shadow_clone_come_out_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_shadow_clone_shadows_thirsty_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_shadow_clone_back_belly_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_shadow_clone_filthy_sweet_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_shadow_clone_dont_touch_shadow_ilinca_01_v3.mp3"
        },
        ["污染标记"] = {"Sound\\Boss\\Mia\\Voice\\mia_mark_filthiest_sweetest_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_mark_like_smell_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_mark_drink_clean_ilinca_01_v3.mp3"},
        ["污染脉冲"] = {
            "Sound\\Boss\\Mia\\Voice\\mia_pulse_pool_breathing_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_pulse_water_rising_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_pulse_first_wave_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_pulse_second_wave_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_pulse_third_wave_touching_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_pulse_stain_everything_ilinca_01_v3.mp3"
        },
        ["污水柱爆发"] = {"Sound\\Boss\\Mia\\Voice\\mia_water_column_ground_laughing_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_water_column_dont_stand_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_water_column_pop_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_water_column_mud_remains_ilinca_01_v3.mp3"},
        ["腐化转移"] = {"Sound\\Boss\\Mia\\Voice\\mia_transfer_not_safe_clean_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_transfer_place_turn_black_ilinca_01_v3.mp3"},
        ["平台超载惩罚"] = {"Sound\\Boss\\Mia\\Voice\\mia_overload_rot_faster_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_overload_close_together_ilinca_01_v3.mp3"},
        ["腐化黏液涂层"] = {"Sound\\Boss\\Mia\\Voice\\mia_slime_coating_come_close_stick_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_slime_coating_claws_mud_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_slime_coating_smell_like_me_ilinca_01_v3.mp3", "Sound\\Boss\\Mia\\Voice\\mia_slime_coating_filthy_water_flows_ilinca_01_v3.mp3"},
        ["终极污染"] = {
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_spring_mine_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_water_corruption_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_guard_core_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_first_sip_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_second_sip_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_final_sip_no_hurt_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_dont_touch_that_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_so_close_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_clear_again_hurts_ilinca_01_v3.mp3",
            "Sound\\Boss\\Mia\\Voice\\mia_ultimate_everything_black_ilinca_01_v3.mp3"
        },
        ["死亡"] = {"Sound\\Boss\\Mia\\Voice\\mia_defeat_water_quiet_ilinca_02_v3.mp3"}
    }
}
return ____exports
