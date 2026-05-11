local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.14．落点打击.01．落点打击系统.00．共享")
local CreateTimer = ____00_FF0E_5171_4EAB.CreateTimer
local GetExpiredTimer = ____00_FF0E_5171_4EAB.GetExpiredTimer
local GetHandleId = ____00_FF0E_5171_4EAB.GetHandleId
local _____843D_70B9_6253_51FB_5B9E_4F8B_8868 = ____00_FF0E_5171_4EAB["落点打击实例表"]
local _____843D_70B9_6253_51FB_5B9A_65F6_5668_4E0A_4E0B_6587_8868 = ____00_FF0E_5171_4EAB["落点打击定时器上下文表"]
local _____63A8_8FDB_4E0B_4E00_4E2A_843D_70B9_6253_51FBID = ____00_FF0E_5171_4EAB["推进下一个落点打击ID"]
local ____01_FF0E_843D_70B9_751F_6210 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.14．落点打击.01．落点打击系统.01．落点生成")
local _____521B_5EFA_843D_70B9_5217_8868 = ____01_FF0E_843D_70B9_751F_6210["创建落点列表"]
local ____02_FF0E_7279_6548_4E0E_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.14．落点打击.01．落点打击系统.02．特效与伤害")
local _____7ED3_7B97_5355_6B21_843D_70B9_4F24_5BB3 = ____02_FF0E_7279_6548_4E0E_4F24_5BB3["结算单次落点伤害"]
local _____521B_5EFA_843D_70B9_63D0_793A_7279_6548 = ____02_FF0E_7279_6548_4E0E_4F24_5BB3["创建落点提示特效"]
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则.00．命中规则模板")
local _____521B_5EFA_547D_4E2D_89C4_5219_72B6_6001 = ____require_result_1["创建命中规则状态"]
local function _____7ED3_675F_843D_70B9_6253_51FB_5B9E_4F8B(_____5B9E_4F8BID)
    local _____5B9E_4F8B = _____843D_70B9_6253_51FB_5B9E_4F8B_8868[_____5B9E_4F8BID]
    if _____5B9E_4F8B == nil then
        return
    end
    __TS__Delete(_____843D_70B9_6253_51FB_5B9E_4F8B_8868, _____5B9E_4F8BID)
    local ____opt_2 = _____5B9E_4F8B["参数"]["on全部完成"]
    if ____opt_2 ~= nil then
        ____opt_2(_____5B9E_4F8BID)
    end
end
local function ____on_843D_70B9_6253_51FB_5B9A_65F6_5668_5230_65F6()
    local t = GetExpiredTimer()
    if not t then
        return
    end
    local _____5B9A_65F6_5668ID = GetHandleId(t)
    local _____4E0A_4E0B_6587 = _____843D_70B9_6253_51FB_5B9A_65F6_5668_4E0A_4E0B_6587_8868[_____5B9A_65F6_5668ID]
    __TS__Delete(_____843D_70B9_6253_51FB_5B9A_65F6_5668_4E0A_4E0B_6587_8868, _____5B9A_65F6_5668ID)
    safeDestroyTimer(t)
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    local _____5B9E_4F8B = _____843D_70B9_6253_51FB_5B9E_4F8B_8868[_____4E0A_4E0B_6587["实例ID"]]
    if _____5B9E_4F8B == nil then
        return
    end
    _____7ED3_7B97_5355_6B21_843D_70B9_4F24_5BB3(_____5B9E_4F8B, _____4E0A_4E0B_6587["落点序号"])
    _____5B9E_4F8B["剩余落点数"] = _____5B9E_4F8B["剩余落点数"] - 1
    if _____5B9E_4F8B["剩余落点数"] <= 0 then
        _____7ED3_675F_843D_70B9_6253_51FB_5B9E_4F8B(_____5B9E_4F8B.id)
    end
end
local function _____542F_52A8_5355_4E2A_843D_70B9_8BA1_65F6_5668(_____5B9E_4F8BID, _____843D_70B9_5E8F_53F7, _____5EF6_8FDF)
    local t = CreateTimer()
    if not t then
        return
    end
    _____843D_70B9_6253_51FB_5B9A_65F6_5668_4E0A_4E0B_6587_8868[GetHandleId(t)] = {["实例ID"] = _____5B9E_4F8BID, ["落点序号"] = _____843D_70B9_5E8F_53F7}
    safeTimerStart(t, _____5EF6_8FDF, false, ____on_843D_70B9_6253_51FB_5B9A_65F6_5668_5230_65F6)
end
____exports["创建落点打击"] = function(_____53C2_6570)
    if _____53C2_6570["伤害半径"] <= 0 then
        return 0
    end
    local _____843D_70B9_5217_8868 = _____521B_5EFA_843D_70B9_5217_8868(_____53C2_6570)
    if #_____843D_70B9_5217_8868 <= 0 then
        return 0
    end
    local _____5B9E_4F8BID = _____63A8_8FDB_4E0B_4E00_4E2A_843D_70B9_6253_51FBID()
    local _____5B9E_4F8B = {
        id = _____5B9E_4F8BID,
        ["参数"] = _____53C2_6570,
        ["落点列表"] = _____843D_70B9_5217_8868,
        ["剩余落点数"] = #_____843D_70B9_5217_8868,
        ["命中规则状态"] = _____521B_5EFA_547D_4E2D_89C4_5219_72B6_6001({["每单位最大命中次数"] = _____53C2_6570["每单位最大命中次数"]})
    }
    _____843D_70B9_6253_51FB_5B9E_4F8B_8868[_____5B9E_4F8BID] = _____5B9E_4F8B
    local i = 0
    while i < #_____843D_70B9_5217_8868 do
        local _____843D_70B9 = _____843D_70B9_5217_8868[i + 1]
        _____521B_5EFA_843D_70B9_63D0_793A_7279_6548(_____53C2_6570, _____843D_70B9)
        _____542F_52A8_5355_4E2A_843D_70B9_8BA1_65F6_5668(_____5B9E_4F8BID, i, _____843D_70B9["触发延迟"] > 0 and _____843D_70B9["触发延迟"] or 0)
        i = i + 1
    end
    return _____5B9E_4F8BID
end
return ____exports
