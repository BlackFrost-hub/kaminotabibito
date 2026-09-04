-- 芙莉莲 Q/W/E/R/D 通魔物编壳；通魔持续字段承载动态百分比蓝耗。

local ICONS = {
  Q = 'ReplaceableTextures\\CommandButtons\\Frieren\\BTNFrierenQ.blp',
  W = 'ReplaceableTextures\\CommandButtons\\Frieren\\BTNFrierenW.blp',
  E = 'ReplaceableTextures\\CommandButtons\\Frieren\\BTNFrierenE.blp',
  R = 'ReplaceableTextures\\CommandButtons\\Frieren\\BTNFrierenR.blp',
  D = 'ReplaceableTextures\\CommandButtons\\Frieren\\BTNFrierenD.blp',
}
local DISABLED_ICONS = {
  Q = 'ReplaceableTextures\\CommandButtonsDisabled\\Frieren\\DISBTNFrierenQ.blp',
  W = 'ReplaceableTextures\\CommandButtonsDisabled\\Frieren\\DISBTNFrierenW.blp',
  E = 'ReplaceableTextures\\CommandButtonsDisabled\\Frieren\\DISBTNFrierenE.blp',
  R = 'ReplaceableTextures\\CommandButtonsDisabled\\Frieren\\DISBTNFrierenR.blp',
  D = 'ReplaceableTextures\\CommandButtonsDisabled\\Frieren\\DISBTNFrierenD.blp',
}
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AFQ1', '芙莉莲-普通攻击魔法·Zoltraak（Q）', {
  editorSuffix = 'FrierenQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'carrionswarm',
  tooltip = '普通攻击魔法·Zoltraak（Q）', tooltipExtended = '技能说明：向目标方向发射直线贯穿魔法，命中后对解析目标追加伤害。|n伤害：基础造成攻击力110%的魔法伤害；防御解析目标额外受到攻击力50%的魔法伤害；解析完成目标额外受到攻击力80%的魔法伤害。|n施法距离：1000|n伤害范围：窄直线，命中半径80|n冷却时间：4秒|n魔法消耗：最大魔法值的4.5%',
  icon = ICONS.Q, iconTurnOff = DISABLED_ICONS.Q, hotkey = 'Q', buttonX = 0, buttonY = 2, cooldown = 4, manaCost = 50, percentManaCost = 0.045,
})

createPlayerHeroChannelAbility('AFW1', '芙莉莲-防御魔法·魔力护壁（W）', {
  editorSuffix = 'FrierenW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = '防御魔法·魔力护壁（W）', tooltipExtended = '技能说明：展开正面魔力护壁，成功时完整化解一次主要攻击；自然结束后获得护盾。|n伤害：本技能不直接造成伤害；成功招架会记录一次防御解析，供后续Q或R强化。|n防御范围：正面100度|n招架窗口：1.2秒|n护盾：护盾值为攻击力的120%，持续3秒|n花田效果：花田内施放时护壁持续时间增加0.4秒|n冷却时间：10秒|n魔法消耗：最大魔法值的7.5%',
  icon = ICONS.W, iconTurnOff = DISABLED_ICONS.W, hotkey = 'W', buttonX = 1, buttonY = 2, cooldown = 10, manaCost = 100, percentManaCost = 0.075,
})

createPlayerHeroChannelAbility('AFE1', '芙莉莲-飞行魔法·高处观察（E）', {
  editorSuffix = 'FrierenE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'shockwave',
  tooltip = '飞行魔法·高处观察（E）', tooltipExtended = '技能说明：升空并向目标方向飞行，在高处观察周围；落地时冲击敌人，飞行期间降低受到的伤害。|n伤害：落地造成攻击力60%的魔法伤害。|n施法距离：飞行600距离|n观察范围：半径500|n伤害范围：落点半径220|n飞行高度：约250|n观察持续时间：2秒|n伤害减免：40%|n冷却时间：12秒|n魔法消耗：最大魔法值的7%',
  icon = ICONS.E, iconTurnOff = DISABLED_ICONS.E, hotkey = 'E', buttonX = 2, buttonY = 2, cooldown = 12, manaCost = 150, percentManaCost = 0.07,
})

createPlayerHeroChannelAbility('AFR1', '芙莉莲-解析魔法·贯穿射杀（R）', {
  editorSuffix = 'FrierenR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1200, orderId = 'monsoon',
  tooltip = '解析魔法·贯穿射杀（R）', tooltipExtended = '技能说明：蓄力后沿目标方向发射窄幅贯穿魔法炮，解析效果会追加伤害或扩大命中宽度。|n伤害：基础造成攻击力220%的魔法伤害；攻击解析或防御解析目标额外受到攻击力20%的魔法伤害；解析完成目标额外受到攻击力100%的破防伤害和攻击力50%的爆发伤害；位置解析会使命中半宽扩大50%。|n施法距离：1200|n伤害范围：窄直线，命中半宽120|n蓄力时间：0.9秒|n冷却时间：25秒|n魔法消耗：最大魔法值的15%',
  icon = ICONS.R, iconTurnOff = DISABLED_ICONS.R, hotkey = 'R', buttonX = 3, buttonY = 2, cooldown = 25, manaCost = 300, percentManaCost = 0.15,
})

createPlayerHeroActiveDChannelAbility('AFD1', '芙莉莲-创造花田的魔法（D）', {
  editorSuffix = 'FrierenD', levels = 1,
  targetType = 2, castRange = 900, orderId = 'blizzard',
  tooltip = '创造花田的魔法（D）', tooltipExtended = '技能说明：在目标区域创造花田；花田不造成伤害，也不阻挡单位。花田内静止施法会加快隐匿准备，并强化Q、W或E。|n伤害：本技能不造成伤害。|n技能类型：天赋技能，初始获得|n花田范围：半径300|n花田持续时间：8秒|n花田效果：Q施法距离增加100；W护壁持续时间增加0.4秒；E落点伤害倍率增加0.2。|n冷却时间：18秒|n魔法消耗：最大魔法值的6%',
  icon = ICONS.D, iconTurnOff = DISABLED_ICONS.D, hotkey = 'D', buttonX = 0, buttonY = 1, cooldown = 18, manaCost = 30, percentManaCost = 0.06,
})
