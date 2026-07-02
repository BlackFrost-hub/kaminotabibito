local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 扩展控制系统
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
local String2OrderIdBJ = ____require_result_0.String2OrderIdBJ
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.05．Buff系统.01．控制抗性.index")
local calcReducedControlDuration = ____require_result_2.calcReducedControlDuration
local isExcludedFromControlResist = ____require_result_2.isExcludedFromControlResist
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_4["施加快速控制Buff"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local addPeriodicCallback = ____require_result_5.addPeriodicCallback
local getServerTime = ____require_result_5.getServerTime
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local registerTargetOrderListener = ____require_result_6.registerTargetOrderListener
local registerPointOrderListener = ____require_result_6.registerPointOrderListener
local registerImmediateOrderListener = ____require_result_6.registerImmediateOrderListener
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_7.getEnemyUnitsInRange
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_8.debugLogForce
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.06．控制Debuff联动")
local _____901A_77E5_63A7_5236Debuff_4E8B_4EF6 = ____require_result_9["通知控制Debuff事件"]
local ____require_result_10 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.控制效果定义")
local _____83B7_53D6_6269_5C55_63A7_5236_5B9A_4E49 = ____require_result_10["获取扩展控制定义"]
local _____83B7_53D6_63A7_5236_6548_679C_5B9A_4E49 = ____require_result_10["获取控制效果定义"]
local _____9ED8_8BA4_9B45_60D1_8DDF_968F_534A_5F84 = ____require_result_10["默认魅惑跟随半径"]
local _____9B45_60D1_7279_6548_6A21_578B = ____require_result_10["魅惑特效模型"]
local _____6050_60E7_7279_6548_6A21_578B = ____require_result_10["恐惧特效模型"]
local _____9ED8_8BA4_6050_60E7_9003_79BB_8DDD_79BB = ____require_result_10["默认恐惧逃离距离"]
local _____9ED8_8BA4_6050_60E7_79FB_52A8_901F_5EA6 = ____require_result_10["默认恐惧移动速度"]
local _____9ED8_8BA4_6050_60E7_968F_673A_534A_5F84 = ____require_result_10["默认恐惧随机半径"]
local _____6269_5C55_63A7_5236_7279_6548_6302_70B9 = ____require_result_10["扩展控制特效挂点"]
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local GetUnitCurrentOrder = jass.GetUnitCurrentOrder
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local IssueTargetOrder = jass.IssueTargetOrder
local IssuePointOrder = jass.IssuePointOrder
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitMoveSpeed = jass.GetUnitMoveSpeed
local GetRandomReal = jass.GetRandomReal
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local IsUnitType = jass.IsUnitType
local SetUnitMoveSpeed = jass.SetUnitMoveSpeed
local UnitDamageTarget = jass.UnitDamageTarget
local DzSetUnitDisableControlOrder = japi.DzSetUnitDisableControlOrder
local DzGetUnitDisableControlOrder = japi.DzGetUnitDisableControlOrder
local DzUnitOrdersForceStop = japi.DzUnitOrdersForceStop
local DzUnitDisableAttack = japi.DzUnitDisableAttack
local _____6A21_5757_540D = "扩展控制系统"
local ____jglobals_bj_DEGTORAD_11 = jglobals.bj_DEGTORAD
if ____jglobals_bj_DEGTORAD_11 == nil then
    ____jglobals_bj_DEGTORAD_11 = 0.017453292519943295
end
local bj_DEGTORAD = ____jglobals_bj_DEGTORAD_11
local ____jglobals_bj_RADTODEG_12 = jglobals.bj_RADTODEG
if ____jglobals_bj_RADTODEG_12 == nil then
    ____jglobals_bj_RADTODEG_12 = 57.29577951308232
end
local bj_RADTODEG = ____jglobals_bj_RADTODEG_12
local _____6269_5C55_63A7_5236_6620_5C04_8868 = {}
local _____6269_5C55_63A7_5236_76EE_6807ID_5217_8868 = {}
local _____5F85_6267_884C_53CD_4F24_961F_5217 = {}
local _____5DF2_521D_59CB_5316 = false
local _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
local _____53CD_4F24_7ED3_7B97_5DF2_6392_961F = false
local _____653B_51FB_547D_4EE4ID = 0
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return IsUnitType(_____5355_4F4D, jass.UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_76EE_6807_5217_8868_7D22_5F15(_____76EE_6807ID)
    do
        local i = 0
        while i < #_____6269_5C55_63A7_5236_76EE_6807ID_5217_8868 do
            if _____6269_5C55_63A7_5236_76EE_6807ID_5217_8868[i + 1] == _____76EE_6807ID then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
local function _____52A0_5165_76EE_6807ID(_____76EE_6807ID)
    if _____53D6_76EE_6807_5217_8868_7D22_5F15(_____76EE_6807ID) >= 0 then
        return
    end
    _____6269_5C55_63A7_5236_76EE_6807ID_5217_8868[#_____6269_5C55_63A7_5236_76EE_6807ID_5217_8868 + 1] = _____76EE_6807ID
end
local function _____79FB_9664_76EE_6807ID(_____76EE_6807ID)
    local index = _____53D6_76EE_6807_5217_8868_7D22_5F15(_____76EE_6807ID)
    if index < 0 then
        return
    end
    __TS__ArraySplice(_____6269_5C55_63A7_5236_76EE_6807ID_5217_8868, index, 1)
end
local function _____8BA1_7B97_5E73_65B9_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end
local function _____8BA1_7B97_6781_5750_6807X(x, angle, distance)
    return x + Cos(angle * bj_DEGTORAD) * distance
end
local function _____8BA1_7B97_6781_5750_6807Y(y, angle, distance)
    return y + Sin(angle * bj_DEGTORAD) * distance
end
local function _____53D6_4E0D_4F4E_4E8E_4E0B_9650(_____6570_503C, _____4E0B_9650)
    if _____6570_503C < _____4E0B_9650 then
        return _____4E0B_9650
    end
    return _____6570_503C
end
local function _____6E05_7406_6269_5C55_63A7_5236_8BB0_5F55(_____76EE_6807ID, _____8BB0_5F55)
    if _____8BB0_5F55["目标单位引用"] ~= nil and _____8BB0_5F55["目标单位引用"] ~= 0 then
        if _____8BB0_5F55["特效句柄"] ~= nil and _____8BB0_5F55["特效句柄"] ~= 0 then
            DestroyEffect(_____8BB0_5F55["特效句柄"])
            _____8BB0_5F55["特效句柄"] = nil
        end
        if _____8BB0_5F55["类型"] == "charm" or _____8BB0_5F55["类型"] == "fear" then
            DzUnitDisableAttack(_____8BB0_5F55["目标单位引用"], false)
        end
        if _____8BB0_5F55["类型"] == "fear" then
            SetUnitMoveSpeed(_____8BB0_5F55["目标单位引用"], _____8BB0_5F55["原本移动速度"])
        end
        DzSetUnitDisableControlOrder(_____8BB0_5F55["目标单位引用"], _____8BB0_5F55["原本屏蔽控制命令"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____8BB0_5F55["目标单位引用"], _____8BB0_5F55.BuffID)
    end
    __TS__Delete(_____6269_5C55_63A7_5236_6620_5C04_8868, _____76EE_6807ID)
    _____79FB_9664_76EE_6807ID(_____76EE_6807ID)
end
local function _____5185_90E8_6E05_9664_6269_5C55_63A7_5236(_____76EE_6807ID, _____6307_5B9A_7C7B_578B)
    local _____8BB0_5F55 = _____6269_5C55_63A7_5236_6620_5C04_8868[_____76EE_6807ID]
    if _____8BB0_5F55 == nil then
        return false
    end
    if _____6307_5B9A_7C7B_578B ~= nil and _____8BB0_5F55["类型"] ~= _____6307_5B9A_7C7B_578B then
        return false
    end
    _____6E05_7406_6269_5C55_63A7_5236_8BB0_5F55(_____76EE_6807ID, _____8BB0_5F55)
    debugLogForce(
        _____6A21_5757_540D,
        "清除扩展控制",
        "目标ID=",
        _____76EE_6807ID,
        "类型=",
        _____8BB0_5F55["类型"]
    )
    return true
end
local function _____6267_884C_5632_8BBD_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
    local _____76EE_6807_5355_4F4D = _____8BB0_5F55["目标单位引用"]
    local _____6765_6E90_5355_4F4D = _____8BB0_5F55["来源单位引用"]
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____76EE_6807_5355_4F4D) or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____6765_6E90_5355_4F4D) then
        return
    end
    if _____653B_51FB_547D_4EE4ID == 0 then
        _____653B_51FB_547D_4EE4ID = String2OrderIdBJ("attack")
    end
    _____8BB0_5F55["下次行为时间"] = _____5F53_524D_65F6_95F4 + 250
    if (GetUnitCurrentOrder(_____76EE_6807_5355_4F4D) or 0) == _____653B_51FB_547D_4EE4ID then
        return
    end
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssueTargetOrder(_____76EE_6807_5355_4F4D, "attack", _____6765_6E90_5355_4F4D)
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function _____6267_884C_9B45_60D1_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
    local _____76EE_6807_5355_4F4D = _____8BB0_5F55["目标单位引用"]
    local _____6765_6E90_5355_4F4D = _____8BB0_5F55["来源单位引用"]
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____76EE_6807_5355_4F4D) or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____6765_6E90_5355_4F4D) then
        return
    end
    _____8BB0_5F55["下次行为时间"] = _____5F53_524D_65F6_95F4 + 200
    local _____76EE_6807X = GetUnitX(_____76EE_6807_5355_4F4D)
    local _____76EE_6807Y = GetUnitY(_____76EE_6807_5355_4F4D)
    local _____6765_6E90X = GetUnitX(_____6765_6E90_5355_4F4D)
    local _____6765_6E90Y = GetUnitY(_____6765_6E90_5355_4F4D)
    if _____8BA1_7B97_5E73_65B9_8DDD_79BB(_____76EE_6807X, _____76EE_6807Y, _____6765_6E90X, _____6765_6E90Y) <= _____8BB0_5F55["跟随半径"] * _____8BB0_5F55["跟随半径"] then
        return
    end
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssuePointOrder(_____76EE_6807_5355_4F4D, "move", _____6765_6E90X, _____6765_6E90Y)
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function _____6267_884C_6050_60E7_9003_79BB_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
    local _____76EE_6807_5355_4F4D = _____8BB0_5F55["目标单位引用"]
    local _____6765_6E90_5355_4F4D = _____8BB0_5F55["来源单位引用"]
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____76EE_6807_5355_4F4D) or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____6765_6E90_5355_4F4D) then
        return
    end
    _____8BB0_5F55["下次行为时间"] = _____5F53_524D_65F6_95F4 + 300
    local _____76EE_6807X = GetUnitX(_____76EE_6807_5355_4F4D)
    local _____76EE_6807Y = GetUnitY(_____76EE_6807_5355_4F4D)
    local _____6765_6E90X = GetUnitX(_____6765_6E90_5355_4F4D)
    local _____6765_6E90Y = GetUnitY(_____6765_6E90_5355_4F4D)
    local dx = _____76EE_6807X - _____6765_6E90X
    local dy = _____76EE_6807Y - _____6765_6E90Y
    local _____89D2_5EA6 = GetRandomReal(0, 360)
    if dx * dx + dy * dy > 1 then
        _____89D2_5EA6 = Atan2(dy, dx) * bj_RADTODEG
    end
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssuePointOrder(
        _____76EE_6807_5355_4F4D,
        "move",
        _____8BA1_7B97_6781_5750_6807X(_____76EE_6807X, _____89D2_5EA6, _____8BB0_5F55["逃离距离"]),
        _____8BA1_7B97_6781_5750_6807Y(_____76EE_6807Y, _____89D2_5EA6, _____8BB0_5F55["逃离距离"])
    )
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function _____6267_884C_6050_60E7_968F_673A_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
    local _____76EE_6807_5355_4F4D = _____8BB0_5F55["目标单位引用"]
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        return
    end
    _____8BB0_5F55["下次行为时间"] = _____5F53_524D_65F6_95F4 + 450
    local _____76EE_6807X = GetUnitX(_____76EE_6807_5355_4F4D)
    local _____76EE_6807Y = GetUnitY(_____76EE_6807_5355_4F4D)
    local _____968F_673A_89D2_5EA6 = GetRandomReal(0, 360)
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssuePointOrder(
        _____76EE_6807_5355_4F4D,
        "move",
        _____8BA1_7B97_6781_5750_6807X(_____76EE_6807X, _____968F_673A_89D2_5EA6, _____8BB0_5F55["随机半径"]),
        _____8BA1_7B97_6781_5750_6807Y(_____76EE_6807Y, _____968F_673A_89D2_5EA6, _____8BB0_5F55["随机半径"])
    )
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function _____6267_884C_6050_60E7_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
    if _____8BB0_5F55["恐惧模式"] == "随机乱跑" then
        _____6267_884C_6050_60E7_968F_673A_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
        return
    end
    _____6267_884C_6050_60E7_9003_79BB_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
