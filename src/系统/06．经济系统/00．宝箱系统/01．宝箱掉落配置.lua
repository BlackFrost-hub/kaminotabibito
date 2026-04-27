local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ArrayPushArray = ____lualib.__TS__ArrayPushArray
local ____exports = {}
local ____require_result_0 = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
local getChestConfigByString = ____require_result_0.getChestConfigByString
local ____require_result_1 = require("系统.02．物品系统.01．装备数据")
local items = ____require_result_1.items
local function parseItemPool(poolStr)
    local entries = {}
    local parts = __TS__StringSplit(poolStr, ";")
    for ____, part in ipairs(parts) do
        do
            local trimmed = __TS__StringTrim(part)
            if not trimmed then
                goto __continue3
            end
            if __TS__StringIncludes(trimmed, ":") then
                local splitParts = __TS__StringSplit(trimmed, ":")
                local id = __TS__StringTrim(splitParts[1] or "")
                local weightStr = splitParts[2] or ""
                entries[#entries + 1] = {
                    id = id,
                    weight = __TS__ParseFloat(weightStr) or 1
                }
            else
                entries[#entries + 1] = {id = trimmed, weight = 1}
            end
        end
        ::__continue3::
    end
    return entries
end
local function drawByWeightWithRepeat(pool, picks)
    local result = {}
    local totalWeight = __TS__ArrayReduce(
        pool,
        function(____, sum, e) return sum + e.weight end,
        0
    )
    do
        local i = 0
        while i < picks do
            local r = math:random() * totalWeight
            for ____, entry in ipairs(pool) do
                r = r - entry.weight
                if r <= 0 then
                    result[#result + 1] = entry.id
                    break
                end
            end
            i = i + 1
        end
    end
    return result
end
local function drawByEqualWithoutRepeat(pool, picks)
    local shuffled = __TS__ArraySort(
        {table.unpack(pool)},
        function() return math:random() - 0.5 end
    )
    local count = picks < #shuffled and picks or #shuffled
    return __TS__ArrayMap(
        __TS__ArraySlice(shuffled, 0, count),
        function(____, e) return e.id end
    )
end
local function filterItemsByScore(min, max)
    local result = {}
    for ____, ____value in ipairs(__TS__ObjectEntries(items)) do
        local id = ____value[1]
        local data = ____value[2]
        local score = data and data.score
        if score ~= nil and score >= min and score <= max then
            result[#result + 1] = id
        end
    end
    return result
end
local function parseAlwaysItems(alwaysStr)
    if not alwaysStr then
        return {}
    end
    return __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(alwaysStr, ";"),
            function(____, s) return __TS__StringTrim(s) end
        ),
        function(____, s) return #s == 4 end
    )
end
local function executeDropByMode(dropMode, picks)
    local result = {}
    if dropMode.always ~= nil and dropMode.always then
        local alwaysItems = parseAlwaysItems(dropMode.always)
        for ____, itemId in ipairs(alwaysItems) do
            result[#result + 1] = itemId
        end
    end
    repeat
        local ____switch30 = dropMode.type
        local ____cond30 = ____switch30 == "pool"
        if ____cond30 then
            do
                local pool = parseItemPool(dropMode.items)
                if #pool > 0 and picks > 0 then
                    local hasWeight = __TS__ArraySome(
                        pool,
                        function(____, e) return e.weight ~= 1 end
                    )
                    local drawn = hasWeight and drawByWeightWithRepeat(pool, picks) or drawByEqualWithoutRepeat(pool, picks)
                    __TS__ArrayPushArray(result, drawn)
                end
                break
            end
        end
        ____cond30 = ____cond30 or ____switch30 == "mixed"
        if ____cond30 then
            do
                local pool = parseItemPool(dropMode.items)
                if #pool > 0 then
                    pool = __TS__ArrayFilter(
                        pool,
                        function(____, entry)
                            local ____opt_4 = items[entry.id]
                            local score = ____opt_4 and ____opt_4.score
                            if score == nil then
                                return false
                            end
                            return score >= dropMode.range.min and score <= dropMode.range.max
                        end
                    )
                end
                if #pool > 0 and picks > 0 then
                    local drawn = drawByWeightWithRepeat(pool, picks)
                    __TS__ArrayPushArray(result, drawn)
                end
                break
            end
        end
        ____cond30 = ____cond30 or ____switch30 == "score"
        if ____cond30 then
            do
                local itemIds = filterItemsByScore(dropMode.range.min, dropMode.range.max)
                if #itemIds > 0 and picks > 0 then
                    local pool = __TS__ArrayMap(
                        itemIds,
                        function(____, id) return {id = id, weight = 1} end
                    )
                    local drawn = drawByEqualWithoutRepeat(pool, picks)
                    __TS__ArrayPushArray(result, drawn)
                end
                break
            end
        end
    until true
    return result
end
--- 执行宝箱掉落
-- 
-- @param config 宝箱配置
-- @returns 掉落的物品ID数组
function ____exports.executeChestDrop(config)
    return executeDropByMode(config.dropMode, config.picks)
end
--- 通过可破坏物类型执行掉落
-- 
-- @param destructableType 可破坏物类型ID（如 "B00Z"）
-- @returns 掉落的物品ID数组，如果不是宝箱返回空数组
function ____exports.dropItemsByDestructable(destructableType)
    local config = getChestConfigByString(nil, destructableType)
    if not config then
        return {}
    end
    return ____exports.executeChestDrop(config)
end
--- 创建掉落物品（在指定位置创建物品）
-- 
-- @param itemId 物品ID
-- @param x X坐标
-- @param y Y坐标
-- @returns 创建的物品
function ____exports.createDropItem(itemId, x, y)
    local jass = require("jass.common")
    local item = jass:CreateItem(
        jass:FourCC(itemId),
        x,
        y
    )
    if item then
        local ____require_result_6 = require("系统.02．物品系统.09．装备排泄")
        local setLastCreatedItem = ____require_result_6.setLastCreatedItem
        setLastCreatedItem(nil, item)
    end
    return item
end
--- 在宝箱位置执行完整掉落（创建物品）
-- 
-- @param destructableType 可破坏物类型
-- @param x X坐标
-- @param y Y坐标
-- @returns 创建的物品数组
function ____exports.dropItemsFromChest(destructableType, x, y)
    local itemIds = ____exports.dropItemsByDestructable(destructableType)
    local items = {}
    for ____, itemId in ipairs(itemIds) do
        local item = ____exports.createDropItem(itemId, x, y)
        if item then
            items[#items + 1] = item
        end
    end
    return items
end
return ____exports
