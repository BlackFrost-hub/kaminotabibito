--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____64AD_653E_70B9_7279_6548, _____9020_6210_4F24_5BB3, _____6267_884C_5BA1_5224_4E4B_73AF_516C_5F0F_4F24_5BB3, _____53D6_8C61_9650_540D_79F0, _____53D6_8C61_9650_541F_5531_6761_989C_8272, _____53D6_8C61_9650_6CD5_9635_989C_8272, _____542F_52A8_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8F6E_6B21, _____7ED3_7B97_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8C61_9650, addDelayedCallback, _____65BD_52A0_5355_4F53_653B_51FB_529B_964D_4F4EBuff, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____83B7_53D6Boss_6280_80FD_6700_8FDC_654C_5BF9_82F1_96C4, _____521B_5EFA_70B9_7279_6548, _____521B_5EFA_5FAA_73AF_70B9_7279_6548, _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761, _____5173_95ED_541F_5531_6761, Sound3DII_CooPlayReuse, _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B, jass, GetUnitStateJapi, GetRandomInt, GetUnitX, GetUnitY, GetUnitState, R2I, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, UNIT_STATE_MANA, UNIT_STATE_MAX_MANA
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算BossAOE技能伤害"]
function _____64AD_653E_70B9_7279_6548(model, x, y, duration, scale)
    if duration == nil then
        duration = 1
    end
    if scale == nil then
        scale = 1
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = model,
        X = x,
        Y = y,
        ["缩放"] = scale,
        ["持续秒"] = duration
    })
end
function _____9020_6210_4F24_5BB3(boss, target, amount, damageType, _____6280_80FD_5B9E_4F8BID)
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or amount <= 0 then
        return
    end
    _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害"] = amount,
        attack = false,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        ["伤害类型"] = damageType,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = "瑟兰迪尔审判之环"
    })
end
function _____6267_884C_5BA1_5224_4E4B_73AF_516C_5F0F_4F24_5BB3(boss, target, _____4F24_5BB3_7C7B_578B, _____4F24_5BB3_516C_5F0F, _____6280_80FD_5B9E_4F8BID)
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害公式"] = _____4F24_5BB3_516C_5F0F,
        attack = false,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        ["伤害类型"] = _____4F24_5BB3_7C7B_578B,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = "瑟兰迪尔审判之环"
    })
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
function _____542F_52A8_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8F6E_6B21(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["审判之环"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        context["审判之环进行中"] = false
        _____5173_95ED_541F_5531_6761("场地常驻AOE")
        return
    end
    local color = GetRandomInt(1, 4)
    local _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "瑟兰迪尔审判之环", ["持续时间秒"] = config["周期秒"] + 2})
    local _____8C61_9650_540D_79F0 = _____53D6_8C61_9650_540D_79F0(color)
    local _____8868_73B0_4E2D_5FC3 = {
        x = GetUnitX(boss),
        y = GetUnitY(boss)
    }
    Sound3DII_CooPlayReuse(
        config["展开音效"],
        _____8868_73B0_4E2D_5FC3.x,
        _____8868_73B0_4E2D_5FC3.y,
        0,
        config["展开音效裁断距离"]
    )
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
            _____7ED3_7B97_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8C61_9650(boss, color, _____6280_80FD_5B9E_4F8BID)
            _____542F_52A8_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8F6E_6B21(context)
        end
    )
end
function _____7ED3_7B97_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8C61_9650(boss, color, _____6280_80FD_5B9E_4F8BID)
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
                _____6267_884C_5BA1_5224_4E4B_73AF_516C_5F0F_4F24_5BB3(
                    boss,
                    target,
                    jass.DAMAGE_TYPE_FIRE,
                    {["来源攻击力比例"] = config["红伤害Boss攻击力比例"], ["目标最大生命比例"] = config["红伤害目标最大生命比例"], ["总倍率"] = config["伤害总倍率"]},
                    _____6280_80FD_5B9E_4F8BID
                )
            elseif color == 3 then
                _____64AD_653E_70B9_7279_6548(config["绿特效"], x, y, 1)
                local life = GetUnitState(target, UNIT_STATE_LIFE)
                local maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
                if maxLife > 0 and life / maxLife > 0.75 then
                    _____6267_884C_5BA1_5224_4E4B_73AF_516C_5F0F_4F24_5BB3(
                        boss,
                        target,
                        jass.DAMAGE_TYPE_LIGHTNING,
                        {["来源攻击力比例"] = config["绿高血伤害Boss攻击力比例"], ["目标最大生命比例"] = config["绿高血伤害目标最大生命比例"], ["总倍率"] = config["伤害总倍率"]},
                        _____6280_80FD_5B9E_4F8BID
                    )
                else
                    _____6267_884C_5BA1_5224_4E4B_73AF_516C_5F0F_4F24_5BB3(
                        boss,
                        target,
                        jass.DAMAGE_TYPE_LIGHTNING,
                        {["来源攻击力比例"] = config["绿低血伤害Boss攻击力比例"], ["目标最大生命比例"] = config["绿低血伤害目标最大生命比例"], ["总倍率"] = config["伤害总倍率"]},
                        _____6280_80FD_5B9E_4F8BID
                    )
                end
            else
                _____64AD_653E_70B9_7279_6548(config["金特效"], x, y, 1)
                local mana = GetUnitState(target, UNIT_STATE_MANA)
                local maxMana = GetUnitStateJapi(target, UNIT_STATE_MAX_MANA)
                local maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
                local lostRatio = maxMana > 0 and (maxMana - mana) / maxMana or 0
                _____9020_6210_4F24_5BB3(
                    boss,
                    target,
                    maxLife * lostRatio,
                    jass.DAMAGE_TYPE_MIND,
                    _____6280_80FD_5B9E_4F8BID
                )
            end
            i = i + 1
        end
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.03．攻击力降低")
_____65BD_52A0_5355_4F53_653B_51FB_529B_964D_4F4EBuff = ____require_result_1["施加单体攻击力降低Buff"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_2["读取单位攻击力"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
_____83B7_53D6Boss_6280_80FD_6700_8FDC_654C_5BF9_82F1_96C4 = ____require_result_3["获取Boss技能最远敌对英雄"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_5["创建循环点特效"]
local ____require_result_6 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
_____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761 = ____require_result_6["显示场地常驻AOE吟唱条"]
_____5173_95ED_541F_5531_6761 = ____require_result_6["关闭吟唱条"]
local ____require_result_7 = require("lib.扩展函数.封装函数.02．音效系统.index")
Sound3DII_CooPlayReuse = ____require_result_7.Sound3DII_CooPlayReuse
local ____require_result_8 = require("系统.04．伤害系统.08．技能伤害系统")
_____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_8["创建独立技能伤害实例"]
jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
GetRandomInt = jass.GetRandomInt
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
local AddSpecialEffect = jass.AddSpecialEffect
R2I = jass.R2I
local EXSetEffectSize = japi.EXSetEffectSize
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_STATE_MANA = jass.UNIT_STATE_MANA
UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
____exports["释放瑟兰迪尔审判之环"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["审判之环"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["审判之环进行中"] then
        return false
    end
    context["审判之环进行中"] = true
    _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "审判之环")
    _____542F_52A8_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF_8F6E_6B21(context)
    return true
end
____exports["停止瑟兰迪尔审判之环"] = function(context)
    context["审判之环进行中"] = false
    _____5173_95ED_541F_5531_6761("场地常驻AOE")
end
return ____exports
