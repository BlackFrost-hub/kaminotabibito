local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置")
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心X"]
local _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y = ____01_FF0E_573A_5730_914D_7F6E["取米亚平台中心Y"]
local _____53D6_7C73_4E9A_5355_4F4D_6240_5728_5B89_5168_57DF = ____01_FF0E_573A_5730_914D_7F6E["取米亚单位所在安全域"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚音效配置"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚")
local _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387 = ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A["取米亚平台超载伤害倍率"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____03_FF0E_5BF9_5916_63A5_53E3["创建原生弹幕"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_0["获取Boss技能敌对英雄列表"]
local ____require_result_1 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761 = ____require_result_1["显示场地常驻AOE吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_1["关闭吟唱条"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_2["创建点特效"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_4["创建独立技能伤害实例"]
local jass = require("jass.common")
local japi = require("jass.japi")
local AddSpecialEffect = jass.AddSpecialEffect
local GetHandleId = jass.GetHandleId
local DestroyEffect = jass.DestroyEffect
local EXSetEffectSize = japi.EXSetEffectSize
local EXSetEffectZ = japi.EXSetEffectZ
local EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____6C61_67D3_8109_51B2_5F39_5E55_98DE_884C_79D2 = 0.5
local _____7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_4E0A_4E0B_6587_8868 = {}
local function _____9500_6BC1_7C73_4E9A_6C61_67D3_8109_51B2_6269_6563_7279_6548(effect)
    if effect == nil or effect == 0 then
        return
    end
    DestroyEffect(effect)
end
local function _____7C73_4E9A_5B89_5168_57DF_5F53_524D_6709_6548(context, _____533A_57DF)
    if _____533A_57DF == nil then
        return false
    end
    local ____533A_57DF__914D_7F6E_ID_5 = _____533A_57DF["配置"].ID
    if ____533A_57DF__914D_7F6E_ID_5 == nil then
        ____533A_57DF__914D_7F6E_ID_5 = _____533A_57DF["配置"]["名称"]
    end
    local ____533A_57DF__914D_7F6E_ID_5_6 = ____533A_57DF__914D_7F6E_ID_5
    if ____533A_57DF__914D_7F6E_ID_5_6 == nil then
        ____533A_57DF__914D_7F6E_ID_5_6 = ""
    end
    local id = ____533A_57DF__914D_7F6E_ID_5_6
    if id ~= "" and context["腐化转移污染平台ID"] == id then
        return false
    end
    if id ~= "" and context["超载平台ID表"][id] == true then
        return false
    end
    return true
end
local function _____5355_4F4D_5728_6709_6548_5B89_5168_57DF_5185(context, unit)
    return _____7C73_4E9A_5B89_5168_57DF_5F53_524D_6709_6548(
        context,
        _____53D6_7C73_4E9A_5355_4F4D_6240_5728_5B89_5168_57DF(unit, context["安全域区域组"])
    )
end
local function _____521B_5EFA_7C73_4E9A_6C61_67D3_8109_51B2_53EF_547D_4E2D_76EE_6807ID_8868(boss)
    local _____76EE_6807ID_8868 = {}
    local _____76EE_6807_5217_8868 = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            do
                local target = _____76EE_6807_5217_8868[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue11
                end
                local targetId = GetHandleId(target)
                if targetId ~= 0 then
                    _____76EE_6807ID_8868[targetId] = true
                end
            end
            ::__continue11::
            i = i + 1
        end
    end
    return _____76EE_6807ID_8868
end
local function _____7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_76EE_6807_7B5B_9009(target, _____5F39_5E55ID)
    local _____5F39_5E55_4E0A_4E0B_6587 = _____7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_4E0A_4E0B_6587_8868[_____5F39_5E55ID]
    if _____5F39_5E55_4E0A_4E0B_6587 == nil or not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local targetId = GetHandleId(target)
    return _____5F39_5E55_4E0A_4E0B_6587["可命中目标ID表"][targetId] == true
end
local function _____7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_547D_4E2D(target, _____5F39_5E55ID)
    local _____5F39_5E55_4E0A_4E0B_6587 = _____7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_4E0A_4E0B_6587_8868[_____5F39_5E55ID]
    if _____5F39_5E55_4E0A_4E0B_6587 == nil or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local targetId = GetHandleId(target)
    if targetId == 0 or _____5F39_5E55_4E0A_4E0B_6587["本波已命中目标ID表"][targetId] == true then
        return
    end
    _____5F39_5E55_4E0A_4E0B_6587["本波已命中目标ID表"][targetId] = true
    local context = _____5F39_5E55_4E0A_4E0B_6587["上下文"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["阶段"] ~= 2 then
        return
    end
    if _____5355_4F4D_5728_6709_6548_5B89_5168_57DF_5185(context, target) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害公式"] = {
            ["目标最大生命比例"] = config["每波最大生命伤害比例"],
            ["总倍率"] = _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387(target)
        },
        attackType = jass.ATTACK_TYPE_NORMAL,
        ["伤害类型"] = jass.DAMAGE_TYPE_POISON,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["技能实例ID"] = _____5F39_5E55_4E0A_4E0B_6587["技能实例ID"],
        ["标签"] = "米亚污染脉冲"
    })
    _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, target, config["每波腐化层数"], "污染脉冲")
end
local function _____6E05_7406_7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_4E0A_4E0B_6587(______539F_56E0, _____5F39_5E55ID)
    __TS__Delete(_____7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_4E0A_4E0B_6587_8868, _____5F39_5E55ID)
end
local function _____663E_793A_6C61_67D3_8109_51B2_6CE2_9884_8B66(context, waveIndex, _____6301_7EED_79D2)
    local boss = context["Boss单位"]
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    local radius = config["波次半径"][waveIndex + 1]
    if not _____5355_4F4D_6709_6548(boss) or radius == nil or radius <= 0 or _____6301_7EED_79D2 <= 0 then
        return
    end
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
        Y = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
        ["半径"] = radius,
        ["持续时间"] = _____6301_7EED_79D2,
        ["来源单位"] = boss
    })
    local _____533A_57DF_5217_8868 = context["安全域区域组"]["区域列表"]
    do
        local i = 0
        while i < #_____533A_57DF_5217_8868 do
            do
                local _____533A_57DF = _____533A_57DF_5217_8868[i + 1]
                if not _____7C73_4E9A_5B89_5168_57DF_5F53_524D_6709_6548(context, _____533A_57DF) then
                    goto __continue25
                end
                local width = _____533A_57DF["配置"]["右"] - _____533A_57DF["配置"]["左"]
                local height = _____533A_57DF["配置"]["上"] - _____533A_57DF["配置"]["下"]
                _____521B_5EFA_6280_80FD_63D0_793A_5708({
                    ["类型"] = "白色安全圆",
                    X = _____533A_57DF["中心X"],
                    Y = _____533A_57DF["中心Y"],
                    ["半径"] = (width < height and width or height) * 0.5,
                    ["持续时间"] = _____6301_7EED_79D2
                })
            end
            ::__continue25::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_671D_5411_70B9_7279_6548(model, x, y, scale, duration, yawDeg, z)
    return _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = model,
        X = x,
        Y = y,
        Z = z,
        ["缩放"] = scale,
        ["Z轴角度"] = yawDeg,
        ["持续秒"] = duration
    })