end
local function _____6269_5C55_63A7_5236_9A71_52A8Tick()
    local _____5F53_524D_65F6_95F4 = getServerTime()
    local index = 0
    while index < #_____6269_5C55_63A7_5236_76EE_6807ID_5217_8868 do
        do
            local _____76EE_6807ID = _____6269_5C55_63A7_5236_76EE_6807ID_5217_8868[index + 1]
            local _____8BB0_5F55 = _____6269_5C55_63A7_5236_6620_5C04_8868[_____76EE_6807ID]
            if _____8BB0_5F55 == nil then
                __TS__ArraySplice(_____6269_5C55_63A7_5236_76EE_6807ID_5217_8868, index, 1)
                goto __continue42
            end
            if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____8BB0_5F55["目标单位引用"]) or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____8BB0_5F55["来源单位引用"]) or _____8BB0_5F55["到期时间"] <= _____5F53_524D_65F6_95F4 then
                _____6E05_7406_6269_5C55_63A7_5236_8BB0_5F55(_____76EE_6807ID, _____8BB0_5F55)
                goto __continue42
            end
            if _____5F53_524D_65F6_95F4 >= _____8BB0_5F55["下次行为时间"] then
                if _____8BB0_5F55["类型"] == "taunt" then
                    _____6267_884C_5632_8BBD_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
                elseif _____8BB0_5F55["类型"] == "charm" then
                    _____6267_884C_9B45_60D1_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
                else
                    _____6267_884C_6050_60E7_884C_4E3A(_____8BB0_5F55, _____5F53_524D_65F6_95F4)
                end
            end
            index = index + 1
        end
        ::__continue42::
    end
