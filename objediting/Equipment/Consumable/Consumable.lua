-- Consumables, potion-like pickups, and one-time battle items.

local rogueRuneUseAbility = AbilityDefinitionExperienceMod:new('A0MZ')
rogueRuneUseAbility:setName('[系统]盗贼神符使用壳')
rogueRuneUseAbility:setItemAbility(true)
rogueRuneUseAbility:setExperienceGained(1, 0)

createEquipmentItem('I0E5', '月光碎片', {
  baseId = 'rde1',
  icon = 'BuffIcon\\Boss\\Thranduil\\yueguangsuipian.blp',
  model = 'Objects\\InventoryItems\\runicobject\\runicobject.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 1,
  priority = 200,
  goldCost = 0,
  canBeDropped = false,
  tooltipExtended = '|cffccffff[战斗道具]|r|n拾取后获得 |cffffff006秒内基础移动速度+25%|r。',
  description = '|cffccffff[战斗道具]|r|n拾取后获得 |cffffff006秒内基础移动速度+25%|r。',
})

createEquipmentItem('I0ER', '冷却水晶', {
  baseId = 'rde1',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNcooling_crystal.blp',
  model = 'Objects\\InventoryItems\\CrystalShard\\CrystalShard.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 1,
  priority = 210,
  goldCost = 0,
  canBeDropped = false,
  tooltipExtended = '|cffccffff[战斗道具]|r|n拾取后清除自身全部 |cffff6600灼热|r 层数。',
  description = '|cffccffff[战斗道具]|r|n拾取后清除自身全部 |cffff6600灼热|r 层数。',
})

local function createRogueAutoUseRune(id, name, description, priority)
  local item = ItemDefinition:new(id, 'rdis')
  item:setName(name)
  item:setTooltipBasic(name)
  item:setTooltipExtended(description)
  item:setDescription(description)
  item:setClassification('Purchasable')
  item:setGoldCost(75)
  item:setLumberCost(0)
  item:setHitPoints(75)
  item:setPriority(priority)
  item:setStockMaximum(1)
  item:setStockReplenishInterval(60)
  item:setStockStartDelay(0)
  item:setAbilities('A0MZ')
  item:setNumberofCharges(1)
  item:setCanBeDropped(true)
  item:setDroppedWhenCarrierDies(false)
  item:setCanBeSoldByMerchants(false)
  item:setCanBeSoldToMerchants(false)
  item:setActivelyUsed(true)
  item:setPerishable(true)
  item:setUseAutomaticallyWhenAcquired(true)
  item:setIncludeAsRandomChoice(false)
  item:setValidTargetForTransformation(false)
  return item
end

createRogueAutoUseRune('I0FK', '盗贼神符（护甲）', '拾取后在10秒内提高15点护甲', 200)
createRogueAutoUseRune('I0FL', '盗贼神符（魔抗）', '拾取后在10秒内提高20%魔抗', 200)

local torchDescription = '|cffffff00道具|r|n在最远800码的目标位置立一个火把，提供600点视野，持续10秒|n|cffc0c0c0冷却：2秒|r'
local torchItem = ItemDefinition:new('I0FM', 'azhr')
torchItem:setName('火把')
torchItem:setTooltipBasic('火把')
torchItem:setTooltipExtended(torchDescription)
torchItem:setDescription(torchDescription)
torchItem:setInterfaceIcon('ReplaceableTextures\\WorldEditUI\\Doodad-Prop.blp')
torchItem:setAbilities('IP01')
torchItem:setClassification('Purchasable')
torchItem:setCooldownGroup('IP01')
torchItem:setGoldCost(200)
torchItem:setLumberCost(0)
torchItem:setPriority(200)
torchItem:setCanBeSoldByMerchants(false)
torchItem:setCanBeSoldToMerchants(true)
torchItem:setActivelyUsed(true)
torchItem:setPerishable(true)
torchItem:setNumberofCharges(1)

