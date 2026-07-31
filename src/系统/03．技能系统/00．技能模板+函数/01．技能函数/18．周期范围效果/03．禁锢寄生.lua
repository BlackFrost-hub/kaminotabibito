local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____79FB_9664_6301_7EED_4F24_5BB3, _____786E_4FDD_6301_7EED_4F24_5BB3_7CFB_7EDF_542F_52A8, _____6301_7EED_4F24_5BB3_7CFB_7EDFTick, GetUnitAbilityLevel, IsUnitPaused, ATTACK_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, addPeriodicCallback, removePeriodicCallback, getServerTime, _____9020_6210_6301_7EED_4F24_5BB3, debugLogForce, _____6301_7EED_4F24_5BB3_5B9E_4F8B_8868, _____6301_7EED_4F24_5BB3ID_5217_8868, _____6301_7EED_4F24_5BB3_56DE_8C03ID
function _____79FB_9664_6301_7EED_4F24_5BB3(id)
    local _____5B9E_4F8B = _____6301_7EED_4F24_5BB3_5B9E_4F8B_8868[id]
    if _____5B9E_4F8B == nil then
        return
    end
    if _____5B9E_4F8B["调试标签"] ~= nil then
        debugLogForce(
            _____5B9E_4F8B["调试标签"],
            "持续伤害实例移除",
            "实例ID=",
            id,
            "目标=",
            _____5B9E_4F8B["目标单位"],
            "已执行跳数=",
            _____5B9E_4F8B["调试跳数"]
        )
    end
    __TS__Delete(_____6301_7EED_4F24_5BB3_5B9E_4F8B_8868, id)
    local index = __TS__ArrayIndexOf(_____6301_7EED_4F24_5BB3ID_5217_8868, id)
    if index >= 0 then
        __TS__ArraySplice(_____6301_7EED_4F24_5BB3ID_5217_8868, index, 1)
    end
    if #_____6301_7EED_4F24_5BB3ID_5217_8868 == 0 and _____6301_7EED_4F24_5BB3_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____6301_7EED_4F24_5BB3_56DE_8C03ID)
        _____6301_7EED_4F24_5BB3_56DE_8C03ID = 0
    end
end
function _____786E_4FDD_6301_7EED_4F24_5BB3_7CFB_7EDF_542F_52A8()
    if _____6301_7EED_4F24_5BB3_56DE_8C03ID ~= 0 then
        return
    end
    _____6301_7EED_4F24_5BB3_56DE_8C03ID = addPeriodicCallback(100, _____6301_7EED_4F24_5BB3_7CFB_7EDFTick)
