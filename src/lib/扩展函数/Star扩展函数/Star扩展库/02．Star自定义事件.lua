--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 自定义事件系统（STES）— 与 zinc `library STES` / war3map.j 对齐
-- - 事件表：优先使用 JASS 的 STES___HT / STES_HT（与 STES_GetTable 一致），勿与 StarBase.j 的 StarBaseHT 混用
-- - STES_Register / STES_RegisterEx：与编译后 STES_Register 逻辑一致
-- - STES_Fire：逆天传参链（YDLocalExecuteTrigger + saveParent + YDTriggerExecuteTrigger false）
-- - STES_FireWithReal11Step：每轮 YDLocal5Set(real, realParamKey, 0) 再 Execute；realParamKey 须由调用方指定（YDLocal 变量名支持数字/英文/中文等）
-- - STES_Execute：与 JASS STES_Execute 一致（TriggerEvaluate + TriggerExecute）
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
local YDLocalExecuteTrigger = ____require_result_0.YDLocalExecuteTrigger
local YDTriggerExecuteTrigger = ____require_result_0.YDTriggerExecuteTrigger
local saveParentIndex = ____require_result_0.saveParentIndex
local ____require_result_1 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local getG_SIndex = ____require_result_1.getG_SIndex
local setG_SIndex = ____require_result_1.setG_SIndex
local getG_LIndex = ____require_result_1.getG_LIndex
local setG_LIndex = ____require_result_1.setG_LIndex
local _indexStack = ____require_result_1._indexStack
local YDLocal5Set = ____require_result_1.YDLocal5Set
--- 与 war3map 中 `STES___HT` / `STES_GetTable` 指向的同一张表；导出名保留历史兼容
local StarBaseHT = nil
local skey_count = 0
local skey_countEx = 0
local skey_index = 0
local skey_indexEx = 0
local StarVarStr = ""
local keysInitialized = false
--- 解析 STES 使用的 hashtable：与 JASS `STES_GetTable` → `return STES___HT` 一致
-- 同时尝试 jass.common 上的全局（部分 Lua 桥接把 JASS 全局挂在这里）
local function resolveStesHashtable(self)
    local jg = jglobals
    local g = _G
    local jc = jass
    local ____opt_result_4
    if jg ~= nil then
        ____opt_result_4 = jg.STES___HT
    end
    local ____opt_result_7
    if jg ~= nil then
        ____opt_result_7 = jg.STES_HT
    end
    local ____g_STES___HT_20 = g.STES___HT
    local ____g_STES_HT_21 = g.STES_HT
    local ____opt_result_10
    if jg ~= nil then
        ____opt_result_10 = jg.udg_STES___HT
    end
    local ____opt_result_13
    if jg ~= nil then
        ____opt_result_13 = jg.udg_STES_HT
    end
    local ____opt_result_16
    if jc ~= nil then
        ____opt_result_16 = jc.STES___HT
    end
    local ____opt_result_19
    if jc ~= nil then
        ____opt_result_19 = jc.STES_HT
    end
    local candidates = {
        ____opt_result_4,
        ____opt_result_7,
        ____g_STES___HT_20,
        ____g_STES_HT_21,
        ____opt_result_10,
        ____opt_result_13,
        ____opt_result_16,
        ____opt_result_19
    }
    do
        local i = 0
        while i < #candidates do
            local t = candidates[i + 1]
            if t ~= nil and t ~= 0 then
                return t
            end
            i = i + 1
        end
    end
    return nil
end
local function syncStesGlobals(self, ht)
    if ht == nil then
        return
    end
    if jglobals then
        local jg = jglobals
        if jg.STES___HT == nil or jg.STES___HT == 0 then
            jg.STES___HT = ht
        end
        if jg.STES_HT == nil or jg.STES_HT == 0 then
            jg.STES_HT = ht
        end
    end
    local g = _G
    if g.STES___HT == nil or g.STES___HT == 0 then
        g.STES___HT = ht
    end
    if g.STES_HT == nil or g.STES_HT == 0 then
        g.STES_HT = ht
    end
    g.STES_StarBaseHT = ht
end
--- 初始化 skey_* 常量（只执行一次）
local function ensureStesKeys(self)
    if keysInitialized then
        return
    end
    skey_count = jass.StringHash("count")
    ____exports.skey_count = skey_count
    skey_countEx = jass.StringHash("countEx")
    ____exports.skey_countEx = skey_countEx
    skey_index = jass.StringHash("index")
    ____exports.skey_index = skey_index
    skey_indexEx = jass.StringHash("indexEx")
    ____exports.skey_indexEx = skey_indexEx
    keysInitialized = true
    if jglobals then
        jglobals.STES_skey_index = skey_index
        jglobals.STES_skey_count = skey_count
        jglobals.STES_skey_indexEx = skey_indexEx
        jglobals.STES_skey_countEx = skey_countEx
    end
    local g = _G
    g.STES_skey_index = skey_index
    g.STES_skey_count = skey_count
    g.STES_skey_indexEx = skey_indexEx
    g.STES_skey_countEx = skey_countEx
