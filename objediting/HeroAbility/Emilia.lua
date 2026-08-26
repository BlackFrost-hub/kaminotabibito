-- 爱蜜莉雅 Q/W/E/R/D 物编壳。
-- 这里只提供可施放、可识别的通魔入口；实际伤害、状态、特效和冷却由 TS 技能实现。
-- 图标先使用原生占位图，待对应 BLP 正式迁移后由运行时显示初始化替换。

local EMILIA_ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AEQ1', '爱蜜莉雅-冰之矢（Q）', {
  editorSuffix = 'EmiliaQ',
  heroAbility = true,
  levels = HERO_LEVELS,
  targetType = 3,
  castRange = 900,
  orderId = 'frostnova',
  tooltip = '冰之矢（Q）',
  tooltipExtended = '向目标方向发射冰之矢；实际冰晶联动与伤害由 TS 处理。',
  icon = EMILIA_ICON,
  hotkey = 'Q',
  buttonX = 0,
  buttonY = 2,
  cooldown = 5,
  manaCost = 60,
})

createPlayerHeroChannelAbility('AEW1', '爱蜜莉雅-冰花绽放（W）', {
  editorSuffix = 'EmiliaW',
  heroAbility = true,
  levels = HERO_LEVELS,
  targetType = 2,
  castRange = 900,
  orderId = 'blizzard',
  tooltip = '冰花绽放（W）',
  tooltipExtended = '在目标地点展开冰花区域；实际区域、寒意与二段由 TS 处理。',
  icon = EMILIA_ICON,
  hotkey = 'W',
  buttonX = 1,
  buttonY = 2,
  cooldown = 9,
  manaCost = 80,
})

createPlayerHeroChannelAbility('AEE1', '爱蜜莉雅-冰晶护身（E）', {
  editorSuffix = 'EmiliaE',
  heroAbility = true,
  levels = HERO_LEVELS,
  targetType = 2,
  castRange = 900,
  orderId = 'shockwave',
  tooltip = '冰晶护身（E）',
  tooltipExtended = '获得冰晶护盾并向目标方向调整位置；护盾与冰面表现由 TS 处理。',
  icon = EMILIA_ICON,
  hotkey = 'E',
  buttonX = 2,
  buttonY = 2,
  cooldown = 10,
  manaCost = 70,
})

createPlayerHeroChannelAbility('AER1', '爱蜜莉雅-永冻之庭（R）', {
  editorSuffix = 'EmiliaR',
  heroAbility = true,
  levels = HERO_LEVELS,
  targetType = 2,
  castRange = 1000,
  orderId = 'monsoon',
  tooltip = '永冻之庭（R）',
  tooltipExtended = '在目标区域展开永冻领域；实际读取冰晶、冻结与结算由 TS 处理。',
  icon = EMILIA_ICON,
  hotkey = 'R',
  buttonX = 3,
  buttonY = 2,
  cooldown = 70,
  manaCost = 140,
})

createPlayerHeroActiveDChannelAbility('AED1', '爱蜜莉雅-帕克显现（D）', {
  editorSuffix = 'EmiliaD',
  levels = 1,
  targetType = 0,
  castRange = 0,
  targetsAllowed = '',
  orderId = 'roar',
  tooltip = '帕克显现（D）',
  tooltipExtended = '召唤帕克协战并获得强化机会；持续时间与强化资源由 TS 处理。',
  icon = EMILIA_ICON,
  hotkey = 'D',
  buttonX = 0,
  buttonY = 1,
  cooldown = 15,
  manaCost = 40,
})

