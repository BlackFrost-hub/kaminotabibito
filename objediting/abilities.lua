-- System abilities

local function createNamedAbility(definition, id, name)
  local ability = definition:new(id)
  ability:setName(name)
  return ability
end

local function createNamedAbilityFromBase(id, baseId, name)
  local ability = AbilityDefinition:new(id, baseId)
  ability:setName(name)
  return ability
end

local function applyCommonBuffAbility(ability, options)
  options = options or {}
  if options.missileArt ~= nil then
    ability:setMissileArt(options.missileArt)
  end
  if options.missileSpeed ~= nil then
    ability:setMissileSpeed(options.missileSpeed)
  end
  ability:setAnimationNames(options.animationNames or '')
  ability:setLevels(options.levels or 1)
  ability:setCooldown(1, options.cooldown or 0)
  ability:setManaCost(1, options.manaCost or 0)
  ability:setCastRange(1, options.castRange or 999999)
  ability:setDurationNormal(1, options.durationNormal or 1)
  ability:setDurationHero(1, options.durationHero or 1)
  ability:setRequirements(options.requirements or '')
  ability:setTargetsAllowed(1, options.targetsAllowed or 'ground,air,nonsapper')
end

local asg1 = createNamedAbility(AbilityDefinitionAttackBonusPlus1, 'ASG1', '[系统]攻击力增加')
asg1:setAttackBonus(1, 0)

local asg2 = createNamedAbility(AbilityDefinitionDefenseBonusPlus1, 'ASG2', '[系统]护甲增加')
asg2:setDefenseBonus(1, 0)

local asg3 = createNamedAbility(AbilityDefinitionAttributeModifierSkill, 'ASG3', '[系统]属性增加')
asg3:setStrengthBonus(1, 0)
asg3:setAgilityBonus(1, 0)
asg3:setIntelligenceBonus(1, 0)
asg3:setHideButton(1, true)
asg3:setLevels(1)
asg3:setHeroAbility(false)
asg3:setItemAbility(true)
asg3:setArtCaster('')

local asg6 = createNamedAbility(AbilityDefinitionMoveSpeedBonus, 'ASG6', '[系统]移动速度增加')
asg6:setMovementSpeedBonus(1, 0)

local asg7 = createNamedAbility(AbilityDefinitionAttackSpeedIncrease, 'ASG7', '[系统]攻击速度增加')
asg7:setAttackSpeedIncrease(1, 0)

local sightBonusAbilityIds = {
  'ASV1', 'ASV2', 'ASV3', 'ASV4', 'ASV5', 'ASV6', 'ASV7', 'ASV8', 'ASV9',
  'ASV0',
  'ASVA', 'ASVB', 'ASVC', 'ASVD', 'ASVE', 'ASVF', 'ASVG', 'ASVH', 'ASVI', 'ASVJ',
  'ASVK', 'ASVL', 'ASVM', 'ASVN', 'ASVO', 'ASVP', 'ASVQ', 'ASVR', 'ASVS', 'ASVT',
  'ASVU', 'ASVV', 'ASVW', 'ASVX', 'ASVY', 'ASVZ',
}
for i, id in ipairs(sightBonusAbilityIds) do
  local sight = createNamedAbility(AbilityDefinitionSightBonus, id, '[系统]视野增加' .. tostring(i * 50))
  sight:setSightRangeBonus(1, i * 50)
end

-- Buff abilities

local asby = createNamedAbility(AbilityDefinitionPolymorph, 'ASBy', '[Buff系统]变羊')
applyCommonBuffAbility(asby, {
  missileArt = '',
  missileSpeed = 10000,
})
asby:setMaximumCreepLevel(1, 0)

local asb0 = createNamedAbility(AbilityDefinitionMountainKingThunderBolt, 'ASB0', '[Buff系统]击晕')
applyCommonBuffAbility(asb0, {
  missileArt = '',
  missileSpeed = 0,
})
asb0:setDamage(1, 0)

local asbx = createNamedAbility(AbilityDefinitionInvisibility, 'ASBX', '[Buff系统]隐形')
applyCommonBuffAbility(asbx, {
  missileArt = '',
  missileSpeed = 0,
})

local asb4 = createNamedAbility(AbilityDefinitionThunderBoltCreep, 'ASB4', '[Buff系统]冰冻')
applyCommonBuffAbility(asb4, {
  missileArt = '',
  missileSpeed = 0,
})
asb4:setBuffs(1, 'Bfrz')
asb4:setDamage(1, 0)

local asb9 = createNamedAbility(AbilityDefinitionSlow, 'ASB9', '[Buff系统]减速')
applyCommonBuffAbility(asb9)
asb9:setMovementSpeedFactor(1, 0.1)
asb9:setAttackSpeedFactor(1, 0)

