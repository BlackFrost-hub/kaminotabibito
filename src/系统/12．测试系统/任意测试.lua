--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.12．YDWE函数")
local getObjectProperty = ____require_result_0.getObjectProperty
local ObjectType = ____require_result_0.ObjectType
local t = jass.CreateTimer()
jass.TimerStart(
    t,
    1,
    false,
    function()
        local u = jass.gg_unit_Hamg_0002
        if u then
            local primary = getObjectProperty(nil, ObjectType.UNIT, "Hamg", "Primary")
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                10,
                "单位存在! Hamg Primary: " .. primary
            )
        else
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                10,
                "gg_unit_Hamg_0002 不存在!"
            )
        end
        jass.DestroyTimer(t)
    end
)
return ____exports
