local ____lualib = require("lualib_bundle")
local __TS__StringCharCodeAt = ____lualib.__TS__StringCharCodeAt
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local itemsData = require("系统.装备.装备数据").default or ({})
local _seed = 0
local DEBUG_DROP = true
local PREFIX = "|cffffff00『系统提示』：|r"
local DEBUG_COLOR = "|cff87ceeb"
local function ____debug(____, msg)
    if not DEBUG_DROP then
        return
    end
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0.02,
        10,
        ((PREFIX .. DEBUG_COLOR) .. msg) .. "|r"
    )
end;
(function()
    local key = "__equip_drop_seeded"
    if _G[key] then
        return
    end
    _G[key] = true
    local s = tostring({})
    local h = 0
    do
        local i = 0
        while i < #s do
            h = (h * 33 + __TS__StringCharCodeAt(s, i)) % 2147483647
            i = i + 1
        end
    end
    if h <= 0 then
        h = 12345
    end
    _seed = h
    math.randomseed(_seed)
    ____debug(
        nil,
        "装备掉落：seed=" .. tostring(_seed)
    )
end)(nil)
local function stringToFourCC(self, s)
    local b1 = string.byte(s, 1)
    local b2 = string.byte(s, 2)
    local b3 = string.byte(s, 3)
    local b4 = string.byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
