local DEFAULT_DUMMY_ICON = 'ReplaceableTextures\\CommandButtons\\BTNNecromancerAdept.blp'

-- 单位“物编-Art-图标”不要写 setArt。
-- 这套 ObjEditing 的真实单位 API 需要去 `.def/def/` 查定义：
-- 例如单位图标字段 `uico` 对应 `.def/def/UnitOrBuildingOrHeroDefinition.lua`
-- 真实 setter 是 `setIconGameInterface(...)`。
local function applyCommonDummyUnit(u, options)
  options = options or {}
  u:setName(options.name or '')
  u:setTooltipBasic(options.tooltipBasic or '')
  u:setTooltipExtended(options.tooltipExtended or '')
  u:setDescription(options.description or '')
  u:setNormalAbilities(options.abilities or 'Aloc')
  u:setCollisionSize(options.collision or 0.0)
  u:setModelFile(options.modelFile or '.mdl')
  if options.modelFileExtraVersions ~= nil then
    u:setModelFileExtraVersions(tostring(options.modelFileExtraVersions))
  end
  if options.scale ~= nil then
    u:setScalingValue(options.scale)
  end
  u:setIconGameInterface(options.icon or DEFAULT_DUMMY_ICON)
  if options.special ~= nil then
    u:setSpecial(options.special)
  end
  u:setStructuresBuilt('')
  u:setUpgradesUsed('')
  u:setUnitSoundSet('')
  u:setAnimationCastBackswing(0.0)
  u:setAnimationCastPoint(0.0)
  if options.animationBlend ~= nil then
    u:setAnimationBlendTimeseconds(options.animationBlend)
  end
  if options.animationRunSpeed ~= nil then
    u:setAnimationRunSpeed(options.animationRunSpeed)
  end
  if options.animationWalkSpeed ~= nil then
    u:setAnimationWalkSpeed(options.animationWalkSpeed)
  end
  u:setMovementType(options.movementType or MovementType.Foot)
  u:setMovementHeightMinimum(options.minHeight or 0.0)
  u:setMovementHeight(options.height or 0.0)
  u:setSpeedBase(options.speedBase or 1)
  u:setSpeedMinimum(options.speedMinimum or 0)
  u:setSpeedMaximum(options.speedMaximum or 0)
  u:setUnitClassification(options.classification or 'ancient')
  u:setHitPointsRegenerationType('always')
  u:setHitPointsMaximumBase(options.hp or 1)
  u:setHitPointsRegenerationRate(options.hpRegen or 0.0)
  u:setManaMaximum(options.mana or 0)
  u:setManaRegeneration(options.manaRegen or 0.0)
  u:setManaInitialAmount(options.initialMana or 0)
  u:setFoodProduced(0)
  u:setHideMinimapDisplay(options.hideMinimap ~= false)
  u:setSightRadiusDay(options.sightDay or 0)
  u:setSightRadiusNight(options.sightNight or 0)
  u:setTurnRate(options.turnRate or 3.0)
  u:setPropulsionWindowdegrees(options.propulsionWindow or 360.0)
  if options.selectionScale ~= nil then
    u:setSelectionScale(options.selectionScale)
  end
  return u
end

local function applyNoCostNoBounty(u)
  u:setFoodCost(0)
  u:setGoldCost(0)
  u:setLumberCost(0)
  u:setBuildTime(0)
  u:setRepairTime(0)
  u:setRepairGoldCost(0)
  u:setRepairLumberCost(0)
  u:setGoldBountyAwardedBase(0)
  u:setGoldBountyAwardedNumberofDice(0)
  u:setGoldBountyAwardedSidesperDie(0)
  u:setLumberBountyAwardedBase(0)
  u:setLumberBountyAwardedNumberofDice(0)
  u:setLumberBountyAwardedSidesperDie(0)
end

-- Buff dummy unit helper
local function createBuffUnit(id, name)
  local u = UnitDefinition:new(id, 'ewsp')
  applyCommonDummyUnit(u, {
    name = name,
    hp = 10000,
    hpRegen = 100.0,
    mana = 10000,
    manaRegen = 1000.0,
    initialMana = 1000,
  })
  return u
end

createBuffUnit('bHun', 'SFB_Unit')
createBuffUnit('sfb1', '[系统]增益buff')
createBuffUnit('sfb2', '[系统]负面buff')

