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
    if type(jass.StringHash) == "function" then
        return jass.StringHash("parentIndex")
    end
    return 0
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
    local ____temp_32
    if type(jass.GetTriggeringTrigger) == "function" then
        ____temp_32 = jass.GetTriggeringTrigger()
    else
        ____temp_32 = nil
    end
    local trig = ____temp_32
    if not trig then
        return 0
    end
    if type(jass.GetHandleId) ~= "function" then
        return 0
    end
    local hd = jass.GetHandleId(trig)
    local sk = ____exports.getSKey_PIndex(nil)
    local ____temp_33
    if type(jass.LoadInteger) == "function" then
        ____temp_33 = jass.LoadInteger(YDHT, hd, sk) or 0
    else
        ____temp_33 = 0
    end
    return ____temp_33
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
    if type(jass.StringHash) == "function" then
        return jass.StringHash("Trigger")
    end
    return 0
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
    if type(jass.StringHash) ~= "function" then
        return 0
    end
    return jass.StringHash(s) or 0
end
local function loadByHash(self, ____type, h, p, c)
    repeat
        local ____switch21 = ____type
        local ____cond21 = ____switch21 == "integer"
        if ____cond21 then
            local ____temp_10
            if type(jass.LoadInteger) == "function" then
                ____temp_10 = jass.LoadInteger(h, p, c)
            else
                ____temp_10 = 0
            end
            return ____temp_10
        end
        ____cond21 = ____cond21 or ____switch21 == "real"
        if ____cond21 then
            local ____temp_11
            if type(jass.LoadReal) == "function" then
                ____temp_11 = jass.LoadReal(h, p, c)
            else
                ____temp_11 = 0
            end
            return ____temp_11
        end
        ____cond21 = ____cond21 or ____switch21 == "boolean"
        if ____cond21 then
            local ____temp_12
            if type(jass.LoadBoolean) == "function" then
                ____temp_12 = jass.LoadBoolean(h, p, c)
            else
                ____temp_12 = false
            end
            return ____temp_12
        end
        ____cond21 = ____cond21 or ____switch21 == "string"
        if ____cond21 then
            local ____temp_13
            if type(jass.LoadStr) == "function" then
                ____temp_13 = jass.LoadStr(h, p, c)
            else
                ____temp_13 = ""
            end
            return ____temp_13
        end
        ____cond21 = ____cond21 or ____switch21 == "unit"
        if ____cond21 then
            local ____temp_14
            if type(jass.LoadUnitHandle) == "function" then
                ____temp_14 = jass.LoadUnitHandle(h, p, c)
            else
                ____temp_14 = nil
            end
            return ____temp_14
        end
        ____cond21 = ____cond21 or ____switch21 == "group"
        if ____cond21 then
            local ____temp_15
            if type(jass.LoadGroupHandle) == "function" then
                ____temp_15 = jass.LoadGroupHandle(h, p, c)
            else
                ____temp_15 = nil
            end
            return ____temp_15
        end
        ____cond21 = ____cond21 or ____switch21 == "timer"
        if ____cond21 then
            local ____temp_16
            if type(jass.LoadTimerHandle) == "function" then
                ____temp_16 = jass.LoadTimerHandle(h, p, c)
            else
                ____temp_16 = nil
            end
            return ____temp_16
        end
        ____cond21 = ____cond21 or ____switch21 == "trigger"
        if ____cond21 then
            local ____temp_17
            if type(jass.LoadTriggerHandle) == "function" then
                ____temp_17 = jass.LoadTriggerHandle(h, p, c)
            else
                ____temp_17 = nil
            end
            return ____temp_17
        end
        ____cond21 = ____cond21 or ____switch21 == "item"
        if ____cond21 then
            local ____temp_18
            if type(jass.LoadItemHandle) == "function" then
                ____temp_18 = jass.LoadItemHandle(h, p, c)
            else
                ____temp_18 = nil
            end
            return ____temp_18
        end
        ____cond21 = ____cond21 or ____switch21 == "player"
        if ____cond21 then
            local ____temp_19
            if type(jass.LoadPlayerHandle) == "function" then
                ____temp_19 = jass.LoadPlayerHandle(h, p, c)
            else
                ____temp_19 = nil
            end
            return ____temp_19
        end
        ____cond21 = ____cond21 or ____switch21 == "location"
        if ____cond21 then
            local ____temp_20
            if type(jass.LoadLocationHandle) == "function" then
                ____temp_20 = jass.LoadLocationHandle(h, p, c)
            else
                ____temp_20 = nil
            end
            return ____temp_20
        end
        ____cond21 = ____cond21 or ____switch21 == "destructable"
        if ____cond21 then
            local ____temp_21
            if type(jass.LoadDestructableHandle) == "function" then
                ____temp_21 = jass.LoadDestructableHandle(h, p, c)
            else
                ____temp_21 = nil
            end
            return ____temp_21
        end
        ____cond21 = ____cond21 or ____switch21 == "force"
        if ____cond21 then
            local ____temp_22
            if type(jass.LoadForceHandle) == "function" then
                ____temp_22 = jass.LoadForceHandle(h, p, c)
            else
                ____temp_22 = nil
            end
            return ____temp_22
        end
        ____cond21 = ____cond21 or ____switch21 == "rect"
        if ____cond21 then
            local ____temp_23
            if type(jass.LoadRectHandle) == "function" then
                ____temp_23 = jass.LoadRectHandle(h, p, c)
            else
                ____temp_23 = nil
            end
            return ____temp_23
        end
        ____cond21 = ____cond21 or ____switch21 == "region"
        if ____cond21 then
            local ____temp_24
            if type(jass.LoadRegionHandle) == "function" then
                ____temp_24 = jass.LoadRegionHandle(h, p, c)
            else
                ____temp_24 = nil
            end
            return ____temp_24
        end
        ____cond21 = ____cond21 or ____switch21 == "sound"
        if ____cond21 then
            local ____temp_25
            if type(jass.LoadSoundHandle) == "function" then
                ____temp_25 = jass.LoadSoundHandle(h, p, c)
            else
                ____temp_25 = nil
            end
            return ____temp_25
        end
        ____cond21 = ____cond21 or ____switch21 == "effect"
        if ____cond21 then
            local ____temp_26
            if type(jass.LoadEffectHandle) == "function" then
                ____temp_26 = jass.LoadEffectHandle(h, p, c)
            else
                ____temp_26 = nil
            end
            return ____temp_26
        end
        do
            return nil
        end
    until true