end
function _____6301_7EED_4F24_5BB3_7CFB_7EDFTick()
    local now = getServerTime()
    local index = 0
    while index < #_____6301_7EED_4F24_5BB3ID_5217_8868 do
        do
            local id = _____6301_7EED_4F24_5BB3ID_5217_8868[index + 1]
            local _____5B9E_4F8B = _____6301_7EED_4F24_5BB3_5B9E_4F8B_8868[id]
            if _____5B9E_4F8B == nil or _____5B9E_4F8B["目标单位"] == nil or _____5B9E_4F8B["目标单位"] == 0 then
                if _____5B9E_4F8B ~= nil and _____5B9E_4F8B["调试标签"] ~= nil then
                    debugLogForce(_____5B9E_4F8B["调试标签"], "持续伤害跳过并移除：目标句柄无效", "实例ID=", id)
                end
                _____79FB_9664_6301_7EED_4F24_5BB3(id)
                goto __continue20
            end
            if GetUnitAbilityLevel(_____5B9E_4F8B["目标单位"], _____5B9E_4F8B.BuffID) <= 0 then
                if _____5B9E_4F8B["调试标签"] ~= nil then
                    debugLogForce(
                        _____5B9E_4F8B["调试标签"],
                        "持续伤害跳过并移除：原生Buff不存在",
                        "实例ID=",
                        id,
                        "BuffID=",
                        _____5B9E_4F8B.BuffID
                    )
                end
                _____79FB_9664_6301_7EED_4F24_5BB3(id)
                goto __continue20
            end
            if now >= _____5B9E_4F8B["下次伤害时间"] then
                if IsUnitPaused(_____5B9E_4F8B["目标单位"]) then
                    if _____5B9E_4F8B["调试标签"] ~= nil and now - _____5B9E_4F8B["调试上次暂停日志时间"] >= 1000 then
                        _____5B9E_4F8B["调试上次暂停日志时间"] = now
                        debugLogForce(
                            _____5B9E_4F8B["调试标签"],
                            "持续伤害跳过：目标当前被暂停",
                            "实例ID=",
                            id,
                            "目标=",
                            _____5B9E_4F8B["目标单位"],
                            "时间Ms=",
                            now,
                            "下次伤害时间=",
                            _____5B9E_4F8B["下次伤害时间"]
                        )
                    end
                else
                    _____5B9E_4F8B["调试跳数"] = _____5B9E_4F8B["调试跳数"] + 1
                    if _____5B9E_4F8B["调试标签"] ~= nil then
                        debugLogForce(
                            _____5B9E_4F8B["调试标签"],
                            "持续伤害Tick开始",
                            "实例ID=",
                            id,
                            "跳数=",
                            _____5B9E_4F8B["调试跳数"],
                            "时间Ms=",
                            now,
                            "目标=",
                            _____5B9E_4F8B["目标单位"]
                        )
                    end
                    local _____6BCF_8DF3_4F24_5BB3_8BA1_7B97_5668 = _____5B9E_4F8B["每跳伤害计算器"]
                    if _____6BCF_8DF3_4F24_5BB3_8BA1_7B97_5668 ~= nil then
                        local _____4F24_5BB3_7EC4_4EF6_5217_8868 = _____6BCF_8DF3_4F24_5BB3_8BA1_7B97_5668(_____5B9E_4F8B["来源单位"], _____5B9E_4F8B["目标单位"])
                        if _____5B9E_4F8B["调试标签"] ~= nil then
                            debugLogForce(
                                _____5B9E_4F8B["调试标签"],
                                "动态伤害计算器返回",
                                "实例ID=",
                                id,
                                "组件数=",
                                #_____4F24_5BB3_7EC4_4EF6_5217_8868
                            )
                        end
                        do
                            local componentIndex = 0
                            while componentIndex < #_____4F24_5BB3_7EC4_4EF6_5217_8868 do
                                do
                                    local _____4F24_5BB3_7EC4_4EF6 = _____4F24_5BB3_7EC4_4EF6_5217_8868[componentIndex + 1]
                                    if _____4F24_5BB3_7EC4_4EF6 == nil or not (_____4F24_5BB3_7EC4_4EF6["伤害"] > 0) then
                                        if _____5B9E_4F8B["调试标签"] ~= nil then
                                            debugLogForce(
                                                _____5B9E_4F8B["调试标签"],
                                                "伤害组件跳过",
                                                "实例ID=",
                                                id,
                                                "组件索引=",
                                                componentIndex,
                                                "组件有效=",
                                                _____4F24_5BB3_7EC4_4EF6 ~= nil,
                                                "伤害=",
                                                _____4F24_5BB3_7EC4_4EF6 ~= nil and _____4F24_5BB3_7EC4_4EF6["伤害"] or 0
                                            )
                                        end
                                        goto __continue33
                                    end
                                    local applied = _____9020_6210_6301_7EED_4F24_5BB3(
                                        _____5B9E_4F8B["来源单位"],
                                        _____5B9E_4F8B["目标单位"],
                                        _____4F24_5BB3_7EC4_4EF6["伤害"],
                                        _____4F24_5BB3_7EC4_4EF6["伤害类型"],
                                        false,
                                        ATTACK_TYPE_NORMAL,
                                        WEAPON_TYPE_WHOKNOWS
                                    )
                                    if _____5B9E_4F8B["调试标签"] ~= nil then
                                        debugLogForce(
                                            _____5B9E_4F8B["调试标签"],
                                            "伤害组件已结算",
                                            "实例ID=",
                                            id,
                                            "组件索引=",
                                            componentIndex,
                                            "伤害=",
                                            _____4F24_5BB3_7EC4_4EF6["伤害"],
                                            "伤害类型句柄=",
                                            _____4F24_5BB3_7EC4_4EF6["伤害类型"],
                                            "结算返回=",
                                            applied
                                        )
                                    end
                                end
                                ::__continue33::
                                componentIndex = componentIndex + 1
                            end
                        end
                    else
                        local applied = _____9020_6210_6301_7EED_4F24_5BB3(
                            _____5B9E_4F8B["来源单位"],
                            _____5B9E_4F8B["目标单位"],
                            _____5B9E_4F8B["伤害"],
                            _____5B9E_4F8B["伤害类型"],
                            false,
                            ATTACK_TYPE_NORMAL,
                            WEAPON_TYPE_WHOKNOWS
                        )
                        if _____5B9E_4F8B["调试标签"] ~= nil then
                            debugLogForce(
                                _____5B9E_4F8B["调试标签"],
                                "固定伤害已结算",
                                "实例ID=",
                                id,
                                "伤害=",
                                _____5B9E_4F8B["伤害"],
                                "伤害类型句柄=",
                                _____5B9E_4F8B["伤害类型"],
                                "结算返回=",
                                applied
                            )
                        end
                    end
                    _____5B9E_4F8B["下次伤害时间"] = now + _____5B9E_4F8B["伤害间隔毫秒"]
                    if _____5B9E_4F8B["调试标签"] ~= nil then
                        debugLogForce(
                            _____5B9E_4F8B["调试标签"],
                            "持续伤害Tick结束",
                            "实例ID=",
                            id,
                            "下一次伤害时间=",
                            _____5B9E_4F8B["下次伤害时间"]
                        )
                    end
                end
            end
            if index < #_____6301_7EED_4F24_5BB3ID_5217_8868 and _____6301_7EED_4F24_5BB3ID_5217_8868[index + 1] == id then
                index = index + 1
            end
        end
        ::__continue20::
    end
