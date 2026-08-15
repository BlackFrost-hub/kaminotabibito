--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- YDUserData 安全封装
-- 
-- 用途：
-- - 专门给 `@noSelfInFile` 文件使用
-- - 避免直接调用 `YDWE` 相关导出时，因为 TSTL / Lua 的 self 形态导致参数错位
-- 
-- 规则：
-- - 在普通文件里，仍可直接用原版导出
-- - 在 `@noSelfInFile` 文件里，优先用这里的安全版
-- 
-- AI 使用指引：
-- - 只要你在 `@noSelfInFile` 文件里需要调 `00．YDWE函数` / `01．YDUserData兼容`
--   里的导出，优先先来本文件找是否已有安全版。
-- - 尤其优先使用这里的安全版来替代：
--   - `YDUserDataGet / YDUserDataSet`
--   - `getObjectProperty / getObjectPropertyReal`
--   - `YDWEGetUnitAbilityDataString / Integer / Real`
--   - `YDWESetUnitAbilityState / YDWESetUnitAbilityDataReal`
-- - 如果这里还没有对应安全包装，再新增到本文件，不要在业务文件里到处手写 `unsafe(undefined, ...)`。
local ydweCompat = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local ydweBase = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDUserDataGetUnsafe = ydweCompat.YDUserDataGet
local YDUserDataSetUnsafe = ydweCompat.YDUserDataSet
local YDUserDataClearUnsafe = ydweCompat.YDUserDataClear
local YDUserDataHasUnsafe = ydweCompat.YDUserDataHas
local YDUserDataClearTableUnsafe = ydweCompat.YDUserDataClearTable
local getObjectPropertyUnsafe = ydweBase.getObjectProperty
local getObjectPropertyRealUnsafe = ydweBase.getObjectPropertyReal
local getObjectPropertyIntegerUnsafe = ydweBase.getObjectPropertyInteger
local YDWEGetUnitAbilityDataStringUnsafe = ydweBase.YDWEGetUnitAbilityDataString
local YDWEGetUnitAbilityDataIntegerUnsafe = ydweBase.YDWEGetUnitAbilityDataInteger
local YDWEGetUnitAbilityDataRealUnsafe = ydweBase.YDWEGetUnitAbilityDataReal
local YDWESetUnitAbilityStateUnsafe = ydweBase.YDWESetUnitAbilityState
local YDWEGetUnitAbilityStateUnsafe = ydweBase.YDWEGetUnitAbilityState
local YDWESetUnitAbilityDataRealUnsafe = ydweBase.YDWESetUnitAbilityDataReal
local YDWETimerDestroyEffectUnsafe = ydweBase.YDWETimerDestroyEffect
local YDWEAngleBetweenUnitsUnsafe = ydweBase.YDWEAngleBetweenUnits
local YDWEDistanceBetweenUnitsUnsafe = ydweBase.YDWEDistanceBetweenUnits
function ____exports.YDUserDataGetSafe(tableType, tableKey, attr, valueType)
    return YDUserDataGetUnsafe(
        nil,
        tableType,
        tableKey,
        attr,
        valueType
    )
end
function ____exports.YDUserDataSetSafe(tableType, tableKey, attr, valueType, value)
    YDUserDataSetUnsafe(
        nil,
        tableType,
        tableKey,
        attr,
        valueType,
        value
    )
end
function ____exports.YDUserDataClearSafe(tableType, tableKey, attr, valueType)
    YDUserDataClearUnsafe(
        nil,
        tableType,
        tableKey,
        attr,
        valueType
    )
end
function ____exports.YDUserDataHasSafe(tableType, tableKey, attr, valueType)
    return YDUserDataHasUnsafe(
        nil,
        tableType,
        tableKey,
        attr,
        valueType
    ) == true
end
function ____exports.YDUserDataClearTableSafe(tableTypeName, tableKey)
    YDUserDataClearTableUnsafe(nil, tableTypeName, tableKey)
