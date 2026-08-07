--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.00．配置")
local _____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派剑士单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.01．运行时上下文")
local _____83B7_53D6_5168_90E8_6559_6D3E_5251_58EB_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部教派剑士上下文"]
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派剑士上下文"]
local _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派剑士单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.02．数值与表现配置")
local _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派剑士技能配置"]
local ____04_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____04_FF0E_5BF9_5916_63A5_53E3["创建召唤物"]
local ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.03．召唤物组状态管理")
local _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001 = ____03_FF0E_53EC_5524_7269_7EC4_72B6_6001_7BA1_7406["创建召唤物组状态"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位最大生命"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["执行战斗自身传送到坐标"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664 = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["执行非伤害生命移除"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local getGameDifficulty = ____require_result_2.getGameDifficulty
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_3["取当前有效玩家人数"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_4["开始硬直"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_5["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_5["移除单位暂停"]
local ____require_result_6 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_6["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_6["关闭吟唱条"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_7.getEnemyUnitsInRange
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_8.EC_CreateEffect
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local ____require_result_10 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_10.debugLogForce
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerController = jass.GetPlayerController
local GetRandomReal = jass.GetRandomReal
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local SetUnitAnimation = jass.SetUnitAnimation
local ShowUnit = jass.ShowUnit
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local MAP_CONTROL_USER = jass.MAP_CONTROL_USER
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5206_8EAB_6682_505C_6765_6E90 = "Boss:教派剑士:深渊分身"
local _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6DF1_6E0A_5206_8EAB_6280_80FDID = stringToFourCCSafe(_____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["深渊分身"])
local _____6DF1_6E0A_5206_8EAB_5DF2_6CE8_518C = false
local function _____5355_4F4D_5C5E_4E8E_5206_8EAB_72B6_6001(unit, _____72B6_6001)
    if unit == nil or unit == 0 then
        return false
    end
    local hid = GetHandleId(unit)
    local ____self_11 = _____72B6_6001["召唤组"]
    local _____5217_8868 = ____self_11["取单位列表"](____self_11)
    do
        local i = 0
        while i < #_____5217_8868 do
            if GetHandleId(_____5217_8868[i + 1]) == hid then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____662F_5426_7531_73A9_5BB6_6467_6BC1(killer)
    return killer ~= nil and killer ~= 0 and (IsUnitType(killer, UNIT_TYPE_HERO) or GetPlayerController(GetOwningPlayer(killer)) == MAP_CONTROL_USER)
end
local function _____67E5_627E_5206_8EAB_72B6_6001(unit)
    local _____4E0A_4E0B_6587_5217_8868 = _____83B7_53D6_5168_90E8_6559_6D3E_5251_58EB_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #_____4E0A_4E0B_6587_5217_8868 do
            local _____72B6_6001 = _____4E0A_4E0B_6587_5217_8868[i + 1]["分身状态"]
            if _____72B6_6001 ~= nil and not _____72B6_6001["已结束"] and _____5355_4F4D_5C5E_4E8E_5206_8EAB_72B6_6001(unit, _____72B6_6001) then
                return _____72B6_6001
            end
            i = i + 1
        end
    end
    return nil
end
local function _____6DF1_6E0A_5206_8EAB_4F24_5BB3_4FEE_6B63(context)
    if context == nil then
        return 0
    end
    if _____67E5_627E_5206_8EAB_72B6_6001(context.attacker) ~= nil then
        if context.currentDamage > 0 then
            debugLogForce(
                "教派剑士-深渊分身",
                "分身造成伤害归零",
                "cloneHid=",
                GetHandleId(context.attacker),
                "prevented=",
                context.currentDamage
            )
        end
        return 0
    end
    if _____67E5_627E_5206_8EAB_72B6_6001(context.target) ~= nil then
        return context.currentDamage * _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊分身"]["分身承伤倍率"]
    end
    return context.currentDamage
end
local function _____7ED3_675F_6DF1_6E0A_5206_8EAB(_____72B6_6001, _____5168_7531_73A9_5BB6_6467_6BC1, _____539F_56E0)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    if boss ~= nil and boss ~= 0 then
        _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(boss, _____72B6_6001["起点X"], _____72B6_6001["起点Y"])
        ShowUnit(boss, true)
        _____79FB_9664_5355_4F4D_6682_505C(boss, _____5206_8EAB_6682_505C_6765_6E90)
        _____72B6_6001["Boss已隐藏"] = false
        if _____5168_7531_73A9_5BB6_6467_6BC1 and _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) then
            _____5F00_59CB_786C_76F4(boss, _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊分身"]["全部摧毁硬直秒"])
        end
    end
    _____5173_95ED_541F_5531_6761(_____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊分身"]["读条通道"])
    if _____72B6_6001["上下文"]["分身状态"] == _____72B6_6001 then
        _____72B6_6001["上下文"]["分身状态"] = nil
    end
    debugLogForce(
        "教派剑士-深渊分身",
        "分身阶段结束并恢复Boss",
        "bossHid=",
        boss ~= nil and boss ~= 0 and GetHandleId(boss) or 0,
        "reason=",
        _____539F_56E0,
        "allPlayerDestroyed=",
        _____5168_7531_73A9_5BB6_6467_6BC1,
        "playerKills=",
        _____72B6_6001["玩家摧毁数量"],
        "total=",
        _____72B6_6001["总数量"]
    )
end
local function ____on_6DF1_6E0A_5206_8EAB_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    local ____self_12 = _____72B6_6001["召唤组"]
    ____self_12["清空"](____self_12, true)
    _____7ED3_675F_6DF1_6E0A_5206_8EAB(_____72B6_6001, false, "上下文清理")
end
local function ____on_5206_8EAB_6B7B_4EA1_7206_70B8(variable)
    local _____5FEB_7167 = variable
    if _____5FEB_7167 == nil or not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(_____5FEB_7167["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____5FEB_7167["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊分身"]
    EC_CreateEffect(
        _____914D_7F6E["爆炸特效路径"],
        _____5FEB_7167.X,
        _____5FEB_7167.Y,
        0,
        0,
        _____914D_7F6E["爆炸特效缩放"],
        1,
        _____914D_7F6E["爆炸特效持续秒"]
    )
    local _____76EE_6807_5217_8868 = getEnemyUnitsInRange(boss, _____5FEB_7167.X, _____5FEB_7167.Y, _____914D_7F6E["分身死亡爆炸半径"])
    local _____547D_4E2D_6570 = 0
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            local _____7ED3_679C = _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                ["来源"] = boss,
                ["目标"] = _____76EE_6807_5217_8868[i + 1],
                ["技能ID"] = _____6DF1_6E0A_5206_8EAB_6280_80FDID,
                ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["分身死亡伤害Boss攻击力比例"]},
                attack = false,
                ranged = false,
                attackType = ATTACK_TYPE_NORMAL,
                ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["标签"] = _____914D_7F6E["伤害标签"]
            })
            if _____7ED3_679C["是否造成伤害"] then
                _____547D_4E2D_6570 = _____547D_4E2D_6570 + 1
            end
            i = i + 1
        end
    end
    debugLogForce(
        "教派剑士-深渊分身",
        "分身死亡延迟爆炸结算",
        "cloneHid=",
        _____5FEB_7167["分身Hid"],
        "x=",
        _____5FEB_7167.X,
        "y=",
        _____5FEB_7167.Y,
        "hitCount=",
        _____547D_4E2D_6570
    )
end
local function ____on_5206_8EAB_5355_4F4D_6B7B_4EA1(unit, killer, _group, variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil then
        return
    end
    if _____662F_5426_7531_73A9_5BB6_6467_6BC1(killer) then
        _____72B6_6001["玩家摧毁数量"] = _____72B6_6001["玩家摧毁数量"] + 1
    end
    local _____5FEB_7167 = {
        ["上下文"] = _____72B6_6001["上下文"],
        X = GetUnitX(unit),
        Y = GetUnitY(unit),
        ["分身Hid"] = GetHandleId(unit)
    }
    local _____7206_70B8ID = addDelayedCallback(_____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊分身"]["分身死亡爆炸延迟秒"] * 1000, ____on_5206_8EAB_6B7B_4EA1_7206_70B8, _____5FEB_7167)
    local ____self_13 = _____72B6_6001["上下文"]["清理"]
    ____self_13["登记延迟回调"](____self_13, "教派剑士-分身死亡爆炸", _____7206_70B8ID)
    debugLogForce(
        "教派剑士-深渊分身",
        "分身死亡",
        "cloneHid=",
        _____5FEB_7167["分身Hid"],
        "killerHid=",
        killer ~= nil and killer ~= 0 and GetHandleId(killer) or 0,
        "playerDestroyedCount=",
        _____72B6_6001["玩家摧毁数量"]
    )
end
local function ____on_5168_90E8_5206_8EAB_6B7B_4EA1(_group, variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil then
        return
    end
    _____7ED3_675F_6DF1_6E0A_5206_8EAB(_____72B6_6001, _____72B6_6001["总数量"] > 0 and _____72B6_6001["玩家摧毁数量"] >= _____72B6_6001["总数量"], "全部分身消失")
end
local function ____on_6DF1_6E0A_5206_8EAB_515C_5E95_7ED3_675F(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    local ____self_14 = _____72B6_6001["召唤组"]
    ____self_14["清空"](____self_14, true)
    _____7ED3_675F_6DF1_6E0A_5206_8EAB(_____72B6_6001, false, "持续时间兜底结束")
end
local function ____on_521B_5EFA_6DF1_6E0A_5206_8EAB(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] or not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(_____72B6_6001["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊分身"]
    _____5173_95ED_541F_5531_6761(_____914D_7F6E["读条通道"])
    _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({
        ["目标"] = boss,
        ["数值"] = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(boss) * _____914D_7F6E["自损最大生命比例"],
        ["不致死"] = false,
        ["显示文字"] = false,
        ["显示特效"] = false
    })
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) then
        _____7ED3_675F_6DF1_6E0A_5206_8EAB(_____72B6_6001, false, "自损后死亡")
        return
    end
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____914D_7F6E["分身音效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____914D_7F6E["分身音效裁断距离"]
    )
    local ____self_15 = _____72B6_6001["召唤组"]
    ____self_15["开始批次"](____self_15, _____72B6_6001["总数量"])
    local _____5B9E_9645_6570_91CF = 0
    do
        local i = 0
        while i < _____72B6_6001["总数量"] do
            local _____89D2_5EA6 = GetRandomReal(0, 360)
            local clone = _____521B_5EFA_53EC_5524_7269({
                ["主人单位"] = boss,
                ["所属玩家"] = GetOwningPlayer(boss),
                ["单位类型"] = _____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["单位ID"],
                ["单位名称"] = "深渊分身",
                X = _____6781_5750_6807X(_____72B6_6001["起点X"], _____89D2_5EA6, _____914D_7F6E["分身散开距离"]),
                Y = _____6781_5750_6807Y(_____72B6_6001["起点Y"], _____89D2_5EA6, _____914D_7F6E["分身散开距离"]),
                ["朝向"] = _____89D2_5EA6,
                ["持续时间"] = _____914D_7F6E["分身持续秒"],
                ["缩放"] = _____914D_7F6E["分身缩放"]
            })
            if clone ~= nil and clone ~= 0 then
                local ____self_16 = _____72B6_6001["召唤组"]
                ____self_16["登记"](____self_16, clone)
                _____5B9E_9645_6570_91CF = _____5B9E_9645_6570_91CF + 1
                debugLogForce(
                    "教派剑士-深渊分身",
                    "分身创建并登记",
                    "cloneHid=",
                    GetHandleId(clone),
                    "index=",
                    i + 1
                )
            end
            i = i + 1
        end
    end
    local ____self_17 = _____72B6_6001["召唤组"]
    ____self_17["结束批次"](____self_17)
    _____72B6_6001["总数量"] = _____5B9E_9645_6570_91CF
    if _____5B9E_9645_6570_91CF <= 0 then
        _____7ED3_675F_6DF1_6E0A_5206_8EAB(_____72B6_6001, false, "分身创建失败")
        return
    end
    _____6DFB_52A0_5355_4F4D_6682_505C(boss, _____5206_8EAB_6682_505C_6765_6E90)
    ShowUnit(boss, false)
    _____72B6_6001["Boss已隐藏"] = true
    local _____515C_5E95ID = addDelayedCallback((_____914D_7F6E["分身持续秒"] + 0.2) * 1000, ____on_6DF1_6E0A_5206_8EAB_515C_5E95_7ED3_675F, _____72B6_6001)
    local ____self_18 = _____72B6_6001["上下文"]["清理"]
    ____self_18["登记延迟回调"](____self_18, "教派剑士-深渊分身兜底", _____515C_5E95ID)
    debugLogForce(
        "教派剑士-深渊分身",
        "召唤批次结束并隐藏Boss",
        "bossHid=",
        GetHandleId(boss),
        "count=",
        _____5B9E_9645_6570_91CF,
        "duration=",
        _____914D_7F6E["分身持续秒"]
    )
end
____exports["释放教派剑士深渊分身"] = function(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) or _____4E0A_4E0B_6587["分身状态"] ~= nil then
        return false
    end
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊分身"]
    local playerCount = _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570()
    local difficulty = getGameDifficulty() > 0 and getGameDifficulty() or 1
    local count = (playerCount >= _____914D_7F6E["高人数阈值"] or difficulty >= _____914D_7F6E["高难度阈值"]) and _____914D_7F6E["强化分身数量"] or _____914D_7F6E["默认分身数量"]
    local _____72B6_6001 = {
        ["已结束"] = false,
        ["上下文"] = _____4E0A_4E0B_6587,
        ["起点X"] = GetUnitX(boss),
        ["起点Y"] = GetUnitY(boss),
        ["召唤组"] = nil,
        ["总数量"] = count,
        ["玩家摧毁数量"] = 0,
        ["Boss已隐藏"] = false
    }
    _____72B6_6001["召唤组"] = _____521B_5EFA_53EC_5524_7269_7EC4_72B6_6001({
        ["清理"] = _____4E0A_4E0B_6587["清理"],
        ["名称"] = "教派剑士-深渊分身组",
        ["全灭延迟秒"] = 0,
        ["变量"] = _____72B6_6001,
        ["on单位死亡"] = ____on_5206_8EAB_5355_4F4D_6B7B_4EA1,
        ["on全部死亡"] = ____on_5168_90E8_5206_8EAB_6B7B_4EA1
    })
    _____4E0A_4E0B_6587["分身状态"] = _____72B6_6001
    local ____self_21 = _____4E0A_4E0B_6587["清理"]
    ____self_21["登记清理"](____self_21, "教派剑士-深渊分身清理", ____on_6DF1_6E0A_5206_8EAB_6E05_7406, _____72B6_6001)
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["施法硬直秒"])
    SetUnitAnimation(boss, _____914D_7F6E["动作名"])
    EC_CreateEffect(
        _____914D_7F6E["起始特效路径"],
        _____72B6_6001["起点X"],
        _____72B6_6001["起点Y"],
        0,
        270,
        _____914D_7F6E["起始特效缩放"],
        1,
        _____914D_7F6E["起始特效持续秒"]
    )
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["施法硬直秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    local _____521B_5EFAID = addDelayedCallback(_____914D_7F6E["施法硬直秒"] * 1000, ____on_521B_5EFA_6DF1_6E0A_5206_8EAB, _____72B6_6001)
    local ____self_22 = _____4E0A_4E0B_6587["清理"]
    ____self_22["登记延迟回调"](____self_22, "教派剑士-创建深渊分身", _____521B_5EFAID)
    debugLogForce(
        "教派剑士-深渊分身",
        "施法前摇开始",
        "bossHid=",
        GetHandleId(boss),
        "playerCount=",
        playerCount,
        "difficulty=",
        difficulty,
        "count=",
        count
    )
    return true
end
local function ____on_6559_6D3E_5251_58EB_6DF1_6E0A_5206_8EAB_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6DF1_6E0A_5206_8EAB_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(castingUnit)
    local _____5DF2_5F00_59CB = _____4E0A_4E0B_6587 ~= nil and ____exports["释放教派剑士深渊分身"](_____4E0A_4E0B_6587)
    debugLogForce(
        "教派剑士-深渊分身",
        "正式SPELL_EFFECT入口",
        "bossHid=",
        GetHandleId(castingUnit),
        "started=",
        _____5DF2_5F00_59CB
    )
end
____exports["注册教派剑士深渊分身"] = function()
    if _____6DF1_6E0A_5206_8EAB_5DF2_6CE8_518C then
        return
    end
    _____6DF1_6E0A_5206_8EAB_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_6559_6D3E_5251_58EB_6DF1_6E0A_5206_8EAB_751F_6548)
    registerDamageModifier(_____6DF1_6E0A_5206_8EAB_4F24_5BB3_4FEE_6B63, _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["深渊分身"]["分身伤害修正优先级"])
    debugLogForce("教派剑士-深渊分身", "技能壳与分身伤害修正监听注册完成", "skillId=", _____6DF1_6E0A_5206_8EAB_6280_80FDID)
end
return ____exports
