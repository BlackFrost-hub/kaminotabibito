local ____lualib = require("lualib_bundle")
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
local getPlayerFirstHero
local jass = require("jass.common")
local function readFirstNumber(self, s)
    local found = false
    local n = 0
    do
        local i = 0
        while i < #s do
            local c = __TS__StringCharAt(s, i)
            if c >= "0" and c <= "9" then
                found = true
                n = n * 10 + ((string.byte(c, 1) or 0 / 0) - 48)
            elseif found then
                break
            end
            i = i + 1
        end
    end
    return n
end
local function parseItemLevelRank(self, levelRaw)
    if not levelRaw or levelRaw == "" then
        return -999
    end
    local lv = __TS__StringTrim(levelRaw)
    local ____table = {
        ["E-"] = 10,
        E = 11,
        ["E+"] = 12,
        ["E++"] = 13,
        ["E+++"] = 14,
        ["D-"] = 20,
        D = 21,
        ["D+"] = 22,
        ["D++"] = 23,
        ["D+++"] = 24,
        ["C-"] = 30,
        C = 31,
        ["C+"] = 32,
        ["C++"] = 33,
        ["C+++"] = 34,
        ["B-"] = 40,
        B = 41,
        ["B+"] = 42,
        ["B++"] = 43,
        ["B+++"] = 44,
        ["A-"] = 50,
        A = 51,
        ["A+"] = 52,
        ["S-"] = 60,
        S = 61,
        ["S+"] = 62
    }
    return ____table[lv] or -999
end
local function parseEquipBoundToken(self, token)
    local t = __TS__StringTrim(token)
    if t == "" then
        return nil
    end
    local first = string.sub(t, 1, 1)
    local op = "="
    local levelStr = t
    if first == "<" or first == "＞" or first == ">" or first == "＜" or first == "=" then
        op = first == "＜" and "<" or (first == "＞" and ">" or first)
        levelStr = __TS__StringTrim(__TS__StringSubstring(t, 1))
    end
    local rank = parseItemLevelRank(nil, levelStr)
    if rank < 0 then
        return nil
    end
    return {op = op, rank = rank}
end
local function isEquipConditionMatched(self, condition, submittedItemLevel)
    if not submittedItemLevel or submittedItemLevel == "" then
        return false
    end
    local levelRank = parseItemLevelRank(nil, submittedItemLevel)
    if levelRank < 0 then
        return false
    end
    if (string.find(condition, "装备等级", nil, true) or 0) - 1 ~= 0 then
        return false
    end
    local expr = __TS__StringTrim(__TS__StringSubstring(condition, #"装备等级"))
    if expr == "" then
        return false
    end
    local parts = __TS__StringSplit(expr, "&")
    for ____, raw in ipairs(parts) do
        do
            local bound = parseEquipBoundToken(nil, raw)
            if not bound then
                goto __continue18
            end
            if bound.op == "<" and not (levelRank < bound.rank) then
                return false
            end
            if bound.op == ">" and not (levelRank > bound.rank) then
                return false
            end
            if bound.op == "=" and not (levelRank == bound.rank) then
                return false
            end
        end
        ::__continue18::
    end
    return true
end
local function isItemIdConditionMatched(self, condition, submittedItemId)
    if not submittedItemId or #submittedItemId ~= 4 then
        return false
    end
    local tokens = __TS__StringSplit(condition, "|")
    for ____, t in ipairs(tokens) do
        if __TS__StringTrim(t) == submittedItemId then
            return true
        end
    end
    return false
end
local function isHeroLevelConditionMatched(self, text, triggerPlayerId)
    if (string.find(text, "英雄等级＞", nil, true) or 0) - 1 == 0 or (string.find(text, "英雄等级>", nil, true) or 0) - 1 == 0 then
        local limit = readFirstNumber(nil, text)
        local ____temp_0
        if triggerPlayerId ~= nil then
            ____temp_0 = jass:Player(triggerPlayerId)
        else
            ____temp_0 = nil
        end
        local p = ____temp_0
        local ____p_1
        if p then
            ____p_1 = getPlayerFirstHero(nil, p)
        else
            ____p_1 = nil
        end
        local hero = ____p_1
        local lv = hero and jass:GetHeroLevel(hero) or 0
        return lv > limit
    end
    if (string.find(text, "英雄等级≤", nil, true) or 0) - 1 == 0 or (string.find(text, "英雄等级<=", nil, true) or 0) - 1 == 0 then
        local limit = readFirstNumber(nil, text)
        local ____temp_2
        if triggerPlayerId ~= nil then
            ____temp_2 = jass:Player(triggerPlayerId)
        else
            ____temp_2 = nil
        end
        local p = ____temp_2
        local ____p_3
        if p then
            ____p_3 = getPlayerFirstHero(nil, p)
        else
            ____p_3 = nil
        end
        local hero = ____p_3
        local lv = hero and jass:GetHeroLevel(hero) or 0
        return lv <= limit
    end
    return true
end
getPlayerFirstHero = function() return nil end
function ____exports.bindRewardParseHeroResolver(self, fn)
    getPlayerFirstHero = fn
end
function ____exports.isConditionMatchedWithContext(self, condition, ctx)
    local text = __TS__StringTrim(condition)
    if text == "" then
        return true
    end
    if (string.find(text, "装备等级", nil, true) or 0) - 1 == 0 then
        return isEquipConditionMatched(nil, text, ctx.submittedItemLevel)
    end
    if (string.find(text, "|", nil, true) or 0) - 1 >= 0 and (string.find(text, "I", nil, true) or 0) - 1 >= 0 then
        return isItemIdConditionMatched(nil, text, ctx.submittedItemId)
    end
    return isHeroLevelConditionMatched(nil, text, ctx.triggerPlayerId)
end
return ____exports
