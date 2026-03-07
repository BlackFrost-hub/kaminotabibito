--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local runtime = require("jass.runtime")
runtime.console = true
local jassConsole = require("jass.console")
require("jass.japi")
local jass = require("jass.common")
local g = require("jass.globals")
if g.YDUserDataGet2 and not jass.YDUserDataGet2 then
    jass.YDUserDataGet2 = g.YDUserDataGet2
end
if g.YDUserDataGet and not jass.YDUserDataGet then
    jass.YDUserDataGet = g.YDUserDataGet
end
if g.Ir_GetUnitAttackType and not jass.Ir_GetUnitAttackType then
    jass.Ir_GetUnitAttackType = g.Ir_GetUnitAttackType
end
if g.Ir_SetUnitAttackType and not jass.Ir_SetUnitAttackType then
    jass.Ir_SetUnitAttackType = g.Ir_SetUnitAttackType
end
_G.print = function(...)
    local args = {...}
    local str = ""
    do
        local i = 0
        while i < #args do
            str = str .. tostring(args[i + 1])
            if i < #args - 1 then
                str = str .. "\t"
            end
            i = i + 1
        end
    end
    jassConsole.write(str .. "\n")
end
require("系统.装备.装备提取")
require("系统.测试.测试事件")
local ok, err = pcall(function () return require("系统.装备.装备系统") end
    )
if not ok then
    _G.print(
        "装备系统加载失败:",
        tostring(err)
    )
end
return ____exports