local function getItemsByScoreRange(self, minScore, maxScore)
    local result = {}
    for id in pairs(itemsData) do
        do
            local __continue11
            repeat
                if type(id) ~= "string" or #id ~= 4 then
                    __continue11 = true
                    break
                end
                local entry = itemsData[id]
                local score = entry and entry.score
                if type(score) ~= "number" then
                    __continue11 = true
                    break
                end
                if score >= minScore and score <= maxScore then
                    result[#result + 1] = id
                end
                __continue11 = true
            until true
            if not __continue11 then
                break
            end
        end
    end
    return result
end
local function pickOneItem(self, minScore, maxScore)
    local list = getItemsByScoreRange(nil, minScore, maxScore)
    if DEBUG_DROP then
        ____debug(
            nil,
            ((((("候选数量：" .. tostring(#list)) .. "（") .. tostring(minScore)) .. "-") .. tostring(maxScore)) .. "）"
        )
    end
    if #list == 0 then
        return nil
    end
    local idx = math.random(1, #list)
    return list[idx]
end
local DROP_RULES = {{unitId = "hfoo", minScore = 150, maxScore = 250, proc = 1}}
local function onUnitDeath(self)
    local unit = jass.GetTriggerUnit()
    if not unit then
        return
    end
    if type(jass.GetUnitTypeId) ~= "function" then
        return
    end
    local typeId = jass.GetUnitTypeId(unit)
    ____debug(
        nil,
        "掉落触发：unitType=" .. tostring(typeId)
    )
    for ____, rule in ipairs(DROP_RULES) do
        do
            local __continue22
            repeat
                local ruleTypeId = stringToFourCC(nil, rule.unitId)
                if typeId ~= ruleTypeId then
                    __continue22 = true
                    break
                end
                ____debug(
                    nil,
                    (((((("命中规则：" .. rule.unitId) .. " score=") .. tostring(rule.minScore)) .. "-") .. tostring(rule.maxScore)) .. " proc=") .. tostring(rule.proc)
                )
                local proc = type(rule.proc) == "number" and rule.proc or 0
                local r = math.random(1, 10000)
                if r > proc * 10000 then
                    ____debug(
                        nil,
                        ("概率未过：roll=" .. tostring(r)) .. "/10000"
                    )
                    __continue22 = true
                    break
                end
                local itemId = pickOneItem(nil, rule.minScore, rule.maxScore)
                if not itemId then
                    local total = 0
                    local withScore = 0
                    local inRange = 0
                    local sample = ""
                    local sampled = 0
                    for id in pairs(itemsData) do
                        total = total + 1
                        local entry = itemsData[id]
                        if type(entry and entry.score) == "number" then
                            withScore = withScore + 1
                            if entry.score >= rule.minScore and entry.score <= rule.maxScore then
                                inRange = inRange + 1
                            end
                        end
                        if sampled < 5 and type(id) == "string" then
                            sample = sample .. (sampled == 0 and "" or ",") .. id
                            sampled = sampled + 1
                        end
                    end
                    ____debug(
                        nil,
                        (((((("抽取失败：该分数段无物品 total=" .. tostring(total)) .. " withScore=") .. tostring(withScore)) .. " inRange=") .. tostring(inRange)) .. " sample=") .. sample
                    )
                    __continue22 = true
                    break
                end
                ____debug(nil, "抽取成功：itemId=" .. itemId)
                local loc = nil
                if type(jass.GetUnitLoc) == "function" then
                    loc = jass.GetUnitLoc(unit)
                end
                if loc and type(jass.CreateItemLoc) == "function" then
                    jass.CreateItemLoc(
                        stringToFourCC(nil, itemId),
                        loc
                    )
                    if type(jass.RemoveLocation) == "function" then
                        jass.RemoveLocation(loc)
                    end
                    ____debug(nil, "已CreateItemLoc")
                elseif jass.GetUnitX ~= nil then
                    local x = jass.GetUnitX(unit)
                    local y = jass.GetUnitY(unit)
                    jass.CreateItem(
                        stringToFourCC(nil, itemId),
                        x,
                        y
                    )
                    ____debug(nil, "已CreateItem(x,y)")
                else
                    ____debug(nil, "创建失败：无CreateItemLoc且无GetUnitX/GetUnitY")
                end
                break
            until true
            if not __continue22 then
                break
            end
        end
    end
end
local function condition(self)
    local u = jass.GetTriggerUnit()
    if not u then
        return false
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(u) then
        return false
    end
    if jass.IsUnitType(u, jass.UNIT_TYPE_SUMMONED) then
        return false
    end
    return true
end
local function init(self)
    local trig = jass.CreateTrigger()
    local ____jass_EVENT_PLAYER_UNIT_DEATH_4 = jass.EVENT_PLAYER_UNIT_DEATH
    if ____jass_EVENT_PLAYER_UNIT_DEATH_4 == nil then
        ____jass_EVENT_PLAYER_UNIT_DEATH_4 = 52
    end
    local eventId = ____jass_EVENT_PLAYER_UNIT_DEATH_4
    do
        local i = 0
        while i < 16 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                eventId,
                nil
            )
            i = i + 1
        end
    end
    local ____this_7
    ____this_7 = jass
    local ____opt_5 = ____this_7.Player
    if ____opt_5 ~= nil then
        local ____jass_PLAYER_NEUTRAL_AGGRESSIVE_6 = jass.PLAYER_NEUTRAL_AGGRESSIVE
        if ____jass_PLAYER_NEUTRAL_AGGRESSIVE_6 == nil then
            ____jass_PLAYER_NEUTRAL_AGGRESSIVE_6 = 12
        end
        ____opt_5 = ____opt_5(____this_7, ____jass_PLAYER_NEUTRAL_AGGRESSIVE_6)
    end
    local neutral = ____opt_5
    if neutral ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, nil)
    end
    local ____this_10
    ____this_10 = jass
    local ____opt_8 = ____this_10.Player
    if ____opt_8 ~= nil then
        local ____jass_PLAYER_NEUTRAL_PASSIVE_9 = jass.PLAYER_NEUTRAL_PASSIVE
        if ____jass_PLAYER_NEUTRAL_PASSIVE_9 == nil then
            ____jass_PLAYER_NEUTRAL_PASSIVE_9 = 15
        end
        ____opt_8 = ____opt_8(____this_10, ____jass_PLAYER_NEUTRAL_PASSIVE_9)
    end
    local neutralPassive = ____opt_8
    if neutralPassive ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, nil)
    end
    local cond = jass.Condition
    if type(cond) == "function" then
        jass.TriggerAddCondition(
            trig,
            cond(nil, condition)
        )
    end
    jass.TriggerAddAction(trig, onUnitDeath)
    local cnt = 0
    for _k in pairs(itemsData) do
        cnt = cnt + 1
    end
    ____debug(
        nil,
        "装备掉落：init 完成 items=" .. tostring(cnt)
    )
end
init(nil)
____exports.DROP_RULES = DROP_RULES
____exports.pickOneItem = pickOneItem
return ____exports