createEquipmentItem('I00Y', '|cFF800000触手残片|r', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\BTNTentacle.blp',
  model = 'Objects\\InventoryItems\\runicobject\\runicobject.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 1,
  priority = 150,
  goldCost = 150,
  hitPoints = 150,
  charges = 1,
  stockMaximum = 5,
  stockReplenishInterval = 60,
  tooltipExtended = '|cFFFFFFCC『材料』|n|r|cFFFFFF00效果：|n|r|cFF00CCFF水/冰属性抗性+7%（每个残片）|n|r|cFF00FF00已经持有2片残片时，每次拾取新的残片都可以恢复已损失HP20%的HP|n|r|cFFFF0000每块未被拾取的残片都会增加卡瑟拉100/5秒生命恢复！|n|r|cFF808080鱿鱼死亡后掉落的残片，似乎能够抵御来自海底的力量|r',
  description = '|cFFFFFFCC『材料』|n|r|cFFFFFF00效果：|n|r|cFF00CCFF水/冰属性抗性+7%（每个残片）|n|r|cFF00FF00已经持有2片残片时，每次拾取新的残片都可以恢复已损失HP20%的HP|n|r|cFFFF0000每块未被拾取的残片都会增加卡瑟拉100/5秒生命恢复！|n|r|cFF808080鱿鱼死亡后掉落的残片，似乎能够抵御来自海底的力量|r',
})

createEquipmentItem('I0HE', '精灵药水合成', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\BTNHealingSpray.blp',
  model = 'Objects\\InventoryItems\\runicobject\\runicobject.mdl',
  abilities = 'A0LH',
  classification = 'Charged',
  level = 0,
  unclassifiedLevel = 0,
  priority = 130,
  goldCost = 0,
  hitPoints = 1,
  charges = 1,
  stockMaximum = 1,
  stockReplenishInterval = 0,
  stockStartDelay = 0,
  canBeDropped = true,
  canBeSoldByMerchants = true,
  canBeSoldToMerchants = false,
  tooltipExtended = '|cffc0c0c0材料/制作媒介|r|n用于制作精灵药水，合成后会消耗本物品。|n|cffffcc66星露花×3 + 精灵药水合成 → 星露生命精华|r|n|cffffcc66晨曦花×3 + 精灵药水合成 → 晨曦魔力精华|r|n|cffffcc66月影花×3 + 精灵药水合成 → 月影灵息精华|r|n|cffffcc66星露花×2 + 晨曦花×1 + 精灵生命药水×1 + 精灵药水合成 → 星曦复苏药剂|r|n|cffffcc66晨曦花×2 + 月影花×1 + 精灵魔法药水×1 + 精灵药水合成 → 曦月澄明药剂|r|n|cffffcc66星露花×1 + 月影花×2 + 精灵生命药水×1 + 精灵药水合成 → 星月净愈药剂|r|n|cffffcc66星露花×1 + 晨曦花×1 + 月影花×1 + 精灵生命药水×1 + 精灵魔法药水×1 + 精灵药水合成 → 精灵王城三花灵药|r',
  description = '|cffc0c0c0材料/制作媒介|r|n用于制作精灵药水，合成后会消耗本物品。|n|cffffcc66星露花×3 + 精灵药水合成 → 星露生命精华|r|n|cffffcc66晨曦花×3 + 精灵药水合成 → 晨曦魔力精华|r|n|cffffcc66月影花×3 + 精灵药水合成 → 月影灵息精华|r|n|cffffcc66星露花×2 + 晨曦花×1 + 精灵生命药水×1 + 精灵药水合成 → 星曦复苏药剂|r|n|cffffcc66晨曦花×2 + 月影花×1 + 精灵魔法药水×1 + 精灵药水合成 → 曦月澄明药剂|r|n|cffffcc66星露花×1 + 月影花×2 + 精灵生命药水×1 + 精灵药水合成 → 星月净愈药剂|r|n|cffffcc66星露花×1 + 晨曦花×1 + 月影花×1 + 精灵生命药水×1 + 精灵魔法药水×1 + 精灵药水合成 → 精灵王城三花灵药|r',
})

local function createElfPotion(id, name, description, icon, model, buttonX, canBeSoldByMerchants, goldCost, priority)
  local item = ItemDefinition:new(id, 'hslv')
  item:setName(name)
  item:setTooltipBasic(name)
  item:setTooltipExtended(description)
  item:setDescription(description)
  item:setInterfaceIcon(icon)
  item:setModelUsed(model)
  item:setButtonPositionX(buttonX)
  item:setButtonPositionY(2)
  item:setAbilities('A08C')
  item:setCooldownGroup('A08C')
  item:setClassification('Purchasable')
  item:setLevel(0)
  item:setLevelUnclassified(0)
  item:setGoldCost(goldCost or 750)
  item:setLumberCost(0)
  item:setHitPoints(100)
  item:setPriority(priority or 750)
  item:setScalingValue(1.0)
  item:setStockMaximum(canBeSoldByMerchants == false and 0 or 2)
  item:setStockReplenishInterval(0)
  item:setStockStartDelay(0)
  item:setCanBeDropped(true)
  item:setDroppedWhenCarrierDies(false)
  item:setCanBeSoldByMerchants(canBeSoldByMerchants ~= false)
  item:setCanBeSoldToMerchants(true)
  item:setActivelyUsed(true)
  item:setPerishable(true)
  item:setUseAutomaticallyWhenAcquired(false)
  item:setIgnoreCooldown(false)
  item:setIncludeAsRandomChoice(false)
  item:setValidTargetForTransformation(false)
  item:setNumberofCharges(3)
  return item
