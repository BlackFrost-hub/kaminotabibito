-- 芙莉莲玩家英雄物编。
-- 远程智力英雄；普通攻击使用独立白紫魔法弹。

createPlayerHeroUnit('E00K', '芙莉莲', {
  baseId = 'Emoo',
  properNames = '芙莉莲',
  tooltipBasic = '召唤芙莉莲',
  tooltipExtended = '通过长期解析、魔力护壁和贯穿魔法完成战斗的精灵魔法使。',
  description = '解析与远程贯穿型智力英雄。',
  modelFile = 'Unit\\Hero\\Frieren\\Frieren.mdx',
  scale = 1.0,
  icon = 'ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp',
  normalAbilities = 'A014,AInv,AFD1',
  heroAbilities = '',
  upgradesUsed = '',

  strength = 18,
  agility = 22,
  intelligence = 30,
  primaryAttribute = 'INT',
  strengthPerLevel = 1.5,
  agilityPerLevel = 2.0,
  intelligencePerLevel = 3.5,

  attackMode = 'ranged',
  attackType = AttackType.Magic,
  attackRange = 700,
  acquire = 700.0,
  attackTargets = 'ground,structure,debris,air,item,ward',
  projectileArt = 'Common\\Effect\\Projectile\\FrierenAttackBolt.mdx',
  projectileSpeed = 1400,
  projectileArc = 0.03,
  projectileHoming = false,
  weaponSound = WeaponSound.Nothing,
  projectileLaunchZ = 95.0,
  projectileImpactZ = 60.0,
  speed = 305,
  turnRate = 2.0,
})
