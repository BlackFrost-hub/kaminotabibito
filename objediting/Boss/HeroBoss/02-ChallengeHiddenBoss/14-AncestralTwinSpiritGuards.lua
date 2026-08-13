-- Ancestral Twin Spirit Guards: two normal forms and two corrupted forms.

local function createTwinSpiritGuardForm(id, name, modelFile, icon, scale, description)
  local unit = createMeleeBossHeroUnit(id, name, {
    baseId = 'Udea',
    modelFile = modelFile,
    icon = icon,
    properNames = name,
    tooltipBasic = name,
    tooltipExtended = '祖地双灵卫联合战斗单位。',
    description = description,

    level = 40,
  hp = 20608,
    mana = 1000,
    initialMana = 1000,
    manaRegen = 10.0,
    speed = 400,
    turnRate = 0.75,
    strength = 20,
    agility = 20,
    intelligence = 20,
    strengthPerLevel = 1,
    agilityPerLevel = 1,
    intelligencePerLevel = 1,
    primaryAttribute = 'STR',
  damageBase = 1030,
    damageDice = 1,
    damageSides = 1,
    attackCooldown = 0.8,
    attackRange = 128,
    attackTargets = 'ground,structure,debris,item,ward',
    attackType = AttackType.Normal,
    weaponType = WeaponType.Normal,
    defense = 35,
    armorType = ArmorType.Hero,
    hpRegen = 206.08,
    regenType = 'always',
    scale = scale,
    collision = 40.0,
    soundSet = '',
    race = Race.Creeps,
    classification = 'undead',
    abilities = 'AInv',
    upgrades = 'R001,R002',
    acquire = 1200.0,
    sightDay = 1800,
    sightNight = 1400,
    goldBountyBase = 0,
    goldBountyDice = 0,
    goldBountySides = 0,
    pointValue = 0,
    hideHeroDeathMsg = true,
    dropItems = false,
  })

  unit:setAttack1AnimationBackswingPoint(0.45)
  unit:setAttack1AnimationDamagePoint(0.40)
  unit:setAttack1MaximumNumberofTargets(1)
  unit:setAttack1ShowUI(true)
  unit:setAttack1WeaponSound(WeaponSound.MetalHeavySlice)
  unit:setArmorSoundType(ArmorSoundType.Metal)
  unit:setDeathType(2)
  unit:setSelectionScale(scale * 0.9)
  return unit
end

createTwinSpiritGuardForm(
  'U00F',
  '赤誓灵卫',
  'Boss\\AncestralTwinSpiritGuards\\RedOathGuard.mdx',
  'Boss\\AncestralTwinSpiritGuards\\Icon\\BTNRedOathGuard.blp',
  1.78,
  '祖地灵印的赤誓守卫，以剑术、折步和灵印判断阻止入侵者。'
)

createTwinSpiritGuardForm(
  'U00B',
  '裂誓战躯',
  'Boss\\AncestralTwinSpiritGuards\\RedOathMutant.mdx',
  'Boss\\AncestralTwinSpiritGuards\\Icon\\BTNRedOathMutant.blp',
  2.22,
  '赤誓灵卫被侵蚀后显露的沉重战躯，只剩失控的守门武魂。'
)

createTwinSpiritGuardForm(
  'U00E',
  '苍影灵卫',
  'Boss\\AncestralTwinSpiritGuards\\AzureShadeGuard.mdx',
  'Boss\\AncestralTwinSpiritGuards\\Icon\\BTNAzureShadeGuard.blp',
  1.50,
  '祖地封门的苍影守卫，以灵识、剑盾和防御阵线阻止入侵者。'
)

createTwinSpiritGuardForm(
  'U00D',
  '无面祷影',
  'Boss\\AncestralTwinSpiritGuards\\AzureShadeMutant.mdx',
  'Boss\\AncestralTwinSpiritGuards\\Icon\\BTNAzureShadeMutant.blp',
  3.50,
  '苍影灵卫被侵蚀后留下的空洞祷影，记忆与面容已经被完全剥离。'
)
