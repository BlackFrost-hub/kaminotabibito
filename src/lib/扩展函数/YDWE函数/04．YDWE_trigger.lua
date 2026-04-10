--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local STEP_KEY = 3487460470
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
    local ____pick_result_0 = pick(nil, "YDLOC")
    if ____pick_result_0 == nil then
        ____pick_result_0 = pick(nil, "YDHASH_HANDLE")
    end
    local ____pick_result_0_1 = ____pick_result_0
    if ____pick_result_0_1 == nil then
        ____pick_result_0_1 = pick(nil, "YDHT")
    end
    local ____pick_result_0_1_2 = ____pick_result_0_1
    if ____pick_result_0_1_2 == nil then
        ____pick_result_0_1_2 = pick(nil, "udg_YDHASH_HANDLE")
    end
    local ____pick_result_0_1_2_3 = ____pick_result_0_1_2
    if ____pick_result_0_1_2_3 == nil then
        ____pick_result_0_1_2_3 = pick(nil, "udg_YDHT")
    end
    return ____pick_result_0_1_2_3
end
--- 设置触发器的局部变量上下文（YDWE 传参索引）
-- 对应 JASS 宏 YDLocalExecuteTrigger(trg)
-- 
-- @param trg 目标触发器
function ____exports.YDLocalExecuteTrigger(self, trg)
    if not trg then
        return
    end
    if type(jass.GetHandleId) ~= "function" then
        return
    end
    local YDLOC = findYDLOC(nil)
    if not YDLOC then
        return
    end
    local hd = jass.GetHandleId(trg)
    local step = jass.LoadInteger(YDLOC, hd, STEP_KEY)
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
        if type(jass.ConditionalTriggerExecute) == "function" then
            jass.ConditionalTriggerExecute(trg)
        end
    else
        if type(jass.TriggerExecute) == "function" then
            jass.TriggerExecute(trg)
        end
    end
end
return ____exports
