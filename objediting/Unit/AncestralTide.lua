-- Ancestral tide units for the six-stage Naga route.
-- The runtime skills are added by TS; these object definitions intentionally
-- clear inherited unit skills so the parent units only provide base data.

local function createAncestralTideUnit(id, parentId, name, modelFile, classification, scale, icon)
  local unit = UnitDefinition:new(id, parentId)
  unit:setName(name)
  unit:setTooltipBasic(name)
  unit:setTooltipExtended(name)
  unit:setDescription(name)
  unit:setModelFile(modelFile)
  unit:setModelFileExtraVersions('0')
  unit:setScalingValue(scale or 1.0)
  unit:setIconGameInterface(icon)
  unit:setRace(Race.Naga)
  unit:setNormalAbilities('')
  unit:setStructuresBuilt('')
  unit:setUpgradesUsed('R001,R002')
  unit:setUnitClassification(classification or 'ancient')
  unit:setCanFlee(false)
  unit:setCanDropItemsOnDeath(true)
  return unit
end

-- Common foot soldiers. Their weak versions of the route mechanics are added
-- in TS and are not inherited from the Naga parent objects.
createAncestralTideUnit(
  'n054',
  'nnmg',
  '灵潮祭司',
  'Unit\\Elite\\DreamEater.MDX',
  'ancient',
  1.80,
  'Unit\\Elite\\Icon\\DreamEater.blp'
)

createAncestralTideUnit(
  'n056',
  'nnmg',
  '潮蚀巡鳞者',
  'Unit\\Minion\\Murlocs_master.MDX',
  'ancient',
  1.50,
  'Unit\\Minion\\Icon\\Murlocs_master.blp'
)

createAncestralTideUnit(
  'n052',
  'nnrg',
  '金鳞执刑官',
  'Unit\\Elite\\NagaDeepStalker.mdx',
  'ancient',
  1.75,
  'Unit\\Elite\\Icon\\NagaDeepStalker.blp'
)

createAncestralTideUnit(
  'n055',
  'nnrg',
  '深渊鳞将',
  'Unit\\Elite\\NagaRoyalGuard.mdx',
  'ancient',
  1.75,
  'Unit\\Elite\\Icon\\NagaRoyalGuard.blp'
)

-- The sixth screenshot is the human Mortar Team base object. Keep its
-- artillery attack data explicit because the inherited unit uses different
-- projectile defaults.
local reefStonehurler = createAncestralTideUnit(
  'h00Y',
  'hmtm',
  '碎礁投石手',
  'Unit\\Minion\\KetzualHero.mdx',
  'ancient',
  1.00,
  'Unit\\Minion\\Icon\\KetzualHero.blp'
)
reefStonehurler:setAttacksEnabled(AttacksEnabled.AttackOneOnly)
reefStonehurler:setAttack1AttackType(AttackType.Siege)
reefStonehurler:setAttack1WeaponType(WeaponType.Artillery)
reefStonehurler:setAttack1ProjectileArt('Abilities\\Weapons\\DemolisherMissile\\DemolisherMissile.mdl')
reefStonehurler:setAttack1ProjectileSpeed(900)
reefStonehurler:setAttack1ProjectileArc(0.35)
reefStonehurler:setAttack1TargetsAllowed('debris,ground,wall,ward,item')
reefStonehurler:setAttack1WeaponSound(WeaponSound.Nothing)