end
function ____exports.getObjectPropertySafe(objectType, objectId, property)
    return getObjectPropertyUnsafe(nil, objectType, objectId, property)
end
function ____exports.getObjectPropertyRealSafe(objectType, objectId, property)
    return getObjectPropertyRealUnsafe(nil, objectType, objectId, property)
end
function ____exports.getObjectPropertyIntegerSafe(objectType, objectId, property)
    return getObjectPropertyIntegerUnsafe(nil, objectType, objectId, property)
end
function ____exports.YDWEGetUnitAbilityDataStringSafe(unit, abilityId, level, dataType)
    return YDWEGetUnitAbilityDataStringUnsafe(
        nil,
        unit,
        abilityId,
        level,
        dataType
    )
end
function ____exports.YDWEGetUnitAbilityDataIntegerSafe(unit, abilityId, level, dataType)
    return YDWEGetUnitAbilityDataIntegerUnsafe(
        nil,
        unit,
        abilityId,
        level,
        dataType
    )
end
function ____exports.YDWEGetUnitAbilityDataRealSafe(unit, abilityId, level, dataType)
    return YDWEGetUnitAbilityDataRealUnsafe(
        nil,
        unit,
        abilityId,
        level,
        dataType
    )
end
function ____exports.YDWESetUnitAbilityStateSafe(unit, abilityId, stateType, value)
    return YDWESetUnitAbilityStateUnsafe(
        nil,
        unit,
        abilityId,
        stateType,
        value
    )
end
function ____exports.YDWEGetUnitAbilityStateSafe(unit, abilityId, stateType)
    return YDWEGetUnitAbilityStateUnsafe(nil, unit, abilityId, stateType)
end
function ____exports.YDWESetUnitAbilityDataRealSafe(unit, abilityId, level, dataType, value)
    return YDWESetUnitAbilityDataRealUnsafe(
        nil,
        unit,
        abilityId,
        level,
        dataType,
        value
    )
end
function ____exports.YDWETimerDestroyEffectSafe(duration, effect)
    YDWETimerDestroyEffectUnsafe(nil, duration, effect)
end
function ____exports.YDWEAngleBetweenUnitsSafe(fromUnit, toUnit)
    return YDWEAngleBetweenUnitsUnsafe(nil, fromUnit, toUnit)
end
function ____exports.YDWEDistanceBetweenUnitsSafe(a, b)
    return YDWEDistanceBetweenUnitsUnsafe(nil, a, b)
end
____exports["安全YDUserDataGet"] = ____exports.YDUserDataGetSafe
____exports["安全YDUserDataSet"] = ____exports.YDUserDataSetSafe
____exports["安全YDUserDataClear"] = ____exports.YDUserDataClearSafe
____exports["安全YDUserDataHas"] = ____exports.YDUserDataHasSafe
____exports["安全YDUserDataClearTable"] = ____exports.YDUserDataClearTableSafe
____exports["安全读取对象属性"] = ____exports.getObjectPropertySafe
____exports["安全读取对象实数属性"] = ____exports.getObjectPropertyRealSafe
____exports["安全读取对象整数属性"] = ____exports.getObjectPropertyIntegerSafe
____exports["安全读取单位技能字符串"] = ____exports.YDWEGetUnitAbilityDataStringSafe
____exports["安全读取单位技能整数"] = ____exports.YDWEGetUnitAbilityDataIntegerSafe
____exports["安全读取单位技能实数"] = ____exports.YDWEGetUnitAbilityDataRealSafe
____exports["安全设置单位技能状态"] = ____exports.YDWESetUnitAbilityStateSafe
____exports["安全设置单位技能实数数据"] = ____exports.YDWESetUnitAbilityDataRealSafe
____exports["安全延时销毁特效"] = ____exports.YDWETimerDestroyEffectSafe
____exports["安全取两单位角度"] = ____exports.YDWEAngleBetweenUnitsSafe
____exports["安全取两单位距离"] = ____exports.YDWEDistanceBetweenUnitsSafe
return ____exports
