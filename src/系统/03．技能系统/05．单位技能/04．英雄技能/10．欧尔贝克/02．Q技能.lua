--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____onQ_51B2_950B_7ED3_675F_4E0A_4E0B_6587
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.10．欧尔贝克.00．配置")
local _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["欧尔贝克单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.10．欧尔贝克.00A．表现工具")
local _____64AD_653E_6B27_5C14_8D1D_514B_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放欧尔贝克单位音效"]
local _____64AD_653E_6B27_5C14_8D1D_514B_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放欧尔贝克配置动作"]
local ____17_FF0E_6B27_5C14_8D1D_514B = require("系统.05．Buff系统.03．Buff表.02．英雄.17．欧尔贝克")
local _____6B27_5C14_8D1D_514BBuffID = ____17_FF0E_6B27_5C14_8D1D_514B["欧尔贝克BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_3["开始冲锋"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_5["造成技能伤害"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_6["施加眩晕"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_7.getUnitsInRange
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_8["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_8["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_8["两点角度"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
local ____require_result_10 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_10.isUnitEnemy
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____5355_4F4D_62E5_6709_539F_751FBuff = ____require_result_11["单位拥有原生Buff"]
local _____5355_4F4D_662F_6307_5B9A_7C7B_578B = ____require_result_11["单位是指定类型"]
local ____require_result_12 = require("系统.05．Buff系统.00．Buff系统")
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_12["移除单位指定Buff"]
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____Q_6280_80FDID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"])
local _____6B27_5C14_8D1D_514B_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____79EF_6512Buff_7C7B_578BID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["积攒BuffID"])
--- 冲锋速度 = 源 JASS（20 码/0.03125s） × 1.5 倍
local _____51B2_523A_6BCF_79D2_901F_5EA6 = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.Q["冲刺步距"] / 0.03125 * _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.Q["冲刺速度倍率"]
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local UnitRemoveAbility = jass.UnitRemoveAbility
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local function _____5F52_4E00_5316_89D2_5EA6(angle)
    local result = angle % 360
    if result < 0 then
        result = result + 360
    end
    return result
end
--- 返回两角度在 0~180 范围内的最小夹角
local function _____89D2_5EA6_5DEE(a, b)
    local diff = math.abs(_____5F52_4E00_5316_89D2_5EA6(a) - _____5F52_4E00_5316_89D2_5EA6(b))
    if diff > 180 then
        diff = 360 - diff
    end
    return diff
end
--- 目标类型过滤：排除建筑/机械/古树等无效目标（路径与扇形共用）
local function _____662F_6709_6548_4F24_5BB3_76EE_6807(_____4E0A_4E0B_6587, target)
    if target == nil or target == 0 or target == _____4E0A_4E0B_6587["施法者"] then
        return false
    end
    if not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_MECHANICAL) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_STRUCTURE) then
        return false
    end
    if not isUnitEnemy(target, _____4E0A_4E0B_6587["施法者"]) then
        return false
    end
    return true
end
--- 是否已计入本次 Q 的去重表
local function _____5DF2_547D_4E2D_8FC7(_____4E0A_4E0B_6587, target)
    return _____4E0A_4E0B_6587["已命中"][GetHandleId(target)] == true
end
--- 记录去重并结算：眩晕 + 技能伤害（AOE 形态）
local function _____7ED3_7B97Q_5355_4F53_4F24_5BB3(_____4E0A_4E0B_6587, target)
    if _____5DF2_547D_4E2D_8FC7(_____4E0A_4E0B_6587, target) then
        return
    end
    _____4E0A_4E0B_6587["已命中"][GetHandleId(target)] = true
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.Q
    local _____7729_6655_79D2 = _____4E0A_4E0B_6587["十字斩"] and cfg["十字眩晕秒"] or cfg["眩晕秒"]
    _____65BD_52A0_7729_6655(
        _____4E0A_4E0B_6587["施法者"],
        target,
        _____7729_6655_79D2,
        _____4E0A_4E0B_6587["十字斩"] and "十字斩" or "横一字斩",
        "技能"
    )
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____4E0A_4E0B_6587["施法者"],
        ["目标"] = target,
        ["伤害"] = _____4E0A_4E0B_6587["伤害值"],
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FDID,
        ["标签"] = _____4E0A_4E0B_6587["十字斩"] and "欧尔贝克-十字斩" or "欧尔贝克-横一字斩",
        ["伤害形态"] = "AOE",
        ["参与技能伤害加成"] = true
    })