end
local function ____on_76EE_6807_6307_4EE4(unit, orderId, targetUnit, _targetItem, _targetDestructable)
    if _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 then
        return
    end
    if _____653B_51FB_547D_4EE4ID == 0 then
        _____653B_51FB_547D_4EE4ID = String2OrderIdBJ("attack")
    end
    local _____8BB0_5F55 = _____6269_5C55_63A7_5236_6620_5C04_8868[_____53D6_5355_4F4DID(unit)]
    if _____8BB0_5F55 == nil or _____8BB0_5F55["类型"] ~= "taunt" then
        return
    end
    if orderId == _____653B_51FB_547D_4EE4ID and _____53D6_5355_4F4DID(targetUnit) == _____8BB0_5F55["来源单位ID"] then
        return
    end
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssueTargetOrder(unit, "attack", _____8BB0_5F55["来源单位引用"])
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function ____on_70B9_6307_4EE4(unit, orderId, _x, _y)
    if _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 then
        return
    end
    if _____653B_51FB_547D_4EE4ID == 0 then
        _____653B_51FB_547D_4EE4ID = String2OrderIdBJ("attack")
    end
    local _____8BB0_5F55 = _____6269_5C55_63A7_5236_6620_5C04_8868[_____53D6_5355_4F4DID(unit)]
    if _____8BB0_5F55 == nil or _____8BB0_5F55["类型"] ~= "taunt" then
        return
    end
    if orderId == _____653B_51FB_547D_4EE4ID then
        return
    end
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssueTargetOrder(unit, "attack", _____8BB0_5F55["来源单位引用"])
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function ____on_7ACB_5373_6307_4EE4(unit, orderId)
    if _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 then
        return
    end
    if _____653B_51FB_547D_4EE4ID == 0 then
        _____653B_51FB_547D_4EE4ID = String2OrderIdBJ("attack")
    end
    local _____8BB0_5F55 = _____6269_5C55_63A7_5236_6620_5C04_8868[_____53D6_5355_4F4DID(unit)]
    if _____8BB0_5F55 == nil or _____8BB0_5F55["类型"] ~= "taunt" then
        return
    end
    if orderId == _____653B_51FB_547D_4EE4ID then
        return
    end
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssueTargetOrder(unit, "attack", _____8BB0_5F55["来源单位引用"])
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function ____flush_53CD_4F24_961F_5217()
    _____53CD_4F24_7ED3_7B97_5DF2_6392_961F = false
    while #_____5F85_6267_884C_53CD_4F24_961F_5217 > 0 do
        do
            local _____8BB0_5F55 = table.remove(_____5F85_6267_884C_53CD_4F24_961F_5217, 1)
            if _____8BB0_5F55 == nil then
                goto __continue65
            end
            if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____8BB0_5F55["攻击者"]) then
                goto __continue65
            end
            if _____8BB0_5F55["伤害"] <= 0 then
                goto __continue65
            end
            UnitDamageTarget(
                _____8BB0_5F55["攻击者"],
                _____8BB0_5F55["攻击者"],
                _____8BB0_5F55["伤害"],
                false,
                false,
                jass.ATTACK_TYPE_CHAOS,
                jass.DAMAGE_TYPE_UNIVERSAL,
                nil
            )
        end
        ::__continue65::
    end