-- Charge / cast progress bar unit
local e01O = UnitDefinition:new('e01O', 'ewsp')
applyCommonDummyUnit(e01O, {
  name = '[系统]施法进度条',
  modelFile = 'war3mapImported\\Progressbar.mdx',
  scale = 1.0,
  movementType = MovementType.Fly,
  minHeight = 233.0,
  height = 233.0,
  selectionScale = 0.0,
})

-- 红色圆形提示圈单位
local scir = UnitDefinition:new('scir', 'ewsp')
applyCommonDummyUnit(scir, {
  name = '[系统]圆形提示圈',
  modelFile = 'resource\\models\\Tip\\skillTip\\Abiltip_ring.mdx',
  scale = 1.0,
  minHeight = 100.0,
  height = 100.0,
  selectionScale = 0.0,
})

-- Common summon shell unit.
-- Ground pathing only: use height / runtime SetUnitFlyHeight for visual floating,
-- never MovementType.Fly.
local summonShell = UnitDefinition:new('e08P', 'ewsp')
applyCommonDummyUnit(summonShell, {
  name = '[系统]通用召唤物壳子',
  tooltipBasic = '[系统]通用召唤物壳子',
  tooltipExtended = '代码侧通用召唤物壳子单位。',
  description = '代码侧通用召唤物壳子单位。',
  modelFile = '.mdl',
  modelFileExtraVersions = 0,
  icon = 'ReplaceableTextures\\CommandButtons\\BTNSentryWard.blp',
  abilities = '',
  movementType = MovementType.Foot,
  minHeight = 0.0,
  height = 10.0,
  speedBase = 300,
  speedMinimum = 0,
  speedMaximum = 522,
  classification = '',
  hp = 100,
  hpRegen = 0.0,
  sightDay = 1400,
  sightNight = 1400,
  collision = 16.0,
  turnRate = 1.0,
  propulsionWindow = 60.0,
  selectionScale = 1.0,
})
applyNoCostNoBounty(summonShell)
summonShell:setLevel(5)
summonShell:setAcquisitionRange(600.0)
summonShell:setAttacksEnabled(AttacksEnabled.AttackOneOnly)
summonShell:setAttack1AttackType(AttackType.Pierce)
summonShell:setAttack1DamageBase(1)
summonShell:setAttack1DamageNumberofDice(1)
summonShell:setAttack1DamageSidesperDie(1)
summonShell:setAttack1CooldownTime(1.0)
summonShell:setAttack1Range(128)
summonShell:setAttack1TargetsAllowed('ground,air,enemy,neutral')
summonShell:setAttack1WeaponType(WeaponType.Missile)
summonShell:setAttack1ProjectileSpeed(900)
summonShell:setAttack1WeaponSound(WeaponSound.Nothing)
summonShell:setDefenseBase(0)
summonShell:setDefenseUpgradeBonus(0)
summonShell:setArmorType(ArmorType.Normal)
summonShell:setPointValue(0)
summonShell:setPriority(0)
summonShell:setFormationRank(0)
summonShell:setCanFlee(false)

-- 坂井悠二 D「祭礼之蛇」专用特效承载马甲。
-- 源 JASS 的 SetUnitScale(1.20/4.00) 依赖单位物编基础缩放 1.00，不能复用基础缩放 2.50 的 eaaa。
local e06V = UnitDefinition:new('e06V', 'ewsp')
applyCommonDummyUnit(e06V, {
  name = '[英雄技能]坂井悠二D祭礼之蛇马甲',
  modelFile = 'Common\\Model\\Dummy\\SakaiYuujiD\\dummy.mdx',
  scale = 1.00,
  movementType = MovementType.Fly,
  minHeight = 0.0,
  height = 50.0,
  speedBase = 522,
  turnRate = 3.0,
  classification = 'ancient',
  hp = 99999,
  hpRegen = 0.0,
  hideMinimap = true,
  sightDay = 0,
  sightNight = 0,
  selectionScale = 0.0,
})
e06V:setModelFileExtraVersions('0')
-- 源物编 X/Y 轴最大旋转角度均为 0；禁止坡面俯仰/侧倾传给 origin 挂载的蛇头与蛇身。
e06V:setMaximumPitchAngledegrees(0.0)
e06V:setMaximumRollAngledegrees(0.0)
applyNoCostNoBounty(e06V)
e06V:setSelectionCircleHeight(0.0)
e06V:setSelectionCircleOnWater(false)
e06V:setDeathTimeseconds(0.1)

