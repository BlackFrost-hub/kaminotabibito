local FRIEREN_FLOWER_CLUSTER_ID = 'D0B5'
local BASE_FLOWER_ID = 'ZWcl'

local function getCreateDefinition()
    local index = 1
    while true do
        local name, value = debug.getupvalue(W3BDefinition.constructor, index)
        if not name then
            break
        end
        if name == '_ENV' and type(value.createDefinition) == 'function' then
            return value.createDefinition
        end
        index = index + 1
    end
    error('ObjEditing createDefinition API is unavailable', 2)
end

local createDefinition = getCreateDefinition()
local flower = createDefinition(DefinitionType.Doodad, FRIEREN_FLOWER_CLUSTER_ID, BASE_FLOWER_ID)
flower:setString('dnam', '芙莉莲花簇')
flower:setString('dfil', 'Common\\Decoration\\Flower\\FrierenFlowerCluster.mdx')
flower:setInt('dvar', 1)
flower:setString('dptx', '')
