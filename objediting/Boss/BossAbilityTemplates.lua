-- Boss common ability templates.
--
-- Boss 技能规则：
-- 本图 Boss 技能只使用单位目标通魔或无目标通魔。
-- 锁定单位、点地面技能，都用单位目标通魔。
-- 对自身周围造成伤害、以自身为中心 AOE、对自己使用的技能，都用无目标通魔。

local BOSS_CHANNEL_ABILITY_ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'

function createBossChannelAbility(id, name, options)
  options = options or {}

  local ability = AbilityDefinitionIllidanChannel:new(id)
  ability:setName(name)
  ability:setHeroAbility(false)
  ability:setItemAbility(false)
  ability:setLevels(options.levels or 1)
  ability:setCooldown(1, options.cooldown or 0)
  ability:setManaCost(1, options.manaCost or 0)
  ability:setCastRange(1, options.castRange or 999999)
  ability:setAreaofEffect(1, options.area or 0)
  ability:setDurationNormal(1, options.durationNormal or 0)
  ability:setDurationHero(1, options.durationHero or 0)
  ability:setTargetsAllowed(1, options.targetsAllowed or 'ground,air,enemy,neutral')
  ability:setRequirements(options.requirements or '')
  ability:setAnimationNames(options.animationNames or '')
  ability:setArtEffect(options.artEffect or '')
  ability:setArtTarget(options.artTarget or '')
  ability:setTargetAttachments(options.targetAttachments or 0)
  ability:setTargetAttachmentPoint(options.targetAttachmentPoint or '')
  ability:setArtCaster(options.artCaster or '')
  ability:setCasterAttachments(options.casterAttachments or 0)
  ability:setCasterAttachmentPoint(options.casterAttachmentPoint or '')

  ability:setFollowThroughTime(1, options.followThroughTime or 0)
  ability:setTargetType(1, options.targetType or 1)
  local channelOptions = options.channelOptions
  if channelOptions == nil then
    channelOptions = 1
  end
  ability:setOptions(1, channelOptions)
  ability:setArtDuration(1, options.artDuration or 0)
  ability:setDisableOtherAbilities(1, options.disableOtherAbilities or false)
  ability:setBaseOrderID(1, options.orderId or 'channel')
  ability:setButtonPositionNormalX(options.buttonX or 0)
  ability:setButtonPositionNormalY(options.buttonY or 2)

  if options.tooltip ~= nil then
    ability:setTooltipNormal(1, options.tooltip)
  end
  if options.tooltipExtended ~= nil then
    ability:setTooltipNormalExtended(1, options.tooltipExtended)
  end
  ability:setIconNormal(options.icon or BOSS_CHANNEL_ABILITY_ICON)
  if options.hotkey ~= nil then
    ability:setHotkeyNormal(options.hotkey)
  end

  return ability
end

function createBossUnitTargetChannelAbility(id, name, options)
  options = options or {}
  options.targetType = options.targetType or 1
  return createBossChannelAbility(id, name, options)
end

function createBossNoTargetChannelAbility(id, name, options)
  options = options or {}
  options.targetType = options.targetType or 0
  options.castRange = options.castRange or 0
  options.targetsAllowed = options.targetsAllowed or ''
  return createBossChannelAbility(id, name, options)
end

local unitTargetChannelGroups = {
  {
    prefix = 'A',
    ids = {
      'AT00', 'AT01', 'AT02', 'AT03',
      'AT04', 'AT05', 'AT06', 'AT07',
      'AT08', 'AT09', 'AT10', 'AT11',
      'AT12', 'AT13', 'AT14', 'AT15',
      'AT16',
    },
    orderIds = {
      'acidbomb', 'banish', 'chainlightning', 'cripple',
      'curse', 'cyclone', 'deathcoil', 'entanglingroots',
      'faeriefire', 'firebolt', 'frostnova', 'soulburn',
      'heal', 'innerfire', 'purge', 'slow',
      'sleep',
    },
  },
  {
    prefix = 'B',
    ids = {
      'BT00', 'BT01', 'BT02', 'BT03',
      'BT04', 'BT05', 'BT06', 'BT07',
      'BT08', 'BT09', 'BT10', 'BT11',
      'BT12', 'BT13', 'BT14', 'BT15',
      'BT16',
    },
    orderIds = {
      'flamestrike', 'blizzard', 'carrionswarm', 'breathoffire',
      'shockwave', 'stormbolt', 'polymorph', 'hex',
      'fingerofdeath', 'forkedlightning', 'manaburn', 'thunderbolt',
      'holybolt', 'drunkenhaze', 'shadowstrike', 'parasite',
      'possession',
    },
  },
  {
    prefix = 'C',
    ids = {
      'CT00', 'CT01', 'CT02', 'CT03',
      'CT04', 'CT05', 'CT06', 'CT07',
      'CT08', 'CT09', 'CT10', 'CT11',
      'CT12', 'CT13', 'CT14', 'CT15',
      'CT16',
    },
    orderIds = {
      'antimagicshell', 'bloodlust', 'charm', 'doom',
      'ensnare', 'impale', 'lightningshield', 'magicleash',
      'monsoon', 'rainoffire', 'rejuvination', 'silence',
      'spiritlink', 'stampede', 'transmute', 'volcano',
      'web',
    },
  },
}

for _, group in ipairs(unitTargetChannelGroups) do
  for index, id in ipairs(group.ids) do
    local castRange = 400 + (index - 1) * 100
    local name = '[系统]通用单位目标技能' .. group.prefix .. '组施法距离' .. tostring(castRange)

    createBossUnitTargetChannelAbility(id, name, {
      castRange = castRange,
      orderId = group.orderIds[index],
      buttonX = (index - 1) % 4,
      buttonY = 2,
      tooltip = name,
      tooltipExtended = name,
    })
  end
end

local noTargetChannelIds = {
  'AN00', 'AN01', 'AN02', 'AN03',
}

local noTargetChannelOrderIds = {
  'thunderclap', 'warstomp', 'roar', 'howlofterror',
}

for index, id in ipairs(noTargetChannelIds) do
  local name = '[系统]通用无目标技能' .. tostring(index)

  createBossNoTargetChannelAbility(id, name, {
    orderId = noTargetChannelOrderIds[index],
    buttonX = (index - 1) % 4,
    buttonY = 1,
    tooltip = name,
    tooltipExtended = name,
  })
end
