-- Equipment common item ability templates.
--
-- Active equipment/item skills use these Channel slots in allocation order:
--   IU00-IU14: unit target
--   IP00-IP14: point target
--   IN00-IN14: no target
--
-- Runtime code may rewrite order id, cooldown, mana cost, and cast range on the
-- unit-owned ability instance. Do not create per-item abilities just for those
-- numeric differences.

local EQUIPMENT_ITEM_ABILITY_ICON = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'

EquipmentItemAbilitySlots = {
  unitTarget = {},
  pointTarget = {},
  noTarget = {},
}

local equipmentItemAbilityOrderIds = {
  unitTarget = {
    'acidbomb', 'banish', 'chainlightning', 'cripple', 'curse',
    'cyclone', 'deathcoil', 'entanglingroots', 'faeriefire', 'firebolt',
    'frostnova', 'soulburn', 'heal', 'innerfire', 'purge',
  },
  pointTarget = {
    'flamestrike', 'blizzard', 'carrionswarm', 'breathoffire', 'shockwave',
    'impale', 'monsoon', 'rainoffire', 'silence', 'stampede',
    'volcano', 'clusterrockets', 'earthquake', 'tornado', 'forceofnature',
  },
  noTarget = {
    'thunderclap', 'warstomp', 'roar', 'howlofterror', 'polymorph',
    'hex', 'fingerofdeath', 'forkedlightning', 'manaburn', 'thunderbolt',
    'holybolt', 'drunkenhaze', 'shadowstrike', 'parasite', 'possession',
  },
}

local function createEquipmentItemChannelAbility(id, name, options)
  options = options or {}

  local ability = AbilityDefinitionIllidanChannel:new(id)
  ability:setName(name)
  ability:setHeroAbility(false)
  ability:setItemAbility(true)
  ability:setLevels(1)
  ability:setCooldown(1, options.cooldown or 0)
  ability:setManaCost(1, options.manaCost or 0)
  ability:setCastRange(1, options.castRange or 500)
  ability:setAreaofEffect(1, options.area or 0)
  ability:setDurationNormal(1, 0)
  ability:setDurationHero(1, 0)
  ability:setTargetsAllowed(1, options.targetsAllowed or 'ground,air,enemy,neutral,friend,self')
  ability:setRequirements('')
  ability:setAnimationNames('')
  ability:setArtEffect('')
  ability:setArtTarget('')
  ability:setTargetAttachments(0)
  ability:setTargetAttachmentPoint('')
  ability:setArtCaster('')
  ability:setCasterAttachments(0)
  ability:setCasterAttachmentPoint('')
  ability:setFollowThroughTime(1, 0)
  ability:setTargetType(1, options.targetType or 1)
  ability:setOptions(1, options.channelOptions or 0)
  ability:setArtDuration(1, 0)
  ability:setDisableOtherAbilities(1, false)
  ability:setBaseOrderID(1, options.orderId or 'channel')
  ability:setTooltipNormal(1, name)
  ability:setTooltipNormalExtended(1, name)
  ability:setIconNormal(options.icon or EQUIPMENT_ITEM_ABILITY_ICON)

  return ability
end

local function registerEquipmentItemAbilitySlot(groupName, slot)
  local group = EquipmentItemAbilitySlots[groupName]
  group[#group + 1] = slot
end

local function createEquipmentItemAbilitySlot(groupName, id, name, targetType, orderId, castRange, targetsAllowed)
  createEquipmentItemChannelAbility(id, name, {
    targetType = targetType,
    orderId = orderId,
    castRange = castRange,
    targetsAllowed = targetsAllowed,
  })

  registerEquipmentItemAbilitySlot(groupName, {
    id = id,
    targetType = targetType,
    orderId = orderId,
    castRange = castRange,
    name = name,
  })
end

for index = 0, 14 do
  local id = string.format('IU%02d', index)
  local name = '[系统]装备通用单位目标技能槽位' .. tostring(index + 1)
  createEquipmentItemAbilitySlot('unitTarget', id, name, 1, equipmentItemAbilityOrderIds.unitTarget[index + 1], 500, 'ground,air,enemy,neutral,friend,self')
end

for index = 0, 14 do
  local id = string.format('IP%02d', index)
  local name = '[系统]装备通用点目标技能槽位' .. tostring(index + 1)
  createEquipmentItemAbilitySlot('pointTarget', id, name, 2, equipmentItemAbilityOrderIds.pointTarget[index + 1], 500, 'ground,air,enemy,neutral,friend,self')
end

for index = 0, 14 do
  local id = string.format('IN%02d', index)
  local name = '[系统]装备通用无目标技能槽位' .. tostring(index + 1)
  createEquipmentItemAbilitySlot('noTarget', id, name, 0, equipmentItemAbilityOrderIds.noTarget[index + 1], 0, '')
end
