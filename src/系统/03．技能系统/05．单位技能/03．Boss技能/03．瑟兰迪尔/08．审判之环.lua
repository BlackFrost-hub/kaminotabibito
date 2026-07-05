--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____64AD_653E_70B9_7279_6548, _____9020_6210_4F24_5BB3, _____6309_653B_51FB_548C_6700_5927_751F_547D_8BA1_7B97_4F24_5BB3, _____53D6_8C61_9650_540D_79F0, _____53D6_8C61_9650_541F_5531_6761_989C_8272, _____53D6_8C61_9650_6CD5_9635_989C_8272, _____542F_52A8_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8F6E_6B21, _____7ED3_7B97_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8C61_9650, getServerTime, addDelayedCallback, _____65BD_52A0_5355_4F53_653B_51FB_529B_964D_4F4EBuff, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____83B7_53D6Boss_6280_80FD_6700_8FDC_654C_5BF9_82F1_96C4, YDWETimerDestroyEffectSafe, _____521B_5EFA_5FAA_73AF_70B9_7279_6548, _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761, _____5173_95ED_541F_5531_6761, _____9020_6210AOE_6280_80FD_4F24_5BB3, jass, GetRandomInt, GetUnitX, GetUnitY, GetUnitState, AddSpecialEffect, R2I, EXSetEffectSize, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, UNIT_STATE_MANA, UNIT_STATE_MAX_MANA
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
function _____64AD_653E_70B9_7279_6548(model, x, y, duration, scale)
    if duration == nil then
        duration = 1
    end
    if scale == nil then
        scale = 1
    end
    local effect = AddSpecialEffect(model, x, y)
    if effect ~= nil and effect ~= 0 then
        if scale ~= 1 then
            EXSetEffectSize(effect, scale)
        end
        YDWETimerDestroyEffectSafe(duration, effect)
    end
end
function _____9020_6210_4F24_5BB3(boss, target, amount, damageType)
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or amount <= 0 then
        return
    end
    _____9020_6210AOE_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害"] = amount,
        attack = false,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        ["伤害类型"] = damageType,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能"
    })
end
function _____6309_653B_51FB_548C_6700_5927_751F_547D_8BA1_7B97_4F24_5BB3(boss, target, _____653B_51FB_529B_6BD4_4F8B, _____6700_5927_751F_547D_6BD4_4F8B)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["审判之环"]
    return (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * _____653B_51FB_529B_6BD4_4F8B + GetUnitState(target, UNIT_STATE_MAX_LIFE) * _____6700_5927_751F_547D_6BD4_4F8B) * config["伤害总倍率"]
end
function _____53D6_8C61_9650_540D_79F0(color)
    if color == 1 then
        return "红"
    end
    if color == 2 then
        return "蓝"
    end
    if color == 3 then
        return "绿"
    end
    return "金"
end
function _____53D6_8C61_9650_541F_5531_6761_989C_8272(color)
    if color == 1 then
        return 4
    end
    if color == 2 then
        return 7
    end
    if color == 3 then
        return 1
    end
    return 6
end
function _____53D6_8C61_9650_6CD5_9635_989C_8272(color)
    if color == 1 then
        return 4294918208
    end
    if color == 2 then
        return 4282417407
    end
    if color == 3 then
        return 4282449760
    end
    return 4294955104
