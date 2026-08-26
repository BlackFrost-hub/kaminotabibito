-- Shared constructors for categorized unit object data.

local function playerHeroValue(value, fallback)
  if value == nil then
    return fallback
  end
  return value
end

local function validatePlayerHeroAttributes(name, options)
  local strength = options.strength
  local agility = options.agility
  local intelligence = options.intelligence
  local strengthPerLevel = options.strengthPerLevel
  local agilityPerLevel = options.agilityPerLevel
  local intelligencePerLevel = options.intelligencePerLevel
  local primaryAttribute = options.primaryAttribute

  assert(type(strength) == 'number', name .. ': strength is required')
  assert(type(agility) == 'number', name .. ': agility is required')
  assert(type(intelligence) == 'number', name .. ': intelligence is required')
  assert(type(strengthPerLevel) == 'number', name .. ': strengthPerLevel is required')
  assert(type(agilityPerLevel) == 'number', name .. ': agilityPerLevel is required')
  assert(type(intelligencePerLevel) == 'number', name .. ': intelligencePerLevel is required')
  assert(primaryAttribute == 'STR' or primaryAttribute == 'AGI' or primaryAttribute == 'INT', name .. ': primaryAttribute must be STR, AGI or INT')
  assert(strength + agility + intelligence >= 70, name .. ': starting attributes must total at least 70')
  assert(strengthPerLevel + agilityPerLevel + intelligencePerLevel <= 7.0 + 0.000001, name .. ': attribute growth must total at most 7.0')

  local primaryGrowth = strengthPerLevel
  if primaryAttribute == 'AGI' then
    primaryGrowth = agilityPerLevel
  elseif primaryAttribute == 'INT' then
    primaryGrowth = intelligencePerLevel
  end
  assert(primaryGrowth >= 3.5, name .. ': primary attribute growth must be at least 3.5')
end

