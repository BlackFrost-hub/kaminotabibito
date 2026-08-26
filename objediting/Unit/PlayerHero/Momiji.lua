-- 朱雀院红叶玩家英雄物编。
-- 近战敏捷剑士；近战攻击不得配置投射物。

createPlayerHeroUnit('E00G', '朱雀院红叶', {
  baseId = 'Edem',
  properNames = '朱雀院红叶',
  tooltipBasic = '召唤朱雀院红叶',
  tooltipExtended = '擅长制造破绽、招架反击与高速终式的近战剑士。',
  description = '朱雀院流近战技巧型剑士。',
  modelFile = 'Unit\\Hero\\Momiji\\Momiji.mdx',
  icon = 'ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiQ.blp',
  normalAbilities = 'A014,AInv,AMD1',
  heroAbilities = 'AMQ1,AMW1,AME1,AMR1',
  upgradesUsed = '',

  strength = 25,
  agility = 30,
  intelligence = 15,
  primaryAttribute = 'AGI',
  strengthPerLevel = 2.0,
  agilityPerLevel = 3.5,
  intelligencePerLevel = 1.5,

  attackMode = 'melee',
  attackType = AttackType.Normal,
  attackRange = 150,
  acquire = 600.0,
  attackTargets = 'ground,structure,debris,air,item,ward',
  projectileArt = '',
  projectileSpeed = 0,
  projectileArc = 0.0,
  projectileHoming = false,
  weaponSound = WeaponSound.MetalMediumSlice,
  attackCooldown = 2.0,
  attackBackswing = 0.35,
  attackDamagePoint = 0.25,
  speed = 330,
  turnRate = 3.0,
})
