--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.10．欧尔贝克.00．配置")
local _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["欧尔贝克单位技能配置"]
local ____00B_FF0E_79EF_6512_72B6_6001 = require("系统.03．技能系统.05．单位技能.04．英雄技能.10．欧尔贝克.00B．积攒状态")
local _____83B7_53D6_6B27_5C14_8D1D_514B_79EF_6512_8BA1_6570 = ____00B_FF0E_79EF_6512_72B6_6001["获取欧尔贝克积攒计数"]
local _____6D88_8017_6B27_5C14_8D1D_514B_79EF_6512 = ____00B_FF0E_79EF_6512_72B6_6001["消耗欧尔贝克积攒"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local ____require_result_2 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_2.Sound3DII_UnitPlayReuse
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_3["创建原生弹幕"]
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_4.registerAppliedFinalDamageListener
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____5355_4F4D_62E5_6709_539F_751FBuff = ____require_result_6["单位拥有原生Buff"]
local _____5355_4F4D_662F_6307_5B9A_7C7B_578B = ____require_result_6["单位是指定类型"]
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6B27_5C14_8D1D_514B_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local ____E_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["E技能ID"])
local _____79EF_6512Buff_7C7B_578BID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["积攒BuffID"])
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight
--- 已注册标记，防止重复监听
local _____5DF2_6CE8_518C = false
local function _____662F_6B27_5C14_8D1D_514B(unit)
    return _____5355_4F4D_662F_6307_5B9A_7C7B_578B(unit, _____6B27_5C14_8D1D_514B_5355_4F4D_7C7B_578BID)
end
local function _____91CA_653E_6B27_5C14_8D1D_514B_5251_6C14(caster, level)
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.E
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (cfg["基础攻击力倍率"] + cfg["每级攻击力倍率"] * level)
    local angle = GetUnitFacing(caster)
    Sound3DII_UnitPlayReuse(cfg["音效路径"], caster, cfg["音效裁断距离"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["触发特效模型"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        Z = 0,
        ["持续秒"] = 0.8
    })
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = caster,
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        ["方向角"] = angle,
        ["速度"] = cfg["弹幕速度"],
        ["最大距离"] = cfg["弹幕速度"] * cfg["弹幕生命秒"],
        ["生命周期"] = cfg["弹幕生命秒"],
        ["命中半径"] = cfg["弹幕命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["最大总命中次数"] = 1,
        ["伤害值"] = damage,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____E_6280_80FD_7C7B_578BID,
        ["技能标签"] = "欧尔贝克-千枝枪剑气",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true,
        ["模型"] = cfg["弹幕模型"],
        ["飞行高度"] = GetUnitFlyHeight(caster) + GetUnitDefaultFlyHeight(caster)
    })
end
local function _____5C1D_8BD5_89E6_53D1_6B27_5C14_8D1D_514B_5251_6C14(caster)
    local level = GetUnitAbilityLevel(caster, ____E_6280_80FD_7C7B_578BID)
    if not (level > 0) or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.E
    local hasBuff = _____5355_4F4D_62E5_6709_539F_751FBuff(caster, _____79EF_6512Buff_7C7B_578BID)
    local probability = hasBuff and cfg["积攒触发概率"] or cfg["普攻触发概率"]
    if math.random() >= probability then
        return
    end
    _____91CA_653E_6B27_5C14_8D1D_514B_5251_6C14(caster, level)
end
local function ____on_6B27_5C14_8D1D_514B_9020_6210_4F24_5BB3_7ED3_7B97(_target, attacker, applied, snapshot)
    if not (applied > 0) or not _____662F_6B27_5C14_8D1D_514B(attacker) then
        return
    end
    local ____opt_result_9
    if snapshot ~= nil then
        ____opt_result_9 = snapshot.isWrappedSkillDamage
    end
    if ____opt_result_9 == true then
        return
    end
    if _____83B7_53D6_6B27_5C14_8D1D_514B_79EF_6512_8BA1_6570(attacker) > 0 then
        _____6D88_8017_6B27_5C14_8D1D_514B_79EF_6512(attacker)
    end
    _____5C1D_8BD5_89E6_53D1_6B27_5C14_8D1D_514B_5251_6C14(attacker)
end
____exports["注册欧尔贝克被动"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_6B27_5C14_8D1D_514B_9020_6210_4F24_5BB3_7ED3_7B97)
end
____exports["注册欧尔贝克被动"]()
return ____exports
