local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.00．配置")
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["杀戮食人魔单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.01．运行时上下文")
local _____83B7_53D6_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取杀戮食人魔上下文"]
local _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建杀戮食人魔上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.02．数值与表现配置")
local _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["杀戮食人魔技能配置"]
local ____08_FF0E_98DF_4EBA_9B54 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.08．食人魔")
local _____98DF_4EBA_9B54BuffID = ____08_FF0E_98DF_4EBA_9B54["食人魔BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算Boss单体技能伤害"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local getBuffRuntime = ____require_result_2.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local removePeriodicCallback = ____require_result_3.removePeriodicCallback
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_4["获取Boss技能随机敌对英雄"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local jass = require("jass.common")
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local AddLightning = jass.AddLightning
local MoveLightningEx = jass.MoveLightningEx
local DestroyLightning = jass.DestroyLightning
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____75DB_4E4B_675F_7F1A_6280_80FDID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["痛之束缚"])
local _____75DB_4E4B_675F_7F1A_5DF2_6CE8_518C = false
local _____75DB_4E4B_675F_7F1A_4F24_5BB3_76D1_542C_5DF2_6CE8_518C = false
local _____75DB_4E4B_675F_7F1A_5F85_53D1_961F_5217 = {}
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____6E05_9664_75DB_4E4B_675F_7F1A(context)
    local _____65E7_5468_671FID = context["束缚周期ID"]
    local _____65E7_76EE_6807 = context["束缚目标"]
    local _____65E7_95EA_7535 = context["束缚闪电"]
    if _____65E7_5468_671FID > 0 then
        removePeriodicCallback(_____65E7_5468_671FID)
    end
    context["束缚周期ID"] = 0
    if _____65E7_95EA_7535 ~= nil and _____65E7_95EA_7535 ~= 0 then
        DestroyLightning(_____65E7_95EA_7535)
    end
    if _____65E7_76EE_6807 ~= nil and _____65E7_76EE_6807 ~= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65E7_76EE_6807, _____98DF_4EBA_9B54BuffID["痛之束缚"])
    end
    context["束缚闪电"] = nil
    context["束缚目标"] = nil
    context["束缚反伤中"] = false
end
local function ____on_75DB_4E4B_675F_7F1A_4E0A_4E0B_6587_6E05_7406(variable)
    local context = variable
    if context ~= nil then
        _____6E05_9664_75DB_4E4B_675F_7F1A(context)
    end
end
local function ____on_75DB_4E4B_675F_7F1A_5468_671F(variable)
    local context = variable
    if context == nil or not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(context["束缚目标"]) then
        if context ~= nil then
            _____6E05_9664_75DB_4E4B_675F_7F1A(context)
        end
        return
    end
    if getBuffRuntime(context["束缚目标"], _____98DF_4EBA_9B54BuffID["痛之束缚"]) == nil then
        _____6E05_9664_75DB_4E4B_675F_7F1A(context)
        return
    end
    local dx = GetUnitX(context["束缚目标"]) - GetUnitX(context["Boss单位"])
    local dy = GetUnitY(context["束缚目标"]) - GetUnitY(context["Boss单位"])
    local maxDistance = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["痛之束缚"]["断裂距离"]
    if dx * dx + dy * dy > maxDistance * maxDistance then
        _____6E05_9664_75DB_4E4B_675F_7F1A(context)
        return
    end
    MoveLightningEx(
        context["束缚闪电"],
        false,
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        80,
        GetUnitX(context["束缚目标"]),
        GetUnitY(context["束缚目标"]),
        80
    )
end
local function _____5EFA_7ACB_75DB_4E4B_675F_7F1A(data)
    local context = data["上下文"]
    local boss = context["Boss单位"]
    local target = data["目标单位"]
    if not _____5355_4F4D_5B58_6D3B(boss) or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____6E05_9664_75DB_4E4B_675F_7F1A(context)
    context["束缚目标"] = target
    context["束缚闪电"] = AddLightning(
        _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["痛之束缚"]["闪电代码"],
        false,
        GetUnitX(boss),
        GetUnitY(boss),
        GetUnitX(target),
        GetUnitY(target)
    )
    registerManualBuff(
        target,
        _____98DF_4EBA_9B54BuffID["痛之束缚"],
        _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["痛之束缚"]["持续秒"],
        _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["痛之束缚"]["伤害转移比例"],
        {sourceUnit = boss, sourceName = "杀戮食人魔-痛之束缚"}
    )
    context["束缚周期ID"] = addPeriodicCallback(100, ____on_75DB_4E4B_675F_7F1A_5468_671F, context)
    if not context["束缚清理已登记"] then
        context["束缚清理已登记"] = true
        local ____self_7 = context["清理"]
        ____self_7["登记清理"](____self_7, "杀戮食人魔-痛之束缚", ____on_75DB_4E4B_675F_7F1A_4E0A_4E0B_6587_6E05_7406, context)
    end