end
--- 冲锋路径命中回调：冲锋系统已按“命中伤害”结算过伤害，这里只记去重表并施加眩晕
local function ____onQ_8DEF_5F84_547D_4E2D(_____79FB_52A8_5355_4F4D, _____76EE_6807)
    local _____4E0A_4E0B_6587 = ____onQ_51B2_950B_7ED3_675F_4E0A_4E0B_6587
    if _____4E0A_4E0B_6587 == nil or _____4E0A_4E0B_6587["施法者"] ~= _____79FB_52A8_5355_4F4D then
        return
    end
    if not _____662F_6709_6548_4F24_5BB3_76EE_6807(_____4E0A_4E0B_6587, _____76EE_6807) then
        return
    end
    if _____5DF2_547D_4E2D_8FC7(_____4E0A_4E0B_6587, _____76EE_6807) then
        return
    end
    _____4E0A_4E0B_6587["已命中"][GetHandleId(_____76EE_6807)] = true
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.Q
    local _____7729_6655_79D2 = _____4E0A_4E0B_6587["十字斩"] and cfg["十字眩晕秒"] or cfg["眩晕秒"]
    _____65BD_52A0_7729_6655(
        _____4E0A_4E0B_6587["施法者"],
        _____76EE_6807,
        _____7729_6655_79D2,
        _____4E0A_4E0B_6587["十字斩"] and "十字斩" or "横一字斩",
        "技能"
    )
end
--- 冲锋命中过滤：冲锋系统已排除自身与死亡单位，这里补类型过滤
local function ____Q_547D_4E2D_8FC7_6EE4(_____79FB_52A8_5355_4F4D, _____76EE_6807)
    local _____4E0A_4E0B_6587 = ____onQ_51B2_950B_7ED3_675F_4E0A_4E0B_6587
    if _____4E0A_4E0B_6587 == nil or _____4E0A_4E0B_6587["施法者"] ~= _____79FB_52A8_5355_4F4D then
        return false
    end
    if not _____662F_6709_6548_4F24_5BB3_76EE_6807(_____4E0A_4E0B_6587, _____76EE_6807) then
        return false
    end
    return not _____5DF2_547D_4E2D_8FC7(_____4E0A_4E0B_6587, _____76EE_6807)
end
local function _____7ED3_7B97Q_843D_70B9(_____4E0A_4E0B_6587)
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.Q
    local _____65BD_6CD5_8005 = _____4E0A_4E0B_6587["施法者"]
    local casterX = GetUnitX(_____65BD_6CD5_8005)
    local casterY = GetUnitY(_____65BD_6CD5_8005)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["冲刺特效模型"],
        X = casterX,
        Y = casterY,
        ["面向角度"] = _____4E0A_4E0B_6587["方向角"],
        ["缩放"] = cfg["冲刺特效缩放X"],
        ["持续秒"] = cfg["冲刺特效持续秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["落点特效模型"],
        X = casterX,
        Y = casterY,
        Z = 0,
        ["缩放"] = cfg["落点特效缩放X"],
        ["持续秒"] = cfg["落点特效持续秒"]
    })
    if _____4E0A_4E0B_6587["十字斩"] then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = cfg["冲刺特效模型"],
            X = casterX + math.cos(_____4E0A_4E0B_6587["方向角"] * math.pi / 180) * 125,
            Y = casterY + math.sin(_____4E0A_4E0B_6587["方向角"] * math.pi / 180) * 125,
            Z = 175,
            ["面向角度"] = _____4E0A_4E0B_6587["方向角"],
            ["缩放"] = cfg["冲刺特效缩放X"],
            ["持续秒"] = cfg["冲刺特效持续秒"]
        })
    end
    local targets = getUnitsInRange(casterX, casterY, _____4E0A_4E0B_6587["命中范围"])
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____662F_6709_6548_4F24_5BB3_76EE_6807(_____4E0A_4E0B_6587, target) then
                    goto __continue26
                end
                if _____5DF2_547D_4E2D_8FC7(_____4E0A_4E0B_6587, target) then
                    goto __continue26
                end
                local _____6307_5411_76EE_6807_89D2_5EA6 = _____4E24_70B9_89D2_5EA6(
                    casterX,
                    casterY,
                    GetUnitX(target),
                    GetUnitY(target)
                )
                if _____89D2_5EA6_5DEE(_____6307_5411_76EE_6807_89D2_5EA6, _____4E0A_4E0B_6587["方向角"]) > _____4E0A_4E0B_6587["扇形半角"] then
                    goto __continue26
                end
                _____7ED3_7B97Q_5355_4F53_4F24_5BB3(_____4E0A_4E0B_6587, target)
            end
            ::__continue26::
            i = i + 1
        end
    end
