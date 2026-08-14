--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
function ____exports.ModifyGateBJ(gateOperation, d)
    if not d then
        return
    end
    local CLOSE = jglobals.bj_GATEOPERATION_CLOSE
    local OPEN = jglobals.bj_GATEOPERATION_OPEN
    local DESTROY = jglobals.bj_GATEOPERATION_DESTROY
    if gateOperation == CLOSE then
        if jass.GetDestructableLife(d) <= 0 then
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
        if jass.GetDestructableLife(d) > 0 then
            jass.KillDestructable(d)
        end
        jass.SetDestructableAnimation(d, "death alternate")
        return
    end
    if gateOperation == DESTROY then
        if jass.GetDestructableLife(d) > 0 then
            jass.KillDestructable(d)
        end
        jass.SetDestructableAnimation(d, "death")
    end
end
function ____exports.GetUnitsInRectMatching(r, filter)
    local g = jass.CreateGroup()
    if not g then
        return nil
    end
    jass.GroupEnumUnitsInRect(g, r, filter)
    if filter then
        jass.DestroyBoolExpr(filter)
    end
    return g
end
function ____exports.ForGroupBJ(whichGroup, callback)
    local wantDestroy = not not jglobals.bj_wantDestroyGroup
    jglobals.bj_wantDestroyGroup = false
    jass.ForGroup(whichGroup, callback)
    if wantDestroy then
        jass.DestroyGroup(whichGroup)
    end
end
function ____exports.GetPlayersAll()
    return jglobals.bj_FORCE_ALL_PLAYERS
end
function ____exports.SetTimeOfDay(whatTime)
    jass.SetFloatGameState(jglobals.GAME_STATE_TIME_OF_DAY, whatTime)
end
function ____exports.GetRandomDirectionDeg()
    return jass.GetRandomReal(0, 360)
end
function ____exports.GetSpellAbilityId()
    return jass.GetSpellAbilityId()
end
function ____exports.OrderIdToString(orderId)
    local c1 = orderId % 256
    local c2 = jass.R2I(orderId / 256) % 256
    local c3 = jass.R2I(orderId / 256 / 256) % 256
    local c4 = jass.R2I(orderId / 256 / 256 / 256) % 256
    return string.char(c1, c2, c3, c4)
end
____exports.lastCreatedEffect = nil
function ____exports.AddSpecialEffectTargetUnitBJ(attachPointName, targetWidget, modelName)
    ____exports.lastCreatedEffect = jass.AddSpecialEffectTarget(modelName, targetWidget, attachPointName)
    return ____exports.lastCreatedEffect
end
function ____exports.OperatorDegreeMultiply(a, b)
    return a * b
end
function ____exports.OperatorRealAdd(a, b)
    return a + b
end
function ____exports.OperatorRealMultiply(a, b)
    return a * b
end
--- 字符串转命令ID
-- 对应JASS: String2OrderIdBJ
-- 先尝试OrderId，若为0再尝试UnitId
function ____exports.String2OrderIdBJ(orderIdString)
    local orderId = 0
    orderId = jass.OrderId(orderIdString)
    if orderId ~= 0 then
        return orderId
    end
    orderId = jass.UnitId(orderIdString)
    if orderId ~= 0 then
        return orderId
    end
    return 0
end
return ____exports
