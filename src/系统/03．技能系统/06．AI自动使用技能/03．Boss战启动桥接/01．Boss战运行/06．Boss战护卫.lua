local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5355_4F4D_662F_5426_6B7B_4EA1, _____83B7_53D6_62A4_536B_5BF9_767D_6765_6E90_5355_4F4D, IsUnitType, UNIT_TYPE_DEAD
local ____05_FF0EBoss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.05．Boss战斗启动护卫配置表")
local ____Boss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 = ____05_FF0EBoss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868["Boss战斗启动护卫配置表"]
local ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.getServerTime
local ____07_FF0EBoss_5F31_70B9_4E8B_4EF6_6865_63A5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.07．Boss弱点事件桥接")
local _____542F_52A8Boss_62A4_536B_8840_6761_5F31_70B9_97E7_6027 = ____07_FF0EBoss_5F31_70B9_4E8B_4EF6_6865_63A5["启动Boss护卫血条弱点韧性"]
local _____7ED3_675FBoss_62A4_536B_8840_6761_5F31_70B9_97E7_6027 = ____07_FF0EBoss_5F31_70B9_4E8B_4EF6_6865_63A5["结束Boss护卫血条弱点韧性"]
function _____5355_4F4D_662F_5426_6B7B_4EA1(unit)
    if unit == nil or unit == 0 then
        return true
    end
    return IsUnitType(unit, UNIT_TYPE_DEAD)
end
function _____83B7_53D6_62A4_536B_5BF9_767D_6765_6E90_5355_4F4D(context, _____8FD0_884C_4E0A_4E0B_6587, _____8BF4_8BDD_8005)
    if _____8BF4_8BDD_8005 == "Boss" then
        return context["Boss单位"]
    end
    do
        local i = 0
        while i < #_____8FD0_884C_4E0A_4E0B_6587["已生成护卫"] do
            local _____5B9E_4F8B = _____8FD0_884C_4E0A_4E0B_6587["已生成护卫"][i + 1]
            if not _____5355_4F4D_662F_5426_6B7B_4EA1(_____5B9E_4F8B.unit) then
                return _____5B9E_4F8B.unit
            end
            i = i + 1
        end
    end
    return nil
