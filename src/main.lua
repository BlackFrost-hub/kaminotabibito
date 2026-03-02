--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local runtime = require("jass.runtime")
runtime.console = true
local jassConsole = require("jass.console")
local originalPrint = _G.print
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
_G.print("hello world")
_G.print("hello world")
_G.print("hello world")
_G.print("hello world")
local jassMain = require("jass.common")
local timer = jassMain.CreateTimer()
jassMain.TimerStart(
    timer,
    0.5,
    false,
    function()
        _G.print("延迟加载装备系统...")
        local success, result = pcall(function () return require("item_modules.equip_system") end
            )
        if success then
            _G.print("装备系统加载完成")
        else
            if originalPrint then
                originalPrint("装备系统加载失败:", result)
            end
        end
    end
)
_G.print("main.lua Loading complete")
return ____exports
