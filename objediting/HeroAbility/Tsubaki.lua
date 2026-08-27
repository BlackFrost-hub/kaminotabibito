-- 朱雀院椿 Q/W/E/R/D 通魔物编壳。实际机制与表现由 TS 接管。

local ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('ATQ1', '朱雀院椿-居合·返（Q）', {
  editorSuffix = 'TsubakiQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 650, orderId = 'carrionswarm',
  tooltip = '居合·返（Q）', tooltipExtended = '施展低前摇居合斩；返刃和反击准备联动由 TS 处理。',
  icon = ICON, hotkey = 'Q', buttonX = 0, buttonY = 2, cooldown = 5, manaCost = 40,
})

createPlayerHeroChannelAbility('ATW1', '朱雀院椿-VF场·后之先（W）', {
  editorSuffix = 'TsubakiW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = 'VF场·后之先（W）', tooltipExtended = '展开普通/完美招架窗口；真实伤害化解与反击由 TS 处理。',
  icon = ICON, hotkey = 'W', buttonX = 1, buttonY = 2, cooldown = 10, manaCost = 55,
})

createPlayerHeroChannelAbility('ATE1', '朱雀院椿-刃道·间合（E）', {
  editorSuffix = 'TsubakiE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 700, orderId = 'shockwave',
  tooltip = '刃道·间合（E）', tooltipExtended = '短距离调整间合并在终点横斩；位移、决斗距离与回锋由 TS 处理。',
  icon = ICON, hotkey = 'E', buttonX = 2, buttonY = 2, cooldown = 9, manaCost = 65,
})

createPlayerHeroChannelAbility('ATR1', '朱雀院椿-炎姬·黄泉凤凰（R）', {
  editorSuffix = 'TsubakiR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'monsoon',
  tooltip = '炎姬·黄泉凤凰（R）', tooltipExtended = '蓄势释放决斗终式；姿态、VF、反击分支和世界坐标进度条由 TS 处理。',
  icon = ICON, hotkey = 'R', buttonX = 3, buttonY = 2, cooldown = 70, manaCost = 140,
})

createPlayerHeroActiveDChannelAbility('ATD1', '朱雀院椿-浴火鸟·二刀解放（D）', {
  editorSuffix = 'TsubakiD', levels = 1,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'berserk',
  tooltip = '浴火鸟·二刀解放（D）', tooltipExtended = '切换一刀守势与二刀攻势；姿态资源和联动由 TS 处理。',
  icon = ICON, hotkey = 'D', buttonX = 0, buttonY = 1, cooldown = 8, manaCost = 25,
})
