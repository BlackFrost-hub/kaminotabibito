-- Pollution Cat Mia boss unit.
-- Raw id keeps the historical Mia id used by older unit config.

createMeleeBossHeroUnit('N00V', '污染之猫·腐化者米亚', {
  modelFile = 'Boss\\PollutionCat Corruptor Mia\\BAIHU.mdx',
  icon = 'Boss\\PollutionCat Corruptor Mia\\mia.blp',
  properNames = '污染之猫·腐化者米亚',
  tooltipBasic = '污染之猫·腐化者米亚',
  tooltipExtended = '污染之猫·腐化者米亚',
  description = '污染之猫·腐化者米亚',

  -- Second-chapter hidden Boss baseline.
  level = 11,
  hp = 36800,
  mana = 1100,
  initialMana = 1100,
  manaRegen = 11.0,
  speed = 354,
  movementType = MovementType.Fly,
  minHeight = 0.0,
  height = 0.0,
  turnRate = 0.66,
  strength = 20,
  agility = 21,
  intelligence = 17,
  strengthPerLevel = 1,
  agilityPerLevel = 1,
  intelligencePerLevel = 1,
  damageBase = 1750,
  attackCooldown = 1.0,
  attackType = AttackType.Chaos,
  defense = 35,
  hpRegen = 294.4,
  goldBountyBase = 550,
  pointValue = 110,

  scale = 3.0,
  collision = 64.0,
  soundSet = 'DruidOfTheClaw',
  classification = 'undead',
  abilities = 'AInv,AT14,AN00',
  upgrades = 'R001,R002',
})
