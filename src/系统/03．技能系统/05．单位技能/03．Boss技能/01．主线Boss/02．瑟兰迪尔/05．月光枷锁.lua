local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____64AD_653E_6708_5149_67B7_9501_65BD_6CD5_52A8_4F5C, _____8BA9_5355_4F4D_9762_5411_76EE_6807, _____53D1_5C04_6708_5149_67B7_9501_5F39_5E55, _____64AD_653E_6708_5149_67B7_9501_547D_4E2D_7279_6548, _____7ED3_7B97_6708_5149_67B7_9501Tick_4F24_5BB3, _____6E05_7406_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55, _____521B_5EFA_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55, _____6E05_7406_6708_5149_67B7_9501_63A7_5236, _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, jass, addDelayedCallback, _____5F00_59CB_786C_76F4, _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761, _____5173_95ED_541F_5531_6761, _____521B_5EFA_539F_751F_5F39_5E55, _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9, _____65BD_52A0_6269_5C55_63A7_5236, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, createTimedUnitEffect, Sound3DII_CooPlayReuse, GetUnitName, R2I, GetUnitX, GetUnitY, GetUnitFacing, SetUnitFacing, Atan2, GetHandleId, SetUnitAnimationByIndex, SetUnitTimeScale, UnitRemoveAbility, _____6708_5149_67B7_9501_6280_80FDID, BJ_RADTODEG, _____6708_5149_67B7_9501_6839_987BBuffID, _____6708_5149_67B7_9501_539F_751F_6839_987BBuff, _____6708_5149_67B7_9501_7ED1_5B9A_8868
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建瑟兰迪尔上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.00．配置")
local _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["瑟兰迪尔单位技能配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_53E5_67C4_5B58_5728 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位句柄存在"]
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
function _____64AD_653E_6708_5149_67B7_9501_65BD_6CD5_52A8_4F5C(caster)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____5F00_59CB_786C_76F4(caster, config["施法硬直秒"])
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = config["施法硬直秒"], ["颜色ID"] = config["吟唱条颜色ID"], ["标题文本"] = config["吟唱条标题文本"], ["提示文本"] = config["吟唱条提示文本"]})
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = caster,
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["持续秒"] = config["施法硬直秒"],
        ["重播时点秒列表"] = {config["动画重播延迟Ms"] / 1000},
        ["恢复动画编号"] = config["恢复动画编号"],
        ["恢复动画速度"] = config["恢复动画速度"]
    })
end
function _____8BA9_5355_4F4D_9762_5411_76EE_6807(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local angle = Atan2(
        GetUnitY(target) - GetUnitY(caster),
        GetUnitX(target) - GetUnitX(caster)
    ) * BJ_RADTODEG
    SetUnitFacing(caster, angle)
end
function _____53D1_5C04_6708_5149_67B7_9501_5F39_5E55(caster, target, context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    local targetId = GetHandleId(target)
    local _____5DF2_547D_4E2D = false
    local function _____6708_5149_67B7_9501_5F39_5E55_76EE_6807_7B5B_9009(_____76EE_6807_5355_4F4D)
        return _____5355_4F4D_6709_6548(_____76EE_6807_5355_4F4D) and GetHandleId(_____76EE_6807_5355_4F4D) == targetId
    end
    local function _____6708_5149_67B7_9501_5F39_5E55_547D_4E2D(_____547D_4E2D_5355_4F4D)
        if _____5DF2_547D_4E2D then
            return
        end
        _____5DF2_547D_4E2D = true
        _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D(caster, _____547D_4E2D_5355_4F4D, context)
    end
    local function _____6708_5149_67B7_9501_5F39_5E55_5230_8FBE_76EE_6807_70B9()
        if _____5DF2_547D_4E2D or not _____5355_4F4D_6709_6548(target) then
            return
        end
        _____5DF2_547D_4E2D = true
        _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D(caster, target, context)
    end
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = caster,
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        ["方向角"] = GetUnitFacing(caster),
        ["指定目标"] = target,
        ["速度"] = config["飞行速度"],
        ["轨迹采样器"] = _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9(target, config["命中半径"]),
        ["命中半径"] = config["命中半径"],
        ["生命周期"] = 3,
        ["最大距离"] = config["最大飞行距离"],
        ["碰撞消失"] = true,
        ["最大总命中次数"] = 1,
        ["每单位最大命中次数"] = 1,
        ["模型"] = config["飞行特效"],
        ["附着特效模型"] = config["飞行特效"],
        ["飞行高度"] = 80,
        ["影响目标"] = "全部",
        ["目标筛选"] = _____6708_5149_67B7_9501_5F39_5E55_76EE_6807_7B5B_9009,
        ["on命中"] = _____6708_5149_67B7_9501_5F39_5E55_547D_4E2D,
        ["on命中单位"] = _____6708_5149_67B7_9501_5F39_5E55_547D_4E2D,
        ["on到达目标点"] = _____6708_5149_67B7_9501_5F39_5E55_5230_8FBE_76EE_6807_70B9
    })
