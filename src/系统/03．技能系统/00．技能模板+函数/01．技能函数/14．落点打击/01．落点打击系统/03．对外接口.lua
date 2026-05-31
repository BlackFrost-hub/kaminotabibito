local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.14．落点打击.01．落点打击系统.00．共享")
local _____843D_70B9_6253_51FB_5B9E_4F8B_8868 = ____00_FF0E_5171_4EAB["落点打击实例表"]
local _____63A8_8FDB_4E0B_4E00_4E2A_843D_70B9_6253_51FBID = ____00_FF0E_5171_4EAB["推进下一个落点打击ID"]
local ____01_FF0E_843D_70B9_751F_6210 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.14．落点打击.01．落点打击系统.01．落点生成")
local _____521B_5EFA_843D_70B9_5217_8868 = ____01_FF0E_843D_70B9_751F_6210["创建落点列表"]
local ____02_FF0E_7279_6548_4E0E_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.14．落点打击.01．落点打击系统.02．特效与伤害")
local _____7ED3_7B97_5355_6B21_843D_70B9_4F24_5BB3 = ____02_FF0E_7279_6548_4E0E_4F24_5BB3["结算单次落点伤害"]
local _____521B_5EFA_843D_70B9_63D0_793A_7279_6548 = ____02_FF0E_7279_6548_4E0E_4F24_5BB3["创建落点提示特效"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则")
local _____521B_5EFA_547D_4E2D_89C4_5219_72B6_6001 = ____require_result_1["创建命中规则状态"]
local _____843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2 = 10
local _____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868 = {}
local _____5F85_7ED3_7B97_843D_70B9_5E8F_53F7_5217_8868 = {}
local _____5F85_7ED3_7B97_5230_671F_6BEB_79D2_5217_8868 = {}
local _____843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5_56DE_8C03ID = 0
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
local function _____7ED3_7B97_5230_65F6_843D_70B9(_____5B9E_4F8BID, _____843D_70B9_5E8F_53F7)
    local _____5B9E_4F8B = _____843D_70B9_6253_51FB_5B9E_4F8B_8868[_____5B9E_4F8BID]
    if _____5B9E_4F8B == nil then
        return
    end
    _____7ED3_7B97_5355_6B21_843D_70B9_4F24_5BB3(_____5B9E_4F8B, _____843D_70B9_5E8F_53F7)
    _____5B9E_4F8B["剩余落点数"] = _____5B9E_4F8B["剩余落点数"] - 1
    if _____5B9E_4F8B["剩余落点数"] <= 0 then
        _____7ED3_675F_843D_70B9_6253_51FB_5B9E_4F8B(_____5B9E_4F8B.id)
    end
end
local function _____505C_6B62_843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5()
    if _____843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5_56DE_8C03ID)
    _____843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5_56DE_8C03ID = 0
end
local function ____on_843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #_____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868 do
            if now >= _____5F85_7ED3_7B97_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                _____7ED3_7B97_5230_65F6_843D_70B9(_____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868[i + 1], _____5F85_7ED3_7B97_843D_70B9_5E8F_53F7_5217_8868[i + 1])
            else
                _____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868[writeIndex + 1] = _____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868[i + 1]
                _____5F85_7ED3_7B97_843D_70B9_5E8F_53F7_5217_8868[writeIndex + 1] = _____5F85_7ED3_7B97_843D_70B9_5E8F_53F7_5217_8868[i + 1]
                _____5F85_7ED3_7B97_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____5F85_7ED3_7B97_5230_671F_6BEB_79D2_5217_8868[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868)
            table.remove(_____5F85_7ED3_7B97_843D_70B9_5E8F_53F7_5217_8868)
            table.remove(_____5F85_7ED3_7B97_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
    if #_____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868 <= 0 then
        _____505C_6B62_843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5()
    end
end
local function _____786E_4FDD_843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5()
    if _____843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5_56DE_8C03ID > 0 then
        return
    end
    _____843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5_56DE_8C03ID = addPeriodicCallback(_____843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2, ____on_843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5)
end
local function _____542F_52A8_5355_4E2A_843D_70B9_8BA1_65F6_5668(_____5B9E_4F8BID, _____843D_70B9_5E8F_53F7, _____5EF6_8FDF)
    _____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868[#_____5F85_7ED3_7B97_5B9E_4F8BID_5217_8868 + 1] = _____5B9E_4F8BID
    _____5F85_7ED3_7B97_843D_70B9_5E8F_53F7_5217_8868[#_____5F85_7ED3_7B97_843D_70B9_5E8F_53F7_5217_8868 + 1] = _____843D_70B9_5E8F_53F7
    _____5F85_7ED3_7B97_5230_671F_6BEB_79D2_5217_8868[#_____5F85_7ED3_7B97_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + (_____5EF6_8FDF > 0 and _____5EF6_8FDF * 1000 or 0)
    _____786E_4FDD_843D_70B9_6253_51FB_8BA1_65F6_68C0_67E5()
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
