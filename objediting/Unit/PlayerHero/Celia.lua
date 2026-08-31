-- 塞莉亚·克莱尔玩家英雄物编。
-- 远程智力英雄；普通攻击复用缩放克制的棱晶弹体表现。

createPlayerHeroUnit('E00J', '塞莉亚·克莱尔', {
  baseId = 'Emoo',
  properNames = '塞莉亚·克莱尔',
  tooltipBasic = '召唤塞莉亚·克莱尔',
  tooltipExtended = '以公式节点、解析结界和锚定术式组织战场的天才魔术师。',
  description = '连锁演算与区域控制型远程智力英雄。',
  modelFile = 'Unit\\Hero\\Celia\\Celia.mdx',
  scale = 1.0,
  icon = 'ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp',
  normalAbilities = 'A014,AInv,AKD1',
  heroAbilities = '',
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
  projectileArt = 'Common\\Effect\\Projectile\\CeliaPrismBolt.mdx',
  projectileSpeed = 1250,
  projectileArc = 0.05,
  projectileHoming = false,
  weaponSound = WeaponSound.Nothing,
  projectileLaunchZ = 90.0,
  projectileImpactZ = 60.0,
  speed = 310,
  turnRate = 2.0,
})
