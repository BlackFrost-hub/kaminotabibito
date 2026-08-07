-- Chapter 3 transition boss: Lir Bert.

local lirBert = createMeleeBossHeroUnit('N05L', '利尔·伯特', {
  modelFile = 'Boss\\LirBert\\liz_armor_new22_unit.mdx',
  icon = 'Boss\\LirBert\\Icon\\LirBert.blp',
  properNames = '皇家卫队队长',
  tooltipBasic = '利尔·伯特',
  tooltipExtended = '利尔·伯特',
  description = '利尔·伯特',

  level = 30,
  hp = 10000,
  mana = 100,
  initialMana = 0,
  manaRegen = 2.0,
  speed = 400,
  strength = 1,
  agility = 1,
  intelligence = 1,
  strengthPerLevel = 1,
  agilityPerLevel = 1,
  intelligencePerLevel = 1,
  damageBase = 450,
  attackCooldown = 1.5,
  attackType = AttackType.Pierce,
  defense = 25,
  hpRegen = 80.0,
  scale = 2.5,
  abilities = 'A0L4,A0L3,A0L2,AInv',
  upgrades = 'R001,R002',
  acquire = 1200.0,
  sightNight = 1400,
  goldBountyBase = 500,
})
lirBert:setIconScoreScreen('Boss\\LirBert\\Icon\\LirBert.blp')
lirBert:setAttack1WeaponSound(WeaponSound.MetalHeavySlice)
lirBert:setLumberBountyAwardedBase(1)
