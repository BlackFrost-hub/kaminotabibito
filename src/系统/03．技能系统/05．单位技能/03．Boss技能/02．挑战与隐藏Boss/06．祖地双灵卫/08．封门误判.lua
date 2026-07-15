--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____07_FF0E_53CC_94A5_51C0_5316 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.07．双钥净化")
local _____63A8_8FDB_7956_5730_53CC_7075_536B_4E0B_4E00_4E2A_51C0_5316_8282_70B9 = ____07_FF0E_53CC_94A5_51C0_5316["推进祖地双灵卫下一个净化节点"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local _____80F6_56CA_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.胶囊区域")
local _____5355_4F4D_662F_5426_5728_80F6_56CA_533A_57DF = _____80F6_56CA_533A_57DF["单位是否在胶囊区域"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local AddSpecialEffect = jass.AddSpecialEffect
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local function _____94FA_8BBE_6708_767D_901A_9053(startX, startY, endX, endY, duration)
    local model = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["封门误判"]["月白安全通道特效路径"]
    local segments = 6
    do
        local i = 0
        while i <= segments do
            local t = i / segments
            local effect = AddSpecialEffect(model, startX + (endX - startX) * t, startY + (endY - startY) * t)
            if effect ~= nil and effect ~= 0 then
                YDWETimerDestroyEffectSafe(duration, effect)
            end
            i = i + 1
        end
    end
end
____exports["释放祖地双灵卫封门误判"] = function(context)
    if context["战斗已结束"] or context["阶段"] ~= "P3双蚀共鸣" or not context["封门误判待触发"] or context["已净化节点数量"] <= 0 then
        return false
    end
    local node = context["净化节点列表"][context["已净化节点数量"]]
    if node == nil then
        return false
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3
    local red = context["赤誓灵卫单位"]
    local azure = context["苍影灵卫单位"]
    context["封门误判待触发"] = false
    context["大型技能占用者"] = "联合机制"
    context["大型机制忙碌到Ms"] = getServerTime() + (cfg["封门误判预警秒"] + 0.8) * 1000
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = context["场地中心X"],
        Y = context["场地中心Y"],
        ["半径"] = context["场地半宽"] > context["场地半高"] and context["场地半宽"] or context["场地半高"],
        ["持续时间"] = cfg["封门误判预警秒"],
        ["来源单位"] = azure
    })
    _____94FA_8BBE_6708_767D_901A_9053(
        node.X,
        node.Y,
        context["场地中心X"],
        context["场地中心Y"],
        cfg["封门误判预警秒"] + 0.6
    )
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = red, ["动画编号"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["裂誓下劈"], ["持续秒"] = cfg["封门误判预警秒"] + 0.3, ["恢复动画编号"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["裂誓待机"]})
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = azure, ["动画编号"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["无面施法"], ["持续秒"] = cfg["封门误判预警秒"] + 0.3, ["恢复动画编号"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["动作"]["无面待机"]})
    local delayedId = addDelayedCallback(
        cfg["封门误判预警秒"] * 1000,
        function()
            if not context["战斗已结束"] and context["阶段"] == "P3双蚀共鸣" then
                local impact = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["封门误判"]["封门中心砸击特效路径"], context["场地中心X"], context["场地中心Y"])
                if impact ~= nil and impact ~= 0 then
                    YDWETimerDestroyEffectSafe(1.2, impact)
                end
                local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(red)
                do
                    local i = 0
                    while i < #heroes do
                        do
                            local target = heroes[i + 1]
                            if _____5355_4F4D_662F_5426_5728_80F6_56CA_533A_57DF(
                                target,
                                node.X,
                                node.Y,
                                context["场地中心X"],
                                context["场地中心Y"],
                                cfg["封门误判安全通道半宽"]
                            ) then
                                goto __continue13
                            end
                            local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(red, target, {["来源攻击力比例"] = cfg["封门误判伤害攻击力比例"], ["目标最大生命比例"] = cfg["封门误判目标最大生命比例"]})
                            _____9020_6210AOE_6280_80FD_4F24_5BB3({
                                ["来源"] = red,
                                ["目标"] = target,
                                ["伤害"] = damage,
                                attack = false,
                                ranged = true,
                                attackType = ATTACK_TYPE_NORMAL,
                                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                                weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                                ["来源类型"] = "Boss技能",
                                ["标签"] = "祖地双灵卫·封门误判"
                            })
                        end
                        ::__continue13::
                        i = i + 1
                    end
                end
                context["大型技能占用者"] = nil
                _____63A8_8FDB_7956_5730_53CC_7075_536B_4E0B_4E00_4E2A_51C0_5316_8282_70B9(context)
            end
        end
    )
    local ____self_5 = context["清理"]
    ____self_5["登记延迟回调"](____self_5, "祖地双灵卫-封门误判", delayedId)
    return true
end
____exports["封门误判机制状态"] = {
    ["类型"] = "P3阶段收束技",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "净化节点完成后投射月白安全通道，玩家借通道躲避两名守卫对封门区域的联合误判。",
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = false
}
return ____exports
