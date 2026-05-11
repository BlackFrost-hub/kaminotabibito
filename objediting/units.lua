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
  u:setMovementType(MovementType.Fly)
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
local e011 = UnitDefinition:new('e011', 'ewsp')
applyCommonDummyUnit(e011, {
  name = '[系统]施法进度条',
  modelFile = 'resource\\models\\Common\\Progressbar.mdx',
  scale = 1.0,
  minHeight = 275.0,
  height = 275.0,
  selectionScale = 0.0,
})

-- Shield bar unit
-- [护盾系统]-显示马甲
local sbar = UnitDefinition:new('sbar', 'ewsp')
applyCommonDummyUnit(sbar, {
  name = '[护盾系统]-显示马甲',
  modelFile = 'S_Shiled.mdl',
  icon = 'ReplaceableTextures\\CommandButtons\\BTNWisp.blp',
  scale = 1.0,
  speedBase = 270,
  hp = 10000,
  hpRegen = 100.0,
  mana = 10000,
  manaRegen = 1000.0,
  initialMana = 1000,
  sightDay = 1800,
  sightNight = 1800,
  selectionScale = 0.0,
})
sbar:setAllowCustomTeamColor(0)
sbar:setTeamColor(-1)
sbar:setTintingColorRed(100)
sbar:setTintingColorGreen(200)
sbar:setTintingColorBlue(255)

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

-- TS 原生弹幕默认马甲单位
-- 分类约定：
-- ancient = 蝗虫单位，mechanical + ward = 弹幕/技能弹道。
-- tauren 不在物编默认加，运行时由 TS 原生弹幕按“不可阻挡”动态添加。
local eaaa = UnitDefinition:new('eaaa', 'ewsp')
applyCommonDummyUnit(eaaa, {
  name = '[系统]TS原生弹幕马甲',
  modelFile = '.mdl',
  scale = 2.50,
  icon = 'ReplaceableTextures\\CommandButtons\\BTNHumArtilleryUpOne.blp',
  special = 'Units\\NightElf\\Wisp\\WispExplode.mdl',
  animationBlend = 0.0,
  animationRunSpeed = 0.0,
  animationWalkSpeed = 0.0,
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