end
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_0["广播单位提示"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local SetUnitState = jass.SetUnitState
local SetUnitStateJapi = japi.SetUnitState
local GetUnitState = jass.GetUnitState
local AddSpecialEffect = jass.AddSpecialEffect
IsUnitType = jass.IsUnitType
local KillUnit = jass.KillUnit
local GetRandomInt = jass.GetRandomInt
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____6A21_5757_540D = "Boss战护卫"
local _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_8FD0_884C_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_53E5_67C4ID(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
local function _____6309Boss_67E5_627E_62A4_536B_914D_7F6E(bossUnit)
    local bossTypeId = GetUnitTypeId(bossUnit)
    if bossTypeId == 0 then
        return nil
    end
    do
        local i = 0
        while i < #____Boss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 do
            local _____914D_7F6E = ____Boss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868[i + 1]
            if stringToFourCCSafe(_____914D_7F6E["Boss单位ID"]) == bossTypeId then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
local function _____8BB0_5F55_62A4_536B_5B9E_4F8B(_____8FD0_884C_4E0A_4E0B_6587, unit, _____914D_7F6E)
    local handleId = _____83B7_53D6_53E5_67C4ID(unit)
    if handleId == 0 then
        return
    end
    local ____8FD0_884C_4E0A_4E0B_6587__5DF2_751F_6210_62A4_536B_5 = _____8FD0_884C_4E0A_4E0B_6587["已生成护卫"]
    ____8FD0_884C_4E0A_4E0B_6587__5DF2_751F_6210_62A4_536B_5[#____8FD0_884C_4E0A_4E0B_6587__5DF2_751F_6210_62A4_536B_5 + 1] = {unit = unit, handleId = handleId, ["主Boss死亡时立刻死亡"] = _____914D_7F6E["主Boss死亡时立刻死亡"] == true}
    if _____914D_7F6E["显示护卫血条"] == true then
        _____542F_52A8Boss_62A4_536B_8840_6761_5F31_70B9_97E7_6027(_____8FD0_884C_4E0A_4E0B_6587["Boss战上下文"], unit, _____8FD0_884C_4E0A_4E0B_6587["配置"]["护卫血条归属类型"])
    end
end
local function _____5E94_7528_62A4_536B_989D_5916_5C5E_6027(unit, _____914D_7F6E)
    if _____914D_7F6E["额外最大生命"] ~= nil and _____914D_7F6E["额外最大生命"] ~= 0 then
        local maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE)
        SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, maxLife + _____914D_7F6E["额外最大生命"])
        SetUnitState(
            unit,
            UNIT_STATE_LIFE,
            GetUnitState(unit, UNIT_STATE_MAX_LIFE)
        )
    end
    if _____914D_7F6E["暴击率"] ~= nil then
        YDUserDataSetSafe(
            "unit",
            unit,
            "暴击率",
            "real",
            _____914D_7F6E["暴击率"]
        )
    end
    if _____914D_7F6E["普攻伤害吸血"] ~= nil then
        YDUserDataSetSafe(
            "unit",
            unit,
            "普攻伤害吸血",
            "real",
            _____914D_7F6E["普攻伤害吸血"]
        )
    end
end
local function _____64AD_653E_62A4_536B_51FA_751F_7279_6548(_____914D_7F6E)
    if _____914D_7F6E["出生特效模型"] == nil or _____914D_7F6E["出生特效模型"] == "" then
        return
    end
    local effect = AddSpecialEffect(_____914D_7F6E["出生特效模型"], _____914D_7F6E.X, _____914D_7F6E.Y)
    if effect == nil or effect == 0 then
        return
    end
    YDWETimerDestroyEffectSafe(_____914D_7F6E["出生特效持续秒"] or 1, effect)
end
local function _____521B_5EFA_5355_4E2A_62A4_536B(_____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E)
    local unitTypeId = stringToFourCCSafe(_____914D_7F6E["单位ID"])
    if unitTypeId == 0 then
        return nil
    end
    local unit = CreateUnit(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        unitTypeId,
        _____914D_7F6E.X,
        _____914D_7F6E.Y,
        _____914D_7F6E["面向"] or 270
    )
    if unit == nil or unit == 0 then
        return nil
    end
    _____5E94_7528_62A4_536B_989D_5916_5C5E_6027(unit, _____914D_7F6E)
    _____64AD_653E_62A4_536B_51FA_751F_7279_6548(_____914D_7F6E)
    _____8BB0_5F55_62A4_536B_5B9E_4F8B(_____8FD0_884C_4E0A_4E0B_6587, unit, _____914D_7F6E)
    return unit
end
local function _____968F_673A_5E7F_64AD_62A4_536B_6587_6848(_____6765_6E90_5355_4F4D, _____6587_6848_6C60)
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return
    end
    if _____6587_6848_6C60 == nil or #_____6587_6848_6C60 == 0 then
        return
    end
    local index = #_____6587_6848_6C60 <= 1 and 0 or GetRandomInt(1, #_____6587_6848_6C60) - 1
    local _____6587_6848 = _____6587_6848_6C60[index + 1]
    if _____6587_6848 == nil or _____6587_6848 == "" then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____6765_6E90_5355_4F4D, _____6587_6848, 4)
end
local function _____6309_6279_6B21_83B7_53D6_5E7F_64AD_6765_6E90_5355_4F4D(context, _____8FD0_884C_4E0A_4E0B_6587, _____6279_6B21_914D_7F6E)
    if _____6279_6B21_914D_7F6E["广播说话者"] == "Boss" then
        return context["Boss单位"]
    end
    return _____83B7_53D6_62A4_536B_5BF9_767D_6765_6E90_5355_4F4D(context, _____8FD0_884C_4E0A_4E0B_6587, "护卫")
