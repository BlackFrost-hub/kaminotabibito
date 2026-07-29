local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5355_4F4D_662F_5426_6B7B_4EA1, _____83B7_53D6_62A4_536B_5BF9_767D_6765_6E90_5355_4F4D, IsUnitType, UNIT_TYPE_DEAD
local ____05_FF0EBoss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.05．Boss战斗启动护卫配置表")
local ____Boss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868 = ____05_FF0EBoss_6218_6597_542F_52A8_62A4_536B_914D_7F6E_8868["Boss战斗启动护卫配置表"]
local ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.getServerTime
local ____07_FF0EBoss_5F31_70B9_4E8B_4EF6_6865_63A5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.07．Boss弱点事件桥接")
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
local GetUnitStateJapi = japi.GetUnitState
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
local ____require_result_5 = require("系统.01．单位系统.10．护卫系统.index")
local _____521B_5EFA_62A4_536B_5355_4F4D = ____require_result_5["创建护卫单位"]
local _____767B_8BB0_62A4_536B_5355_4F4D = ____require_result_5["登记护卫单位"]
local _____6CE8_9500_62A4_536B_5355_4F4D = ____require_result_5["注销护卫单位"]
local _____5904_7406Boss_7ED3_675F_5168_90E8_62A4_536B = ____require_result_5["处理Boss结束全部护卫"]
local Player = jass.Player
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local SetUnitState = jass.SetUnitState
local SetUnitStateJapi = japi.SetUnitState
local GetUnitState = jass.GetUnitState
local AddSpecialEffect = jass.AddSpecialEffect
IsUnitType = jass.IsUnitType
local GetRandomInt = jass.GetRandomInt
local GetRandomReal = jass.GetRandomReal
local GetRectMinX = jass.GetRectMinX
local GetRectMaxX = jass.GetRectMaxX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxY = jass.GetRectMaxY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitOwner = jass.SetUnitOwner
local SetUnitPosition = jass.SetUnitPosition
local Cos = jass.Cos
local Sin = jass.Sin
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____6A21_5757_540D = "Boss战护卫"
local _____89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
local _____5E26_5165_62A4_536B_6700_5C0F_534A_5F84 = 250
local _____5E26_5165_62A4_536B_6700_5927_534A_5F84 = 700
local _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_8FD0_884C_4E0A_4E0B_6587_8868 = {}
local _____6309Boss_53E5_67C4_7D22_5F15_7684_5F85_5E26_5165_62A4_536B_8868 = {}
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
local function _____8BB0_5F55_62A4_536B_5B9E_4F8B(_____8FD0_884C_4E0A_4E0B_6587, unit)
    local handleId = _____83B7_53D6_53E5_67C4ID(unit)
    if handleId == 0 then
        return
    end
    local ____8FD0_884C_4E0A_4E0B_6587__5DF2_751F_6210_62A4_536B_6 = _____8FD0_884C_4E0A_4E0B_6587["已生成护卫"]
    ____8FD0_884C_4E0A_4E0B_6587__5DF2_751F_6210_62A4_536B_6[#____8FD0_884C_4E0A_4E0B_6587__5DF2_751F_6210_62A4_536B_6 + 1] = {
        unit = unit,
        handleId = handleId,
        unitTypeId = GetUnitTypeId(unit)
    }
end
local function _____83B7_53D6_968F_673A_73AF_5F62_5750_6807(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____6700_5C0F_534A_5F84, _____6700_5927_534A_5F84)
    local _____89D2_5EA6 = GetRandomReal(0, 360)
    local _____534A_5F84 = GetRandomReal(_____6700_5C0F_534A_5F84, _____6700_5927_534A_5F84)
    local _____5F27_5EA6 = _____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6
    return {
        X = _____4E2D_5FC3X + Cos(_____5F27_5EA6) * _____534A_5F84,
        Y = _____4E2D_5FC3Y + Sin(_____5F27_5EA6) * _____534A_5F84,
        ["角度"] = _____89D2_5EA6
    }
