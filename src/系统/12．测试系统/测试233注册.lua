local ____lualib = require("lualib_bundle")
local __TS__TypeOf = ____lualib.__TS__TypeOf
local ____exports = {}
local jass = require("jass.common")
local function dumpJapiKeys(self)
    local pr = _G.print
    if not pr then
        return
    end
    do
        local function ____catch(e)
            local ____this_1
            ____this_1 = _G
            local ____opt_0 = ____this_1.print
            if ____opt_0 ~= nil then
                _G.print("[japi] require failed: " .. tostring(e)
                )
            end
        end
        local ____try, ____hasReturned = pcall(function()
            local japi = require("jass.japi")
            pr("[japi] typeof=" .. tostring(__TS__TypeOf(japi)
                )
            )
            local keys = {}
            for k in pairs(japi) do
                if type(k) == "string" then
                    keys[#keys + 1] = k
                end
            end
            pr("[japi] keys=" .. tostring(#keys)
            )
            pr("[japi] list=" .. table.concat(keys, ", ")
            )
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
    end
end
local function dumpDzKeyEventTrgType(self)
    local pr = _G.print
    if not pr then
        return
    end
    local g = _G
    local t0 = "nil"
    local t1 = "nil"
    local t2 = "nil"
    local tP0 = "nil"
    local tP1 = "nil"
    local tBy0 = "nil"
    local tBy1 = "nil"
    local tBy2 = "nil"
    do
        pcall(function()
            t0 = tostring(__TS__TypeOf(g.DzTriggerRegisterKeyEventTrg)
            )
        end)
    end
    do
        pcall(function()
            t1 = tostring(__TS__TypeOf(require("jass.common").DzTriggerRegisterKeyEventTrg)
            )
        end)
    end
    do
        pcall(function()
            t2 = tostring(__TS__TypeOf(require("jass.globals").DzTriggerRegisterKeyEventTrg)
            )
        end)
    end
    pr("[type] _G.DzTriggerRegisterKeyEventTrg=" .. t0)
    pr("[type] jass.common.DzTriggerRegisterKeyEventTrg=" .. t1)
    pr("[type] jass.globals.DzTriggerRegisterKeyEventTrg=" .. t2)
    do
        pcall(function()
            tP0 = tostring(__TS__TypeOf(require("jass.common").DzGetTriggerKeyPlayer)
            )
        end)
    end
    do
        pcall(function()
            tP1 = tostring(__TS__TypeOf(require("jass.japi").DzGetTriggerKeyPlayer)
            )
        end)
    end
    pr("[type] jass.common.DzGetTriggerKeyPlayer=" .. tP0)
    pr("[type] jass.japi.DzGetTriggerKeyPlayer=" .. tP1)
    do
        pcall(function()
            tBy0 = tostring(__TS__TypeOf(g.DzTriggerRegisterKeyEventByCode)
            )
        end)
    end
    do
        pcall(function()
            tBy1 = tostring(__TS__TypeOf(require("jass.common").DzTriggerRegisterKeyEventByCode)
            )
        end)
    end
    do
        pcall(function()
            tBy2 = tostring(__TS__TypeOf(require("jass.japi").DzTriggerRegisterKeyEventByCode)
            )
        end)
    end
    pr("[type] _G.DzTriggerRegisterKeyEventByCode=" .. tBy0)
    pr("[type] jass.common.DzTriggerRegisterKeyEventByCode=" .. tBy1)
    pr("[type] jass.japi.DzTriggerRegisterKeyEventByCode=" .. tBy2)
    local tMx0 = "nil"
    local tMx1 = "nil"
    do
        pcall(function()
            tMx0 = tostring(__TS__TypeOf(g.DzGetMouseX)
            )
        end)
    end
    do
        pcall(function()
            tMx1 = tostring(__TS__TypeOf(require("jass.japi").DzGetMouseX)
            )
        end)
    end
    pr("[type] _G.DzGetMouseX=" .. tMx0)
    pr("[type] jass.japi.DzGetMouseX=" .. tMx1)
end
local function bindKeyBN_once_min(self)
    local pr = _G.print
    if not pr then
        return
    end
    local g = _G
    if g.__keytest_bound then
        pr("[keytest] already bound")
        return
    end
    g.__keytest_bound = true
    local japi = require("jass.japi")
    if type(jass.CreateTrigger) ~= "function" or type(jass.DisplayTimedTextToPlayer) ~= "function" or type(jass.Player) ~= "function" then
        pr("[keytest] missing basic jass funcs")
        return
    end
    if type(japi.DzTriggerRegisterKeyEventByCode) ~= "function" then
        pr("[keytest] DzTriggerRegisterKeyEventByCode not function")
        return
    end
    local function bind(____, key, label)
        local trig = jass.CreateTrigger()
        japi.DzTriggerRegisterKeyEventByCode(
            trig,
            key,
            1,
            false,
            function()
                local msg = ((("[KEYOK] " .. label) .. " key=") .. tostring(key)) .. " sync=false"
                do
                    local i = 0
                    while i < 12 do
                        jass.DisplayTimedTextToPlayer(
                            jass.Player(i),
                            0,
                            0,
                            5,
                            msg
                        )
                        i = i + 1
                    end
                end
            end
        )
    end
    pr("[keytest] bind B/N (sync=false, key=66/78)")
    bind(nil, 66, "B")
    bind(nil, 78, "N")
end
local function onChat233(self)
    dumpJapiKeys(nil)
    dumpDzKeyEventTrgType(nil)
    bindKeyBN_once_min(nil)
    if type(jass.DisplayTimedTextToPlayer) == "function" and type(jass.Player) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            6,
            "[japi] 已打印 jass.japi keys"
        )
    end
end
local function init(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.TriggerRegisterPlayerChatEvent) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    local tr = jass.CreateTrigger()
    jass.TriggerRegisterPlayerChatEvent(
        tr,
        jass.Player(0),
        "233",
        true
    )
    jass.TriggerAddAction(tr, onChat233)
end
init(nil)
return ____exports
