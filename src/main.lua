--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local runtime = require(nil, "jass.runtime")
runtime.console = true
local jassConsole = require(nil, "jass.console")
_G.print = function(____, ...)
    local args = {...}
    local str = ""
    do
        local i = 0
        while i < #args do
            str = str .. tostring(nil, args[i + 1])
            if i < #args - 1 then
                str = str .. "\t"
            end
            i = i + 1
        end
    end
    jassConsole:write(str .. "\n")
end
require(nil, "系统.装备.装备提取")
local ok, err = unpack(
    pcall(
        nil,
        function() return require(nil, "系统.装备.装备系统") end
    ),
    1,
    2
)
if not ok then
    _G:print(
        "装备系统加载失败:",
        tostring(nil, err)
    )
end
return ____exports
