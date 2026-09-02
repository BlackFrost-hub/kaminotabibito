-- Reusable instant combo-input shells based on Paladin Divine Shield.
-- The parent ability has no cast animation. Runtime TS owns every gameplay effect.

HeroComboAbilityShell = HeroComboAbilityShell or {}

-- Player hero skill shells use the same channel base as Boss skills, but remain
-- hero abilities so they occupy the unit's Q/W/E/R hero slots.
function createPlayerHeroChannelAbility(id, name, options)
  options = options or {}

  local ability = AbilityDefinitionIllidanChannel:new(id)
  ability:setName(name)
  ability:setEditorSuffix(options.editorSuffix or 'PlayerHeroChannelShell')
  ability:setHeroAbility(options.heroAbility ~= false)
  ability:setItemAbility(false)
  local levels = options.levels or 1
  -- Channel duration data (102/103) is repurposed by the runtime as a
  -- percentage mana cost for player-hero shells. Fixed mana cost (104)
  -- stacks on top: the runtime sync computes fixed + percent * max mana.
  local percentManaCost = options.percentManaCost
  local fixedManaCost = options.manaCost or 0
  local normalDuration = options.durationNormal ~= nil and options.durationNormal or (percentManaCost or 0)
  local heroDuration = options.durationHero ~= nil and options.durationHero or (percentManaCost or 0)
  ability:setLevels(levels)
  for level = 1, levels do
    ability:setCooldown(level, options.cooldown ~= nil and options.cooldown or 1)
    ability:setManaCost(level, fixedManaCost)
    ability:setCastRange(level, options.castRange or 900)
    ability:setAreaofEffect(level, options.area or 0)
    ability:setDurationNormal(level, normalDuration)
    ability:setDurationHero(level, heroDuration)
    ability:setTargetsAllowed(level, options.targetsAllowed or 'ground,air,enemy,neutral,nonsapper')
    ability:setFollowThroughTime(level, options.followThroughTime or 0)
    ability:setTargetType(level, options.targetType ~= nil and options.targetType or 2)
    ability:setOptions(level, options.channelOptions ~= nil and options.channelOptions or 1)
    ability:setArtDuration(level, options.artDuration or 0)
    ability:setDisableOtherAbilities(level, options.disableOtherAbilities or false)
    ability:setTooltipNormal(level, options.tooltip or name)
    ability:setTooltipNormalExtended(level, options.tooltipExtended or options.tooltip or name)
  end
  ability:setRequirements(options.requirements or '')
  ability:setAnimationNames(options.animationNames or '')
  ability:setArtEffect(options.artEffect or '')
  ability:setArtTarget(options.artTarget or '')
  ability:setTargetAttachments(options.targetAttachments or 0)
  ability:setTargetAttachmentPoint(options.targetAttachmentPoint or '')
  ability:setArtCaster(options.artCaster or '')
  ability:setCasterAttachments(options.casterAttachments or 0)
  ability:setCasterAttachmentPoint(options.casterAttachmentPoint or '')
  ability:setBaseOrderID(1, options.orderId or 'channel')
  ability:setButtonPositionNormalX(options.buttonX or 0)
  ability:setButtonPositionNormalY(options.buttonY or 2)
  local icon = options.icon or 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
  ability:setIconNormal(icon)
  ability:setIconTurnOff(options.iconTurnOff or icon)
  if options.hotkey ~= nil then
    ability:setHotkeyNormal(options.hotkey)
  end
  return ability
end

-- Active player-hero D skills use the normal ability bar. They share the same
-- channel shell, but are explicitly non-hero abilities so they do not consume
-- one of the four Q/W/E/R hero slots.
function createPlayerHeroActiveDChannelAbility(id, name, options)
  options = options or {}
  options.heroAbility = false
  options.buttonX = options.buttonX or 0
  options.buttonY = options.buttonY or 1
  return createPlayerHeroChannelAbility(id, name, options)
