local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.00．配置")
local _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派学者单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派学者上下文"]
local _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派学者单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.02．数值与表现配置")
local _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者技能配置"]
local _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者音效配置"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local _____9500_6BC1_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["销毁原生弹幕"]
local ____04_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____04_FF0E_5BF9_5916_63A5_53E3["创建召唤物"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位最大生命"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_2["施加快速控制Buff"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local ____require_result_4 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_4.doHeal
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_6.Sound3DII_CooPlayReuse
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerController = jass.GetPlayerController
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local SetUnitState = jass.SetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local MAP_CONTROL_USER = jass.MAP_CONTROL_USER
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6559_6D3E_5B66_8005_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6697_5F71_5F39_5E55_72B6_6001_8868 = {}
local _____6697_5F71_5355_4F4D_5230_5F39_5E55ID = {}
local _____6697_5F71_7D22_547D_5DF2_6CE8_518C = false
local function _____662F_5426_73A9_5BB6_6467_6BC1_8005(unit)
    return unit ~= nil and unit ~= 0 and (IsUnitType(unit, UNIT_TYPE_HERO) or GetPlayerController(GetOwningPlayer(unit)) == MAP_CONTROL_USER)
end
local function ____on_6697_5F71_7D22_547D_547D_4E2D(target, barrageId)
    local _____72B6_6001 = _____6697_5F71_5F39_5E55_72B6_6001_8868[barrageId]
    if _____72B6_6001 == nil or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____72B6_6001["上下文"]["Boss单位"]) or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(target) then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["暗影索命"]
    local _____7ED3_679C = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["命中Boss攻击力比例"]},
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = _____914D_7F6E["伤害标签"]
    })
    if _____7ED3_679C["是否造成伤害"] then
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(
            boss,
            target,
            0,
            _____914D_7F6E["命中眩晕秒"],
            "教派学者-暗影索命",
            "技能"
        )
        EC_CreateEffect(
            _____914D_7F6E["命中特效路径"],
            GetUnitX(target),
            GetUnitY(target),
            0,
            0,
            _____914D_7F6E["命中特效缩放"],
            1,
            1
        )
        Sound3DII_CooPlayReuse(
            _____914D_7F6E["命中音效路径"],
            GetUnitX(target),
            GetUnitY(target),
            0,
            _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
        )
    end
end
local function ____on_6697_5F71_7D22_547D_88AB_51FB_843D(killer, barrageId)
    local _____72B6_6001 = _____6697_5F71_5F39_5E55_72B6_6001_8868[barrageId]
    if _____72B6_6001 == nil or not _____662F_5426_73A9_5BB6_6467_6BC1_8005(killer) or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(killer) then
        return
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["暗影索命"]
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(killer)
    local _____6CBB_7597_91CF = _____653B_51FB_529B * _____914D_7F6E["击落治疗攻击力比例"]
    local _____56DE_9B54_91CF = _____653B_51FB_529B * _____914D_7F6E["击落回魔攻击力比例"]
    local _____51FB_843D_524D_9B54_6CD5_503C = GetUnitState(killer, UNIT_STATE_MANA)
    local _____5B9E_9645_6CBB_7597 = doHeal({
        HealSource = killer,
        HealTarget = killer,
        HealAmount = _____6CBB_7597_91CF,
        HealManaAmount = _____56DE_9B54_91CF,
        ItemHeal = false,
        HealEffect = true,
        HealEffectPath = _____914D_7F6E["击落恢复特效路径"],
        ManaEffect = true
    })
    local _____5B9E_9645_56DE_9B54 = GetUnitState(killer, UNIT_STATE_MANA) - _____51FB_843D_524D_9B54_6CD5_503C
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E["弹幕击落"],
        GetUnitX(killer),
        GetUnitY(killer),
        0,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
    )
end
local function ____on_6697_5F71_7D22_547D_7ED3_675F(reason, barrageId)
    local _____72B6_6001 = _____6697_5F71_5F39_5E55_72B6_6001_8868[barrageId]
    __TS__Delete(_____6697_5F71_5F39_5E55_72B6_6001_8868, barrageId)
    if _____72B6_6001 == nil then
        return
    end
    if _____72B6_6001["弹幕单位"] ~= nil and _____72B6_6001["弹幕单位"] ~= 0 then
        __TS__Delete(
            _____6697_5F71_5355_4F4D_5230_5F39_5E55ID,
            GetHandleId(_____72B6_6001["弹幕单位"])
        )
    end
    __TS__Delete(_____72B6_6001["上下文"]["暗影弹幕ID表"], barrageId)
