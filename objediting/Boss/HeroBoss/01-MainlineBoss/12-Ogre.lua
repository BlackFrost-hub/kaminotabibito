-- Chapter 2 mainline boss: Ogre variants.

local desertOgre = createMeleeBossHeroUnit('N05J', '沙漠食人魔', {
  modelFile = 'Boss\\Ogre\\OgrePaladinV1.00.mdx',
  icon = 'ReplaceableTextures\\CommandButtons\\BTNArmoredOge.blp',
  properNames = '',
  tooltipBasic = '沙漠食人魔',
  tooltipExtended = '沙漠食人魔',
  description = '沙漠食人魔',

  level = 20,
  hp = 8500,
  mana = 100,
  initialMana = 1000,
  manaRegen = 2.0,
  speed = 362,
  strength = 1,
  agility = 1,
  intelligence = 1,
  strengthPerLevel = 1,
  agilityPerLevel = 1,
  intelligencePerLevel = 1,
  damageBase = 265,
  attackCooldown = 2.0,
  attackType = AttackType.Chaos,
  defense = 35,
  hpRegen = 68.0,
  scale = 3.0,
  abilities = 'AInv,A0KV,A0KX,A0KY,A0KZ',
  upgrades = 'R001,R002',
  acquire = 1200.0,
  sightNight = 1400,
  goldBountyBase = 500,
})
desertOgre:setIconScoreScreen('ReplaceableTextures\\CommandButtons\\BTNArmoredOge.blp')
desertOgre:setSelectionScale(1.0)
desertOgre:setLumberBountyAwardedBase(1)

local killingOgre = createMeleeBossHeroUnit('N05K', '杀戮食人魔', {
  modelFile = 'Boss\\Ogre\\Cho\'Gall_Possessed.mdx',
  icon = 'ReplaceableTextures\\CommandButtons\\BTNAbomination.blp',
  properNames = '',
  tooltipBasic = '杀戮食人魔',
  tooltipExtended = '杀戮食人魔',
  description = '杀戮食人魔',

  level = 20,
  hp = 11500,
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
  damageBase = 415,
  attackCooldown = 2.0,
  attackType = AttackType.Siege,
  defense = 40,
  hpRegen = 92.0,
  scale = 3.0,
  abilities = 'AInv,A0KW,A0L0,A0L1,A0KZ',
  upgrades = 'R001,R002',
  acquire = 1200.0,
  sightNight = 1400,
  goldBountyBase = 500,
})
killingOgre:setIconScoreScreen('ReplaceableTextures\\CommandButtons\\BTNAbomination.blp')
killingOgre:setSelectionScale(1.5)
killingOgre:setLumberBountyAwardedBase(1)
