--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F4D_79FB_5230_5750_6807 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["执行战斗自身位移到坐标"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
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
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local function _____70B9_5728_5706_5185(x, y, centerX, centerY, radius)
    local dx = x - centerX
    local dy = y - centerY
    return dx * dx + dy * dy <= radius * radius
end
local function _____9650_5236_5728_573A_5730_5185(context, x, y)
    local margin = 64
    local minX = context["场地中心X"] - context["场地半宽"] + margin
    local maxX = context["场地中心X"] + context["场地半宽"] - margin
    local minY = context["场地中心Y"] - context["场地半高"] + margin
    local maxY = context["场地中心Y"] + context["场地半高"] - margin
    return {X = x < minX and minX or (x > maxX and maxX or x), Y = y < minY and minY or (y > maxY and maxY or y)}
end
local function _____8BA1_7B97_8E0F_6B65_843D_70B9(context, fromX, fromY, targetX, targetY)
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["断誓践踏"]
    local dx = targetX - fromX
    local dy = targetY - fromY
    local distance = SquareRoot(dx * dx + dy * dy)
    if distance <= cfg["每步距离"] or distance <= 0.01 then
        return _____9650_5236_5728_573A_5730_5185(context, targetX, targetY)
    end
    return _____9650_5236_5728_573A_5730_5185(context, fromX + dx / distance * cfg["每步距离"], fromY + dy / distance * cfg["每步距离"])
end
local function _____7ED3_7B97_8DF5_8E0F_4F24_5BB3(context, x, y, label)
    local boss = context["赤誓灵卫单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
        return
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["断誓践踏"]
    local impact = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["断誓践踏"]["践踏落地特效路径"], x, y)
    if impact ~= nil and impact ~= 0 then
        YDWETimerDestroyEffectSafe(0.8, impact)
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hit = heroes[i + 1]
                if not _____70B9_5728_5706_5185(
                    GetUnitX(hit),
                    GetUnitY(hit),
                    x,
                    y,
                    cfg["落点半径"]
                ) then
                    goto __continue10
                end
                local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, hit, {["来源攻击力比例"] = cfg["伤害攻击力比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"]})
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = hit,
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
            ::__continue10::
            i = i + 1
        end
    end
end
--- P3 双钥净化调用点：第二落点命中当前破壳节点时，将节点推进到校准阶段。
____exports["尝试以断誓践踏破壳当前净化节点"] = function(context, landingX, landingY)
    if context["当前净化节点序号"] <= 0 then
        return false
    end
    local nodes = context["净化节点列表"]
    do
        local i = 0
        while i < #nodes do
            do
                local node = nodes[i + 1]
                if node["序号"] ~= context["当前净化节点序号"] or node["阶段"] ~= "破壳" then
                    goto __continue15
                end
                local now = getServerTime()
                if now < node["重试允许Ms"] then
                    return false
                end
                if not _____70B9_5728_5706_5185(
                    landingX,
                    landingY,
                    node.X,
                    node.Y,
                    _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["节点判定半径"]
                ) then
                    return false
                end
                node["阶段"] = "校准"
                node["校准截止Ms"] = now + _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["校准阶段窗口秒"] * 1000
                node["重试允许Ms"] = 0
                return true
            end
            ::__continue15::
            i = i + 1
        end
    end
    return false
end
local function _____5C1D_8BD5_7531_8A93_76FE_538B_5236_88C2_8A93_6218_8EAF(context, landingX, landingY)
    local shield = context["誓盾"]
    local boss = context["赤誓灵卫单位"]
    local radius = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["誓锋壁进"]["誓盾宽度"] * 0.5
    if shield == nil or getServerTime() >= shield["到期Ms"] or not _____5355_4F4D_6709_6548(boss) or not _____70B9_5728_5706_5185(
        landingX,
        landingY,
        shield.X,
        shield.Y,
        radius
    ) then
        return false
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["断誓践踏"]
    _____5F00_59CB_786C_76F4(boss, cfg["压制硬直秒"])
    local suppress = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["断誓践踏"]["镇魂压制特效路径"], landingX, landingY)
    if suppress ~= nil and suppress ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["压制硬直秒"], suppress)
    end
    if shield["特效"] ~= nil and shield["特效"] ~= 0 then
        DestroyEffect(shield["特效"])
    end
    context["誓盾"] = nil
    return true