-- Common player hero object data. Every player hero must declare its attack mode
-- so ranged projectile fields cannot accidentally leak into a melee hero.
function createPlayerHeroUnit(id, name, options)
  options = options or {}
  validatePlayerHeroAttributes(name, options)

  local attackMode = options.attackMode
  assert(attackMode == 'ranged' or attackMode == 'melee', name .. ': attackMode must be ranged or melee')
  local isRanged = attackMode == 'ranged'
  local projectileArt = playerHeroValue(options.projectileArt, '')
  local projectileSpeed = playerHeroValue(options.projectileSpeed, 0)
  local projectileArc = isRanged and playerHeroValue(options.projectileArc, 0.0) or 0.0
  local projectileHoming = isRanged and playerHeroValue(options.projectileHoming, false) or false
  if isRanged then
    assert(projectileArt ~= '', name .. ': ranged heroes require projectileArt')
    assert(projectileSpeed > 0, name .. ': ranged heroes require projectileSpeed > 0')
  else
    assert(projectileArt == '', name .. ': melee heroes must not define projectileArt')
    assert(projectileSpeed == 0, name .. ': melee heroes must use projectileSpeed 0')
  end

  local unit = HeroDefinition:new(id, playerHeroValue(options.baseId, 'Emoo'))
  unit:setName(name)
  unit:setProperNames(playerHeroValue(options.properNames, name))
  unit:setProperNamesUsed(playerHeroValue(options.properNamesUsed, 1))
  unit:setTooltipBasic(playerHeroValue(options.tooltipBasic, name))
  unit:setTooltipExtended(playerHeroValue(options.tooltipExtended, name))
  unit:setDescription(playerHeroValue(options.description, name))
  unit:setRequirements(playerHeroValue(options.requirements, ''))

  unit:setModelFile(playerHeroValue(options.modelFile, '.mdl'))
  unit:setModelFileExtraVersions(tostring(playerHeroValue(options.modelFileExtraVersions, 0)))
  unit:setScalingValue(playerHeroValue(options.scale, 1.0))
  unit:setIconGameInterface(playerHeroValue(options.icon, 'ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp'))
  unit:setNormalAbilities(playerHeroValue(options.normalAbilities, ''))
  unit:setHeroAbilities(playerHeroValue(options.heroAbilities, ''))
  unit:setStructuresBuilt(playerHeroValue(options.structuresBuilt, ''))
  unit:setUpgradesUsed(playerHeroValue(options.upgradesUsed, ''))
  unit:setUnitSoundSet(playerHeroValue(options.unitSoundSet, ''))
  unit:setRandomSound(playerHeroValue(options.randomSound, ''))
  unit:setMovementSound(playerHeroValue(options.movementSound, ''))

  unit:setHitPointsMaximumBase(playerHeroValue(options.hp, 1))
  unit:setHitPointsRegenerationType(playerHeroValue(options.hpRegenType, 'always'))
  unit:setHitPointsRegenerationRate(playerHeroValue(options.hpRegen, 0.0))
  unit:setManaMaximum(playerHeroValue(options.mana, 100))
  unit:setManaRegeneration(playerHeroValue(options.manaRegen, 0.0))
  unit:setManaInitialAmount(playerHeroValue(options.initialMana, 99999))
  unit:setFoodProduced(playerHeroValue(options.foodProduced, 0))
  unit:setFoodCost(playerHeroValue(options.foodCost, 5))
  unit:setAcquisitionRange(playerHeroValue(options.acquire, isRanged and 650.0 or 128.0))
  unit:setSightRadiusDay(playerHeroValue(options.sightDay, 1600))
  unit:setSightRadiusNight(playerHeroValue(options.sightNight, 1100))
  unit:setCollisionSize(playerHeroValue(options.collision, 32.0))

  unit:setLevel(playerHeroValue(options.level, 1))
  unit:setSpeedBase(playerHeroValue(options.speed, 310))
  unit:setSpeedMinimum(playerHeroValue(options.speedMinimum, 0))
  unit:setSpeedMaximum(playerHeroValue(options.speedMaximum, 522))
  unit:setMovementType(playerHeroValue(options.movementType, MovementType.Foot))
  unit:setMovementHeightMinimum(playerHeroValue(options.minHeight, 0.0))
  unit:setMovementHeight(playerHeroValue(options.height, 0.0))
  unit:setTurnRate(playerHeroValue(options.turnRate, 2.0))
  unit:setPropulsionWindowdegrees(playerHeroValue(options.propulsionWindow, 60.0))
  unit:setUnitClassification(playerHeroValue(options.classification, ''))
  unit:setArmorType(playerHeroValue(options.armorType, ArmorType.Hero))
  unit:setDefenseBase(playerHeroValue(options.defense, 0))
  unit:setDefenseUpgradeBonus(playerHeroValue(options.defenseUpgradeBonus, 0))
  unit:setCanFlee(playerHeroValue(options.canFlee, false))
  unit:setCanDropItemsOnDeath(playerHeroValue(options.dropItems, true))

  unit:setPrimaryAttribute(options.primaryAttribute)
  unit:setStartingStrength(options.strength)
  unit:setStartingAgility(options.agility)
  unit:setStartingIntelligence(options.intelligence)
  unit:setStrengthPerLevel(options.strengthPerLevel)
  unit:setAgilityPerLevel(options.agilityPerLevel)
  unit:setIntelligencePerLevel(options.intelligencePerLevel)

  unit:setAttacksEnabled(playerHeroValue(options.attacksEnabled, AttacksEnabled.AttackOneOnly))
  unit:setAttack1AttackType(playerHeroValue(options.attackType, isRanged and AttackType.Magic or AttackType.Normal))
  unit:setAttack1WeaponType(isRanged and WeaponType.Missile or WeaponType.Instant)
  unit:setAttack1WeaponSound(playerHeroValue(options.weaponSound, WeaponSound.Nothing))
  unit:setAttack1TargetsAllowed(playerHeroValue(options.attackTargets, 'ground,structure,debris,air,item,ward'))
  unit:setAttack1Range(playerHeroValue(options.attackRange, isRanged and 650 or 128))
  unit:setAttack1RangeMotionBuffer(playerHeroValue(options.rangeBuffer, 250.0))
  unit:setAttack1ProjectileArt(projectileArt)
  unit:setAttack1ProjectileSpeed(projectileSpeed)
  unit:setAttack1ProjectileArc(projectileArc)
  unit:setAttack1ProjectileHomingEnabled(projectileHoming)
  unit:setAttack1ShowUI(playerHeroValue(options.attackShowUI, true))
  unit:setAttack1MaximumNumberofTargets(playerHeroValue(options.attackMaximumTargets, 1))
  unit:setAttack1CooldownTime(playerHeroValue(options.attackCooldown, 2.2))
  unit:setAttack1AnimationBackswingPoint(playerHeroValue(options.attackBackswing, 0.4))
  unit:setAttack1AnimationDamagePoint(playerHeroValue(options.attackDamagePoint, 0.3))
  unit:setAttack1DamageBase(playerHeroValue(options.damageBase, 100))
  unit:setAttack1DamageNumberofDice(playerHeroValue(options.damageDice, 12))
  unit:setAttack1DamageSidesperDie(playerHeroValue(options.damageSides, 2))
  unit:setAttack1DamageUpgradeAmount(playerHeroValue(options.damageUpgrade, 0))
  unit:setAttack1DamageSpillRadius(playerHeroValue(options.damageSpillRadius, 0.0))
  unit:setAttack1DamageSpillDistance(playerHeroValue(options.damageSpillDistance, 0.0))

  unit:setGoldCost(playerHeroValue(options.goldCost, 0))
  unit:setLumberCost(playerHeroValue(options.lumberCost, 0))
  unit:setBuildTime(playerHeroValue(options.buildTime, 0))
  unit:setPointValue(playerHeroValue(options.pointValue, 0))
  unit:setGoldBountyAwardedBase(playerHeroValue(options.goldBountyBase, 0))
  unit:setGoldBountyAwardedNumberofDice(playerHeroValue(options.goldBountyDice, 0))
  unit:setGoldBountyAwardedSidesperDie(playerHeroValue(options.goldBountySides, 0))
  unit:setLumberBountyAwardedBase(playerHeroValue(options.lumberBountyBase, 0))
  unit:setLumberBountyAwardedNumberofDice(playerHeroValue(options.lumberBountyDice, 0))
  unit:setLumberBountyAwardedSidesperDie(playerHeroValue(options.lumberBountySides, 0))
  unit:setStockMaximum(playerHeroValue(options.stockMaximum, 0))
  unit:setStockStartDelay(playerHeroValue(options.stockStartDelay, 120))
  unit:setStockReplenishInterval(playerHeroValue(options.stockReplenishInterval, 30))

  if options.projectileLaunchZ ~= nil then
    unit:setProjectileLaunchZ(options.projectileLaunchZ)
  end
  if options.projectileImpactZ ~= nil then
    unit:setProjectileImpactZ(options.projectileImpactZ)
  end
  return unit
