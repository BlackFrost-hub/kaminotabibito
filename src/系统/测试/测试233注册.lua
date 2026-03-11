--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local function dumpAllKeys(self)
    local pr = _G.print
    if not pr then
        return
    end
    local j = jass
    local g = _G
    pr(nil, "--- jass 全部 key ---")
    for k in pairs(j) do
        pr(nil, "jass." .. k)
    end
    pr(nil, "--- _G 全部 key ---")
    for k in pairs(g) do
        pr(nil, "_G." .. k)
    end
end
local function listAllCustomJassFunctions(self)
    local pr = _G.print
    if not pr then
        return
    end
    local g = _G
    local count = 0
    pr(nil, "=== 所有自定义Jass函数(_G中,非jass) ===")
    for k in pairs(g) do
        if type(g[k]) == "function" and k ~= "_G" and (string.find(k, "jass", nil, true) or 0) - 1 ~= 0 then
            pr(nil, k)
            count = count + 1
            if count > 50 then
                break
            end
        end
    end
    pr(
        nil,
        ("总共找到 " .. tostring(count)) .. "+ 个自定义函数"
    )
end
local function listCounts(self)
    local pr = _G.print
    if not pr then
        return
    end
    local j = jass
    local g = _G
    local jassCount = 0
    local globalCount = 0
    for k in pairs(j) do
        if type(j[k]) == "function" then
            jassCount = jassCount + 1
        end
    end
    for k in pairs(g) do
        if type(g[k]) == "function" and k ~= "_G" and (string.find(k, "jass", nil, true) or 0) - 1 ~= 0 then
            globalCount = globalCount + 1
        end
    end
    pr(nil, "---")
    pr(
        nil,
        ((("找到 jass 函数 " .. tostring(jassCount)) .. " 个, 全局函数 ") .. tostring(globalCount)) .. " 个"
    )
end
local function findFunction(self, funcName)
    local j = jass
    local glob = _G
    local pr = glob.print
    if j[funcName] then
        if pr ~= nil then
            pr(nil, "✅ 在 jass 表里: jass." .. funcName)
        end
        return j[funcName]
    end
    if glob[funcName] then
        if pr ~= nil then
            pr(nil, "✅ 在全局环境: _G." .. funcName)
        end
        return glob[funcName]
    end
    if pr ~= nil then
        pr(nil, "❌ 找不到: " .. funcName)
    end
    dumpAllKeys(nil)
    return nil
end
local function onChat233(self)
    local STES_Register = findFunction(nil, "STES_Register")
    if STES_Register then
        local trig = jass.CreateTrigger()
        jass.TriggerAddAction(
            trig,
            function()
                local ____this_7
                ____this_7 = _G
                local ____opt_6 = ____this_7.print
                if ____opt_6 ~= nil then
                    ____opt_6(____this_7, "LuaEvent_GetItem 触发")
                end
                jass.DisplayTimedTextToPlayer(
                    jass.Player(0),
                    0,
                    0,
                    8,
                    "LuaEvent_GetItem 触发"
                )
            end
        )
        STES_Register(nil, trig, "LuaEvent_GetItem")
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            8,
            "已注册 LuaEvent_GetItem"
        )
    end
    listAllCustomJassFunctions(nil)
    listCounts(nil)
end
local function init(self)
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