end
____exports["释放断誓践踏"] = function(context, target)
    local boss = context["赤誓灵卫单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["战斗已结束"] or context["赤誓灵卫形态"] ~= "裂誓战躯" then
        return false
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["断誓践踏"]
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local ____temp_5
    if context["阶段"] == "P2侵蚀失衡" and context["首次变异守卫"] == "赤誓灵卫" then
        ____temp_5 = context["誓盾"]
    else
        ____temp_5 = nil
    end
    local activeShield = ____temp_5
    local firstTargetX = activeShield ~= nil and getServerTime() < activeShield["到期Ms"] and activeShield.X or targetX
    local firstTargetY = activeShield ~= nil and getServerTime() < activeShield["到期Ms"] and activeShield.Y or targetY
    local first = _____8BA1_7B97_8E0F_6B65_843D_70B9(
        context,
        GetUnitX(boss),
        GetUnitY(boss),
        firstTargetX,
        firstTargetY
    )
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(
        boss,
        Atan2(
            first.Y - GetUnitY(boss),
            first.X - GetUnitX(boss)
        ) * RAD_TO_DEG
    )
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["第二步预警秒"] + 0.5, ["恢复动画编号"] = cfg["恢复动画编号"]})
    if not _____6267_884C_6218_6597_81EA_8EAB_4F4D_79FB_5230_5750_6807(boss, first.X, first.Y) then
        return false
    end
    _____7ED3_7B97_8DF5_8E0F_4F24_5BB3(context, first.X, first.Y, "祖地双灵卫·断誓践踏一踏")
    local secondTargetX = activeShield ~= nil and getServerTime() < activeShield["到期Ms"] and activeShield.X or targetX
    local secondTargetY = activeShield ~= nil and getServerTime() < activeShield["到期Ms"] and activeShield.Y or targetY
    local second = _____8BA1_7B97_8E0F_6B65_843D_70B9(
        context,
        first.X,
        first.Y,
        secondTargetX,
        secondTargetY
    )
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(
        boss,
        Atan2(second.Y - first.Y, second.X - first.X) * RAD_TO_DEG
    )
    local warningSeconds = cfg["第二步预警秒"] > cfg["两步间隔秒"] and cfg["第二步预警秒"] or cfg["两步间隔秒"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = second.X,
        Y = second.Y,
        ["半径"] = cfg["落点半径"],
        ["持续时间"] = warningSeconds,
        ["来源单位"] = boss
    })
    local delayedId = addDelayedCallback(
        warningSeconds * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                return
            end
            if not _____6267_884C_6218_6597_81EA_8EAB_4F4D_79FB_5230_5750_6807(boss, second.X, second.Y) then
                return
            end
            local hitNode = ____exports["尝试以断誓践踏破壳当前净化节点"](context, second.X, second.Y)
            local suppressed = _____5C1D_8BD5_7531_8A93_76FE_538B_5236_88C2_8A93_6218_8EAF(context, second.X, second.Y)
            if hitNode or suppressed then
                return
            end
            _____7ED3_7B97_8DF5_8E0F_4F24_5BB3(context, second.X, second.Y, "祖地双灵卫·断誓践踏二踏")
            local soulCrack = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["断誓践踏"]["短时魂裂特效路径"], second.X, second.Y)
            if soulCrack ~= nil and soulCrack ~= 0 then
                YDWETimerDestroyEffectSafe(cfg["魂裂持续秒"], soulCrack)
            end
        end
    )
    local ____self_6 = context["清理"]
    ____self_6["登记延迟回调"](____self_6, "祖地双灵卫-断誓践踏第二步", delayedId)
    return true
end
____exports["断誓践踏技能状态"] = {
    ["所属形态"] = "裂誓战躯",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = true,
    ["实现要求"] = "两次短踏步均走战斗自身位移封装；P2命中誓盾时压制自身，P3第二落点可推进当前净化节点到校准阶段。"
}
return ____exports
