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
        ["腐化黏液爆发地面"] = "Common\\Effect\\Element\\poison\\MiaSlimeBurstGround.mdx",
        ["腐化黏液爆发放射"] = "Common\\Effect\\Element\\poison\\MiaSlimeBurstFlash.mdx",
        ["腐化感染叠层爆发"] = "Common\\Effect\\Element\\poison\\MiaCorruptionStackBurst.mdx",
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
        ["转阶段2"] = {"米亚跳入中央水池，战斗进入P2；污染波即将开始。（站上白色安全平台，避开红色扩散区域。）", "P2水池污染已启动，平台是安全位置。（分散站位，留意红色扩散波。）"},
        ["转阶段3"] = {"米亚进入P3，腐化黏液涂层生效。（近战攻击会叠加腐化感染，非必要不要贴身。）", "P3腐化黏液每10秒向全场扩散1层腐化感染。（保持分散并及时降低腐化层数。）"},
        ["腐化爪击"] = {"米亚锁定目标并跃击落点，落地造成当前攻击力×300%伤害并施加1层腐化感染。（离开红色扑击路径和落点。）", "落地点将留下持续10秒、半径180码的腐化爪痕，每秒叠加1层腐化感染。（立即离开爪痕区域。）"},
        ["污水喷吐"] = {"米亚将在1秒后向正面喷吐1.5秒，覆盖900码、90°扇形。（离开米亚正面，站到侧后方。）", "喷吐首次命中会额外施加2层腐化感染，结束后留下持续5秒、半径220码的污水区。（离开红色扇形和污水区。）"},
        ["灵猫分身"] = {
            "米亚召唤2个灵猫分身，持续15秒；未击杀的分身结束时每只为米亚恢复最大生命值15%。（优先击杀分身。）",
            "灵猫分身已出现，分身生命值为米亚最大生命值的10%，攻击力为米亚当前攻击力的30%。（集中火力击杀分身。）",
            "灵猫分身还剩5秒，未击杀的分身将为米亚恢复最大生命值15%/只。（继续优先处理分身。）",
            "灵猫分身已结束，存活分身使米亚恢复最大生命值15%/只。（下一次分身请优先击杀。）",
            "灵猫分身已全部击杀，米亚未获得恢复。（保持站位，准备下一次技能。）"
        },
        ["污染标记"] = {"污染标记锁定当前腐化感染层数最高的玩家，米亚的腐化爪击和污水喷吐对其伤害提高20%。（被标记者注意躲避技能。）", "污染标记每1秒重新判定并持续1.5秒；被标记者承受米亚腐化爪击和污水喷吐的伤害提高20%。（降低腐化层数，避免持续被标记。）", "污染标记目标已死亡，米亚恢复自身最大生命值10%。（控制腐化层数，避免被标记者倒下。）"},
        ["污染脉冲"] = {
            "污染脉冲将在15秒预警后从水池中心扩散4波，半径依次为150/300/450/600码；每波叠加1层腐化感染。（进入白色安全平台。）",
            "污染脉冲还有3秒开始扩散，四波间隔1秒。（立即进入白色安全平台，避开红色扩散区。）",
            "污染脉冲第1波扩散，半径150码。（留在白色安全平台。）",
            "污染脉冲第2波扩散，半径300码。（继续留在白色安全平台。）",
            "污染脉冲第3波扩散，半径450码。（不要离开白色安全平台。）",
            "污染脉冲第4波扩散，半径600码。（保持在白色安全平台，直到扩散结束。）"
        },
        ["污水柱爆发"] = {"污水柱锁定随机玩家位置，1-2人模式1个、3-4人模式2个；2秒后在预警圈内爆发。（离开绿色预警圈。）", "污水柱还有0.5秒爆发，爆发半径180码。（立即离开预警圈。）", "污水柱爆发，半径180码内造成当前攻击力×90%+目标最大生命值×2%的伤害并增加2层腐化感染。（离开爆发圈。）", "爆发后留下半径220码、持续15秒的腐化水坑；每秒造成当前攻击力×8%+目标最大生命值×0.4%的伤害并增加1层腐化感染。（离开水坑。）"},
        ["腐化转移"] = {"米亚将在1.5秒后跳向目标平台并使其污染10秒。（离开红色预警平台，转移到其他平台。）", "目标平台已被污染10秒，平台内每秒叠加2层腐化感染。（立即离开该平台。）"},
        ["平台超载惩罚"] = {"平台超载：1-2人模式超过1人、3-4人模式超过2人时，每秒增加1层腐化感染；腐化爪击、污水喷吐、污染脉冲和污水柱爆发对你的伤害提高30%。（分散到未超载平台。）", "平台仍在超载：每秒增加1层腐化感染；腐化爪击、污水喷吐、污染脉冲和污水柱爆发对你的伤害提高30%。（保持人数不超过平台容量。）"},
        ["腐化黏液涂层"] = {"腐化黏液涂层已覆盖米亚：米亚受到的所有伤害提高20%。（输出时避免不必要的近战攻击。）", "近战反噬：攻击米亚的玩家增加1层腐化感染，同一玩家5秒内不会重复触发。（远离米亚或改用远程攻击。）", "米亚每10秒使所有有效玩家增加1层腐化感染。（保持分散并及时降低腐化层数。）", "腐化黏液使米亚受到的所有伤害提高20%。（保持输出，但避免近战触发反噬。）"},
        ["终极污染"] = {
            "终极污染开始，引导10秒；场上生成4个腐化核心，所有玩家每秒增加1层腐化感染。（10秒内击破全部核心即可打断。）",
            "终极污染引导中，所有玩家每秒增加1层腐化感染。（优先寻找并击破4个腐化核心。）",
            "腐化核心必须全部击破才能打断终极污染。（分工集火核心，不要只攻击米亚。）",
            "终极污染已进行2秒，全场已叠加2层腐化感染。（继续击破腐化核心。）",
            "终极污染已进行4秒，全场已叠加4层腐化感染。（优先处理剩余腐化核心。）",
            "终极污染已进行6秒，全场已叠加6层腐化感染。（抓紧击破全部腐化核心。）",
            "腐化核心已被击破，剩余核心继续维持引导。（集火剩余核心，全部击破即可打断。）",
            "只剩1个腐化核心，全部击破即可打断终极污染。（立即集火最后核心。）",
            "终极污染已被打断，米亚进入3秒虚弱。（趁虚弱集中输出。）",
            "终极污染完成：全场腐化感染立即设为15层并死亡。（必须在10秒内击破全部腐化核心。）"
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
