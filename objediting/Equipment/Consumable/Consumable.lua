-- Consumables, potion-like pickups, and one-time battle items.

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
