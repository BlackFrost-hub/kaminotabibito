--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____5F00_59CB_7956_5730_53CC_7075_536B_8054_5408_65BD_6CD5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["开始祖地双灵卫联合施法"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____01_FF0E_8A93_950B_58C1_8FDB = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.01．誓锋壁进")
local _____91CA_653E_8A93_950B_58C1_8FDB = ____01_FF0E_8A93_950B_58C1_8FDB["释放誓锋壁进"]
local ____01_FF0E_7075_5370_6298_6B65 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.01．灵印折步")
local _____521B_5EFA_8D64_8A93_9547_9B42_5370 = ____01_FF0E_7075_5370_6298_6B65["创建赤誓镇魂印"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.01．多阶段技能编排.06．技能阶段链执行器")
local _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建立即执行阶段"]
local _____521B_5EFA_5EF6_8FDF_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建延迟阶段"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["点到线段距离平方"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["执行战斗自身传送到坐标"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.12．台词播放")
local _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放苍影灵卫台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local function _____8A93_76FE_662F_5426_963B_6321(context, sourceX, sourceY, target)
    local shield = context["誓盾"]
    if shield == nil or getServerTime() >= shield["到期Ms"] then
        return false
    end
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local totalX = targetX - sourceX
    local totalY = targetY - sourceY
    local total2 = totalX * totalX + totalY * totalY
    if total2 <= 1 then
        return false
    end
    local projection = ((shield.X - sourceX) * totalX + (shield.Y - sourceY) * totalY) / total2
    if projection <= 0 or projection >= 1 then
        return false
    end
    local width = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["誓锋壁进"]["誓盾宽度"]
    return _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
        shield.X,
        shield.Y,
        sourceX,
        sourceY,
        targetX,
        targetY
    ) <= width * width * 0.25
end
____exports["释放祖地双灵卫封门校验"] = function(context, target)
    local red = context["赤誓灵卫单位"]
    local azure = context["苍影灵卫单位"]
    if context["战斗已结束"] or context["阶段"] ~= "P1双灵守门" or context["大型技能占用者"] ~= nil or target == nil or target == 0 then
        return false
    end
    local waveStartX = 0
    local waveStartY = 0
    local waveEndX = 0
    local waveEndY = 0
    local waveReady = false
    local waveWarning = 1
    local executor = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "祖地双灵卫-封门校验", ["清理"] = context["清理"], ["互斥组"] = "祖地双灵卫大型技能"})
    context["大型技能占用者"] = "联合机制"
    context["大型机制忙碌到Ms"] = getServerTime() + 4200
    local executionId = executor["开始"](
        executor,
        {
            key = "封门校验",
            ["单位"] = azure,
            ["上下文"] = context,
            ["最大持续毫秒"] = 5000,
            ["阶段列表"] = {
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        _____91CA_653E_8A93_950B_58C1_8FDB(context, target)
                    end,
                    "苍影誓锋壁进"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(1650, "等待誓盾成形"),
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        local shield = context["誓盾"]
                        if shield == nil then
                            return
                        end
                        local facing = shield["朝向"]
                        waveStartX = _____6781_5750_6807X(shield.X, facing + 180, 420)
                        waveStartY = _____6781_5750_6807Y(shield.Y, facing + 180, 420)
                        waveEndX = _____6781_5750_6807X(shield.X, facing, context["场地半宽"] + 500)
                        waveEndY = _____6781_5750_6807Y(shield.Y, facing, context["场地半宽"] + 500)
                        waveReady = true
                        _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(red, waveStartX, waveStartY)
                        local waveFacing = _____4E24_70B9_89D2_5EA6(waveStartX, waveStartY, waveEndX, waveEndY)
                        _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(red, waveFacing)
                        _____5F00_59CB_7956_5730_53CC_7075_536B_8054_5408_65BD_6CD5(context, waveWarning, "封门校验·灵魂潮", "誓盾成形后，灵魂潮将在读条结束时沿直线结算")
                        _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = red, ["动画编号"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["灵印折步"]["动画编号"], ["持续秒"] = waveWarning + 0.4, ["恢复动画编号"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["赤誓正常待机"]})
                        _____521B_5EFA_6280_80FD_63D0_793A_5708({
                            ["类型"] = "方向直线",
                            X = waveStartX,
                            Y = waveStartY,
                            ["宽度"] = context["场地半高"] * 2,
                            ["长度"] = context["场地半宽"] * 2 + 900,
                            ["朝向"] = waveFacing,
                            ["持续时间"] = waveWarning,
                            ["来源单位"] = red
                        })
                    end,
                    "灵魂潮预警"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(waveWarning * 1000, "等待灵魂潮"),
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        if not waveReady then
                            return
                        end
                        local effect = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["封门校验"]["半场灵魂潮特效路径"], waveStartX, waveStartY)
                        if effect ~= nil and effect ~= 0 then
                            YDWETimerDestroyEffectSafe(1.2, effect)
                        end
                        local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(red)
                        do
                            local i = 0
                            while i < #heroes do
                                do
                                    local hit = heroes[i + 1]
                                    if _____8A93_76FE_662F_5426_963B_6321(context, waveStartX, waveStartY, hit) then
                                        goto __continue15
                                    end
                                    local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(red, hit, {["来源攻击力比例"] = 0.95, ["目标最大生命比例"] = 0.045})
                                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                                        ["来源"] = red,
                                        ["目标"] = hit,
                                        ["伤害"] = damage,
                                        attack = false,
                                        ranged = true,
                                        attackType = ATTACK_TYPE_NORMAL,
                                        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                                        weaponType = WEAPON_TYPE_WHOKNOWS,
                                        ["来源类型"] = "Boss技能",
                                        ["标签"] = "祖地双灵卫·封门校验"
                                    })
                                end
                                ::__continue15::
                                i = i + 1
                            end
                        end
                        _____521B_5EFA_8D64_8A93_9547_9B42_5370(context, waveStartX, waveStartY)
                    end,
                    "灵魂潮结算与留印"
                )
            },
            ["结束回调"] = function()
                if context["大型技能占用者"] == "联合机制" then
                    context["大型技能占用者"] = nil
                end
            end
        }
    )
    if executionId == 0 then
        context["大型技能占用者"] = nil
        return false
    end
    _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD(azure, "封门校验")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["封门校验"],
        GetUnitX(azure),
        GetUnitY(azure),
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    return true
end
____exports["封门校验机制状态"] = {
    ["类型"] = "P1联合组合技",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "苍影灵卫留下有朝向的誓盾，赤誓灵卫随后释放灵魂潮，教授盾可阻挡灵魂能量。",
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = true
}
return ____exports