end
local function ____on_6697_5F71_7D22_547D_5F39_5E55_6E05_7406(variable)
    local _____6E05_7406_72B6_6001 = variable
    if _____6E05_7406_72B6_6001 == nil or _____6E05_7406_72B6_6001["已结束"] then
        return
    end
    _____6E05_7406_72B6_6001["已结束"] = true
    _____9500_6BC1_539F_751F_5F39_5E55(_____6E05_7406_72B6_6001["弹幕ID"], "手动销毁")
end
____exports["创建教派学者暗影弹幕"] = function(_____4E0A_4E0B_6587, _____89D2_5EA6, _____7F29_653E, _____53D1_5C04_6765_6E90)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) then
        return 0
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["暗影索命"]
    local X = GetUnitX(boss)
    local Y = GetUnitY(boss)
    local _____751F_547D_503C = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(boss) * _____914D_7F6E["弹幕生命Boss最大生命比例"]
    local _____8F7D_4F53_5355_4F4D = _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = _____914D_7F6E["弹幕马甲单位ID"],
        ["单位名称"] = "暗影",
        X = X,
        Y = Y,
        ["朝向"] = _____89D2_5EA6,
        ["持续时间"] = _____914D_7F6E["弹幕生命周期秒"],
        ["生命值"] = _____751F_547D_503C,
        ["禁止普攻"] = true,
        ["禁用路径"] = true,
        ["模型文件"] = _____914D_7F6E["弹幕模型路径"],
        ["缩放"] = _____7F29_653E
    })
    if _____8F7D_4F53_5355_4F4D == nil or _____8F7D_4F53_5355_4F4D == 0 then
        return 0
    end
    SetUnitState(_____8F7D_4F53_5355_4F4D, UNIT_STATE_LIFE, _____751F_547D_503C)
    local _____5F39_5E55 = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        ["弹幕单位"] = _____8F7D_4F53_5355_4F4D,
        X = X,
        Y = Y,
        ["方向角"] = _____89D2_5EA6,
        ["速度"] = _____914D_7F6E["弹幕速度"],
        ["生命周期"] = _____914D_7F6E["弹幕生命周期秒"],
        ["命中半径"] = _____914D_7F6E["弹幕碰撞半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["最大总命中次数"] = 1,
        ["弹幕生命值"] = _____751F_547D_503C,
        ["可攻击摧毁"] = true,
        ["被阻挡时销毁"] = false,
        ["弹射"] = true,
        ["随机弹射"] = true,
        ["弹射次数上限"] = _____914D_7F6E["随机弹射次数上限"],
        ["模型"] = _____914D_7F6E["弹幕模型路径"],
        ["缩放"] = _____7F29_653E,
        ["禁用碰撞"] = true,
        ["死亡时移除单位"] = true,
        ["on命中"] = ____on_6697_5F71_7D22_547D_547D_4E2D,
        ["on被击落"] = ____on_6697_5F71_7D22_547D_88AB_51FB_843D,
        ["on结束"] = ____on_6697_5F71_7D22_547D_7ED3_675F
    })
    local _____72B6_6001 = {["上下文"] = _____4E0A_4E0B_6587, ["弹幕ID"] = _____5F39_5E55["弹幕ID"], ["弹幕单位"] = _____8F7D_4F53_5355_4F4D, ["发射来源"] = _____53D1_5C04_6765_6E90}
    _____6697_5F71_5F39_5E55_72B6_6001_8868[_____5F39_5E55["弹幕ID"]] = _____72B6_6001
    _____6697_5F71_5355_4F4D_5230_5F39_5E55ID[GetHandleId(_____8F7D_4F53_5355_4F4D)] = _____5F39_5E55["弹幕ID"]
    _____4E0A_4E0B_6587["暗影弹幕ID表"][_____5F39_5E55["弹幕ID"]] = true
    local ____self_10 = _____4E0A_4E0B_6587["清理"]
    ____self_10["登记清理"](____self_10, "教派学者-暗影弹幕销毁", ____on_6697_5F71_7D22_547D_5F39_5E55_6E05_7406, {["弹幕ID"] = _____5F39_5E55["弹幕ID"], ["已结束"] = false})
    registerManualBuff(
        _____8F7D_4F53_5355_4F4D,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["暗影弹幕"],
        _____914D_7F6E["弹幕生命周期秒"],
        _____751F_547D_503C,
        {sourceUnit = boss, effectSourceName = "暗影索命", effectSourceType = "技能"}
    )
    Sound3DII_CooPlayReuse(
        _____914D_7F6E["发射音效路径"],
        X,
        Y,
        0,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
    )
    return _____5F39_5E55["弹幕ID"]
