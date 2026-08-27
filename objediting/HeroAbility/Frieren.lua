-- 芙莉莲 Q/W/E/R/D 通魔物编壳。实际机制与表现由 TS 接管。

local ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AFQ1', '芙莉莲-普通攻击魔法·Zoltraak（Q）', {
  editorSuffix = 'FrierenQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'carrionswarm',
  tooltip = '普通攻击魔法·Zoltraak（Q）', tooltipExtended = '沿目标方向发射基础贯穿魔法；解析联动与弹道伤害由 TS 处理。',
  icon = ICON, hotkey = 'Q', buttonX = 0, buttonY = 2, cooldown = 4, manaCost = 45,
})

createPlayerHeroChannelAbility('AFW1', '芙莉莲-防御魔法·魔力护壁（W）', {
  editorSuffix = 'FrierenW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = '防御魔法·魔力护壁（W）', tooltipExtended = '展开正面魔力护壁；防御解析和受击结算由 TS 处理。',
  icon = ICON, hotkey = 'W', buttonX = 1, buttonY = 2, cooldown = 10, manaCost = 75,
})

createPlayerHeroChannelAbility('AFE1', '芙莉莲-飞行魔法·高处观察（E）', {
  editorSuffix = 'FrierenE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'shockwave',
  tooltip = '飞行魔法·高处观察（E）', tooltipExtended = '升空观察目标区域并建立位置解析；高度、位移和落地由 TS 处理。',
  icon = ICON, hotkey = 'E', buttonX = 2, buttonY = 2, cooldown = 12, manaCost = 70,
})

createPlayerHeroChannelAbility('AFR1', '芙莉莲-解析魔法·贯穿射杀（R）', {
  editorSuffix = 'FrierenR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1200, orderId = 'monsoon',
  tooltip = '解析魔法·贯穿射杀（R）', tooltipExtended = '蓄力后发射窄幅贯穿魔法炮；解析快照和世界坐标进度条由 TS 处理。',
  icon = ICON, hotkey = 'R', buttonX = 3, buttonY = 2, cooldown = 75, manaCost = 150,
})

createPlayerHeroActiveDChannelAbility('AFD1', '芙莉莲-创造花田的魔法（D）', {
  editorSuffix = 'FrierenD', levels = 1,
  targetType = 2, castRange = 900, orderId = 'blizzard',
  tooltip = '创造花田的魔法（D）', tooltipExtended = '在目标区域创造花田并触发战斗化效果；区域、花朵和消散由 TS 处理。',
  icon = ICON, hotkey = 'D', buttonX = 0, buttonY = 1, cooldown = 18, manaCost = 60,
})