end
local function _____83B7_53D6_62A4_536B_751F_6210_5750_6807(_____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E)
    local _____968F_673A_4F4D_7F6E = _____914D_7F6E["随机生成位置"]
    local _____5730_70B9_77E9_5F62 = _____8FD0_884C_4E0A_4E0B_6587["Boss战上下文"]["地点矩形"]
    if _____968F_673A_4F4D_7F6E ~= nil and _____968F_673A_4F4D_7F6E["中心"] == "Boss战矩形中心" and _____5730_70B9_77E9_5F62 ~= nil and _____5730_70B9_77E9_5F62 ~= 0 then
        local _____4E2D_5FC3X = (GetRectMinX(_____5730_70B9_77E9_5F62) + GetRectMaxX(_____5730_70B9_77E9_5F62)) * 0.5
        local _____4E2D_5FC3Y = (GetRectMinY(_____5730_70B9_77E9_5F62) + GetRectMaxY(_____5730_70B9_77E9_5F62)) * 0.5
        return _____83B7_53D6_968F_673A_73AF_5F62_5750_6807(_____4E2D_5FC3X, _____4E2D_5FC3Y, _____968F_673A_4F4D_7F6E["最小半径"], _____968F_673A_4F4D_7F6E["最大半径"])
    end
    return {
        X = _____914D_7F6E.X or GetUnitX(_____8FD0_884C_4E0A_4E0B_6587["Boss战上下文"]["Boss单位"]),
        Y = _____914D_7F6E.Y or GetUnitY(_____8FD0_884C_4E0A_4E0B_6587["Boss战上下文"]["Boss单位"])
    }
end
local function _____83B7_53D6_540C_7C7B_5B58_6D3B_6570_91CF(_____8FD0_884C_4E0A_4E0B_6587, unitTypeId)
    local count = 0
    do
        local i = 0
        while i < #_____8FD0_884C_4E0A_4E0B_6587["已生成护卫"] do
            local _____5B9E_4F8B = _____8FD0_884C_4E0A_4E0B_6587["已生成护卫"][i + 1]
            if _____5B9E_4F8B.unitTypeId == unitTypeId and not _____5355_4F4D_662F_5426_6B7B_4EA1(_____5B9E_4F8B.unit) then
                count = count + 1
            end
            i = i + 1
        end
    end
    return count