end
local function ____onQ_51B2_950B_7ED3_675F(caster, reason, ______4F4D_79FBID)
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    if reason ~= "完成" and reason ~= "撞墙" then
        return
    end
    local _____4E0A_4E0B_6587 = ____onQ_51B2_950B_7ED3_675F_4E0A_4E0B_6587
    if _____4E0A_4E0B_6587 == nil or _____4E0A_4E0B_6587["施法者"] ~= caster then
        return
    end
    ____onQ_51B2_950B_7ED3_675F_4E0A_4E0B_6587 = nil
    _____7ED3_7B97Q_843D_70B9(_____4E0A_4E0B_6587)
end
--- 施法硬直来源（硬直暂停系统，可追踪可清理）
local ____Q_65BD_6CD5_786C_76F4_6765_6E90 = "欧尔贝克Q施法硬直"
local function ____on_6B27_5C14_8D1D_514BQ(caster, abilityId)
    if abilityId ~= ____Q_6280_80FDID then
        return
    end
    if not _____5355_4F4D_662F_6307_5B9A_7C7B_578B(caster, _____6B27_5C14_8D1D_514B_5355_4F4D_7C7B_578BID) then
        return
    end
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.Q
    local level = GetUnitAbilityLevel(caster, ____Q_6280_80FDID)
    local startX = GetUnitX(caster)
    local startY = GetUnitY(caster)
    local targetX = GetSpellTargetX()
    local targetY = GetSpellTargetY()
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(startX, startY, targetX, targetY)
    local _____8DDD_79BB = math.sqrt((targetX - startX) * (targetX - startX) + (targetY - startY) * (targetY - startY))
    local _____4F24_5BB3_503C = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (cfg["基础攻击力倍率"] + cfg["每级攻击力倍率"] * level)
    local _____5341_5B57_65A9 = _____5355_4F4D_62E5_6709_539F_751FBuff(caster, _____79EF_6512Buff_7C7B_578BID)
    if _____5341_5B57_65A9 then
        UnitRemoveAbility(caster, _____79EF_6512Buff_7C7B_578BID)
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, _____6B27_5C14_8D1D_514BBuffID["积攒"])
        _____64AD_653E_6B27_5C14_8D1D_514B_5355_4F4D_97F3_6548(caster, cfg["十字全局音效键"])
    else
        _____64AD_653E_6B27_5C14_8D1D_514B_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    end
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, ____Q_65BD_6CD5_786C_76F4_6765_6E90)
    _____64AD_653E_6B27_5C14_8D1D_514B_914D_7F6E_52A8_4F5C(caster, 3, 2)
    addDelayedCallback(
        cfg["施法硬直秒"] * 1000,
        function()
            _____79FB_9664_5355_4F4D_6682_505C(caster, ____Q_65BD_6CD5_786C_76F4_6765_6E90)
            if not _____5355_4F4D_5B58_6D3B(caster) then
                return
            end
            ____onQ_51B2_950B_7ED3_675F_4E0A_4E0B_6587 = {
                ["施法者"] = caster,
                ["起点X"] = startX,
                ["起点Y"] = startY,
                ["方向角"] = _____65B9_5411_89D2,
                ["伤害值"] = _____4F24_5BB3_503C,
                ["十字斩"] = _____5341_5B57_65A9,
                ["命中范围"] = cfg["命中范围"],
                ["扇形半角"] = cfg["扇形半角"],
                ["已命中"] = {}
            }
            _____5F00_59CB_51B2_950B(
                caster,
                {
                    ["角度"] = _____65B9_5411_89D2,
                    ["距离"] = _____8DDD_79BB,
                    ["每秒速度"] = _____51B2_523A_6BCF_79D2_901F_5EA6,
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["朝向跟随位移"] = true,
                    ["动画序号"] = 3,
                    ["开始回调"] = function(_____79FB_52A8_5355_4F4D)
                        _____64AD_653E_6B27_5C14_8D1D_514B_914D_7F6E_52A8_4F5C(_____79FB_52A8_5355_4F4D, 3, 2)
                    end,
                    ["命中半径"] = cfg["命中范围"],
                    ["只命中敌人"] = true,
                    ["允许重复命中"] = false,
                    ["命中伤害"] = _____4F24_5BB3_503C,
                    ["攻击类型"] = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                    ["技能伤害标记"] = {
                        ["来源类型"] = "单位技能",
                        ["技能ID"] = ____Q_6280_80FDID,
                        ["标签"] = _____5341_5B57_65A9 and "欧尔贝克-十字斩" or "欧尔贝克-横一字斩",
                        ["伤害形态"] = "AOE",
                        ["参与技能伤害加成"] = true
                    },
                    ["命中过滤"] = ____Q_547D_4E2D_8FC7_6EE4,
                    ["命中回调"] = ____onQ_8DEF_5F84_547D_4E2D,
                    ["结束回调"] = ____onQ_51B2_950B_7ED3_675F
                }
            )
        end
    )
end
registerSpellEffectListener(____on_6B27_5C14_8D1D_514BQ)
return ____exports