end

function createAncestralTideUnit(id, parentId, name, modelFile, classification, scale, icon)
  local unit = UnitDefinition:new(id, parentId)
  unit:setName(name)
  unit:setTooltipBasic(name)
  unit:setTooltipExtended(name)
  unit:setDescription(name)
  unit:setModelFile(modelFile)
  unit:setModelFileExtraVersions('0')
  unit:setScalingValue(scale or 1.0)
  unit:setIconGameInterface(icon)
  unit:setRace(Race.Naga)
  unit:setNormalAbilities('')
  unit:setStructuresBuilt('')
  unit:setUpgradesUsed('R001,R002')
  unit:setUnitClassification(classification or 'ancient')
  unit:setCanFlee(false)
  unit:setCanDropItemsOnDeath(true)
  return unit
end

function createSecondLegionUnit(id, parentId, options)
  local unit = UnitDefinition:new(id, parentId)
  unit:setName(options.name)
  unit:setTooltipBasic(options.name)
  unit:setTooltipExtended(options.description)
  unit:setDescription(options.description)
  unit:setModelFile(options.modelFile)
  unit:setModelFileExtraVersions('0')
  unit:setIconGameInterface(options.icon)
  unit:setScalingValue(options.scale)
  unit:setRace(Race.Nightelf)
  unit:setNormalAbilities('')
  unit:setStructuresBuilt('')
  unit:setUpgradesUsed('R001,R002')
  unit:setUnitClassification('')
  unit:setCanFlee(false)
  unit:setHideMinimapDisplay(true)
  unit:setDisplayasNeutralHostile(true)
  unit:setLevel(30)
  unit:setHitPointsMaximumBase(options.hp)
  unit:setHitPointsRegenerationType('always')
  unit:setHitPointsRegenerationRate(options.hpRegen)
  unit:setManaMaximum(options.mana or 0)
  unit:setManaInitialAmount(options.mana or 0)
  unit:setManaRegeneration(options.manaRegen or 0.0)
  unit:setDefenseBase(options.defense)
  unit:setDefenseUpgradeBonus(0)
  unit:setArmorType(ArmorType.Normal)
  unit:setSpeedBase(options.speed)
  unit:setCollisionSize(options.collision)
  unit:setAcquisitionRange(options.acquire)
  unit:setSightRadiusDay(1600)
  unit:setSightRadiusNight(1200)
  unit:setTurnRate(1.0)
  unit:setPointValue(options.pointValue)
  unit:setGoldBountyAwardedBase(options.bounty)
  unit:setGoldBountyAwardedNumberofDice(0)
  unit:setGoldBountyAwardedSidesperDie(0)

  unit:setAttacksEnabled(AttacksEnabled.AttackOneOnly)
  unit:setAttack1AttackType(options.attackType)
  unit:setAttack1DamageBase(options.damage)
  unit:setAttack1DamageNumberofDice(1)
  unit:setAttack1DamageSidesperDie(1)
  unit:setAttack1CooldownTime(options.attackCooldown)
  unit:setAttack1Range(options.attackRange)
  unit:setAttack1RangeMotionBuffer(options.rangeBuffer)
  unit:setAttack1TargetsAllowed(options.attackTargets)
  unit:setAttack1WeaponType(options.weaponType)
  unit:setAttack1WeaponSound(options.weaponSound)
  unit:setAttack1ProjectileArt(options.projectileArt or '')
  unit:setAttack1ProjectileSpeed(options.projectileSpeed or 0)
  unit:setAttack1ProjectileArc(options.projectileArc or 0.0)
  unit:setAttack1ProjectileHomingEnabled(options.projectileHoming or false)
  unit:setAttack1AnimationBackswingPoint(options.attackBackswing)
  unit:setAttack1AnimationDamagePoint(options.attackDamagePoint)
  unit:setAttack1MaximumNumberofTargets(1)
  unit:setAttack1ShowUI(true)
  unit:setProjectileLaunchZ(options.projectileLaunchZ or 60.0)
  unit:setProjectileImpactZ(options.projectileImpactZ or 60.0)
  return unit
end

function createSealGuardUnit(id, parentId, options)
  options.name = options.name or options.displayName or id
  local unit = createSecondLegionUnit(id, parentId, options)
  unit:setRace(Race.Creeps)
  unit:setLevel(options.level or 25)
  unit:setUpgradesUsed(options.upgrades or 'R001')
  unit:setUnitClassification(options.classification or '')
  unit:setCanDropItemsOnDeath(false)
  unit:setGoldBountyAwardedBase(0)
  unit:setGoldBountyAwardedNumberofDice(0)
  unit:setGoldBountyAwardedSidesperDie(0)
  return unit
end
