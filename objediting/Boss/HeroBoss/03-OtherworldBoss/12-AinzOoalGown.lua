-- Chapter 3 postgame foreign boss: Ainz Ooal Gown and guardian Albedo.

local ainz = createRangedBossHeroUnit('U007', '安兹·乌尔·恭', {
  modelFile = 'Boss\\AinzOoalGown\\AinzOoalGown.mdx',
  icon = 'Boss\\AinzOoalGown\\AinzOoalGown.blp',
  properNames = '纳萨力克地下大坟墓统治者',
  tooltipBasic = '安兹·乌尔·恭',
  tooltipExtended = '远高于第三章常规强度的异界隐藏 Boss。',
  description = '死亡支配者与纳萨力克至尊，以高阶魔法和阶段法则审视挑战者。',

  level = 50,
  hp = 100000,
  mana = 5000,
  initialMana = 5000,
  manaRegen = 35.0,
  speed = 340,
  turnRate = 0.55,
  strength = 24,
  agility = 18,
  intelligence = 32,
  strengthPerLevel = 2.0,
  agilityPerLevel = 1.5,
  intelligencePerLevel = 3.2,
  primaryAttribute = 'INT',
  damageBase = 3200,
  damageDice = 1,
  damageSides = 1,
  attackCooldown = 1.8,
  attackRange = 1200,
  attackTargets = 'ground,air,enemy,neutral,structure,debris,item,ward',
  attackType = AttackType.Magic,
  weaponType = WeaponType.Missile,
  projectileArt = 'Boss\\AinzOoalGown\\Projectile\\AinzMagicMissile.mdx',
  projectileSpeed = 1400,
  defense = 35,
  hpRegen = 300.0,
  regenType = 'always',
  scale = 1.7,
  collision = 48.0,
  soundSet = '',
  classification = 'undead',
  abilities = 'AInv,AT08,BT08,CT08,AN00',
  upgrades = 'R001,R002',
  acquire = 1300.0,
  sightDay = 1900,
  sightNight = 1600,
  goldBountyBase = 0,
  goldBountyDice = 0,
  goldBountySides = 0,
  pointValue = 600,
  hideHeroDeathMsg = true,
  dropItems = false,
})

ainz:setAnimationCastBackswing(0.20)
ainz:setAnimationCastPoint(0.35)
ainz:setAttack1AnimationBackswingPoint(0.45)
ainz:setAttack1AnimationDamagePoint(0.55)
ainz:setAttack1MaximumNumberofTargets(1)
ainz:setAttack1ShowUI(true)
ainz:setAttack1WeaponSound(WeaponSound.Nothing)
ainz:setArmorSoundType(ArmorSoundType.Metal)
ainz:setDeathType(2)
ainz:setSelectionScale(1.85)

local albedo = createMeleeBossHeroUnit('U008', '雅儿贝德', {
  modelFile = 'Boss\\AinzOoalGown\\Albedo.mdx',
  icon = 'Boss\\AinzOoalGown\\Albedo.blp',
  properNames = '纳萨力克守护者总管',
  tooltipBasic = '雅儿贝德',
  tooltipExtended = '安兹守护者介入模式中的真实护卫单位。',
  description = '以重甲、黑翼和绝对忠诚守护至尊；生命降至最低比例后锁血而不死亡。',

  level = 48,
  hp = 70000,
  mana = 1500,
  initialMana = 1500,
  manaRegen = 12.0,
  speed = 400,
  turnRate = 0.75,
  strength = 30,
  agility = 22,
  intelligence = 18,
  strengthPerLevel = 3.0,
  agilityPerLevel = 2.0,
  intelligencePerLevel = 1.6,
  primaryAttribute = 'STR',
  damageBase = 2800,
  damageDice = 1,
  damageSides = 1,
  attackCooldown = 1.45,
  attackRange = 140,
  attackTargets = 'ground,structure,debris,item,ward',
  attackType = AttackType.Normal,
  weaponType = WeaponType.Normal,
  defense = 35,
  hpRegen = 0.0,
  regenType = 'always',
  scale = 2.2,
  collision = 42.0,
  soundSet = '',
  classification = 'undead',
  abilities = 'AInv',
  upgrades = 'R001,R002',
  acquire = 1200.0,
  sightDay = 1800,
  sightNight = 1500,
  goldBountyBase = 0,
  goldBountyDice = 0,
  goldBountySides = 0,
  pointValue = 300,
  hideHeroDeathMsg = true,
  dropItems = false,
})

albedo:setAnimationCastBackswing(0.20)
albedo:setAnimationCastPoint(0.40)
albedo:setAttack1AnimationBackswingPoint(0.55)
albedo:setAttack1AnimationDamagePoint(0.65)
albedo:setAttack1MaximumNumberofTargets(1)
albedo:setAttack1ShowUI(true)
albedo:setAttack1WeaponSound(WeaponSound.MetalHeavyBash)
albedo:setArmorSoundType(ArmorSoundType.Metal)
albedo:setDeathType(2)
albedo:setSelectionScale(1.65)
