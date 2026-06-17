-- System-level command shells.
-- These abilities are intentionally clean: runtime code listens to their order ids
-- and implements the real effect.

SystemIgnoreControlAbilityIds = {
  Berserk = 'USKB',
  WindWalk = 'USKW',
  DivineShield = {'USKD', 'UD01', 'UD02', 'UD03', 'UD04', 'UD05', 'UD06', 'UD07'},
  Reveal = {'USKS', 'UW01', 'UW02', 'UW03', 'UW04', 'UW05', 'UW06', 'UW07'},
}

local SYSTEM_INPUT_ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
-- Warcraft treats 0 duration as permanent for these shells. Keep active shells at 0.01.
local SHORT_DURATION = 0.01

local function getUnitSkillButtonPosition(slotIndex)
  return (slotIndex - 1) % 4, slotIndex <= 4 and 1 or 2
end

local function clearSystemInputShellCommon(ability, name, buttonX, buttonY)
  ability:setName(name)
  ability:setEditorSuffix('IgnoreControlInputShell')
  ability:setHeroAbility(false)
  ability:setItemAbility(false)
  ability:setLevels(1)
  ability:setCooldown(1, 0)
  ability:setManaCost(1, 0)
  ability:setCastRange(1, 0)
  ability:setAreaofEffect(1, 0)
  ability:setDurationNormal(1, SHORT_DURATION)
  ability:setDurationHero(1, SHORT_DURATION)
  ability:setCastingTime(1, 0)
  ability:setTargetsAllowed(1, 'nonsapper')
  ability:setRequirements('')
  ability:setRequirementsLevels('')
  ability:setAnimationNames('')
  ability:setArtEffect('')
  ability:setArtTarget('')
  ability:setTargetAttachments(0)
  ability:setTargetAttachmentPoint('')
  ability:setArtCaster('')
  ability:setCasterAttachments(0)
  ability:setCasterAttachmentPoint('')
  ability:setArtSpecial('')
  ability:setAreaEffect('')
  ability:setLightningEffects('')
  ability:setMissileArt('')
  ability:setMissileSpeed(0)
  ability:setMissileArc(0)
  ability:setMissileHomingEnabled(false)
  ability:setBuffs(1, '')
  ability:setTooltipNormal(1, name)
  ability:setTooltipNormalExtended(1, '系统命令壳子：只用于捕捉无视控制输入，真实效果由 TS 技能函数处理。')
  ability:setIconNormal(SYSTEM_INPUT_ICON)
  ability:setButtonPositionNormalX(buttonX or 0)
  ability:setButtonPositionNormalY(buttonY or 2)
end

local function createIgnoreControlBerserkShell()
  local ability = AbilityDefinitionBeserk:new(SystemIgnoreControlAbilityIds.Berserk)
  clearSystemInputShellCommon(ability, '[系统]无视控制输入-狂战士')
  ability:setMovementSpeedIncrease(1, 0)
  ability:setAttackSpeedIncrease(1, 0)
  ability:setDamageTakenIncrease(1, 0)
  return ability
end

local function createIgnoreControlWindWalkShell()
  local ability = AbilityDefinitionBladeMasterWindWalk:new(SystemIgnoreControlAbilityIds.WindWalk)
  clearSystemInputShellCommon(ability, '[系统]无视控制输入-疾风步')
  ability:setMovementSpeedIncrease(1, 0)
  ability:setTransitionTime(1, 0)
  ability:setBackstabDamage(1, false)
  ability:setBackstabDamage1(1, 0)
  return ability
end

local function createIgnoreControlDivineShieldShell(id, slotIndex)
  local buttonX, buttonY = getUnitSkillButtonPosition(slotIndex)
  local ability = AbilityDefinitionPaladinDivineShield:new(id)
  clearSystemInputShellCommon(ability, '[系统]无视控制输入-无敌护甲槽位' .. tostring(slotIndex), buttonX, buttonY)
  ability:setCanDeactivate(1, false)
  return ability
end

local function createIgnoreControlRevealShell(id, slotIndex)
  local buttonX, buttonY = getUnitSkillButtonPosition(slotIndex)
  local ability = AbilityDefinition:new(id, 'Arev')
  clearSystemInputShellCommon(ability, '[系统]无视控制输入-显示槽位' .. tostring(slotIndex), buttonX, buttonY)
  ability:setCastRange(1, 999999)
  ability:setDurationNormal(1, 0)
  ability:setDurationHero(1, 0)
  return ability
end

createIgnoreControlBerserkShell()
createIgnoreControlWindWalkShell()

for index, id in ipairs(SystemIgnoreControlAbilityIds.DivineShield) do
  createIgnoreControlDivineShieldShell(id, index)
end

for index, id in ipairs(SystemIgnoreControlAbilityIds.Reveal) do
  createIgnoreControlRevealShell(id, index)
end
