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