end
function _____64AD_653E_6708_5149_67B7_9501_547D_4E2D_7279_6548(target)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    createTimedUnitEffect(target, "origin", config["命中特效"], config["定身秒"])
end
function _____7ED3_7B97_6708_5149_67B7_9501Tick_4F24_5BB3(caster, target, tickIndex, _____8BB0_5F55)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    local targetId = GetHandleId(target)
    addDelayedCallback(
        R2I(config["Tick间隔秒"] * tickIndex * 1000),
        function()
            if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
                return
            end
            if _____6708_5149_67B7_9501_7ED1_5B9A_8868[targetId] ~= _____8BB0_5F55 then
                return
            end
            local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(caster, target, {["来源攻击力比例"] = config["Tick伤害Boss攻击力比例"], ["目标最大生命比例"] = config["Tick伤害目标最大生命比例"], ["总倍率"] = config["Tick伤害总倍率"]})
            _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                ["技能ID"] = _____6708_5149_67B7_9501_6280_80FDID,
                ["来源"] = caster,
                ["目标"] = target,
                ["伤害"] = damage,
                attack = false,
                ranged = false,
                attackType = jass.ATTACK_TYPE_NORMAL,
                ["伤害类型"] = jass.DAMAGE_TYPE_PLANT,
                weaponType = jass.WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "Boss技能"
            })
        end
    )
end
function _____6E05_7406_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55(targetId, _____8BB0_5F55, _____6E05_7406_63A7_5236)
    if _____6708_5149_67B7_9501_7ED1_5B9A_8868[targetId] ~= _____8BB0_5F55 then
        return false
    end
    __TS__Delete(_____6708_5149_67B7_9501_7ED1_5B9A_8868, targetId)
    if _____6E05_7406_63A7_5236 then
        _____6E05_7406_6708_5149_67B7_9501_63A7_5236(_____8BB0_5F55["目标单位"])
    end
    return true
end
function _____521B_5EFA_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55(caster, target, context)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return nil
    end
    local ____temp_13 = context ~= nil
    if ____temp_13 then
        local ____self_12 = context["清理"]
        ____temp_13 = ____self_12["已清理"](____self_12)
    end
    if ____temp_13 then
        return nil
    end
    local targetId = GetHandleId(target)
    local _____65E7_8BB0_5F55 = _____6708_5149_67B7_9501_7ED1_5B9A_8868[targetId]
    if _____65E7_8BB0_5F55 ~= nil then
        _____6E05_7406_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55(targetId, _____65E7_8BB0_5F55, true)
    end
    local _____8BB0_5F55 = {["来源单位"] = caster, ["目标单位"] = target, ["已承受打断伤害"] = 0}
    _____6708_5149_67B7_9501_7ED1_5B9A_8868[targetId] = _____8BB0_5F55
    if context ~= nil then
        local ____self_14 = context["清理"]
        ____self_14["登记清理"](
            ____self_14,
            "月光枷锁绑定",
            function()
                _____6E05_7406_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55(targetId, _____8BB0_5F55, true)
            end
        )
    end
    return _____8BB0_5F55
end
function _____6E05_7406_6708_5149_67B7_9501_63A7_5236(target)
    if not _____5355_4F4D_53E5_67C4_5B58_5728(target) then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, config.BuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____6708_5149_67B7_9501_6839_987BBuffID)
    UnitRemoveAbility(target, _____6708_5149_67B7_9501_539F_751F_6839_987BBuff)
end
____exports["释放瑟兰迪尔月光枷锁效果"] = function(caster, target, context)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(caster, "月光枷锁")
    _____8BA9_5355_4F4D_9762_5411_76EE_6807(caster, target)
    _____64AD_653E_6708_5149_67B7_9501_65BD_6CD5_52A8_4F5C(caster)
    addDelayedCallback(
        R2I(config["施法硬直秒"] * 1000),
        function()
            _____5173_95ED_541F_5531_6761("常规技能")
            if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
                return
            end
            _____8BA9_5355_4F4D_9762_5411_76EE_6807(caster, target)
            SetUnitTimeScale(caster, config["恢复动画速度"])
            SetUnitAnimationByIndex(caster, config["恢复动画编号"])
            _____53D1_5C04_6708_5149_67B7_9501_5F39_5E55(caster, target, context)
        end
    )
