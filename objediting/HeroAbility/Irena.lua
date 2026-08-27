-- 伊蕾娜 Q/W/E/R/D 通魔物编壳。实际机制与表现由 TS 接管。

local ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AIQ1', '伊蕾娜-旅风·追迹（Q）', {
  editorSuffix = 'IrenaQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 3, castRange = 900, orderId = 'frostnova',
  tooltip = '旅风·追迹（Q）', tooltipExtended = '发射追迹魔弹并记录风行见闻；弹道和联动由 TS 处理。',
  icon = ICON, hotkey = 'Q', buttonX = 0, buttonY = 2, cooldown = 5, manaCost = 50,
})

createPlayerHeroChannelAbility('AIW1', '伊蕾娜-镜界护符（W）', {
  editorSuffix = 'IrenaW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = '镜界护符（W）', tooltipExtended = '展开镜界保护并记录镜界见闻；保护与偏折由 TS 处理。',
  icon = ICON, hotkey = 'W', buttonX = 1, buttonY = 2, cooldown = 10, manaCost = 70,
})

createPlayerHeroChannelAbility('AIE1', '伊蕾娜-扫帚·远行（E）', {
  editorSuffix = 'IrenaE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'shockwave',
  tooltip = '扫帚·远行（E）', tooltipExtended = '沿目标方向进行扫帚飞行并记录远行见闻；位移高度和路线由 TS 处理。',
  icon = ICON, hotkey = 'E', buttonX = 2, buttonY = 2, cooldown = 12, manaCost = 75,
})

createPlayerHeroChannelAbility('AIR1', '伊蕾娜-灰之魔女·万法回廊（R）', {
  editorSuffix = 'IrenaR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'monsoon',
  tooltip = '灰之魔女·万法回廊（R）', tooltipExtended = '蓄力展开万法回廊并读取见闻；世界坐标进度条和领域结算由 TS 处理。',
  icon = ICON, hotkey = 'R', buttonX = 3, buttonY = 2, cooldown = 70, manaCost = 140,
})

createPlayerHeroActiveDChannelAbility('AID1', '伊蕾娜-旅途魔法变式（D）', {
  editorSuffix = 'IrenaD', levels = 1,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'berserk',
  tooltip = '旅途魔法变式（D）', tooltipExtended = '切换下一次技能采用的即兴变式；选择、锁定与消费由 TS 处理。',
  icon = ICON, hotkey = 'D', buttonX = 0, buttonY = 1, cooldown = 4, manaCost = 20,
})
