-- Chapter 2 hidden boss: Corrupted Ancient Moltes.

local moltes = createMeleeBossHeroUnit('N05W', '古木之蚀·莫尔特斯', {
  modelFile = 'Boss\\Moltes\\Moltes.mdx',
  icon = 'Boss\\Moltes\\Moltes.blp',
  properNames = '古木之蚀·莫尔特斯',
  tooltipBasic = '古木之蚀·莫尔特斯',
  tooltipExtended = '古木之蚀·莫尔特斯',
  description = '古木之蚀·莫尔特斯',

  level = 35,
  hp = 64000,
  mana = 1000,
  initialMana = 1000,
  manaRegen = 5.0,
  speed = 372,
  strength = 20,
  agility = 20,
  intelligence = 20,
  strengthPerLevel = 1,
  agilityPerLevel = 1,
  intelligencePerLevel = 1,
  damageBase = 2500,
  damageDice = 1,
  damageSides = 1,
  attackCooldown = 1.15,
  attackType = AttackType.Chaos,
  weaponType = WeaponType.Instant,
  defense = 35,
  hpRegen = 480.0,
  scale = 2.0,
  soundSet = 'AncientOfWar',
  classification = 'undead',
  abilities = 'AInv,AN00,AN01,AT12,BT08,AN02',
  upgrades = 'R001,R002',
  acquire = 1200.0,
  sightNight = 1400,
  goldBountyBase = 3500,
  lumberBountyBase = 2,
  pointValue = 390,
})

moltes:setTintingColorRed(255)
moltes:setTintingColorGreen(155)
moltes:setTintingColorBlue(255)