local asb8 = createNamedAbility(AbilityDefinitionSilenceCreep, 'ASB8', '[Buff系统]沉默')
applyCommonBuffAbility(asb8)
asb8:setAttacksPrevented(1, 8)
asb8:setChanceToMiss(1, 0)
asb8:setAreaofEffect(1, 1)

-- 新增原生 Buff 技能必须逐个验证母技能和 setter；错误母技能或三字符字段会导致加载闪退/ObjEditing 读入断言。

local asbi = createNamedAbility(AbilityDefinitionInnerFire, 'ASBI', '[Buff系统]心灵之火')
applyCommonBuffAbility(asbi, {
  targetsAllowed = 'ground,air,enemy,friend,self,neutral,nonsapper',
})
asbi:setDamageIncrease(1, 0.1)
asbi:setDefenseIncrease(1, 5)
asbi:setLifeRegenRate(1, 0)

local asbl = createNamedAbility(AbilityDefinitionBloodlust, 'ASBL', '[Buff系统]嗜血术')
applyCommonBuffAbility(asbl, {
  targetsAllowed = 'ground,air,enemy,friend,self,neutral,nonsapper',
})
asbl:setAttackSpeedIncrease(1, 0.4)
asbl:setMovementSpeedIncrease(1, 0.25)
asbl:setScalingFactor(1, 1.0)

local asbc = createNamedAbility(AbilityDefinitionCripple, 'ASBC', '[Buff系统]残废')
applyCommonBuffAbility(asbc, {
  targetsAllowed = 'ground,air,enemy,friend,self,neutral,nonsapper',
})
asbc:setMovementSpeedReduction(1, 0.5)
asbc:setAttackSpeedReduction(1, 0.5)
asbc:setDamageReduction(1, 0.5)

local asbf = createNamedAbility(AbilityDefinitionFaerieFire, 'ASBF', '[Buff系统]精灵之火')
applyCommonBuffAbility(asbf, {
  targetsAllowed = 'ground,air,enemy,friend,self,neutral,nonsapper',
})
asbf:setDefenseReduction(1, 5)
asbf:setAlwaysAutocast(1, false)

local asbr = createNamedAbility(AbilityDefinitionCursecreep, 'ASBR', '[Buff系统]诅咒')
applyCommonBuffAbility(asbr, {
  targetsAllowed = 'ground,air,enemy,friend,self,neutral,nonsapper',
})
-- Curse 的 setChancetoMiss 在当前 ObjEditing 定义里会写出 3 字节字段 Crs，导致 w3a 读入断言。

local asbs = createNamedAbility(AbilityDefinitionSleepcreep, 'ASBS', '[Buff系统]睡眠')
applyCommonBuffAbility(asbs, {
  targetsAllowed = 'ground,air,enemy,friend,self,neutral,nonsapper',
})
asbs:setStunDuration(1, 0)

local asbt = createNamedAbilityFromBase('ASBT', 'Aenr', '[Buff系统]纠缠根须')
-- Aenr 本身是中立敌对非英雄纠缠；这里不要再写 heroAbility 字段，否则 ObjEditing 读对象会断言失败。
applyCommonBuffAbility(asbt, {
  targetsAllowed = 'ground,air,enemy,friend,self,neutral,nonsapper',
})

-- ASBH 飓风：Cyclonecreep 生成母技能 ACcy 会导致地图加载闪退，改测普通 Cyclone(Acyc)。
local asbh = createNamedAbility(AbilityDefinitionCyclone, 'ASBH', '[Buff系统]飓风')
applyCommonBuffAbility(asbh, {
  targetsAllowed = 'ground,air,enemy,friend,self,neutral,nonsapper',
})
asbh:setCanBeDispelled(1, true)

local asbp = createNamedAbility(AbilityDefinitionParasite, 'ASBP', '[Buff系统]寄生')
applyCommonBuffAbility(asbp, {
  targetsAllowed = 'ground,air,enemy,friend,self,neutral,nonsapper',
  cooldown = 0.10,
  manaCost = 0,
  castRange = 999999,
  durationNormal = 0.001,
  durationHero = 0.001,
})
asbp:setCastingTime(1, 0.01)
asbp:setBuffs(1, 'BNpa')
asbp:setDamageperSecond(1, 0.0)
asbp:setAttackSpeedFactor(1, 0.0)
asbp:setMovementSpeedFactor(1, 0.0)
asbp:setSummonedUnitDuration(1, 8.0)
asbp:setSummonedUnitCount(1, 1)
asbp:setUnitType(1, 'e00N')

local asil = createNamedAbility(AbilityDefinitionItemIllusion, 'ASIL', '[系统]幻象物品')
applyCommonBuffAbility(asil, {
  missileArt = '',
  missileSpeed = 0,
  targetsAllowed = 'ground,air,enemy,friend,self,neutral',
})
asil:setLevels(1)
asil:setHeroAbility(false)
asil:setItemAbility(false)
asil:setDamageReceivedMultiplier(1, 2.0)
asil:setDamageDealtofnormal(1, 0.0)
