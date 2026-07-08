--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____66F4_65B0_9B54_6CD5_663E_793A, _____7ED3_675F_5F02_5F62_5316, _____5F02_5F62_5316Tick, _____542F_52A8_5F02_5F62_5316_72B6_6001, ____on_83F2_5229_65AF_5F02_5F62_5316_751F_6548, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitState, SetUnitState, UNIT_STATE_MAX_LIFE, UNIT_STATE_MAX_MANA, UNIT_STATE_MANA, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, addPeriodicCallback, removePeriodicCallback, getServerTime, registerManualBuff, getBuffRuntime, _____83F2_5229_65AFBuffID, _____5F00_59CB_7275_5F15, _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664, _____521B_5EFA_70B9_7279_6548, createUnitEffect, _____83F2_5229_65AF_5355_4F4D_7C7B_578BID, _____5F02_5F62_5316_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.00．配置")
local _____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲利斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.01．运行时上下文")
local _____83B7_53D6_5168_90E8_83F2_5229_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部菲利斯上下文"]
local _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建菲利斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.02．数值与表现配置")
local _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯数值与表现配置"]
local _____83F2_5229_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯音效配置"]
local ____05_FF0E_5251_6C14_7075_65A9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.05．剑气灵斩")
local _____91CA_653E_83F2_5229_65AF_5251_6C14_7075_65A9 = ____05_FF0E_5251_6C14_7075_65A9["释放菲利斯剑气灵斩"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.08．台词播放")
local _____64AD_653E_83F2_5229_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放菲利斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_96BE_5EA6 = ____11_FF0E_516C_5171_5DE5_5177["取难度"]
local _____8DDD_79BB_5E73_65B9XY = ____11_FF0E_516C_5171_5DE5_5177["距离平方XY"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____66F4_65B0_9B54_6CD5_663E_793A(context)
    local boss = context["Boss单位"]
    local maxMana = GetUnitState(boss, UNIT_STATE_MAX_MANA)
    if maxMana > 0 then
        local shown = context["当前魔法充能"] > maxMana and maxMana or context["当前魔法充能"]
        SetUnitState(boss, UNIT_STATE_MANA, shown)
    end
    registerManualBuff(
        boss,
        _____83F2_5229_65AFBuffID["魔力汲取"],
        2,
        context["当前魔法充能"],
        {sourceName = "菲利斯-魔力汲取"}
    )
end
function _____7ED3_675F_5F02_5F62_5316(context)
    context["异形化中"] = false
    context["异形化结束Ms"] = 0
end
function _____5F02_5F62_5316Tick(context, callbackID)
    local boss = context["Boss单位"]
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]
    local ____temp_12 = not _____5355_4F4D_6709_6548(boss)
    if not ____temp_12 then
        local ____self_11 = context["清理"]
        ____temp_12 = ____self_11["已清理"](____self_11)
    end
    if ____temp_12 or getServerTime() >= context["异形化结束Ms"] or getBuffRuntime(boss, _____83F2_5229_65AFBuffID["异形化"]) == nil then
        removePeriodicCallback(callbackID)
        _____7ED3_675F_5F02_5F62_5316(context)
        return
    end
    _____521B_5EFA_6280_80FD_63D0_793A_5708({["类型"] = "圆形", ["锚点单位"] = boss, ["半径"] = cfg["近身扣血半径"], ["持续时间"] = cfg["Tick秒"]})
    _____521B_5EFA_6280_80FD_63D0_793A_5708({["类型"] = "双环", ["锚点单位"] = boss, ["半径"] = cfg["牵引半径"], ["持续时间"] = cfg["Tick秒"]})
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["周期波动特效路径"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["缩放"] = 1,
        ["持续秒"] = cfg["特效持续秒"]
    })
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local near2 = cfg["近身扣血半径"] * cfg["近身扣血半径"]
    local pull2 = cfg["牵引半径"] * cfg["牵引半径"]
    local damageRatio = cfg["近身扣血目标最大生命基础比例"] + cfg["近身扣血每难度追加比例"] * _____53D6_96BE_5EA6()
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue25
                end
                local distance2 = _____8DDD_79BB_5E73_65B9XY(
                    GetUnitX(boss),
                    GetUnitY(boss),
                    GetUnitX(hero),
                    GetUnitY(hero)
                )
                if distance2 <= near2 then
                    _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({
                        ["目标"] = hero,
                        ["数值"] = GetUnitState(hero, UNIT_STATE_MAX_LIFE) * damageRatio,
                        ["不致死"] = true,
                        ["显示特效"] = false
                    })
                    createUnitEffect(
                        hero,
                        "origin",
                        cfg["近身命中特效路径"],
                        cfg["特效持续秒"],
                        "菲利斯-异形化近身命中"
                    )
                elseif distance2 <= pull2 then
                    _____5F00_59CB_7275_5F15(hero, {
                        ["中心单位"] = boss,
                        ["主单位"] = boss,
                        ["持续时间"] = cfg["牵引持续秒"],
                        ["每秒速度"] = cfg["牵引每秒速度"],
                        ["最小距离"] = cfg["牵引最小距离"],
                        ["闪电效果代码"] = cfg["牵引闪电代码"],
                        ["闪电高度"] = 80,
                        ["检查地形"] = true,
                        ["禁用碰撞"] = false,
                        ["暂停单位"] = false
                    })
                end
            end
            ::__continue25::
            i = i + 1
        end
    end