end
local jass = require("jass.common")
GetUnitAbilityLevel = jass.GetUnitAbilityLevel
IsUnitPaused = jass.IsUnitPaused
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setEntanglingRoots = ____require_result_1.SFB_setEntanglingRoots
local SFB_setParasite = ____require_result_1.SFB_setParasite
local ____require_result_2 = require("系统.04．伤害系统.07．持续伤害系统")
_____9020_6210_6301_7EED_4F24_5BB3 = ____require_result_2["造成持续伤害"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_3.debugLogForce
local ____BUFF__7EA0_7F20_6839_987B = 1111844210
local ____BUFF__5BC4_751F = 1112436833
local _____9ED8_8BA4_4F24_5BB3_95F4_9694 = 1
local _____6301_7EED_65F6_95F4_8865_507F = 0.05
_____6301_7EED_4F24_5BB3_5B9E_4F8B_8868 = {}
_____6301_7EED_4F24_5BB3ID_5217_8868 = {}
local _____4E0B_4E00_4E2A_6301_7EED_4F24_5BB3ID = 0
_____6301_7EED_4F24_5BB3_56DE_8C03ID = 0
local function _____8F6C_6570_5B57(value)
    if value == nil or value == false or value == "" then
        return 0
    end
    local n = type(value) == "number" and value or __TS__Number(value)
    return n ~= n and 0 or n
end
local function _____8BFB_53D6_6765_6E90_5355_4F4D(_____53C2_6570)
    local ____53C2_6570__6765_6E90_5355_4F4D_4 = _____53C2_6570["来源单位"]
    if ____53C2_6570__6765_6E90_5355_4F4D_4 == nil then
        ____53C2_6570__6765_6E90_5355_4F4D_4 = _____53C2_6570.BuffSource
    end
    return ____53C2_6570__6765_6E90_5355_4F4D_4
end
local function _____8BFB_53D6_76EE_6807_5355_4F4D(_____53C2_6570)
    local ____53C2_6570__76EE_6807_5355_4F4D_5 = _____53C2_6570["目标单位"]
    if ____53C2_6570__76EE_6807_5355_4F4D_5 == nil then
        ____53C2_6570__76EE_6807_5355_4F4D_5 = _____53C2_6570.BuffTarget
    end
    return ____53C2_6570__76EE_6807_5355_4F4D_5
end
local function _____8BFB_53D6_6301_7EED_65F6_95F4(_____53C2_6570)
    local time = _____8F6C_6570_5B57(_____53C2_6570["持续时间"] or _____53C2_6570.time)
    return time > 0 and time + _____6301_7EED_65F6_95F4_8865_507F or 0
end
local function _____8BFB_53D6_4F24_5BB3_95F4_9694(_____53C2_6570)
    local interval = _____8F6C_6570_5B57(_____53C2_6570["伤害间隔"] or _____53C2_6570.DamageInterval)
    return interval > 0 and interval or _____9ED8_8BA4_4F24_5BB3_95F4_9694
end
local function _____8BFB_53D6_4F24_5BB3_7C7B_578B(_____53C2_6570)
    local ____53C2_6570__4F24_5BB3_7C7B_578B_6 = _____53C2_6570["伤害类型"]
    if ____53C2_6570__4F24_5BB3_7C7B_578B_6 == nil then
        ____53C2_6570__4F24_5BB3_7C7B_578B_6 = _____53C2_6570.DamageType
    end
    local ____53C2_6570__4F24_5BB3_7C7B_578B_6_7 = ____53C2_6570__4F24_5BB3_7C7B_578B_6
    if ____53C2_6570__4F24_5BB3_7C7B_578B_6_7 == nil then
        ____53C2_6570__4F24_5BB3_7C7B_578B_6_7 = DAMAGE_TYPE_PLANT
    end
    return ____53C2_6570__4F24_5BB3_7C7B_578B_6_7
end
local function _____6CE8_518C_6301_7EED_4F24_5BB3(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____4F24_5BB3, _____4F24_5BB3_7C7B_578B, _____4F24_5BB3_95F4_9694, BuffID, _____6BCF_8DF3_4F24_5BB3_8BA1_7B97_5668, _____8C03_8BD5_6807_7B7E)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return 0
    end
    if not (_____4F24_5BB3 > 0) and _____6BCF_8DF3_4F24_5BB3_8BA1_7B97_5668 == nil then
        return 0
    end
    _____4E0B_4E00_4E2A_6301_7EED_4F24_5BB3ID = _____4E0B_4E00_4E2A_6301_7EED_4F24_5BB3ID + 1
    local id = _____4E0B_4E00_4E2A_6301_7EED_4F24_5BB3ID
    local now = getServerTime()
    _____6301_7EED_4F24_5BB3_5B9E_4F8B_8868[id] = {
        ID = id,
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["目标单位"] = _____76EE_6807_5355_4F4D,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = _____4F24_5BB3_7C7B_578B,
        ["每跳伤害计算器"] = _____6BCF_8DF3_4F24_5BB3_8BA1_7B97_5668,
        ["伤害间隔毫秒"] = _____4F24_5BB3_95F4_9694 * 1000,
        ["下次伤害时间"] = now + _____4F24_5BB3_95F4_9694 * 1000,
        BuffID = BuffID,
        ["调试标签"] = _____8C03_8BD5_6807_7B7E,
        ["调试跳数"] = 0,
        ["调试上次暂停日志时间"] = 0
    }
    _____6301_7EED_4F24_5BB3ID_5217_8868[#_____6301_7EED_4F24_5BB3ID_5217_8868 + 1] = id
    _____786E_4FDD_6301_7EED_4F24_5BB3_7CFB_7EDF_542F_52A8()
    return id
end
____exports["施加禁锢"] = function(_____53C2_6570)
    local _____6765_6E90_5355_4F4D = _____8BFB_53D6_6765_6E90_5355_4F4D(_____53C2_6570)
    local _____76EE_6807_5355_4F4D = _____8BFB_53D6_76EE_6807_5355_4F4D(_____53C2_6570)
    local _____6301_7EED_65F6_95F4 = _____8BFB_53D6_6301_7EED_65F6_95F4(_____53C2_6570)
    local _____8C03_8BD5_6807_7B7E = _____53C2_6570["调试标签"]
    if _____8C03_8BD5_6807_7B7E ~= nil then
        debugLogForce(
            _____8C03_8BD5_6807_7B7E,
            "施加禁锢入口",
            "来源=",
            _____6765_6E90_5355_4F4D,
            "目标=",
            _____76EE_6807_5355_4F4D,
            "持续秒=",
            _____6301_7EED_65F6_95F4,
            "伤害=",
            _____8F6C_6570_5B57(_____53C2_6570["伤害"] or _____53C2_6570.HitDamage),
            "伤害间隔秒=",
            _____8BFB_53D6_4F24_5BB3_95F4_9694(_____53C2_6570),
            "有动态计算器=",
            _____53C2_6570["每跳伤害计算器"] ~= nil
        )
    end
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 or _____6301_7EED_65F6_95F4 <= 0 then
        if _____8C03_8BD5_6807_7B7E ~= nil then
            debugLogForce(
                _____8C03_8BD5_6807_7B7E,
                "施加禁锢拒绝",
                "目标句柄有效=",
                _____76EE_6807_5355_4F4D ~= nil and _____76EE_6807_5355_4F4D ~= 0,
                "持续时间有效=",
                _____6301_7EED_65F6_95F4 > 0
            )
        end
        return
    end
    SFB_setEntanglingRoots(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____6301_7EED_65F6_95F4)
    if _____8C03_8BD5_6807_7B7E ~= nil then
        debugLogForce(
            _____8C03_8BD5_6807_7B7E,
            "原生纠缠根须已调用",
            "来源=",
            _____6765_6E90_5355_4F4D,
            "目标=",
            _____76EE_6807_5355_4F4D,
            "持续秒=",
            _____6301_7EED_65F6_95F4
        )
    end
    local _____5B9E_4F8BID = _____6CE8_518C_6301_7EED_4F24_5BB3(
        _____6765_6E90_5355_4F4D,
        _____76EE_6807_5355_4F4D,
        _____8F6C_6570_5B57(_____53C2_6570["伤害"] or _____53C2_6570.HitDamage),
        _____8BFB_53D6_4F24_5BB3_7C7B_578B(_____53C2_6570),
        _____8BFB_53D6_4F24_5BB3_95F4_9694(_____53C2_6570),
        ____BUFF__7EA0_7F20_6839_987B,
        _____53C2_6570["每跳伤害计算器"],
        _____8C03_8BD5_6807_7B7E
    )
    if _____8C03_8BD5_6807_7B7E ~= nil then
        debugLogForce(
            _____8C03_8BD5_6807_7B7E,
            "持续伤害实例已注册",
            "实例ID=",
            _____5B9E_4F8BID,
            "来源=",
            _____6765_6E90_5355_4F4D,
            "目标=",
            _____76EE_6807_5355_4F4D
        )
    end
end
____exports["施加寄生"] = function(_____53C2_6570)
    local _____6765_6E90_5355_4F4D = _____8BFB_53D6_6765_6E90_5355_4F4D(_____53C2_6570)
    local _____76EE_6807_5355_4F4D = _____8BFB_53D6_76EE_6807_5355_4F4D(_____53C2_6570)
    local _____6301_7EED_65F6_95F4 = _____8BFB_53D6_6301_7EED_65F6_95F4(_____53C2_6570)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 or _____6301_7EED_65F6_95F4 <= 0 then
        return
    end
    SFB_setParasite(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____6301_7EED_65F6_95F4)
    _____6CE8_518C_6301_7EED_4F24_5BB3(
        _____6765_6E90_5355_4F4D,
        _____76EE_6807_5355_4F4D,
        _____8F6C_6570_5B57(_____53C2_6570["伤害"] or _____53C2_6570.HitDamage),
        _____8BFB_53D6_4F24_5BB3_7C7B_578B(_____53C2_6570),
        _____8BFB_53D6_4F24_5BB3_95F4_9694(_____53C2_6570),
        ____BUFF__5BC4_751F,
        _____53C2_6570["每跳伤害计算器"]
    )
end
return ____exports
