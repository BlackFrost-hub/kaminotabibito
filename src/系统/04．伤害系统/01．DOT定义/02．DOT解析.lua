local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseInt = ____lualib.__TS__ParseInt
local ____exports = {}
--- 装备 `Buff` 可多段，用 `+` 连接，例如：`Buff:dmg:...;timeN+Buff:dmg:...;timeN`
function ____exports.splitItemBuffSegments(buff)
    if not buff or type(buff) ~= "string" then
        return {}
    end
    local parts = __TS__StringSplit(buff, "+")
    local out = {}
    do
        local i = 0
        while i < #parts do
            local t = __TS__StringTrim(parts[i + 1])
            if t ~= "" then
                out[#out + 1] = t
            end
            i = i + 1
        end
    end
    return out
end
--- 从字符串中读取从 startIdx 开始的连续数字
function ____exports.readNumberFromString(s, startIdx)
    local numEnd = startIdx
    while numEnd < #s do
        local c = __TS__StringCharAt(s, numEnd)
        if c >= "0" and c <= "9" then
            numEnd = numEnd + 1
        else
            break
        end
    end
    return numEnd > startIdx and (__TS__ParseInt(
        __TS__StringSubstring(s, startIdx, numEnd),
        10
    ) or 0) or 0
end
--- 通用的标准 DOT Buff 解析（适用于 AntiHeal、Burn、Poison）
function ____exports.parseStandardDotBuff(buffStr, keyword, createResult, requireValuePositive)
    if requireValuePositive == nil then
        requireValuePositive = true
    end
    if not buffStr or type(buffStr) ~= "string" then
        return nil
    end
    local s = __TS__StringTrim(buffStr)
    local attackOnly = false
    if (string.find(s, "Buff:attack:", nil, true) or 0) - 1 == 0 then
        attackOnly = true
    elseif (string.find(s, "Buff:dmg:", nil, true) or 0) - 1 ~= 0 then
        return nil
    end
    local rest = __TS__StringSubstring(s, attackOnly and 12 or 9)
    local keywordIdx = (string.find(rest, keyword, nil, true) or 0) - 1
    if keywordIdx < 0 then
        return nil
    end
    local valueStartIdx = keywordIdx + #keyword
    local value = ____exports.readNumberFromString(rest, valueStartIdx)
    local timeIdx = (string.find(rest, "time", nil, true) or 0) - 1
    if timeIdx < 0 then
        return nil
    end
    local duration = ____exports.readNumberFromString(rest, timeIdx + 4)
    if duration <= 0 then
        return nil
    end
    if requireValuePositive and value <= 0 then
        return nil
    end
    return createResult(value, duration, attackOnly)
end
return ____exports
