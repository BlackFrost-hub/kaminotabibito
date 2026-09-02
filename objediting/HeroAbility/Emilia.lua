-- 爱蜜莉雅 Q/W/E/R/D 物编壳。
-- 技能效果由运行时实现；通魔持续字段承载动态百分比蓝耗，固定基础蓝耗与百分比蓝耗由运行时叠加计算。
local ICONS = {
  Q = 'ReplaceableTextures\\CommandButtons\\Emilia\\BTNEmiliaQ.blp',
  W = 'ReplaceableTextures\\CommandButtons\\Emilia\\BTNEmiliaW.blp',
  E = 'ReplaceableTextures\\CommandButtons\\Emilia\\BTNEmiliaE.blp',
  R = 'ReplaceableTextures\\CommandButtons\\Emilia\\BTNEmiliaR.blp',
  D = 'ReplaceableTextures\\CommandButtons\\Emilia\\BTNEmiliaD.blp',
}
local DISABLED_ICONS = {
  Q = 'ReplaceableTextures\\CommandButtonsDisabled\\Emilia\\DISBTNEmiliaQ.blp',
  W = 'ReplaceableTextures\\CommandButtonsDisabled\\Emilia\\DISBTNEmiliaW.blp',
  E = 'ReplaceableTextures\\CommandButtonsDisabled\\Emilia\\DISBTNEmiliaE.blp',
  R = 'ReplaceableTextures\\CommandButtonsDisabled\\Emilia\\DISBTNEmiliaR.blp',
  D = 'ReplaceableTextures\\CommandButtonsDisabled\\Emilia\\DISBTNEmiliaD.blp',
}
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AEQ1', '爱蜜莉雅-冰之矢（Q）', {
  editorSuffix = 'EmiliaQ',
  heroAbility = true,
  levels = HERO_LEVELS,
  targetType = 3,
  castRange = 900,
  orderId = 'frostnova',
  tooltip = '冰之矢（Q）',
  tooltipExtended = '技能说明：向目标方向发射冰之矢，穿过冰晶后会分裂成冰刃。|n伤害：主矢造成攻击力120%的魔法伤害；每枚冰刃造成攻击力40%的魔法伤害。|n施法距离：900|n伤害范围：命中半径100|n冷却时间：5秒|n魔法消耗：最大魔法值的6%',
  icon = ICONS.Q, iconTurnOff = DISABLED_ICONS.Q,
  hotkey = 'Q',
  buttonX = 0,
  buttonY = 2,
  cooldown = 5,
  manaCost = 50,
  percentManaCost = 0.06,
})

createPlayerHeroChannelAbility('AEW1', '爱蜜莉雅-冰花绽放（W）', {
  editorSuffix = 'EmiliaW',
  heroAbility = true,
  levels = HERO_LEVELS,
  targetType = 2,
  castRange = 900,
  orderId = 'blizzard',
  tooltip = '冰花绽放（W）',
  tooltipExtended = '技能说明：在目标地点展开冰花区域，冰花出现和结束时都会造成伤害，再次施放可提前引爆并发射冰片。|n伤害：展开时造成攻击力60%的魔法伤害；自然结束造成攻击力90%的魔法伤害；提前引爆造成攻击力120%的魔法伤害；每枚冰片造成攻击力30%的魔法伤害。|n伤害范围：半径350|n减速：区域内敌人减速30%|n持续时间：4秒|n冷却时间：9秒|n魔法消耗：最大魔法值的8%',
  icon = ICONS.W, iconTurnOff = DISABLED_ICONS.W,
  hotkey = 'W',
  buttonX = 1,
  buttonY = 2,
  cooldown = 9,
  manaCost = 100,
  percentManaCost = 0.08,
})

createPlayerHeroChannelAbility('AEE1', '爱蜜莉雅-冰晶护身（E）', {
  editorSuffix = 'EmiliaE',
  heroAbility = true,
  levels = HERO_LEVELS,
  targetType = 2,
  castRange = 900,
  orderId = 'shockwave',
  tooltip = '冰晶护身（E）',
  tooltipExtended = '技能说明：向目标方向移动，并召唤冰晶护盾保护自己；移动结束时攻击落点附近的敌人，护盾破碎时再次造成伤害。|n伤害：落点冰爆和破盾冰爆各造成攻击力80%的魔法伤害。|n护盾：护盾值为攻击力的300%|n施法距离：移动400距离|n伤害范围：落点半径260|n护盾持续时间：4秒|n冷却时间：10秒|n魔法消耗：最大魔法值的7%',
  icon = ICONS.E, iconTurnOff = DISABLED_ICONS.E,
  hotkey = 'E',
  buttonX = 2,
  buttonY = 2,
  cooldown = 10,
  manaCost = 150,
  percentManaCost = 0.07,
})

createPlayerHeroChannelAbility('AER1', '爱蜜莉雅-永冻之庭（R）', {
  editorSuffix = 'EmiliaR',
  heroAbility = true,
  levels = HERO_LEVELS,
  targetType = 2,
  castRange = 1000,
  orderId = 'monsoon',
  tooltip = '永冻之庭（R）',
  tooltipExtended = '技能说明：蓄力后在目标区域展开永冻领域，领域期间持续攻击范围内的敌人，读取冰晶后引发爆发。|n伤害：领域内每秒造成攻击力15%的魔法伤害；每枚读取的冰晶爆发造成攻击力80%的魔法伤害；领域结束时造成攻击力200%的最终冰爆伤害。|n伤害范围：半径600（帕克强化时半径780）|n减速：最终冰爆使敌人减速30%|n蓄力时间：0.6秒|n领域持续时间：5秒|n冷却时间：70秒|n魔法消耗：最大魔法值的14%',
  icon = ICONS.R, iconTurnOff = DISABLED_ICONS.R,
  hotkey = 'R',
  buttonX = 3,
  buttonY = 2,
  cooldown = 70,
  manaCost = 300,
  percentManaCost = 0.14,
})

createPlayerHeroActiveDChannelAbility('AED1', '爱蜜莉雅-帕克显现（D）', {
  editorSuffix = 'EmiliaD',
  levels = 1,
  targetType = 0,
  castRange = 0,
  targetsAllowed = '',
  orderId = 'roar',
  tooltip = '帕克显现（D）',
  tooltipExtended = '技能说明：召唤帕克协战，并获得冰系技能强化机会。|n伤害：本技能不直接造成伤害。|n技能类型：天赋技能，初始获得|n强化次数：最多3次|n帕克持续时间：12秒|n冷却时间：15秒|n魔法消耗：最大魔法值的4%',
  icon = ICONS.D, iconTurnOff = DISABLED_ICONS.D,
  hotkey = 'D',
  buttonX = 0,
  buttonY = 1,
  cooldown = 15,
  manaCost = 30,
  percentManaCost = 0.04,
})
