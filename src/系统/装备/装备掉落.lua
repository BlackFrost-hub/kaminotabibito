local ____lualib = require("lualib_bundle")
local __TS__StringCharCodeAt = ____lualib.__TS__StringCharCodeAt
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local getItemsByScoreRange, itemsData
function getItemsByScoreRange(self, minScore, maxScore)
    local result = {}
    for id in pairs(itemsData) do
        do
            local __continue89
            repeat
                if type(id) ~= "string" or #id ~= 4 then
                    __continue89 = true
                    break
                end
                local entry = itemsData[id]
                local score = entry and entry.score
                if type(score) ~= "number" then
                    __continue89 = true
                    break
                end
                if score >= minScore and score <= maxScore then
                    result[#result + 1] = id
                end
                __continue89 = true
            until true
            if not __continue89 then
                break
            end
        end
    end
    return result
end
--- 装备掉落表格式说明：
-- - picks：最多掉落多少件物品。
-- - itemIds 带百分数（如 I03Y:7%;I04R:7%）：每个物品独立按自身概率判定是否掉落，互不影响，但最终最多掉落 picks 件；always 表示必掉且仅掉一次（不参与重复抽取）。
-- - itemIds 纯权重（如 I02C:1.5;I01G:1）：按权重在池中随机抽取 picks 件。
-- - itemIds 无权重（如 I00C;I00E;I00D;I00G）：在池中随机选 picks 件（默认不重复）。
-- - isUniversal：为 true 时，若掉了专属掉落则不再参与通用掉落（如 1-10 级 3% 生命药水，待实现）。
-- - unitType：单位类型（normal/elite/Boss 等）。elite/Boss 在 T（玩家人数）>1 时，picks = round(basePicks×(1+0.334×(T-1)))。
-- - 全局掉落默认不重复；仅当 picks（含 T 提升后）> 池子大小时，多出的次数从非 always 物品中随机重复抽取。
local jass = require("jass.common")
local g = require("jass.globals")
local idData = require("系统.装备.装备掉落表").default or require("系统.装备.装备掉落表").idData or ({})
itemsData = require("系统.装备.装备数据").default or ({})
local _seed = 0
local DEBUG_DROP = false
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
local function typeIdToUnitId(self, typeId)
    for id in pairs(idData) do
        if stringToFourCC(nil, id) == typeId then
            return id
        end
    end
    return nil
end
--- 解析 itemIds → [{id, weight, always?}]。always 标记必掉且仅掉一次、不参与重复抽取
local function parseItemPool(self, itemIdsStr)
    local raw = __TS__StringTrim(tostring(itemIdsStr))
    if not raw then
        return {}
    end
    local parts = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(raw, ";"),
            function(____, p) return __TS__StringTrim(p) end
        ),
        function(____, p) return #p >= 4 end
    )
    local hasColon = __TS__ArraySome(
        parts,
        function(____, p) return (string.find(p, ":", nil, true) or 0) - 1 >= 0 end
    )
    local pool = {}
    if hasColon then
        for ____, p in ipairs(parts) do
            do
                local __continue20
                repeat
                    local colon = (string.find(p, ":", nil, true) or 0) - 1
                    if colon < 0 then
                        __continue20 = true
                        break
                    end
                    local id = __TS__StringTrim(__TS__StringSubstring(p, 0, colon))
                    local w = 0
                    local always = false
                    local rest = string.lower(__TS__StringTrim(__TS__StringSubstring(p, colon + 1)))
                    if rest == "always" then
                        w = 1
                        always = true
                    elseif (string.find(rest, "%", nil, true) or 0) - 1 >= 0 then
                        w = __TS__ParseFloat(rest) / 100
                    else
                        w = __TS__ParseFloat(rest)
                    end
                    if #id >= 4 then
                        pool[#pool + 1] = {
                            id = __TS__StringSubstring(id, 0, 4),
                            weight = w,
                            always = always
                        }
                    end
                    __continue20 = true
                until true
                if not __continue20 then
                    break
                end
            end
        end
    else
        for ____, p in ipairs(parts) do
            local id = __TS__StringSubstring(p, 0, 4)
            if #id == 4 then
                pool[#pool + 1] = {id = id, weight = 1}
            end
        end
    end
    return pool
end
--- Jass 全局 T = 玩家人数。unitType 为 elite/Boss 时，picks = round(basePicks × (1 + 0.334×(T-1)))，如 T=5、picks=2 得 5
local function getEffectivePicks(self, basePicks, unitType)
    local ut = string.lower(tostring(unitType or ""))
    if ut ~= "elite" and ut ~= "boss" then
        return basePicks
    end
    local T = g.udg_T ~= nil and __TS__Number(g.udg_T) or 0
    if T <= 1 then
        return basePicks
    end
    local mult = 1 + 0.334 * (T - 1)
    return math.floor(basePicks * mult + 0.5)
end
--- 加权随机取一个（权重不必归一化）
local function weightedPickOne(self, pool)
    if #pool == 0 then
        return nil
    end
    local sum = 0
    for ____, p in ipairs(pool) do
        sum = sum + p.weight
    end
    if sum <= 0 then
        local ____opt_0 = pool[math.random(1, #pool)]
        if ____opt_0 ~= nil then
            ____opt_0 = ____opt_0.id
        end
        return ____opt_0
    end
    local r = math.random(1, 10000) / 10000 * sum
    local acc = 0
    for ____, p in ipairs(pool) do
        acc = acc + p.weight
        if r <= acc then
            return p.id
        end
    end
    return pool[#pool].id
end
--- 权重池：默认不重复（每个池内物品至多掉一次）。
-- picks=1 抽 1 个；picks>1 每项独立按概率 roll，always 必掉且仅掉一次；最多 picks 件。
-- 当 picks > 池子大小时，多出的次数从非 always 物品中随机重复抽取；always 永不重复。
local function pickFromWeightedPool(self, pool, picks)
    if #pool == 0 then
        return {}
    end
    if picks == 1 then
        local one = weightedPickOne(nil, pool)
        return one and ({one}) or ({})
    end
    local out = {}
    for ____, p in ipairs(pool) do
        if p.weight >= 1 then
            out[#out + 1] = p.id
        else
            local r = math.random(1, 10000) / 10000
            if r < p.weight then
                out[#out + 1] = p.id
            end
        end
    end
    if #out > picks then
        do
            local i = #out - 1
            while i >= 1 do
                local j = math.random(1, i + 1)
                local t = out[i + 1]
                out[i + 1] = out[j]
                out[j] = t
                i = i - 1
            end
        end
        while #out > picks do
            table.remove(out)
        end
    end
    local needMore = picks - #out
    if needMore <= 0 then
        return out
    end
    local nonAlwaysIds = {}
    for ____, p in ipairs(pool) do
        if not p.always then
            nonAlwaysIds[#nonAlwaysIds + 1] = p.id
        end
    end
    if #nonAlwaysIds == 0 then
        return out
    end
    do
        local i = 0
        while i < needMore do
            local idx = math.random(1, #nonAlwaysIds)
            out[#out + 1] = nonAlwaysIds[idx]
            i = i + 1
        end
    end
    return out
end
--- 无权重池（I00C;I00E;I00D;I00G）：随机选 picks 个；默认不重复，仅当 picks > 池大小时才允许重复
local function pickFromEqualPool(self, ids, picks)
    if #ids == 0 or picks <= 0 then
        return {}
    end
    local allowRepeat = picks > #ids
    local out = {}
    local list = __TS__ArraySlice(ids)
    do
        local i = 0
        while i < picks do
            if #list == 0 and not allowRepeat then
                break
            end
            local idx = math.random(1, #list)
            local id = list[idx - 1]
            out[#out + 1] = id
            if not allowRepeat then
                __TS__ArraySplice(list, idx - 1, 1)
            end
            i = i + 1
        end
    end
    return out
end
local function createItemAtUnit(self, unit, itemId)
    local four = stringToFourCC(nil, itemId)
    local loc = nil
    if type(jass.GetUnitLoc) == "function" then
        loc = jass.GetUnitLoc(unit)
    end
    if loc and type(jass.CreateItemLoc) == "function" then
        jass.CreateItemLoc(four, loc)
        if type(jass.RemoveLocation) == "function" then
            jass.RemoveLocation(loc)
        end
    elseif jass.GetUnitX ~= nil then
        local x = jass.GetUnitX(unit)
        local y = jass.GetUnitY(unit)
        jass.CreateItem(four, x, y)
    end
end
local function onUnitDeath(self)
    local unit = jass.GetTriggerUnit()
    if not unit then
        return
    end
    if type(jass.GetUnitTypeId) ~= "function" then
        return
    end
    local typeId = jass.GetUnitTypeId(unit)
    local unitId = typeIdToUnitId(nil, typeId)
    local entry = unitId and idData[unitId] or nil
    if entry and entry.itemIds ~= nil then
        local dropProc = entry.dropProc ~= nil and __TS__Number(entry.dropProc) or 1
        local r = math.random(1, 10000)
        if r > dropProc * 10000 then
            return
        end
        local rawItemIds = tostring(entry.itemIds)
        local pool = parseItemPool(nil, rawItemIds)
        if #pool == 0 then
            return
        end
        local picksNum = math.max(
            1,
            math.floor(__TS__Number(entry.picks) or 1)
        )
        picksNum = getEffectivePicks(nil, picksNum, entry.unitType)
        local ids = __TS__ArrayMap(
            pool,
            function(____, p) return p.id end
        )
        local isEqualPool = (string.find(rawItemIds, ":", nil, true) or 0) - 1 < 0
        local toDrop = isEqualPool and pickFromEqualPool(nil, ids, picksNum) or pickFromWeightedPool(nil, pool, picksNum)
        for ____, id in ipairs(toDrop) do
            createItemAtUnit(nil, unit, id)
        end
        if DEBUG_DROP and #toDrop > 0 then
            ____debug(
                nil,
                (((("总表掉落：" .. tostring(unitId)) .. " x") .. tostring(#toDrop)) .. " ") .. table.concat(toDrop, ",")
            )
        end
        return
    end
    local DROP_RULES = {{unitId = "hfoo", minScore = 150, maxScore = 250, proc = 1}}
    for ____, rule in ipairs(DROP_RULES) do
        do
            local __continue82
            repeat
                if typeId ~= stringToFourCC(nil, rule.unitId) then
                    __continue82 = true
                    break
                end
                local r = math.random(1, 10000)
                if r > rule.proc * 10000 then
                    __continue82 = true
                    break
                end
                local list = getItemsByScoreRange(nil, rule.minScore, rule.maxScore)
                if #list == 0 then
                    __continue82 = true
                    break
                end
                local idx = math.random(1, #list)
                local itemId = list[idx]
                if itemId ~= nil and itemId ~= "" then
                    createItemAtUnit(nil, unit, itemId)
                end
                break
            until true
            if not __continue82 then
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
            ____jass_PLAYER_NEUTRAL_AGGRESSIVE_6 = 13
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
    for _k in pairs(idData) do
        cnt = cnt + 1
    end
    ____debug(
        nil,
        "装备掉落：init 完成 单位数=" .. tostring(cnt)
    )
end
init(nil)
return ____exports
