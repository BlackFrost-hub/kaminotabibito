local ____lualib = require("lualib_bundle")
local __TS__TypeOf = ____lualib.__TS__TypeOf
local ____exports = {}
local ____04_FF0E_952E_76D8_51FD_6570 = require("lib.扩展函数.封装函数.04．硬件输入.04．键盘函数")
local registerKeyEventByCode = ____04_FF0E_952E_76D8_51FD_6570.registerKeyEventByCode
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____01_FF0E_5E38_91CF_5B9A_4E49.KEY_STATE
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
                ____opt_0(
                    ____this_1,
                    "[japi] require failed: " .. tostring(nil, e)
                )
            end
        end
        local ____try, ____hasReturned = pcall(function()
            local japi = require("jass.japi")
            pr(
                nil,
                "[japi] typeof=" .. tostring(
                    nil,
                    __TS__TypeOf(japi)
                )
            )
            local keys = {}
            for k in pairs(japi) do
                if type(k) == "string" then
                    keys[#keys + 1] = k
                end
            end
            pr(
                nil,
                "[japi] keys=" .. tostring(nil, #keys)
            )
            pr(
                nil,
                "[japi] list=" .. table.concat(keys, ", ")
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
            t0 = tostring(
                nil,
                __TS__TypeOf(g.DzTriggerRegisterKeyEventTrg)
            )
        end)
    end
    do
        pcall(function()
            t1 = tostring(
                nil,
                __TS__TypeOf(require("jass.common").DzTriggerRegisterKeyEventTrg)
            )
        end)
    end
    do
        pcall(function()
            t2 = tostring(
                nil,
                __TS__TypeOf(require("jass.globals").DzTriggerRegisterKeyEventTrg)
            )
        end)
    end
    pr(nil, "[type] _G.DzTriggerRegisterKeyEventTrg=" .. t0)
    pr(nil, "[type] jass.common.DzTriggerRegisterKeyEventTrg=" .. t1)
    pr(nil, "[type] jass.globals.DzTriggerRegisterKeyEventTrg=" .. t2)
    do
        pcall(function()
            tP0 = tostring(
                nil,
                __TS__TypeOf(require("jass.common").DzGetTriggerKeyPlayer)
            )
        end)
    end
    do
        pcall(function()
            tP1 = tostring(
                nil,
                __TS__TypeOf(require("jass.japi").DzGetTriggerKeyPlayer)
            )
        end)
    end
    pr(nil, "[type] jass.common.DzGetTriggerKeyPlayer=" .. tP0)
    pr(nil, "[type] jass.japi.DzGetTriggerKeyPlayer=" .. tP1)
    do
        pcall(function()
            tBy0 = tostring(
                nil,
                __TS__TypeOf(g.DzTriggerRegisterKeyEventByCode)
            )
        end)
    end
    do
        pcall(function()
            tBy1 = tostring(
                nil,
                __TS__TypeOf(require("jass.common").DzTriggerRegisterKeyEventByCode)
            )
        end)
    end
    do
        pcall(function()
            tBy2 = tostring(
                nil,
                __TS__TypeOf(require("jass.japi").DzTriggerRegisterKeyEventByCode)
            )
        end)
    end
    pr(nil, "[type] _G.DzTriggerRegisterKeyEventByCode=" .. tBy0)
    pr(nil, "[type] jass.common.DzTriggerRegisterKeyEventByCode=" .. tBy1)
    pr(nil, "[type] jass.japi.DzTriggerRegisterKeyEventByCode=" .. tBy2)
    local tMx0 = "nil"
    local tMx1 = "nil"
    do
        pcall(function()
            tMx0 = tostring(
                nil,
                __TS__TypeOf(g.DzGetMouseX)
            )
        end)
    end
    do
        pcall(function()
            tMx1 = tostring(
                nil,
                __TS__TypeOf(require("jass.japi").DzGetMouseX)
            )
        end)
    end
    pr(nil, "[type] _G.DzGetMouseX=" .. tMx0)
    pr(nil, "[type] jass.japi.DzGetMouseX=" .. tMx1)
end
local function bindKeyBN_once_min(self)
    local pr = _G.print
    if not pr then
        return
    end
    local g = _G
    if g.__keytest_bound then
        pr(nil, "[keytest] already bound")
        return
    end
    g.__keytest_bound = true
    local function bind(____, key, label)
        registerKeyEventByCode(
            nil,
            key,
            KEY_STATE.DOWN,
            false,
            function()
                local msg = ((("[KEYOK] " .. label) .. " key=") .. tostring(nil, key)) .. " sync=false"
                do
                    local i = 0
                    while i < 12 do
                        jass:DisplayTimedTextToPlayer(
                            jass:Player(i),
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
    pr(nil, "[keytest] bind B/N (sync=false, key=66/78)")
    bind(nil, 66, "B")
    bind(nil, 78, "N")
end
local function onChat233(self)
    dumpJapiKeys(nil)
    dumpDzKeyEventTrgType(nil)
    bindKeyBN_once_min(nil)
    jass:DisplayTimedTextToPlayer(
        jass:Player(0),
        0,
        0,
        6,
        "[japi] 已打印 jass.japi keys"
    )
end
local function init(self)
    local tr = jass:CreateTrigger()
    jass:TriggerRegisterPlayerChatEvent(
        tr,
        jass:Player(0),
        "233",
        true
    )
    jass:TriggerAddAction(tr, onChat233)
end
init(nil)
return ____exports
