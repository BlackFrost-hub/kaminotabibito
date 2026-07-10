--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["巴尔扎罗斯单位技能配置"] = {
    ["单位ID"] = "N03G",
    ["单位名"] = "熔岩恶魔王·巴尔扎罗斯",
    ["Boss单位ID"] = "N03G",
    ["护卫"] = {["格鲁姆"] = {
        ["名称"] = "熔岩破坏者·格鲁姆",
        ["模型路径"] = "Boss\\Balzaroth\\Grum\\Grum.mdx",
        ["图标路径"] = "Boss\\Balzaroth\\Grum\\Grum.blp",
        ["广播持续时间Ms"] = 3200,
        ["配音裁断距离"] = 4000,
        ["配音生成配置"] = {
            ["显示台词字段"] = "台词",
            ["配音台词字段"] = "配音台词",
            ["声线名称"] = "Azgar - Intimidating Orc Troll",
            ["声线ID"] = "3VkFsBHdRPqWKsitgYhJ",
            ["模型ID"] = "eleven_v3",
            ["语言"] = "en",
            ["整体提示词"] = "A massive demonic orc enforcer in molten heavy armor, fiercely loyal to an infernal king. Deep battle-worn growl, blunt military obedience, crushing physical menace, and clear Warcraft-style combat delivery. Speak at a forceful battle pace with restrained grit. Not comedic, not mindless, not a roaring animal.",
            ["说明"] = "格鲁姆是重甲近战护卫，语气粗粝、忠诚、直接。回应君王时服从但不卑怯；技能台词短促有冲击力，避免拖成长吼。"
        },
        ["台词"] = {["响应召令"] = {"遵命，吾王。"}, ["熔岩重锤"] = {"都趴下！我要把你们砸进地底！"}, ["熔岩火径"] = {"火路已开。无路可退。"}, ["死亡"] = {"吾王……格鲁姆不能再战了……"}},
        ["配音台词"] = {["响应召令"] = {"[obedient growl] As you command, my king."}, ["熔岩重锤"] = {"[battle roar] Down! I will hammer you into the earth!"}, ["熔岩火径"] = {"[grim] The path burns. There is no retreat."}, ["死亡"] = {"[dying strain] My king... Grum can fight no longer..."}},
        ["配音资源"] = {["响应召令"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_grum_answer_command_01_v3.mp3"}, ["熔岩重锤"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_grum_molten_hammer_01_v3.mp3"}, ["熔岩火径"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_grum_lava_path_01_v3.mp3"}, ["死亡"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_grum_death_01_v3.mp3"}}
    }, ["塞拉"] = {
        ["名称"] = "冰焰巫师·塞拉",
        ["模型路径"] = "Boss\\Balzaroth\\Sera\\Sera.mdx",
        ["图标路径"] = "Boss\\Balzaroth\\Sera\\Sera.blp",
        ["广播持续时间Ms"] = 3200,
        ["配音裁断距离"] = 4000,
        ["配音生成配置"] = {
            ["显示台词字段"] = "台词",
            ["配音台词字段"] = "配音台词",
            ["声线名称"] = "Altáriel - Storyteller of the Light",
            ["声线ID"] = "oBVK5gDykyUkoVXUPyCU",
            ["模型ID"] = "eleven_v3",
            ["语言"] = "en",
            ["整体提示词"] = "A pale elven battle mage serving an infernal king, wielding frost and flame with cold precision. Low feminine elven timbre, controlled danger, disciplined loyalty, and concise Warcraft-style spellcasting. Keep the delivery clear and combat-paced, with a faint arcane resonance. Not gentle, not pastoral, not a storyteller.",
            ["说明"] = "塞拉是冷静危险的冰焰法师护卫。以低沉精灵女声为底，通过提示词压住森林神谕感；台词强调精准施法、元素控制和克制的忠诚。"
        },
        ["台词"] = {
            ["响应召令"] = {"遵命，陛下。"},
            ["冰焰双星"] = {"冰与火，将同时索命。"},
            ["绝对零度领域"] = {"绝对零度，封锁战场。"},
            ["元素转换火焰"] = {"冰霜退去，烈焰接管。"},
            ["元素转换冰霜"] = {"烈焰沉寂，寒冬降临。"},
            ["死亡"] = {"陛下……元素失衡了……"}
        },
        ["配音台词"] = {
            ["响应召令"] = {"[coldly obedient] As you command, my liege."},
            ["冰焰双星"] = {"[cold precision] Ice and flame will claim you together."},
            ["绝对零度领域"] = {"[commanding] Absolute zero. Seal the battlefield."},
            ["元素转换火焰"] = {"[rising intensity] Frost recedes. Flame takes command."},
            ["元素转换冰霜"] = {"[coldly] Flame falls silent. Winter descends."},
            ["死亡"] = {"[fading disbelief] My liege... the elements... are breaking..."}
        },
        ["配音资源"] = {
            ["响应召令"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_sera_answer_command_01_v3.mp3"},
            ["冰焰双星"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_sera_frostfire_twins_01_v3.mp3"},
            ["绝对零度领域"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_sera_absolute_zero_01_v3.mp3"},
            ["元素转换火焰"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_sera_shift_to_flame_01_v3.mp3"},
            ["元素转换冰霜"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_sera_shift_to_frost_01_v3.mp3"},
            ["死亡"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_guard_sera_death_01_v3.mp3"}
        }
    }},
    ["技能壳"] = {["恶魔咆哮波"] = "A0C9", ["熔岩喷发"] = "A0CC", ["王者天罚"] = "A0CA", ["火焰锁链"] = "A0CB"},
    ["主动技能提示"] = {{["技能ID"] = "A0C9", ["提示"] = "恶魔咆哮波"}, {["技能ID"] = "A0CC", ["提示"] = "熔岩喷发"}, {["技能ID"] = "A0CA", ["提示"] = "王者天罚"}, {["技能ID"] = "A0CB", ["提示"] = "火焰锁链"}},
    ["广播持续时间Ms"] = 4200,
    ["配音裁断距离"] = 4000,
    ["配音生成配置"] = {
        ["显示台词字段"] = "台词",
        ["配音台词字段"] = "配音台词",
        ["声线名称"] = "Matthew Schmitz - Unholy, Wicked Demon",
        ["声线ID"] = "rCYFsCX2waxtHCgVD0e8",
        ["模型ID"] = "eleven_v3",
        ["语言"] = "en",
        ["整体提示词"] = "An ancient molten demon king, colossal and heavily armored, with deep infernal resonance, imperious royal command, controlled wrath, and volcanic cavern weight. Speak clearly at battle pace, authoritative rather than theatrical, with restrained rumble and slight stone chamber reverb. Not a mindless beast, not a whispering demon, not a human villain.",
        ["说明"] = "系统消息和广播继续显示中文台词；AI Voice 使用后续确认的英文配音台词。整体表演强调熔岩恶魔王的统治感与清晰度，战斗台词不要拖慢，情绪标签仅适用于 eleven_v3。"
    },
    BuffID = {
        ["灼热"] = "BBZ1",
        ["熔核封印"] = "BBZ2",
        ["火焰锁链"] = "BBZ3",
        ["熔岩护盾"] = "BBZ4",
        ["炙热奉献"] = "BBZ5",
        ["塞拉火焰形态"] = "BBZ6",
        ["塞拉冰霜形态"] = "BBZ7",
        ["熔岩暴走"] = "BBZ8"
    },
    ["模型"] = {Boss = "war3mapImported\\2.mdl"},
    ["台词"] = {
        ["开场"] = {"地核的锁链，终将为王让路。"},
        ["转阶段2"] = {"护卫已尽，封印松动。"},
        ["转阶段3"] = {"大地开始燃烧。"},
        ["死亡"] = {"熔核...不该归于沉寂..."},
        ["熔岩重锤"] = {"格鲁姆，碾碎他们。"},
        ["熔岩火径"] = {"火线会告诉你们边界在哪里。"},
        ["炙热奉献"] = {"把你的余烬献给王。"},
        ["冰焰双星"] = {"塞拉，让冰火同时坠落。"},
        ["绝对零度领域"] = {"寒意也要臣服于熔核。"},
        ["元素转换"] = {"元素换相，战场重铸。"},
        ["恶魔咆哮波"] = {"听见王的怒吼了吗？"},
        ["王者天罚"] = {"天罚落下，跪地求生。"},
        ["熔岩喷发"] = {"地底已经醒来。"},
        ["火焰锁链"] = {"锁住他。"},
        ["地核召唤"] = {"地核仆从，苏醒。"},
        ["熔岩护盾"] = {"熔岩即我的甲胄。"},
        ["末日熔爆"] = {"站进安全区，或者成为下一层岩浆。"},
        ["末日熔爆中途"] = {"还剩一息，安全区不会等人。"},
        ["末日熔爆爆发"] = {"看，这就是地核的呼吸。"}
    },
    ["配音台词"] = {
        ["开场"] = {"[commanding, restrained fury] The chains of the molten core will yield before their king."},
        ["转阶段2"] = {"[low satisfaction] My guards have fallen... [rising menace] and with them, the seal begins to break."},
        ["转阶段3"] = {"[growing wrath] The earth itself... [triumphant] now burns at my command."},
        ["死亡"] = {"[shocked, weakening] The molten core... [fading disbelief] cannot fall silent..."},
        ["熔岩重锤"] = {"[commanding] Grum. Crush them."},
        ["熔岩火径"] = {"[cold warning] Let the line of flame teach you where your world ends."},
        ["炙热奉献"] = {"[imperious] Yield your embers to your king."},
        ["冰焰双星"] = {"[commanding] Sera. Let frost and flame fall as one."},
        ["绝对零度领域"] = {"[contemptuous] Even the cold must kneel before the molten core."},
        ["元素转换"] = {"[arcane command] Let the elements turn. [rising power] Reforge this battlefield."},
        ["恶魔咆哮波"] = {"[taunting] Do you hear it? [infernal fury] The wrath of your king!"},
        ["王者天罚"] = {"[royal condemnation] Judgment descends. [merciless] Kneel... and beg to survive."},
        ["熔岩喷发"] = {"[ominous] The depths... have awakened."},
        ["火焰锁链"] = {"[sharp command] Bind them."},
        ["地核召唤"] = {"[summoning command] Servants of the core... awaken."},
        ["熔岩护盾"] = {"[unyielding] Molten fire is my armor."},
        ["末日熔爆"] = {"[coldly commanding] Enter the sanctuary... [volcanic menace] or become another layer of molten stone."},
        ["末日熔爆中途"] = {"[pressing menace] One breath remains. [cold] The sanctuary will not wait."},
        ["末日熔爆爆发"] = {"[dark awe] Behold... [volcanic triumph] the breath of the molten core."}
    },
    ["配音资源"] = {
        ["开场"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_opening_molten_core_king_unholy_01_v3.mp3"},
        ["转阶段2"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_phase2_guards_fallen_seal_breaks_01_v3.mp3"},
        ["转阶段3"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_phase3_earth_burns_command_01_v3.mp3"},
        ["死亡"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_death_molten_core_silence_01_v3.mp3"},
        ["熔岩重锤"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_molten_hammer_command_01_v3.mp3"},
        ["熔岩火径"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_lava_path_boundary_01_v3.mp3"},
        ["炙热奉献"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_searing_offering_embers_01_v3.mp3"},
        ["冰焰双星"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_frostfire_twins_command_01_v3.mp3"},
        ["绝对零度领域"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_absolute_zero_submission_01_v3.mp3"},
        ["元素转换"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_element_shift_reforge_01_v3.mp3"},
        ["恶魔咆哮波"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_demonic_roar_wave_wrath_01_v3.mp3"},
        ["王者天罚"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_royal_judgment_kneel_01_v3.mp3"},
        ["熔岩喷发"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_lava_eruption_depths_awaken_01_v3.mp3"},
        ["火焰锁链"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_flame_chains_bind_01_v3.mp3"},
        ["地核召唤"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_core_summon_servants_awaken_01_v3.mp3"},
        ["熔岩护盾"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_molten_shield_armor_01_v3.mp3"},
        ["末日熔爆"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_doom_meltdown_sanctuary_warning_01_v3.mp3"},
        ["末日熔爆中途"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_doom_meltdown_one_breath_01_v3.mp3"},
        ["末日熔爆爆发"] = {"Sound\\Boss\\Balzaroth\\Voice\\balzaroth_doom_meltdown_core_breath_01_v3.mp3"}
    }
}
return ____exports
