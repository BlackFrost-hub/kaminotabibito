-- 塞莉亚·克莱尔 Q/W/E/R/D 通魔物编壳。实际机制与表现由 TS 接管。

local ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AKQ1', '塞莉亚·克莱尔-棱晶魔弹（Q）', {
  editorSuffix = 'CeliaQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 3, castRange = 900, orderId = 'frostnova',
  tooltip = '棱晶魔弹（Q）', tooltipExtended = '发射棱晶魔弹并建立演算节点；折射、连接和伤害由 TS 处理。',
  icon = ICON, hotkey = 'Q', buttonX = 0, buttonY = 2, cooldown = 5, manaCost = 55,
})

createPlayerHeroChannelAbility('AKW1', '塞莉亚·克莱尔-解析结界（W）', {
  editorSuffix = 'CeliaW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = '解析结界（W）', tooltipExtended = '展开解析保护结界并建立节点；吸收与消耗反馈由 TS 处理。',
  icon = ICON, hotkey = 'W', buttonX = 1, buttonY = 2, cooldown = 10, manaCost = 75,
})

createPlayerHeroChannelAbility('AKE1', '塞莉亚·克莱尔-锚定魔法阵（E）', {
  editorSuffix = 'CeliaE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 900, orderId = 'shockwave',
  tooltip = '锚定魔法阵（E）', tooltipExtended = '在目标点建立锚定术式和节点；区域判定与控制由 TS 处理。',
  icon = ICON, hotkey = 'E', buttonX = 2, buttonY = 2, cooldown = 11, manaCost = 70,
})

createPlayerHeroChannelAbility('AKR1', '塞莉亚·克莱尔-高阶术式·闭锁（R）', {
  editorSuffix = 'CeliaR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'monsoon',
  tooltip = '高阶术式·闭锁（R）', tooltipExtended = '蓄力锁定节点快照并展开高阶公式；世界坐标进度条和闭锁结算由 TS 处理。',
  icon = ICON, hotkey = 'R', buttonX = 3, buttonY = 2, cooldown = 75, manaCost = 150,
})

createPlayerHeroActiveDChannelAbility('AKD1', '塞莉亚·克莱尔-术式转写（D）', {
  editorSuffix = 'CeliaD', levels = 1,
  targetType = 2, castRange = 900, orderId = 'blink',
  tooltip = '术式转写（D）', tooltipExtended = '选择并移动演算节点，重排公式连接；节点选择和移动由 TS 处理。',
  icon = ICON, hotkey = 'D', buttonX = 0, buttonY = 1, cooldown = 8, manaCost = 35,
})
