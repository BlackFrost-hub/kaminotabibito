local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53CB_65B9_5171_540C_6D88_5931, jass, getGameTime, registerManualBuff, _____79FB_9664_5355_4F4D_6682_505C, ____E_6682_505C_6765_6E90
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00．配置")
local _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["八云紫单位技能配置"]
local ____01_FF0E_88C2_9699_7CFB_7EDF = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.07．公共与单位壳.01．裂隙系统")
local _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B = ____01_FF0E_88C2_9699_7CFB_7EDF["八云紫单位存活"]
local _____662F_516B_4E91_7D2B = ____01_FF0E_88C2_9699_7CFB_7EDF["是八云紫"]
local _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA = ____01_FF0E_88C2_9699_7CFB_7EDF["是八云紫合法敌人"]
local _____67E5_627E_516B_4E91_7D2B_88C2_9699 = ____01_FF0E_88C2_9699_7CFB_7EDF["查找八云紫裂隙"]
local _____521B_5EFA_516B_4E91_7D2B_70B9_7279_6548 = ____01_FF0E_88C2_9699_7CFB_7EDF["创建八云紫点特效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____14_FF0E_516B_4E91_7D2B = require("系统.05．Buff系统.03．Buff表.02．英雄.14．八云紫")
local _____516B_4E91_7D2BBuffID = ____14_FF0E_516B_4E91_7D2B["八云紫BuffID"]
function _____53CB_65B9_5171_540C_6D88_5931(variable)
    local context = variable
    if context == nil or context["已结束"] or not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(context["目标"]) then
        return
    end
    context["友方已隐藏"] = true
    jass.ShowUnit(context["目标"], false)
    registerManualBuff(
        context["目标"],
        _____516B_4E91_7D2BBuffID["神隐"],
        math.max(
            0.1,
            (context["到期时间"] - getGameTime()) / 1000
        ),
        0,
        {sourceUnit = context["英雄"], effectSourceType = "技能"}
    )
    _____79FB_9664_5355_4F4D_6682_505C(context["英雄"], ____E_6682_505C_6765_6E90)
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
getGameTime = ____require_result_0.getGameTime
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.05．Buff系统.05．Buff清除函数")
local _____79FB_9664_5355_4F4D_8D1F_9762Buff = ____require_result_3["移除单位负面Buff"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____5355_4F4D_662F_5426_65E0_654C_5B89_5168 = ____require_result_5["单位是否无敌安全"]
local ____require_result_6 = require("平台扩展API动作")
local _____5355_4F4D_6269_5C55__8BBE_79FB_52A8_7C7B_578B = ____require_result_6["单位扩展_设移动类型"]
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_6["技能_设置技能冷却时间"]
local ____require_result_7 = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4 = ____require_result_7["技能_获取技能当前冷却时间"]
local _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4 = ____require_result_7["技能_获取技能最大冷却时间"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_8["读取单位攻击力"]
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_9.getEnemyUnitsInRange
local ____require_result_10 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_10["造成单体技能伤害"]
local ____require_result_11 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_11["施加眩晕"]
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_12["创建点特效"]
local _____914D_7F6E = _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E
____E_6682_505C_6765_6E90 = "八云紫-E-友方神隐准备"
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
local _____795E_9690_4E0A_4E0B_6587_8868 = {}
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and jass.GetUnitTypeId(unit) ~= 0
end
local function _____53E5_67C4ID(unit)
    local _____5355_4F4D_6709_6548_result_13
    if _____5355_4F4D_6709_6548(unit) then
        _____5355_4F4D_6709_6548_result_13 = jass.GetHandleId(unit)
    else
        _____5355_4F4D_6709_6548_result_13 = 0
    end
    return _____5355_4F4D_6709_6548_result_13
end
local function _____9020_6210E_4F24_5BB3(context, target, damage, tag)
    if not _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA(context["英雄"], target) or not (damage > 0) then
        return
    end
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = context["英雄"],
        ["目标"] = target,
        ["伤害"] = damage,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____914D_7F6E["技能"].E["类型ID"],
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = tag,
        ["伤害形态"] = "AOE",
        ["参与技能伤害加成"] = true
    })
end
local function _____8C03_6574E_51B7_5374(variable)
    local data = variable
    if data == nil or not _____5355_4F4D_6709_6548(data["英雄"]) or not (data["减少比例"] > 0) then
        return
    end
    local current = _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4(data["英雄"], _____914D_7F6E["技能"].E["类型ID"]) or 0
    local maximum = _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4(data["英雄"], _____914D_7F6E["技能"].E["类型ID"]) or 0
    if not (current > 0) or not (maximum > 0) then
        return
    end
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(data["英雄"], _____914D_7F6E["技能"].E["类型ID"], current * (1 - data["减少比例"]), maximum)
end
local function _____9690_85CF_516B_4E91_7D2B(context)
    local hero = context["英雄"]
    jass.SetUnitVertexColor(
        hero,
        255,
        255,
        255,
        0
    )
    _____5355_4F4D_6269_5C55__8BBE_79FB_52A8_7C7B_578B(hero, 1)
    jass.SetUnitScale(hero, _____914D_7F6E.E["隐藏缩放"], _____914D_7F6E.E["隐藏缩放"], _____914D_7F6E.E["隐藏缩放"])
    jass.SetUnitAcquireRange(hero, 0)
    jass.SetUnitInvulnerable(hero, true)
    _____521B_5EFA_516B_4E91_7D2B_70B9_7279_6548(
        _____914D_7F6E.E["消失特效"],
        jass.GetUnitX(hero),
        jass.GetUnitY(hero),
        1.5,
        _____914D_7F6E.E["消失特效缩放"],
        _____914D_7F6E.E["消失特效高度"]
    )
end
local function _____6062_590D_516B_4E91_7D2B(context)
    local hero = context["英雄"]
    if not _____5355_4F4D_6709_6548(hero) then
        return
    end
    jass.ShowUnit(hero, true)
    jass.SetUnitVertexColor(
        hero,
        255,
        255,
        255,
        255
    )
    _____5355_4F4D_6269_5C55__8BBE_79FB_52A8_7C7B_578B(hero, 2)
    jass.SetUnitScale(hero, _____914D_7F6E.E["恢复缩放"], _____914D_7F6E.E["恢复缩放"], _____914D_7F6E.E["恢复缩放"])
    jass.SetUnitAcquireRange(hero, _____914D_7F6E.E["恢复索敌范围"])
    jass.SetUnitInvulnerable(hero, context["原始无敌"])
    _____79FB_9664_5355_4F4D_6682_505C(hero, ____E_6682_505C_6765_6E90)
end
local function _____83B7_53D6_654C_65B9_80CC_540E_70B9(target)
    local radians = (jass.GetUnitFacing(target) + 180) * math.pi / 180
    local distance = _____914D_7F6E.E["敌方背后距离"]
    local x = jass.GetUnitX(target) + math.cos(radians) * distance
    local y = jass.GetUnitY(target) + math.sin(radians) * distance
    if jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) == true then
        distance = _____914D_7F6E.E["敌方阻挡回退距离"]
        x = jass.GetUnitX(target) + math.cos(radians) * distance
        y = jass.GetUnitY(target) + math.sin(radians) * distance
    end
    return {x = x, y = y}
