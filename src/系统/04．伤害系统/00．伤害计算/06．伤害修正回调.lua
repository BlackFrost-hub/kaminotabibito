local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_0.getBuffRuntime
local damageModifiers = {}
local nextModifierId = 1
local vulnerableModifierRegistered = false
local damageBaseModifiers = {}
local nextBaseModifierId = 1
local VULNERABLE_BUFF_ID = "C026"
local function sortDamageModifiers()
    __TS__ArraySort(
        damageModifiers,
        function(____, a, b)
            if a.priority ~= b.priority then
                return b.priority - a.priority
            end
            return a.id - b.id
        end
    )
end
function ____exports.registerDamageModifier(callback, priority)
    if priority == nil then
        priority = 0
    end
    if callback == nil then
        return 0
    end
    local id = nextModifierId
    nextModifierId = nextModifierId + 1
    damageModifiers[#damageModifiers + 1] = {id = id, priority = priority, callback = callback}
    sortDamageModifiers()
    return id
end
function ____exports.unregisterDamageModifier(id)
    do
        local i = 0
        while i < #damageModifiers do
            do
                if damageModifiers[i + 1].id ~= id then
                    goto __continue9
                end
                __TS__ArraySplice(damageModifiers, i, 1)
                return true
            end
            ::__continue9::
            i = i + 1
        end
    end
    return false
end
function ____exports.applyDamageModifiers(context)
    local currentDamage = context.currentDamage
    do
        local i = 0
        while i < #damageModifiers do
            do
                local entry = damageModifiers[i + 1]
                if entry == nil or entry.callback == nil then
                    goto __continue13
                end
                context.currentDamage = currentDamage
                local nextDamage = entry.callback(context)
                if type(nextDamage) == "number" then
                    currentDamage = nextDamage
                end
            end
            ::__continue13::
            i = i + 1
        end
    end
    return currentDamage
end
local function sortDamageBaseModifiers()
    __TS__ArraySort(
        damageBaseModifiers,
        function(self, a, b)
            if a.priority ~= b.priority then
                return b.priority - a.priority
            end
            return a.id - b.id
        end
    )
end
function ____exports.registerDamageBaseModifier(callback, priority)
    if priority == nil then
        priority = 0
    end
    if callback == nil then
        return 0
    end
    local id = nextBaseModifierId
    nextBaseModifierId = nextBaseModifierId + 1
    damageBaseModifiers[#damageBaseModifiers + 1] = {id = id, priority = priority, callback = callback}
    sortDamageBaseModifiers()
    return id
end
function ____exports.unregisterDamageBaseModifier(id)
    do
        local i = 0
        while i < #damageBaseModifiers do
            do
                if damageBaseModifiers[i + 1].id ~= id then
                    goto __continue23
                end
                __TS__ArraySplice(damageBaseModifiers, i, 1)
                return true
            end
            ::__continue23::
            i = i + 1
        end
    end
    return false
end
function ____exports.applyDamageBaseModifiers(context)
    local currentDamage = context.currentDamage
    do
        local i = 0
        while i < #damageBaseModifiers do
            do
                local entry = damageBaseModifiers[i + 1]
                if entry == nil or entry.callback == nil then
                    goto __continue27
                end
                context.currentDamage = currentDamage
                local nextDamage = entry.callback(context)
                if type(nextDamage) == "number" then
                    currentDamage = nextDamage
                end
            end
            ::__continue27::
            i = i + 1
        end
    end
    return currentDamage
end
function ____exports.getDamageBaseModifierCount()
    return #damageBaseModifiers
end
function ____exports.getDamageModifierCount()
    return #damageModifiers
end
local function getVulnerableMultiplier(value)
    if type(value) ~= "number" or not __TS__NumberIsFinite(__TS__Number(value)) or value == 0 then
        return 0
    end
    if value > -1 and value < 1 then
        return value
    end
    return value / 100
end
local function onVulnerableDamageModifier(context)
    local buffRuntime = getBuffRuntime(context.target, VULNERABLE_BUFF_ID)
    if buffRuntime == nil then
        return context.currentDamage
    end
    local bonus = getVulnerableMultiplier(buffRuntime.effect)
    if bonus <= 0 then
        return context.currentDamage
    end
    return context.currentDamage * (1 + bonus)
end
local function ensureVulnerableModifierRegistered()
    if vulnerableModifierRegistered then
        return
    end
    vulnerableModifierRegistered = true
    ____exports.registerDamageModifier(onVulnerableDamageModifier, 20)
end
ensureVulnerableModifierRegistered()
return ____exports