end
local function saveByHash(self, ____type, h, p, c, value)
    repeat
        local ____switch23 = ____type
        local ____cond23 = ____switch23 == "integer"
        if ____cond23 then
            if type(jass.SaveInteger) == "function" then
                jass.SaveInteger(
                    h,
                    p,
                    c,
                    __TS__Number(value) or 0
                )
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "real"
        if ____cond23 then
            if type(jass.SaveReal) == "function" then
                jass.SaveReal(
                    h,
                    p,
                    c,
                    __TS__Number(value) or 0
                )
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "boolean"
        if ____cond23 then
            if type(jass.SaveBoolean) == "function" then
                jass.SaveBoolean(h, p, c, not not value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "string"
        if ____cond23 then
            if type(jass.SaveStr) == "function" then
                jass.SaveStr(
                    h,
                    p,
                    c,
                    tostring(value)
                )
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "unit"
        if ____cond23 then
            if type(jass.SaveUnitHandle) == "function" then
                jass.SaveUnitHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "group"
        if ____cond23 then
            if type(jass.SaveGroupHandle) == "function" then
                jass.SaveGroupHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "timer"
        if ____cond23 then
            if type(jass.SaveTimerHandle) == "function" then
                jass.SaveTimerHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "trigger"
        if ____cond23 then
            if type(jass.SaveTriggerHandle) == "function" then
                jass.SaveTriggerHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "item"
        if ____cond23 then
            if type(jass.SaveItemHandle) == "function" then
                jass.SaveItemHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "player"
        if ____cond23 then
            if type(jass.SavePlayerHandle) == "function" then
                jass.SavePlayerHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "location"
        if ____cond23 then
            if type(jass.SaveLocationHandle) == "function" then
                jass.SaveLocationHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "destructable"
        if ____cond23 then
            if type(jass.SaveDestructableHandle) == "function" then
                jass.SaveDestructableHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "force"
        if ____cond23 then
            if type(jass.SaveForceHandle) == "function" then
                jass.SaveForceHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "rect"
        if ____cond23 then
            if type(jass.SaveRectHandle) == "function" then
                jass.SaveRectHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "region"
        if ____cond23 then
            if type(jass.SaveRegionHandle) == "function" then
                jass.SaveRegionHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "sound"
        if ____cond23 then
            if type(jass.SaveSoundHandle) == "function" then
                jass.SaveSoundHandle(h, p, c, value)
            end
            return
        end
        ____cond23 = ____cond23 or ____switch23 == "effect"
        if ____cond23 then
            if type(jass.SaveEffectHandle) == "function" then
                jass.SaveEffectHandle(h, p, c, value)
            end
            return
        end
    until true
end
local function defaultForType(self, ____type)
    repeat
        local ____switch42 = ____type
        local ____cond42 = ____switch42 == "integer"
        if ____cond42 then
            return 0
        end
        ____cond42 = ____cond42 or ____switch42 == "real"
        if ____cond42 then
            return 0
        end
        ____cond42 = ____cond42 or ____switch42 == "boolean"
        if ____cond42 then
            return false
        end
        ____cond42 = ____cond42 or ____switch42 == "string"
        if ____cond42 then
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
    local ____temp_27
    if type(jass.GetTriggeringTrigger) == "function" then
        ____temp_27 = jass.GetTriggeringTrigger()
    else
        ____temp_27 = nil
    end
    local trig = ____temp_27
    if not trig or not YDLOC then
        return
    end
    if type(jass.GetHandleId) ~= "function" then
        return
    end
    local hd = jass.GetHandleId(trig)
    local ____temp_28
    if type(jass.LoadInteger) == "function" then
        ____temp_28 = jass.LoadInteger(YDLOC, hd, STEP_KEY)
    else
        ____temp_28 = 0
    end
    local step = ____temp_28
    step = step + 3
    if type(jass.SaveInteger) == "function" then
        jass.SaveInteger(YDLOC, hd, STEP_KEY, step)
        jass.SaveInteger(YDLOC, hd, STEP_KEY2, step)
    end
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
    if YDLOC and sIndex ~= 0 and type(jass.FlushChildHashtable) == "function" then
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
    local ____G_ydl_triggerstep_29 = _G.ydl_triggerstep
    if ____G_ydl_triggerstep_29 == nil then
        ____G_ydl_triggerstep_29 = 0
    end
    local p = ____G_ydl_triggerstep_29
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
    local ____G_ydl_triggerstep_30 = _G.ydl_triggerstep
    if ____G_ydl_triggerstep_30 == nil then
        ____G_ydl_triggerstep_30 = 0
    end
    local p = ____G_ydl_triggerstep_30
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
    local ____G_ydl_triggerstep_31 = _G.ydl_triggerstep
    if ____G_ydl_triggerstep_31 == nil then
        ____G_ydl_triggerstep_31 = 0
    end
    local p = ____G_ydl_triggerstep_31
    if type(p) ~= "number" or p == 0 or p ~= p then
        return
    end
    if type(jass.FlushChildHashtable) == "function" then
        jass.FlushChildHashtable(h, p)
    end
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
    local ____temp_34
    if type(jass.GetTriggeringTrigger) == "function" then
        ____temp_34 = jass.GetTriggeringTrigger()
    else
        ____temp_34 = nil
    end
    local trig = ____temp_34
    if not trig then
        return
    end
    if type(jass.GetHandleId) ~= "function" then
        return
    end
    local hd = jass.GetHandleId(trig)
    local sk = ____exports.getSKey_PIndex(nil)
    if type(jass.RemoveSavedInteger) == "function" then
        jass.RemoveSavedInteger(YDHT, hd, sk)
    end
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