end
local function _____7ED3_7B97_654C_65B9_5206_652F(context)
    local target = context["目标"]
    if not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(target) or not _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA(context["英雄"], target) then
        return
    end
    local point = _____83B7_53D6_654C_65B9_80CC_540E_70B9(target)
    context["出现X"] = point.x
    context["出现Y"] = point.y
    jass.SetUnitPosition(context["英雄"], point.x, point.y)
    _____65BD_52A0_7729_6655(
        context["英雄"],
        target,
        _____914D_7F6E.E["敌方眩晕秒"],
        "八云紫-E-神隐突袭",
        "技能"
    )
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.E["敌方结算特效"],
        X = jass.GetUnitX(target),
        Y = jass.GetUnitY(target),
        Z = _____914D_7F6E.E["敌方结算特效高度"],
        ["缩放"] = _____914D_7F6E.E["敌方结算特效缩放"],
        ["动画速度"] = _____914D_7F6E.E["敌方结算特效速度"],
        ["持续秒"] = _____914D_7F6E.E["敌方结算特效持续秒"]
    })
    local attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["英雄"])
    local missingLife = math.max(
        0,
        jass.GetUnitState(target, UNIT_STATE_MAX_LIFE) - jass.GetUnitState(target, UNIT_STATE_LIFE)
    )
    _____9020_6210E_4F24_5BB3(context, target, attack * _____914D_7F6E.E["敌方额外伤害攻击力比例"] + missingLife * _____914D_7F6E.E["敌方已损失生命比例"], "八云紫-E-敌方神隐突袭")
