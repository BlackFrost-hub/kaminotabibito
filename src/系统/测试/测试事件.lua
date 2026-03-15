--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local function onTestEvent(self)
    local t = jass.CreateTimer()
    jass.TimerStart(
        t,
        0,
        false,
        function()
            local out = ""
            local ok, err = pcall(function ()
                        local u = g.gg_unit_Hamg_0002
                        local hasSet = not not jass.Ir_SetUnitAttackType
                        out = (("u=" .. tostring(not not u)) .. " hasSet=") .. tostring(hasSet)
                        if u and hasSet then
                            local hasGet = not not jass.Ir_GetUnitAttackType
                            local ____hasGet_0
                            if hasGet then
                                ____hasGet_0 = jass.Ir_GetUnitAttackType(u)
                            else
                                ____hasGet_0 = -1
                            end
                            local before = ____hasGet_0
                            jass.Ir_SetUnitAttackType(u, 5)
                            local ____hasGet_1
                            if hasGet then
                                ____hasGet_1 = jass.Ir_GetUnitAttackType(u)
                            else
                                ____hasGet_1 = -1
                            end
                            local after = ____hasGet_1
                            out = (("before=" .. tostring(before)) .. " after=") .. tostring(after)
                        end
                    end
                )
            if not ok then
                out = "pcall err: " .. tostring(err)
            end
            local line = "[TestEvent] " .. out
            local ____this_3
            ____this_3 = _G
            local ____opt_2 = ____this_3.print
            if ____opt_2 ~= nil then
                ____opt_2(____this_3, line)
            end
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                15,
                line
            )
        end
    )
end
local function init(self)
    local evtTrig = jass.CreateTrigger()
    jass.TriggerAddAction(evtTrig, onTestEvent)
    local ____jass_STES_Register_4 = jass.STES_Register
    if ____jass_STES_Register_4 == nil then
        ____jass_STES_Register_4 = g.STES_Register
    end
    local ____jass_STES_Register_4_5 = ____jass_STES_Register_4
    if ____jass_STES_Register_4_5 == nil then
        ____jass_STES_Register_4_5 = _G.STES_Register
    end
    local STES_Reg = ____jass_STES_Register_4_5
    if type(STES_Reg) == "function" then
        STES_Reg(evtTrig, "测试事件")
    else
        g.udg_RegTrigger = evtTrig
        g.udg_RegEventStr = "测试事件"
        jass.ExecuteFunc("Bridge_STES_Register")
    end
end
init(nil)
return ____exports
