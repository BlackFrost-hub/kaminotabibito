-- Chapter 3 other NPC object data.

local chiwei = UnitDefinition:new('n03Z', 'nhem')
chiwei:setName('赤尾')
chiwei:setNameEditorSuffix('')
chiwei:setTooltipBasic('赤尾')
chiwei:setModelFile('Unit\\NPC\\03-Chapter\\Other\\FelGuardBlue.mdx')
chiwei:setModelFileExtraVersions('0')
chiwei:setIconGameInterface('Unit\\NPC\\03-Chapter\\Other\\Icon\\Chiwei.blp')
chiwei:setHideMinimapDisplay(true)
chiwei:setLevel(10)
chiwei:setScalingValue(1.5)
chiwei:setRace(Race.Demon)
chiwei:setUpgradesUsed('')

local function createChapter3OtherNpc(id, name, modelFile, icon, scale, height)
  local unit = UnitDefinition:new(id, 'edot')
  unit:setDependencyEquivalents('')
  unit:setNameEditorSuffix('')
  unit:setName(name)
  unit:setTooltipBasic(name)
  unit:setTooltipExtended(name)
  unit:setDescription(name)
  unit:setNormalAbilities('Asid,Aneu,Avul,Apit')
  unit:setModelFile(modelFile)
  unit:setModelFileExtraVersions('0')
  unit:setIconGameInterface(icon)
  unit:setHideMinimapDisplay(true)
  unit:setScalingValue(scale)
  unit:setMovementHeight(height)
  unit:setMovementType(MovementType.Fly)
  unit:setRace(Race.Human)
  unit:setSpeedBase(1)
  unit:setTurnRate(2.0)
  unit:setUpgradesUsed('R001,R002')
  return unit
end

createChapter3OtherNpc(
  'n067',
  '分离教派教皇',
  'Unit\\NPC\\03-Chapter\\Other\\SchismPope.mdx',
  'Unit\\NPC\\03-Chapter\\Other\\Icon\\SchismPope.blp',
  1.35,
  45.0
)

createChapter3OtherNpc(
  'n068',
  '奥斯特利一世',
  'Unit\\NPC\\03-Chapter\\Other\\HumanBishop.mdx',
  'Unit\\NPC\\03-Chapter\\Other\\Icon\\OsterlyI.blp',
  1.25,
  45.0
)