end
local function _____7ED3_7B97_6700_7EC8_5C55_5F00(context)
    if not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(context["英雄"]) then
        return
    end
    local heroX = jass.GetUnitX(context["英雄"])
    local heroY = jass.GetUnitY(context["英雄"])
    _____521B_5EFA_516B_4E91_7D2B_70B9_7279_6548(_____914D_7F6E.E["出现特效"], heroX, heroY, 1.5)
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["英雄"]) * _____914D_7F6E.E["最终伤害攻击力比例"]
    local enemies = getEnemyUnitsInRange(context["英雄"], heroX, heroY, _____914D_7F6E.E["最终范围"])
    do
        local i = 0
        while i < #enemies do
            _____9020_6210E_4F24_5BB3(context, enemies[i + 1], damage, "八云紫-E-神隐最终展开")
            i = i + 1
        end
    end
end
local function _____7ED3_675F_795E_9690(context, _____7ED3_7B97_4F24_5BB3)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    if context["周期ID"] ~= 0 then
        removePeriodicCallback(context["周期ID"])
    end
    local heroId = _____53E5_67C4ID(context["英雄"])
    if heroId ~= 0 and _____795E_9690_4E0A_4E0B_6587_8868[heroId] == context then
        __TS__Delete(_____795E_9690_4E0A_4E0B_6587_8868, heroId)
    end
    jass.SetPlayerAbilityAvailable(
        jass.GetOwningPlayer(context["英雄"]),
        _____914D_7F6E["技能"].E["类型ID"],
        true
    )
    jass.UnitRemoveAbility(context["英雄"], _____914D_7F6E["技能"]["E出现"]["类型ID"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["英雄"], _____516B_4E91_7D2BBuffID["神隐"])
    if context["友方已隐藏"] and _____5355_4F4D_6709_6548(context["目标"]) then
        jass.ShowUnit(context["目标"], true)
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["目标"], _____516B_4E91_7D2BBuffID["神隐"])
    end
    if _____7ED3_7B97_4F24_5BB3 and context["方式"] == "敌方" then
        _____7ED3_7B97_654C_65B9_5206_652F(context)
    elseif context["方式"] == "裂隙" then
        jass.SetUnitPosition(context["英雄"], context["出现X"], context["出现Y"])
    elseif context["方式"] == "友方" and _____5355_4F4D_6709_6548(context["目标"]) then
        context["出现X"] = jass.GetUnitX(context["目标"])
        context["出现Y"] = jass.GetUnitY(context["目标"])
        jass.SetUnitPosition(context["英雄"], context["出现X"], context["出现Y"])
        jass.SetUnitPosition(context["目标"], context["出现X"], context["出现Y"])
        _____79FB_9664_5355_4F4D_8D1F_9762Buff(context["目标"], false)
    else
        jass.SetUnitPosition(context["英雄"], context["出现X"], context["出现Y"])
    end
    _____6062_590D_516B_4E91_7D2B(context)
    if _____7ED3_7B97_4F24_5BB3 then
        _____7ED3_7B97_6700_7EC8_5C55_5F00(context)
    end
