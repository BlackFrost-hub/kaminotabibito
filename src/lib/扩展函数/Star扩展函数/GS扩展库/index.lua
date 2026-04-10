--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local gsExt = require("lib.扩展函数.Star扩展函数.GS扩展库.00．极坐标投影")
do
    local ____export = require("lib.扩展函数.Star扩展函数.GS扩展库.00．极坐标投影")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local function expose(self, name, fn)
    if type(fn) ~= "function" then
        return
    end
    local g = _G
    if type(g[name]) == "function" then
        return
    end
    g[name] = fn
end
function ____exports.registerBridge(self)
    expose(nil, "GS_PolarProjectionBJ", gsExt.GS_PolarProjectionBJ)
end
return ____exports