end
--- 从 JASS 全局重新绑定 STES 表。绝不把新建的 InitHashtable 写入 jglobals.STES___HT，
-- 否则会在 Lua 早于 STES 库绑表时覆盖 JASS 原表，导致 JASS 注册与 Lua 读表不一致（计数恒为 0）。
local function refreshStesBinding(self)
    ensureStesKeys(nil)
    local ht = resolveStesHashtable(nil)
    if ht ~= nil and ht ~= 0 then
        if ht ~= StarBaseHT then
            StarBaseHT = ht
            ____exports.StarBaseHT = StarBaseHT
            syncStesGlobals(nil, ht)
        end
    end
end
--- 无 JASS STES 表时，仅用于纯 Lua 自测；不修改 jglobals.STES___HT / STES_HT
local function ensureLuaOnlyStesTable(self)
    if StarBaseHT ~= nil and StarBaseHT ~= 0 then
        return
    end
    local ht = jass.InitHashtable()
    StarBaseHT = ht
    ____exports.StarBaseHT = StarBaseHT
    local g = _G
    g.STES_LuaOnlyHT = ht
    g.STES_StarBaseHT = ht
end
local function init(self)
    refreshStesBinding(nil)
end
--- 获取自定义事件系统使用的全局哈希表（与 JASS STES_GetTable 相同语义）
function ____exports.STES_GetTable()
    init(nil)
    return StarBaseHT
end
--- 为触发器注册自定义事件
function ____exports.STES_Register(a, b, c)
    init(nil)
    refreshStesBinding(nil)
    if not StarBaseHT then
        ensureLuaOnlyStesTable(nil)
    end
    if not StarBaseHT then
        return
    end
    local t
    local name
    if type(a) == "string" then
        name = a
        t = b
    elseif type(b) == "string" then
        t = a
        name = b
    else
        t = b
        name = c
    end
    if type(name) ~= "string" or t == nil or t == 0 then
        return
    end
    local hash = jass.StringHash(name)
    local hd = jass.GetHandleId(t)
    local index = jass.LoadInteger(StarBaseHT, hash, skey_index)
    local index2 = jass.LoadInteger(StarBaseHT, hd, skey_index)
    jass.SaveTriggerHandle(StarBaseHT, hash, index, t)
    jass.SaveInteger(StarBaseHT, hash, skey_index, index + 1)
    jass.SaveStr(StarBaseHT, hd, index2, name)
    jass.SaveInteger(StarBaseHT, hd, skey_index, index2 + 1)
end
--- RegisterEx：与 zinc STES_RegisterEx 一致（函数字符串 ↔ 事件名字符串，使用 skey_indexEx）
function ____exports.STES_RegisterEx(funcName, eventName)
    init(nil)
    refreshStesBinding(nil)
    if not StarBaseHT then
        ensureLuaOnlyStesTable(nil)
    end
    if not StarBaseHT then
        return
    end
    if type(funcName) ~= "string" or type(eventName) ~= "string" then
        return
    end
    local hash = jass.StringHash(eventName)
    local hd = jass.StringHash(funcName)
    local index = jass.LoadInteger(StarBaseHT, hash, skey_indexEx)
    local index2 = jass.LoadInteger(StarBaseHT, hd, skey_indexEx)
    jass.SaveStr(StarBaseHT, hash, index, funcName)
    jass.SaveInteger(StarBaseHT, hash, skey_indexEx, index + 1)
    jass.SaveStr(StarBaseHT, hd, index2, eventName)
    jass.SaveInteger(StarBaseHT, hd, skey_indexEx, index2 + 1)
end
--- 与 JASS STES_GetUnitEvent 一致：I2S(GetHandleId(u)) + name
function ____exports.STES_GetUnitEvent(u, name)
    if u == nil or u == 0 then
        return name
    end
    return tostring(jass.GetHandleId(u)) .. name
end
--- 与 JASS STES_Execute 一致：仅遍历触发器，Evaluate 通过才 Execute
function ____exports.STES_Execute(name)
    init(nil)
    refreshStesBinding(nil)
    if not StarBaseHT then
        return
    end
    local hash = jass.StringHash(name)
    local index = jass.LoadInteger(StarBaseHT, hash, skey_index)
    local i = 0
    while i < index do
        local t = jass.LoadTriggerHandle(StarBaseHT, hash, i)
        if t then
            if jass.TriggerEvaluate(t) then
                jass.TriggerExecute(t)
            end
        end
        i = i + 1
    end