end
local function _____64AD_653E_8109_51B2_4E2D_5FC3_9884_8B66()
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["中心预警特效"],
        X = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X(),
        Y = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y(),
        Z = 30,
        ["缩放"] = 3,
        ["持续秒"] = config["预警秒"] + 0.2,
        ["红"] = 255,
        ["绿"] = 20,
        ["蓝"] = 20,
        ["透明度"] = 255
    })
end
local function _____64AD_653E_8109_51B2_6CE2_8868_73B0(context, waveIndex, _____6280_80FD_5B9E_4F8BID, _____4E0A_4E00_6CE2_6269_6563_7279_6548)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    local boss = context["Boss单位"]
    local centerX = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X()
    local centerY = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y()
    local _____6CE2_6B21_534A_5F84 = config["波次半径"][waveIndex + 1]
    local _____547D_4E2D_534A_5F84 = config["波次命中半径"][waveIndex + 1]
    local waveNo = waveIndex + 1
    local angles = {0, 90, 180, 270}
    _____9500_6BC1_7C73_4E9A_6C61_67D3_8109_51B2_6269_6563_7279_6548(_____4E0A_4E00_6CE2_6269_6563_7279_6548)
    if not _____5355_4F4D_6709_6548(boss) or _____6CE2_6B21_534A_5F84 == nil or _____6CE2_6B21_534A_5F84 <= 0 or _____547D_4E2D_534A_5F84 == nil or _____547D_4E2D_534A_5F84 <= 0 then
        return nil
    end
    local _____53EF_547D_4E2D_76EE_6807ID_8868 = _____521B_5EFA_7C73_4E9A_6C61_67D3_8109_51B2_53EF_547D_4E2D_76EE_6807ID_8868(boss)
    local _____672C_6CE2_5DF2_547D_4E2D_76EE_6807ID_8868 = {}
    do
        local i = 0
        while i < #angles do
            local _____5F39_5E55 = _____521B_5EFA_539F_751F_5F39_5E55({
                ["所有者"] = boss,
                ["载体模式"] = "单位",
                X = centerX,
                Y = centerY,
                ["方向角"] = angles[i + 1],
                ["速度"] = _____6CE2_6B21_534A_5F84 / _____6C61_67D3_8109_51B2_5F39_5E55_98DE_884C_79D2,
                ["最大距离"] = _____6CE2_6B21_534A_5F84,
                ["生命周期"] = _____6C61_67D3_8109_51B2_5F39_5E55_98DE_884C_79D2,
                ["命中半径"] = _____547D_4E2D_534A_5F84,
                ["影响目标"] = "敌方",
                ["碰撞消失"] = false,
                ["每单位最大命中次数"] = 1,
                ["不可阻挡"] = true,
                ["禁用碰撞"] = true,
                ["显式改向后锁定方向"] = true,
                ["模型"] = config["脉冲中心特效"],
                ["缩放"] = 1,
                ["攻击类型"] = jass.ATTACK_TYPE_NORMAL,
                ["伤害类型"] = jass.DAMAGE_TYPE_POISON,
                ["武器类型"] = jass.WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "Boss技能",
                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                ["技能标签"] = "米亚污染脉冲",
                ["伤害形态"] = "AOE",
                ["目标筛选"] = _____7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_76EE_6807_7B5B_9009,
                ["on命中"] = _____7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_547D_4E2D,
                ["on结束"] = _____6E05_7406_7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_4E0A_4E0B_6587
            })
            _____7C73_4E9A_6C61_67D3_8109_51B2_5F39_5E55_4E0A_4E0B_6587_8868[_____5F39_5E55["弹幕ID"]] = {["上下文"] = context, ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID, ["可命中目标ID表"] = _____53EF_547D_4E2D_76EE_6807ID_8868, ["本波已命中目标ID表"] = _____672C_6CE2_5DF2_547D_4E2D_76EE_6807ID_8868}
            i = i + 1
        end
    end
    local effect = _____521B_5EFA_671D_5411_70B9_7279_6548(
        config["扩散波特效"],
        centerX,
        centerY,
        1.5 * waveNo,
        2,
        270,
        0
    )
    return effect
