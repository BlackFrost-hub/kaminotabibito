-- Felice sword-soul summons. Keep the small wolf raw id aligned with the source map.

local function createFeliceSoulWolf(id, name, hitPoints, modelFile)
  local wolf = UnitDefinition:new(id, 'osw2')
  wolf:setName(name)
  wolf:setNameEditorSuffix('菲利斯')
  wolf:setHitPointsMaximumBase(hitPoints)
  wolf:setNormalAbilities('')
  wolf:setAttack1AnimationBackswingPoint(0.5)
  wolf:setAttack1DamageBase(1)
  wolf:setSightRadiusNight(1200)
  wolf:setHitPointsRegenerationRate(0.0)
  wolf:setSpeedBase(452)
  wolf:setUnitClassification('ward')
  if modelFile ~= nil then
    wolf:setModelFile(modelFile)
    wolf:setModelFileExtraVersions('0')
  end
  return wolf
end

createFeliceSoulWolf('o00A', '剑魂之狼', 4, nil)
createFeliceSoulWolf('o00B', '大剑魂之狼', 8, 'Unit\\Summon\\FeliceSoulWolfLarge.mdx')
