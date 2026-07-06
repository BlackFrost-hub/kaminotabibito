-- Legacy active items that already live in the ObjEditing source map.
--
-- Only replace the item active ability with a common Channel shell. Do not
-- rebuild names, icons, models, tooltips, prices, or classifications here.
-- Those fields should keep the old object data from the source map.

local LEGACY_ACTIVE_ITEM_SHELL_POOLS = {
  unit = {
    'IU00', 'IU01', 'IU02', 'IU03', 'IU04',
    'IU05', 'IU06', 'IU07', 'IU08', 'IU09',
    'IU10', 'IU11', 'IU12', 'IU13', 'IU14',
  },
  point = {
    'IP00', 'IP01', 'IP02', 'IP03', 'IP04',
    'IP05', 'IP06', 'IP07', 'IP08', 'IP09',
    'IP10', 'IP11', 'IP12', 'IP13', 'IP14',
  },
  none = {
    'IN02', 'IN03', 'IN04', 'IN05', 'IN06',
    'IN07', 'IN08', 'IN09',
    'IN10', 'IN11', 'IN12', 'IN13', 'IN14',
  },
}

local legacyActiveItemShellIndex = {
  unit = 0,
  point = 0,
  none = 0,
}

local function nextLegacyActiveItemShell(targetType)
  local pool = LEGACY_ACTIVE_ITEM_SHELL_POOLS[targetType]
  local index = legacyActiveItemShellIndex[targetType] % #pool
  legacyActiveItemShellIndex[targetType] = legacyActiveItemShellIndex[targetType] + 1
  return pool[index + 1]
end

