--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
____exports.TASK_UI_DEBUG = false
local function getPrint(self)
    return _G.print
end
function ____exports.taskUiDebug(self, msg)
    if not ____exports.TASK_UI_DEBUG then
        return
    end
    local ____opt_0 = getPrint(nil)
    if ____opt_0 ~= nil then
        ____opt_0(nil, "[TaskUI] " .. msg)
    end
end
function ____exports.taskUiDebugPlayerTag(self)
    local ____opt_2 = jass.GetLocalPlayer
    if ____opt_2 ~= nil then
        ____opt_2 = ____opt_2(jass)
    end
    local lp = ____opt_2
    local ____temp_4
    if lp ~= nil and type(jass.GetPlayerId) == "function" then
        ____temp_4 = jass.GetPlayerId(lp)
    else
        ____temp_4 = -1
    end
    local pid = ____temp_4
    return "lp=" .. tostring(pid)
end
return ____exports
