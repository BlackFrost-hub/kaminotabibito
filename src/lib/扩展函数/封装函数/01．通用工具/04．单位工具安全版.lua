--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local _____5355_4F4D_7EC4_904D_5386_56DE_8C03_6808 = {}
local function ____on_5B89_5168_904D_5386_5355_4F4D_7EC4()
    local _____56DE_8C03 = _____5355_4F4D_7EC4_904D_5386_56DE_8C03_6808[#_____5355_4F4D_7EC4_904D_5386_56DE_8C03_6808]
    if type(_____56DE_8C03) ~= "function" then
        return
    end
    local _____5355_4F4D = GetEnumUnit()
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    _____56DE_8C03(_____5355_4F4D)
end
--- `@noSelfInFile` 兼容的单位组遍历。
-- 使用具名 JASS `ForGroup` 回调，不修改原单位组，支持同步嵌套遍历。
function ____exports.forEachUnitInGroupSafe(_____5355_4F4D_7EC4, _____56DE_8C03)
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 or type(_____56DE_8C03) ~= "function" then
        return
    end
    _____5355_4F4D_7EC4_904D_5386_56DE_8C03_6808[#_____5355_4F4D_7EC4_904D_5386_56DE_8C03_6808 + 1] = _____56DE_8C03
    ForGroup(_____5355_4F4D_7EC4, ____on_5B89_5168_904D_5386_5355_4F4D_7EC4)
    table.remove(_____5355_4F4D_7EC4_904D_5386_56DE_8C03_6808)
end
return ____exports
