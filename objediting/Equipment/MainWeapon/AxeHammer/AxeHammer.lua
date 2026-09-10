-- Main weapon: axe or hammer.


-- 默洛克渔夫重复收购奖励（移自 MainWeapon.lua 中转站：中转站只负责 dofile 子文件，不能放条目定义）。
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

-- 默洛克渔夫重复收购奖励（移自 MainWeapon.lua 中转站：中转站只负责 dofile 子文件，不能放条目定义）。
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
