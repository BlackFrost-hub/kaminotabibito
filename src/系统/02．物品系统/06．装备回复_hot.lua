local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local ____exports = {}
--- 装备 hot/abilList 解析与单段治疗量计算（供 `06．装备回复` 与 STES 推算共用）
local jass = require("jass.common")
function ____exports.parseEquipHealSegments(self, hotStr, abilList)
    local segments = __TS__StringSplit(hotStr, "+")
    local abilIds = __TS__ArrayMap(
        __TS__StringSplit(abilList, ","),
        function(____, x) return __TS__StringTrim(x) end
    )
    local result = {}
    do
        local i = 0
        while i < #segments do
            do
                local seg = __TS__StringTrim(segments[i + 1])
                if seg == "" then
                    goto __continue5
                end
                local tokens = __TS__ArrayFilter(
                    __TS__ArrayMap(
                        __TS__StringSplit(seg, ";"),
                        function(____, x) return __TS__StringTrim(x) end
                    ),
                    function(____, x) return x ~= "" end
                )
                local waitSec = 0
                for ____, t in ipairs(tokens) do
                    local waitIdx = (string.find(t, ":wait", nil, true) or 0) - 1
                    if waitIdx >= 0 then
                        local w = __TS__ParseFloat(__TS__StringSubstring(t, waitIdx + 5)) or 0
                        if w > waitSec then
                            waitSec = w
                        end
                    end
                end
                result[#result + 1] = {tokens = tokens, abilId = abilIds[i + 1] or "", waitSec = waitSec}
            end
            ::__continue5::
            i = i + 1
        end
    end
    return result
end
function ____exports.calcEquipHealHpMp(self, tokens, unit)
    local hp = 0
    local mp = 0
    local maxHp = jass:GetUnitState(
        unit,
        jass:ConvertUnitState(1)
    )
    local curHp = jass:GetWidgetLife(unit)
    local maxMp = jass:GetUnitState(
        unit,
        jass:ConvertUnitState(3)
    )
    local lostHp = maxHp - curHp
    for ____, rawToken in ipairs(tokens) do
        local waitIdx = (string.find(rawToken, ":wait", nil, true) or 0) - 1
        local t = __TS__StringTrim(waitIdx >= 0 and __TS__StringSubstring(rawToken, 0, waitIdx) or rawToken)
        local tl = string.lower(t)
        if __TS__StringEndsWith(tl, "hplost") then
            local prefix = __TS__StringSubstring(t, 0, #t - 6)
            if __TS__StringEndsWith(prefix, "%") then
                local pct = __TS__ParseFloat(__TS__StringSubstring(prefix, 0, #prefix - 1)) / 100
                hp = hp + lostHp * pct
            else
                hp = hp + (__TS__ParseFloat(prefix) or 0)
            end
        elseif __TS__StringEndsWith(tl, "hp") then
            local prefix = __TS__StringSubstring(t, 0, #t - 2)
            if __TS__StringEndsWith(prefix, "%") then
                local pct = __TS__ParseFloat(__TS__StringSubstring(prefix, 0, #prefix - 1)) / 100
                hp = hp + maxHp * pct
            else
                hp = hp + (__TS__ParseFloat(prefix) or 0)
            end
        elseif __TS__StringEndsWith(tl, "mp") then
            local prefix = __TS__StringSubstring(t, 0, #t - 2)
            if __TS__StringEndsWith(prefix, "%") then
                local pct = __TS__ParseFloat(__TS__StringSubstring(prefix, 0, #prefix - 1)) / 100
                mp = mp + maxMp * pct
            else
                mp = mp + (__TS__ParseFloat(prefix) or 0)
            end
        end
    end
    return {hp = hp, mp = mp}
end
--- 按装备表汇总各段治疗量（不拆 :wait 延时；仅统计 abilId 非空的段）
function ____exports.sumHealFromItemData(self, unit, item, itemsData, fourCCToString)
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return {hp = 0, mp = 0, ok = false}
    end
    local itemId = jass:GetItemTypeId(item)
    local idStr = fourCCToString(nil, itemId)
    local entry = itemsData[idStr]
    if not entry or not entry.hot or not entry.abilList then
        return {hp = 0, mp = 0, ok = false}
    end
    local segments = ____exports.parseEquipHealSegments(nil, entry.hot, entry.abilList)
    local hp = 0
    local mp = 0
    do
        local i = 0
        while i < #segments do
            do
                local seg = segments[i + 1]
                if seg.abilId == "" then
                    goto __continue29
                end
                local c = ____exports.calcEquipHealHpMp(nil, seg.tokens, unit)
                hp = hp + c.hp
                mp = mp + c.mp
            end
            ::__continue29::
            i = i + 1
        end
    end
    return {hp = hp, mp = mp, ok = hp > 0 or mp > 0}
end
return ____exports
