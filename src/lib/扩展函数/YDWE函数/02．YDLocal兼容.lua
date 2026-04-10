local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
--- YDLocal 兼容层
-- - 实现 Hash.h 中的 YDLocal1Get / YDLocal1Set / YDLocalSet 宏
-- - 供配置表达式 / 旧JASS风格调用直接使用
local jass = require("jass.common")
local jglobals = require("jass.globals")
--- 获取符号（从 globalThis / jglobals / jass 中查找）
local function sym(self, name)
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
--- 获取 YDLOC 哈希表句柄
local function ydlocHandle(self)
    local h = sym(nil, "YDLOC")
    if h == nil then
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
    return h
end
--- 获取 G_SIndex 全局索引
local function getG_SIndex(self)
    local idx = sym(nil, "G_SIndex")
    return type(idx) == "number" and idx or 0
end
--- 获取 G_LIndex 全局索引
local function getG_LIndex(self)
    local idx = sym(nil, "G_LIndex")
    return type(idx) == "number" and idx or 0
end
--- StringHash 封装
local function sh(self, s)
    if type(jass.StringHash) ~= "function" then
        return 0
    end
    return jass.StringHash(s) or 0
end
--- 从哈希表加载数据
local function loadByHash(self, ____type, h, p, c)
    repeat
        local ____switch10 = ____type
        local ____cond10 = ____switch10 == "integer"
        if ____cond10 then
            local ____temp_7
            if type(jass.LoadInteger) == "function" then
                ____temp_7 = jass.LoadInteger(h, p, c)
            else
                ____temp_7 = 0
            end
            return ____temp_7
        end
        ____cond10 = ____cond10 or ____switch10 == "real"
        if ____cond10 then
            local ____temp_8
            if type(jass.LoadReal) == "function" then
                ____temp_8 = jass.LoadReal(h, p, c)
            else
                ____temp_8 = 0
            end
            return ____temp_8
        end
        ____cond10 = ____cond10 or ____switch10 == "boolean"
        if ____cond10 then
            local ____temp_9
            if type(jass.LoadBoolean) == "function" then
                ____temp_9 = jass.LoadBoolean(h, p, c)
            else
                ____temp_9 = false
            end
            return ____temp_9
        end
        ____cond10 = ____cond10 or ____switch10 == "string"
        if ____cond10 then
            local ____temp_10
            if type(jass.LoadStr) == "function" then
                ____temp_10 = jass.LoadStr(h, p, c)
            else
                ____temp_10 = ""
            end
            return ____temp_10
        end
        ____cond10 = ____cond10 or ____switch10 == "unit"
        if ____cond10 then
            local ____temp_11
            if type(jass.LoadUnitHandle) == "function" then
                ____temp_11 = jass.LoadUnitHandle(h, p, c)
            else
                ____temp_11 = nil
            end
            return ____temp_11
        end
        ____cond10 = ____cond10 or ____switch10 == "group"
        if ____cond10 then
            local ____temp_12
            if type(jass.LoadGroupHandle) == "function" then
                ____temp_12 = jass.LoadGroupHandle(h, p, c)
            else
                ____temp_12 = nil
            end
            return ____temp_12
        end
        ____cond10 = ____cond10 or ____switch10 == "timer"
        if ____cond10 then
            local ____temp_13
            if type(jass.LoadTimerHandle) == "function" then
                ____temp_13 = jass.LoadTimerHandle(h, p, c)
            else
                ____temp_13 = nil
            end
            return ____temp_13
        end
        ____cond10 = ____cond10 or ____switch10 == "trigger"
        if ____cond10 then
            local ____temp_14
            if type(jass.LoadTriggerHandle) == "function" then
                ____temp_14 = jass.LoadTriggerHandle(h, p, c)
            else
                ____temp_14 = nil
            end
            return ____temp_14
        end
        ____cond10 = ____cond10 or ____switch10 == "item"
        if ____cond10 then
            local ____temp_15
            if type(jass.LoadItemHandle) == "function" then
                ____temp_15 = jass.LoadItemHandle(h, p, c)
            else
                ____temp_15 = nil
            end
            return ____temp_15
        end
        ____cond10 = ____cond10 or ____switch10 == "player"
        if ____cond10 then
            local ____temp_16
            if type(jass.LoadPlayerHandle) == "function" then
                ____temp_16 = jass.LoadPlayerHandle(h, p, c)
            else
                ____temp_16 = nil
            end
            return ____temp_16
        end
        ____cond10 = ____cond10 or ____switch10 == "location"
        if ____cond10 then
            local ____temp_17
            if type(jass.LoadLocationHandle) == "function" then
                ____temp_17 = jass.LoadLocationHandle(h, p, c)
            else
                ____temp_17 = nil
            end
            return ____temp_17
        end
        ____cond10 = ____cond10 or ____switch10 == "destructable"
        if ____cond10 then
            local ____temp_18
            if type(jass.LoadDestructableHandle) == "function" then
                ____temp_18 = jass.LoadDestructableHandle(h, p, c)
            else
                ____temp_18 = nil
            end
            return ____temp_18
        end
        ____cond10 = ____cond10 or ____switch10 == "force"
        if ____cond10 then
            local ____temp_19
            if type(jass.LoadForceHandle) == "function" then
                ____temp_19 = jass.LoadForceHandle(h, p, c)
            else
                ____temp_19 = nil
            end
            return ____temp_19
        end
        ____cond10 = ____cond10 or ____switch10 == "rect"
        if ____cond10 then
            local ____temp_20
            if type(jass.LoadRectHandle) == "function" then
                ____temp_20 = jass.LoadRectHandle(h, p, c)
            else
                ____temp_20 = nil
            end
            return ____temp_20
        end
        ____cond10 = ____cond10 or ____switch10 == "region"
        if ____cond10 then
            local ____temp_21
            if type(jass.LoadRegionHandle) == "function" then
                ____temp_21 = jass.LoadRegionHandle(h, p, c)
            else
                ____temp_21 = nil
            end
            return ____temp_21
        end
        ____cond10 = ____cond10 or ____switch10 == "sound"
        if ____cond10 then
            local ____temp_22
            if type(jass.LoadSoundHandle) == "function" then
                ____temp_22 = jass.LoadSoundHandle(h, p, c)
            else
                ____temp_22 = nil
            end
            return ____temp_22
        end
        ____cond10 = ____cond10 or ____switch10 == "effect"
        if ____cond10 then
            local ____temp_23
            if type(jass.LoadEffectHandle) == "function" then
                ____temp_23 = jass.LoadEffectHandle(h, p, c)
            else
                ____temp_23 = nil
            end
            return ____temp_23
        end
        do
            return nil
        end
    until true
