-- Chapter 3 foreign hidden boss: Shalltear Bloodfallen and Valkyrie form.

local function createShalltearForm(id, name, modelFile, options)
  options = options or {}
  local unit = createMeleeBossHeroUnit(id, name, {
    modelFile = modelFile,
    icon = options.icon or 'ReplaceableTextures\\CommandButtons\\BTNHeroWarden.blp',
    properNames = options.properNames or name,
    tooltipBasic = name,
    tooltipExtended = options.tooltipExtended or '第三章异界隐藏挑战 Boss。',
    description = options.description or '以滴管长枪、鲜血印记和女武神武装追猎挑战者。',

    level = 45,
    hp = 85000,
    mana = 2000,
    initialMana = 2000,
    manaRegen = 20.0,
    speed = options.speed or 400,
    turnRate = 0.85,
    strength = 25,
    agility = 30,
    intelligence = 22,
    strengthPerLevel = 1,
    agilityPerLevel = 1,
    intelligencePerLevel = 1,
    primaryAttribute = 'AGI',
    damageBase = options.damageBase or 3000,
    damageDice = 1,
    damageSides = 1,
    attackCooldown = options.attackCooldown or 1.0,
    attackRange = options.attackRange or 180,
    attackTargets = 'ground,structure,debris,item,ward',
    attackType = AttackType.Normal,
    weaponType = WeaponType.Normal,
    defense = options.defense or 35,
    hpRegen = 680.0,
    regenType = 'always',
    scale = options.scale or 1.65,
    collision = options.collision or 36.0,
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
    pointValue = options.pointValue or 520,
    hideHeroDeathMsg = true,
    dropItems = false,
  })

  unit:setAnimationCastBackswing(0.18)
  unit:setAnimationCastPoint(options.castPoint or 0.32)
  unit:setAttack1AnimationBackswingPoint(options.attackBackswing or 0.45)
  unit:setAttack1AnimationDamagePoint(options.attackDamagePoint or 0.38)
  unit:setAttack1RangeMotionBuffer(260.0)
  unit:setAttack1MaximumNumberofTargets(1)
  unit:setAttack1ShowUI(true)
  unit:setAttack1WeaponSound(WeaponSound.MetalHeavySlice)
  unit:setArmorSoundType(ArmorSoundType.Metal)
  unit:setDeathType(2)
  unit:setSelectionScale(options.selectionScale or 1.45)
  return unit
end

createShalltearForm('U009', '夏提雅·布拉德弗伦', 'Boss\\ShalltearBloodfallen\\Shalltear.mdx', {
  icon = 'Boss\\ShalltearBloodfallen\\Shalltear.blp',
  properNames = '真祖吸血鬼·夏提雅',
  tooltipExtended = '夏提雅的常态礼服战斗形态，也是挑战开场与 P1 使用的正式单位。',
  description = '优雅而危险的真祖吸血鬼，以滴管长枪建立连续追击与鲜血循环。',
})

createShalltearForm('U00A', '夏提雅·女武神形态', 'Boss\\ShalltearBloodfallen\\ShalltearValkyrie.mdx', {
  icon = 'Boss\\ShalltearBloodfallen\\ShalltearValkyrie.blp',
  properNames = '鲜血女武神·夏提雅',
  tooltipExtended = '夏提雅进入英灵战乙女或高压阶段时使用的武装形态。',
  description = '血色铠甲与双翼完全展开，攻击节奏和正面压迫进一步提高。',
  speed = 420,
  damageBase = 4125,
  attackCooldown = 0.9,
  attackRange = 200,
  defense = 35,
  scale = 1.45,
  collision = 40.0,
  castPoint = 0.38,
  attackBackswing = 0.55,
  attackDamagePoint = 0.45,
  selectionScale = 1.65,
  pointValue = 0,
})
