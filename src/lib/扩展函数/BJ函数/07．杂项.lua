--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
function ____exports.ModifyGateBJ(self, gateOperation, d)
    if not d then
        return
    end
    if type(jass.GetDestructableLife) ~= "function" or type(jass.GetDestructableMaxLife) ~= "function" or type(jass.SetDestructableAnimation) ~= "function" then
        return
    end
    local CLOSE = jglobals.bj_GATEOPERATION_CLOSE
    local OPEN = jglobals.bj_GATEOPERATION_OPEN
    local DESTROY = jglobals.bj_GATEOPERATION_DESTROY
    if gateOperation == CLOSE then
        if jass.GetDestructableLife(d) <= 0 and type(jass.DestructableRestoreLife) == "function" then
            jass.DestructableRestoreLife(
                d,
                jass.GetDestructableMaxLife(d),
                true
            )
        end
        jass.SetDestructableAnimation(d, "stand")
        return
    end
    if gateOperation == OPEN then
        if jass.GetDestructableLife(d) > 0 and type(jass.KillDestructable) == "function" then
            jass.KillDestructable(d)
        end
        jass.SetDestructableAnimation(d, "death alternate")
        return
    end
    if gateOperation == DESTROY then
        if jass.GetDestructableLife(d) > 0 and type(jass.KillDestructable) == "function" then
            jass.KillDestructable(d)
        end
        jass.SetDestructableAnimation(d, "death")
    end
end
function ____exports.GetUnitsInRectMatching(self, r, filter)
    if type(jass.CreateGroup) ~= "function" then
        return nil
    end
    local g = jass.CreateGroup()
    if not g then
        return nil
    end
    if type(jass.GroupEnumUnitsInRect) == "function" then
        jass.GroupEnumUnitsInRect(g, r, filter)
    end
    if filter and type(jass.DestroyBoolExpr) == "function" then
        jass.DestroyBoolExpr(filter)
    end
    return g
end
function ____exports.ForGroupBJ(self, whichGroup, callback)
    local wantDestroy = not not jglobals.bj_wantDestroyGroup
    jglobals.bj_wantDestroyGroup = false
    if type(jass.ForGroup) == "function" then
        jass.ForGroup(whichGroup, callback)
    end
    if wantDestroy and type(jass.DestroyGroup) == "function" then
        jass.DestroyGroup(whichGroup)
    end
end
function ____exports.GetPlayersAll(self)
    return jglobals.bj_FORCE_ALL_PLAYERS
end
function ____exports.GetRandomDirectionDeg(self)
    return jass.GetRandomReal(0, 360)
end
function ____exports.GetSpellAbilityId(self)
    if type(jass.GetSpellAbilityId) == "function" then
        return jass.GetSpellAbilityId()
    end
    return 0
end
function ____exports.OrderIdToString(self, orderId)
    local c1 = orderId % 256
    local c2 = math.floor(orderId / 256) % 256
    local c3 = math.floor(orderId / 256 / 256) % 256
    local c4 = math.floor(orderId / 256 / 256 / 256) % 256
    return string.char(c1, c2, c3, c4)
end
____exports.lastCreatedEffect = nil
function ____exports.AddSpecialEffectTargetUnitBJ(self, attachPointName, targetWidget, modelName)
    if type(jass.AddSpecialEffectTarget) == "function" then
        ____exports.lastCreatedEffect = jass.AddSpecialEffectTarget(modelName, targetWidget, attachPointName)
        return ____exports.lastCreatedEffect
    end
    return nil
end
function ____exports.OperatorDegreeMultiply(self, a, b)
    return a * b
end
function ____exports.OperatorRealAdd(self, a, b)
    return a + b
end
function ____exports.OperatorRealMultiply(self, a, b)
    return a * b
end
function ____exports.IMaxBJ(self, a, b)
    return a >= b and a or b
end
function ____exports.IMinBJ(self, a, b)
    return a <= b and a or b
end
return ____exports
