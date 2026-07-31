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
    { 技能ID: "A0LL", 提示: "扩散冲击波", 扩展提示: "蓄力1秒后以Boss为中心向360°发射16道外扩弹幕；每道命中一次造成Boss当前攻击力×200%伤害，命中目标的普通攻击伤害降低40%，持续7秒。预警半径620码（远离Boss）。" },
    { 技能ID: "A0LM", 提示: "消耗反击", 扩展提示: "正面防御持续3秒；正面270°内只承受原伤害的10%，受击后向攻击者发射反击弹幕，造成Boss当前攻击力×300%伤害并抽取其本次伤害值20%的魔法值。背后120°内攻击可破招，使本次伤害提高50%并令Boss硬直2秒（优先从背后攻击）。" },
    { 技能ID: "A0LN", 提示: "远古诅咒", 扩展提示: "点名目标等待3秒；第一段总伤害=点名目标结算时当前生命值×（60%+20%×N），N为当前有效玩家数且至少按1人计算，点名目标与其400码内玩家均分。第一段后所有有效玩家恢复等于该总伤害的生命值；N≥2时，1.8秒后在玩家中心650码内触发第二段。" },
    { 技能ID: "AN00", 提示: "树魔图腾", 扩展提示: "吟唱0.8秒后按存活随从抽取图腾：巫医→静止陷阱（600码触发，0.75秒后全体眩晕8秒）、猎头者→生命陷阱（持续20秒、影响半径900码、每秒造成目标最大生命3%并降低治疗50%+难度×5%）、投掷者→爆炸陷阱（10秒、被摧毁0.5秒后全体承受当前生命50%+难度×1800魔法伤害）；多种随从按存活数量加权，无随从时随机。" },
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
    开场: ["森林会记住你们踏入此地的脚步。（优先击杀随从，降低Boss最多80%的攻击力加成。）"],
    随从特性: ["族群仍在回应我的号令。（每个存活随从使Boss攻击力增加20%，最多4层；清空随从会触发攻速+100%、移速+50%的暴怒。）"],
    扩散冲击波: ["离我远点，或者被风撕开。（蓄力1秒后向360°外扩，远离Boss周围620码预警区。）"],
    消耗反击: ["来，攻击我的正面。（防御持续3秒，正面270°只承受10%伤害；绕到背后120°内可以破招。）"],
    远古诅咒: ["古老的诅咒会找到最脆弱的血肉。（被点名者停在原地让队友进入400码分摊圈；第一段后离开玩家中心650码预警区。）"],
    树魔图腾: ["图腾立起，猎场开始。（优先处理图腾：静止陷阱远离600码；生命陷阱每秒扣3%最大生命并降低治疗；爆炸图腾被摧毁后0.5秒全队受击。）"],
    死亡: ["部族...不会就此沉默...（战斗结束后确认随从与图腾已清理。）"],
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
