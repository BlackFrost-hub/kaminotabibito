--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
____exports.STEP_LEN = 2
____exports.TICK = 0.03
function ____exports.nextTypingProgress(self, current, step)
    if step == nil then
        step = ____exports.STEP_LEN
    end
    return current + step
end
function ____exports.substringCompat(self, text, start, ____end)
    if type(jass.SubString) == "function" then
        return jass.SubString(text, start, ____end)
    end
    return text:sub(start + 1, ____end)
end
function ____exports.stringLengthCompat(self, text)
    if type(jass.StringLength) == "function" then
        return jass.StringLength(text)
    end
    return #text
end
return ____exports
