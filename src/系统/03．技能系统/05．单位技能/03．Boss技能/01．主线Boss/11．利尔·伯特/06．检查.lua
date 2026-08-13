local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.00．配置")
local _____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["利尔伯特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.01．运行时")
local _____83B7_53D6_5229_5C14_4F2F_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6["获取利尔伯特上下文"]
local _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6["获取或创建利尔伯特上下文"]
local _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6["利尔伯特单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.02．数值与表现配置")
local _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["利尔伯特技能配置"]
local _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["利尔伯特音效配置"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____10_FF0E_5229_5C14_B7_4F2F_7279 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.10．利尔·伯特")
local _____5229_5C14_4F2F_7279BuffID = ____10_FF0E_5229_5C14_B7_4F2F_7279["利尔伯特BuffID"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_3["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local removeDelayedCallback = ____require_result_4.removeDelayedCallback
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_5["移除单位指定Buff"]
local ____require_result_6 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_6["获取Boss技能敌对英雄列表"]
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_7.EC_CreateEffect
local ____require_result_8 = require("lib.扩展函数.物品相关函数.装备数据查询")
local getItemDataEntry = ____require_result_8.getItemDataEntry
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____require_result_10["播放Boss坐标音效"]
local jass = require("jass.common")
local globals = require("jass.globals")
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local UnitItemInSlot = jass.UnitItemInSlot
local UnitAddItem = jass.UnitAddItem
local UnitRemoveItem = jass.UnitRemoveItem
local SetItemPosition = jass.SetItemPosition
local GetItemTypeId = jass.GetItemTypeId
local GetRandomInt = jass.GetRandomInt
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____68C0_67E5_6280_80FDID = stringToFourCCSafe(_____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["检查"])
local _____68C0_67E5_5DF2_6CE8_518C = false
local function _____8BFB_53D6_5F53_524D_96BE_5EA6N()
    local _____96BE_5EA6 = __TS__Number(globals.udg_N)
    return _____96BE_5EA6 == _____96BE_5EA6 and _____96BE_5EA6 > 0 and _____96BE_5EA6 or 0
end
local function _____68C0_67E5_7269_54C1_6709_6548(item)
    return item ~= nil and item ~= 0 and GetItemTypeId(item) ~= 0
end
local function _____83B7_53D6_53EF_68C0_67E5_88C5_5907_5217_8868(target)
    local _____88C5_5907_5217_8868 = {}
    do
        local slot = 0
        while slot <= 5 do
            local item = UnitItemInSlot(target, slot)
            if _____68C0_67E5_7269_54C1_6709_6548(item) and getItemDataEntry(item) ~= nil then
                _____88C5_5907_5217_8868[#_____88C5_5907_5217_8868 + 1] = item
            end
            slot = slot + 1
        end
    end
    return _____88C5_5907_5217_8868
end
local function _____653E_4E0B_539F_68C0_67E5_88C5_5907(_____72B6_6001)
    local item = _____72B6_6001["装备"]
    if not _____68C0_67E5_7269_54C1_6709_6548(item) then
        return false
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local target = _____72B6_6001["目标单位"]
    local _____951A_70B9 = boss
    if boss == nil or boss == 0 or GetUnitTypeId(boss) == 0 then
        _____951A_70B9 = target
    end
    if _____951A_70B9 == nil or _____951A_70B9 == 0 or GetUnitTypeId(_____951A_70B9) == 0 then
        return false
    end
    if boss ~= nil and boss ~= 0 and GetUnitTypeId(boss) ~= 0 then
        UnitRemoveItem(boss, item)
    end
    SetItemPosition(
        item,
        GetUnitX(_____951A_70B9),
        GetUnitY(_____951A_70B9)
    )
    return true
end
local function _____7ED3_675F_68C0_67E5_72B6_6001(_____72B6_6001)
    if _____72B6_6001["阶段"] == "已结束" then
        return
    end
    local _____7ED3_675F_524D_9636_6BB5 = _____72B6_6001["阶段"]
    if _____72B6_6001["正常结束回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["正常结束回调ID"])
        _____72B6_6001["正常结束回调ID"] = 0
    end
    if _____72B6_6001["失败惩罚回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["失败惩罚回调ID"])
        _____72B6_6001["失败惩罚回调ID"] = 0
    end
    if _____7ED3_675F_524D_9636_6BB5 == "检查中" then
        _____653E_4E0B_539F_68C0_67E5_88C5_5907(_____72B6_6001)
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["上下文"]["Boss单位"], _____5229_5C14_4F2F_7279BuffID["检查中"])
    _____72B6_6001["阶段"] = "已结束"
    if _____72B6_6001["上下文"]["检查状态"] == _____72B6_6001 then
        _____72B6_6001["上下文"]["检查状态"] = nil
    end
end
local function ____on_68C0_67E5_8FD0_884C_65F6_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["阶段"] == "已结束" then
        return
    end
    _____7ED3_675F_68C0_67E5_72B6_6001(_____72B6_6001)
end
local function ____on_68C0_67E5_8BFB_6761_7ED3_675F(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil then
        return
    end
    _____5173_95ED_541F_5531_6761(_____72B6_6001["通道"])
end
local function ____on_68C0_67E5_6B63_5E38_7ED3_675F(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["阶段"] ~= "检查中" or _____72B6_6001["上下文"]["检查状态"] ~= _____72B6_6001 then
        return
    end
    _____72B6_6001["正常结束回调ID"] = 0
    _____7ED3_675F_68C0_67E5_72B6_6001(_____72B6_6001)
end
local function ____on_68C0_67E5_5931_8D25_60E9_7F5A(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["阶段"] ~= "失败等待惩罚" or _____72B6_6001["上下文"]["检查状态"] ~= _____72B6_6001 then
        return
    end
    _____72B6_6001["失败惩罚回调ID"] = 0
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    if not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(boss) then
        _____7ED3_675F_68C0_67E5_72B6_6001(_____72B6_6001)
        return
    end
    local _____914D_7F6E = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["检查"]
    local _____76EE_6807_5217_8868 = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            do
                local target = _____76EE_6807_5217_8868[i + 1]
                if not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(target) then
                    goto __continue29
                end
                local _____7ED3_679C = _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["技能ID"] = _____68C0_67E5_6280_80FDID,
                    ["伤害公式"] = {["目标最大生命比例"] = _____914D_7F6E["目标最大生命比例"], ["来源攻击力比例"] = _____914D_7F6E["Boss攻击力比例"]},
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = "利尔·伯特·检查失败"
                })
                if _____7ED3_679C["是否造成伤害"] then
                    local _____7279_6548 = _____914D_7F6E["失败惩罚命中特效"]
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
                    _____64AD_653EBoss_5750_6807_97F3_6548(
                        _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["检查"]["失败惩罚"],
                        GetUnitX(target),
                        GetUnitY(target),
                        _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["默认裁断距离"]
                    )
                end
            end
            ::__continue29::
            i = i + 1
        end
    end
    _____7ED3_675F_68C0_67E5_72B6_6001(_____72B6_6001)
end
local function _____89E6_53D1_68C0_67E5_5931_8D25(_____72B6_6001, _____9608_503C)
    if _____72B6_6001["阶段"] ~= "检查中" or _____72B6_6001["上下文"]["检查状态"] ~= _____72B6_6001 then
        return
    end
    _____72B6_6001["阶段"] = "失败等待惩罚"
    if _____72B6_6001["正常结束回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["正常结束回调ID"])
        _____72B6_6001["正常结束回调ID"] = 0
    end
    _____653E_4E0B_539F_68C0_67E5_88C5_5907(_____72B6_6001)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["上下文"]["Boss单位"], _____5229_5C14_4F2F_7279BuffID["检查中"])
    local _____914D_7F6E = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["检查"]
    _____72B6_6001["失败惩罚回调ID"] = addDelayedCallback(_____914D_7F6E["失败惩罚延迟秒"] * 1000, ____on_68C0_67E5_5931_8D25_60E9_7F5A, _____72B6_6001)
    local ____self_11 = _____72B6_6001["上下文"]["清理"]
    ____self_11["登记延迟回调"](____self_11, "检查失败惩罚", _____72B6_6001["失败惩罚回调ID"])
end
local function ____on_5229_5C14_4F2F_7279_627F_53D7_6700_7EC8_4F24_5BB3(target, _attacker, applied, _snapshot)
    if not (applied > 0) or target == nil or target == 0 or GetUnitTypeId(target) ~= _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_5229_5C14_4F2F_7279_4E0A_4E0B_6587(target)
    local _____72B6_6001 = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["检查状态"]
    if _____4E0A_4E0B_6587 == nil or _____72B6_6001 == nil or _____72B6_6001["阶段"] ~= "检查中" or _____72B6_6001["上下文"] ~= _____4E0A_4E0B_6587 then
        return
    end
    _____72B6_6001["累计最终伤害"] = _____72B6_6001["累计最终伤害"] + applied
    local _____914D_7F6E = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["检查"]
    local _____9608_503C = _____914D_7F6E["基础伤害阈值"] - _____914D_7F6E["每难度N降低阈值"] * _____8BFB_53D6_5F53_524D_96BE_5EA6N()
    if _____72B6_6001["累计最终伤害"] > _____9608_503C then
        _____89E6_53D1_68C0_67E5_5931_8D25(_____72B6_6001, _____9608_503C)
    end
end
____exports["释放利尔伯特检查"] = function(_____4E0A_4E0B_6587, target)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(boss) or not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(target) then
        return false
    end
    if _____4E0A_4E0B_6587["检查状态"] ~= nil and _____4E0A_4E0B_6587["检查状态"]["阶段"] ~= "已结束" then
        return false
    end
    local _____88C5_5907_5217_8868 = _____83B7_53D6_53EF_68C0_67E5_88C5_5907_5217_8868(target)
    if #_____88C5_5907_5217_8868 <= 0 then
        return false
    end
    local item = _____88C5_5907_5217_8868[GetRandomInt(0, #_____88C5_5907_5217_8868 - 1) + 1]
    if not _____68C0_67E5_7269_54C1_6709_6548(item) or not UnitAddItem(boss, item) then
        return false
    end
    local _____914D_7F6E = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["检查"]
    local _____72B6_6001 = {
        ["上下文"] = _____4E0A_4E0B_6587,
        ["目标单位"] = target,
        ["装备"] = item,
        ["阶段"] = "检查中",
        ["累计最终伤害"] = 0,
        ["正常结束回调ID"] = 0,
        ["失败惩罚回调ID"] = 0
    }
    _____4E0A_4E0B_6587["检查状态"] = _____72B6_6001
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["施法硬直秒"])
    SetUnitAnimationByIndex(boss, _____914D_7F6E["动作编号"])
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["检查"]["装备抽取"],
        GetUnitX(target),
        GetUnitY(target),
        _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["通魔施法秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    registerManualBuff(
        boss,
        _____5229_5C14_4F2F_7279BuffID["检查中"],
        _____914D_7F6E["检查持续秒"],
        0,
        {sourceUnit = boss, effectSourceName = "检查", effectSourceType = "技能"}
    )
    local ____self_16 = _____4E0A_4E0B_6587["清理"]
    ____self_16["登记清理"](____self_16, "检查状态清理", ____on_68C0_67E5_8FD0_884C_65F6_6E05_7406, _____72B6_6001)
    local _____8BFB_6761_56DE_8C03ID = addDelayedCallback(_____914D_7F6E["通魔施法秒"] * 1000, ____on_68C0_67E5_8BFB_6761_7ED3_675F, {["通道"] = _____914D_7F6E["读条通道"], ["Boss单位"] = boss})
    local ____self_17 = _____4E0A_4E0B_6587["清理"]
    ____self_17["登记延迟回调"](____self_17, "检查读条结束", _____8BFB_6761_56DE_8C03ID)
    _____72B6_6001["正常结束回调ID"] = addDelayedCallback(_____914D_7F6E["检查持续秒"] * 1000, ____on_68C0_67E5_6B63_5E38_7ED3_675F, _____72B6_6001)
    local ____self_18 = _____4E0A_4E0B_6587["清理"]
    ____self_18["登记延迟回调"](____self_18, "检查正常结束", _____72B6_6001["正常结束回调ID"])
    return true
end
local function ____on_5229_5C14_4F2F_7279_68C0_67E5_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____68C0_67E5_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587(castingUnit)
    if _____4E0A_4E0B_6587 ~= nil then
        ____exports["释放利尔伯特检查"](
            _____4E0A_4E0B_6587,
            GetSpellTargetUnit()
        )
    end
end
____exports["注册利尔伯特检查"] = function()
    if _____68C0_67E5_5DF2_6CE8_518C then
        return
    end
    _____68C0_67E5_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_5229_5C14_4F2F_7279_68C0_67E5_751F_6548)
    registerAppliedFinalDamageListener(____on_5229_5C14_4F2F_7279_627F_53D7_6700_7EC8_4F24_5BB3)
end
return ____exports
