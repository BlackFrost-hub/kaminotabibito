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
