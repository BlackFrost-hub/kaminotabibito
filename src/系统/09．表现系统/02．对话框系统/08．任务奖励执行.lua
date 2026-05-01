local ____lualib = require("lualib_bundle")
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
local ____index = require("lib.扩展函数.BJ函数.index")
local IMaxBJ = ____index.IMaxBJ
local ____index = require("lib.扩展函数.自定义扩展函数.index")
local getPlayerFirstHero = ____index.getPlayerFirstHero
local ____06_FF0E_4EFB_52A1_5956_52B1_89E3_6790 = require("系统.09．表现系统.02．对话框系统.06．任务奖励解析")
local bindRewardParseHeroResolver = ____06_FF0E_4EFB_52A1_5956_52B1_89E3_6790.bindRewardParseHeroResolver
local isConditionMatchedWithContext = ____06_FF0E_4EFB_52A1_5956_52B1_89E3_6790.isConditionMatchedWithContext
local jass = require("jass.common")
local function getUserPlayers(self)
    local out = {}
    do
        local i = 0
        while i < 4 do
            local p = jass.Player(i)
            if p and jass.GetPlayerController(p) == jass.MAP_CONTROL_USER then
                out[#out + 1] = p
            end
            i = i + 1
        end
    end
    return out
end
bindRewardParseHeroResolver(nil, getPlayerFirstHero)
local function gainGold(self, players, value)
    for ____, p in ipairs(players) do
        local cur = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD) or 0
        jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD, cur + value)
    end
end
local function gainLumber(self, players, value)
    for ____, p in ipairs(players) do
        local cur = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER) or 0
        jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER, cur + value)
    end
end
local function gainExp(self, players, value)
    for ____, p in ipairs(players) do
        local hero = getPlayerFirstHero(nil, p)
        if hero then
            jass.AddHeroXP(hero, value, true)
        end
    end
end
local function gainLevel(self, players, value)
    for ____, p in ipairs(players) do
        local hero = getPlayerFirstHero(nil, p)
        if hero then
            local lv = jass.GetHeroLevel(hero)
            jass.SetHeroLevel(hero, lv + value, false)
        end
    end
end
local function gainHeroStat(self, players, statName, value)
    for ____, p in ipairs(players) do
        do
            local hero = getPlayerFirstHero(nil, p)
            if not hero then
                goto __continue21
            end
            if statName == "力量" then
                jass.SetHeroStr(
                    hero,
                    jass.GetHeroStr(hero, false) + value,
                    true
                )
            elseif statName == "敏捷" then
                jass.SetHeroAgi(
                    hero,
                    jass.GetHeroAgi(hero, false) + value,
                    true
                )
            elseif statName == "智力" then
                jass.SetHeroInt(
                    hero,
                    jass.GetHeroInt(hero, false) + value,
                    true
                )
            end
        end
        ::__continue21::
    end
end
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
local function resolveAmountExpr(self, expr, triggerPlayerId)
    local text = __TS__StringTrim(expr)
    if (string.find(text, "IMaxBJ(", nil, true) or 0) - 1 == 0 then
        local ____temp_0
        if triggerPlayerId ~= nil then
            ____temp_0 = jass.Player(triggerPlayerId)
        else
            ____temp_0 = nil
        end
        local player = ____temp_0
        local ____player_1
        if player then
            ____player_1 = getPlayerFirstHero(nil, player)
        else
            ____player_1 = nil
        end
        local hero = ____player_1
        local level = hero and jass.GetHeroLevel(hero) or 1
        local a = 20000 - (level - 20) * 1000
        return IMaxBJ(nil, a, 10000)
    end
    return readFirstNumber(nil, text)