end
function _____542F_52A8_5F02_5F62_5316_72B6_6001(context)
    local boss = context["Boss单位"]
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    context["当前魔法充能"] = 0
    _____66F4_65B0_9B54_6CD5_663E_793A(context)
    context["异形化中"] = true
    context["异形化结束Ms"] = getServerTime() + cfg["持续秒"] * 1000
    registerManualBuff(
        boss,
        _____83F2_5229_65AFBuffID["异形化"],
        cfg["持续秒"],
        cfg["造成和受到伤害提高"],
        {sourceName = "菲利斯-异形化"}
    )
    _____64AD_653EBoss_5750_6807_97F3_6548(_____83F2_5229_65AF_97F3_6548_914D_7F6E["异形化"]["启动"], x, y, _____83F2_5229_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
        _____83F2_5229_65AF_97F3_6548_914D_7F6E["异形化"]["牵引波动"],
        x,
        y,
        _____83F2_5229_65AF_97F3_6548_914D_7F6E["异形化"]["牵引波动延迟Ms"],
        _____83F2_5229_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["爆发柱特效路径"],
        X = x,
        Y = y,
        ["缩放"] = 1.75,
        ["持续秒"] = cfg["特效持续秒"]
    })
    createUnitEffect(
        boss,
        "origin",
        cfg["持续气场特效路径"],
        cfg["持续秒"],
        "菲利斯-异形化持续气场"
    )
    _____91CA_653E_83F2_5229_65AF_5251_6C14_7075_65A9(context)
    local tickID = 0
    tickID = addPeriodicCallback(
        cfg["Tick秒"] * 1000,
        function()
            _____5F02_5F62_5316Tick(context, tickID)
        end
    )
    local ____self_13 = context["清理"]
    ____self_13["登记周期回调"](____self_13, "菲利斯-异形化Tick", tickID)
end
____exports["释放菲利斯异形化"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]
    local available = context["当前魔法充能"] > GetUnitState(boss, UNIT_STATE_MANA) and context["当前魔法充能"] or GetUnitState(boss, UNIT_STATE_MANA)
    if available < cfg["魔法阈值"] or context["异形化中"] then
        return
    end
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = GetUnitX(boss),
        ["目标Y"] = GetUnitY(boss),
        ["硬直秒"] = 0.25,
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "大招",
            ["总时长"] = 0.25,
            ["颜色ID"] = cfg["吟唱条颜色ID"],
            ["标题文本"] = cfg["吟唱条标题文本"],
            ["提示文本"] = cfg["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_83F2_5229_65AF_53F0_8BCD(boss, "异形化")
        end,
        ["on生效"] = function()
            _____542F_52A8_5F02_5F62_5316_72B6_6001(context)
        end
    })