end
local function _____767B_8BB0_540E_7EED_5BF9_767D(_____8FD0_884C_4E0A_4E0B_6587, _____540E_7EED_5BF9_767D)
    if _____540E_7EED_5BF9_767D == nil or #_____540E_7EED_5BF9_767D == 0 then
        return
    end
    local nowMs = getServerTime()
    do
        local i = 0
        while i < #_____540E_7EED_5BF9_767D do
            do
                local _____914D_7F6E = _____540E_7EED_5BF9_767D[i + 1]
                if _____914D_7F6E["文案池"] == nil or #_____914D_7F6E["文案池"] == 0 then
                    goto __continue33
                end
                local ____8FD0_884C_4E0A_4E0B_6587__5F85_64AD_5BF9_767D_6 = _____8FD0_884C_4E0A_4E0B_6587["待播对白"]
                ____8FD0_884C_4E0A_4E0B_6587__5F85_64AD_5BF9_767D_6[#____8FD0_884C_4E0A_4E0B_6587__5F85_64AD_5BF9_767D_6 + 1] = {["触发时间"] = nowMs + _____914D_7F6E["延迟毫秒"], ["说话者"] = _____914D_7F6E["说话者"], ["文案池"] = _____914D_7F6E["文案池"]}
            end
            ::__continue33::
            i = i + 1
        end
    end
end
local function _____5904_7406_5F85_64AD_5BF9_767D(context, _____8FD0_884C_4E0A_4E0B_6587, nowMs)
    do
        local i = #_____8FD0_884C_4E0A_4E0B_6587["待播对白"] - 1
        while i >= 0 do
            do
                local _____5BF9_767D = _____8FD0_884C_4E0A_4E0B_6587["待播对白"][i + 1]
                if nowMs < _____5BF9_767D["触发时间"] then
                    goto __continue42
                end
                local _____6765_6E90_5355_4F4D = _____83B7_53D6_62A4_536B_5BF9_767D_6765_6E90_5355_4F4D(context, _____8FD0_884C_4E0A_4E0B_6587, _____5BF9_767D["说话者"])
                _____968F_673A_5E7F_64AD_62A4_536B_6587_6848(_____6765_6E90_5355_4F4D, _____5BF9_767D["文案池"])
                __TS__ArraySplice(_____8FD0_884C_4E0A_4E0B_6587["待播对白"], i, 1)
            end
            ::__continue42::
            i = i - 1
        end
    end
end
local function _____6E05_7406_5DF2_6B7B_4EA1_62A4_536B_8BB0_5F55(_____8FD0_884C_4E0A_4E0B_6587)
    do
        local i = #_____8FD0_884C_4E0A_4E0B_6587["已生成护卫"] - 1
        while i >= 0 do
            if _____5355_4F4D_662F_5426_6B7B_4EA1(_____8FD0_884C_4E0A_4E0B_6587["已生成护卫"][i + 1].unit) then
                _____7ED3_675FBoss_62A4_536B_8840_6761_5F31_70B9_97E7_6027(_____8FD0_884C_4E0A_4E0B_6587["已生成护卫"][i + 1].unit)
                __TS__ArraySplice(_____8FD0_884C_4E0A_4E0B_6587["已生成护卫"], i, 1)
            end
            i = i - 1
        end
    end
end
____exports["处理Boss战护卫启动"] = function(context)
    local bossHandleId = context["Boss句柄ID"]
    local _____8FD0_884C_4E0A_4E0B_6587 = _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_8FD0_884C_4E0A_4E0B_6587_8868[bossHandleId]
    if _____8FD0_884C_4E0A_4E0B_6587 ~= nil and _____8FD0_884C_4E0A_4E0B_6587["是否已启动"] then
        return
    end
    local _____914D_7F6E = _____6309Boss_67E5_627E_62A4_536B_914D_7F6E(context["Boss单位"])
    if _____914D_7F6E == nil then
        return
    end
    _____8FD0_884C_4E0A_4E0B_6587 = {
        ["Boss战上下文"] = context,
        ["配置"] = _____914D_7F6E,
        ["已生成护卫"] = {},
        ["待播对白"] = {},
        ["下次周期生成时间"] = 0,
        ["是否已启动"] = true
    }
    _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_8FD0_884C_4E0A_4E0B_6587_8868[bossHandleId] = _____8FD0_884C_4E0A_4E0B_6587
    if _____914D_7F6E["初始护卫批次"] ~= nil then
        do
            local i = 0
            while i < #_____914D_7F6E["初始护卫批次"]["单位列表"] do
                _____521B_5EFA_5355_4E2A_62A4_536B(_____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E["初始护卫批次"]["单位列表"][i + 1])
                i = i + 1
            end
        end
        _____968F_673A_5E7F_64AD_62A4_536B_6587_6848(
            _____6309_6279_6B21_83B7_53D6_5E7F_64AD_6765_6E90_5355_4F4D(context, _____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E["初始护卫批次"]),
            _____914D_7F6E["初始护卫批次"]["广播文案池"]
        )
        _____767B_8BB0_540E_7EED_5BF9_767D(_____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E["初始护卫批次"]["后续对白"])
    end
    local ____opt_7 = _____914D_7F6E["周期护卫批次"]
    if (____opt_7 and ____opt_7["间隔毫秒"]) ~= nil then
        _____8FD0_884C_4E0A_4E0B_6587["下次周期生成时间"] = getServerTime() + _____914D_7F6E["周期护卫批次"]["间隔毫秒"]
    end
    debugLogForce(
        _____6A21_5757_540D,
        "启动Boss护卫",
        "boss=",
        bossHandleId,
        "bossTypeId=",
        GetUnitTypeId(context["Boss单位"])
    )
end
____exports["处理Boss战护卫Tick"] = function(context, nowMs)
    local _____8FD0_884C_4E0A_4E0B_6587 = _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_8FD0_884C_4E0A_4E0B_6587_8868[context["Boss句柄ID"]]
    if _____8FD0_884C_4E0A_4E0B_6587 == nil then
        return
    end
    _____6E05_7406_5DF2_6B7B_4EA1_62A4_536B_8BB0_5F55(_____8FD0_884C_4E0A_4E0B_6587)
    _____5904_7406_5F85_64AD_5BF9_767D(context, _____8FD0_884C_4E0A_4E0B_6587, nowMs)
    local _____5468_671F_914D_7F6E = _____8FD0_884C_4E0A_4E0B_6587["配置"]["周期护卫批次"]
    if _____5468_671F_914D_7F6E == nil or _____5468_671F_914D_7F6E["间隔毫秒"] == nil or _____5468_671F_914D_7F6E["间隔毫秒"] <= 0 then
        return
    end
    if nowMs < _____8FD0_884C_4E0A_4E0B_6587["下次周期生成时间"] then
        return
    end
    local _____5E7F_64AD_6765_6E90_5355_4F4D = nil
    do
        local i = 0
        while i < #_____5468_671F_914D_7F6E["单位列表"] do
            local unit = _____521B_5EFA_5355_4E2A_62A4_536B(_____8FD0_884C_4E0A_4E0B_6587, _____5468_671F_914D_7F6E["单位列表"][i + 1])
            if _____5E7F_64AD_6765_6E90_5355_4F4D == nil and unit ~= nil and unit ~= 0 then
                _____5E7F_64AD_6765_6E90_5355_4F4D = unit
            end
            i = i + 1
        end
    end
    local ____temp_9
    if _____5468_671F_914D_7F6E["广播说话者"] == "Boss" then
        ____temp_9 = context["Boss单位"]
    else
        ____temp_9 = _____5E7F_64AD_6765_6E90_5355_4F4D
    end
    local _____5468_671F_5E7F_64AD_6765_6E90_5355_4F4D = ____temp_9
    _____968F_673A_5E7F_64AD_62A4_536B_6587_6848(_____5468_671F_5E7F_64AD_6765_6E90_5355_4F4D, _____5468_671F_914D_7F6E["广播文案池"])
    _____8FD0_884C_4E0A_4E0B_6587["下次周期生成时间"] = nowMs + _____5468_671F_914D_7F6E["间隔毫秒"]
end
____exports["处理Boss战护卫结束"] = function(context)
    local _____8FD0_884C_4E0A_4E0B_6587 = _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_8FD0_884C_4E0A_4E0B_6587_8868[context["Boss句柄ID"]]
    if _____8FD0_884C_4E0A_4E0B_6587 == nil then
        return
    end
    do
        local i = 0
        while i < #_____8FD0_884C_4E0A_4E0B_6587["已生成护卫"] do
            do
                local _____5B9E_4F8B = _____8FD0_884C_4E0A_4E0B_6587["已生成护卫"][i + 1]
                _____7ED3_675FBoss_62A4_536B_8840_6761_5F31_70B9_97E7_6027(_____5B9E_4F8B.unit)
                if not _____5B9E_4F8B["主Boss死亡时立刻死亡"] then
                    goto __continue65
                end
                if _____5355_4F4D_662F_5426_6B7B_4EA1(_____5B9E_4F8B.unit) then
                    goto __continue65
                end
                KillUnit(_____5B9E_4F8B.unit)
            end
            ::__continue65::
            i = i + 1
        end
    end
    _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_8FD0_884C_4E0A_4E0B_6587_8868[context["Boss句柄ID"]] = nil
    debugLogForce(_____6A21_5757_540D, "结束Boss护卫", "boss=", context["Boss句柄ID"])
end
return ____exports