-- TS 原生弹幕默认马甲单位
-- 分类约定：
-- ancient = 蝗虫单位，mechanical + ward = 弹幕/技能弹道。
-- tauren 不在物编默认加，运行时由 TS 原生弹幕按“不可阻挡”动态添加。
local eaaa = UnitDefinition:new('eaaa', 'ewsp')
applyCommonDummyUnit(eaaa, {
  name = '[系统]TS原生弹幕马甲',
  -- 通用辅助马甲模型：根目录 dummy.mdx 文件头有效且带 origin 挂点。
  modelFile = 'dummy.mdx',
  scale = 2.50,
  icon = 'ReplaceableTextures\\CommandButtons\\BTNHumArtilleryUpOne.blp',
  special = 'Units\\NightElf\\Wisp\\WispExplode.mdl',
  animationBlend = 0.0,
  animationRunSpeed = 0.0,
  animationWalkSpeed = 0.0,
  movementType = MovementType.Fly,
  minHeight = 0.0,
  height = 75.0,
  classification = 'ancient,mechanical,ward',
  hp = 99,
  hpRegen = -1.0,
  hideMinimap = false,
  sightDay = 500,
  sightNight = 500,
  turnRate = 1.0,
  propulsionWindow = 1.0,
  selectionScale = 1.0,
})
eaaa:setModelFileExtraVersions('0')
applyNoCostNoBounty(eaaa)
eaaa:setSelectionCircleHeight(0.0)
eaaa:setSelectionCircleOnWater(false)
eaaa:setScaleProjectiles(false)
eaaa:setAllowCustomTeamColor(0)
eaaa:setTeamColor(-1)
eaaa:setTintingColorRed(255)
eaaa:setTintingColorGreen(255)
eaaa:setTintingColorBlue(255)
eaaa:setElevationSamplePoints(0)
eaaa:setElevationSampleRadius(50.0)
eaaa:setFogOfWarSampleRadius(0.0)
eaaa:setDeathTimeseconds(1.0)
eaaa:setStockStartDelay(0)
eaaa:setStockReplenishInterval(0)
eaaa:setStockMaximum(0)
eaaa:setPointValue(0)
eaaa:setPriority(0)
eaaa:setFormationRank(0)
eaaa:setCanFlee(false)

-- TS native attackable projectile dummy without Locust
local eaab = UnitDefinition:new('eaab', 'ewsp')
applyCommonDummyUnit(eaab, {
  name = '[System]TS Native Attackable Projectile Dummy',
  abilities = '',
  modelFile = '.mdl',
  scale = 2.50,
  icon = 'ReplaceableTextures\\CommandButtons\\BTNHumArtilleryUpOne.blp',
  special = 'Units\\NightElf\\Wisp\\WispExplode.mdl',
  animationBlend = 0.0,
  animationRunSpeed = 0.0,
  animationWalkSpeed = 0.0,
  movementType = MovementType.Fly,
  minHeight = 0.0,
  height = 75.0,
  classification = '',
  hp = 99,
  hpRegen = -1.0,
  hideMinimap = false,
  sightDay = 500,
  sightNight = 500,
  turnRate = 1.0,
  propulsionWindow = 1.0,
  selectionScale = 1.0,
})
eaab:setModelFileExtraVersions('0')
applyNoCostNoBounty(eaab)
eaab:setSelectionCircleHeight(0.0)
eaab:setSelectionCircleOnWater(false)
eaab:setScaleProjectiles(false)
eaab:setAllowCustomTeamColor(0)
eaab:setTeamColor(-1)
eaab:setTintingColorRed(255)
eaab:setTintingColorGreen(255)
eaab:setTintingColorBlue(255)
eaab:setElevationSamplePoints(0)
eaab:setElevationSampleRadius(50.0)
eaab:setFogOfWarSampleRadius(0.0)
eaab:setDeathTimeseconds(1.0)
eaab:setStockStartDelay(0)
eaab:setStockReplenishInterval(0)
eaab:setStockMaximum(0)
eaab:setPointValue(0)
eaab:setPriority(0)
eaab:setFormationRank(0)
eaab:setCanFlee(false)
