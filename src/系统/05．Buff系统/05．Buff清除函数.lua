local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
--- Buff 清除函数
-- 
-- 显眼入口：按 `01．Buff表.ts` 的 type 字段清除单位 Buff。
-- 
-- 常用：
-- - `移除单位增益Buff(unit)`：清除 `type` 含 `Buff` 字段的条目。
-- - `移除单位负面Buff(unit)`：清除 `type` 含 `Debuff` 字段的条目。
-- - `移除单位指定类型Buff(unit, "Debuff:control")`：清除同时含 `Debuff` 和 `control` 字段的条目。
-- 
-- 说明：
-- - D001-D004 是纯 TS DOT，没有原生魔法效果；清除时只停止 DOT 和自定义 BuffUI。
-- - 快速 Buff 如果绑定了原生魔法效果 rawId，底层会同步 UnitRemoveAbility。
local buffPool = require("系统.05．Buff系统.00．Buff系统")
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
local BUFF_TABLE = buffTableMod.buffs
local getBuffIdsOnUnit = buffPool.getBuffIdsOnUnit
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = buffPool["移除单位指定Buff"]
local function parseBuffTypeFields(typeName)
    local fields = {}
    local start = 0
    local lowerType = string.lower(typeName)
    while start <= #lowerType do
        local ____end = (string.find(
            lowerType,
            ":",
            math.max(start + 1, 1),
            true
        ) or 0) - 1
        local field = ____end >= 0 and __TS__StringSubstring(lowerType, start, ____end) or __TS__StringSubstring(lowerType, start)
        if field ~= "" then
            fields[#fields + 1] = field
        end
        if ____end < 0 then
            break
        end
        start = ____end + 1
    end
    return fields
end
local function hasBuffTypeField(typeFields, queryField)
    local lowerField = string.lower(queryField)
    do
        local i = 0
        while i < #typeFields do
            if typeFields[i + 1] == lowerField then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function isBuffTypeQueryMatched(typeName, typeQuery)
    if typeQuery == "" then
        return true
    end
    local queryFields = parseBuffTypeFields(typeQuery)
    if #queryFields == 0 then
        return true
    end
    local typeFields = parseBuffTypeFields(typeName)
    do
        local i = 0
        while i < #queryFields do
            if not hasBuffTypeField(typeFields, queryFields[i + 1]) then
                return false
            end
            i = i + 1
        end
    end
    return true
end
local function isBuffTypeMatched(buffID, typeQuery, onlyPurgable)
    local meta = BUFF_TABLE[buffID]
    if meta == nil then
        return false
    end
    local typeName = meta.type
    if type(typeName) ~= "string" or typeName == "" then
        return false
    end
    if not isBuffTypeQueryMatched(typeName, typeQuery) then
        return false
    end
    if onlyPurgable and meta.canPurge ~= true then
        return false
    end
    return true
end
local function isBuffDispelMatched(buffID, typeQuery, maxDispelLevel, onlyPurgable)
    local meta = BUFF_TABLE[buffID]
    if meta == nil then
        return false
    end
    local typeName = meta.type
    if type(typeName) ~= "string" or typeName == "" then
        return false
    end
    if not isBuffTypeQueryMatched(typeName, typeQuery) then
        return false
    end
    if onlyPurgable and meta.canPurge ~= true then
        return false
    end
    local dispelLevel = meta.dispelLevel
    if type(dispelLevel) ~= "number" then
        return false
    end
    if dispelLevel < 0 then
        return false
    end
    return dispelLevel <= maxDispelLevel
end
--- 按 `01．Buff表.ts` 的 type 字段清除单位 Buff。
-- 
-- - `Buff:`    增益类
-- - `Debuff:` 负面类
-- - `Debuff:control` 控制类负面
-- - `Debuff:magic` 魔法类负面
-- - 查询按 `:` 分隔字段命中，不依赖字段顺序
-- - onlyPurgable=true 时只清 `canPurge: true` 的条目
____exports["移除单位指定类型Buff"] = function(unit, typePrefix, onlyPurgable)
    if onlyPurgable == nil then
        onlyPurgable = false
    end
    if unit == nil or unit == 0 or typePrefix == "" then
        return 0
    end
    local ids = getBuffIdsOnUnit(unit)
    local removed = 0
    do
        local i = 0
        while i < #ids do
            do
                local buffID = ids[i + 1]
                if not isBuffTypeMatched(buffID, typePrefix, onlyPurgable) then
                    goto __continue31
                end
                if _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, buffID) then
                    removed = removed + 1
                end
            end
            ::__continue31::
            i = i + 1
        end
    end
    return removed
end
--- 清除单位增益 Buff（Buff 表 type 含 `Buff` 字段）。
____exports["移除单位增益Buff"] = function(unit, onlyPurgable)
    if onlyPurgable == nil then
        onlyPurgable = false
    end
    return ____exports["移除单位指定类型Buff"](unit, "Buff:", onlyPurgable)
end
--- 清除单位负面 Buff（Buff 表 type 含 `Debuff` 字段）。
____exports["移除单位负面Buff"] = function(unit, onlyPurgable)
    if onlyPurgable == nil then
        onlyPurgable = false
    end
    return ____exports["移除单位指定类型Buff"](unit, "Debuff:", onlyPurgable)
end
--- 按 Buff 表 `dispelLevel` 执行驱散。
-- 
-- - `maxDispelLevel=1`：只驱散 1 级及以下
-- - `maxDispelLevel=2`：驱散 2 级及以下
-- - `typePrefix=""`：不限制类型；也可传 `Buff:` / `Debuff:` / `Debuff:control` / `Debuff:magic`
-- - `typePrefix` 按 `:` 分隔字段命中，不依赖字段顺序
-- - `onlyPurgable=true`：只驱散 `canPurge: true` 的条目
____exports["按驱散等级移除单位Buff"] = function(unit, maxDispelLevel, typePrefix, onlyPurgable)
    if typePrefix == nil then
        typePrefix = ""
    end
    if onlyPurgable == nil then
        onlyPurgable = true
    end
    if unit == nil or unit == 0 then
        return 0
    end
    if type(maxDispelLevel) ~= "number" or maxDispelLevel < 0 then
        return 0
    end
    local ids = getBuffIdsOnUnit(unit)
    local removed = 0
    do
        local i = 0
        while i < #ids do
            do
                local buffID = ids[i + 1]
                if not isBuffDispelMatched(buffID, typePrefix, maxDispelLevel, onlyPurgable) then
                    goto __continue40
                end
                if _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, buffID) then
                    removed = removed + 1
                end
            end
            ::__continue40::
            i = i + 1
        end
    end
    return removed
end
--- 1 级驱散：常规净化/驱散。默认只驱散 `canPurge: true`。
____exports["一级驱散单位Buff"] = function(unit, typePrefix, onlyPurgable)
    if typePrefix == nil then
        typePrefix = ""
    end
    if onlyPurgable == nil then
        onlyPurgable = true
    end
    return ____exports["按驱散等级移除单位Buff"](unit, 1, typePrefix, onlyPurgable)
end
--- 2 级驱散：强驱散。默认只驱散 `canPurge: true`。
____exports["二级驱散单位Buff"] = function(unit, typePrefix, onlyPurgable)
    if typePrefix == nil then
        typePrefix = ""
    end
    if onlyPurgable == nil then
        onlyPurgable = true
    end
    return ____exports["按驱散等级移除单位Buff"](unit, 2, typePrefix, onlyPurgable)
end
return ____exports
