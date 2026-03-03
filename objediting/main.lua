```lua
-- Require or define UnitDefinition before using it
-- Example: require the module if it exists
-- local UnitDefinition = require("UnitDefinition")

-- Or define a simple mock for demonstration
UnitDefinition = {}
UnitDefinition.__index = UnitDefinition
function UnitDefinition:new(id, type)
	local obj = setmetatable({}, self)
	obj.id = id
	obj.type = type
	return obj
end
function UnitDefinition:setName(name)
	self.name = name
end

local h101 = UnitDefinition:new('H101', 'Hpal')
hYou need to define or require the `UnitDefinition` class/module before using it in your code.
