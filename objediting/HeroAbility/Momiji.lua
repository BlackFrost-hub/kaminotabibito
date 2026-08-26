-- 朱雀院红叶 Q/W/E/R/D 物编壳。
-- 实际机制由 TS 接管；Q2 复用全局 ASQ2 二段输入壳。

local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AMQ1', '朱雀院红叶-飞燕·穿（Q）', {
  editorSuffix = 'MomijiQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 800, orderId = 'carrionswarm',
  tooltip = '飞燕·穿（Q）',
  tooltipExtended = '向目标方向突进斩击；二段输入、破绽和刀势联动由 TS 处理。',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiQ.blp', hotkey = 'Q', buttonX = 0, buttonY = 2,
  cooldown = 6, manaCost = 45,
})

createPlayerHeroChannelAbility('AMW1', '朱雀院红叶-水镜·返刃（W）', {
  editorSuffix = 'MomijiW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = '水镜·返刃（W）',
  tooltipExtended = '展开正面招架窗口；招架判定与反击由 TS 处理。',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiW.blp', hotkey = 'W', buttonX = 1, buttonY = 2,
  cooldown = 10, manaCost = 55,
})

createPlayerHeroChannelAbility('AME1', '朱雀院红叶-三叶·散华（E）', {
  editorSuffix = 'MomijiE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 650, orderId = 'shockwave',
  tooltip = '三叶·散华（E）',
  tooltipExtended = '朝目标方向连续施展三段斩击并留下剑痕；实际结算由 TS 处理。',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiE.blp', hotkey = 'E', buttonX = 2, buttonY = 2,
  cooldown = 9, manaCost = 65,
})

createPlayerHeroChannelAbility('AMR1', '朱雀院红叶-奥义·红叶一闪（R）', {
  editorSuffix = 'MomijiR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'monsoon',
  tooltip = '奥义·红叶一闪（R）',
  tooltipExtended = '朝目标方向蓄势并释放窄直线终式；蓄力和世界坐标进度条由 TS 处理。',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiR.blp', hotkey = 'R', buttonX = 3, buttonY = 2,
  cooldown = 65, manaCost = 130,
})

createPlayerHeroActiveDChannelAbility('AMD1', '朱雀院红叶-朱雀流·秘传三式（D）', {
  editorSuffix = 'MomijiD', levels = 1,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'berserk',
  tooltip = '朱雀流·秘传三式（D）',
  tooltipExtended = '进入秘传状态并获得三次技能强化机会；强化分配由 TS 处理。',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiD.blp', hotkey = 'D', buttonX = 0, buttonY = 1,
  cooldown = 18, manaCost = 50,
})