end
local function ____on_75DB_4E4B_675F_7F1A_751F_6548()
    while #_____75DB_4E4B_675F_7F1A_5F85_53D1_961F_5217 > 0 do
        do
            local data = _____75DB_4E4B_675F_7F1A_5F85_53D1_961F_5217[1]
            __TS__ArraySplice(_____75DB_4E4B_675F_7F1A_5F85_53D1_961F_5217, 0, 1)
            if data == nil or not _____5355_4F4D_5B58_6D3B(data["上下文"]["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(data["目标单位"]) then
                goto __continue18
            end
            _____5EFA_7ACB_75DB_4E4B_675F_7F1A(data)
            return
        end
        ::__continue18::
    end
end
local function ____on_75DB_4E4B_675F_7F1A_53CD_4F24(target, _attacker, applied, snapshot)
    if not (applied > 0) or not _____5355_4F4D_5B58_6D3B(target) or GetUnitTypeId(target) ~= _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587(target)
    if context == nil or context["束缚反伤中"] or not _____5355_4F4D_5B58_6D3B(context["束缚目标"]) then
        return
    end
    if snapshot ~= nil and snapshot.isDamageTransfer == true then
        return
    end
    local dx = GetUnitX(context["束缚目标"]) - GetUnitX(target)
    local dy = GetUnitY(context["束缚目标"]) - GetUnitY(target)
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["痛之束缚"]
    if dx * dx + dy * dy > cfg["断裂距离"] * cfg["断裂距离"] then
        _____6E05_9664_75DB_4E4B_675F_7F1A(context)
        return
    end
    context["束缚反伤中"] = true
    EC_CreateEffect(
        cfg["命中特效"],
        GetUnitX(context["束缚目标"]),
        GetUnitY(context["束缚目标"]),
        0,
        0,
        1.25,
        1.5,
        0.5
    )
    local _____8F6C_79FB_4F24_5BB3 = applied * cfg["伤害转移比例"]
    _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = target,
        ["目标"] = context["束缚目标"],
        ["伤害"] = _____8F6C_79FB_4F24_5BB3,
        ["技能ID"] = _____75DB_4E4B_675F_7F1A_6280_80FDID,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = "杀戮食人魔·痛之束缚",
        isDamageTransfer = true
    })
    context["束缚反伤中"] = false
end
local function _____53D6_75DB_4E4B_675F_7F1A_76EE_6807(boss)
    local spellTarget = GetSpellTargetUnit()
    if _____5355_4F4D_5B58_6D3B(spellTarget) then
        return spellTarget
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
end
____exports["释放杀戮食人魔痛之束缚"] = function(context, skillInstanceId)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_5B58_6D3B(boss) then
        return false
    end
    local target = _____53D6_75DB_4E4B_675F_7F1A_76EE_6807(boss)
    if not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    _____75DB_4E4B_675F_7F1A_5F85_53D1_961F_5217[#_____75DB_4E4B_675F_7F1A_5F85_53D1_961F_5217 + 1] = {["上下文"] = context, ["目标单位"] = target, ["技能实例ID"] = skillInstanceId}
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "杀戮食人魔-痛之束缚",
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = 0.7,
        ["动画编号"] = 5,
        ["恢复动画编号"] = 1,
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = 0.7,
            ["颜色ID"] = 1,
            ["标题文本"] = "痛之束缚",
            ["提示文本"] = "远离食人魔可挣脱链接"
        },
        ["on生效"] = ____on_75DB_4E4B_675F_7F1A_751F_6548
    })
    return true
end
local function ____on_75DB_4E4B_675F_7F1A_6280_80FD_58F3_91CA_653E(context, _boss, skillInstanceId)
    ____exports["释放杀戮食人魔痛之束缚"](context, skillInstanceId)
end
____exports["注册杀戮食人魔痛之束缚"] = function()
    if not _____75DB_4E4B_675F_7F1A_4F24_5BB3_76D1_542C_5DF2_6CE8_518C then
        _____75DB_4E4B_675F_7F1A_4F24_5BB3_76D1_542C_5DF2_6CE8_518C = true
        registerAppliedFinalDamageListener(____on_75DB_4E4B_675F_7F1A_53CD_4F24)
    end
    if _____75DB_4E4B_675F_7F1A_5DF2_6CE8_518C then
        return
    end
    _____75DB_4E4B_675F_7F1A_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "杀戮食人魔-痛之束缚",
        ["单位类型ID"] = _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____75DB_4E4B_675F_7F1A_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587,
        ["释放技能"] = ____on_75DB_4E4B_675F_7F1A_6280_80FD_58F3_91CA_653E,
        ["技能实例持续时间秒"] = 10
    })
end
return ____exports
