local ____lualib = require("lualib_bundle")
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
function getItemsByScoreRange(minScore, maxScore)
    local result = {}
    for id in pairs(itemsData) do
        do
            if type(id) ~= "string" or #id ~= 4 then
                goto __continue78
            end
            local entry = itemsData[id]
            local score = entry and entry.score
            if type(score) ~= "number" then
                goto __continue78
            end
            if score >= minScore and score <= maxScore then
                result[#result + 1] = id
            end
        end
        ::__continue78::
    end
    return result
end
--- 装备掉落表格式说明：
-- - picks：最多掉落多少件（不是必定掉满）。
-- - itemIds 带百分数（如 I03Y:7%;I04R:7%）：每项独立按概率判定，不重复；最多 picks 件。仅当 picks > 物品种类数时，差额按权重再抽（可重复）。
-- - itemIds 纯权重（如 I02C:1.5;I01G:1）：按权重在池中随机抽 picks 件。
-- - itemIds 无权重（如 I00C;I00E;I00D;I00G）：从池中选 min(picks, 池大小) 件不重复；picks > 池大小时多出的可重复随机。
-- - always：必掉且仅掉一次。
-- - unitType 为 elite/Boss 且 T>1 时，picks = round(basePicks×(1+0.334×(T-1)))。
local jass = require("jass.common")
local g = require("jass.globals")
local itemInv = require("lib.扩展函数.BJ函数.index")
local equipExcrete = require("系统.02．物品系统.09．装备排泄")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local isSpecialUnit = ____require_result_0.isSpecialUnit
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_1.debugLog
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local idData = require("系统.02．物品系统.02．装备掉落表").default or require("系统.02．物品系统.02．装备掉落表").idData or ({})
itemsData = require("系统.02．物品系统.01．装备数据").default or ({})
local PREFIX = "|cffffff00『系统提示』：|r"
local function typeIdToUnitId(typeId)
    for id in pairs(idData) do
        if stringToFourCC(id) == typeId then
            return id
        end
    end
    return nil
end
--- 解析 itemIds → [{id, weight, always?}]。always 标记必掉且仅掉一次、不参与重复抽取
local function parseItemPool(itemIdsStr)
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
                local colon = (string.find(p, ":", nil, true) or 0) - 1
                if colon < 0 then
                    goto __continue12
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
            end
            ::__continue12::
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
local function getEffectivePicks(basePicks, unitType)
    local ut = string.lower(tostring(unitType or ""))
    if ut ~= "elite" and ut ~= "boss" then
        return basePicks
    end
    local T = g.udg_T ~= nil and __TS__Number(g.udg_T) or 0
    if T <= 1 then
        return basePicks
    end
    local mult = 1 + 0.334 * (T - 1)
    return jass.R2I(basePicks * mult + 0.5)
end
--- 加权随机取一个（权重不必归一化）
local function weightedPickOne(pool)
    if #pool == 0 then
        return nil
    end
    local sum = 0
    for ____, p in ipairs(pool) do
        sum = sum + p.weight
    end
    if sum <= 0 then
        local ____opt_3 = pool[jass.GetRandomInt(1, #pool)]
        if ____opt_3 ~= nil then
            ____opt_3 = ____opt_3.id
        end
        return ____opt_3
    end
    local r = jass.GetRandomReal(0, 1) * sum
    local acc = 0
    for ____, p in ipairs(pool) do
        acc = acc + p.weight
        if r <= acc then
            return p.id
        end
    end
    return pool[#pool].id
end
--- 权重/百分比池：最多 picks 件；首轮每项独立按概率 roll，不重复。
-- 仅当 picks > 池子物品种类数时，差额按权重再抽（可重复掉落）。
local function pickFromWeightedPool(pool, picks)
    if #pool == 0 then
        return {}
    end
    if picks == 1 then
        local one = weightedPickOne(pool)
        return one and ({one}) or ({})
    end
    local out = {}
    for ____, p in ipairs(pool) do
        if p.weight >= 1 or p.always then
            debugLog(
                nil,
                "装备掉落",
                "必掉物品:",
                p.id,
                p.weight
            )
            out[#out + 1] = p.id
        else
            local r = jass.GetRandomReal(0, 1)
            debugLog(
                nil,
                "装备掉落",
                "概率判定:",
                p.id,
                "weight:",
                p.weight,
                "r:",
                r,
                "命中:",
                r < p.weight
            )
            if r < p.weight then
                out[#out + 1] = p.id
            end
        end
    end
    if #out > picks then
        do
            local i = #out - 1
            while i >= 1 do
                local j = jass.GetRandomInt(1, i + 1)
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
    if picks <= #pool then
        return out
    end
    do
        local i = 0
        while i < needMore do
            local one = weightedPickOne(pool)
            if one ~= nil then
                out[#out + 1] = one
            end
            i = i + 1
        end
    end
    return out
end
--- 无权重池（I00C;I00E;I00D;I00G）：从池中选 min(picks, 池大小) 件不重复；若 picks > 池大小，多出的按池内随机再抽（可重复）
local function pickFromEqualPool(ids, picks)
    if #ids == 0 or picks <= 0 then
        return {}
    end
    local out = {}
    local list = __TS__ArraySlice(ids)
    local firstPicks = picks <= #list and picks or #list
    do
        local i = 0
        while i < firstPicks do
            local idx = jass.GetRandomInt(1, #list)
            local id = list[idx - 1]
            out[#out + 1] = id
            __TS__ArraySplice(list, idx - 1, 1)
            i = i + 1
        end
    end
    local needMore = picks - #out
    do
        local i = 0
        while i < needMore do
            local idx = jass.GetRandomInt(1, #ids)
            out[#out + 1] = ids[idx - 1]
            i = i + 1
        end
    end
    return out
end
local function createItemAtUnit(unit, itemId)
    local four = stringToFourCC(itemId)
    local loc = jass.GetUnitLoc(unit)
    if loc then
        equipExcrete:setLastCreatedItem(itemInv:CreateItemLoc(four, loc))
    elseif jass.GetUnitX ~= nil then
        local x = jass.GetUnitX(unit)
        local y = jass.GetUnitY(unit)
        equipExcrete:setLastCreatedItem(jass.CreateItem(four, x, y))
    end
    if loc then
        jass.RemoveLocation(loc)
    end
end
local function onUnitDeath(unit, _killer)
    if not unit then
        return
    end
    if isSpecialUnit(nil, unit) then
        return
    end
    local typeId = jass.GetUnitTypeId(unit)
    local unitId = typeIdToUnitId(typeId)
    local entry = unitId and idData[unitId] or nil
    debugLog(
        nil,
        "装备掉落",
        "单位死亡 typeId:",
        typeId,
        "unitId:",
        unitId,
        "entry:",
        entry and entry.name
    )
    if entry and entry.itemIds ~= nil then
        debugLog(nil, "装备掉落", "找到掉落表 itemIds:", entry.itemIds)
        local dropProc = entry.dropProc ~= nil and __TS__Number(entry.dropProc) or 1
        local r = jass.GetRandomInt(1, 10000)
        if r > dropProc * 10000 then
            return
        end
        local rawItemIds = tostring(entry.itemIds)
        local pool = parseItemPool(rawItemIds)
        if #pool == 0 then
            return
        end
        local picksNum = jass.R2I(__TS__Number(entry.picks) or 1)
        if picksNum < 1 then
            picksNum = 1
        end
        picksNum = getEffectivePicks(picksNum, entry.unitType)
        local ids = __TS__ArrayMap(
            pool,
            function(____, p) return p.id end
        )
        local isEqualPool = (string.find(rawItemIds, ":", nil, true) or 0) - 1 < 0
        local toDrop = isEqualPool and pickFromEqualPool(ids, picksNum) or pickFromWeightedPool(pool, picksNum)
        for ____, id in ipairs(toDrop) do
            createItemAtUnit(unit, id)
        end
        return
    end
    local DROP_RULES = {{unitId = "hfoo", minScore = 150, maxScore = 250, proc = 1}}
    for ____, rule in ipairs(DROP_RULES) do
        do
            if typeId ~= stringToFourCC(rule.unitId) then
                goto __continue71
            end
            local r = jass.GetRandomInt(1, 10000)
            if r > rule.proc * 10000 then
                goto __continue71
            end
            local list = getItemsByScoreRange(rule.minScore, rule.maxScore)
            if #list == 0 then
                goto __continue71
            end
            local idx = jass.GetRandomInt(1, #list)
            local itemId = list[idx]
            if itemId ~= nil and itemId ~= "" then
                createItemAtUnit(unit, itemId)
            end
            break
        end
        ::__continue71::
    end
end
registerDeathListener(onUnitDeath)
return ____exports