end

createElfPotion(
  'IEM1',
  '精灵魔法药水',
  '|cffffffcc药品|n|r在10秒内恢复英雄1000魔法值|cffccffff|n|r|cffffffcc不会因战斗而打断效果|r',
  'ReplaceableTextures\\CommandButtons\\BTN000114.blp',
  'war3mapImported\\PotionBlueGreater.mdl',
  3
)

createElfPotion(
  'IEL1',
  '精灵生命药水',
  '|cffffffcc药品|n|r在10秒内恢复英雄2400生命值|cffccffff|n|r|cffffffcc不会因战斗而打断效果|r',
  'ReplaceableTextures\\CommandButtons\\BTN000113.blp',
  'war3mapImported\\PotionGreen.mdl',
  1
)

createElfPotion(
  'I0H7',
  '星露生命精华',
  '|cffffffcc药品|r|n4秒内持续恢复英雄3600点生命值。|n使用后8秒内获得10点护甲。|n|cffc0c0c0不会因战斗而打断效果。|r',
  'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNstarlit_life_essence.blp',
  'war3mapImported\\PotionGreen.mdl',
  0,
  false,
  0,
  1000
)

createElfPotion(
  'I0H8',
  '晨曦魔力精华',
  '|cffffffcc药品|r|n4秒内持续恢复英雄1800点魔法值。|n使用后8秒内提高8%魔法伤害。|n|cffc0c0c0不会因战斗而打断效果。|r',
  'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNdawn_mana_essence.blp',
  'war3mapImported\\PotionBlueGreater.mdl',
  1,
  false,
  0,
  1010
)

createElfPotion(
  'I0H9',
  '月影灵息精华',
  '|cffffffcc药品|r|n4秒内持续恢复英雄2400点生命值和1200点魔法值。|n使用后8秒内提高10%魔抗。|n|cffc0c0c0不会因战斗而打断效果。|r',
  'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNmoonshadow_spirit_essence.blp',
  'war3mapImported\\PotionGreen.mdl',
  2,
  false,
  0,
  1020
)

createElfPotion(
  'I0HA',
  '星曦复苏药剂',
  '|cffffffcc药品|r|n5秒内持续恢复英雄5000点生命值和1000点魔法值。|n使用后8秒内获得12点护甲。|n|cffc0c0c0不会因战斗而打断效果。|r',
  'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNstarlit_dawn_revitalizing_potion.blp',
  'war3mapImported\\PotionGreen.mdl',
  3,
  false,
  0,
  1030
)

createElfPotion(
  'I0HB',
  '曦月澄明药剂',
  '|cffffffcc药品|r|n5秒内持续恢复英雄2400点生命值和2600点魔法值。|n使用后8秒内提高10%魔法伤害。|n|cffc0c0c0不会因战斗而打断效果。|r',
  'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNdawn_moon_clarity_potion.blp',
  'war3mapImported\\PotionBlueGreater.mdl',
  0,
  false,
  0,
  1040
)

createElfPotion(
  'I0HC',
  '星月净愈药剂',
  '|cffffffcc药品|r|n5秒内持续恢复英雄5200点生命值和1400点魔法值。|n使用后8秒内提高12%魔抗。|n|cffc0c0c0不会因战斗而打断效果。|r',
  'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNstarlit_moon_purifying_potion.blp',
  'war3mapImported\\PotionGreen.mdl',
  1,
  false,
  0,
  1050
)

createElfPotion(
  'I0HD',
  '精灵王城三花灵药',
  '|cffffffcc药品|r|n6秒内持续恢复英雄6000点生命值和3000点魔法值。|n使用后8秒内提高8%魔法伤害和8%魔抗。|n|cffc0c0c0不会因战斗而打断效果。|r',
  'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNelf_royal_city_three_flower_elixir.blp',
  'war3mapImported\\PotionBlueGreater.mdl',
  2,
  false,
  0,
  1060
)