end
local function _____7ED3_7B97_6C61_67D3_8109_51B2_6CE2(context, waveIndex, _____6280_80FD_5B9E_4F8BID, _____4E0A_4E00_6CE2_6269_6563_7279_6548)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["阶段"] ~= 2 then
        _____9500_6BC1_7C73_4E9A_6C61_67D3_8109_51B2_6269_6563_7279_6548(_____4E0A_4E00_6CE2_6269_6563_7279_6548)
        return nil
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    local centerX = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3X()
    local centerY = _____53D6_7C73_4E9A_5E73_53F0_4E2D_5FC3Y()
    local effect = _____64AD_653E_8109_51B2_6CE2_8868_73B0(context, waveIndex, _____6280_80FD_5B9E_4F8BID, _____4E0A_4E00_6CE2_6269_6563_7279_6548)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____7C73_4E9A_97F3_6548_914D_7F6E["污染脉冲"]["扩散波"], centerX, centerY, _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"])
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污染脉冲", waveIndex + 2)
    return effect
end
local function _____521B_5EFA_6C61_67D3_8109_51B2_65F6_95F4_8F74_4E8B_4EF6(context)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    local boss = context["Boss单位"]
    local _____6280_80FD_5B9E_4F8BID = 0
    local _____4E0A_4E00_6CE2_6269_6563_7279_6548 = nil
    local _____4E8B_4EF6_5217_8868 = {
        {
            ["时点毫秒"] = 0,
            ["名称"] = "污染脉冲开始",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) or context["阶段"] ~= 2 then
                    return
                end
                _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "米亚污染脉冲", ["持续时间秒"] = config["预警秒"] + #config["波次半径"] + 2})
                _____64AD_653E_8109_51B2_4E2D_5FC3_9884_8B66()
                _____663E_793A_6C61_67D3_8109_51B2_6CE2_9884_8B66(context, 0, config["预警秒"])
                _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污染脉冲", 0)
                _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761({
                    ["总时长"] = config["预警秒"],
                    ["颜色ID"] = 3,
                    ["标题文本"] = "污染脉冲",
                    ["提示文本"] = ((("预警" .. tostring(config["预警秒"])) .. "秒后扩散") .. tostring(#config["波次半径"])) .. "波，进入白色安全平台可规避（避开红色扩散区）。"
                })
            end
        },
        {
            ["时点毫秒"] = (config["预警秒"] - 3) * 1000,
            ["名称"] = "污染脉冲三秒提醒",
            ["执行"] = function()
                if _____5355_4F4D_6709_6548(context["Boss单位"]) and context["阶段"] == 2 then
                    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "污染脉冲", 1)
                end
            end
        }
    }
    do
        local i = 0
        while i < #config["波次半径"] do
            local waveIndex = i
            if waveIndex > 0 then
                _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
                    ["时点毫秒"] = (config["预警秒"] + waveIndex - 1) * 1000,
                    ["名称"] = ("污染脉冲第" .. tostring(waveIndex + 1)) .. "波预警",
                    ["执行"] = function()
                        _____663E_793A_6C61_67D3_8109_51B2_6CE2_9884_8B66(context, waveIndex, 1)
                    end
                }
            end
            _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
                ["时点毫秒"] = (config["预警秒"] + waveIndex) * 1000,
                ["名称"] = ("污染脉冲第" .. tostring(waveIndex + 1)) .. "波",
                ["执行"] = function()
                    _____4E0A_4E00_6CE2_6269_6563_7279_6548 = _____7ED3_7B97_6C61_67D3_8109_51B2_6CE2(context, waveIndex, _____6280_80FD_5B9E_4F8BID, _____4E0A_4E00_6CE2_6269_6563_7279_6548)
                end
            }
            i = i + 1
        end
    end
    return _____4E8B_4EF6_5217_8868
end
____exports["释放米亚污染脉冲"] = function(context)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["阶段"] ~= 2 then
        return false
    end
    if context["污染脉冲组合执行器"] == nil then
        context["污染脉冲组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "米亚-污染脉冲", ["清理"] = context["清理"], ["互斥组"] = "米亚场地技能"})
    end
    local ____self_7 = context["污染脉冲组合执行器"]
    local _____6267_884CID = ____self_7["开始"](
        ____self_7,
        {
            key = "污染脉冲",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = (config["预警秒"] + #config["波次半径"]) * 1000 + 500,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____521B_5EFA_6C61_67D3_8109_51B2_65F6_95F4_8F74_4E8B_4EF6(context)),
            ["结束回调"] = function(event)
                if event["原因"] ~= "完成" then
                    _____5173_95ED_541F_5531_6761("场地常驻AOE")
                end
            end
        }
    )
    return _____6267_884CID ~= 0
end
return ____exports
