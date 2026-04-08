local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local ____exports = {}
local jass
function ____exports.getPlayerFirstHero(self, player)
    local g = jass.CreateGroup()
    jass.GroupEnumUnitsOfPlayer(g, player, nil)
    local hero = nil
    local firstUnit = jass.FirstOfGroup(g)
    while firstUnit do
        if jass.IsUnitType(firstUnit, jass.UNIT_TYPE_HERO) then
            hero = firstUnit
            break
        end
        jass.GroupRemoveUnit(g, firstUnit)
        firstUnit = jass.FirstOfGroup(g)
    end
    jass.DestroyGroup(g)
    return hero
end
jass = require("jass.common")
local function createPlayerGroup(self)
    local players = {}
    do
        local i = 0
        while i < 4 do
            local p = jass.Player(i)
            if jass.GetPlayerController(p) == jass.MAP_CONTROL_USER then
                players[#players + 1] = p
            end
            i = i + 1
        end
    end
    return {players = players}
end
local function destroyPlayerGroup(self, pg)
    pg.players = {}
end
function ____exports.giveRewardToPlayers(self, reward, triggerPlayerId)
    if not reward then
        return
    end
    local pg = createPlayerGroup(nil)
    local parts = __TS__StringSplit(reward, ";")
    for ____, part in ipairs(parts) do
        do
            local __continue9
            repeat
                local trimmed = __TS__StringTrim(part)
                if #trimmed == 0 then
                    __continue9 = true
                    break
                end
                local hasExplicitTarget = (string.find(trimmed, "所有玩家", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "完成任务的玩家", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "all", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "Player", nil, true) or 0) - 1 ~= -1
                local isAll = (string.find(trimmed, "所有玩家", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "all", nil, true) or 0) - 1 ~= -1 or not hasExplicitTarget
                local isPlayer = (string.find(trimmed, "完成任务的玩家", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "Player", nil, true) or 0) - 1 ~= -1
                if not isAll and not isPlayer then
                    __continue9 = true
                    break
                end
                local targetPlayers = isPlayer and (triggerPlayerId ~= nil and triggerPlayerId >= 0 and ({jass.Player(triggerPlayerId)}) or ({})) or pg.players
                local value = 0
                do
                    local i = 0
                    while i < #trimmed do
                        local c = __TS__StringCharAt(trimmed, i)
                        if c >= "0" and c <= "9" then
                            value = value * 10 + ((string.byte(c, 1) or 0 / 0) - 48)
                        elseif value > 0 then
                            break
                        end
                        i = i + 1
                    end
                end
                if value == 0 then
                    __continue9 = true
                    break
                end
                local targetHeroes = {}
                for ____, p in ipairs(targetPlayers) do
                    local h = ____exports.getPlayerFirstHero(nil, p)
                    if h then
                        targetHeroes[#targetHeroes + 1] = h
                    end
                end
                if (string.find(trimmed, "经验", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "exp", nil, true) or 0) - 1 ~= -1 then
                    for ____, hero in ipairs(targetHeroes) do
                        if type(jass.AddHeroXP) == "function" then
                            jass.AddHeroXP(hero, value, true)
                        end
                    end
                elseif (string.find(trimmed, "金币", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "gold", nil, true) or 0) - 1 ~= -1 then
                    for ____, p in ipairs(targetPlayers) do
                        local currentGold = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD) or 0
                        jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD, currentGold + value)
                    end
                elseif (string.find(trimmed, "木材", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "能量碎片", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "wood", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "lumber", nil, true) or 0) - 1 ~= -1 then
                    for ____, p in ipairs(targetPlayers) do
                        local currentWood = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER) or 0
                        jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER, currentWood + value)
                    end
                elseif (string.find(trimmed, "智力", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "Int", nil, true) or 0) - 1 ~= -1 then
                    for ____, hero in ipairs(targetHeroes) do
                        if type(jass.SetHeroInt) == "function" then
                            local currentInt = jass.GetHeroInt(hero, false)
                            jass.SetHeroInt(hero, currentInt + value, true)
                        end
                    end
                elseif (string.find(trimmed, "敏捷", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "Agi", nil, true) or 0) - 1 ~= -1 then
                    for ____, hero in ipairs(targetHeroes) do
                        if type(jass.SetHeroAgi) == "function" then
                            local currentAgi = jass.GetHeroAgi(hero, false)
                            jass.SetHeroAgi(hero, currentAgi + value, true)
                        end
                    end
                elseif (string.find(trimmed, "力量", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "Str", nil, true) or 0) - 1 ~= -1 then
                    for ____, hero in ipairs(targetHeroes) do
                        if type(jass.SetHeroStr) == "function" then
                            local currentStr = jass.GetHeroStr(hero, false)
                            jass.SetHeroStr(hero, currentStr + value, true)
                        end
                    end
                elseif (string.find(trimmed, "等级", nil, true) or 0) - 1 ~= -1 or (string.find(trimmed, "level", nil, true) or 0) - 1 ~= -1 then
                    for ____, hero in ipairs(targetHeroes) do
                        if type(jass.SetHeroLevel) == "function" then
                            local currentLevel = jass.GetHeroLevel(hero)
                            jass.SetHeroLevel(hero, currentLevel + value, false)
                        end
                    end
                end
                __continue9 = true
            until true
            if not __continue9 then
                break
            end
        end
    end
    destroyPlayerGroup(nil, pg)
end
return ____exports
