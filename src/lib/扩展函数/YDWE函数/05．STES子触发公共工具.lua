local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
--- STES 子触发 + YDLocal5 读参 / 父页恢复 — 装备提取、装备回复、Buff/任务桥接等共用。
-- 首参 `_self` 为 TSTL 导出占位，调用处传 `undefined`（勿用冒号调用）。
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_0.YDLocal5Get
local clearStar_PIndex = ____require_result_0.clearStar_PIndex
local flushYDLocal5ParamPage = ____require_result_0.flushYDLocal5ParamPage
local getParentYdlocPageForReturnValue = ____require_result_0.getParentYdlocPageForReturnValue
local setG_SIndex = ____require_result_0.setG_SIndex
local setG_LIndex = ____require_result_0.setG_LIndex
local ____require_result_1 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
local YDLocalExecuteTrigger = ____require_result_1.YDLocalExecuteTrigger
--- 与 JASS 进子触发前一致，避免 ydl_triggerstep 错位导致 YDLocal5Get 全 0
-- 
-- 当 JASS 端触发 STES 事件时，Lua 端的触发器动作被调用，
-- 此时需要执行 YDLocalExecuteTrigger 来同步 ydl_triggerstep，
-- 这样后续的 YDLocal5Get 才能正确读取到 JASS 端传递的参数
function ____exports.ydlStes_syncTriggerStep(self, _self)
    local trg = jass:GetTriggeringTrigger()
    if trg == nil or trg == 0 then
        return
    end
    YDLocalExecuteTrigger(nil, trg)
end
--- 子触发结束前恢复父 G_SIndex/G_LIndex，便于父 YDLocal1Get
function ____exports.ydlStes_restoreParentPage(self, _self)
    local page = getParentYdlocPageForReturnValue(nil)
    if page > 0 then
        setG_SIndex(nil, page)
        setG_LIndex(nil, page)
    end
end
--- 传参子表 Flush + restoreParentPage + clearStar_PIndex，用于子触发 finally
function ____exports.ydlStes_finishChildCleanup(self, _self)
    flushYDLocal5ParamPage(nil)
    ____exports.ydlStes_restoreParentPage(nil, nil)
    clearStar_PIndex(nil)
end
--- YDLocal / LoadReal 可能为 number 或可 tonumber 的 string；无效则 undefined
function ____exports.ydlStes_coerceOptionalNumber(self, _self, v)
    if v == nil then
        return nil
    end
    if type(v) == "number" and v == v then
        return v
    end
    local tn = _G.tonumber
    local t = tn(nil, v)
    if type(t) == "number" and t == t then
        return t
    end
    return nil
end
--- 同上，失败为 0（Buff/装备回复等）
function ____exports.ydlStes_coerceReal(self, _self, v)
    if v == nil then
        return 0
    end
    if type(v) == "number" and v == v and __TS__NumberIsFinite(__TS__Number(v)) then
        return v
    end
    local tn = _G.tonumber
    local t = tn(nil, v)
    if type(t) == "number" and t == t and __TS__NumberIsFinite(__TS__Number(t)) then
        return t
    end
    return 0
end
function ____exports.ydlStes_readString5(self, _self, name)
    local v = YDLocal5Get(nil, "string", name)
    if type(v) == "string" then
        return v
    end
    if v == nil then
        return ""
    end
    return tostring(nil, v)
end
function ____exports.ydlStes_readBoolean5(self, _self, name)
    return YDLocal5Get(nil, "boolean", name) == true
end
function ____exports.ydlStes_readInteger5(self, _self, name)
    local v = YDLocal5Get(nil, "integer", name)
    if type(v) == "number" and v == v then
        return math.floor(v)
    end
    local tn = _G.tonumber
    local t = tn(nil, v)
    if type(t) == "number" and t == t then
        return math.floor(t)
    end
    return 0
end
function ____exports.ydlStes_readUnit5(self, _self, name)
    return YDLocal5Get(nil, "unit", name)
end
function ____exports.ydlStes_readReal5(self, _self, name)
    return ____exports.ydlStes_coerceReal(
        nil,
        _self,
        YDLocal5Get(nil, "real", name)
    )
end
--- 与 JASS `LoadInteger(STES_GetTable(), …, skey_index)` 一致
function ____exports.ydlStes_skeyIndex(self, _self)
    if type(jglobals.STES_skey_index) == "number" and jglobals.STES_skey_index ~= 0 then
        return jglobals.STES_skey_index
    end
    return jass:StringHash("index")
end
--- STES_GetTable 后 Register（与任务/Buff 桥接写法一致）
function ____exports.ydlStes_registerAfterGetTable(self, _self, trig, eventName)
    local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
    local STES_Register = ____require_result_2.STES_Register
    local STES_GetTable = ____require_result_2.STES_GetTable
    if STES_Register == nil then
        return
    end
    STES_GetTable(nil)
    STES_Register(nil, trig, eventName)
end
return ____exports
