-- 朱雀院红叶 Q/W/E/R/D 物编壳。
-- 技能效果由运行时实现；Q2 复用全局 ASQ2 二段输入壳。

local HERO_LEVELS = 15

createPlayerHeroChannelAbility('AMQ1', '朱雀院红叶-飞燕·穿（Q）', {
  editorSuffix = 'MomijiQ', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 800, orderId = 'carrionswarm',
  tooltip = '飞燕·穿（Q）',
  tooltipExtended = '技能说明：向目标方向突进并完成拔刀斩，命中后可在短时间内追加回身斩。|n伤害：拔刀斩造成攻击力100%的物理伤害；回身斩造成攻击力80%的物理伤害。|n施法距离：突进300距离|n伤害范围：命中半径100|n二段时间：命中后0.7秒内|n冷却时间：6秒|n魔法消耗：最大魔法值的4.5%',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiQ.blp', hotkey = 'Q', buttonX = 0, buttonY = 2,
  cooldown = 6, percentManaCost = 0.045,
})

createPlayerHeroChannelAbility('AMW1', '朱雀院红叶-水镜·返刃（W）', {
  editorSuffix = 'MomijiW', heroAbility = true, levels = HERO_LEVELS,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'roar',
  tooltip = '水镜·返刃（W）',
  tooltipExtended = '技能说明：在面前展开水镜招架攻击；成功招架后立即反击攻击来源，未招架到攻击则以收刀斩结束。|n伤害：反击造成攻击力100%的物理伤害；未招架时释放前方收刀斩。|n防御范围：正面90度|n招架持续时间：0.6秒|n收刀斩范围：前方220|n冷却时间：10秒|n魔法消耗：最大魔法值的5.5%',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiW.blp', hotkey = 'W', buttonX = 1, buttonY = 2,
  cooldown = 10, percentManaCost = 0.055,
})

createPlayerHeroChannelAbility('AME1', '朱雀院红叶-三叶·散华（E）', {
  editorSuffix = 'MomijiE', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 650, orderId = 'shockwave',
  tooltip = '三叶·散华（E）',
  tooltipExtended = '技能说明：向前方连续施展三段斩击，并在斩击路径上留下剑痕。|n伤害：第一段造成攻击力50%的物理伤害，第二段造成70%，第三段造成120%。|n施法方向：前方直线|n伤害范围：三段斩击路径|n剑痕持续时间：2.5秒|n冷却时间：9秒|n魔法消耗：最大魔法值的6.5%',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiE.blp', hotkey = 'E', buttonX = 2, buttonY = 2,
  cooldown = 9, percentManaCost = 0.065,
})

createPlayerHeroChannelAbility('AMR1', '朱雀院红叶-奥义·红叶一闪（R）', {
  editorSuffix = 'MomijiR', heroAbility = true, levels = HERO_LEVELS,
  targetType = 2, castRange = 1000, orderId = 'monsoon',
  tooltip = '奥义·红叶一闪（R）',
  tooltipExtended = '技能说明：蓄力后沿目标方向释放高速直线终式，破绽、刀势和剑痕会强化后续斩击。|n伤害：主斩造成攻击力200%的物理伤害，并根据已有状态追加斩击。|n施法距离：700|n伤害范围：窄直线|n蓄力时间：0.7秒|n冷却时间：65秒|n魔法消耗：最大魔法值的13%',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiR.blp', hotkey = 'R', buttonX = 3, buttonY = 2,
  cooldown = 65, percentManaCost = 0.13,
})

createPlayerHeroActiveDChannelAbility('AMD1', '朱雀院红叶-朱雀流·秘传三式（D）', {
  editorSuffix = 'MomijiD', levels = 1,
  targetType = 0, castRange = 0, targetsAllowed = '', orderId = 'berserk',
  tooltip = '朱雀流·秘传三式（D）',
  tooltipExtended = '技能说明：进入秘传状态，强化接下来的斩击、招架或终式。|n伤害：本技能不直接造成伤害，强化效果由后续技能触发。|n技能类型：天赋技能，初始获得|n强化次数：最多3次|n状态持续时间：8秒|n冷却时间：18秒|n魔法消耗：最大魔法值的5%',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiD.blp', hotkey = 'D', buttonX = 0, buttonY = 1,
  cooldown = 18, percentManaCost = 0.05,
})
