--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC, _____5355_4F4D_6709_6548, _____8DDD_79BB_5E73_65B9XY, _____64AD_653E_6269_6563_51B2_51FB_6CE2_84C4_529B_7279_6548, _____64AD_653E_6269_6563_51B2_51FB_6CE2_547D_4E2D_7279_6548, _____65BD_52A0_53E4_6811_8870_5F31, _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_5173_952E_602A_53EB, _____6267_884C_6269_6563_51B2_51FB_6CE2, ____on_6811_9B54_9996_9886_6269_6563_51B2_51FB_6CE2_751F_6548, _____9020_6210AOE_6280_80FD_4F24_5BB3, GetUnitTypeId, GetUnitX, GetUnitY, GetHandleId, IsUnitType, UNIT_TYPE_DEAD, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, addPeriodicCallback, removePeriodicCallback, registerManualBuff, _____6811_9B54_9996_9886BuffID, _____521B_5EFA_70B9_7279_6548, _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID, _____6269_6563_51B2_51FB_6CE2_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.00．配置")
local _____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["树魔首领单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建树魔首领上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.02．数值与表现配置")
local _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领数值与表现配置"]
local _____6811_9B54_9996_9886_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领音效配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.08．台词播放")
local _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放树魔首领台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____8DDD_79BB_5E73_65B9XY(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return dx * dx + dy * dy
end
function _____64AD_653E_6269_6563_51B2_51FB_6CE2_84C4_529B_7279_6548(boss)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["扩散冲击波"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["蓄力特效路径"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        Z = 0,
        ["缩放"] = cfg["蓄力特效缩放"],
        ["持续秒"] = cfg["蓄力特效持续秒"]
    })
end
function _____64AD_653E_6269_6563_51B2_51FB_6CE2_547D_4E2D_7279_6548(boss)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["扩散冲击波"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["扩散命中特效路径"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        Z = 0,
        ["缩放"] = cfg["扩散命中特效缩放"],
        ["持续秒"] = cfg["扩散命中特效持续秒"]
    })
end
function _____65BD_52A0_53E4_6811_8870_5F31(target)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["扩散冲击波"]
    registerManualBuff(
        target,
        _____6811_9B54_9996_9886BuffID["古树衰弱"],
        cfg["攻击降低持续秒"],
        cfg["攻击降低比例"],
        {sourceName = "树魔首领-扩散冲击波"}
    )
end
function _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_5173_952E_602A_53EB(boss)
    local soundCfg = _____6811_9B54_9996_9886_97F3_6548_914D_7F6E
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = soundCfg["怪物拟声"]["标识"],
        ["音效路径列表"] = soundCfg["怪物拟声"]["音效路径列表"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["裁断距离"] = soundCfg["默认裁断距离"],
        ["冷却Ms"] = soundCfg["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = soundCfg["怪物拟声"]["关键机制触发概率百分比"]
    })
end
function _____6267_884C_6269_6563_51B2_51FB_6CE2(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["扩散冲击波"]
    local hit = {}
    local step = 0
    _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_5173_952E_602A_53EB(boss)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["扩散冲击波"]["生效"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____64AD_653E_6269_6563_51B2_51FB_6CE2_547D_4E2D_7279_6548(boss)
    local callbackID = 0
    callbackID = addPeriodicCallback(
        cfg["Tick间隔毫秒"],
        function()
            local ____temp_11 = not _____5355_4F4D_6709_6548(boss)
            if not ____temp_11 then
                local ____self_10 = context["清理"]
                ____temp_11 = ____self_10["已清理"](____self_10)
            end
            if ____temp_11 then
                removePeriodicCallback(callbackID)
                return
            end
            step = step + 1
            local radius = cfg["初始半径"] + cfg["每跳扩张半径"] * step
            local radius2 = radius * radius
            local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["Boss攻击力比例"]
            local bossX = GetUnitX(boss)
            local bossY = GetUnitY(boss)
            local targets = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            do
                local i = 0
                while i < #targets do
                    do
                        local target = targets[i + 1]
                        if not _____5355_4F4D_6709_6548(target) then
                            goto __continue14
                        end
                        local hid = GetHandleId(target) or 0
                        if hid == 0 or hit[hid] == true then
                            goto __continue14
                        end
                        if _____8DDD_79BB_5E73_65B9XY(
                            bossX,
                            bossY,
                            GetUnitX(target),
                            GetUnitY(target)
                        ) > radius2 then
                            goto __continue14
                        end
                        hit[hid] = true
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["技能ID"] = _____6269_6563_51B2_51FB_6CE2_6280_80FDID,
                            ["来源"] = boss,
                            ["目标"] = target,
                            ["伤害"] = damage,
                            attack = false,
                            ranged = false,
                            attackType = ATTACK_TYPE_NORMAL,
                            ["伤害类型"] = DAMAGE_TYPE_PLANT,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "Boss技能"
                        })
                        _____65BD_52A0_53E4_6811_8870_5F31(target)
                    end
                    ::__continue14::
                    i = i + 1
                end
            end
            if step >= cfg["最大扩张跳数"] then
                removePeriodicCallback(callbackID)
            end
        end
    )
    local ____self_12 = context["清理"]
    ____self_12["登记周期回调"](____self_12, "树魔首领-扩散冲击波", callbackID)
end
____exports["释放树魔首领扩散冲击波"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["扩散冲击波"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({["类型"] = "渐变圆形", ["锚点单位"] = boss, ["半径"] = cfg["预警半径"], ["持续时间"] = cfg["前摇秒"]})
    _____64AD_653E_6269_6563_51B2_51FB_6CE2_84C4_529B_7279_6548(boss)
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = GetUnitX(boss),
        ["目标Y"] = GetUnitY(boss),
        ["硬直秒"] = cfg["前摇秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["前摇秒"],
            ["颜色ID"] = cfg["吟唱条颜色ID"],
            ["标题文本"] = cfg["吟唱条标题文本"],
            ["提示文本"] = cfg["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD(boss, "扩散冲击波")
        end,
        ["on生效"] = function()
            _____6267_884C_6269_6563_51B2_51FB_6CE2(context)
        end
    })
end
function ____on_6811_9B54_9996_9886_6269_6563_51B2_51FB_6CE2_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6269_6563_51B2_51FB_6CE2_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放树魔首领扩散冲击波"](context)
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetHandleId = jass.GetHandleId
IsUnitType = jass.IsUnitType
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_2["启动基础施法时间线"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_5.addPeriodicCallback
removePeriodicCallback = ____require_result_5.removePeriodicCallback
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_6.registerManualBuff
local getBuffRuntime = ____require_result_6.getBuffRuntime
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.04．树魔首领")
_____6811_9B54_9996_9886BuffID = ____require_result_7["树魔首领BuffID"]
local ____require_result_8 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_8.registerDamageModifier
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
_____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____6269_6563_51B2_51FB_6CE2_6280_80FDID = stringToFourCC(_____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["扩散冲击波"]["技能槽位"])
local _____6269_6563_51B2_51FB_6CE2_5DF2_6CE8_518C = false
local function _____53E4_6811_8870_5F31_4F24_5BB3_4FEE_6B63(damageContext)
    if damageContext == nil or damageContext.isNormalAttack ~= true then
        return damageContext.currentDamage
    end
    local runtime = getBuffRuntime(damageContext.attacker, _____6811_9B54_9996_9886BuffID["古树衰弱"])
    if runtime == nil then
        return damageContext.currentDamage
    end
    local reduce = runtime.effect > 0 and runtime.effect or _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["扩散冲击波"]["攻击降低比例"]
    return damageContext.currentDamage * (1 - reduce)
end
____exports["注册树魔首领扩散冲击波"] = function()
    if _____6269_6563_51B2_51FB_6CE2_5DF2_6CE8_518C then
        return
    end
    _____6269_6563_51B2_51FB_6CE2_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "树魔首领-扩散冲击波",
        ["单位类型ID"] = _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6269_6563_51B2_51FB_6CE2_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_6811_9B54_9996_9886_6269_6563_51B2_51FB_6CE2_751F_6548(boss, _____6269_6563_51B2_51FB_6CE2_6280_80FDID)
        end
    })
    registerDamageModifier(_____53E4_6811_8870_5F31_4F24_5BB3_4FEE_6B63, 35)
end
return ____exports
