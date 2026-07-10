/** @noSelfInFile */

export const 树魔首领单位技能配置 = {
  单位ID: "N05S",
  单位名称: "树魔首领",
  Boss单位ID: "N05S",
  技能壳: {
    扩散冲击波: "A0LL",
    消耗反击: "A0LM",
    远古诅咒: "A0LN",
    树魔图腾: "AN00",
  },
  主动技能提示: [
    { 技能ID: "A0LL", 提示: "扩散冲击波", 扩展提示: "蓄力后向周围发射风属性冲击波，并降低命中目标攻击力。" },
    { 技能ID: "A0LM", 提示: "消耗反击", 扩展提示: "进入正面防御姿态，受到正面伤害时反击并削减目标魔法值。" },
    { 技能ID: "A0LN", 提示: "远古诅咒", 扩展提示: "点名玩家承受可分摊诅咒，并在分摊后触发中心区域爆发。" },
    { 技能ID: "AN00", 提示: "树魔图腾", 扩展提示: "根据场上随从类型在场地中央放置静止、生命或爆炸陷阱。" },
  ],
  召唤物ID: {
    猎头者: "ohun",
    巫医: "odoc",
    投掷者: "h00U",
    静止陷阱: "待接入",
    生命陷阱: "待接入",
    爆炸陷阱: "待接入",
  },
  广播持续时间Ms: 4200,
  配音裁断距离: 4000,
  配音生成配置: {
    显示台词字段: "台词",
    配音台词字段: "配音台词",
    声线名称: "Dante - Growly and Menacing Monster",
    声线ID: "wXvR48IpOq9HACltTmt7",
    模型ID: "eleven_v3",
    语言: "en",
    整体提示词: "An ancient forest troll chieftain and voodoo war-shaman. Gravelly monstrous authority, tribal command, predatory intelligence, and dark ritual menace. Speak clearly at a forceful Warcraft-style battle pace, with restrained growls and rough breath. Not a mindless beast, not an ogre, not a tree spirit, and not a theatrical human villain.",
    说明: "树魔首领按森林巨魔酋长兼巫毒萨满处理。号令与技能台词强调部族权威、猎场警告和挑衅；诅咒与图腾强调古老巫毒；死亡保持强撑与部族执念。避免纯怪吼、食人魔憨重感和古树精灵感。",
  },
  台词: {
    开场: ["森林会记住你们踏入此地的脚步。"],
    随从特性: ["族群仍在回应我的号令。"],
    扩散冲击波: ["离我远点，或者被风撕开。"],
    消耗反击: ["来，攻击我的正面。"],
    远古诅咒: ["古老的诅咒会找到最脆弱的血肉。"],
    树魔图腾: ["图腾立起，猎场开始。"],
    死亡: ["部族...不会就此沉默..."],
  },
  配音台词: {
    开场: ["[low tribal warning] The forest remembers every step you took into our hunting grounds."],
    随从特性: ["[commanding roar] My tribe still answers the chief's call."],
    扩散冲击波: ["[thunderous warning] Get back! [furious threat] Or the storm will tear the flesh from your bones!"],
    消耗反击: ["[challenging] Face me, then. Strike the chief head-on."],
    远古诅咒: ["[grave shamanic warning] The old curse has found you. [venomous menace] It always feeds on the weakest flesh."],
    树魔图腾: ["[booming ritual command] Raise the totem! [predatory warning] The hunting ground is sealed. There will be no escape!"],
    死亡: ["[dying defiance] The tribe... [final growl] will not be silenced with me..."],
  },
  配音资源: {
    开场: ["Sound\\Boss\\TrollChief\\Voice\\troll_chief_opening_hunting_grounds_dante_01_v3.mp3"],
    随从特性: ["Sound\\Boss\\TrollChief\\Voice\\troll_chief_minion_tribe_answers_dante_01_v3.mp3"],
    扩散冲击波: ["Sound\\Boss\\TrollChief\\Voice\\troll_chief_shockwave_wind_tear_dante_02_heavy_warning_v3.mp3"],
    消耗反击: ["Sound\\Boss\\TrollChief\\Voice\\troll_chief_counter_face_me_dante_01_v3.mp3"],
    远古诅咒: ["Sound\\Boss\\TrollChief\\Voice\\troll_chief_ancient_curse_weakest_flesh_dante_02_heavy_warning_v3.mp3"],
    树魔图腾: ["Sound\\Boss\\TrollChief\\Voice\\troll_chief_totem_hunt_begins_dante_02_heavy_warning_v3.mp3"],
    死亡: ["Sound\\Boss\\TrollChief\\Voice\\troll_chief_death_tribe_not_silenced_dante_01_v3.mp3"],
  },
} as const;

export type 树魔首领台词类型 = keyof typeof 树魔首领单位技能配置.台词;
