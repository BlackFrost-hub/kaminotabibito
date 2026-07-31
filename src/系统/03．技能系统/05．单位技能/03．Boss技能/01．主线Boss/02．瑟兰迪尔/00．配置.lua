--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["瑟兰迪尔单位技能配置"] = {
    ["单位ID"] = "N057",
    ["单位名"] = "精灵执法队长·瑟兰迪尔",
    ["单位目标技能900"] = "AT05",
    ["单位目标技能1000"] = "AT06",
    ["精灵箭阵技能"] = "AN00",
    ["律法召唤技能"] = "AN01",
    ["主动技能提示"] = {{["技能ID"] = "AT05", ["提示"] = "月光枷锁", ["扩展提示"] = "施法硬直1秒；命中后定身3秒，每1秒结算1次，单次伤害=瑟兰迪尔当前攻击力×8%+目标最大生命值×0.4%，共3次；累计受到其他单位≥1500点伤害可打断并掉落月光碎片。（看到锁链命中后，队友立即集火打断。）"}, {["技能ID"] = "AT06", ["提示"] = "罪与罚", ["扩展提示"] = "施法硬直1秒，5秒后随机结算红/蓝/绿/金象限。红：每秒扣目标最大生命5%，持续8秒，并使攻击力提高35%持续18秒；蓝：移动速度降低70%、攻击速度降低50%持续8秒，并使护甲提高40%、魔抗提高30%持续18秒；绿：每秒扣最大生命4%持续8秒，并使治疗效果降低60%，同时每秒回蓝300、技能消耗降低50%持续18秒；金：按结算时已损失法力值×200%每秒结算8次（无最大法力值时每次固定200），并使技能伤害提高45%、技能消耗提高60%、冷却缩短30%持续18秒。（5秒读条期间先看清颜色，再准备对应的生存或资源方案。）"}, {["技能ID"] = "AN00", ["提示"] = "精灵箭阵", ["扩展提示"] = "施法硬直0.5秒；召唤4名弓手，持续20秒。每名弓手生命值=Boss最大生命值×15%，每2秒发射1枚弹幕，首次出手延迟0.35秒，单发伤害=Boss当前攻击力×50%，射程1600码；执法印记目标更容易被选中。（优先击杀弓手，或避开其弹道。）"}, {["技能ID"] = "AN01", ["提示"] = "律法召唤", ["扩展提示"] = "施法硬直0.5秒；单人召唤1名、多人召唤2名执法者，持续35秒。每名执法者生命值=Boss最大生命值×25%，护甲20，并独占连接1名玩家；连接半径500码，超出后每1秒结算Boss攻击力×35%的伤害。（保持与执法者距离，优先处理连线单位。）"}},
    ["广播持续时间Ms"] = 4200,
    ["配音裁断距离"] = 4000,
    ["配音生成配置"] = {
        ["显示台词字段"] = "台词",
        ["配音台词字段"] = "配音台词",
        ["声线名称"] = "Jude - Conversational British Podcaster",
        ["声线ID"] = "Yg7C1g7suzNt5TisIqkZ",
        ["模型ID"] = "eleven_v3",
        ["语言"] = "en",
        ["说明"] = "系统消息/广播显示继续使用中文台词；AI Voice 生成使用英文配音台词。情绪标签如 [angry] 仅适用于 eleven_v3，不要用 eleven_multilingual_v2 生成。"
    },
    ["台词"] = {
        ["开战"] = {"停下！在王城的圣洁之地挥动武器？你不知道这里的规矩吗？（战斗开始，留意月光枷锁和近身秩序领域。）", "月光林地不容许任何争斗……即使是外来的旅者。（保持移动，别让锁链找到你。）", "我是瑟兰迪尔，王庭的执法者。放下武器投降，或者……接受秩序的审判。（先观察预警，再处理点名与召唤物。）"},
        ["转阶段70"] = {"警告无效……那么，接受审判吧！律法之环，展开！（进入二阶段后，颜色法阵每12秒结算一次，提前看清颜色。）", "在这里，每一条罪行都将被称量！（留意红、蓝、绿、金四种象限提示，按颜色调整站位和资源。）"},
        ["转阶段40"] = {"秩序……必须维持！即使……代价是我的生命！（月光灌注将在3秒内完成，完成后进入180秒击杀倒计时。）", "月光啊，给予我最后的力量！（Boss强化完成前抓紧调整站位。）", "以王庭之名……最终裁决！（强化完成后不要拖延，倒计时结束会触发全场惩罚。）"},
        ["月光枷锁"] = {"月光会替你停下脚步。（锁链命中后定身3秒，队友累计造成1500点伤害可打断。）", "违令者，接受束缚。（被定身期间每秒结算一次伤害，立即集火解救。）"},
        ["精灵箭阵"] = {"弓手就位，封锁他们的退路！（4名弓手持续20秒，优先击杀或避开弹道。）", "王庭箭阵，展开！（标记目标更容易被弓手锁定，注意弹道方向。）"},
        ["审判之环"] = {"律法之环已经展开，站错位置就是罪证。（每12秒按颜色结算，先看清法阵颜色。）", "审判开始，颜色会指出你的命运。（红色准备承伤，蓝色注意攻击力，绿色保持高血量，金色保留法力。）"},
        ["罪与罚"] = {"罪与罚从不分离。（5秒后按颜色施加8秒惩罚和18秒增益，提前准备对应方案。）", "你的选择，将成为判决。（被点名后观察颜色，别在结算前耗尽生命或法力。）"},
        ["律法召唤"] = {"执法者，听令出列！（执法者持续35秒，会独占连接玩家。）", "秩序锁链会让逃避者付出代价。（离开500码连接范围会每秒受到惩罚，保持距离或先击杀执法者。）"},
        ["月光灌注"] = {"月光啊，汇入我的刃锋。（3秒后强化完成，瑟兰迪尔获得180秒月光灌注。）", "若审判不能结束纷争，那就让月光终结一切。（强化期间攻击力提高50%，倒计时结束会触发全场惩罚。）"},
        ["精灵神罚"] = {"时间已尽，精灵神罚降临！（180秒倒计时结束，所有玩家将受到最大生命值100%的强化伤害。）", "月光不再宽恕。（倒计时已经结束，无法再靠站位规避。）"},
        ["终末审判"] = {"全体肃静，终末审判开始！（引导5秒，随后2秒后爆炸；只有瑟兰迪尔脚下200码内安全。）", "留在裁决之外，或被秩序抹去。（看到场地法阵后，立刻进入Boss脚下200码安全区。）"},
        ["胜利"] = {"咳……你赢了……但秩序……不会因我而逝……（战斗结束，等待后续剧情演出。）", "记住……月光林地……需要和平……（请勿继续攻击，战斗已经结束。）", "愿月光……指引你道路的……不是……武器……（胜负已定，等待奖励结算。）"}
    },
    ["配音台词"] = {
        ["开战"] = {"[angry] Halt! [annoyed] Drawing your blade on the sacred ground of the royal city? [exasperated] Are you unaware of this realm's laws?", "[stern] No blood is to be spilled in Moonlit Grove. [cold] Not by outsiders. Not by anyone.", "[authoritative] I am Thranduil, enforcer of the royal court. [warning] Lay down your arms, or face the judgment of order."},
        ["转阶段70"] = {"[frustrated] So be it. The warning has failed. [commanding] Stand trial! Ring of Law, unfold!", "[severe] In this place, every offence is weighed beneath the moon."},
        ["转阶段40"] = {"[desperate] Order must endure! [fierce resolve] Even if my life is the price!", "[pleading] Moonlight, grant me your final strength.", "[fierce] By the authority of the royal court... final judgment!"},
        ["月光枷锁"] = {"[controlled] Moonlight shall bind your steps.", "[stern] Defier, be still."},
        ["精灵箭阵"] = {"[commanding] Archers, take position. Seal their retreat!", "[urgent] Royal arrow line, loose!"},
        ["审判之环"] = {"[measured] The Ring of Judgment is open. Step wrongly, and your guilt is proven.", "[cold] Judgment begins. The colors will name your fate."},
        ["罪与罚"] = {"[grim] Sin and punishment are never parted.", "[accusing] Your choice becomes your sentence."},
        ["律法召唤"] = {"[commanding] Enforcers, heed my command. Step forth!", "[severe] The chains of law will punish those who flee."},
        ["月光灌注"] = {"[focused] Moonlight, flow into my blade.", "[resolute] If judgment cannot end this conflict, then moonlight will."},
        ["精灵神罚"] = {"[wrathful] Time is up. Elven punishment descends!", "[cold fury] Moonlight offers no further mercy."},
        ["终末审判"] = {"[commanding] Silence, all of you. Final judgment begins!", "[ominous] Stand outside the verdict, or be erased by order."},
        ["胜利"] = {"[coughs weakly] You... have won... [weak and fading] but order will not die with me...", "[softly] Remember... Moonlit Grove... must know peace...", "[fading] May moonlight guide your path... not your weapons..."}
    },
    ["配音资源"] = {
        ["开战"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_opening_law_warning_jude_02_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_opening_moonlit_grove_jude_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_opening_court_enforcer_jude_01_v3_64k.mp3"},
        ["转阶段70"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_phase70_warning_failed_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_phase70_offences_weighed_01_v3_64k.mp3"},
        ["转阶段40"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_phase40_order_endure_02_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_phase40_moonlight_strength_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_phase40_final_judgment_01_v3_64k.mp3"},
        ["月光枷锁"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_moon_shackle_bind_steps_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_moon_shackle_defier_still_01_v3_64k.mp3"},
        ["精灵箭阵"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_arrow_array_archers_position_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_arrow_array_royal_arrow_line_01_v3_64k.mp3"},
        ["审判之环"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_judgment_ring_step_wrongly_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_judgment_ring_colors_fate_01_v3_64k.mp3"},
        ["罪与罚"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_sin_punishment_never_parted_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_sin_punishment_choice_sentence_01_v3_64k.mp3"},
        ["律法召唤"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_law_summon_enforcers_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_law_summon_chains_01_v3_64k.mp3"},
        ["月光灌注"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_moon_infusion_blade_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_moon_infusion_end_conflict_01_v3_64k.mp3"},
        ["精灵神罚"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_elven_smite_time_up_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_elven_smite_no_mercy_01_v3_64k.mp3"},
        ["终末审判"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_final_judgment_silence_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_final_judgment_erased_01_v3_64k.mp3"},
        ["胜利"] = {"Sound\\Boss\\Thranduil\\Voice\\thranduil_defeat_order_not_die_03_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_defeat_grove_peace_01_v3_64k.mp3", "Sound\\Boss\\Thranduil\\Voice\\thranduil_defeat_moonlight_path_01_v3_64k.mp3"}
    }
}
return ____exports
