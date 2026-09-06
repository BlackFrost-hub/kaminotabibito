-- 塞莉亚·克莱尔 Q/W/E/R/D 通魔物编壳；通魔持续字段承载动态百分比蓝耗。

local ICONS = {
  Q = 'ReplaceableTextures\\CommandButtons\\Celia\\BTNCeliaQ.blp',
  W = 'ReplaceableTextures\\CommandButtons\\Celia\\BTNCeliaW.blp',
  E = 'ReplaceableTextures\\CommandButtons\\Celia\\BTNCeliaE.blp',
  R = 'ReplaceableTextures\\CommandButtons\\Celia\\BTNCeliaR.blp',
  D = 'ReplaceableTextures\\CommandButtons\\Celia\\BTNCeliaD.blp',
}
local DISABLED_ICONS = {
  Q = 'ReplaceableTextures\\CommandButtonsDisabled\\Celia\\DISBTNCeliaQ.blp',
  W = 'ReplaceableTextures\\CommandButtonsDisabled\\Celia\\DISBTNCeliaW.blp',
  E = 'ReplaceableTextures\\CommandButtonsDisabled\\Celia\\DISBTNCeliaE.blp',
  R = 'ReplaceableTextures\\CommandButtonsDisabled\\Celia\\DISBTNCeliaR.blp',
  D = 'ReplaceableTextures\\CommandButtonsDisabled\\Celia\\DISBTNCeliaD.blp',
}
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AKQ1', '塞莉亚·克莱尔-棱晶魔弹（Q）', {
  editorSuffix = 'CeliaQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 3, castRange = 900, orderId = 'frostnova',
  tooltip = '棱晶魔弹（Q）', tooltipExtended = '技能说明：向目标方向发射棱晶魔弹，命中后建立演算节点；场上的节点可使后续魔弹折射、穿透或追踪。|n伤害：主弹造成攻击力150%的魔法伤害；联动追加伤害最高为攻击力90%。|n施法距离：900|n伤害范围：命中半径100|n节点数量：最多2个|n冷却时间：5秒|n魔法消耗：最大魔法值的5.5%',
  icon = ICONS.Q, iconTurnOff = DISABLED_ICONS.Q, hotkey = 'Q', buttonX = 0, buttonY = 2, cooldown = 5, manaCost = 50, percentManaCost = 0.055,
})

createPlayerHeroChannelAbility('AKW1', '塞莉亚·克莱尔-解析结界（W）', {
  editorSuffix = 'CeliaW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = '解析结界（W）', tooltipExtended = '技能说明：展开解析结界并获得护盾；成功防御时化解一次主要攻击并反冲攻击来源，结束时使范围内敌人减速。|n伤害：成功防御会反冲攻击来源。|n护盾：护盾值为攻击力的150%|n结界范围：半径320|n减速范围：半径350|n减速持续时间：2秒|n结界持续时间：4秒|n冷却时间：10秒|n魔法消耗：最大魔法值的7.5%',
  icon = ICONS.W, iconTurnOff = DISABLED_ICONS.W, hotkey = 'W', buttonX = 1, buttonY = 2, cooldown = 10, manaCost = 100, percentManaCost = 0.075,
})

createPlayerHeroChannelAbility('AKE1', '塞莉亚·克莱尔-锚定魔法阵（E）', {
  editorSuffix = 'CeliaE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 900, orderId = 'shockwave',
  tooltip = '锚定魔法阵（E）', tooltipExtended = '技能说明：在目标点展开锚定魔法阵，敌人在阵中停留会逐渐被锁定。|n伤害：生效时造成攻击力170%的魔法伤害。|n施法距离：目标点|n伤害范围：半径300|n减速：35%，持续2秒|n定身条件：停留1.8秒|n定身时间：1.2秒|n魔法阵持续时间：4秒|n冷却时间：11秒|n魔法消耗：最大魔法值的7%',
  icon = ICONS.E, iconTurnOff = DISABLED_ICONS.E, hotkey = 'E', buttonX = 2, buttonY = 2, cooldown = 11, manaCost = 150, percentManaCost = 0.07,
})

createPlayerHeroChannelAbility('AKR1', '塞莉亚·克莱尔-高阶术式·闭锁（R）', {
  editorSuffix = 'CeliaR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'monsoon',
  tooltip = '高阶术式·闭锁（R）', tooltipExtended = '技能说明：蓄力后锁定范围内的演算节点与连接，并根据连接类型释放不同的高阶术式。|n伤害：基础造成攻击力260%的魔法伤害；连接分支追加折射弹、穿透炮或封锁爆裂。|n锁定范围：半径450|n减速：40%，持续2.5秒|n控制：短暂硬直|n蓄力时间：1.5秒|n冷却时间：75秒|n魔法消耗：最大魔法值的15%',
  icon = ICONS.R, iconTurnOff = DISABLED_ICONS.R, hotkey = 'R', buttonX = 3, buttonY = 2, cooldown = 75, manaCost = 300, percentManaCost = 0.15,
})

createPlayerHeroActiveDChannelAbility('AKD1', '塞莉亚·克莱尔-术式转写（D）', {
  editorSuffix = 'CeliaD', levels = 1,
  targetType = 2, castRange = 900, orderId = 'blink',
  tooltip = '术式转写（D）', tooltipExtended = '技能说明：选择一个演算节点并将其移动到目标点，同时重新排列节点之间的连接；没有节点时会在脚下建立临时节点。|n伤害：本技能不直接造成伤害。|n技能类型：天赋技能，初始获得|n施法范围：目标点|n临时节点持续时间：6秒|n冷却时间：8秒|n魔法消耗：最大魔法值的3.5%',
  icon = ICONS.D, iconTurnOff = DISABLED_ICONS.D, hotkey = 'D', buttonX = 0, buttonY = 1, cooldown = 8, manaCost = 30, percentManaCost = 0.035,
})
