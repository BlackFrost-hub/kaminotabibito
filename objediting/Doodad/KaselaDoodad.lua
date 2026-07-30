local KASELA_INSULATING_CORAL_ID = 'D0B3'
local BASE_CORAL_ID = 'ZWcl'

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
local coral = createDefinition(DefinitionType.Doodad, KASELA_INSULATING_CORAL_ID, BASE_CORAL_ID)
coral:setString('dnam', '绝缘珊瑚')
coral:setString('dfil', 'Doodads\\Ruins\\Water\\Coral\\Coral')
coral:setInt('dvar', 7)
coral:setString('dptx', '')
