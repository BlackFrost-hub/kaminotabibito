-- Chapter 2 elf-city NPCs.

local function createElfCouncilNpc(id, name, options)
  local unit = UnitDefinition:new(id, 'edot')
  unit:setDependencyEquivalents('')
  unit:setNameEditorSuffix('')
  unit:setName(name)
  unit:setNormalAbilities('Asid,Aneu,Avul,Apit')
  unit:setIconGameInterface(options.icon)
  if options.modelFile ~= nil then
    unit:setModelFile(options.modelFile)
  end
  if options.scale ~= nil then
    unit:setScalingValue(options.scale)
  end
  unit:setMovementHeight(options.height)
  unit:setMovementType(MovementType.Fly)
  unit:setRace(Race.Human)
  unit:setSpeedBase(1)
  unit:setTurnRate(2.0)
  unit:setUpgradesUsed('')
  return unit
end

createElfCouncilNpc('e020', '术法长老-赫克提尔', {
  icon = 'Unit\\NPC\\02-Chapter\\Elf\\Icon\\Hectel.blp',
  scale = 1.5,
  height = 45.0,
})

createElfCouncilNpc('e021', '财务总长-丝费里德', {
  icon = 'Unit\\NPC\\02-Chapter\\Elf\\Icon\\Siferid.blp',
  modelFile = 'Unit\\NPC\\02-Chapter\\Elf\\Xuejingling.mdx',
  height = 53.0,
})

createElfCouncilNpc('e08Q', '精灵古老-本·思雅', {
  icon = 'Unit\\NPC\\02-Chapter\\Elf\\Icon\\BenSiya.blp',
  modelFile = 'units\\nightelf\\FaerieDragon\\FaerieDragon.mdl',
  scale = 1.2,
  height = 100.0,
})

createElfCouncilNpc('e08R', '内务总管-语维', {
  icon = 'Unit\\NPC\\02-Chapter\\Elf\\Icon\\Yuwei.blp',
  modelFile = 'Unit\\NPC\\02-Chapter\\Elf\\BloodelfPhoenixGuard.mdx',
  scale = 1.1,
  height = 45.0,
})

createElfCouncilNpc('e08T', '王宫卫队长-艾伦', {
  icon = 'Unit\\NPC\\02-Chapter\\Elf\\Icon\\Allen.blp',
  modelFile = 'Unit\\NPC\\02-Chapter\\Elf\\Allen.mdx',
  scale = 1.2,
  height = 45.0,
})

local yethir = UnitDefinition:new('e08S', 'hfoo')
yethir:setName('防卫部长-耶提尔')
yethir:setNameEditorSuffix('')
yethir:setTooltipBasic('防卫部长-耶提尔')
yethir:setTooltipExtended('克林姆德王城防卫部长，负责统领王城守军。')
yethir:setDescription('克林姆德王城防卫部长，负责统领王城守军。')
yethir:setModelFile('Unit\\NPC\\02-Chapter\\Elf\\Yethir.mdx')
yethir:setModelFileExtraVersions('0')
yethir:setIconGameInterface('Unit\\NPC\\02-Chapter\\Elf\\Icon\\Yethir.blp')
yethir:setScalingValue(1.15)
yethir:setRace(Race.Nightelf)
yethir:setNormalAbilities('Avul')
yethir:setStructuresBuilt('')
yethir:setUpgradesUsed('R001,R002')
yethir:setUnitClassification('')
yethir:setCanFlee(false)
yethir:setLevel(30)
yethir:setHitPointsMaximumBase(12000)
yethir:setHitPointsRegenerationType('always')
yethir:setHitPointsRegenerationRate(120.0)
yethir:setDefenseBase(40)
yethir:setDefenseUpgradeBonus(0)
yethir:setArmorType(ArmorType.Normal)
yethir:setSpeedBase(320)
yethir:setCollisionSize(32.0)
yethir:setAcquisitionRange(600.0)
yethir:setSightRadiusDay(1600)
yethir:setSightRadiusNight(1200)
yethir:setTurnRate(1.0)
yethir:setAttacksEnabled(AttacksEnabled.AttackOneOnly)
yethir:setAttack1AttackType(AttackType.Normal)
yethir:setAttack1DamageBase(300)
yethir:setAttack1DamageNumberofDice(1)
yethir:setAttack1DamageSidesperDie(1)
yethir:setAttack1CooldownTime(1.5)
yethir:setAttack1Range(128)
yethir:setAttack1RangeMotionBuffer(250.0)
yethir:setAttack1TargetsAllowed('ground,enemy,neutral,structure,debris,item,ward')
yethir:setAttack1WeaponType(WeaponType.Normal)
yethir:setAttack1WeaponSound(WeaponSound.MetalHeavySlice)
yethir:setAttack1AnimationBackswingPoint(0.5)
yethir:setAttack1AnimationDamagePoint(0.4)
yethir:setAttack1MaximumNumberofTargets(1)
yethir:setAttack1ShowUI(true)

local king = UnitDefinition:new('h01N', 'hspt')
king:setName('克林姆德王')
king:setRequirements('')
king:setNormalAbilities('Aneu')
king:setIconGameInterface('Unit\\NPC\\02-Chapter\\Elf\\Icon\\KlinmodKing.blp')
king:setModelFile('Unit\\NPC\\02-Chapter\\Elf\\KlinmodKing.mdx')
king:setLevel(4)
king:setScalingValue(1.8)
king:setMovementHeight(300.0)
king:setMovementType(MovementType.Fly)
king:setUpgradesUsed('')

local livant = UnitDefinition:new('h01O', 'hspt')
livant:setName('第一王子-里凡特')
livant:setRequirements('')
livant:setNormalAbilities('Asid,Aneu,Avul,Apit')
livant:setIconGameInterface('Unit\\NPC\\02-Chapter\\Elf\\Icon\\Livant.blp')
livant:setModelFile('Unit\\NPC\\02-Chapter\\Elf\\Livant.mdx')
livant:setScalingValue(1.3)
livant:setMovementHeight(50.0)
livant:setMovementType(MovementType.Fly)
livant:setRace(Race.Human)
livant:setSpeedBase(1)
livant:setTurnRate(2.0)
livant:setUpgradesUsed('')

local elfPotionVendor = UnitDefinition:new('nEPM', 'nbee')
elfPotionVendor:setName('精灵药水商人')
elfPotionVendor:setNameEditorSuffix('')
elfPotionVendor:setTooltipBasic('精灵药水商人')
elfPotionVendor:setTooltipExtended('出售精灵魔法药水和精灵生命药水。')
elfPotionVendor:setDescription('出售精灵魔法药水和精灵生命药水。')
elfPotionVendor:setNormalAbilities('Aneu,Avul,Apit')
elfPotionVendor:setItemsSold('IEM1,IEL1')
elfPotionVendor:setScalingValue(1.60)
elfPotionVendor:setCanFlee(false)
