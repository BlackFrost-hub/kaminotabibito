--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _print = _G.print
local DEBUG_FLAGS = {}
function ____exports.setDebug(self, module, on)
    DEBUG_FLAGS[module] = on
end
function ____exports.isDebug(self, module)
    return DEBUG_FLAGS[module] == true
end
function ____exports.debugLog(self, module, ...)
    if not ____exports.isDebug(nil, module) then
        return
    end
    if not _print then
        return
    end
    local prefix = ("[" .. module) .. "] "
    _print(nil, prefix, ...)
end
function ____exports.debugLogForce(self, module, ...)
    if not _print then
        return
    end
    local prefix = ("[" .. module) .. "] "
    _print(nil, prefix, ...)
end
return ____exports
