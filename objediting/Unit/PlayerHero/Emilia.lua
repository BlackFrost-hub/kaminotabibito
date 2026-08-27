-- 爱蜜莉雅玩家英雄物编。
-- 远程冰系英雄；通用字段和远近战攻击分支由 UnitTemplates.lua 统一处理。

createPlayerHeroUnit('E00C', '爱蜜莉雅', {
  baseId = 'Emoo',
  properNames = '爱蜜莉雅',
  tooltipBasic = '召唤爱蜜莉雅',
  tooltipExtended = '冰之精灵术士爱蜜莉雅。',
  description = '冰之精灵术士爱蜜莉雅。',
  modelFile = 'Unit\\Hero\\Emilia\\[Hero]-Emilia_2.mdx',
  scale = 1.0,
  icon = 'ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp',
  normalAbilities = 'A014,AInv,AED1',
  heroAbilities = 'AEQ1,AEW1,AEE1,AER1',
  upgradesUsed = '',

  strength = 20,
  agility = 20,
  intelligence = 30,
  primaryAttribute = 'INT',
  strengthPerLevel = 1.5,
  agilityPerLevel = 2.0,
  intelligencePerLevel = 3.5,

  attackMode = 'ranged',
  attackType = AttackType.Magic,
  attackRange = 650,
  acquire = 650.0,
  attackTargets = 'ground,structure,debris,air,item,ward',
  projectileArt = 'Common\\Effect\\Projectile\\file00000543.mdx',
  projectileSpeed = 1300,
  projectileArc = 0.05,
  projectileHoming = false,
  weaponSound = WeaponSound.Nothing,
})
