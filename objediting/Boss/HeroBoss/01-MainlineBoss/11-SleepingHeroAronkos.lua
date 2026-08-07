-- Chapter 3 graveyard boss: Sleeping Hero Aronkos.

local aronkos = createMeleeBossHeroUnit('U006', '沉睡英魂·亚伦柯斯', {
  baseId = 'Udea',
  modelFile = 'Boss\\SleepingHeroAronkos\\SleepingHeroAronkos.mdx',
  icon = 'Boss\\SleepingHeroAronkos\\Aronkos.blp',
  properNames = '沉睡英魂·亚伦柯斯',
  tooltipBasic = '沉睡英魂·亚伦柯斯',
  tooltipExtended = '沉睡英魂·亚伦柯斯',
  description = '沉眠于墓地中的古老英魂，仍以死亡骑士之姿守望旧日誓约。',
  requirements = 'unp1,unp2',

  level = 40,
  hp = 68000,
  mana = 1000,
  initialMana = 1000,
  manaRegen = 10.0,
  speed = 400,
  speedMinimum = 0,
  speedMaximum = 0,
  turnRate = 0.5,
  strength = 20,
  agility = 20,
  intelligence = 20,
  strengthPerLevel = 1,
  agilityPerLevel = 1,
  intelligencePerLevel = 1,
  primaryAttribute = 'STR',
  damageBase = 2350,
  damageDice = 2,
  damageSides = 6,
  attackCooldown = 0.8,
  attackRange = 100,
  attackTargets = 'ground,structure,debris,item,ward',
  attackType = AttackType.Normal,
  weaponType = WeaponType.Normal,
  defense = 25,
  armorType = ArmorType.Hero,
  hpRegen = 544.0,
  regenType = 'blight',
  scale = 2.0,
  collision = 32.0,
  soundSet = 'HeroDeathKnight',
  race = Race.Creeps,
  classification = 'undead',
  abilities = 'AInv,AT00,AN00',
  upgrades = 'R001,R002',
  acquire = 1200.0,
  sightDay = 1800,
  sightNight = 1400,
  goldBountyBase = 4000,
  goldBountyDice = 8,
  goldBountySides = 3,
  pointValue = 100,
  priority = 9,
  formation = 0,
})

-- Fields inherited from the old Udea object that are not part of the common Boss template.
aronkos:setAttack1AnimationBackswingPoint(0.41)
aronkos:setAttack1AnimationDamagePoint(0.56)
aronkos:setAttack1RangeMotionBuffer(250.0)
aronkos:setAttack1MaximumNumberofTargets(1)
aronkos:setAttack1ShowUI(true)
aronkos:setAttack1WeaponSound(WeaponSound.MetalHeavySlice)
aronkos:setArmorSoundType(ArmorSoundType.Metal)
aronkos:setDeathType(2)
aronkos:setSelectionScale(1.85)

aronkos:setGoldCost(425)
aronkos:setLumberCost(100)
aronkos:setBuildTime(55)
aronkos:setRepairGoldCost(425)
aronkos:setRepairLumberCost(100)
aronkos:setRepairTime(55)
aronkos:setStockMaximum(3)
aronkos:setStockStartDelay(0)
aronkos:setStockReplenishInterval(30)
aronkos:setLumberBountyAwardedBase(1)
aronkos:setLumberBountyAwardedNumberofDice(0)
aronkos:setLumberBountyAwardedSidesperDie(0)