end
____exports["释放瑟兰迪尔审判之环"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["审判之环"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    if context["审判之环进行中"] then
        return
    end
    context["审判之环进行中"] = true
    _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "审判之环")
    _____542F_52A8_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8F6E_6B21(context)
end
function _____542F_52A8_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8F6E_6B21(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["审判之环"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        context["审判之环进行中"] = false
        _____5173_95ED_541F_5531_6761("场地常驻AOE")
        return
    end
    local color = GetRandomInt(1, 4)
    local _____8C61_9650_540D_79F0 = _____53D6_8C61_9650_540D_79F0(color)
    local _____8868_73B0_4E2D_5FC3 = {
        x = GetUnitX(boss),
        y = GetUnitY(boss)
    }
    _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761({
        ["总时长"] = config["周期秒"],
        ["颜色ID"] = _____53D6_8C61_9650_541F_5531_6761_989C_8272(color),
        ["标题文本"] = (config["吟唱条标题文本"] .. "：") .. _____8C61_9650_540D_79F0,
        ["提示文本"] = "场地常驻AOE：下次审判象限 " .. _____8C61_9650_540D_79F0
    })
    _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = config["特效"],
        X = _____8868_73B0_4E2D_5FC3.x,
        Y = _____8868_73B0_4E2D_5FC3.y,
        ["缩放"] = config["法阵缩放"],
        ["顶点颜色"] = _____53D6_8C61_9650_6CD5_9635_989C_8272(color),
        ["重建间隔秒"] = config["法阵重建间隔秒"],
        ["单次持续秒"] = config["法阵单次持续秒"],
        ["总持续秒"] = config["周期秒"],
        ["存活条件"] = function()
            return context["审判之环进行中"] and _____5355_4F4D_6709_6548(boss)
        end
    })
    addDelayedCallback(
        R2I(config["周期秒"] * 1000),
        function()
            if not context["审判之环进行中"] then
                return
            end
            if not _____5355_4F4D_6709_6548(boss) then
                context["审判之环进行中"] = false
                _____5173_95ED_541F_5531_6761("场地常驻AOE")
                return
            end
            _____7ED3_7B97_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8C61_9650(boss, color)
            context["上次审判之环Ms"] = getServerTime()
            _____542F_52A8_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8F6E_6B21(context)
        end
    )
end
function _____7ED3_7B97_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8C61_9650(boss, color)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["审判之环"]
    if color == 2 then
        local target = _____83B7_53D6Boss_6280_80FD_6700_8FDC_654C_5BF9_82F1_96C4(boss)
        if _____5355_4F4D_6709_6548(target) then
            _____65BD_52A0_5355_4F53_653B_51FB_529B_964D_4F4EBuff(
                boss,
                target,
                {
                    BuffID = config["审判压制BuffID"],
                    ["持续时间"] = config["持续秒"],
                    ["攻击力"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(target) * config["蓝攻击力降低比例"],
                    ["图标路径"] = "BuffIcon\\Boss\\Thranduil\\shenpanyazhi.blp"
                }
            )
        end
        return
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            local target = heroes[i + 1]
            local x = GetUnitX(target)
            local y = GetUnitY(target)
            if color == 1 then
                _____64AD_653E_70B9_7279_6548(config["红特效"], x, y, 1)
                _____9020_6210_4F24_5BB3(
                    boss,
                    target,
                    _____6309_653B_51FB_548C_6700_5927_751F_547D_8BA1_7B97_4F24_5BB3(boss, target, config["红伤害Boss攻击力比例"], config["红伤害目标最大生命比例"]),
                    jass.DAMAGE_TYPE_FIRE
                )
            elseif color == 3 then
                _____64AD_653E_70B9_7279_6548(config["绿特效"], x, y, 1)
                local life = GetUnitState(target, UNIT_STATE_LIFE)
                local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
                if maxLife > 0 and life / maxLife > 0.75 then
                    _____9020_6210_4F24_5BB3(
                        boss,
                        target,
                        _____6309_653B_51FB_548C_6700_5927_751F_547D_8BA1_7B97_4F24_5BB3(boss, target, config["绿高血伤害Boss攻击力比例"], config["绿高血伤害目标最大生命比例"]),
                        jass.DAMAGE_TYPE_LIGHTNING
                    )
                else
                    _____9020_6210_4F24_5BB3(
                        boss,
                        target,
                        _____6309_653B_51FB_548C_6700_5927_751F_547D_8BA1_7B97_4F24_5BB3(boss, target, config["绿低血伤害Boss攻击力比例"], config["绿低血伤害目标最大生命比例"]),
                        jass.DAMAGE_TYPE_LIGHTNING
                    )
                end
            else
                _____64AD_653E_70B9_7279_6548(config["金特效"], x, y, 1)
                local mana = GetUnitState(target, UNIT_STATE_MANA)
                local maxMana = GetUnitState(target, UNIT_STATE_MAX_MANA)
                local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
                local lostRatio = maxMana > 0 and (maxMana - mana) / maxMana or 0
                _____9020_6210_4F24_5BB3(boss, target, maxLife * lostRatio, jass.DAMAGE_TYPE_MIND)
            end
            i = i + 1
        end
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
getServerTime = ____require_result_0.getServerTime
addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.03．攻击力降低")
_____65BD_52A0_5355_4F53_653B_51FB_529B_964D_4F4EBuff = ____require_result_1["施加单体攻击力降低Buff"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_2["读取单位攻击力"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
_____83B7_53D6Boss_6280_80FD_6700_8FDC_654C_5BF9_82F1_96C4 = ____require_result_3["获取Boss技能最远敌对英雄"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_5["创建循环点特效"]
local ____require_result_6 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
_____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761 = ____require_result_6["显示场地常驻AOE吟唱条"]
_____5173_95ED_541F_5531_6761 = ____require_result_6["关闭吟唱条"]
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_7["造成AOE技能伤害"]
jass = require("jass.common")
local japi = require("jass.japi")
GetRandomInt = jass.GetRandomInt
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
AddSpecialEffect = jass.AddSpecialEffect
R2I = jass.R2I
EXSetEffectSize = japi.EXSetEffectSize
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_STATE_MANA = jass.UNIT_STATE_MANA
UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
____exports["尝试触发瑟兰迪尔审判之环"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["审判之环"]
    local now = getServerTime()
    if context["审判之环进行中"] then
        return
    end
    if context["上次审判之环Ms"] > 0 and now - context["上次审判之环Ms"] < config["周期秒"] * 1000 then
        return
    end
    context["上次审判之环Ms"] = now
    ____exports["释放瑟兰迪尔审判之环"](context)
end
____exports["停止瑟兰迪尔审判之环"] = function(context)
    context["审判之环进行中"] = false
    _____5173_95ED_541F_5531_6761("场地常驻AOE")
end
____exports["注册瑟兰迪尔审判之环"] = function()
end
return ____exports
