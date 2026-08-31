-- 伊蕾娜 Q/W/E/R/D 通魔物编壳；通魔持续字段承载动态百分比蓝耗。

local ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AIQ1', '伊蕾娜-旅风·追迹（Q）', {
  editorSuffix = 'IrenaQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 3, castRange = 900, orderId = 'frostnova',
  tooltip = '旅风·追迹（Q）', tooltipExtended = '技能说明：向目标方向发射追踪魔弹，命中后记录旅途见闻；已有镜界或远行路线时会追加联动魔法。|n伤害：主弹造成攻击力100%的魔法伤害。|n施法距离：900|n伤害范围：命中半径100|n减速：20%，持续1.2秒|n冷却时间：5秒|n魔法消耗：最大魔法值的5%',
  icon = ICON, hotkey = 'Q', buttonX = 0, buttonY = 2, cooldown = 5, percentManaCost = 0.05,
})

createPlayerHeroChannelAbility('AIW1', '伊蕾娜-镜界护符（W）', {
  editorSuffix = 'IrenaW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = '镜界护符（W）', tooltipExtended = '技能说明：展开镜界保护，首次受到的主要攻击会被完整偏折，结束时对周围敌人施加减速。|n伤害：本技能不直接造成伤害；成功偏折会记录一次镜界见闻，并在选择镜界变式时追加护盾。|n防御范围：自身，保护期间首次有效敌方攻击|n减速范围：半径350|n减速：35%，持续2秒|n保护持续时间：4秒|n冷却时间：10秒|n魔法消耗：最大魔法值的7%',
  icon = ICON, hotkey = 'W', buttonX = 1, buttonY = 2, cooldown = 10, percentManaCost = 0.07,
})

createPlayerHeroChannelAbility('AIE1', '伊蕾娜-扫帚·远行（E）', {
  editorSuffix = 'IrenaE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'shockwave',
  tooltip = '扫帚·远行（E）', tooltipExtended = '技能说明：骑乘扫帚向目标方向飞行，落地时冲击周围敌人，并在飞行路径上留下路线。|n伤害：落点造成攻击力110%的魔法伤害。|n施法距离：飞行550距离|n伤害范围：落点半径260|n减速：25%，持续1.5秒|n飞行高度：约220|n路线持续时间：6秒|n冷却时间：12秒|n魔法消耗：最大魔法值的7.5%',
  icon = ICON, hotkey = 'E', buttonX = 2, buttonY = 2, cooldown = 12, percentManaCost = 0.075,
})

createPlayerHeroChannelAbility('AIR1', '伊蕾娜-灰之魔女·万法回廊（R）', {
  editorSuffix = 'IrenaR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'monsoon',
  tooltip = '灰之魔女·万法回廊（R）', tooltipExtended = '技能说明：蓄力后展开万法回廊，先进行主结算，随后在领域内持续施法，并追加已记录的见闻魔法。|n伤害：主结算造成攻击力220%的魔法伤害；领域内每秒脉冲造成攻击力45%的魔法伤害。|n施法距离：1000，指定目标方向|n伤害范围：回廊半径450|n减速：40%，持续2.5秒|n蓄力时间：1.5秒|n领域持续时间：5秒|n追加见闻：最多3类|n冷却时间：70秒|n魔法消耗：最大魔法值的14%',
  icon = ICON, hotkey = 'R', buttonX = 3, buttonY = 2, cooldown = 70, percentManaCost = 0.14,
})

createPlayerHeroActiveDChannelAbility('AID1', '伊蕾娜-旅途魔法变式（D）', {
  editorSuffix = 'IrenaD', levels = 1,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'berserk',
  tooltip = '旅途魔法变式（D）', tooltipExtended = '技能说明：切换下一次Q、W、E或R使用的魔法变式，按固定顺序选择迅行、镜界与灰烬。|n伤害：本技能不直接造成伤害。|n技能类型：天赋技能，初始获得|n变式保留时间：最多30秒|n冷却时间：4秒|n魔法消耗：最大魔法值的2%',
  icon = ICON, hotkey = 'D', buttonX = 0, buttonY = 1, cooldown = 4, percentManaCost = 0.02,
})