end
local function executeOneRewardExpr(self, expr, triggerPlayerId)
    local text = __TS__StringTrim(expr)
    if text == "" or text == "null" then
        return
    end
    local allPlayers = getUserPlayers(nil)
    local targetPlayers = ((string.find(text, "完成任务的玩家", nil, true) or 0) - 1 >= 0 or (string.find(text, "Player", nil, true) or 0) - 1 >= 0) and (triggerPlayerId ~= nil and ({jass.Player(triggerPlayerId)}) or ({})) or allPlayers
    local payload = text
    local prefixes = {"所有玩家", "完成任务的玩家", "Player"}
    for ____, p in ipairs(prefixes) do
        if (string.find(payload, p, nil, true) or 0) - 1 == 0 then
            payload = __TS__StringTrim(__TS__StringSubstring(payload, #p))
            while string.sub(payload, 1, 1) == "+" or string.sub(payload, 1, 1) == "＋" do
                payload = __TS__StringTrim(__TS__StringSubstring(payload, 1))
            end
            break
        end
    end
    if (string.find(payload, "经验", nil, true) or 0) - 1 >= 0 or (string.find(payload, "exp", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(nil, payload, triggerPlayerId)
        if value > 0 then
            gainExp(nil, targetPlayers, value)
        end
        return
    end
    if (string.find(payload, "金币", nil, true) or 0) - 1 >= 0 or (string.find(payload, "gold", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(nil, payload, triggerPlayerId)
        if value > 0 then
            gainGold(nil, targetPlayers, value)
        end
        return
    end
    if (string.find(payload, "能量碎片", nil, true) or 0) - 1 >= 0 or (string.find(payload, "木头", nil, true) or 0) - 1 >= 0 or (string.find(payload, "木材", nil, true) or 0) - 1 >= 0 or (string.find(payload, "wood", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(nil, payload, triggerPlayerId)
        if value > 0 then
            gainLumber(nil, targetPlayers, value)
        end
        return
    end
    if (string.find(payload, "等级", nil, true) or 0) - 1 >= 0 or (string.find(payload, "level", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(nil, payload, triggerPlayerId)
        if value > 0 then
            gainLevel(nil, targetPlayers, value)
        end
        return
    end
    if (string.find(payload, "力量", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(nil, payload, triggerPlayerId)
        if value > 0 then
            gainHeroStat(nil, targetPlayers, "力量", value)
        end
        return
    end
    if (string.find(payload, "敏捷", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(nil, payload, triggerPlayerId)
        if value > 0 then
            gainHeroStat(nil, targetPlayers, "敏捷", value)
        end
        return
    end
    if (string.find(payload, "智力", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(nil, payload, triggerPlayerId)
        if value > 0 then
            gainHeroStat(nil, targetPlayers, "智力", value)
        end
    end
end
function ____exports.applyRewardWithContext(self, rewardRaw, ctx)
    if not rewardRaw or rewardRaw == "" then
        return {matchedRuleIndex = -1, matchedCondition = ""}
    end
    local matchedRuleIndex = -1
    local matchedCondition = ""
    local lines = __TS__StringSplit(rewardRaw, "\n")
    do
        local lineIdx = 0
        while lineIdx < #lines do
            do
                local line = __TS__StringTrim(lines[lineIdx + 1])
                if line == "" then
                    goto __continue57
                end
                local colon = (string.find(line, ":", nil, true) or 0) - 1
                if colon > 0 then
                    local cond = __TS__StringTrim(__TS__StringSubstring(line, 0, colon))
                    local expr = __TS__StringTrim(__TS__StringSubstring(line, colon + 1))
                    if not isConditionMatchedWithContext(nil, cond, ctx) then
                        goto __continue57
                    end
                    local parts = __TS__StringSplit(expr, ";")
                    for ____, p in ipairs(parts) do
                        executeOneRewardExpr(nil, p, ctx.triggerPlayerId)
                    end
                    matchedRuleIndex = lineIdx
                    matchedCondition = cond
                    break
                end
                local parts = __TS__StringSplit(line, ";")
                for ____, p in ipairs(parts) do
                    executeOneRewardExpr(nil, p, ctx.triggerPlayerId)
                end
            end
            ::__continue57::
            lineIdx = lineIdx + 1
        end
    end
    return {matchedRuleIndex = matchedRuleIndex, matchedCondition = matchedCondition}
end
function ____exports.previewRewardMatchWithContext(self, rewardRaw, ctx)
    if not rewardRaw or rewardRaw == "" then
        return {matchedRuleIndex = -1, matchedCondition = ""}
    end
    local lines = __TS__StringSplit(rewardRaw, "\n")
    do
        local lineIdx = 0
        while lineIdx < #lines do
            do
                local line = __TS__StringTrim(lines[lineIdx + 1])
                if line == "" then
                    goto __continue68
                end
                local colon = (string.find(line, ":", nil, true) or 0) - 1
                if colon <= 0 then
                    goto __continue68
                end
                local cond = __TS__StringTrim(__TS__StringSubstring(line, 0, colon))
                if isConditionMatchedWithContext(nil, cond, ctx) then
                    return {matchedRuleIndex = lineIdx, matchedCondition = cond}
                end
            end
            ::__continue68::
            lineIdx = lineIdx + 1
        end
    end
    return {matchedRuleIndex = -1, matchedCondition = ""}
end
function ____exports.giveRewardToPlayers(self, rewardRaw, triggerPlayerId)
    ____exports.applyRewardWithContext(nil, rewardRaw, {triggerPlayerId = triggerPlayerId})
end
____exports.getPlayerFirstHero = getPlayerFirstHero
return ____exports