end
--- 保存数据到哈希表
local function saveByHash(self, ____type, h, p, c, value)
    repeat
        local ____switch12 = ____type
        local ____cond12 = ____switch12 == "integer"
        if ____cond12 then
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
        ____cond12 = ____cond12 or ____switch12 == "real"
        if ____cond12 then
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
        ____cond12 = ____cond12 or ____switch12 == "boolean"
        if ____cond12 then
            if type(jass.SaveBoolean) == "function" then
                jass.SaveBoolean(h, p, c, not not value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "string"
        if ____cond12 then
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
        ____cond12 = ____cond12 or ____switch12 == "unit"
        if ____cond12 then
            if type(jass.SaveUnitHandle) == "function" then
                jass.SaveUnitHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "group"
        if ____cond12 then
            if type(jass.SaveGroupHandle) == "function" then
                jass.SaveGroupHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "timer"
        if ____cond12 then
            if type(jass.SaveTimerHandle) == "function" then
                jass.SaveTimerHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "trigger"
        if ____cond12 then
            if type(jass.SaveTriggerHandle) == "function" then
                jass.SaveTriggerHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "item"
        if ____cond12 then
            if type(jass.SaveItemHandle) == "function" then
                jass.SaveItemHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "player"
        if ____cond12 then
            if type(jass.SavePlayerHandle) == "function" then
                jass.SavePlayerHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "location"
        if ____cond12 then
            if type(jass.SaveLocationHandle) == "function" then
                jass.SaveLocationHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "destructable"
        if ____cond12 then
            if type(jass.SaveDestructableHandle) == "function" then
                jass.SaveDestructableHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "force"
        if ____cond12 then
            if type(jass.SaveForceHandle) == "function" then
                jass.SaveForceHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "rect"
        if ____cond12 then
            if type(jass.SaveRectHandle) == "function" then
                jass.SaveRectHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "region"
        if ____cond12 then
            if type(jass.SaveRegionHandle) == "function" then
                jass.SaveRegionHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "sound"
        if ____cond12 then
            if type(jass.SaveSoundHandle) == "function" then
                jass.SaveSoundHandle(h, p, c, value)
            end
            return
        end
        ____cond12 = ____cond12 or ____switch12 == "effect"
        if ____cond12 then
            if type(jass.SaveEffectHandle) == "function" then
                jass.SaveEffectHandle(h, p, c, value)
            end
            return
        end
    until true
end
--- YDLocal1Get - 从 YDLOC 读取局部变量（使用 G_LIndex）
-- 对应宏: YDHashGet(YDLOC, type, G_LIndex, StringHash(name))
function ____exports.YDLocal1Get(self, ____type, name)
    local h = ydlocHandle(nil)
    if not h then
        local ____temp_24
        if ____type == "boolean" then
            ____temp_24 = false
        else
            ____temp_24 = ____type == "string" and "" or (____type == "real" and 0 or nil)
        end
        return ____temp_24
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
return ____exports
