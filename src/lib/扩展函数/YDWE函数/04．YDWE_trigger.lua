--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- YDWE 触发器执行相关函数
-- - YDLocalExecuteTrigger: 计算子触发器的 ydl_triggerstep
-- - YDTriggerExecuteTrigger: 执行触发器
-- - saveParentIndex: 保存父索引到 YDHT（用于返回值）
-- 
-- 对应 Hash.h 宏:
--   YDLocalExecuteTrigger(trg)
--   YDTriggerExecuteTrigger(trg, flag)
--   SaveInteger(YDHT, GetHandleId(trg), SKey_PIndex, StarIndex1)
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local getSKey_PIndex = ____require_result_0.getSKey_PIndex
local getSKey_Trigger = ____require_result_0.getSKey_Trigger
local STEP_KEY = ____require_result_0.STEP_KEY
local ydlocHandle = ____require_result_0.ydlocHandle
local ydhtHandle = ____require_result_0.ydhtHandle
local getG_SIndex = ____require_result_0.getG_SIndex
local ____require_result_1 = require("lib.扩展函数.BJ函数.01．触发与事件")
local ConditionalTriggerExecute = ____require_result_1.ConditionalTriggerExecute
local function findYDLOC(self)
    local g = _G
    local function pick(____, name)
        if g[name] ~= nil then
            return g[name]
        end
        if jglobals and jglobals[name] ~= nil then
            return jglobals[name]
        end
        if jass and jass[name] ~= nil then
            return jass[name]
        end
        return nil
    end
    local ____pick_result_2 = pick(nil, "YDLOC")
    if ____pick_result_2 == nil then
        ____pick_result_2 = pick(nil, "YDHASH_HANDLE")
    end
    local ____pick_result_2_3 = ____pick_result_2
    if ____pick_result_2_3 == nil then
        ____pick_result_2_3 = pick(nil, "YDHT")
    end
    local ____pick_result_2_3_4 = ____pick_result_2_3
    if ____pick_result_2_3_4 == nil then
        ____pick_result_2_3_4 = pick(nil, "udg_YDHASH_HANDLE")
    end
    local ____pick_result_2_3_4_5 = ____pick_result_2_3_4
    if ____pick_result_2_3_4_5 == nil then
        ____pick_result_2_3_4_5 = pick(nil, "udg_YDHT")
    end
    return ____pick_result_2_3_4_5
end
local function findYDHT(self)
    local g = _G
    local function pick(____, name)
        if g[name] ~= nil then
            return g[name]
        end
        if jglobals and jglobals[name] ~= nil then
            return jglobals[name]
        end
        if jass and jass[name] ~= nil then
            return jass[name]
        end
        return nil
    end
    local ____pick_result_6 = pick(nil, "YDHT")
    if ____pick_result_6 == nil then
        ____pick_result_6 = pick(nil, "YDHASH_HANDLE")
    end
    local ____pick_result_6_7 = ____pick_result_6
    if ____pick_result_6_7 == nil then
        ____pick_result_6_7 = pick(nil, "udg_YDHT")
    end
    local ____pick_result_6_7_8 = ____pick_result_6_7
    if ____pick_result_6_7_8 == nil then
        ____pick_result_6_7_8 = pick(nil, "udg_YDHASH_HANDLE")
    end
    return ____pick_result_6_7_8
end
--- 设置触发器的局部变量上下文（YDWE 传参索引）
-- 对应 JASS 宏 YDLocalExecuteTrigger(trg)
-- 
-- 逻辑：
--   1. 检查目标触发器是否为逆天触发器（YDLOC 中有 SKey_Trigger 标记）
--      - 是：ydl_triggerstep = GetHandleId(trg)（逆天触发器自管理局部变量）
--   2. 否则：ydl_triggerstep = GetHandleId(trg) * (LoadInteger(YDLOC, hd, STEP_KEY) + 3)
-- 
-- @param trg 目标触发器
function ____exports.YDLocalExecuteTrigger(self, trg)
    if not trg then
        return
    end
    local YDLOC = findYDLOC(nil)
    local hd = jass.GetHandleId(trg)
    if YDLOC and jass.HaveSavedInteger(
        YDLOC,
        hd,
        getSKey_Trigger(nil)
    ) then
        _G.ydl_triggerstep = hd
        return
    end
    local ____YDLOC_9
    if YDLOC then
        ____YDLOC_9 = jass.LoadInteger(YDLOC, hd, STEP_KEY)
    else
        ____YDLOC_9 = 0
    end
    local step = ____YDLOC_9
    _G.ydl_triggerstep = hd * (step + 3)
end
--- 执行触发器
-- 对应 JASS 函数 YDTriggerExecuteTrigger(trg, flag)
-- 
-- @param trg 目标触发器
-- @param flag true=先评估条件再执行，false=直接执行动作
function ____exports.YDTriggerExecuteTrigger(self, trg, flag)
    if not trg then
        return
    end
    if flag then
        ConditionalTriggerExecute(nil, trg)
    else
        jass.TriggerExecute(trg)
    end
end
--- 保存父索引到 YDHT，使子触发器可以通过 YDLocal7Set 写返回值
-- 对应 JASS: SaveInteger(YDHT, GetHandleId(trg), SKey_PIndex, StarIndex1)
-- 
-- StarIndex1 = GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step
-- 在我们的实现中 = 当前 G_SIndex
-- 
-- @param trg 子触发器
function ____exports.saveParentIndex(self, trg)
    if not trg then
        return
    end
    local YDHT = findYDHT(nil)
    if not YDHT then
        return
    end
    local childHd = jass.GetHandleId(trg)
    local parentIndex = getG_SIndex(nil)
    jass.SaveInteger(
        YDHT,
        childHd,
        getSKey_PIndex(nil),
        parentIndex
    )
end
--- 清除子触发器上的父索引
-- 对应 JASS: RemoveSavedInteger(YDHT, GetHandleId(trg), SKey_PIndex)
-- 
-- @param trg 子触发器
function ____exports.removeParentIndex(self, trg)
    if not trg then
        return
    end
    local YDHT = findYDHT(nil)
    if not YDHT then
        return
    end
    local childHd = jass.GetHandleId(trg)
    jass.RemoveSavedInteger(
        YDHT,
        childHd,
        getSKey_PIndex(nil)
    )
end
____exports.findYDHT = findYDHT
return ____exports