-- 第三章烧烤食品：四条熔岩鱼与恶魔犬肉的篝火烤制产物（recipe 在 TS 装备数据，图标沿用对应生食材）。
createEquipmentItem('I0HR', '烤赤魔鱼', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\BTN000312.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 220,
  goldCost = 800,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 50% 生命与 1000 点魔法。|r|n赤魔鱼经篝火慢烤后，鱼皮微焦、鱼肉泛着淡淡的赤红。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffffcc使用：恢复 50% 生命与 1000 点魔法。|r|n赤魔鱼经篝火慢烤后，鱼皮微焦、鱼肉泛着淡淡的赤红。|r',
})

createEquipmentItem('I0HS', '烤熔岩食鱼', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\BTN000313.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 221,
  goldCost = 1200,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 3000 点生命与 1000 点魔法。|r|n油脂丰厚的熔岩食鱼在火上烤得滋滋作响，一口下去暖意直冲四肢。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffffcc使用：恢复 3000 点生命与 1000 点魔法。|r|n油脂丰厚的熔岩食鱼在火上烤得滋滋作响，一口下去暖意直冲四肢。|r',
})

createEquipmentItem('I0HT', '烤熔岩灵鱼', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\BTN000314.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 222,
  goldCost = 1500,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 50% 已损失生命与 50% 已损失魔法。|r|n灵鱼离水后灵性未散，烤制时鳞片间仍有微光流转。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffffcc使用：恢复 50% 已损失生命与 50% 已损失魔法。|r|n灵鱼离水后灵性未散，烤制时鳞片间仍有微光流转。|r',
})

createEquipmentItem('I0HU', '烤熔岩焰鱼', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNroast_molten_flamefish.blp',
  model = 'Unit\\Minion\\Dunkleosteus.mdx',
  scale = 0.35,
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 223,
  goldCost = 2000,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 50% 已损失生命与 50% 已损失魔法。|r|n焰鱼的鱼尾在烤架上仍燃着细小的火苗，据说运气好的人能在鱼腹里找到金块。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 50% 已损失生命与 50% 已损失魔法。|r|n焰鱼的鱼尾在烤架上仍燃着细小的火苗，据说运气好的人能在鱼腹里找到金块。|r',
})

createEquipmentItem('I0HW', '烤恶魔犬肉串', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\BTN000311.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 224,
  goldCost = 1500,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 5000 点生命与 1500 点魔法。|r|n恶魔犬肉串在篝火上烤得外焦里嫩，撒上粗盐后香气能飘出半个营地。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 5000 点生命与 1500 点魔法。|r|n恶魔犬肉串在篝火上烤得外焦里嫩，撒上粗盐后香气能飘出半个营地。|r',
})

createEquipmentItem('I0I1', '烤蛇纹翡翠鲤', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNroast_jade_scale_carp.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 225,
  goldCost = 700,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C|r|n|cffffffcc使用：恢复 3600 点生命与 1200 点魔法。|r|n翡翠鲤烤过后鳞纹全开，油脂里带着一丝矿脉的凉意。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C|r|n|cffffffcc使用：恢复 3600 点生命与 1200 点魔法。|r|n翡翠鲤烤过后鳞纹全开，油脂里带着一丝矿脉的凉意。|r',
})

createEquipmentItem('I0I3', '烤月瞳鳗', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNroast_moonpupil_eel.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 226,
  goldCost = 800,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 35% 已损失生命与 25% 已损失魔法。|r|n鳗肉细腻，咽下后瞳纹般的花纹会在舌尖一闪而过。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 35% 已损失生命与 25% 已损失魔法。|r|n鳗肉细腻，咽下后瞳纹般的花纹会在舌尖一闪而过。|r',
})

createEquipmentItem('I0I5', '烤战痕月鳞鱼', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNroast_battle_scar_moonscale.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 227,
  goldCost = 900,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 4200 点生命，并在 4 秒内提高 10% 受到的治疗。|r|n鳞片被烤得卷起，咸香之外还有一股让人想站得更直的力量。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 4200 点生命，并在 4 秒内提高 10% 受到的治疗。|r|n鳞片被烤得卷起，咸香之外还有一股让人想站得更直的力量。|r',
})

