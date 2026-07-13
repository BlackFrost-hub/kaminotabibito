-- Pollution Cat Mia boss unit.
-- Raw id keeps the historical Mia id used by older unit config.

createMeleeBossHeroUnit('N00V', '污染之猫·腐化者米亚', {
  modelFile = 'Boss\\PollutionCat Corruptor Mia\\BAIHU.mdx',
  icon = 'Boss\\PollutionCat Corruptor Mia\\mia.blp',
  properNames = '污染之猫·腐化者米亚',
  tooltipBasic = '污染之猫·腐化者米亚',
  tooltipExtended = '污染之猫·腐化者米亚',
  description = '污染之猫·腐化者米亚',

  -- Compared with Thranduil's Boss baseline, Mia is about 10% stronger.
  level = 11,
  hp = 22000,
  mana = 1100,
  initialMana = 1100,
  manaRegen = 11.0,
  speed = 354,
  movementType = MovementType.Amphipic,
  turnRate = 0.66,
  strength = 20,
  agility = 21,
  intelligence = 17,
  strengthPerLevel = 2.10,
  agilityPerLevel = 1.65,
  intelligencePerLevel = 2.85,
  damageBase = 1000,
  attackCooldown = 1.82,
  attackType = AttackType.Chaos,
  defense = 35,
  goldBountyBase = 550,
  pointValue = 110,

  scale = 1.0,
  collision = 64.0,
  soundSet = 'DruidOfTheClaw',
  classification = 'undead',
  abilities = 'AInv,AT14,AN00',
  upgrades = 'R001,R002',
})
