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
  icon = 'Equipment\\Icon\\Item\\cooling_crystal.blp',
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
  'Equipment\\Icon\\Item\\starlit_life_essence.blp',
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
  'Equipment\\Icon\\Item\\dawn_mana_essence.blp',
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
  'Equipment\\Icon\\Item\\moonshadow_spirit_essence.blp',
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
  'Equipment\\Icon\\Item\\starlit_dawn_revitalizing_potion.blp',
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
  'Equipment\\Icon\\Item\\dawn_moon_clarity_potion.blp',
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
  'Equipment\\Icon\\Item\\starlit_moon_purifying_potion.blp',
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
  'Equipment\\Icon\\Item\\elf_royal_city_three_flower_elixir.blp',
  'war3mapImported\\PotionBlueGreater.mdl',
  2,
  false,
  0,
  1060
)
