local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 字符串池
-- 
-- 用途：保存一组字符串及其权重，按权重随机取值。
-- - 随机取字符串：只读取，不移除，适合台词、提示、日志文案。
-- - 随机取出字符串：读取后移除，适合不重复文案、随机阶段名、一次性事件。
local jass = require("jass.common")
local GetRandomReal = jass.GetRandomReal
local _____5B57_7B26_4E32_6C60_6620_5C04 = {}
local _____4E0B_4E00_4E2A_5B57_7B26_4E32_6C60ID = 0
local function _____53D6_5B57_7B26_4E32_6C60(pool)
    if pool == nil or pool <= 0 then
        return nil
    end
    return _____5B57_7B26_4E32_6C60_6620_5C04[pool]
end
local function _____53D6_5B89_5168_6743_91CD(weight)
    return weight == nil and 1 or weight
end
local function _____5220_9664_4E0B_6807(data, index)
    local lastIndex = #data.values - 1
    if index < 0 or index > lastIndex then
        return
    end
    if index ~= lastIndex then
        data.values[index + 1] = data.values[lastIndex + 1]
        data.weights[index + 1] = data.weights[lastIndex + 1]
    end
    table.remove(data.values)
    table.remove(data.weights)
end
local function _____968F_673A_53D6_4E0B_6807(data)
    local totalWeight = 0
    local i = 0
    while i < #data.weights do
        local weight = data.weights[i + 1]
        if weight > 0 then
            totalWeight = totalWeight + weight
        end
        i = i + 1
    end
    if totalWeight <= 0 then
        return -1
    end
    local roll = GetRandomReal(0, totalWeight)
    local currentWeight = 0
    local lastPositiveIndex = -1
    i = 0
    while i < #data.values do
        local weight = data.weights[i + 1]
        if weight > 0 then
            currentWeight = currentWeight + weight
            lastPositiveIndex = i
            if roll <= currentWeight then
                return i
            end
        end
        i = i + 1
    end
    return lastPositiveIndex
end
____exports["创建字符串池"] = function()
    _____4E0B_4E00_4E2A_5B57_7B26_4E32_6C60ID = _____4E0B_4E00_4E2A_5B57_7B26_4E32_6C60ID + 1
    local id = _____4E0B_4E00_4E2A_5B57_7B26_4E32_6C60ID
    _____5B57_7B26_4E32_6C60_6620_5C04[id] = {id = id, values = {}, weights = {}}
    return id
end
____exports["删除字符串池"] = function(pool)
    __TS__Delete(_____5B57_7B26_4E32_6C60_6620_5C04, pool)
end
____exports["字符串池是否存在"] = function(pool)
    return _____53D6_5B57_7B26_4E32_6C60(pool) ~= nil
end
____exports["字符串池是否为空"] = function(pool)
    local data = _____53D6_5B57_7B26_4E32_6C60(pool)
    return data == nil or #data.values == 0
end
____exports["获取字符串池数量"] = function(pool)
    local data = _____53D6_5B57_7B26_4E32_6C60(pool)
    return data == nil and 0 or #data.values
end
--- 返回字符串所在下标；不存在返回 -1。下标沿用 JASS 版语义，从 0 开始。
____exports["字符串池查找"] = function(pool, value)
    local data = _____53D6_5B57_7B26_4E32_6C60(pool)
    if data == nil then
        return -1
    end
    local i = 0
    while i < #data.values do
        if data.values[i + 1] == value then
            return i
        end
        i = i + 1
    end
    return -1
end
____exports["字符串池添加"] = function(pool, value, weight)
    local data = _____53D6_5B57_7B26_4E32_6C60(pool)
    if data == nil then
        return false
    end
    local ____data_values_0 = data.values
    ____data_values_0[#____data_values_0 + 1] = value
    local ____data_weights_1 = data.weights
    ____data_weights_1[#____data_weights_1 + 1] = _____53D6_5B89_5168_6743_91CD(weight)
    return true
end
____exports["字符串池删除字符串"] = function(pool, value)
    local data = _____53D6_5B57_7B26_4E32_6C60(pool)
    if data == nil then
        return false
    end
    local index = ____exports["字符串池查找"](pool, value)
    if index < 0 then
        return false
    end
    _____5220_9664_4E0B_6807(data, index)
    return true
end
____exports["字符串池随机取字符串"] = function(pool)
    local data = _____53D6_5B57_7B26_4E32_6C60(pool)
    if data == nil then
        return ""
    end
    local index = _____968F_673A_53D6_4E0B_6807(data)
    return index >= 0 and data.values[index + 1] or ""
end
____exports["字符串池随机取出字符串"] = function(pool)
    local data = _____53D6_5B57_7B26_4E32_6C60(pool)
    if data == nil then
        return ""
    end
    local index = _____968F_673A_53D6_4E0B_6807(data)
    if index < 0 then
        return ""
    end
    local value = data.values[index + 1]
    _____5220_9664_4E0B_6807(data, index)
    return value
end
____exports.SSRP_CreatePool = ____exports["创建字符串池"]
____exports.SSRP_RemovePool = ____exports["删除字符串池"]
____exports.SSRP_IsInPool = ____exports["字符串池查找"]
____exports.SSRP_PoolAddString = ____exports["字符串池添加"]
____exports.SSRP_PoolRemoveString = ____exports["字符串池删除字符串"]
____exports.SSRP_PoolGetString = ____exports["字符串池随机取出字符串"]
return ____exports