end
local function ____schedule_53CD_4F24(attacker, damage)
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(attacker) or damage <= 0 then
        return
    end
    _____5F85_6267_884C_53CD_4F24_961F_5217[#_____5F85_6267_884C_53CD_4F24_961F_5217 + 1] = {["攻击者"] = attacker, ["伤害"] = damage}
    if _____53CD_4F24_7ED3_7B97_5DF2_6392_961F then
        return
    end
    _____53CD_4F24_7ED3_7B97_5DF2_6392_961F = true
    addDelayedCallback(0, ____flush_53CD_4F24_961F_5217)
end
local function ____on_53CD_4F24_6700_7EC8_4F24_5BB3(target, attacker, applied, damageType)
    if applied <= 0 or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(attacker) or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(target) then
        return
    end
    if damageType == nil or damageType.isNormalAttack ~= true then
        return
    end
    local _____8BB0_5F55 = _____6269_5C55_63A7_5236_6620_5C04_8868[_____53D6_5355_4F4DID(attacker)]
    if _____8BB0_5F55 == nil or _____8BB0_5F55["类型"] ~= "taunt" or _____8BB0_5F55["反伤倍率"] <= 0 then
        return
    end
    if _____53D6_5355_4F4DID(target) ~= _____8BB0_5F55["来源单位ID"] then
        return
    end
    ____schedule_53CD_4F24(attacker, applied * _____8BB0_5F55["反伤倍率"])
end
local function _____786E_4FDD_521D_59CB_5316()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerTargetOrderListener(____on_76EE_6807_6307_4EE4)
    registerPointOrderListener(____on_70B9_6307_4EE4)
    registerImmediateOrderListener(____on_7ACB_5373_6307_4EE4)
    registerAppliedFinalDamageListener(____on_53CD_4F24_6700_7EC8_4F24_5BB3)
    addPeriodicCallback(100, _____6269_5C55_63A7_5236_9A71_52A8Tick)
end
local function _____89C4_8303_5316_6269_5C55_63A7_5236_53C2_6570(_____53C2_6570)
    if type(_____53C2_6570) == "number" then
        return {["持续时间"] = _____53C2_6570}
    end
    return _____53C2_6570
end
local function _____53D6_6301_7EED_65F6_95F4(_____53C2_6570)
    if type(_____53C2_6570) == "number" then
        return _____53C2_6570
    end
    return _____53C2_6570["持续时间"] or 0
end
local function _____6784_5EFA_6269_5C55_63A7_5236_8BB0_5F55(_____7C7B_578B, _____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____5B9E_9645_6301_7EED_65F6_95F4, _____53C2_6570)
    local _____5B9A_4E49 = _____83B7_53D6_6269_5C55_63A7_5236_5B9A_4E49(_____7C7B_578B)
    local _____8BB0_5F55 = {
        ["类型"] = _____7C7B_578B,
        ["来源单位ID"] = _____53D6_5355_4F4DID(_____6765_6E90_5355_4F4D),
        ["来源单位引用"] = _____6765_6E90_5355_4F4D,
        ["目标单位引用"] = _____76EE_6807_5355_4F4D,
        BuffID = _____5B9A_4E49.BuffID,
        ["到期时间"] = getServerTime() + _____5B9E_9645_6301_7EED_65F6_95F4 * 1000,
        ["下次行为时间"] = 0,
        ["原本屏蔽控制命令"] = DzGetUnitDisableControlOrder(_____76EE_6807_5355_4F4D) == true,
        ["反伤倍率"] = 0,
        ["跟随半径"] = _____9ED8_8BA4_9B45_60D1_8DDF_968F_534A_5F84,
        ["恐惧模式"] = "逃离施法者",
        ["逃离距离"] = _____9ED8_8BA4_6050_60E7_9003_79BB_8DDD_79BB,
        ["随机半径"] = _____9ED8_8BA4_6050_60E7_968F_673A_534A_5F84,
        ["原本移动速度"] = GetUnitMoveSpeed(_____76EE_6807_5355_4F4D) or 0,
        ["恐惧移动速度"] = _____9ED8_8BA4_6050_60E7_79FB_52A8_901F_5EA6,
        ["特效句柄"] = nil
    }
    if _____7C7B_578B == "taunt" then
        _____8BB0_5F55["反伤倍率"] = _____53C2_6570["反伤倍率"] or 0
    elseif _____7C7B_578B == "charm" then
        _____8BB0_5F55["跟随半径"] = _____53C2_6570["跟随半径"] or _____9ED8_8BA4_9B45_60D1_8DDF_968F_534A_5F84
    else
        _____8BB0_5F55["恐惧模式"] = _____53C2_6570["模式"] or "逃离施法者"
        _____8BB0_5F55["逃离距离"] = _____53C2_6570["逃离距离"] or _____9ED8_8BA4_6050_60E7_9003_79BB_8DDD_79BB
        _____8BB0_5F55["随机半径"] = _____53C2_6570["随机半径"] or _____9ED8_8BA4_6050_60E7_968F_673A_534A_5F84
        _____8BB0_5F55["恐惧移动速度"] = _____53D6_4E0D_4F4E_4E8E_4E0B_9650(_____53C2_6570["移动速度"] or _____9ED8_8BA4_6050_60E7_79FB_52A8_901F_5EA6, _____9ED8_8BA4_6050_60E7_79FB_52A8_901F_5EA6)
    end
    return _____8BB0_5F55
end
local function _____751F_6548_6269_5C55_63A7_5236_9996_5E27(_____8BB0_5F55)
    DzSetUnitDisableControlOrder(_____8BB0_5F55["目标单位引用"], true)
    DzUnitOrdersForceStop(_____8BB0_5F55["目标单位引用"], true)
    if _____8BB0_5F55["类型"] == "taunt" then
        _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
        IssueTargetOrder(_____8BB0_5F55["目标单位引用"], "attack", _____8BB0_5F55["来源单位引用"])
        _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
        return
    end
    if _____8BB0_5F55["类型"] == "charm" then
        _____8BB0_5F55["特效句柄"] = AddSpecialEffectTarget(_____9B45_60D1_7279_6548_6A21_578B, _____8BB0_5F55["目标单位引用"], _____6269_5C55_63A7_5236_7279_6548_6302_70B9)
        DzUnitDisableAttack(_____8BB0_5F55["目标单位引用"], true)
        _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
        IssuePointOrder(
            _____8BB0_5F55["目标单位引用"],
            "move",
            GetUnitX(_____8BB0_5F55["来源单位引用"]),
            GetUnitY(_____8BB0_5F55["来源单位引用"])
        )
        _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
        return
    end
    _____8BB0_5F55["特效句柄"] = AddSpecialEffectTarget(_____6050_60E7_7279_6548_6A21_578B, _____8BB0_5F55["目标单位引用"], _____6269_5C55_63A7_5236_7279_6548_6302_70B9)
    DzUnitDisableAttack(_____8BB0_5F55["目标单位引用"], true)
    SetUnitMoveSpeed(_____8BB0_5F55["目标单位引用"], _____8BB0_5F55["恐惧移动速度"])
    if _____8BB0_5F55["恐惧模式"] == "随机乱跑" then
        _____6267_884C_6050_60E7_968F_673A_884C_4E3A(
            _____8BB0_5F55,
            getServerTime()
        )
        return
    end
    _____6267_884C_6050_60E7_9003_79BB_884C_4E3A(
        _____8BB0_5F55,
        getServerTime()
    )
end
____exports["施加扩展控制"] = function(_____6765_6E90_5355_4F4D_6216Self, _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D, _____7C7B_578B_6216_76EE_6807_5355_4F4D, _____53C2_6570_6216_7C7B_578B, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____76EE_6807_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
    local _____7C7B_578B = _____7C7B_578B_6216_76EE_6807_5355_4F4D
    local _____53C2_6570 = _____53C2_6570_6216_7C7B_578B
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
        _____76EE_6807_5355_4F4D = _____7C7B_578B_6216_76EE_6807_5355_4F4D
        _____7C7B_578B = _____53C2_6570_6216_7C7B_578B
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____6765_6E90_5355_4F4D) or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____76EE_6807_5355_4F4D) or _____53C2_6570 == nil then
        return 0
    end
    local _____89C4_8303_53C2_6570 = _____89C4_8303_5316_6269_5C55_63A7_5236_53C2_6570(_____53C2_6570)
    local _____5B9E_9645_6301_7EED_65F6_95F4 = _____53D6_6301_7EED_65F6_95F4(_____89C4_8303_53C2_6570)
    if _____5B9E_9645_6301_7EED_65F6_95F4 <= 0 then
        return 0
    end
    if not isExcludedFromControlResist(_____76EE_6807_5355_4F4D) then
        _____5B9E_9645_6301_7EED_65F6_95F4 = calcReducedControlDuration(_____76EE_6807_5355_4F4D, _____5B9E_9645_6301_7EED_65F6_95F4)
    end
    if _____5B9E_9645_6301_7EED_65F6_95F4 <= 0 then
        return 0
    end
    local _____5B9A_4E49 = _____83B7_53D6_63A7_5236_6548_679C_5B9A_4E49(_____7C7B_578B)
    if _____5B9A_4E49 == nil then
        return 0
    end
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____76EE_6807_5355_4F4D)
    if _____76EE_6807ID == 0 then
        return 0
    end
    if _____5B9A_4E49["类型分类"] == "快速控制" then
        if _____5B9A_4E49["快速控制ID"] == nil then
            return 0
        end
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____5B9A_4E49["快速控制ID"], _____5B9E_9645_6301_7EED_65F6_95F4)
        _____901A_77E5_63A7_5236Debuff_4E8B_4EF6({
            ["来源单位"] = _____6765_6E90_5355_4F4D,
            ["目标单位"] = _____76EE_6807_5355_4F4D,
            ["类型"] = _____7C7B_578B,
            ["持续时间"] = _____5B9E_9645_6301_7EED_65F6_95F4,
            ["是否控制"] = true,
            ["原始参数"] = _____89C4_8303_53C2_6570
        })
        debugLogForce(
            _____6A21_5757_540D,
            "施加扩展控制",
            "类型=",
            _____7C7B_578B,
            "来源=",
            _____53D6_5355_4F4DID(_____6765_6E90_5355_4F4D),
            "目标=",
            _____76EE_6807ID,
            "持续=",
            _____5B9E_9645_6301_7EED_65F6_95F4
        )
        return _____76EE_6807ID
    end
    _____786E_4FDD_521D_59CB_5316()
    if _____6269_5C55_63A7_5236_6620_5C04_8868[_____76EE_6807ID] ~= nil then
        _____5185_90E8_6E05_9664_6269_5C55_63A7_5236(_____76EE_6807ID)
    end
    local _____8BB0_5F55 = _____6784_5EFA_6269_5C55_63A7_5236_8BB0_5F55(
        _____7C7B_578B,
        _____6765_6E90_5355_4F4D,
        _____76EE_6807_5355_4F4D,
        _____5B9E_9645_6301_7EED_65F6_95F4,
        _____89C4_8303_53C2_6570
    )
    _____6269_5C55_63A7_5236_6620_5C04_8868[_____76EE_6807ID] = _____8BB0_5F55
    _____52A0_5165_76EE_6807ID(_____76EE_6807ID)
    registerManualBuff(
        _____76EE_6807_5355_4F4D,
        _____8BB0_5F55.BuffID,
        _____5B9E_9645_6301_7EED_65F6_95F4,
        0,
        {sourceName = GetUnitName(_____6765_6E90_5355_4F4D)}
    )
    _____751F_6548_6269_5C55_63A7_5236_9996_5E27(_____8BB0_5F55)
    _____901A_77E5_63A7_5236Debuff_4E8B_4EF6({
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["目标单位"] = _____76EE_6807_5355_4F4D,
        ["类型"] = _____7C7B_578B,
        ["持续时间"] = _____5B9E_9645_6301_7EED_65F6_95F4,
        BuffID = _____8BB0_5F55.BuffID,
        ["是否控制"] = true,
        ["原始参数"] = _____89C4_8303_53C2_6570
    })
    debugLogForce(
        _____6A21_5757_540D,
        "施加扩展控制",
        "类型=",
        _____7C7B_578B,
        "来源=",
        _____53D6_5355_4F4DID(_____6765_6E90_5355_4F4D),
        "目标=",
        _____76EE_6807ID,
        "持续=",
        _____5B9E_9645_6301_7EED_65F6_95F4
    )
    return _____76EE_6807ID
