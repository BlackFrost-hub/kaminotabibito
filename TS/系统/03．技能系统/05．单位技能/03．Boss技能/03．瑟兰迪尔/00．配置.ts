/** @noSelfInFile */

export const 瑟兰迪尔单位技能配置 = {
  单位ID: "N057",
  单位名: "精灵执法队长·瑟兰迪尔",
  单位目标技能900: "AT05",
  单位目标技能1000: "AT06",
  精灵箭阵技能: "AN00",
  律法召唤技能: "AN01",
  主动技能提示: [
    { 技能ID: "AT05", 提示: "月光枷锁" },
    { 技能ID: "AT06", 提示: "罪与罚" },
    { 技能ID: "AN00", 提示: "精灵箭阵" },
    { 技能ID: "AN01", 提示: "律法召唤" },
  ],
  广播持续时间Ms: 4200,
  配音裁断距离: 4000,
  配音生成配置: {
    显示台词字段: "台词",
    配音台词字段: "配音台词",
    声线名称: "Jude - Conversational British Podcaster",
    声线ID: "Yg7C1g7suzNt5TisIqkZ",
    模型ID: "eleven_v3",
    语言: "en",
    说明: "系统消息/广播显示继续使用中文台词；AI Voice 生成使用英文配音台词。情绪标签如 [angry] 仅适用于 eleven_v3，不要用 eleven_multilingual_v2 生成。",
  },
  台词: {
    开战: [
      "停下！在王城的圣洁之地挥动武器？你不知道这里的规矩吗？",
      "月光林地不容许任何争斗……即使是外来的旅者。",
      "我是瑟兰迪尔，王庭的执法者。放下武器投降，或者……接受秩序的审判。",
    ],
    转阶段70: [
      "警告无效……那么，接受审判吧！律法之环，展开！",
      "在这里，每一条罪行都将被称量！",
    ],
    转阶段40: [
      "秩序……必须维持！即使……代价是我的生命！",
      "月光啊，给予我最后的力量！",
      "以王庭之名……最终裁决！",
    ],
    月光枷锁: [
      "月光会替你停下脚步。",
      "违令者，接受束缚。",
    ],
    精灵箭阵: [
      "弓手就位，封锁他们的退路！",
      "王庭箭阵，展开！",
    ],
    审判之环: [
      "律法之环已经展开，站错位置就是罪证。",
      "审判开始，颜色会指出你的命运。",
    ],
    罪与罚: [
      "罪与罚从不分离。",
      "你的选择，将成为判决。",
    ],
    律法召唤: [
      "执法者，听令出列！",
      "秩序锁链会让逃避者付出代价。",
    ],
    月光灌注: [
      "月光啊，汇入我的刃锋。",
      "若审判不能结束纷争，那就让月光终结一切。",
    ],
    精灵神罚: [
      "时间已尽，精灵神罚降临！",
      "月光不再宽恕。",
    ],
    终末审判: [
      "全体肃静，终末审判开始！",
      "留在裁决之外，或被秩序抹去。",
    ],
    胜利: [
      "咳……你赢了……但秩序……不会因我而逝……",
      "记住……月光林地……需要和平……",
      "愿月光……指引你道路的……不是……武器……",
    ],
  },
  配音台词: {
    开战: [
      "[angry] Halt! [annoyed] Drawing your blade on the sacred ground of the royal city? [exasperated] Are you unaware of this realm's laws?",
      "[stern] No blood is to be spilled in Moonlit Grove. [cold] Not by outsiders. Not by anyone.",
      "[authoritative] I am Thranduil, enforcer of the royal court. [warning] Lay down your arms, or face the judgment of order.",
    ],
    转阶段70: [
      "[frustrated] So be it. The warning has failed. [commanding] Stand trial! Ring of Law, unfold!",
      "[severe] In this place, every offence is weighed beneath the moon.",
    ],
    转阶段40: [
      "[desperate] Order must endure! [fierce resolve] Even if my life is the price!",
      "[pleading] Moonlight, grant me your final strength.",
      "[fierce] By the authority of the royal court... final judgment!",
    ],
    月光枷锁: [
      "[controlled] Moonlight shall bind your steps.",
      "[stern] Defier, be still.",
    ],
    精灵箭阵: [
      "[commanding] Archers, take position. Seal their retreat!",
      "[urgent] Royal arrow line, loose!",
    ],
    审判之环: [
      "[measured] The Ring of Judgment is open. Step wrongly, and your guilt is proven.",
      "[cold] Judgment begins. The colors will name your fate.",
    ],
    罪与罚: [
      "[grim] Sin and punishment are never parted.",
      "[accusing] Your choice becomes your sentence.",
    ],
    律法召唤: [
      "[commanding] Enforcers, heed my command. Step forth!",
      "[severe] The chains of law will punish those who flee.",
    ],
    月光灌注: [
      "[focused] Moonlight, flow into my blade.",
      "[resolute] If judgment cannot end this conflict, then moonlight will.",
    ],
    精灵神罚: [
      "[wrathful] Time is up. Elven punishment descends!",
      "[cold fury] Moonlight offers no further mercy.",
    ],
    终末审判: [
      "[commanding] Silence, all of you. Final judgment begins!",
      "[ominous] Stand outside the verdict, or be erased by order.",
    ],
    胜利: [
      "[coughs weakly] You... have won... [weak and fading] but order will not die with me...",
      "[softly] Remember... Moonlit Grove... must know peace...",
      "[fading] May moonlight guide your path... not your weapons...",
    ],
  },
  配音资源: {
    开战: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_opening_law_warning_jude_02_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_opening_moonlit_grove_jude_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_opening_court_enforcer_jude_01_v3_64k.mp3",
    ],
    转阶段70: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_phase70_warning_failed_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_phase70_offences_weighed_01_v3_64k.mp3",
    ],
    转阶段40: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_phase40_order_endure_02_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_phase40_moonlight_strength_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_phase40_final_judgment_01_v3_64k.mp3",
    ],
    月光枷锁: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_moon_shackle_bind_steps_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_moon_shackle_defier_still_01_v3_64k.mp3",
    ],
    精灵箭阵: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_arrow_array_archers_position_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_arrow_array_royal_arrow_line_01_v3_64k.mp3",
    ],
    审判之环: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_judgment_ring_step_wrongly_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_judgment_ring_colors_fate_01_v3_64k.mp3",
    ],
    罪与罚: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_sin_punishment_never_parted_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_sin_punishment_choice_sentence_01_v3_64k.mp3",
    ],
    律法召唤: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_law_summon_enforcers_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_law_summon_chains_01_v3_64k.mp3",
    ],
    月光灌注: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_moon_infusion_blade_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_moon_infusion_end_conflict_01_v3_64k.mp3",
    ],
    精灵神罚: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_elven_smite_time_up_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_elven_smite_no_mercy_01_v3_64k.mp3",
    ],
    终末审判: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_final_judgment_silence_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_final_judgment_erased_01_v3_64k.mp3",
    ],
    胜利: [
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_defeat_order_not_die_03_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_defeat_grove_peace_01_v3_64k.mp3",
      "Sound\\Boss\\Thranduil\\Voice\\thranduil_defeat_moonlight_path_01_v3_64k.mp3",
    ],
  },
} as const;
