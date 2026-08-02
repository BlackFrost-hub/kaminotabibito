-- Quest-only story items. These are not regular equipment rewards.

createEquipmentItem('I0ES', '残缺的魔法信件', {
  baseId = 'ratf',
  icon = 'Equipment\\Icon\\QuestItem\\broken_magic_letter.blp',
  model = 'Objects\\InventoryItems\\tome\\tome.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 1,
  priority = 50,
  goldCost = 0,
  canBeDropped = true,
  canBeSoldByMerchants = false,
  canBeSoldToMerchants = false,
  tooltipExtended = '|cffffffcc[任务物品]|r|n树魔首领死亡后凝成的残缺魔法信件。|n|cFF808080信纸上残留着分离教派的加密术式，必须带回王城交给克林姆德王确认。|r',
  description = '|cffffffcc[任务物品]|r|n树魔首领死亡后凝成的残缺魔法信件。|n|cFF808080信纸上残留着分离教派的加密术式，必须带回王城交给克林姆德王确认。|r',
})

createEquipmentItem('I0G9', '火灵核心', {
  baseId = 'ratf',
  icon = 'Equipment\\Icon\\Item\\vengeful_fire_core_shard.blp',
  model = 'Objects\\InventoryItems\\CrystalShard\\CrystalShard.mdl',
  abilities = ' ',
  classification = 'Charged',
  level = 1,
  priority = 50,
  goldCost = 0,
  canBeDropped = true,
  canBeSoldByMerchants = false,
  canBeSoldToMerchants = false,
  tooltipExtended = '|cffffffcc[任务物品]|r|n击败熔岩恶魔后凝结的火灵核心。|n|cFF808080嵌入古老熔核封印后会燃尽自身，暂时压制熔岩恶魔王的再生。|r',
  description = '|cffffffcc[任务物品]|r|n击败熔岩恶魔后凝结的火灵核心。|n|cFF808080嵌入古老熔核封印后会燃尽自身，暂时压制熔岩恶魔王的再生。|r',
})
