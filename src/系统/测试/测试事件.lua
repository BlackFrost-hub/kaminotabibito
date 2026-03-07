--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local function onTestEvent(self)
    local ____this_1
    ____this_1 = _G
    local ____opt_0 = ____this_1.print
    if ____opt_0 ~= nil then
        _G.print("2222 [TestEvent] step2")
    end
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        8,
        "2222"
    )
    jass.QuestMessageBJ(
        jass.GetPlayersAll(),
        jass.bj_QUESTMESSAGE_UPDATED,
        "2222"
    )
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
                            local ____hasGet_2
                            if hasGet then
                                ____hasGet_2 = jass.Ir_GetUnitAttackType(u)
                            else
                                ____hasGet_2 = -1
                            end
                            local before = ____hasGet_2
                            jass.Ir_SetUnitAttackType(u, 5)
                            local ____hasGet_3
                            if hasGet then
                                ____hasGet_3 = jass.Ir_GetUnitAttackType(u)
                            else
                                ____hasGet_3 = -1
                            end
                            local after = ____hasGet_3
                            out = (("before=" .. tostring(before)) .. " after=") .. tostring(after)
                        end
                    end
                )
            if not ok then
                out = "pcall err: " .. tostring(err)
            end
            local line = "[TestEvent] " .. out
            local ____this_5
            ____this_5 = _G
            local ____opt_4 = ____this_5.print
            if ____opt_4 ~= nil then
                ____opt_4(____this_5, line)
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
    local ____jass_STES_Register_6 = jass.STES_Register
    if ____jass_STES_Register_6 == nil then
        ____jass_STES_Register_6 = g.STES_Register
    end
    local ____jass_STES_Register_6_7 = ____jass_STES_Register_6
    if ____jass_STES_Register_6_7 == nil then
        ____jass_STES_Register_6_7 = _G.STES_Register
    end
    local STES_Reg = ____jass_STES_Register_6_7
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
