local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local jass = require("jass.common")
--- Lua 下单位作表键时，伤害回调的 target 与选中枚举的 sole 可能不是同一 userdata；统一用 GetHandleId 作键。
function ____exports.unitHid(self, u)
    if u == nil or u == 0 then
        return 0
    end
    return jass.GetHandleId(u)
end
--- pairs 迭代可能混用 number / string 键，不合并会导致「同目标两行状态」或 onDamage 读不到 cur、乘积误判。
function ____exports.tabRowForHid(self, tab, hid)
    if hid == 0 then
        return nil
    end
    local n = tab[hid]
    if n ~= nil then
        return n
    end
    return tab[tostring(hid)]
end
function ____exports.tabSetHid(self, tab, hid, state)
    if hid == 0 then
        return
    end
    __TS__Delete(
        tab,
        tostring(hid)
    )
    tab[hid] = state
end
function ____exports.tabDeleteHid(self, tab, hid)
    if hid == 0 then
        return
    end
    __TS__Delete(tab, hid)
    __TS__Delete(
        tab,
        tostring(hid)
    )
end
function ____exports.collectHidsInTab(self, tab)
    local seen = {}
    local out = {}
    for k in pairs(tab) do
        do
            local kn = type(k) == "number" and k or __TS__ParseInt(k, 10)
            if __TS__NumberIsNaN(__TS__Number(kn)) or kn == 0 then
                goto __continue12
            end
            if seen[kn] then
                goto __continue12
            end
            seen[kn] = true
            out[#out + 1] = kn
        end
        ::__continue12::
    end
    __TS__ArraySort(
        out,
        function(____, a, b) return a - b end
    )
    return out
end
--- stateByType 槽位应为 DotState 表；若被污染为数字等则剔除，避免 cur.remaining 报错
function ____exports.isValidDotStateRow(self, v)
    return v ~= nil and type(v) == "table" and type(v.remaining) == "number" and type(v.effect) == "number"
end
function ____exports.getDotSourceDisplayName(self, u)
    if u == nil or u == 0 then
        return "未知"
    end
    local n = jass.GetUnitName(u)
    if n ~= nil and n ~= nil and tostring(n) ~= "" then
        return tostring(n)
    end
    return "未知"
end
--- 扁平化存储：key 格式 "typeId|hid"（typeId 字符串，hid 纯数字）
-- 禁止使用 stateByType[typeId][hid] 形式的二级链式索引
-- 排序规则：先按 typeId 字符串字典序，再按 hid 数值（固定语义，勿改）
____exports.dotStateFlat = {}
____exports.ignoredTargetFlat = {}
--- 生成扁平 key
function ____exports.makeDotFlatKey(self, typeId, hid)
    return (typeId .. "|") .. tostring(hid)
end
--- 严格纯数字解析：整串必须为十进制数字且 > 0，不接受 "123abc" 之类
local function parseStrictPositiveInt(self, s)
    if s == "" then
        return nil
    end
    do
        local i = 0
        while i < #s do
            local ch = __TS__StringSubstring(s, i, i + 1)
            if ch < "0" or ch > "9" then
                return nil
            end
            i = i + 1
        end
    end
    local n = __TS__ParseInt(s, 10)
    if __TS__NumberIsNaN(__TS__Number(n)) or n <= 0 then
        return nil
    end
    return n
end
--- 解析扁平 key - 使用字符串操作而非正则（TSTL 不支持正则）
function ____exports.parseDotFlatKey(self, key)
    local idx = (string.find(key, "|", nil, true) or 0) - 1
    if idx <= 0 then
        return nil
    end
    local typeId = __TS__StringSubstring(key, 0, idx)
    local hidStr = __TS__StringSubstring(key, idx + 1)
    local hid = parseStrictPositiveInt(nil, hidStr)
    if typeId == "" or hid == nil then
        return nil
    end
    return {typeId = typeId, hid = hid}
end
--- 读取 DOT 状态
function ____exports.getDotState(self, typeId, hid)
    local key = ____exports.makeDotFlatKey(nil, typeId, hid)
    local state = ____exports.dotStateFlat[key]
    return ____exports.isValidDotStateRow(nil, state) and state or nil
end
--- 写入 DOT 状态
function ____exports.setDotState(self, typeId, hid, state)
    local key = ____exports.makeDotFlatKey(nil, typeId, hid)
    ____exports.dotStateFlat[key] = state
end
--- 删除 DOT 状态
function ____exports.deleteDotState(self, typeId, hid)
    local key = ____exports.makeDotFlatKey(nil, typeId, hid)
    __TS__Delete(____exports.dotStateFlat, key)
end
--- 设置忽略目标
function ____exports.setIgnoredTarget(self, typeId, hid)
    ____exports.ignoredTargetFlat[____exports.makeDotFlatKey(nil, typeId, hid)] = true
end
--- 清除忽略目标
function ____exports.clearIgnoredTarget(self, typeId, hid)
    __TS__Delete(
        ____exports.ignoredTargetFlat,
        ____exports.makeDotFlatKey(nil, typeId, hid)
    )
end
--- 检查忽略目标
function ____exports.isIgnoredTarget(self, typeId, hid)
    return ____exports.ignoredTargetFlat[____exports.makeDotFlatKey(nil, typeId, hid)] == true
end
--- 收集所有活跃的 (typeId, hid) 对，按数值排���
-- 排序：先按 typeId 字符串字典序，再按 hid 数值（固定语义）
function ____exports.collectActiveDotPairs(self)
    local out = {}
    for k in pairs(____exports.dotStateFlat) do
        local p = ____exports.parseDotFlatKey(nil, k)
        if p then
            out[#out + 1] = p
        end
    end
    __TS__ArraySort(
        out,
        function(____, a, b)
            if a.typeId ~= b.typeId then
                return a.typeId < b.typeId and -1 or (a.typeId > b.typeId and 1 or 0)
            end
            return a.hid - b.hid
        end
    )
    return out
end
return ____exports
