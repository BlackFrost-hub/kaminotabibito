local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local sym, ydhtHandle, loadStar_PIndex, jass, jglobals
--- 与 war3map 全局 `SKey_PIndex` 对齐：优先读 jglobals，否则 StringHash("parentIndex")
function ____exports.getSKey_PIndex(self)
    local jg = jglobals
    if type(jg.SKey_PIndex) == "number" and jg.SKey_PIndex ~= 0 then
        return jg.SKey_PIndex
    end
    return jass.StringHash("parentIndex")
end
function sym(self, name)
    local ____G_name_1 = _G[name]
    if ____G_name_1 == nil then
        local ____jglobals_0
        if jglobals then
            ____jglobals_0 = jglobals[name]
        else
            ____jglobals_0 = nil
        end
        ____G_name_1 = ____jglobals_0
    end
    local ____G_name_1_3 = ____G_name_1
    if ____G_name_1_3 == nil then
        local ____jass_2
        if jass then
            ____jass_2 = jass[name]
        else
            ____jass_2 = nil
        end
        ____G_name_1_3 = ____jass_2
    end
    return ____G_name_1_3
end
function ydhtHandle(self)
    local ____sym_result_7 = sym(nil, "YDHT")
    if ____sym_result_7 == nil then
        ____sym_result_7 = sym(nil, "YDHASH_HANDLE")
    end
    local ____sym_result_7_8 = ____sym_result_7
    if ____sym_result_7_8 == nil then
        ____sym_result_7_8 = sym(nil, "udg_YDHT")
    end
    local ____sym_result_7_8_9 = ____sym_result_7_8
    if ____sym_result_7_8_9 == nil then
        ____sym_result_7_8_9 = sym(nil, "udg_YDHASH_HANDLE")
    end
    return ____sym_result_7_8_9
end
function loadStar_PIndex(self)
    local YDHT = ydhtHandle(nil)
    if not YDHT then
        return 0
    end
    local trig = jass.GetTriggeringTrigger()
    if not trig then
        return 0
    end
    local hd = jass.GetHandleId(trig)
    local sk = ____exports.getSKey_PIndex(nil)
    return jass.LoadInteger(YDHT, hd, sk) or 0
end
jass = require("jass.common")
jglobals = require("jass.globals")
local STEP_KEY = 3487460470
local STEP_KEY2 = 3974637031
--- 与 war3map 全局 `SKey_Trigger` 对齐
function ____exports.getSKey_Trigger(self)
    local jg = jglobals
    if type(jg.SKey_Trigger) == "number" and jg.SKey_Trigger ~= 0 then
        return jg.SKey_Trigger
    end
    return jass.StringHash("Trigger")
end
local _indexStack = {}
local function ydlocHandle(self)
    local h = sym(nil, "YDLOC")
    if h ~= nil then
        return h
    end
    local ____sym_result_4 = sym(nil, "YDHASH_HANDLE")
    if ____sym_result_4 == nil then
        ____sym_result_4 = sym(nil, "YDHT")
    end
    local ____sym_result_4_5 = ____sym_result_4
    if ____sym_result_4_5 == nil then
        ____sym_result_4_5 = sym(nil, "udg_YDHASH_HANDLE")
    end
    local ____sym_result_4_5_6 = ____sym_result_4_5
    if ____sym_result_4_5_6 == nil then
        ____sym_result_4_5_6 = sym(nil, "udg_YDHT")
    end
    return ____sym_result_4_5_6
end
local function getG_SIndex(self)
    local idx = sym(nil, "G_SIndex")
    return type(idx) == "number" and idx or 0
end
local function setG_SIndex(self, v)
    if jglobals then
        jglobals.G_SIndex = v
    end
    _G.G_SIndex = v
end
local function getG_LIndex(self)
    local idx = sym(nil, "G_LIndex")
    return type(idx) == "number" and idx or 0
end
local function setG_LIndex(self, v)
    if jglobals then
        jglobals.G_LIndex = v
    end
    _G.G_LIndex = v