local LEGACY_ACTIVE_ITEM_SHELLS = {
  { id = 'I06S', target = 'unit', parent = 'rlif', oldAbilities = 'A086', oldCooldown = 'A086' },
  { id = 'I0AJ', target = 'none', parent = 'bspd', oldAbilities = 'A0F0', oldCooldown = 'A0F0' },
  { id = 'I00J', target = 'unit', parent = 'azhr', oldAbilities = 'A03I', oldCooldown = 'A03I' },
  { id = 'I09R', target = 'unit', parent = 'kymn', oldAbilities = 'A0EO', oldCooldown = 'A0EO' },
  { id = 'I01H', target = 'unit', parent = 'rots', oldAbilities = 'A03G', oldCooldown = 'A03G' },
  { id = 'I095', target = 'unit', parent = 'ratc', oldAbilities = 'A09G', oldCooldown = 'A09G' },
  { id = 'I08B', target = 'unit', parent = 'hcun', oldAbilities = 'A0AE,A0A9,A0A8', oldCooldown = 'A0AE' },
  { id = 'I097', target = 'unit', parent = 'evtl', oldAbilities = 'A0AG', oldCooldown = 'A0AG' },
  { id = 'I083', target = 'unit', parent = 'evtl', oldAbilities = 'A0AN,A0AM,A0AL', oldCooldown = 'A0AN' },
  { id = 'I07L', target = 'unit', parent = 'ratc', oldAbilities = 'A0AP', oldCooldown = 'A0AP' },
  { id = 'I07M', target = 'unit', parent = 'ratc', oldAbilities = 'A0AQ', oldCooldown = 'A0AQ' },
  { id = 'I080', target = 'unit', parent = 'ratc', oldAbilities = 'A0AR', oldCooldown = 'A0AR' },
  { id = 'I07Y', target = 'point', parent = 'ratc', oldAbilities = 'A0B0', oldCooldown = 'A0B0' },
  { id = 'I085', target = 'unit', parent = 'ofir', oldAbilities = 'A0B2', oldCooldown = 'A0B2' },
  { id = 'I07B', target = 'unit', parent = 'ratc', oldAbilities = 'A0B4', oldCooldown = 'A0B4' },
  { id = 'I0BQ', target = 'unit', parent = 'ofir', oldAbilities = 'A0HF', oldCooldown = 'A0HF' },
  { id = 'I044', target = 'unit', parent = 'ratc', oldAbilities = 'A06C,A06D', oldCooldown = 'A06C' },
  { id = 'I082', target = 'point', parent = 'evtl', oldAbilities = 'A0B5', oldCooldown = 'A0B5' },
  { id = 'I07G', target = 'none', parent = 'ratc', oldAbilities = 'A09D', oldCooldown = 'A09D', clearCharges = true },
  { id = 'I09Q', target = 'none', parent = 'texp', oldAbilities = 'A0EL', oldCooldown = 'A0EL' },
  { id = 'I00O', target = 'none', parent = 'azhr', oldAbilities = 'A03J', oldCooldown = 'A03J' },
  { id = 'I01R', target = 'none', parent = 'lhst', oldAbilities = 'A03S,A03R', oldCooldown = 'A03S' },
  { id = 'I0CB', target = 'none', parent = 'lhst', oldAbilities = 'A0HO,A0HN,A0HP', oldCooldown = 'A0HN' },
  { id = 'I043', target = 'none', parent = 'ratc', oldAbilities = 'A06B', oldCooldown = 'A06B' },
  { id = 'I06H', target = 'none', parent = 'ofir', oldAbilities = 'A0EH', oldCooldown = 'A0EH' },
  { id = 'I06I', target = 'none', parent = 'rlif', oldAbilities = 'A07Y', oldCooldown = 'A07Y' },
  { id = 'I06J', target = 'none', parent = 'rlif', oldAbilities = 'A07Y', oldCooldown = 'A07Y' },
  { id = 'I06O', target = 'none', parent = 'rlif', oldAbilities = 'A0EM', oldCooldown = 'A0EM' },
  { id = 'I06Q', target = 'none', parent = 'ofir', oldAbilities = 'A083', oldCooldown = 'A083' },
  { id = 'I06W', target = 'none', parent = 'bspd', oldAbilities = 'A089', oldCooldown = 'A089' },
  { id = 'I08S', target = 'none', parent = 'bspd', oldAbilities = 'A0EK', oldCooldown = 'A0EK' },
  { id = 'I084', target = 'none', parent = 'evtl', oldAbilities = 'A0AI,A0AH', oldCooldown = 'A0AI' },
  { id = 'I07U', target = 'none', parent = 'ratc', oldAbilities = 'A0AW', oldCooldown = 'A0AW' },
  { id = 'I07K', target = 'none', parent = 'bspd', oldAbilities = 'A0AX', oldCooldown = 'A0AX' },
  { id = 'I07C', target = 'none', parent = 'evtl', oldAbilities = 'A0AZ', oldCooldown = 'A0AZ' },
  { id = 'I09J', target = 'none', parent = 'rlif', oldAbilities = 'A0B6', oldCooldown = 'A0B6' },
  { id = 'I09I', target = 'none', parent = 'rlif', oldAbilities = 'A0B8', oldCooldown = 'A0B8' },
  { id = 'I09K', target = 'none', parent = 'rlif', oldAbilities = 'A0B7', oldCooldown = 'A0B7' },
  { id = 'I07E', target = 'none', parent = 'ratc', oldAbilities = 'A09C', oldCooldown = 'A09C' },
  { id = 'I04D', target = 'none', parent = 'pams', oldAbilities = 'A060', oldCooldown = 'A060' },
}

local function splitAbilityList(value)
  local result = {}
  if value == nil or value == '' then
    return result
  end
  for abilityId in tostring(value):gmatch('[^,]+') do
    result[#result + 1] = abilityId
  end
  return result
end

local function replaceActiveAbility(oldAbilities, oldCooldownGroup, shellAbility)
  local abilities = splitAbilityList(oldAbilities)
  if #abilities == 0 then
    return shellAbility
  end

  local replaced = false
  if oldCooldownGroup ~= nil and oldCooldownGroup ~= '' then
    for index, abilityId in ipairs(abilities) do
      if abilityId == oldCooldownGroup then
        abilities[index] = shellAbility
        replaced = true
        break
      end
    end
  end

  if not replaced then
    abilities[1] = shellAbility
  end
  return table.concat(abilities, ',')
end

for _, entry in ipairs(LEGACY_ACTIVE_ITEM_SHELLS) do
  local shellAbility = nextLegacyActiveItemShell(entry.target)
  local item = ItemDefinition:new(entry.id, entry.parent)
  item:setAbilities(replaceActiveAbility(entry.oldAbilities, entry.oldCooldown, shellAbility))
  item:setCooldownGroup(shellAbility)
  item:setActivelyUsed(true)
  if entry.clearCharges == true then
    item:setPerishable(false)
    item:setNumberofCharges(0)
  end
end
