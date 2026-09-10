-- 熔浆鱼王（n06O）技能壳：通魔(Channel)基座，效果由运行时 TS 监听命令串实现。
-- 命名沿用项目 Boss 壳规律：A + Boss字母 + 技能键 + 数字 → AUQ1。
-- 注意：壳只是"容器"，真实效果在 TS（见 05．单位技能/03．Boss技能/02．挑战与隐藏Boss/02．熔浆鱼王），
-- 并且技能显示名会在运行时按单位再改一次（见该模块的 主动技能提示）。

createPlayerHeroChannelAbility('AUQ1', '熔浆鱼王-熔岩冲击', {
  editorSuffix = 'MoltenFishKingQ',
  -- 怪物技能：不占英雄技能位，也不进物品栏。
  heroAbility = false,
  levels = 1,
  -- 点目标技能：朝目标地点喷吐熔岩。
  targetType = 2,
  castRange = 700,
  targetsAllowed = 'ground,enemy,neutral',
  orderId = 'flamestrike',
  tooltip = '熔岩冲击',
  tooltipExtended = '技能说明：朝目标地点喷出熔岩，对范围内敌人造成伤害。',
  icon = 'ReplaceableTextures\\CommandButtons\\BTNFlameStrike.blp',
  hotkey = 'Q',
  cooldown = 12,
  manaCost = 100,
})

-- 第二个技能：熔渊新星（AUW1）。无目标、以自身为中心的近身爆发，
-- 惩罚贴脸输出；与熔岩冲击（拉远喷）形成一近一远的简单节奏。
createPlayerHeroChannelAbility('AUW1', '熔浆鱼王-熔渊新星', {
  editorSuffix = 'MoltenFishKingW',
  heroAbility = false,
  levels = 1,
  -- 无目标技能：以施法者自身为中心。
  targetType = 0,
  castRange = 0,
  targetsAllowed = '',
  orderId = 'thunderclap',
  tooltip = '熔渊新星',
  tooltipExtended = '技能说明：以自身为中心炸开熔岩，对周围敌人造成伤害。',
  icon = 'ReplaceableTextures\\CommandButtons\\BTNThunderClap.blp',
  hotkey = 'W',
  cooldown = 20,
  manaCost = 120,
})