end
--- STES_Fire：逆天传参 / 返回值链（对应 YDTriggerExecuteTrigger(..., false)）
function ____exports.STES_Fire(name)
    init(nil)
    refreshStesBinding(nil)
    if not StarBaseHT then
        return
    end
    local hash = jass.StringHash(name)
    local loopIndex = jass.LoadInteger(StarBaseHT, hash, skey_index)
    _indexStack[#_indexStack + 1] = getG_SIndex(nil)
    do
        local i = 0
        while i < loopIndex do
            local trg = jass.LoadTriggerHandle(StarBaseHT, hash, i)
            if trg then
                YDLocalExecuteTrigger(nil, trg)
                saveParentIndex(nil, trg)
                YDTriggerExecuteTrigger(nil, trg, false)
            end
            i = i + 1
        end
    end
    local prevIndex = #_indexStack > 0 and table.remove(_indexStack) or 0
    setG_SIndex(nil, prevIndex)
    setG_LIndex(nil, prevIndex)
end
--- 与 JASS 遍历 STES：每轮 YDLocal5Set(real, realParamKey, 0) 后 YDTriggerExecuteTrigger(false)。
-- 子触发内对同名变量名做 YDLocal5Get / YDLocal7Set，父用 YDLocal1Get(real, realParamKey) 读回。
-- realParamKey 必须与 GUI/JASS 里 YDLocal 局部变量名字符串完全一致（可为数字、英文、中文等）。
function ____exports.STES_FireWithReal11Step(name, realParamKey)
    init(nil)
    refreshStesBinding(nil)
    if not StarBaseHT then
        return
    end
    if realParamKey == "" then
        return
    end
    local hash = jass.StringHash(name)
    local loopIndex = jass.LoadInteger(StarBaseHT, hash, skey_index)
    _indexStack[#_indexStack + 1] = getG_SIndex(nil)
    do
        local i = 0
        while i < loopIndex do
            local trg = jass.LoadTriggerHandle(StarBaseHT, hash, i)
            if trg then
                YDLocalExecuteTrigger(nil, trg)
                saveParentIndex(nil, trg)
                YDLocal5Set(nil, "real", realParamKey, 0)
                YDTriggerExecuteTrigger(nil, trg, false)
            end
            i = i + 1
        end
    end
    local prevIndex = #_indexStack > 0 and table.remove(_indexStack) or 0
    setG_SIndex(nil, prevIndex)
    setG_LIndex(nil, prevIndex)
end
--- 清除触发器在 STES 中注册的指定事件名（修正 zinc 中误写 hash 父键的问题）
function ____exports.STES_RemoveEvent(t, targetName)
    init(nil)
    refreshStesBinding(nil)
    if not StarBaseHT or t == nil or t == 0 then
        return
    end
    if type(targetName) ~= "string" or targetName == "" then
        return
    end
    local HT = StarBaseHT
    local hd = jass.GetHandleId(t)
    local evCount = jass.LoadInteger(HT, hd, skey_index)
    local i = 0
    while i < evCount do
        do
            local nm = jass.LoadStr(HT, hd, i)
            if nm == targetName then
                local nameHash = jass.StringHash(nm)
                local a = jass.LoadInteger(HT, nameHash, skey_index)
                local b = 0
                while b < a do
                    local t1 = jass.LoadTriggerHandle(HT, nameHash, b)
                    if t1 == t then
                        a = a - 1
                        local tTop = jass.LoadTriggerHandle(HT, nameHash, a)
                        jass.SaveTriggerHandle(HT, nameHash, b, tTop)
                        jass.SaveInteger(HT, nameHash, skey_index, a)
                        if a >= b then
                            break
                        end
                    end
                    b = b + 1
                end
                jass.SaveStr(
                    HT,
                    hd,
                    i,
                    jass.LoadStr(HT, hd, evCount - 1)
                )
                evCount = evCount - 1
                jass.SaveInteger(HT, hd, skey_index, evCount)
                if i >= evCount then
                    break
                end
                goto __continue55
            end
            i = i + 1
        end
        ::__continue55::
    end
end
--- 清除触发器上绑定的所有 STES 事件
function ____exports.STES_Remove(t)
    init(nil)
    refreshStesBinding(nil)
    if not StarBaseHT or t == nil or t == 0 then
        return
    end
    local HT = StarBaseHT
    local hd = jass.GetHandleId(t)
    local evCount = jass.LoadInteger(HT, hd, skey_index)
    local i = 0
    while i < evCount do
        local nm = jass.LoadStr(HT, hd, i)
        local nameHash = jass.StringHash(nm)
        local a = jass.LoadInteger(HT, nameHash, skey_index)
        local b = 0
        while b < a do
            local t1 = jass.LoadTriggerHandle(HT, nameHash, b)
            if t1 == t then
                a = a - 1
                local tTop = jass.LoadTriggerHandle(HT, nameHash, a)
                jass.SaveTriggerHandle(HT, nameHash, b, tTop)
                jass.SaveInteger(HT, nameHash, skey_index, a)
                if a >= b then
                    break
                end
            end
            b = b + 1
        end
        i = i + 1
    end
    jass.FlushChildHashtable(HT, hd)
end
____exports.StarBaseHT = StarBaseHT
____exports.skey_count = skey_count
____exports.skey_countEx = skey_countEx
____exports.skey_index = skey_index
____exports.skey_indexEx = skey_indexEx
____exports.StarVarStr = StarVarStr
return ____exports
