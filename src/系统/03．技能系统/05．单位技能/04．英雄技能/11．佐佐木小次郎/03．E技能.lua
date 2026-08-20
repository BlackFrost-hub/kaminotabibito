--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00．配置")
local _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["佐佐木单位技能配置"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00B．分身与状态管理")
local _____662F_4F50_4F50_6728_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是佐佐木本体"]
local ____11_FF0E_4F50_4F50_6728_5C0F_6B21_90CE = require("系统.05．Buff系统.03．Buff表.02．英雄.11．佐佐木小次郎")
local _____4F50_4F50_6728_5C0F_6B21_90CEBuffID = ____11_FF0E_4F50_4F50_6728_5C0F_6B21_90CE["佐佐木小次郎BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellChannelListener = ____require_result_2.registerSpellChannelListener
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_3["调整玩家属性"]
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_3["临时调整攻击"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____require_result_4["读取单位最大生命"]
local _____5355_4F4D_5B58_6D3B = ____require_result_4["单位存活"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
local _____5411_4E0B_53D6_6574_6574_6570 = ____require_result_5["向下取整整数"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_6.getUnitsInRange
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_7.isUnitEnemy
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态")
local _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5 = ____require_result_8["单位是否正在原生施法"]
local ____require_result_9 = require("系统.01．单位系统.06．仇恨系统.06．对外接口")
local _____589E_52A0_5355_4F4D_4EC7_6068 = ____require_result_9["增加单位仇恨"]
local ____require_result_10 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local getThreat = ____require_result_10.getThreat
local ____require_result_11 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.index")
local _____65BD_52A0_5632_8BBD = ____require_result_11["施加嘲讽"]
local ____require_result_12 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_12.YDWESetUnitAbilityStateSafe
local ____require_result_13 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_13.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_13["移除单位指定Buff"]
local ____E_6280_80FDID_6570_503C = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["E技能ID"])
local _____65BD_6CD5_8FDB_5EA6_6761ID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.E["施法进度条ID"])
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local IsUnitType = jass.IsUnitType
local IssueTargetOrder = jass.IssueTargetOrder
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
--- 止水结束：解除减伤、移除进度条，并按是否完整施法结算
local function _____7ED3_675F_6B62_6C34(_____82F1_96C4, _____65BD_6CD5_8FDB_5EA6_6761, _____662F_5426_5B8C_6574_65BD_6CD5)
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.E
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____82F1_96C4, "伤害减少", -cfg["减伤比例"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4F50_4F50_6728_5C0F_6B21_90CEBuffID["止水"])
    jass.SetUnitAnimation(_____82F1_96C4, "stand")
    if _____65BD_6CD5_8FDB_5EA6_6761 ~= nil and _____65BD_6CD5_8FDB_5EA6_6761 ~= 0 then
        RemoveUnit(_____65BD_6CD5_8FDB_5EA6_6761)
    end
    if not _____662F_5426_5B8C_6574_65BD_6CD5 then
        YDWESetUnitAbilityStateSafe(_____82F1_96C4, ____E_6280_80FDID_6570_503C, 1, cfg["失败冷却秒"])
        return
    end
    local effect = AddSpecialEffectTarget(cfg["完成特效模型"], _____82F1_96C4, "origin")
    if effect ~= nil and effect ~= 0 then
        addDelayedCallback(
            cfg["完成特效持续秒"] * 1000,
            function()
                DestroyEffect(effect)
            end
        )
    end
    local _____5F53_524D_751F_547D = GetUnitState(_____82F1_96C4, UNIT_STATE_LIFE)
    local _____6700_5927_751F_547D = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(_____82F1_96C4)
    local _____6062_590D_540E_751F_547D = _____5F53_524D_751F_547D + _____6700_5927_751F_547D * cfg["恢复生命比例"]
    local _____65B0_751F_547D = _____6062_590D_540E_751F_547D > _____6700_5927_751F_547D and _____6700_5927_751F_547D or _____6062_590D_540E_751F_547D
    SetUnitState(_____82F1_96C4, UNIT_STATE_LIFE, _____65B0_751F_547D)
    local _____653B_51FB_52A0_6210 = _____5411_4E0B_53D6_6574_6574_6570(_____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____82F1_96C4) * cfg["增攻比例"])
    if _____653B_51FB_52A0_6210 > 0 then
        _____4E34_65F6_8C03_6574_653B_51FB(_____82F1_96C4, _____653B_51FB_52A0_6210)
        registerManualBuff(
            _____82F1_96C4,
            _____4F50_4F50_6728_5C0F_6B21_90CEBuffID["宗和的心得"],
            cfg["增攻持续秒"],
            _____653B_51FB_52A0_6210,
            {sourceName = "佐佐木小次郎-止水"}
        )
        addDelayedCallback(
            cfg["增攻持续秒"] * 1000,
            function()
                if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
                    return
                end
                _____4E34_65F6_8C03_6574_653B_51FB(_____82F1_96C4, -_____653B_51FB_52A0_6210)
            end
        )
    end
end
local function ____on_4F50_4F50_6728E_5F00_59CB(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if not _____662F_4F50_4F50_6728_672C_4F53(_____65BD_6CD5_5355_4F4D) then
        return
    end
    if _____6280_80FDID_6570_503C ~= ____E_6280_80FDID_6570_503C then
        return
    end
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.E
    local _____65BD_6CD5X = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____65BD_6CD5Y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    local targets = getUnitsInRange(_____65BD_6CD5X, _____65BD_6CD5Y, cfg["嘲讽范围"])
    do
        local i = 0
        while i < #targets do
            do
                local enemy = targets[i + 1]
                if enemy == nil or enemy == 0 then
                    goto __continue14
                end
                if not _____5355_4F4D_5B58_6D3B(enemy) then
                    goto __continue14
                end
                if IsUnitType(enemy, jass.UNIT_TYPE_ANCIENT) then
                    goto __continue14
                end
                if IsUnitType(enemy, jass.UNIT_TYPE_MECHANICAL) then
                    goto __continue14
                end
                if IsUnitType(enemy, jass.UNIT_TYPE_STRUCTURE) then
                    goto __continue14
                end
                if not isUnitEnemy(enemy, _____65BD_6CD5_5355_4F4D) then
                    goto __continue14
                end
                IssueTargetOrder(enemy, "attackonce", _____65BD_6CD5_5355_4F4D)
                _____65BD_52A0_5632_8BBD(_____65BD_6CD5_5355_4F4D, enemy, {["持续时间"] = cfg["嘲讽持续秒"]})
                local _____5F53_524D_5632_8BBD = getThreat(enemy, _____65BD_6CD5_5355_4F4D)
                if _____5F53_524D_5632_8BBD > 0 then
                    _____589E_52A0_5355_4F4D_4EC7_6068(enemy, _____65BD_6CD5_5355_4F4D, _____5F53_524D_5632_8BBD * 0.3)
                end
            end
            ::__continue14::
            i = i + 1
        end
    end
    addDelayedCallback(
        30,
        function()
            if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_5355_4F4D) then
                return
            end
            jass.SetUnitAnimationByIndex(_____65BD_6CD5_5355_4F4D, 14)
            local _____65BD_6CD5_8FDB_5EA6_6761 = CreateUnit(
                jass.Player(4),
                _____65BD_6CD5_8FDB_5EA6_6761ID,
                GetUnitX(_____65BD_6CD5_5355_4F4D),
                GetUnitY(_____65BD_6CD5_5355_4F4D),
                0
            )
            _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "伤害减少", cfg["减伤比例"])
            registerManualBuff(
                _____65BD_6CD5_5355_4F4D,
                _____4F50_4F50_6728_5C0F_6B21_90CEBuffID["止水"],
                cfg["止水持续秒"],
                cfg["减伤比例"],
                {sourceName = "佐佐木小次郎-止水"}
            )
            SetUnitTimeScale(_____65BD_6CD5_8FDB_5EA6_6761, 0.5)
            SetUnitFlyHeight(
                _____65BD_6CD5_8FDB_5EA6_6761,
                GetUnitDefaultFlyHeight(_____65BD_6CD5_5355_4F4D) + 233,
                0
            )
            local _____5DF2_5F15_5BFC_6BEB_79D2 = 0
            local _____8F6E_8BE2ID
            _____8F6E_8BE2ID = addPeriodicCallback(
                40,
                function()
                    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_5355_4F4D) then
                        removePeriodicCallback(_____8F6E_8BE2ID)
                        if _____65BD_6CD5_8FDB_5EA6_6761 ~= nil and _____65BD_6CD5_8FDB_5EA6_6761 ~= 0 then
                            RemoveUnit(_____65BD_6CD5_8FDB_5EA6_6761)
                        end
                        _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "伤害减少", -cfg["减伤比例"])
                        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_5355_4F4D, _____4F50_4F50_6728_5C0F_6B21_90CEBuffID["止水"])
                        return
                    end
                    _____5DF2_5F15_5BFC_6BEB_79D2 = _____5DF2_5F15_5BFC_6BEB_79D2 + 40
                    SetUnitX(
                        _____65BD_6CD5_8FDB_5EA6_6761,
                        GetUnitX(_____65BD_6CD5_5355_4F4D)
                    )
                    SetUnitY(
                        _____65BD_6CD5_8FDB_5EA6_6761,
                        GetUnitY(_____65BD_6CD5_5355_4F4D)
                    )
                    if _____5DF2_5F15_5BFC_6BEB_79D2 >= cfg["止水持续秒"] * 1000 then
                        removePeriodicCallback(_____8F6E_8BE2ID)
                        _____7ED3_675F_6B62_6C34(_____65BD_6CD5_5355_4F4D, _____65BD_6CD5_8FDB_5EA6_6761, true)
                        return
                    end
                    if not _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5(_____65BD_6CD5_5355_4F4D) then
                        removePeriodicCallback(_____8F6E_8BE2ID)
                        _____7ED3_675F_6B62_6C34(_____65BD_6CD5_5355_4F4D, _____65BD_6CD5_8FDB_5EA6_6761, false)
                    end
                end
            )
        end
    )
end
registerSpellChannelListener(____on_4F50_4F50_6728E_5F00_59CB)
return ____exports
