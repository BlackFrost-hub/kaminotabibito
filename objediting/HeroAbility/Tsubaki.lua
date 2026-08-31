-- 朱雀院椿 Q/W/E/R/D 通魔物编壳；通魔持续字段承载动态百分比蓝耗。

local ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
local HERO_LEVELS = 15

createPlayerHeroChannelAbility('ATQ1', '朱雀院椿-居合·返（Q）', {
  editorSuffix = 'TsubakiQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 650, orderId = 'carrionswarm',
  tooltip = '居合·返（Q）', tooltipExtended = '技能说明：向目标方向施展居合斩；拥有回锋或反击准备时会改为返刃，二刀姿态还会追加交叉斩。|n伤害：基础斩造成攻击力90%的物理伤害。|n伤害范围：半径260、扇形60度|n冷却时间：5秒|n魔法消耗：最大魔法值的4%',
  icon = ICON, hotkey = 'Q', buttonX = 0, buttonY = 2, cooldown = 5, percentManaCost = 0.04,
})

createPlayerHeroChannelAbility('ATW1', '朱雀院椿-VF场·后之先（W）', {
  editorSuffix = 'TsubakiW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = 'VF场·后之先（W）', tooltipExtended = '技能说明：展开正面VF招架场，成功招架时化解一次主要攻击并反击，未受击则以收刀斩结束。|n伤害：反击造成攻击力100%的物理伤害；未受击时释放收刀斩。|n防御范围：正面90度|n招架持续时间：0.6秒|n冷却时间：10秒|n魔法消耗：最大魔法值的5.5%',
  icon = ICON, hotkey = 'W', buttonX = 1, buttonY = 2, cooldown = 10, percentManaCost = 0.055,
})

createPlayerHeroChannelAbility('ATE1', '朱雀院椿-刃道·间合（E）', {
  editorSuffix = 'TsubakiE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 700, orderId = 'shockwave',
  tooltip = '刃道·间合（E）', tooltipExtended = '技能说明：向目标方向位移，在终点施展横斩；二刀姿态会追加横斩，并建立决斗距离。|n伤害：横斩造成攻击力90%的物理伤害。|n施法距离：位移300距离|n伤害范围：半径240、扇形90度|n决斗距离持续时间：2.5秒|n冷却时间：9秒|n魔法消耗：最大魔法值的6.5%',
  icon = ICON, hotkey = 'E', buttonX = 2, buttonY = 2, cooldown = 9, percentManaCost = 0.065,
})

createPlayerHeroChannelAbility('ATR1', '朱雀院椿-炎姬·黄泉凤凰（R）', {
  editorSuffix = 'TsubakiR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'monsoon',
  tooltip = '炎姬·黄泉凤凰（R）', tooltipExtended = '技能说明：蓄力后沿目标方向释放决斗终式，一刀姿态追加反击斩，二刀姿态追加交错斩。|n伤害：主斩造成攻击力200%的物理伤害。|n施法距离：700|n伤害范围：目标方向直线|n蓄力时间：0.7秒|n冷却时间：70秒|n魔法消耗：最大魔法值的14%',
  icon = ICON, hotkey = 'R', buttonX = 3, buttonY = 2, cooldown = 70, percentManaCost = 0.14,
})

createPlayerHeroActiveDChannelAbility('ATD1', '朱雀院椿-浴火鸟·二刀解放（D）', {
  editorSuffix = 'TsubakiD', levels = 1,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'berserk',
  tooltip = '浴火鸟·二刀解放（D）', tooltipExtended = '技能说明：切换一刀守势与二刀攻势，二刀状态会消耗VF，VF归零后自动回到一刀守势。|n伤害：本技能不直接造成伤害。|n技能类型：天赋技能，初始获得|n状态持续时间：12秒|nVF消耗：每秒4点|n冷却时间：8秒|n魔法消耗：最大魔法值的2.5%',
  icon = ICON, hotkey = 'D', buttonX = 0, buttonY = 1, cooldown = 8, percentManaCost = 0.025,
})