end
____exports["AOE施加扩展控制"] = function(_____6765_6E90_5355_4F4D_6216Self, _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D, _____4E2D_5FC3Y_6216_4E2D_5FC3X, _____534A_5F84_6216_4E2D_5FC3Y, _____7C7B_578B_6216_534A_5F84, _____53C2_6570_6216_7C7B_578B, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____4E2D_5FC3X = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
    local _____4E2D_5FC3Y = _____4E2D_5FC3Y_6216_4E2D_5FC3X
    local _____534A_5F84 = _____534A_5F84_6216_4E2D_5FC3Y
    local _____7C7B_578B = _____7C7B_578B_6216_534A_5F84
    local _____53C2_6570 = _____53C2_6570_6216_7C7B_578B
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
        _____4E2D_5FC3X = _____4E2D_5FC3Y_6216_4E2D_5FC3X
        _____4E2D_5FC3Y = _____534A_5F84_6216_4E2D_5FC3Y
        _____534A_5F84 = _____7C7B_578B_6216_534A_5F84
        _____7C7B_578B = _____53C2_6570_6216_7C7B_578B
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____6765_6E90_5355_4F4D) then
        return {}
    end
    local _____76EE_6807_5217_8868 = getEnemyUnitsInRange(_____6765_6E90_5355_4F4D, _____4E2D_5FC3X, _____4E2D_5FC3Y, _____534A_5F84)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            do
                local _____76EE_6807 = _____76EE_6807_5217_8868[i + 1]
                if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____76EE_6807) then
                    goto __continue106
                end
                local id = ____exports["施加扩展控制"](_____6765_6E90_5355_4F4D, _____76EE_6807, _____7C7B_578B, _____53C2_6570)
                if id ~= 0 then
                    _____7ED3_679C[#_____7ED3_679C + 1] = id
                end
            end
            ::__continue106::
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["移除扩展控制"] = function(_____76EE_6807_5355_4F4D_6216Self, _____7C7B_578B_6216_76EE_6807_5355_4F4D, _____517C_5BB9_7C7B_578B)
    local ____temp_13
    if _____517C_5BB9_7C7B_578B == nil then
        ____temp_13 = _____76EE_6807_5355_4F4D_6216Self
    else
        ____temp_13 = _____7C7B_578B_6216_76EE_6807_5355_4F4D
    end
    local _____76EE_6807_5355_4F4D = ____temp_13
    local _____7C7B_578B = _____517C_5BB9_7C7B_578B or _____7C7B_578B_6216_76EE_6807_5355_4F4D
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____76EE_6807_5355_4F4D)
    if _____76EE_6807ID == 0 then
        return false
    end
    return _____5185_90E8_6E05_9664_6269_5C55_63A7_5236(_____76EE_6807ID, _____7C7B_578B)
