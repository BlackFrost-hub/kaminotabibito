local DEFAULT_EQUIPMENT_BASE_ID = 'ratf'
local DEFAULT_EQUIPMENT_MODEL = 'Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl'

function createEquipmentItem(id, name, options)
  options = options or {}

  local item = ItemDefinition:new(id, options.baseId or DEFAULT_EQUIPMENT_BASE_ID)
  item:setName(name)
  item:setTooltipBasic(options.tooltipBasic or name)
  item:setTooltipExtended(options.tooltipExtended or options.description or name)
  item:setDescription(options.description or name)
  item:setInterfaceIcon(options.icon or '')
  item:setModelUsed(options.model or DEFAULT_EQUIPMENT_MODEL)
  item:setAbilities(options.abilities or '')
  item:setCooldownGroup(options.cooldownGroup or '')
  item:setClassification(options.classification or 'Permanent')
  item:setLevel(options.level or 1)
  item:setLevelUnclassified(options.unclassifiedLevel or options.level or 1)
  item:setGoldCost(options.goldCost or 1000)
  item:setLumberCost(options.lumberCost or 0)
  item:setHitPoints(options.hitPoints or 75)
  item:setPriority(options.priority or 1000)
  item:setScalingValue(options.scale or 1.0)
  item:setCanBeDropped(options.canBeDropped ~= false)
  item:setDroppedWhenCarrierDies(options.dropWhenCarrierDies == true)
  item:setCanBeSoldByMerchants(options.canBeSoldByMerchants or false)
  item:setCanBeSoldToMerchants(options.canBeSoldToMerchants or false)
  item:setActivelyUsed(options.activelyUsed or false)
  item:setPerishable(options.perishable or false)
  item:setUseAutomaticallyWhenAcquired(options.autoUse or false)
  item:setIgnoreCooldown(options.ignoreCooldown or false)
  item:setIncludeAsRandomChoice(options.includeAsRandomChoice or false)
  item:setValidTargetForTransformation(options.validMorphTarget or false)
  item:setNumberofCharges(options.charges or 0)
  item:setStockMaximum(options.stockMaximum or 0)
  item:setStockReplenishInterval(options.stockReplenishInterval or 0)
  item:setStockStartDelay(options.stockStartDelay or 0)

  if options.maxStack ~= nil then
    item:setMaxStack(options.maxStack)
  end
  if options.armorType ~= nil then
    item:setArmorType(options.armorType)
  end
  if options.tintRed ~= nil then
    item:setTintingColor1Red(options.tintRed)
  end
  if options.tintGreen ~= nil then
    item:setTintingColor2Green(options.tintGreen)
  end
  if options.tintBlue ~= nil then
    item:setTintingColor3Blue(options.tintBlue)
  end

  return item
end