end
function ____on_83F2_5229_65AF_5F02_5F62_5316_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____5F02_5F62_5316_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83F2_5229_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放菲利斯异形化"](context)
end
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_3.addPeriodicCallback
removePeriodicCallback = ____require_result_3.removePeriodicCallback
getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_4.registerAppliedFinalDamageListener
local ____require_result_5 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_5.registerDamageModifier
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_6.registerManualBuff
getBuffRuntime = ____require_result_6.getBuffRuntime
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.01．Boss.06．菲利斯")
_____83F2_5229_65AFBuffID = ____require_result_7["菲利斯BuffID"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.吸附牵引系统")
_____5F00_59CB_7275_5F15 = ____require_result_8["开始牵引"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
_____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664 = ____require_result_9["执行非伤害生命移除"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
createUnitEffect = ____require_result_10.createUnitEffect
_____83F2_5229_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____5F02_5F62_5316_6280_80FDID = stringToFourCC(_____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]["技能槽位"])
local _____5F02_5F62_5316_5DF2_6CE8_518C = false
local _____5F02_5F62_5316_4F24_5BB3_76D1_542C_5DF2_6CE8_518C = false
local function _____7D2F_8BA1_5F02_5F62_5316_9B54_6CD5(context, amount)
    if not (amount > 0) then
        return
    end
    context["当前魔法充能"] = context["当前魔法充能"] + amount
    if context["当前魔法充能"] > _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]["魔法阈值"] then
        context["当前魔法充能"] = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]["魔法阈值"]
    end
    _____66F4_65B0_9B54_6CD5_663E_793A(context)
end
local function ____on_83F2_5229_65AF_6700_7EC8_4F24_5BB3_5145_80FD(_target, attacker, applied)
    if not (applied > 0) or not _____5355_4F4D_6709_6548(attacker) then
        return
    end
    local contexts = _____83B7_53D6_5168_90E8_83F2_5229_65AF_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if context["Boss单位"] ~= attacker then
                    goto __continue10
                end
                local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]
                _____7D2F_8BA1_5F02_5F62_5316_9B54_6CD5(
                    context,
                    applied * (cfg["伤害回魔基础比例"] + cfg["伤害回魔每难度追加比例"] * _____53D6_96BE_5EA6())
                )
                return
            end
            ::__continue10::
            i = i + 1
        end
    end
end
local function _____5F02_5F62_5316_4F24_5BB3_4FEE_6B63(damageContext)
    if damageContext == nil then
        return 0
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]
    local list = _____83B7_53D6_5168_90E8_83F2_5229_65AF_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #list do
            do
                local context = list[i + 1]
                if not context["异形化中"] or getServerTime() >= context["异形化结束Ms"] then
                    goto __continue15
                end
                local boss = context["Boss单位"]
                if not _____5355_4F4D_6709_6548(boss) then
                    goto __continue15
                end
                if damageContext.attacker == boss then
                    return damageContext.currentDamage * (1 + cfg["造成和受到伤害提高"])
                end
                if damageContext.target == boss then
                    if damageContext.isLightDamage == true then
                        context["异形化结束Ms"] = context["异形化结束Ms"] - cfg["光伤缩短秒"] * 1000
                    end
                    return damageContext.currentDamage * (1 + cfg["造成和受到伤害提高"])
                end
            end
            ::__continue15::
            i = i + 1
        end
    end
    return damageContext.currentDamage
end
____exports["注册菲利斯异形化"] = function()
    if not _____5F02_5F62_5316_4F24_5BB3_76D1_542C_5DF2_6CE8_518C then
        _____5F02_5F62_5316_4F24_5BB3_76D1_542C_5DF2_6CE8_518C = true
        registerAppliedFinalDamageListener(____on_83F2_5229_65AF_6700_7EC8_4F24_5BB3_5145_80FD)
        registerDamageModifier(_____5F02_5F62_5316_4F24_5BB3_4FEE_6B63, 60)
    end
    if _____5F02_5F62_5316_5DF2_6CE8_518C then
        return
    end
    _____5F02_5F62_5316_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "07．异形化",
        ["单位类型ID"] = _____83F2_5229_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5F02_5F62_5316_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_83F2_5229_65AF_5F02_5F62_5316_751F_6548(boss, _____5F02_5F62_5316_6280_80FDID)
        end
    })
end
return ____exports
