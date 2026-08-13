--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.00．配置")
local _____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["利尔伯特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.01．运行时")
local _____83B7_53D6_5168_90E8_5229_5C14_4F2F_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6["获取全部利尔伯特上下文"]
local _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6["获取或创建利尔伯特上下文"]
local _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6["利尔伯特单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.02．数值与表现配置")
local _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["利尔伯特技能配置"]
local _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["利尔伯特音效配置"]
local ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具")
local _____76EE_6807_662F_5426_9762_5411_6765_6E90 = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["目标是否面向来源"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_2["注册Boss自动技能启动监听"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_3["是否已登记Boss技能测试目标"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_4.getRegisteredPlayerHero
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____require_result_7["播放Boss坐标音效"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5229_5C14_4F2F_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6B63_4E49_5BA1_5224_5DF2_6CE8_518C = false
local function _____662F_6B63_4E49_5BA1_5224_6709_6548_76EE_6807(boss, target)
    if not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(boss) or not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(target) then
        return false
    end
    if IsUnitEnemy(
        target,
        GetOwningPlayer(boss)
    ) ~= true then
        return false
    end
    if _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807(target) then
        return true
    end
    return getRegisteredPlayerHero(GetOwningPlayer(target)) == target
end
local function _____64AD_653E_6B63_4E49_5BA1_5224_547D_4E2D_7279_6548(target)
    local _____7279_6548 = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["正义审判"]["命中特效"]
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
local function _____63D0_4EA4_6B63_4E49_5BA1_5224_9644_52A0_4F24_5BB3(_____4E0A_4E0B_6587, _____76EE_6807_5355_4F4D, _____6807_7B7E)
    if not _____662F_6B63_4E49_5BA1_5224_6709_6548_76EE_6807(_____4E0A_4E0B_6587["Boss单位"], _____76EE_6807_5355_4F4D) then
        return {["是否造成伤害"] = false, ["伤害"] = 0}
    end
    _____4E0A_4E0B_6587["正义审判递归锁"] = true
    local _____7ED3_679C = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = _____4E0A_4E0B_6587["Boss单位"],
        ["目标"] = _____76EE_6807_5355_4F4D,
        ["伤害公式"] = {["目标已损生命比例"] = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["正义审判"]["附加已损生命比例"]},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_MIND,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = _____6807_7B7E
    })
    _____4E0A_4E0B_6587["正义审判递归锁"] = false
    if _____7ED3_679C["是否造成伤害"] then
        _____64AD_653E_6B63_4E49_5BA1_5224_547D_4E2D_7279_6548(_____76EE_6807_5355_4F4D)
        _____64AD_653EBoss_5750_6807_97F3_6548(
            _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["正义审判"]["审判命中"],
            GetUnitX(_____76EE_6807_5355_4F4D),
            GetUnitY(_____76EE_6807_5355_4F4D),
            _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["默认裁断距离"]
        )
    end
    return _____7ED3_679C
end
local function ____on_6B63_4E49_5BA1_5224_9644_52A0_4F24_5BB3(variable)
    local _____6570_636E = variable
    if _____6570_636E == nil or not _____662F_6B63_4E49_5BA1_5224_6709_6548_76EE_6807(_____6570_636E["上下文"]["Boss单位"], _____6570_636E["目标单位"]) then
        return
    end
    _____63D0_4EA4_6B63_4E49_5BA1_5224_9644_52A0_4F24_5BB3(_____6570_636E["上下文"], _____6570_636E["目标单位"], "利尔·伯特·正义审判·附加")
end
local function ____on_5229_5C14_9020_6210_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) or not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(attacker) or GetUnitTypeId(attacker) ~= _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587(attacker)
    if _____4E0A_4E0B_6587 == nil or _____4E0A_4E0B_6587["正义审判递归锁"] then
        return
    end
    local ____opt_result_10
    if snapshot ~= nil then
        ____opt_result_10 = snapshot.effectiveDamageType
    end
    local ____temp_14 = ____opt_result_10 == DAMAGE_TYPE_MIND
    if not ____temp_14 then
        local ____opt_result_13
        if snapshot ~= nil then
            ____opt_result_13 = snapshot.rawDamageType
        end
        ____temp_14 = ____opt_result_13 == DAMAGE_TYPE_MIND
    end
    if ____temp_14 then
        return
    end
    if not _____662F_6B63_4E49_5BA1_5224_6709_6548_76EE_6807(attacker, target) then
        return
    end
    if _____76EE_6807_662F_5426_9762_5411_6765_6E90(attacker, target, _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["正义审判"]["面向扇区角度"]) then
        return
    end
    local _____56DE_8C03ID = addDelayedCallback(0, ____on_6B63_4E49_5BA1_5224_9644_52A0_4F24_5BB3, {["上下文"] = _____4E0A_4E0B_6587, ["目标单位"] = target, ["原伤害"] = applied})
    local ____self_15 = _____4E0A_4E0B_6587["清理"]
    ____self_15["登记延迟回调"](____self_15, "正义审判附加伤害", _____56DE_8C03ID)
end
local function ____on_6B63_4E49_5BA1_5224_5468_671F()
    local _____4E0A_4E0B_6587_5217_8868 = _____83B7_53D6_5168_90E8_5229_5C14_4F2F_7279_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #_____4E0A_4E0B_6587_5217_8868 do
            do
                local _____4E0A_4E0B_6587 = _____4E0A_4E0B_6587_5217_8868[i + 1]
                local boss = _____4E0A_4E0B_6587["Boss单位"]
                if not _____5229_5C14_4F2F_7279_5355_4F4D_5B58_6D3B(boss) then
                    goto __continue20
                end
                local _____76EE_6807_5217_8868 = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
                do
                    local j = 0
                    while j < #_____76EE_6807_5217_8868 do
                        do
                            local _____76EE_6807 = _____76EE_6807_5217_8868[j + 1]
                            if not _____662F_6B63_4E49_5BA1_5224_6709_6548_76EE_6807(boss, _____76EE_6807) then
                                goto __continue23
                            end
                            if _____76EE_6807_662F_5426_9762_5411_6765_6E90(boss, _____76EE_6807, _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["正义审判"]["面向扇区角度"]) then
                                goto __continue23
                            end
                            local _____7ED3_679C = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
                                ["来源"] = boss,
                                ["目标"] = _____76EE_6807,
                                ["伤害公式"] = {["来源攻击力比例"] = _____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["正义审判"]["周期Boss攻击力比例"]},
                                attack = false,
                                ranged = false,
                                attackType = ATTACK_TYPE_NORMAL,
                                ["伤害类型"] = DAMAGE_TYPE_MIND,
                                weaponType = WEAPON_TYPE_WHOKNOWS,
                                ["标签"] = "利尔·伯特·正义审判·周期"
                            })
                            if _____7ED3_679C["是否造成伤害"] then
                                _____64AD_653E_6B63_4E49_5BA1_5224_547D_4E2D_7279_6548(_____76EE_6807)
                                _____64AD_653EBoss_5750_6807_97F3_6548(
                                    _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["正义审判"]["审判命中"],
                                    GetUnitX(_____76EE_6807),
                                    GetUnitY(_____76EE_6807),
                                    _____5229_5C14_4F2F_7279_97F3_6548_914D_7F6E["默认裁断距离"]
                                )
                            end
                        end
                        ::__continue23::
                        j = j + 1
                    end
                end
            end
            ::__continue20::
            i = i + 1
        end
    end
end
local function ____on_5229_5C14_4F2F_7279_6218_6597_542F_52A8(context)
    local ____opt_result_18
    if context ~= nil then
        ____opt_result_18 = context["Boss单位"]
    end
    local boss = ____opt_result_18
    _____83B7_53D6_6216_521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587(boss)
end
____exports["注册利尔伯特正义审判"] = function()
    if _____6B63_4E49_5BA1_5224_5DF2_6CE8_518C then
        return
    end
    _____6B63_4E49_5BA1_5224_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_5229_5C14_9020_6210_6700_7EC8_4F24_5BB3)
    addPeriodicCallback(_____5229_5C14_4F2F_7279_6280_80FD_914D_7F6E["正义审判"]["周期秒"] * 1000, ____on_6B63_4E49_5BA1_5224_5468_671F)
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({["名称"] = "利尔·伯特-正义审判", ["单位类型ID"] = _____5229_5C14_4F2F_7279_5355_4F4D_7C7B_578BID, ["on启动"] = ____on_5229_5C14_4F2F_7279_6218_6597_542F_52A8})
end
return ____exports