createEquipmentItem('I0I7', '烤湖心星鲟', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNroast_lakeheart_sturgeon.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 228,
  goldCost = 1000,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 45% 生命与 1800 点魔法。|r|n鱼肉里嵌着星砂，咬开时会有细小的光屑在齿间炸开。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 45% 生命与 1800 点魔法。|r|n鱼肉里嵌着星砂，咬开时会有细小的光屑在齿间炸开。|r',
})

createEquipmentItem('I0I9', '烤污潮鳗', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNroast_foul_tide_eel.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 229,
  goldCost = 700,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C|r|n|cffffffcc使用：恢复 3000 点生命与 1000 点魔法，并在 6 秒内提高 8% 水属性抗性。|r|n土腥与焦香一同涌上来，吞下去后喉咙像结了一层薄薄的膜。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C|r|n|cffffffcc使用：恢复 3000 点生命与 1000 点魔法，并在 6 秒内提高 8% 水属性抗性。|r|n土腥与焦香一同涌上来，吞下去后喉咙像结了一层薄薄的膜。|r',
})

createEquipmentItem('I0IB', '烤黑水鳐', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNroast_blackwater_ray.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 230,
  goldCost = 800,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C|r|n|cffffffcc使用：恢复 40% 已损失生命与 30% 已损失魔法。|r|n鳐肉发黑却出奇鲜甜，吃下去时身体会本能地缩紧又松开。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C|r|n|cffffffcc使用：恢复 40% 已损失生命与 30% 已损失魔法。|r|n鳐肉发黑却出奇鲜甜，吃下去时身体会本能地缩紧又松开。|r',
})

createEquipmentItem('I0ID', '烤净泉鳗', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNroast_pure_spring_eel.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 231,
  goldCost = 1100,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 3800 点生命，并在 3 秒内继续恢复 900 点生命。|r|n泉珠在火上化开，肉汁清甜，暖意会在腹中慢慢铺散。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 3800 点生命，并在 3 秒内继续恢复 900 点生命。|r|n泉珠在火上化开，肉汁清甜，暖意会在腹中慢慢铺散。|r',
})

createEquipmentItem('I0IF', '烤清辉水母鱼', {
  baseId = 'azhr',
  icon = 'ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNroast_clear_glow_jellyfish.blp',
  model = 'Doodads\\Ruins\\Water\\FishTropical\\FishTropical.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 6,
  priority = 232,
  goldCost = 1200,
  tooltipExtended = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 2400 点生命与 2200 点魔法。|r|n半透明的鱼肉在盘里泛着微光，入口清凉，像饮了一口晨露。|r',
  description = '|cffccffff[药剂/食品]|r|n|cffffcc99等级：C+|r|n|cffffffcc使用：恢复 2400 点生命与 2200 点魔法。|r|n半透明的鱼肉在盘里泛着微光，入口清凉，像饮了一口晨露。|r',
})

-- 熔岩鱼竿：第三章熔岩区域的专属钓具，由默洛克渔夫（n06N）出售。
local lavaRodDescription = '|cffffff00道具|r|n熔岩锻造的钓竿，可在岩浆水域垂钓熔岩鱼|n|cffffcc99使用次数：20|r|n|cffc0c0c0冷却：1.5秒|r'
local lavaRodItem = ItemDefinition:new('I0IG', 'azhr')
lavaRodItem:setName('熔岩鱼竿')
lavaRodItem:setTooltipBasic('熔岩鱼竿')
lavaRodItem:setTooltipExtended(lavaRodDescription)
lavaRodItem:setDescription(lavaRodDescription)
lavaRodItem:setInterfaceIcon('ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Item\\BTNlava_fishing_rod.blp')
lavaRodItem:setModelUsed('Common\\Model\\Item\\FinalRod.mdx')
lavaRodItem:setScalingValue(1.3)
lavaRodItem:setAbilities('A017')
lavaRodItem:setClassification('Purchasable')
lavaRodItem:setCooldownGroup('A017')
lavaRodItem:setGoldCost(5000)
lavaRodItem:setLumberCost(0)
lavaRodItem:setPriority(5000)
lavaRodItem:setCanBeSoldByMerchants(false)
lavaRodItem:setCanBeSoldToMerchants(true)
lavaRodItem:setActivelyUsed(true)
lavaRodItem:setPerishable(true)
lavaRodItem:setNumberofCharges(20)
lavaRodItem:setStockMaximum(8)
lavaRodItem:setStockReplenishInterval(90)
lavaRodItem:setHitPoints(100)
