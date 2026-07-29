--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.02．数值与表现配置")
local _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["亚伦柯斯正式设计配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.11．台词播放")
local _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放亚伦柯斯台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____6247_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF = _____6247_5F62_533A_57DF["单位是否在扇形区域"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
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
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local SetUnitFacing = jass.SetUnitFacing
local Atan2 = jass.Atan2
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local RAD_TO_DEG = 57.29577951308232
local _____4EA1_8005_51DD_89C6_6280_80FDKey = "亡者凝视"
____exports["释放亚伦柯斯亡者凝视"] = function(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["战斗已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["亡者凝视"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local facing = Atan2(
        GetUnitY(target) - y,
        GetUnitX(target) - x
    ) * RAD_TO_DEG
    context["当前大型技能"] = _____4EA1_8005_51DD_89C6_6280_80FDKey
    context["普通机制忙碌到Ms"] = getServerTime() + (cfg["前摇秒"] + 0.5) * 1000
    SetUnitFacing(boss, facing)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "扇形",
        X = x,
        Y = y,
        ["半径"] = cfg["半径"],
        ["扇形角度"] = cfg["扇形角度"],
        ["朝向"] = facing,
        ["持续时间"] = cfg["前摇秒"],
        ["来源单位"] = boss
    })
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["前摇秒"] + 0.2, ["恢复动画编号"] = 1})
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(boss, "亡者凝视")
    local delayedId = addDelayedCallback(
        cfg["前摇秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                if context["当前大型技能"] == _____4EA1_8005_51DD_89C6_6280_80FDKey then
                    context["当前大型技能"] = nil
                end
                return
            end
            local effect = AddSpecialEffect(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["亡者凝视特效路径"], x, y)
            _____64AD_653EBoss_5750_6807_97F3_6548(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效"]["亡者凝视"], x, y, _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效默认裁断距离"])
            if effect ~= nil and effect ~= 0 then
                YDWETimerDestroyEffectSafe(0.8, effect)
            end
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            do
                local i = 0
                while i < #heroes do
                    do
                        local hit = heroes[i + 1]
                        if not _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF(
                            hit,
                            x,
                            y,
                            cfg["半径"],
                            facing,
                            cfg["扇形角度"]
                        ) then
                            goto __continue9
                        end
                        local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, hit, {["来源攻击力比例"] = cfg["伤害攻击力比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"]})
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["来源"] = boss,
                            ["目标"] = hit,
                            ["伤害"] = damage,
                            attack = false,
                            ranged = true,
                            attackType = ATTACK_TYPE_NORMAL,
                            ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "Boss技能",
                            ["标签"] = "亚伦柯斯·亡者凝视"
                        })
                        _____5F00_59CB_786C_76F4(hit, cfg["硬直秒"])
                    end
                    ::__continue9::
                    i = i + 1
                end
            end
            if context["当前大型技能"] == _____4EA1_8005_51DD_89C6_6280_80FDKey then
                context["当前大型技能"] = nil
            end
        end
    )
    local ____self_5 = context["清理"]
    ____self_5["登记延迟回调"](____self_5, "亚伦柯斯-亡者凝视", delayedId)
    return true
end
____exports["亡者凝视技能状态"] = {
    ["类型"] = "代码侧周期技能",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = false,
    ["语义"] = "锁定目标朝向后预警正面扇形，结算伤害与短硬直；侧后方始终为安全方向。"
}
return ____exports