end
____exports["单位是否处于扩展控制"] = function(_____76EE_6807_5355_4F4D_6216Self, _____7C7B_578B_6216_76EE_6807_5355_4F4D, _____517C_5BB9_7C7B_578B)
    local ____temp_14
    if _____517C_5BB9_7C7B_578B == nil then
        ____temp_14 = _____76EE_6807_5355_4F4D_6216Self
    else
        ____temp_14 = _____7C7B_578B_6216_76EE_6807_5355_4F4D
    end
    local _____76EE_6807_5355_4F4D = ____temp_14
    local _____7C7B_578B = _____517C_5BB9_7C7B_578B or _____7C7B_578B_6216_76EE_6807_5355_4F4D
    local _____8BB0_5F55 = _____6269_5C55_63A7_5236_6620_5C04_8868[_____53D6_5355_4F4DID(_____76EE_6807_5355_4F4D)]
    if _____8BB0_5F55 == nil then
        return false
    end
    if _____7C7B_578B ~= nil and _____8BB0_5F55["类型"] ~= _____7C7B_578B then
        return false
    end
    return true
end
____exports["获取扩展控制来源单位"] = function(_____76EE_6807_5355_4F4D_6216Self, _____7C7B_578B_6216_76EE_6807_5355_4F4D, _____517C_5BB9_7C7B_578B)
    local ____temp_15
    if _____517C_5BB9_7C7B_578B == nil then
        ____temp_15 = _____76EE_6807_5355_4F4D_6216Self
    else
        ____temp_15 = _____7C7B_578B_6216_76EE_6807_5355_4F4D
    end
    local _____76EE_6807_5355_4F4D = ____temp_15
    local _____7C7B_578B = _____517C_5BB9_7C7B_578B or _____7C7B_578B_6216_76EE_6807_5355_4F4D
    local _____8BB0_5F55 = _____6269_5C55_63A7_5236_6620_5C04_8868[_____53D6_5355_4F4DID(_____76EE_6807_5355_4F4D)]
    if _____8BB0_5F55 == nil or _____8BB0_5F55["类型"] ~= _____7C7B_578B then
        return nil
    end
    return _____8BB0_5F55["来源单位引用"]