end

local COMBO_SHELL_DURATION = 0.001

function HeroComboAbilityShell.createDivineShield(options)
  local duration = options.duration or COMBO_SHELL_DURATION
  if duration <= 0 then
    error('Hero combo Divine Shield shell duration must be greater than 0; Warcraft treats 0 as permanent.')
  end

  local ability = AbilityDefinitionPaladinDivineShield:new(options.id)
  local name = options.name
  local tooltip = options.tooltip or name
  local extendedTooltip = options.extendedTooltip or tooltip
  local icon = options.icon or ''
  local hotkey = options.hotkey or ''
  local buttonX = options.buttonX or 0
  local buttonY = options.buttonY or 2

  ability:setName(name)
  ability:setEditorSuffix(options.editorSuffix or 'HeroComboInputShell')
  ability:setHeroAbility(false)
  ability:setItemAbility(false)
  ability:setLevels(1)
  ability:setCooldown(1, options.cooldown or COMBO_SHELL_DURATION)
  ability:setManaCost(1, options.manaCost or 0)
  ability:setCastRange(1, 0)
  ability:setAreaofEffect(1, 0)
  ability:setDurationNormal(1, duration)
  ability:setDurationHero(1, duration)
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
  ability:setTooltipNormal(1, tooltip)
  ability:setTooltipTurnOff(1, tooltip)
  ability:setTooltipNormalExtended(1, extendedTooltip)
  ability:setTooltipTurnOffExtended(1, extendedTooltip)
  ability:setIconNormal(icon)
  ability:setIconTurnOff(icon)
  ability:setHotkeyNormal(hotkey)
  ability:setHotkeyTurnOff(hotkey)
  ability:setButtonPositionNormalX(buttonX)
  ability:setButtonPositionNormalY(buttonY)
  ability:setButtonPositionTurnOffX(buttonX)
  ability:setButtonPositionTurnOffY(buttonY)
  ability:setOrderStringTurnOff('divineshield')
  ability:setCanDeactivate(1, false)
  return ability
end

-- Shared follow-up shells are keyed only by command-card slot and stage.
-- Hero runtime code stores targets/directions; these shells only emit synchronized spell events.
HeroComboAbilityShell.sharedIds = HeroComboAbilityShell.sharedIds or {
  Q2 = 'ASQ2',
  W2 = 'ASW2',
  E2 = 'ASE2',
  R2 = 'ASR2',
}

function HeroComboAbilityShell.createSharedFollowUp(options)
  local hotkey = options.hotkey
  local stage = options.stage or 2
  return HeroComboAbilityShell.createDivineShield({
    id = options.id,
    name = '[系统]通用' .. hotkey .. tostring(stage) .. '段输入壳',
    editorSuffix = 'SharedComboInputShell',
    tooltip = '继续连段（' .. hotkey .. '）',
    extendedTooltip = '确认当前技能的后续连段。',
    icon = options.icon or 'ReplaceableTextures\\CommandButtons\\BTNReplay-SpeedUp.blp',
    hotkey = hotkey,
    buttonX = options.buttonX,
    buttonY = options.buttonY or 2,
  })
end

local sharedSecondStageSlots = {
  { id = HeroComboAbilityShell.sharedIds.Q2, hotkey = 'Q', buttonX = 0 },
  { id = HeroComboAbilityShell.sharedIds.W2, hotkey = 'W', buttonX = 1 },
  { id = HeroComboAbilityShell.sharedIds.E2, hotkey = 'E', buttonX = 2 },
  { id = HeroComboAbilityShell.sharedIds.R2, hotkey = 'R', buttonX = 3 },
}

for _, slot in ipairs(sharedSecondStageSlots) do
  HeroComboAbilityShell.createSharedFollowUp({
    id = slot.id,
    hotkey = slot.hotkey,
    stage = 2,
    buttonX = slot.buttonX,
  })
end