end
local function _____795E_9690_68C0_67E5(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(context["英雄"]) then
        _____7ED3_675F_795E_9690(context, false)
        return
    end
    if getGameTime() >= context["到期时间"] then
        _____7ED3_675F_795E_9690(context, true)
    end
end
local function _____53CB_65B9_795E_9690_5230_8FBE(variable)
    local context = variable
    if context == nil or context["已结束"] or not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(context["目标"]) then
        return
    end
    context["出现X"] = jass.GetUnitX(context["目标"])
    context["出现Y"] = jass.GetUnitY(context["目标"])
    jass.SetUnitPosition(context["英雄"], context["出现X"], context["出现Y"])
    _____521B_5EFA_516B_4E91_7D2B_70B9_7279_6548(_____914D_7F6E.E["出现特效"], context["出现X"], context["出现Y"], 1.5)
    addDelayedCallback(_____914D_7F6E.E["友方消失延迟秒"] * 1000, _____53CB_65B9_5171_540C_6D88_5931, context)
end
local function _____8FDB_5165_795E_9690(context, _____51CF_5C11_51B7_5374_6BD4_4F8B)
    local heroId = _____53E5_67C4ID(context["英雄"])
    local previous = _____795E_9690_4E0A_4E0B_6587_8868[heroId]
    if previous ~= nil and not previous["已结束"] then
        _____7ED3_675F_795E_9690(previous, false)
    end
    _____795E_9690_4E0A_4E0B_6587_8868[heroId] = context
    _____9690_85CF_516B_4E91_7D2B(context)
    jass.SetPlayerAbilityAvailable(
        jass.GetOwningPlayer(context["英雄"]),
        _____914D_7F6E["技能"].E["类型ID"],
        false
    )
    jass.UnitAddAbility(context["英雄"], _____914D_7F6E["技能"]["E出现"]["类型ID"])
    registerManualBuff(
        context["英雄"],
        _____516B_4E91_7D2BBuffID["神隐"],
        _____914D_7F6E.E["最大间隙秒"],
        0,
        {sourceUnit = context["英雄"], effectSourceType = "技能"}
    )
    context["周期ID"] = addPeriodicCallback(_____914D_7F6E.E["检查间隔毫秒"], _____795E_9690_68C0_67E5, context)
    if _____51CF_5C11_51B7_5374_6BD4_4F8B > 0 then
        addDelayedCallback(10, _____8C03_6574E_51B7_5374, {["英雄"] = context["英雄"], ["减少比例"] = _____51CF_5C11_51B7_5374_6BD4_4F8B})
    end
    if context["方式"] == "友方" then
        _____6DFB_52A0_5355_4F4D_6682_505C(context["英雄"], ____E_6682_505C_6765_6E90)
        addDelayedCallback(_____914D_7F6E.E["友方前置延迟秒"] * 1000, _____53CB_65B9_795E_9690_5230_8FBE, context)
    end
end
local function _____83B7_53D6E_76D1_542C_4E0A_4E0B_6587(hero)
    return _____662F_516B_4E91_7D2B(hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653EE(_entry, hero, skillInstanceId)
    local target = jass.GetSpellTargetUnit()
    local targetX = jass.GetSpellTargetX()
    local targetY = jass.GetSpellTargetY()
    local now = getGameTime()
    local mode
    local gap
    local cooldownReduction = 0
    local appearX = jass.GetUnitX(hero)
    local appearY = jass.GetUnitY(hero)
    if target == hero then
        mode = "自身"
        cooldownReduction = _____914D_7F6E.E["自身额外减冷却比例"]
    elseif target ~= nil and target ~= 0 and jass.IsUnitEnemy(
        target,
        jass.GetOwningPlayer(hero)
    ) == true then
        if not _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA(hero, target) then
            return
        end
        mode = "敌方"
    elseif target ~= nil and target ~= 0 and jass.IsUnitAlly(
        target,
        jass.GetOwningPlayer(hero)
    ) == true then
        if not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(target) then
            return
        end
        mode = "友方"
        cooldownReduction = _____914D_7F6E.E["友方额外减冷却比例"]
        appearX = jass.GetUnitX(target)
        appearY = jass.GetUnitY(target)
    else
        gap = _____67E5_627E_516B_4E91_7D2B_88C2_9699(targetX, targetY, _____914D_7F6E.E["裂隙搜索范围"], hero)
        if gap == nil then
            jass.DisplayTimedTextToPlayer(
                jass.GetOwningPlayer(hero),
                0,
                0,
                3,
                "目标位置附近没有可用的『间隙』。 "
            )
            _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(hero, _____914D_7F6E["技能"].E["类型ID"], 5, 5)
            return
        end
        mode = "裂隙"
        cooldownReduction = _____914D_7F6E.E["裂隙额外减冷却比例"]
        appearX = jass.GetUnitX(gap["单位"])
        appearY = jass.GetUnitY(gap["单位"])
    end
    _____8FDB_5165_795E_9690(
        {
            ["英雄"] = hero,
            ["方式"] = mode,
            ["目标"] = target,
            ["目标裂隙"] = gap,
            ["出现X"] = appearX,
            ["出现Y"] = appearY,
            ["原始无敌"] = _____5355_4F4D_662F_5426_65E0_654C_5B89_5168(hero),
            ["技能实例ID"] = skillInstanceId,
            ["到期时间"] = now + _____914D_7F6E.E["最大间隙秒"] * 1000,
            ["周期ID"] = 0,
            ["已结束"] = false,
            ["友方已隐藏"] = false
        },
        cooldownReduction
    )
end
local function _____76D1_542C_4E3B_52A8_51FA_73B0(caster, spellAbilityId)
    if spellAbilityId ~= _____914D_7F6E["技能"]["E出现"]["类型ID"] or not _____662F_516B_4E91_7D2B(caster) then
        return
    end
    local context = _____795E_9690_4E0A_4E0B_6587_8868[_____53E5_67C4ID(caster)]
    if context ~= nil then
        _____7ED3_675F_795E_9690(context, true)
    end
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "八云紫-八云紫的神隐（E）",
    ["单位类型ID"] = _____914D_7F6E["单位"]["英雄类型ID"],
    ["技能ID"] = _____914D_7F6E["技能"].E["类型ID"],
    ["获取或创建上下文"] = _____83B7_53D6E_76D1_542C_4E0A_4E0B_6587,
    ["释放技能"] = _____91CA_653EE,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 3
})
registerSpellEffectListener(_____76D1_542C_4E3B_52A8_51FA_73B0)
return ____exports
