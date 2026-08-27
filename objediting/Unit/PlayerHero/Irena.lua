-- 伊蕾娜玩家英雄物编。
-- 远程智力英雄；普通攻击使用独立蓝紫魔法弹。

createPlayerHeroUnit('E00I', '伊蕾娜', {
  baseId = 'Emoo',
  properNames = '伊蕾娜',
  tooltipBasic = '召唤伊蕾娜',
  tooltipExtended = '记录旅途见闻、切换魔法变式并以扫帚调整战场位置的灰之魔女。',
  description = '灰之魔女，远程魔法与机动型英雄。',
  modelFile = 'Unit\\Hero\\Irena\\Irena.mdx',
  scale = 1.0,
  icon = 'ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp',
  normalAbilities = 'A014,AInv,AID1',
  heroAbilities = 'AIQ1,AIW1,AIE1,AIR1',
  upgradesUsed = '',

  strength = 20,
  agility = 22,
  intelligence = 28,
  primaryAttribute = 'INT',
  strengthPerLevel = 1.5,
  agilityPerLevel = 2.0,
  intelligencePerLevel = 3.5,

  attackMode = 'ranged',
  attackType = AttackType.Magic,
  attackRange = 650,
  acquire = 650.0,
  attackTargets = 'ground,structure,debris,air,item,ward',
  projectileArt = 'Common\\Effect\\Projectile\\tt (61).mdx',
  projectileSpeed = 1350,
  projectileArc = 0.05,
  projectileHoming = false,
  weaponSound = WeaponSound.Nothing,
  projectileLaunchZ = 85.0,
  projectileImpactZ = 60.0,
  speed = 315,
  turnRate = 2.0,
})