end
local function ____on_6697_5F71_7D22_547D_666E_653B_6D3E_751F(variable)
    local _____5FEB_7167 = variable
    if _____5FEB_7167 == nil or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____5FEB_7167["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____5FEB_7167["上下文"]["Boss单位"]
    local target = _____5FEB_7167["目标单位"]
    local _____89D2_5EA6 = _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(target) and _____4E24_70B9_89D2_5EA6(
        GetUnitX(boss),
        GetUnitY(boss),
        GetUnitX(target),
        GetUnitY(target)
    ) or 0
    ____exports["创建教派学者暗影弹幕"](_____5FEB_7167["上下文"], _____89D2_5EA6, _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["暗影索命"]["普攻弹幕缩放"], "普通攻击")
end
local function _____6559_6D3E_5B66_8005_666E_653B_66FF_6362_4FEE_6B63(context)
    if context == nil or not (context.currentDamage > 0) or context.isNormalAttack ~= true or context.isSkillAttack == true or context.isSkillDamage == true then
        local ____opt_result_13
        if context ~= nil then
            ____opt_result_13 = context.currentDamage
        end
        local ____opt_result_13_14 = ____opt_result_13
        if ____opt_result_13_14 == nil then
            ____opt_result_13_14 = 0
        end
        return ____opt_result_13_14
    end
    local attacker = context.attacker
    if attacker == nil or attacker == 0 or GetUnitTypeId(attacker) ~= _____6559_6D3E_5B66_8005_5355_4F4D_7C7B_578BID then
        return context.currentDamage
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587(attacker)
    if _____4E0A_4E0B_6587 == nil then
        return context.currentDamage
    end
    local _____5FEB_7167 = {["上下文"] = _____4E0A_4E0B_6587, ["目标单位"] = context.target}
    local _____56DE_8C03ID = addDelayedCallback(0, ____on_6697_5F71_7D22_547D_666E_653B_6D3E_751F, _____5FEB_7167)
    local ____self_15 = _____4E0A_4E0B_6587["清理"]
    ____self_15["登记延迟回调"](____self_15, "教派学者-暗影索命普攻派生", _____56DE_8C03ID)
    return 0
end
local function _____6697_5F71_7D22_547D_514B_5236_627F_4F24_4FEE_6B63(context)
    if context == nil or context.target == nil or context.target == 0 or context.isThunderDamage ~= true and context.isLightDamage ~= true then
        local ____opt_result_18
        if context ~= nil then
            ____opt_result_18 = context.currentDamage
        end
        local ____opt_result_18_19 = ____opt_result_18
        if ____opt_result_18_19 == nil then
            ____opt_result_18_19 = 0
        end
        return ____opt_result_18_19
    end
    local barrageId = _____6697_5F71_5355_4F4D_5230_5F39_5E55ID[GetHandleId(context.target)] or 0
    if barrageId <= 0 or _____6697_5F71_5F39_5E55_72B6_6001_8868[barrageId] == nil then
        return context.currentDamage
    end
    local after = context.currentDamage * _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["暗影索命"]["雷光承伤倍率"]
    return after
end
____exports["注册教派学者暗影索命"] = function()
    if _____6697_5F71_7D22_547D_5DF2_6CE8_518C then
        return
    end
    _____6697_5F71_7D22_547D_5DF2_6CE8_518C = true
    registerDamageModifier(_____6559_6D3E_5B66_8005_666E_653B_66FF_6362_4FEE_6B63, _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["暗影索命"]["普攻替换修正优先级"])
    registerDamageModifier(_____6697_5F71_7D22_547D_514B_5236_627F_4F24_4FEE_6B63, _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["暗影索命"]["克制承伤修正优先级"])
end
return ____exports