end
function _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D(caster, target, context)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    local _____8BB0_5F55 = _____521B_5EFA_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55(caster, target, context)
    if _____8BB0_5F55 == nil then
        return
    end
    local targetId = GetHandleId(target)
    Sound3DII_CooPlayReuse(
        config["命中音效"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        config["命中音效裁断距离"]
    )
    _____64AD_653E_6708_5149_67B7_9501_547D_4E2D_7279_6548(target)
    _____65BD_52A0_6269_5C55_63A7_5236(caster, target, "roots", {["持续时间"] = config["定身秒"]})
    registerManualBuff(
        target,
        config.BuffID,
        config["定身秒"],
        0,
        {
            sourceName = GetUnitName(caster),
            iconOverride = "BuffIcon\\Boss\\Thranduil\\yueguangjiasuo.blp",
            effectModelOverride = config["命中特效"]
        }
    )
    do
        local i = 1
        while i <= config["定身秒"] do
            _____7ED3_7B97_6708_5149_67B7_9501Tick_4F24_5BB3(caster, target, i, _____8BB0_5F55)
            i = i + 1
        end
    end
    addDelayedCallback(
        R2I(config["定身秒"] * 1000) + 1,
        function()
            _____6E05_7406_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55(targetId, _____8BB0_5F55, true)
        end
    )
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
jass = require("jass.common")
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
_____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_3["显示常规技能吟唱条"]
_____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
_____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_4["创建原生弹幕"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index")
_____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9 = ____require_result_5["创建追踪插值轨迹"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
_____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_6["施加扩展控制"]
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_7.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_7["移除单位指定Buff"]
local ____require_result_8 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_8.registerAppliedFinalDamageListener
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.14．月光碎片")
local _____521B_5EFA_745F_5170_8FEA_5C14_6708_5149_788E_7247 = ____require_result_9["创建瑟兰迪尔月光碎片"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedUnitEffect = ____require_result_10.createTimedUnitEffect
local ____require_result_11 = require("lib.扩展函数.封装函数.02．音效系统.index")
Sound3DII_CooPlayReuse = ____require_result_11.Sound3DII_CooPlayReuse
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitName = jass.GetUnitName
R2I = jass.R2I
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
SetUnitFacing = jass.SetUnitFacing
Atan2 = jass.Atan2
GetHandleId = jass.GetHandleId
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
UnitRemoveAbility = jass.UnitRemoveAbility
local _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____6708_5149_67B7_9501_6280_80FDID = stringToFourCC(_____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]["技能槽位"])
local _____6708_5149_67B7_9501_5DF2_6CE8_518C = false
BJ_RADTODEG = 57.29577951308232
_____6708_5149_67B7_9501_6839_987BBuffID = "C017"
_____6708_5149_67B7_9501_539F_751F_6839_987BBuff = 1111844210
_____6708_5149_67B7_9501_7ED1_5B9A_8868 = {}
local function _____6253_65AD_6708_5149_67B7_9501_5E76_6389_843D_788E_7247(target)
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local targetId = GetHandleId(target)
    local _____8BB0_5F55 = _____6708_5149_67B7_9501_7ED1_5B9A_8868[targetId]
    if _____8BB0_5F55 == nil then
        return false
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____6E05_7406_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55(targetId, _____8BB0_5F55, true)
    addDelayedCallback(
        0,
        function()
            _____6E05_7406_6708_5149_67B7_9501_63A7_5236(target)
        end
    )
    addDelayedCallback(
        120,
        function()
            _____6E05_7406_6708_5149_67B7_9501_63A7_5236(target)
        end
    )
    _____521B_5EFA_745F_5170_8FEA_5C14_6708_5149_788E_7247(
        GetUnitX(target),
        GetUnitY(target)
    )
    return true
end
local function ____on_6708_5149_67B7_9501_627F_53D7_4F24_5BB3(target, attacker, applied, _snapshot)
    if applied <= 0 or not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_6709_6548(attacker) then
        return
    end
    local targetId = GetHandleId(target)
    local _____8BB0_5F55 = _____6708_5149_67B7_9501_7ED1_5B9A_8868[targetId]
    if _____8BB0_5F55 == nil then
        return
    end
    if attacker == _____8BB0_5F55["来源单位"] then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____8BB0_5F55["已承受打断伤害"] = _____8BB0_5F55["已承受打断伤害"] + applied
    if _____8BB0_5F55["已承受打断伤害"] >= config["打断所需伤害"] then
        _____6253_65AD_6708_5149_67B7_9501_5E76_6389_843D_788E_7247(target)
    end
end
____exports["释放瑟兰迪尔月光枷锁"] = function(_context, _target)
    ____exports["释放瑟兰迪尔月光枷锁效果"](_context["Boss单位"], _target, _context)
end
____exports["立即打断瑟兰迪尔月光枷锁"] = function(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return false
    end
    if _____6708_5149_67B7_9501_7ED1_5B9A_8868[GetHandleId(target)] == nil then
        _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D(caster, target)
    end
    return _____6253_65AD_6708_5149_67B7_9501_5E76_6389_843D_788E_7247(target)
end
local function ____on_745F_5170_8FEA_5C14_6708_5149_67B7_9501_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6708_5149_67B7_9501_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID then
        return
    end
    local target = GetSpellTargetUnit()
    local context = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放瑟兰迪尔月光枷锁效果"](castingUnit, target, context)
end
____exports["注册瑟兰迪尔月光枷锁"] = function()
    if _____6708_5149_67B7_9501_5DF2_6CE8_518C then
        return
    end
    _____6708_5149_67B7_9501_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "瑟兰迪尔月光枷锁",
        ["单位类型ID"] = _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6708_5149_67B7_9501_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_745F_5170_8FEA_5C14_6708_5149_67B7_9501_751F_6548(boss, _____6708_5149_67B7_9501_6280_80FDID)
        end
    })
    registerAppliedFinalDamageListener(____on_6708_5149_67B7_9501_627F_53D7_4F24_5BB3)
end
return ____exports
