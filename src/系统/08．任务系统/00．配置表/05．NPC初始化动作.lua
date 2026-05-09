local ____lualib = require("lualib_bundle")
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local ____03_FF0E_7269_54C1_4E0E_5E93_5B58 = require("lib.扩展函数.BJ函数.03．物品与库存")
local RemoveItemFromStockBJ = ____03_FF0E_7269_54C1_4E0E_5E93_5B58.RemoveItemFromStockBJ
local ____index = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____index.stringToFourCC
local jass = require("jass.common")
local function readFirstInt(self, text)
    local found = false
    local n = 0
    do
        local i = 0
        while i < #text do
            local c = __TS__StringCharAt(text, i)
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
local function parseItemIdList(self, spec)
    local trimmed = __TS__StringTrim(spec)
    local prefix = "itemId("
    if (string.find(trimmed, prefix, nil, true) or 0) - 1 ~= 0 then
        return {}
    end
    local ____end = -1
    do
        local i = #trimmed - 1
        while i >= 0 do
            if __TS__StringCharAt(trimmed, i) == ")" then
                ____end = i
                break
            end
            i = i - 1
        end
    end
    if ____end < #prefix then
        return {}
    end
    local inner = __TS__StringSubstring(trimmed, #prefix, ____end)
    local parts = __TS__StringSplit(inner, "|")
    local out = {}
    for ____, p in ipairs(parts) do
        local code = __TS__StringTrim(p)
        if #code == 4 then
            out[#out + 1] = code
        end
    end
    return out
end
local function pickRandomDistinct(self, list, count)
    local out = {}
    if not list or #list == 0 then
        return out
    end
    if count <= 0 then
        return out
    end
    local pool = {table.unpack(list)}
    while #pool > 0 and #out < count do
        local idx = jass:GetRandomInt(1, #pool) or 1
        local picked = pool[idx]
        out[#out + 1] = picked
        __TS__ArraySplice(pool, idx - 1, 1)
    end
    return out
end
local function execRemoveItemFromStock(self, whichUnit, arg, modifiers)
    local items = parseItemIdList(nil, arg)
    if #items == 0 then
        return
    end
    local pickCount = 0
    for ____, m in ipairs(modifiers) do
        local mm = string.lower(__TS__StringTrim(m))
        if (string.find(mm, "random", nil, true) or 0) - 1 == 0 then
            pickCount = readFirstInt(nil, mm)
            break
        end
    end
    local targets = pickCount > 0 and pickRandomDistinct(nil, items, pickCount) or items
    for ____, code in ipairs(targets) do
        local id = stringToFourCC(nil, code)
        if id ~= 0 then
            RemoveItemFromStockBJ(nil, id, whichUnit)
        end
    end
end
--- 执行 NPC 配置中的 initAction（用于 NPC 生成后的初始化脚本）。
-- 
-- 当前支持：
-- - `RemoveItemFromStockBJ:itemId(I0AG|I0AH|I0AI)`（移除全部）
-- - `RemoveItemFromStockBJ:itemId(I0AG|I0AH|I0AI);random1`（随机移除 1 个）
function ____exports.runNpcInitAction(self, whichUnit, initAction)
    if not whichUnit or not initAction then
        return
    end
    local raw = __TS__StringTrim(initAction)
    if raw == "" then
        return
    end
    local segments = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(raw, ";"),
            function(____, s) return __TS__StringTrim(s) end
        ),
        function(____, s) return s ~= "" end
    )
    if #segments == 0 then
        return
    end
    local head = segments[1]
    local modifiers = __TS__ArraySlice(segments, 1)
    local colon = (string.find(head, ":", nil, true) or 0) - 1
    local action = colon >= 0 and __TS__StringTrim(__TS__StringSubstring(head, 0, colon)) or __TS__StringTrim(head)
    local arg = colon >= 0 and __TS__StringTrim(__TS__StringSubstring(head, colon + 1)) or ""
    if action == "RemoveItemFromStockBJ" then
        execRemoveItemFromStock(nil, whichUnit, arg, modifiers)
        return
    end
end
return ____exports
