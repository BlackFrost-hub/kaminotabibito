local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____08_FF0E_98DF_4EBA_9B54 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.08．食人魔")
local _____98DF_4EBA_9B54BuffID = ____08_FF0E_98DF_4EBA_9B54["食人魔BuffID"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.02．数值与表现配置")
local _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["沙漠食人魔技能配置"]
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8F6C_56DB_4F4DID = ____require_result_0["转四位ID"]
local _____8BFB_53D6_5355_4F4D_7D2F_8BA1_5B9E_6570 = ____require_result_0["读取单位累计实数"]
local _____5199_5165_5355_4F4D_7D2F_8BA1_5B9E_6570 = ____require_result_0["写入单位累计实数"]
local _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_7387_4FEE_6B63 = ____require_result_0["注册指定单位暴击率修正"]
local _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_540E_76D1_542C = ____require_result_0["注册指定单位暴击后监听"]
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_0["获取范围敌军"]
local _____53D6_5355_4F4DX = ____require_result_0["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_0["取单位Y"]
local _____5728_5750_6807_64AD_653E_7279_6548 = ____require_result_0["在坐标播放特效"]
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_4.getRegisteredPlayerHero
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_5["是否已登记Boss技能测试目标"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.00．配置")
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_6["沙漠食人魔单位技能配置"]
local jass = require("jass.common")
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitTypeId = jass.GetUnitTypeId
local GetHandleId = jass.GetHandleId
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = _____8F6C_56DB_4F4DID(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____7B2C_56DB_51FB_4F24_5BB3_4E2D_952E = "沙漠食人魔第四击伤害中"
local _____84C4_529B_76EE_6807_8868 = {}
local _____6C99_6F20_98DF_4EBA_9B54_88AB_52A8_5DF2_6CE8_518C = false
local function _____76EE_6807_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local owner = GetOwningPlayer(unit)
    return owner ~= nil and owner ~= 0 and getRegisteredPlayerHero(owner) == unit or _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807(unit)
end
local function _____6E05_9664_76EE_6807_84C4_529B(target)
    _____5199_5165_5355_4F4D_7D2F_8BA1_5B9E_6570(target, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["累计键"], 0)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____98DF_4EBA_9B54BuffID["蓄力Hit"])
end
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    return unit ~= nil and unit ~= 0 and (GetHandleId(unit) or 0) or 0
end
local function _____767B_8BB0_84C4_529B_76EE_6807(target)
    local targetHid = _____53D6_5355_4F4D_53E5_67C4ID(target)
    if targetHid > 0 then
        _____84C4_529B_76EE_6807_8868[targetHid] = target
    end
end
local function _____79FB_9664_84C4_529B_76EE_6807_767B_8BB0(target)
    local targetHid = _____53D6_5355_4F4D_53E5_67C4ID(target)
    if targetHid > 0 then
        __TS__Delete(_____84C4_529B_76EE_6807_8868, targetHid)
    end
end
local function _____6E05_9664_5168_90E8_84C4_529B_76EE_6807()
    for targetHidText in pairs(_____84C4_529B_76EE_6807_8868) do
        local targetHid = __TS__Number(targetHidText)
        local target = _____84C4_529B_76EE_6807_8868[targetHid]
        if target ~= nil and target ~= 0 then
            _____6E05_9664_76EE_6807_84C4_529B(target)
        end
        __TS__Delete(_____84C4_529B_76EE_6807_8868, targetHid)
    end
end
local function ____on_6C99_6F20_98DF_4EBA_9B54_84C4_529B_76F8_5173_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    if GetUnitTypeId(dyingUnit) == _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID then
        _____6E05_9664_5168_90E8_84C4_529B_76EE_6807()
        return
    end
    local dyingHid = _____53D6_5355_4F4D_53E5_67C4ID(dyingUnit)
    if dyingHid <= 0 or _____84C4_529B_76EE_6807_8868[dyingHid] == nil then
        return
    end
    _____6E05_9664_76EE_6807_84C4_529B(dyingUnit)
    __TS__Delete(_____84C4_529B_76EE_6807_8868, dyingHid)
end
local function _____6C99_6F20_98DF_4EBA_9B54_66B4_51FB_7387_4FEE_6B63(context)
    local ____context__66B4_51FB_5F52_5C5E_5355_4F4D_7 = context["暴击归属单位"]
    if ____context__66B4_51FB_5F52_5C5E_5355_4F4D_7 == nil then
        ____context__66B4_51FB_5F52_5C5E_5355_4F4D_7 = context.attacker
    end
    local attacker = ____context__66B4_51FB_5F52_5C5E_5355_4F4D_7
    if _____8BFB_53D6_5355_4F4D_7D2F_8BA1_5B9E_6570(attacker, _____7B2C_56DB_51FB_4F24_5BB3_4E2D_952E) > 0 then
        return 1
    end
    if not _____76EE_6807_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(context.target) then
        return context["暴击率"]
    end
    local stack = _____8BFB_53D6_5355_4F4D_7D2F_8BA1_5B9E_6570(context.target, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["累计键"])
    return context["暴击率"] + stack * _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["暴击加成系数"]
end
local function _____6C99_6F20_98DF_4EBA_9B54_66B4_51FB_540E_5904_7406(record, _applied, snapshot)
    if not _____76EE_6807_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(record.target) then
        return
    end
    if snapshot == nil or snapshot.isNormalAttack ~= true or snapshot.isSkillAttack == true or snapshot.isSkillDamage == true then
        return
    end
    _____6E05_9664_76EE_6807_84C4_529B(record.target)
    _____79FB_9664_84C4_529B_76EE_6807_767B_8BB0(record.target)
end
local function _____9020_6210_7B2C_56DB_51FB_8303_56F4_4F24_5BB3(attacker, centerTarget)
    local x = _____53D6_5355_4F4DX(centerTarget)
    local y = _____53D6_5355_4F4DY(centerTarget)
    _____5728_5750_6807_64AD_653E_7279_6548(
        _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["蓄力重击"]["爆炸特效"],
        x,
        y,
        0,
        2.5,
        1
    )
    local targets = _____83B7_53D6_8303_56F4_654C_519B(attacker, x, y, _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["蓄力重击"]["范围"])
    _____5199_5165_5355_4F4D_7D2F_8BA1_5B9E_6570(attacker, _____7B2C_56DB_51FB_4F24_5BB3_4E2D_952E, 1)
    do
        local i = 0
        while i < #targets do
            _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                ["来源"] = attacker,
                ["目标"] = targets[i + 1],
                ["伤害公式"] = {["来源攻击力比例"] = _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["蓄力重击"]["攻击力比例"]},
                attack = true,
                ranged = false,
                attackType = ATTACK_TYPE_NORMAL,
                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["标签"] = "沙漠食人魔·蓄力重击第四击"
            })
            i = i + 1
        end
    end
    _____5199_5165_5355_4F4D_7D2F_8BA1_5B9E_6570(attacker, _____7B2C_56DB_51FB_4F24_5BB3_4E2D_952E, 0)
end
local function ____on_6C99_6F20_98DF_4EBA_9B54_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) or GetUnitTypeId(attacker) ~= _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID or not _____76EE_6807_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(target) then
        return
    end
    if snapshot == nil or snapshot.isNormalAttack ~= true or snapshot.isSkillAttack == true or snapshot.isSkillDamage == true then
        return
    end
    if _____8BFB_53D6_5355_4F4D_7D2F_8BA1_5B9E_6570(attacker, _____7B2C_56DB_51FB_4F24_5BB3_4E2D_952E) > 0 then
        return
    end
    local stack = _____8BFB_53D6_5355_4F4D_7D2F_8BA1_5B9E_6570(target, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["累计键"]) + 1
    if stack > _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["蓄力重击"]["最大层数"] then
        stack = _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["蓄力重击"]["最大层数"]
    end
    _____5199_5165_5355_4F4D_7D2F_8BA1_5B9E_6570(target, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["累计键"], stack)
    registerManualBuff(
        target,
        _____98DF_4EBA_9B54BuffID["蓄力Hit"],
        3600,
        stack,
        {stack = stack, sourceUnit = attacker, sourceName = "沙漠食人魔-蓄力重击"}
    )
    _____767B_8BB0_84C4_529B_76EE_6807(target)
    local attackCountBefore = _____8BFB_53D6_5355_4F4D_7D2F_8BA1_5B9E_6570(attacker, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["清空键"])
    local attackCount = attackCountBefore + 1
    local _____662F_5426_7B2C_56DB_51FB = attackCount >= 4
    if attackCount >= 4 then
        attackCount = 0
        _____9020_6210_7B2C_56DB_51FB_8303_56F4_4F24_5BB3(attacker, target)
    end
    _____5199_5165_5355_4F4D_7D2F_8BA1_5B9E_6570(attacker, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["清空键"], attackCount)
end
____exports["注册沙漠食人魔被动效果"] = function()
    if _____6C99_6F20_98DF_4EBA_9B54_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____6C99_6F20_98DF_4EBA_9B54_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_7387_4FEE_6B63(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID, _____6C99_6F20_98DF_4EBA_9B54_66B4_51FB_7387_4FEE_6B63)
    _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_540E_76D1_542C(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID, _____6C99_6F20_98DF_4EBA_9B54_66B4_51FB_540E_5904_7406)
    registerAppliedFinalDamageListener(____on_6C99_6F20_98DF_4EBA_9B54_6700_7EC8_4F24_5BB3)
    registerDeathListener(____on_6C99_6F20_98DF_4EBA_9B54_84C4_529B_76F8_5173_5355_4F4D_6B7B_4EA1)
end
____exports["注册沙漠食人魔被动效果"]()
return ____exports