end
local function _____5E94_7528_62A4_536B_989D_5916_5C5E_6027(unit, _____914D_7F6E)
    if _____914D_7F6E["额外最大生命"] ~= nil and _____914D_7F6E["额外最大生命"] ~= 0 then
        local maxLife = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
        SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, maxLife + _____914D_7F6E["额外最大生命"])
        SetUnitState(
            unit,
            UNIT_STATE_LIFE,
            GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
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
local function _____64AD_653E_62A4_536B_51FA_751F_7279_6548(_____914D_7F6E, x, y)
    if _____914D_7F6E["出生特效模型"] == nil or _____914D_7F6E["出生特效模型"] == "" then
        return
    end
    local effect = AddSpecialEffect(_____914D_7F6E["出生特效模型"], x, y)
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
    if _____914D_7F6E["同类最大存活数量"] ~= nil and _____83B7_53D6_540C_7C7B_5B58_6D3B_6570_91CF(_____8FD0_884C_4E0A_4E0B_6587, unitTypeId) >= _____914D_7F6E["同类最大存活数量"] then
        return nil
    end
    local _____5750_6807 = _____83B7_53D6_62A4_536B_751F_6210_5750_6807(_____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E)
    local unit = _____521B_5EFA_62A4_536B_5355_4F4D({
        ["主Boss单位"] = _____8FD0_884C_4E0A_4E0B_6587["Boss战上下文"]["Boss单位"],
        ["护卫类型"] = "战斗启动护卫:" .. (_____914D_7F6E["单位名"] or _____914D_7F6E["单位ID"]),
        ["护卫血条优先级"] = _____914D_7F6E["护卫血条优先级"] or (_____914D_7F6E["显示护卫血条"] == true and 100 or 0),
        ["Boss结束处理"] = _____914D_7F6E["主Boss死亡时立刻死亡"] == true and "击杀" or "注销",
        ["单位类型"] = _____914D_7F6E["单位ID"],
        ["所属玩家"] = Player(PLAYER_NEUTRAL_AGGRESSIVE),
        X = _____5750_6807.X,
        Y = _____5750_6807.Y,
        ["面向"] = _____914D_7F6E["面向"] or 270
    })
    if unit == nil or unit == 0 then
        return nil
    end
    _____5E94_7528_62A4_536B_989D_5916_5C5E_6027(unit, _____914D_7F6E)
    _____64AD_653E_62A4_536B_51FA_751F_7279_6548(_____914D_7F6E, _____5750_6807.X, _____5750_6807.Y)
    _____8BB0_5F55_62A4_536B_5B9E_4F8B(_____8FD0_884C_4E0A_4E0B_6587, unit)
    return unit
end
local function _____6309_914D_7F6E_521B_5EFA_62A4_536B_6279_6B21(_____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E)
    local _____751F_6210_6570_91CF = _____914D_7F6E["每批生成数量"] or 1
    local _____9996_4E2A_751F_6210_5355_4F4D = nil
    do
        local i = 0
        while i < _____751F_6210_6570_91CF do
            local unit = _____521B_5EFA_5355_4E2A_62A4_536B(_____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E)
            if _____9996_4E2A_751F_6210_5355_4F4D == nil and unit ~= nil and unit ~= 0 then
                _____9996_4E2A_751F_6210_5355_4F4D = unit
            end
            i = i + 1
        end
    end
    return _____9996_4E2A_751F_6210_5355_4F4D
end
local function _____5E26_5165_5F85_767B_8BB0_62A4_536B(_____8FD0_884C_4E0A_4E0B_6587)
    local context = _____8FD0_884C_4E0A_4E0B_6587["Boss战上下文"]
    local _____5F85_5E26_5165_5217_8868 = _____6309Boss_53E5_67C4_7D22_5F15_7684_5F85_5E26_5165_62A4_536B_8868[context["Boss句柄ID"]]
    _____6309Boss_53E5_67C4_7D22_5F15_7684_5F85_5E26_5165_62A4_536B_8868[context["Boss句柄ID"]] = nil
    if _____5F85_5E26_5165_5217_8868 == nil then
        return
    end
    local bossX = GetUnitX(context["Boss单位"])
    local bossY = GetUnitY(context["Boss单位"])
    do
        local i = 0
        while i < #_____5F85_5E26_5165_5217_8868 do
            do
                local _____5F85_5E26_5165 = _____5F85_5E26_5165_5217_8868[i + 1]
                if _____5355_4F4D_662F_5426_6B7B_4EA1(_____5F85_5E26_5165.unit) then
                    goto __continue38
                end
                local _____5750_6807 = _____83B7_53D6_968F_673A_73AF_5F62_5750_6807(bossX, bossY, _____5E26_5165_62A4_536B_6700_5C0F_534A_5F84, _____5E26_5165_62A4_536B_6700_5927_534A_5F84)
                SetUnitOwner(
                    _____5F85_5E26_5165.unit,
                    Player(PLAYER_NEUTRAL_AGGRESSIVE),
                    true
                )
                SetUnitPosition(_____5F85_5E26_5165.unit, _____5750_6807.X, _____5750_6807.Y)
                SetUnitFacing(_____5F85_5E26_5165.unit, _____5750_6807["角度"] + 180)
                _____767B_8BB0_62A4_536B_5355_4F4D(_____5F85_5E26_5165.unit, {["主Boss单位"] = context["Boss单位"], ["护卫类型"] = _____5F85_5E26_5165["护卫类型"], ["护卫血条优先级"] = 0, ["Boss结束处理"] = "击杀"})
                _____8BB0_5F55_62A4_536B_5B9E_4F8B(_____8FD0_884C_4E0A_4E0B_6587, _____5F85_5E26_5165.unit)
            end
            ::__continue38::
            i = i + 1
        end
    end
end
____exports["登记Boss战待带入护卫"] = function(boss, guard, _____62A4_536B_7C7B_578B)
    local bossHandleId = _____83B7_53D6_53E5_67C4ID(boss)
    local guardHandleId = _____83B7_53D6_53E5_67C4ID(guard)
    if bossHandleId == 0 or guardHandleId == 0 or _____5355_4F4D_662F_5426_6B7B_4EA1(guard) then
        return false
    end
    local list = _____6309Boss_53E5_67C4_7D22_5F15_7684_5F85_5E26_5165_62A4_536B_8868[bossHandleId]
    if list == nil then
        list = {}
        _____6309Boss_53E5_67C4_7D22_5F15_7684_5F85_5E26_5165_62A4_536B_8868[bossHandleId] = list
    end
    do
        local i = 0
        while i < #list do
            if _____83B7_53D6_53E5_67C4ID(list[i + 1].unit) == guardHandleId then
                return true
            end
            i = i + 1
        end
    end
    list[#list + 1] = {unit = guard, ["护卫类型"] = _____62A4_536B_7C7B_578B}
    return true
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
                    goto __continue55
                end
                local ____8FD0_884C_4E0A_4E0B_6587__5F85_64AD_5BF9_767D_7 = _____8FD0_884C_4E0A_4E0B_6587["待播对白"]
                ____8FD0_884C_4E0A_4E0B_6587__5F85_64AD_5BF9_767D_7[#____8FD0_884C_4E0A_4E0B_6587__5F85_64AD_5BF9_767D_7 + 1] = {["触发时间"] = nowMs + _____914D_7F6E["延迟毫秒"], ["说话者"] = _____914D_7F6E["说话者"], ["文案池"] = _____914D_7F6E["文案池"]}
            end
            ::__continue55::
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
                    goto __continue64
                end
                local _____6765_6E90_5355_4F4D = _____83B7_53D6_62A4_536B_5BF9_767D_6765_6E90_5355_4F4D(context, _____8FD0_884C_4E0A_4E0B_6587, _____5BF9_767D["说话者"])
                _____968F_673A_5E7F_64AD_62A4_536B_6587_6848(_____6765_6E90_5355_4F4D, _____5BF9_767D["文案池"])
                __TS__ArraySplice(_____8FD0_884C_4E0A_4E0B_6587["待播对白"], i, 1)
            end
            ::__continue64::
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
                _____6CE8_9500_62A4_536B_5355_4F4D(_____8FD0_884C_4E0A_4E0B_6587["已生成护卫"][i + 1].unit)
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
    _____5E26_5165_5F85_767B_8BB0_62A4_536B(_____8FD0_884C_4E0A_4E0B_6587)
    if _____914D_7F6E["初始护卫批次"] ~= nil then
        do
            local i = 0
            while i < #_____914D_7F6E["初始护卫批次"]["单位列表"] do
                _____6309_914D_7F6E_521B_5EFA_62A4_536B_6279_6B21(_____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E["初始护卫批次"]["单位列表"][i + 1])
                i = i + 1
            end
        end
        _____968F_673A_5E7F_64AD_62A4_536B_6587_6848(
            _____6309_6279_6B21_83B7_53D6_5E7F_64AD_6765_6E90_5355_4F4D(context, _____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E["初始护卫批次"]),
            _____914D_7F6E["初始护卫批次"]["广播文案池"]
        )
        _____767B_8BB0_540E_7EED_5BF9_767D(_____8FD0_884C_4E0A_4E0B_6587, _____914D_7F6E["初始护卫批次"]["后续对白"])
    end
    local ____opt_8 = _____914D_7F6E["周期护卫批次"]
    if (____opt_8 and ____opt_8["间隔毫秒"]) ~= nil then
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
            local unit = _____6309_914D_7F6E_521B_5EFA_62A4_536B_6279_6B21(_____8FD0_884C_4E0A_4E0B_6587, _____5468_671F_914D_7F6E["单位列表"][i + 1])
            if _____5E7F_64AD_6765_6E90_5355_4F4D == nil and unit ~= nil and unit ~= 0 then
                _____5E7F_64AD_6765_6E90_5355_4F4D = unit
            end
            i = i + 1
        end
    end
    local ____temp_10
    if _____5468_671F_914D_7F6E["广播说话者"] == "Boss" then
        ____temp_10 = context["Boss单位"]
    else
        ____temp_10 = _____5E7F_64AD_6765_6E90_5355_4F4D
    end
    local _____5468_671F_5E7F_64AD_6765_6E90_5355_4F4D = ____temp_10
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
            local _____5B9E_4F8B = _____8FD0_884C_4E0A_4E0B_6587["已生成护卫"][i + 1]
            _____7ED3_675FBoss_62A4_536B_8840_6761_5F31_70B9_97E7_6027(_____5B9E_4F8B.unit)
            i = i + 1
        end
    end
    _____5904_7406Boss_7ED3_675F_5168_90E8_62A4_536B(context["Boss单位"])
    _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_8FD0_884C_4E0A_4E0B_6587_8868[context["Boss句柄ID"]] = nil
    debugLogForce(_____6A21_5757_540D, "结束Boss护卫", "boss=", context["Boss句柄ID"])
end
return ____exports
