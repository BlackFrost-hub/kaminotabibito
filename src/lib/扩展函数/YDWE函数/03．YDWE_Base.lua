--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
function ____exports.OperatorDegreeAdd(self, a, b)
    return a + b
end
function ____exports.OperatorDegreeSubtract(self, a, b)
    return a - b
end
function ____exports.OperatorDegreeMultiply(self, a, b)
    return a * b
end
function ____exports.OperatorDegreeDivide(self, a, b)
    return a / b
end
function ____exports.OperatorRadianAdd(self, a, b)
    return a + b
end
function ____exports.OperatorRadianSubtract(self, a, b)
    return a - b
end
function ____exports.OperatorRadianMultiply(self, a, b)
    return a * b
end
function ____exports.OperatorRadianDivide(self, a, b)
    return a / b
end
function ____exports.OperatorIntegerAdd(self, a, b)
    return a + b
end
function ____exports.OperatorIntegerSubtract(self, a, b)
    return a - b
end
function ____exports.OperatorIntegerMultiply(self, a, b)
    return a * b
end
function ____exports.OperatorIntegerDivide(self, a, b)
    return math.floor(a / b)
end
function ____exports.OperatorRealAdd(self, a, b)
    return a + b
end
function ____exports.OperatorRealSubtract(self, a, b)
    return a - b
end
function ____exports.OperatorRealMultiply(self, a, b)
    return a * b
end
function ____exports.OperatorRealDivide(self, a, b)
    return a / b
end
local function applyOp(self, a, op, b)
    if op == "+" then
        return a + b
    end
    if op == "-" then
        return a - b
    end
    if op == "*" then
        return a * b
    end
    if op == "/" then
        return a / b
    end
    return a
end
function ____exports.YDWEOperatorInt3(self, a1, op1, a2, op2, a3)
    if op2 == "*" or op2 == "/" then
        return math.floor(applyOp(
            nil,
            a1,
            op1,
            applyOp(nil, a2, op2, a3)
        ))
    end
    return math.floor(applyOp(
        nil,
        applyOp(nil, a1, op1, a2),
        op2,
        a3
    ))
end
function ____exports.YDWEOperatorReal3(self, a1, op1, a2, op2, a3)
    if op2 == "*" or op2 == "/" then
        return applyOp(
            nil,
            a1,
            op1,
            applyOp(nil, a2, op2, a3)
        )
    end
    return applyOp(
        nil,
        applyOp(nil, a1, op1, a2),
        op2,
        a3
    )
end
function ____exports.YDWEOperatorString3(self, a1, a2, a3)
    return (a1 .. a2) .. a3
end
function ____exports.YDWER2Rad(self, a)
    return a
end
function ____exports.YDWER2Deg(self, a)
    return a
end
function ____exports.YDWEDeg2R(self, a)
    return a
end
function ____exports.YDWERad2R(self, a)
    return a
end
function ____exports.YDWEInitHashtable(self)
    return jass.InitHashtable()
end
function ____exports.YDWEIsTriggerEventId(self, eventid)
    return eventid == jass.GetTriggerEventId()
end
function ____exports.YDWEH2I(self, handle)
    return jass.GetHandleId(handle)
end
function ____exports.YDWEGetUnitID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetItemID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetPlayerID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetTimerID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetTriggerID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetGroupID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetLocationID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetMultiboardID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetMultiboardItemID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetTextTagID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetLightningID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetRegionID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetRectID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetLeaderboardID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetEffectID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetDestructableID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetTriggerConditionID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetTriggerActionID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetTriggerEventID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetForceID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetBoolexprID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetSoundID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetTimerDialogID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetTrackableID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetDialogID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEGetButtonID(self, a)
    return ____exports.YDWEH2I(nil, a)
end
function ____exports.YDWEConvert(self, a)
    return a
end
function ____exports.YDWEGetUnitTypeID(self, a)
    return a
end
function ____exports.YDWEGetAbilityTypeID(self, a)
    return a
end
function ____exports.YDWEGetItemTypeID(self, a)
    return a
end
function ____exports.YDWEConverUnitcodeToInt(self, a)
    return a
end
function ____exports.YDWEConverItemcodeToInt(self, a)
    return a
end
function ____exports.YDWEConverAbilcodeToInt(self, a)
    return a
end
function ____exports.YDWEConverOrdercodeToInt(self, a)
    return a
end
function ____exports.YDWEUOrderId2OrderId(self, a)
    return a
end
function ____exports.YDWEPOrderId2OrderId(self, a)
    return a
end
function ____exports.YDWEDOrderId2OrderId(self, a)
    return a
end
function ____exports.YDWEIOrderId2OrderId(self, a)
    return a
end
function ____exports.YDWENOrderId2OrderId(self, a)
    return a
end
function ____exports.YDWEI2UnitId(self, a)
    return a
end
function ____exports.YDWEI2ItemId(self, a)
    return a
end
return ____exports
