local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.00．配置")
local _____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["利尔伯特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.01．运行时")
local _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6["获取或创建利尔伯特上下文"]
local _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6["利尔伯特单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.02．数值与表现配置")
local _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["利尔伯特技能配置"]
local _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["利尔伯特音效配置"]
local ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具")
local _____76EE_6807_662F_5426_9762_5411_6765_6E90 = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["目标是否面向来源"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
local ____10_FF0E_5229_5C14_B7_4F2F_7279 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.10．利尔·伯特")
local _____5229_5C14_4F2F_7279BuffID = ____10_FF0E_5229_5C14_B7_4F2F_7279["利尔伯特BuffID"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_1["施加快速控制Buff"]
local ____require_result_2 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_2["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_2["关闭吟唱条"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local getBuffRuntime = ____require_result_4.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.01．不死函数")
local _____4EE4_5355_4F4D_4E0D_6B7B = ____require_result_5["令单位不死"]
local _____5355_4F4D_662F_5426_4E0D_6B7B = ____require_result_5["单位是否不死"]
local _____79FB_9664_5355_4F4D_4E0D_6B7B = ____require_result_5["移除单位不死"]
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_6.EC_CreateEffect
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____require_result_8["播放Boss坐标音效"]
local jass = require("jass.common")
local globals = require("jass.globals")
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____5BA1_5224_62F7_95EE_6280_80FDID = stringToFourCCSafe(_____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["审判拷问"])
local _____5BA1_5224_62F7_95EE_5DF2_6CE8_518C = false
local function _____8BFB_53D6_5F53_524D_96BE_5EA6N()
    local _____96BE_5EA6 = __TS__Number(globals.udg_N)
    return _____96BE_5EA6 == _____96BE_5EA6 and _____96BE_5EA6 > 0 and _____96BE_5EA6 or 0
end
local function _____64AD_653E_5BA1_5224_62F7_95EE_7279_6548(_____7279_6548, target)
    EC_CreateEffect(
        _____7279_6548["路径"],
        GetUnitX(target),
        GetUnitY(target),
        _____7279_6548.Z,
        _____7279_6548["朝向"],
        _____7279_6548["缩放"],
        _____7279_6548["动画速度"],
        _____7279_6548["持续秒"]
    )
end
local function ____on_5BA1_5224_62F7_95EE_8BFB_6761_7ED3_675F(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil then
        return
    end
    _____5173_95ED_541F_5531_6761(_____72B6_6001["通道"])
end
local function _____79FB_9664_5BA1_5224_62F7_95EEBuff(_____72B6_6001)
    local buffID = _____5229_5C14_4F2F_7279BuffID["审判拷问"]
    local _____5F53_524DBuff_8FD0_884C_65F6 = getBuffRuntime(_____72B6_6001["目标单位"], buffID)
    if _____72B6_6001["Buff运行时"] ~= nil and _____5F53_524DBuff_8FD0_884C_65F6 == _____72B6_6001["Buff运行时"] then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["目标单位"], buffID)
    end
    _____72B6_6001["Buff运行时"] = nil
end
local function _____6E05_7406_5BA1_5224_62F7_95EE_72B6_6001(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    _____79FB_9664_5BA1_5224_62F7_95EEBuff(_____72B6_6001)
end
local function ____on_5BA1_5224_62F7_95EE_7ED3_7B97(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local target = _____72B6_6001["目标单位"]
    local _____914D_7F6E = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["审判拷问"]
    if not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(boss) or not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(target) then
        _____79FB_9664_5BA1_5224_62F7_95EEBuff(_____72B6_6001)
        return
    end
    local _____662F_5426_9762_5411 = _____76EE_6807_662F_5426_9762_5411_6765_6E90(boss, target, _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["正义审判"]["面向扇区角度"])
    local dx = GetUnitX(target) - _____72B6_6001["快照X"]
    local dy = GetUnitY(target) - _____72B6_6001["快照Y"]
    local _____5B89_5168_534A_5F84_5E73_65B9 = _____914D_7F6E["原位置安全半径"] * _____914D_7F6E["原位置安全半径"]
    local _____662F_5426_79BB_5F00_5FEB_7167_70B9 = dx * dx + dy * dy > _____5B89_5168_534A_5F84_5E73_65B9
    local _____662F_5426_5904_7F5A = not _____662F_5426_9762_5411 and _____662F_5426_79BB_5F00_5FEB_7167_70B9
    if _____662F_5426_5904_7F5A then
        local _____4F24_5BB3_6BD4_4F8B = _____914D_7F6E["基础最大生命比例"] + _____914D_7F6E["每难度N最大生命比例"] * _____8BFB_53D6_5F53_524D_96BE_5EA6N()
        local _____539F_672C_4E0D_6B7B = _____5355_4F4D_662F_5426_4E0D_6B7B(target)
        if not _____539F_672C_4E0D_6B7B then
            _____4EE4_5355_4F4D_4E0D_6B7B(target)
        end
        local _____7ED3_679C = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = boss,
            ["目标"] = target,
            ["技能ID"] = _____5BA1_5224_62F7_95EE_6280_80FDID,
            ["伤害公式"] = {["目标最大生命比例"] = _____4F24_5BB3_6BD4_4F8B},
            attack = false,
            ranged = false,
            attackType = ATTACK_TYPE_NORMAL,
            ["伤害类型"] = DAMAGE_TYPE_MIND,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["标签"] = "利尔·伯特·审判拷问"
        })
        if not _____539F_672C_4E0D_6B7B then
            _____79FB_9664_5355_4F4D_4E0D_6B7B(target)
        end
        if _____7ED3_679C["是否造成伤害"] then
            _____64AD_653E_5BA1_5224_62F7_95EE_7279_6548(_____914D_7F6E["命中特效"], target)
            _____64AD_653EBoss_5750_6807_97F3_6548(
                _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["审判拷问"]["结算命中"],
                GetUnitX(target),
                GetUnitY(target),
                _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["默认裁断距离"]
            )
            _____65BD_52A0_5FEB_901F_63A7_5236Buff(
                boss,
                target,
                0,
                _____914D_7F6E["眩晕秒"],
                "利尔·伯特-审判拷问",
                "技能"
            )
        end
    end
    _____79FB_9664_5BA1_5224_62F7_95EEBuff(_____72B6_6001)
end
____exports["释放利尔伯特审判拷问"] = function(_____4E0A_4E0B_6587, target)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(boss) or not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(target) then
        return false
    end
    local _____914D_7F6E = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["审判拷问"]
    local _____72B6_6001 = {
        ["上下文"] = _____4E0A_4E0B_6587,
        ["目标单位"] = target,
        ["快照X"] = GetUnitX(target),
        ["快照Y"] = GetUnitY(target),
        ["已结束"] = false,
        ["Buff运行时"] = nil
    }
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["施法硬直秒"])
    SetUnitAnimationByIndex(boss, _____914D_7F6E["动作编号"])
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["通魔施法秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    _____64AD_653E_5BA1_5224_62F7_95EE_7279_6548(_____914D_7F6E["起始特效"], target)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["审判拷问"]["锁定"],
        GetUnitX(target),
        GetUnitY(target),
        _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    registerManualBuff(
        target,
        _____5229_5C14_4F2F_7279BuffID["审判拷问"],
        _____914D_7F6E["持续秒"],
        0,
        {sourceUnit = boss, effectSourceName = "审判拷问", effectSourceType = "技能"}
    )
    _____72B6_6001["Buff运行时"] = getBuffRuntime(target, _____5229_5C14_4F2F_7279BuffID["审判拷问"])
    local ____self_11 = _____4E0A_4E0B_6587["清理"]
    ____self_11["登记清理"](____self_11, "审判拷问状态清理", _____6E05_7406_5BA1_5224_62F7_95EE_72B6_6001, _____72B6_6001)
    local _____8BFB_6761_56DE_8C03ID = addDelayedCallback(_____914D_7F6E["通魔施法秒"] * 1000, ____on_5BA1_5224_62F7_95EE_8BFB_6761_7ED3_675F, {["通道"] = _____914D_7F6E["读条通道"], ["Boss单位"] = boss})
    local ____self_12 = _____4E0A_4E0B_6587["清理"]
    ____self_12["登记延迟回调"](____self_12, "审判拷问读条结束", _____8BFB_6761_56DE_8C03ID)
    local _____7ED3_7B97_56DE_8C03ID = addDelayedCallback(_____914D_7F6E["持续秒"] * 1000, ____on_5BA1_5224_62F7_95EE_7ED3_7B97, _____72B6_6001)
    local ____self_13 = _____4E0A_4E0B_6587["清理"]
    ____self_13["登记延迟回调"](____self_13, "审判拷问结算", _____7ED3_7B97_56DE_8C03ID)
    return true
end
local function ____on_5229_5C14_4F2F_7279_5BA1_5224_62F7_95EE_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____5BA1_5224_62F7_95EE_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587(castingUnit)
    if _____4E0A_4E0B_6587 ~= nil then
        ____exports["释放利尔伯特审判拷问"](
            _____4E0A_4E0B_6587,
            GetSpellTargetUnit()
        )
    end
end
____exports["注册利尔伯特审判拷问"] = function()
    if _____5BA1_5224_62F7_95EE_5DF2_6CE8_518C then
        return
    end
    _____5BA1_5224_62F7_95EE_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_5229_5C14_4F2F_7279_5BA1_5224_62F7_95EE_751F_6548)
end
return ____exports
