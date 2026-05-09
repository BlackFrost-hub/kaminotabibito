local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local damageModifiers = {}
local nextModifierId = 1
local function sortDamageModifiers(self)
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
function ____exports.registerDamageModifier(self, callback, priority)
    if priority == nil then
        priority = 0
    end
    if callback == nil then
        return 0
    end
    local id = nextModifierId
    nextModifierId = nextModifierId + 1
    damageModifiers[#damageModifiers + 1] = {id = id, priority = priority, callback = callback}
    sortDamageModifiers(nil)
    return id
end
function ____exports.unregisterDamageModifier(self, id)
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
function ____exports.applyDamageModifiers(self, context)
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
function ____exports.getDamageModifierCount(self)
    return #damageModifiers
end
return ____exports
