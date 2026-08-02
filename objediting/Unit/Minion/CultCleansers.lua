-- Chapter 1 cult cleansing units.

local scholar = createSecondLegionUnit('n065', 'nw2w', {
  name = '教派清理者（学者）',
  description = '研究并执行教派净化仪式的恶魔学者。',
  modelFile = 'Unit\\Minion\\FelorcCultist.mdx',
  icon = 'Unit\\Minion\\Icon\\FelorcCultist.blp',
  scale = 1.20,
  hp = 10500,
  hpRegen = 70.0,
  mana = 1000,
  manaRegen = 10.0,
  defense = 20,
  speed = 320,
  collision = 24.0,
  acquire = 850.0,
  pointValue = 250,
  bounty = 1000,
  damage = 1700,
  attackCooldown = 2.00,
  attackRange = 700,
  rangeBuffer = 250.0,
  attackTargets = 'ground,air,enemy,neutral,structure,debris,item,ward',
  attackType = AttackType.Magic,
  weaponType = WeaponType.Missile,
  weaponSound = WeaponSound.Nothing,
  projectileArt = 'Abilities\\Weapons\\DruidoftheTalonMissile\\DruidoftheTalonMissile.mdl',
  projectileSpeed = 900,
  projectileArc = 0.15,
  projectileHoming = true,
  projectileLaunchZ = 90.0,
  projectileImpactZ = 60.0,
  attackBackswing = 0.60,
  attackDamagePoint = 0.50,
})
scholar:setRace(Race.Demon)
scholar:setLevel(33)
scholar:setUpgradesUsed('R001,R002')

local warrior = createSecondLegionUnit('n066', 'nban', {
  name = '教派清理者（战士）',
  description = '负责近身清除异端与守卫的恶魔战士。',
  modelFile = 'Unit\\Minion\\HeroFleshKnight.mdx',
  icon = 'Unit\\Minion\\Icon\\HeroFleshKnight.blp',
  scale = 1.05,
  hp = 13500,
  hpRegen = 90.0,
  defense = 25,
  speed = 340,
  collision = 32.0,
  acquire = 750.0,
  pointValue = 300,
  bounty = 1250,
  damage = 2000,
  attackCooldown = 1.60,
  attackRange = 128,
  rangeBuffer = 250.0,
  attackTargets = 'ground,enemy,neutral,structure,debris,item,ward',
  attackType = AttackType.Normal,
  weaponType = WeaponType.Normal,
  weaponSound = WeaponSound.MetalHeavyChop,
  attackBackswing = 0.50,
  attackDamagePoint = 0.40,
})
warrior:setRace(Race.Demon)
warrior:setLevel(33)
warrior:setUpgradesUsed('R001,R002')