end
____exports["施加嘲讽"] = function(_____6765_6E90_5355_4F4D_6216Self, _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D, _____53C2_6570_6216_76EE_6807_5355_4F4D, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____76EE_6807_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
    local _____53C2_6570 = _____53C2_6570_6216_76EE_6807_5355_4F4D
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
        _____76EE_6807_5355_4F4D = _____53C2_6570_6216_76EE_6807_5355_4F4D
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    return ____exports["施加扩展控制"](_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, "taunt", _____53C2_6570)
end
____exports["AOE施加嘲讽"] = function(_____6765_6E90_5355_4F4D_6216Self, _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D, _____4E2D_5FC3Y_6216_4E2D_5FC3X, _____534A_5F84_6216_4E2D_5FC3Y, _____53C2_6570_6216_534A_5F84, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____4E2D_5FC3X = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
    local _____4E2D_5FC3Y = _____4E2D_5FC3Y_6216_4E2D_5FC3X
    local _____534A_5F84 = _____534A_5F84_6216_4E2D_5FC3Y
    local _____53C2_6570 = _____53C2_6570_6216_534A_5F84
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
        _____4E2D_5FC3X = _____4E2D_5FC3Y_6216_4E2D_5FC3X
        _____4E2D_5FC3Y = _____534A_5F84_6216_4E2D_5FC3Y
        _____534A_5F84 = _____53C2_6570_6216_534A_5F84
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    return ____exports["AOE施加扩展控制"](
        _____6765_6E90_5355_4F4D,
        _____4E2D_5FC3X,
        _____4E2D_5FC3Y,
        _____534A_5F84,
        "taunt",
        _____53C2_6570
    )
end
____exports["移除嘲讽"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____exports__79FB_9664_6269_5C55_63A7_5236_17 = ____exports["移除扩展控制"]
    local ____517C_5BB9_76EE_6807_5355_4F4D_16 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_16 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_16 = _____76EE_6807_5355_4F4D_6216Self
    end
    return ____exports__79FB_9664_6269_5C55_63A7_5236_17(____517C_5BB9_76EE_6807_5355_4F4D_16, "taunt")
end
____exports["单位是否被嘲讽"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____exports__5355_4F4D_662F_5426_5904_4E8E_6269_5C55_63A7_5236_19 = ____exports["单位是否处于扩展控制"]
    local ____517C_5BB9_76EE_6807_5355_4F4D_18 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_18 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_18 = _____76EE_6807_5355_4F4D_6216Self
    end
    return ____exports__5355_4F4D_662F_5426_5904_4E8E_6269_5C55_63A7_5236_19(____517C_5BB9_76EE_6807_5355_4F4D_18, "taunt")
end
____exports["获取嘲讽来源单位"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____exports__83B7_53D6_6269_5C55_63A7_5236_6765_6E90_5355_4F4D_21 = ____exports["获取扩展控制来源单位"]
    local ____517C_5BB9_76EE_6807_5355_4F4D_20 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_20 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_20 = _____76EE_6807_5355_4F4D_6216Self
    end
    return ____exports__83B7_53D6_6269_5C55_63A7_5236_6765_6E90_5355_4F4D_21(____517C_5BB9_76EE_6807_5355_4F4D_20, "taunt")
end
____exports["施加魅惑"] = function(_____6765_6E90_5355_4F4D_6216Self, _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D, _____53C2_6570_6216_76EE_6807_5355_4F4D, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____76EE_6807_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
    local _____53C2_6570 = _____53C2_6570_6216_76EE_6807_5355_4F4D
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
        _____76EE_6807_5355_4F4D = _____53C2_6570_6216_76EE_6807_5355_4F4D
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    return ____exports["施加扩展控制"](_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, "charm", _____53C2_6570)
end
____exports["AOE施加魅惑"] = function(_____6765_6E90_5355_4F4D_6216Self, _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D, _____4E2D_5FC3Y_6216_4E2D_5FC3X, _____534A_5F84_6216_4E2D_5FC3Y, _____53C2_6570_6216_534A_5F84, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____4E2D_5FC3X = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
    local _____4E2D_5FC3Y = _____4E2D_5FC3Y_6216_4E2D_5FC3X
    local _____534A_5F84 = _____534A_5F84_6216_4E2D_5FC3Y
    local _____53C2_6570 = _____53C2_6570_6216_534A_5F84
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
        _____4E2D_5FC3X = _____4E2D_5FC3Y_6216_4E2D_5FC3X
        _____4E2D_5FC3Y = _____534A_5F84_6216_4E2D_5FC3Y
        _____534A_5F84 = _____53C2_6570_6216_534A_5F84
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    return ____exports["AOE施加扩展控制"](
        _____6765_6E90_5355_4F4D,
        _____4E2D_5FC3X,
        _____4E2D_5FC3Y,
        _____534A_5F84,
        "charm",
        _____53C2_6570
    )
end
____exports["移除魅惑"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____exports__79FB_9664_6269_5C55_63A7_5236_23 = ____exports["移除扩展控制"]
    local ____517C_5BB9_76EE_6807_5355_4F4D_22 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_22 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_22 = _____76EE_6807_5355_4F4D_6216Self
    end
    return ____exports__79FB_9664_6269_5C55_63A7_5236_23(____517C_5BB9_76EE_6807_5355_4F4D_22, "charm")
end
____exports["单位是否被魅惑"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____exports__5355_4F4D_662F_5426_5904_4E8E_6269_5C55_63A7_5236_25 = ____exports["单位是否处于扩展控制"]
    local ____517C_5BB9_76EE_6807_5355_4F4D_24 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_24 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_24 = _____76EE_6807_5355_4F4D_6216Self
    end
    return ____exports__5355_4F4D_662F_5426_5904_4E8E_6269_5C55_63A7_5236_25(____517C_5BB9_76EE_6807_5355_4F4D_24, "charm")
end
____exports["获取魅惑来源单位"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____exports__83B7_53D6_6269_5C55_63A7_5236_6765_6E90_5355_4F4D_27 = ____exports["获取扩展控制来源单位"]
    local ____517C_5BB9_76EE_6807_5355_4F4D_26 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_26 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_26 = _____76EE_6807_5355_4F4D_6216Self
    end
    return ____exports__83B7_53D6_6269_5C55_63A7_5236_6765_6E90_5355_4F4D_27(____517C_5BB9_76EE_6807_5355_4F4D_26, "charm")
end
____exports["施加恐惧"] = function(_____6765_6E90_5355_4F4D_6216Self, _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D, _____53C2_6570_6216_76EE_6807_5355_4F4D, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____76EE_6807_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
    local _____53C2_6570 = _____53C2_6570_6216_76EE_6807_5355_4F4D
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
        _____76EE_6807_5355_4F4D = _____53C2_6570_6216_76EE_6807_5355_4F4D
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    return ____exports["施加扩展控制"](_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, "fear", _____53C2_6570)
end
____exports["AOE施加恐惧"] = function(_____6765_6E90_5355_4F4D_6216Self, _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D, _____4E2D_5FC3Y_6216_4E2D_5FC3X, _____534A_5F84_6216_4E2D_5FC3Y, _____53C2_6570_6216_534A_5F84, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____4E2D_5FC3X = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
    local _____4E2D_5FC3Y = _____4E2D_5FC3Y_6216_4E2D_5FC3X
    local _____534A_5F84 = _____534A_5F84_6216_4E2D_5FC3Y
    local _____53C2_6570 = _____53C2_6570_6216_534A_5F84
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
        _____4E2D_5FC3X = _____4E2D_5FC3Y_6216_4E2D_5FC3X
        _____4E2D_5FC3Y = _____534A_5F84_6216_4E2D_5FC3Y
        _____534A_5F84 = _____53C2_6570_6216_534A_5F84
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    return ____exports["AOE施加扩展控制"](
        _____6765_6E90_5355_4F4D,
        _____4E2D_5FC3X,
        _____4E2D_5FC3Y,
        _____534A_5F84,
        "fear",
        _____53C2_6570
    )
end
____exports["移除恐惧"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____exports__79FB_9664_6269_5C55_63A7_5236_29 = ____exports["移除扩展控制"]
    local ____517C_5BB9_76EE_6807_5355_4F4D_28 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_28 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_28 = _____76EE_6807_5355_4F4D_6216Self
    end
    return ____exports__79FB_9664_6269_5C55_63A7_5236_29(____517C_5BB9_76EE_6807_5355_4F4D_28, "fear")
end
____exports["单位是否被恐惧"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____exports__5355_4F4D_662F_5426_5904_4E8E_6269_5C55_63A7_5236_31 = ____exports["单位是否处于扩展控制"]
    local ____517C_5BB9_76EE_6807_5355_4F4D_30 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_30 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_30 = _____76EE_6807_5355_4F4D_6216Self
    end
    return ____exports__5355_4F4D_662F_5426_5904_4E8E_6269_5C55_63A7_5236_31(____517C_5BB9_76EE_6807_5355_4F4D_30, "fear")
end
____exports["获取恐惧来源单位"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____exports__83B7_53D6_6269_5C55_63A7_5236_6765_6E90_5355_4F4D_33 = ____exports["获取扩展控制来源单位"]
    local ____517C_5BB9_76EE_6807_5355_4F4D_32 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_32 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_32 = _____76EE_6807_5355_4F4D_6216Self
    end
    return ____exports__83B7_53D6_6269_5C55_63A7_5236_6765_6E90_5355_4F4D_33(____517C_5BB9_76EE_6807_5355_4F4D_32, "fear")
end
return ____exports
