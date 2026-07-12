--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["菲利斯单位技能配置"] = {
    ["单位ID"] = "N05T",
    ["单位名称"] = "菲利斯",
    ["Boss单位ID"] = "N05T",
    ["技能壳"] = {
        ["领袖光环"] = "A0LQ",
        ["剑魂杀"] = "A0LP",
        ["剑气灵斩"] = "A0LR",
        ["全力封印斩"] = "A0LS",
        ["异形化"] = "A0LT"
    },
    ["主动技能提示"] = {{["技能ID"] = "A0LP", ["提示"] = "剑魂杀", ["扩展提示"] = "蓄力后释放剑气狼，命中后在终点化为小狼或大狼追击玩家。"}, {["技能ID"] = "A0LR", ["提示"] = "剑气灵斩", ["扩展提示"] = "向前方劈出剑气并留下侵蚀区域，持续伤害并汲取魔法。"}, {["技能ID"] = "A0LS", ["提示"] = "全力封印斩", ["扩展提示"] = "锁定 QWER 全冷却玩家，扣除魔法并眩晕。"}, {["技能ID"] = "A0LT", ["提示"] = "异形化", ["扩展提示"] = "消耗满魔法进入强化形态，刷新剑气灵斩并牵引附近玩家。"}},
    ["广播持续时间Ms"] = 4200,
    ["配音裁断距离"] = 4000,
    ["配音生成配置"] = {
        ["显示台词字段"] = "台词",
        ["配音台词字段"] = "配音台词",
        ["声线名称"] = "Maverick - Commanding and Powerful",
        ["声线ID"] = "V33LkP9pVLdcjeB2y5Na",
        ["模型ID"] = "eleven_v3",
        ["语言"] = "en",
        ["整体提示词"] = "A fallen siege commander and master swordsman who begins disciplined, commanding, and militarily precise, then willingly embraces aberrant dark power to win the war. Keep the same masculine identity across both states. Before transformation: cold authority and battlefield command. After transformation: bodily strain, intoxicating power, fractured restraint, and increasingly unhinged triumph. Clear Warcraft-style combat pacing; not a mindless demon and not a theatrical narrator.",
        ["说明"] = "菲利斯黑化前后优先共用 Maverick，以同一声纹保持身份连续。常态强调冷静军令和剑术统御；异形化后通过更低稳定度、更高表演强度及痛苦转癫狂标签表现为力量主动黑化。若试听后黑化幅度仍不足，再为异形化阶段选择独立黑暗人格声线。"
    },
    ["台词"] = {
        ["开场"] = {"帝国的走狗，此事与你们无关。现在让开。"},
        ["领袖光环"] = {"全军稳住阵线，跟随我的剑锋推进！"},
        ["剑魂杀"] = {"剑魂！追上去，猎杀他们！"},
        ["剑气灵斩"] = {"这一斩，会在你们身上刻下永不愈合的伤口！"},
        ["全力封印斩"] = {"你们的力量已经沉默。现在，只有我的剑能够发言。"},
        ["异形化"] = {"力量正在重塑我的血肉，将我变成这场战争需要的兵器！"},
        ["死亡"] = {"哼，还不差。下一次，我或许会认真与你们交手。"}
    },
    ["配音台词"] = {
        ["开场"] = {"[cold contempt] Imperial hounds. This battle does not concern you. [commanding threat] Stand aside, or be cut down with the rest."},
        ["领袖光环"] = {"[thunderous battle command] Hold the line! Advance behind my blade!"},
        ["剑魂杀"] = {"[thunderous battle command] Spirits of the blade! [ruthless threat] Hunt them down!"},
        ["剑气灵斩"] = {"[thunderous warning] This slash will carve a wound into your flesh! [merciless threat] One that will never close!"},
        ["全力封印斩"] = {"[cold command] Your powers are silent now. [merciless threat] Only my blade may speak!"},
        ["异形化"] = {"[fighting the transformation] Power is remaking my flesh... [unhinged triumph] Yes... into the weapon this war demands!"},
        ["死亡"] = {"[wounded amusement] Hmph. Not bad. [cold superiority] Next time, I may fight you in earnest."}
    },
    ["配音资源"] = {
        ["开场"] = {"Sound\\Boss\\Felice\\Voice\\felice_opening_imperial_hounds_maverick_02_v3.mp3"},
        ["领袖光环"] = {"Sound\\Boss\\Felice\\Voice\\felice_leader_aura_hold_line_maverick_02_v3.mp3"},
        ["剑魂杀"] = {"Sound\\Boss\\Felice\\Voice\\felice_sword_soul_hunt_maverick_03_heavy_command_v3.mp3"},
        ["剑气灵斩"] = {"Sound\\Boss\\Felice\\Voice\\felice_spirit_slash_wound_maverick_03_heavy_warning_v3.mp3"},
        ["全力封印斩"] = {"Sound\\Boss\\Felice\\Voice\\felice_seal_only_blade_speaks_maverick_02_v3.mp3"},
        ["异形化"] = {"Sound\\Boss\\Felice\\Voice\\felice_aberration_war_weapon_maverick_02_v3.mp3"},
        ["死亡"] = {"Sound\\Boss\\Felice\\Voice\\felice_defeat_trial_maverick_05_short_superior_v3.mp3"}
    }
}
return ____exports