end
local function sh(self, s)
    return jass.StringHash(s) or 0
end
local function loadByHash(self, ____type, h, p, c)
    repeat
        local ____switch18 = ____type
        local ____cond18 = ____switch18 == "integer"
        if ____cond18 then
            return jass.LoadInteger(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "real"
        if ____cond18 then
            return jass.LoadReal(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "boolean"
        if ____cond18 then
            return jass.LoadBoolean(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "string"
        if ____cond18 then
            return jass.LoadStr(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "unit"
        if ____cond18 then
            return jass.LoadUnitHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "group"
        if ____cond18 then
            return jass.LoadGroupHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "timer"
        if ____cond18 then
            return jass.LoadTimerHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "trigger"
        if ____cond18 then
            return jass.LoadTriggerHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "item"
        if ____cond18 then
            return jass.LoadItemHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "player"
        if ____cond18 then
            return jass.LoadPlayerHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "location"
        if ____cond18 then
            return jass.LoadLocationHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "destructable"
        if ____cond18 then
            return jass.LoadDestructableHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "force"
        if ____cond18 then
            return jass.LoadForceHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "rect"
        if ____cond18 then
            return jass.LoadRectHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "region"
        if ____cond18 then
            return jass.LoadRegionHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "sound"
        if ____cond18 then
            return jass.LoadSoundHandle(h, p, c)
        end
        ____cond18 = ____cond18 or ____switch18 == "effect"
        if ____cond18 then
            return jass.LoadEffectHandle(h, p, c)
        end
        do
            return nil
        end
    until true
end
local function saveByHash(self, ____type, h, p, c, value)
    repeat
        local ____switch20 = ____type
        local ____cond20 = ____switch20 == "integer"
        if ____cond20 then
            jass.SaveInteger(
                h,
                p,
                c,
                __TS__Number(value) or 0
            )
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "real"
        if ____cond20 then
            jass.SaveReal(
                h,
                p,
                c,
                __TS__Number(value) or 0
            )
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "boolean"
        if ____cond20 then
            jass.SaveBoolean(h, p, c, not not value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "string"
        if ____cond20 then
            jass.SaveStr(
                h,
                p,
                c,
                tostring(value)
            )
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "unit"
        if ____cond20 then
            jass.SaveUnitHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "group"
        if ____cond20 then
            jass.SaveGroupHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "timer"
        if ____cond20 then
            jass.SaveTimerHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "trigger"
        if ____cond20 then
            jass.SaveTriggerHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "item"
        if ____cond20 then
            jass.SaveItemHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "player"
        if ____cond20 then
            jass.SavePlayerHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "location"
        if ____cond20 then
            jass.SaveLocationHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "destructable"
        if ____cond20 then
            jass.SaveDestructableHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "force"
        if ____cond20 then
            jass.SaveForceHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "rect"
        if ____cond20 then
            jass.SaveRectHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "region"
        if ____cond20 then
            jass.SaveRegionHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "sound"
        if ____cond20 then
            jass.SaveSoundHandle(h, p, c, value)
            return
        end
        ____cond20 = ____cond20 or ____switch20 == "effect"
        if ____cond20 then
            jass.SaveEffectHandle(h, p, c, value)
            return
        end
    until true
end
local function defaultForType(self, ____type)
    repeat
        local ____switch22 = ____type
        local ____cond22 = ____switch22 == "integer"
        if ____cond22 then
            return 0
        end
        ____cond22 = ____cond22 or ____switch22 == "real"
        if ____cond22 then
            return 0
        end
        ____cond22 = ____cond22 or ____switch22 == "boolean"
        if ____cond22 then
            return false
        end
        ____cond22 = ____cond22 or ____switch22 == "string"
        if ____cond22 then
            return ""
        end
        do
            return nil
        end
    until true
end
--- YDLocalInitialize - 初始化局部变量上下文
-- 对应 JASS 宏 YDLocalInitialize()
-- - 递增当前触发器的 step 计数
-- - 保存 G_SIndex 到栈
-- - 设置 G_SIndex = GetHandleId(GetTriggeringTrigger()) * step
-- - 设置 G_LIndex = G_SIndex
function ____exports.YDLocalInitialize(self)
    local YDLOC = ydlocHandle(nil)
    local trig = jass.GetTriggeringTrigger()
    if not trig or not YDLOC then
        return
    end
    local hd = jass.GetHandleId(trig)
    local step = jass.LoadInteger(YDLOC, hd, STEP_KEY)
    step = step + 3
    jass.SaveInteger(YDLOC, hd, STEP_KEY, step)
    jass.SaveInteger(YDLOC, hd, STEP_KEY2, step)
    _indexStack[#_indexStack + 1] = getG_SIndex(nil)
    local newSIndex = hd * step
    setG_SIndex(nil, newSIndex)
    setG_LIndex(nil, newSIndex)
end
--- YDLocal1Release - 释放局部变量上下文
-- 对应 JASS 宏 YDLocal1Release()
-- - 清除当前触发器的局部变量表
-- - 从栈恢复 G_SIndex / G_LIndex
function ____exports.YDLocal1Release(self)
    local YDLOC = ydlocHandle(nil)
    local sIndex = getG_SIndex(nil)
    if YDLOC and sIndex ~= 0 then
        jass.FlushChildHashtable(YDLOC, sIndex)
    end
    local prevIndex = #_indexStack > 0 and table.remove(_indexStack) or 0
    setG_SIndex(nil, prevIndex)
    setG_LIndex(nil, prevIndex)
end
--- YDLocal1Get - 从 YDLOC 读取局部变量（使用 G_LIndex）
-- 对应宏: YDHashGet(YDLOC, type, G_LIndex, StringHash(name))
function ____exports.YDLocal1Get(self, ____type, name)
    local h = ydlocHandle(nil)
    if not h then
        return defaultForType(nil, ____type)
    end
    local p = getG_LIndex(nil)
    local c = sh(nil, name)
    return loadByHash(
        nil,
        ____type,
        h,
        p,
        c
    )
end
--- YDLocal1Set - 向 YDLOC 写入局部变量（使用 G_SIndex）
-- 对应宏: YDHashSet(YDLOC, type, G_SIndex, StringHash(name), value)
function ____exports.YDLocal1Set(self, ____type, name, value)
    local h = ydlocHandle(nil)
    if not h then
        return
    end
    local p = getG_SIndex(nil)
    local c = sh(nil, name)
    saveByHash(
        nil,
        ____type,
        h,
        p,
        c,
        value
    )
end
--- YDLocalSet - 向 YDLOC 写入局部变量（使用 G_SIndex，带 page 参数但忽略）
-- 对应宏: YDHashSet(YDLOC, type, G_SIndex, StringHash(name), value)
function ____exports.YDLocalSet(self, page, ____type, name, value)
    local h = ydlocHandle(nil)
    if not h then
        return
    end
    local p = getG_SIndex(nil)
    local c = sh(nil, name)
    saveByHash(
        nil,
        ____type,
        h,
        p,
        c,
        value
    )
end
--- YDLocal5Set - 传参：向子触发器的参数区写入
-- 对应宏: YDHashSet(YDLOC, type, ydl_triggerstep, StringHash(name), value)
-- ydl_triggerstep 由 YDLocalExecuteTrigger 设置
function ____exports.YDLocal5Set(self, ____type, name, value)
    local h = ydlocHandle(nil)
    if not h then
        return
    end
    local ____G_ydl_triggerstep_10 = _G.ydl_triggerstep
    if ____G_ydl_triggerstep_10 == nil then
        ____G_ydl_triggerstep_10 = 0
    end
    local p = ____G_ydl_triggerstep_10
    local c = sh(nil, name)
    saveByHash(
        nil,
        ____type,
        h,
        p,
        c,
        value
    )
end
--- YDLocal5Get - 传参：从参数区读取
-- 对应宏: YDHashGet(YDLOC, type, ydl_triggerstep, StringHash(name))
function ____exports.YDLocal5Get(self, ____type, name)
    local h = ydlocHandle(nil)
    if not h then
        return defaultForType(nil, ____type)
    end
    local ____G_ydl_triggerstep_11 = _G.ydl_triggerstep
    if ____G_ydl_triggerstep_11 == nil then
        ____G_ydl_triggerstep_11 = 0
    end
    local p = ____G_ydl_triggerstep_11
    local c = sh(nil, name)
    return loadByHash(
        nil,
        ____type,
        h,
        p,
        c
    )
end
--- 清除当前 YDLocal5 传参区：FlushChildHashtable(YDLOC, ydl_triggerstep)。
-- 与 YDLocal1Release 不同：不修改 G_SIndex、不弹 _indexStack。
-- 纯 Lua 子触发读完参（及可选 YDLocal7Set，写的是父页 Star_PIndex）后调用，避免传参键长期挂在子树上。
function ____exports.flushYDLocal5ParamPage(self)
    local h = ydlocHandle(nil)
    if not h then
        return
    end
    local ____G_ydl_triggerstep_12 = _G.ydl_triggerstep
    if ____G_ydl_triggerstep_12 == nil then
        ____G_ydl_triggerstep_12 = 0
    end
    local p = ____G_ydl_triggerstep_12
    if type(p) ~= "number" or p == 0 or p ~= p then
        return
    end
    jass.FlushChildHashtable(h, p)
end
--- YDLocal7Set - 返回值：写入到父级局部变量表
-- 对应宏: YDHashSet(YDLOC, type, Star_PIndex, StringHash(name), value)
-- Star_PIndex 从 YDHT 中读取（由调用方保存）
function ____exports.YDLocal7Set(self, ____type, name, value)
    local h = ydlocHandle(nil)
    if not h then
        return
    end
    local p = loadStar_PIndex(nil)
    local c = sh(nil, name)
    saveByHash(
        nil,
        ____type,
        h,
        p,
        c,
        value
    )
end
--- YDLocal7Get - 返回值：从父级局部变量表读取
-- 对应宏: YDHashGet(YDLOC, type, Star_PIndex, StringHash(name))
function ____exports.YDLocal7Get(self, ____type, name)
    local h = ydlocHandle(nil)
    if not h then
        return defaultForType(nil, ____type)
    end
    local p = loadStar_PIndex(nil)
    local c = sh(nil, name)
    return loadByHash(
        nil,
        ____type,
        h,
        p,
        c
    )
end
--- 子触发内：YDHT 为当前子触发保存的「父 YDLOC 页码」，与 YDLocal7Set 写入目标一致。
-- 部分 Lua 回调返回父 JASS 时 G_SIndex/G_LIndex 未恢复，父 YDLocal1Get 会读错页；可在 YDLocal7Set 后 setG_* 与此值对齐。
function ____exports.getParentYdlocPageForReturnValue(self, _self)
    return loadStar_PIndex(nil)
end
--- 清除当前触发器的 Star_PIndex
-- 对应 JASS: RemoveSavedInteger(YDHT, GetHandleId(GetTriggeringTrigger()), SKey_PIndex)
function ____exports.clearStar_PIndex(self)
    local YDHT = ydhtHandle(nil)
    if not YDHT then
        return
    end
    local trig = jass.GetTriggeringTrigger()
    if not trig then
        return
    end
    local hd = jass.GetHandleId(trig)
    local sk = ____exports.getSKey_PIndex(nil)
    jass.RemoveSavedInteger(YDHT, hd, sk)
end
____exports.STEP_KEY = STEP_KEY
____exports.STEP_KEY2 = STEP_KEY2
____exports.ydlocHandle = ydlocHandle
____exports.ydhtHandle = ydhtHandle
____exports.getG_SIndex = getG_SIndex
____exports.setG_SIndex = setG_SIndex
____exports.getG_LIndex = getG_LIndex
____exports.setG_LIndex = setG_LIndex
____exports._indexStack = _indexStack
return ____exports
