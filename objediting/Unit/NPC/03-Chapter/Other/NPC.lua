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
chiwei:setSpeedBase(400)
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

local function createDemonCityQuestNpc(id, name, modelFile, icon, scale)
  local unit = UnitDefinition:new(id, 'n03W')
  unit:setDependencyEquivalents('')
  unit:setNameEditorSuffix('')
  unit:setName(name)
  unit:setTooltipBasic(name)
  unit:setTooltipExtended(name)
  unit:setDescription(name)
  unit:setNormalAbilities('Aneu,Avul,Apit')
  unit:setModelFile(modelFile)
  unit:setModelFileExtraVersions('0')
  unit:setIconGameInterface(icon)
  unit:setHideMinimapDisplay(true)
  unit:setScalingValue(scale)
  unit:setSpeedBase(1)
  unit:setTurnRate(2.0)
  unit:setRace(Race.Demon)
  unit:setUpgradesUsed('')
  return unit
end

createDemonCityQuestNpc(
  'n06H',
  '年轻恶魔·泽迦',
  'Unit\\NPC\\03-Chapter\\Other\\DemonCity\\YoungDemon.mdx',
  'Unit\\NPC\\03-Chapter\\Other\\Icon\\YoungDemon.blp',
  1.15
)

createDemonCityQuestNpc(
  'n06I',
  '王墓守陵人',
  'Unit\\NPC\\03-Chapter\\Other\\DemonCity\\RoyalGravekeeper.mdx',
  'Unit\\NPC\\03-Chapter\\Other\\Icon\\RoyalGravekeeper.blp',
  1.15
)

createDemonCityQuestNpc(
  'n06J',
  '熔灵工匠',
  'Unit\\NPC\\03-Chapter\\Other\\DemonCity\\MoltenArtisan.mdx',
  'Unit\\NPC\\03-Chapter\\Other\\Icon\\MoltenArtisan.blp',
  1.15
)

createDemonCityQuestNpc(
  'n06K',
  '熔火酒窖管事',
  'Unit\\NPC\\03-Chapter\\Other\\DemonCity\\WineCellarManager.mdx',
  'Unit\\NPC\\03-Chapter\\Other\\Icon\\WineCellarManager.blp',
  1.25
)

createDemonCityQuestNpc(
  'n06L',
  '恶魔城外巡卫',
  'Unit\\NPC\\03-Chapter\\Other\\DemonCity\\DemonGuard.mdx',
  'Unit\\NPC\\03-Chapter\\Other\\Icon\\DemonGuard.blp',
  1.25
)
