--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["开始祖地双灵卫常规施法"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local _____6247_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF = _____6247_5F62_533A_57DF["单位是否在扇形区域"]
local _____77E9_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.矩形区域")
local _____5355_4F4D_662F_5426_5728_6761_5F62_533A_57DF = _____77E9_5F62_533A_57DF["单位是否在条形区域"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.12．台词播放")
local _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放赤誓灵卫台词"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local Atan2 = jass.Atan2
local CosBJ = jass.CosBJ
local SinBJ = jass.SinBJ
local EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local function _____9020_6210_88C2_9B42_5760_65A9_4F24_5BB3(boss, target, attackRatio, maxLifeRatio, label)
    local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, target, {["来源攻击力比例"] = attackRatio, ["目标最大生命比例"] = maxLifeRatio})
    _____9020_6210AOE_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害"] = damage,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "Boss技能",
        ["标签"] = label
    })
end
____exports["释放裂魂坠斩"] = function(context, target)
    local boss = context["赤誓灵卫单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["战斗已结束"] or context["赤誓灵卫形态"] ~= "裂誓战躯" then
        return false
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["裂魂坠斩"]
    _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD(boss, "裂魂坠斩")
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local facing = Atan2(
        GetUnitY(target) - startY,
        GetUnitX(target) - startX
    ) * RAD_TO_DEG
    local endX = startX + CosBJ(facing) * cfg["余震长度"]
    local endY = startY + SinBJ(facing) * cfg["余震长度"]
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, facing)
    _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5(
        boss,
        cfg["前摇秒"],
        "裂魂坠斩",
        "正面扇斩后将沿锁定方向释放直线余震",
        cfg["前摇秒"] + cfg["余震延迟秒"]
    )
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["前摇秒"] + cfg["余震延迟秒"] + 0.2, ["恢复动画编号"] = cfg["恢复动画编号"]})
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "红色扇形",
        X = startX,
        Y = startY,
        ["半径"] = cfg["扇形半径"],
        ["扇形角度"] = cfg["扇形角度"],
        ["朝向"] = facing,
        ["持续时间"] = cfg["前摇秒"],
        ["来源单位"] = boss
    })
    local slashTrail = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["裂魂坠斩"]["重斩拖尾特效路径"], startX, startY)
    if slashTrail ~= nil and slashTrail ~= 0 then
        EXEffectMatRotateZ(slashTrail, facing)
        YDWETimerDestroyEffectSafe(cfg["前摇秒"] + 0.4, slashTrail)
    end
    local _____4E8B_4EF6_5217_8868 = {
        {
            ["时点毫秒"] = cfg["前摇秒"] * 1000,
            ["名称"] = "裂魂坠斩重斩结算",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                    return
                end
                local impact = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["裂魂坠斩"]["扇形落地特效路径"], startX, startY)
                if impact ~= nil and impact ~= 0 then
                    YDWETimerDestroyEffectSafe(0.8, impact)
                end
                local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
                do
                    local i = 0
                    while i < #heroes do
                        do
                            local hit = heroes[i + 1]
                            if not _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF(
                                hit,
                                startX,
                                startY,
                                cfg["扇形半径"],
                                facing,
                                cfg["扇形角度"]
                            ) then
                                goto __continue10
                            end
                            _____9020_6210_88C2_9B42_5760_65A9_4F24_5BB3(
                                boss,
                                hit,
                                cfg["重斩伤害攻击力比例"],
                                cfg["单段目标最大生命比例"],
                                "祖地双灵卫·裂魂坠斩"
                            )
                        end
                        ::__continue10::
                        i = i + 1
                    end
                end
                _____521B_5EFA_6280_80FD_63D0_793A_5708({
                    ["类型"] = "方向直线",
                    X = startX,
                    Y = startY,
                    ["长度"] = cfg["余震长度"],
                    ["宽度"] = cfg["余震宽度"],
                    ["朝向"] = facing,
                    ["持续时间"] = cfg["余震延迟秒"],
                    ["来源单位"] = boss
                })
            end
        },
        {
            ["时点毫秒"] = (cfg["前摇秒"] + cfg["余震延迟秒"]) * 1000,
            ["名称"] = "裂魂坠斩余震结算",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                    return
                end
                local wave = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["裂魂坠斩"]["直线余震特效路径"], startX, startY)
                if wave ~= nil and wave ~= 0 then
                    EXEffectMatRotateZ(wave, facing)
                    YDWETimerDestroyEffectSafe(0.8, wave)
                end
                local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
                do
                    local i = 0
                    while i < #heroes do
                        do
                            local hit = heroes[i + 1]
                            if not _____5355_4F4D_662F_5426_5728_6761_5F62_533A_57DF(
                                hit,
                                startX,
                                startY,
                                endX,
                                endY,
                                cfg["余震宽度"]
                            ) then
                                goto __continue16
                            end
                            _____9020_6210_88C2_9B42_5760_65A9_4F24_5BB3(
                                boss,
                                hit,
                                cfg["余震伤害攻击力比例"],
                                cfg["单段目标最大生命比例"],
                                "祖地双灵卫·裂魂坠斩余震"
                            )
                        end
                        ::__continue16::
                        i = i + 1
                    end
                end
            end
        }
    }
    local executor = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "祖地双灵卫-裂魂坠斩", ["清理"] = context["清理"], ["互斥组"] = "祖地双灵卫主要技能"})
    return executor["开始"](
        executor,
        {
            key = "裂魂坠斩",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = (cfg["前摇秒"] + cfg["余震延迟秒"] + 0.2) * 1000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____4E8B_4EF6_5217_8868)
        }
    ) ~= 0
end
____exports["裂魂坠斩技能状态"] = {
    ["所属形态"] = "裂誓战躯",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = false,
    ["实现要求"] = "锁定方向后先结算短扇形重击，再独立预警并结算同方向直线余震。"
}
return ____exports
