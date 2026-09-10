dofile('Equipment/MainWeapon/Sword/Sword.lua')
dofile('Equipment/MainWeapon/AxeHammer/AxeHammer.lua')
dofile('Equipment/MainWeapon/Staff/Staff.lua')
dofile('Equipment/MainWeapon/Dagger/Dagger.lua')
dofile('Equipment/MainWeapon/Spear/Spear.lua')
dofile('Equipment/MainWeapon/Bow/Bow.lua')
dofile('Equipment/MainWeapon/Shield/Shield.lua')


-- 默洛克渔夫重复收购奖励（B+ 档）。纯属性、无主动技能；评分依据见 TS 装备数据同条目注释。
createEquipmentItem('I0IJ', '|cffFF8000岩浆崩裂重锤|r', {
  baseId = 'ratf',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\MainWeapon\\AxeHammer\\BTNmagma_burst_maul.blp',
  model = 'Common\\Model\\wepon\\zb10.mdx',
  abilities = ' ',
  classification = 'Campaign',
  level = 6,
  score = 8000,
  tooltipExtended = '|cffccffff[主武器/斧锤-力量·普攻]|r|n|cffffcc99等级：B+|n评分：8000|r|n|cffffffcc[基础属性]|r|n攻击力+175|n力量+42|n生命值+700|n护甲穿透+20%|n|cFF808080锤头是整块玄武岩裂出来的，缝里还有没熄的火。|r',
  description = '|cffccffff[主武器/斧锤-力量·普攻]|r|n|cffffcc99等级：B+|n评分：8000|r|n|cffffffcc[基础属性]|r|n攻击力+175|n力量+42|n生命值+700|n护甲穿透+20%|n|cFF808080锤头是整块玄武岩裂出来的，缝里还有没熄的火。|r',
})


-- 默洛克渔夫重复收购奖励（B+ 档）。纯属性、无主动技能；评分依据见 TS 装备数据同条目注释。
createEquipmentItem('I0IL', '|cff00ccff焚渊法杖|r', {
  baseId = 'ratf',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\MainWeapon\\Staff\\BTNabyss_forge_staff.blp',
  model = 'war3mapImported\\SylvanEdge.mdl',
  abilities = ' ',
  classification = 'Campaign',
  level = 6,
  score = 8000,
  tooltipExtended = '|cffccffff[主武器/法杖-智力·法术]|r|n|cffffcc99等级：B+|n评分：8000|r|n|cffffffcc[基础属性]|r|n攻击力+120|n智力+55|n魔法值+900|n魔法伤害+22%|n魔法穿透+20%|n|cFF808080杖顶那团火被铁笼关着，从不熄灭，也不肯变小。|r',
  description = '|cffccffff[主武器/法杖-智力·法术]|r|n|cffffcc99等级：B+|n评分：8000|r|n|cffffffcc[基础属性]|r|n攻击力+120|n智力+55|n魔法值+900|n魔法伤害+22%|n魔法穿透+20%|n|cFF808080杖顶那团火被铁笼关着，从不熄灭，也不肯变小。|r',
})


-- 默洛克渔夫重复收购奖励（B++ 档）。纯属性、无主动技能；评分依据见 TS 装备数据同条目注释。
createEquipmentItem('I0IP', '|cffFF8000熔渊裂地巨斧|r', {
  baseId = 'ratf',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\MainWeapon\\AxeHammer\\BTNabyss_earthrend_axe.blp',
  model = 'Common\\Model\\wepon\\zb10.mdx',
  abilities = ' ',
  classification = 'Campaign',
  level = 6,
  score = 9000,
  tooltipExtended = '|cffccffff[主武器/斧锤-力量·普攻]|r|n|cffffcc99等级：B++|n评分：9000|r|n|cffffffcc[基础属性]|r|n攻击力+195|n力量+48|n生命值+1100|n护甲穿透+22%|n伤害吸血+8%|n|cFF808080双刃都裂着，斧柄上的锈红纹路像是会呼吸。|r',
  description = '|cffccffff[主武器/斧锤-力量·普攻]|r|n|cffffcc99等级：B++|n评分：9000|r|n|cffffffcc[基础属性]|r|n攻击力+195|n力量+48|n生命值+1100|n护甲穿透+22%|n伤害吸血+8%|n|cFF808080双刃都裂着，斧柄上的锈红纹路像是会呼吸。|r',
})

