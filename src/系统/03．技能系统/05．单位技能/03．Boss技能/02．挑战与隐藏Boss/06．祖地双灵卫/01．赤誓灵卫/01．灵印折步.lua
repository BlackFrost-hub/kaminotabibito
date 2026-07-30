--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["开始祖地双灵卫常规施法"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["执行战斗自身传送到坐标"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____01_FF0E_63A7_5236_4E0EBuff["施加快速减速Buff"]
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.03．对外接口")
local _____5F00_59CB_7275_5F15 = ____03_FF0E_5BF9_5916_63A5_53E3["开始牵引"]
local _____533A_57DF_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.04．区域效果.区域效果")
local _____521B_5EFA_533A_57DF_6548_679C = _____533A_57DF_6548_679C["创建区域效果"]
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
local Atan2 = jass.Atan2
local CosBJ = jass.CosBJ
local SinBJ = jass.SinBJ
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local RAD_TO_DEG = 57.29577951308232
local function _____9650_5236_5728_573A_5730_5185(context, x, y)
    local margin = 64
    local minX = context["场地中心X"] - context["场地半宽"] + margin
    local maxX = context["场地中心X"] + context["场地半宽"] - margin
    local minY = context["场地中心Y"] - context["场地半高"] + margin
    local maxY = context["场地中心Y"] + context["场地半高"] - margin
    return {X = x < minX and minX or (x > maxX and maxX or x), Y = y < minY and minY or (y > maxY and maxY or y)}
end
local function _____6E05_9664_65E7_9547_9B42_5370(context)
    local oldSeal = context["镇魂印"]
    if (oldSeal and oldSeal["区域实例"]) ~= nil then
        local ____self_7 = oldSeal["区域实例"]
        ____self_7["销毁"](____self_7)
    end
    context["镇魂印"] = nil
end
local function _____5355_4F4D_5728_5217_8868_4E2D(unit, list)
    do
        local i = 0
        while i < #list do
            if list[i + 1] == unit then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["创建赤誓镇魂印"] = function(context, x, y)
    _____6E05_9664_65E7_9547_9B42_5370(context)
    local boss = context["赤誓灵卫单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
        return
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["灵印折步"]
    local seal = {
        X = x,
        Y = y,
        ["半径"] = cfg["镇魂印半径"],
        ["到期Ms"] = getServerTime() + cfg["镇魂印持续秒"] * 1000
    }
    local area
    area = _____521B_5EFA_533A_57DF_6548_679C({
        X = x,
        Y = y,
        ["半径"] = cfg["镇魂印半径"],
        ["持续时间"] = cfg["镇魂印持续秒"],
        ["检测间隔"] = 0.25,
        ["防抖间隔"] = 0,
        ["影响目标"] = "敌方",
        ["所有者"] = boss,
        ["模型路径"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["灵印折步"]["镇魂印地面特效路径"],
        ["提示圈"] = {["类型"] = "渐变圆形", ["半径"] = cfg["镇魂印半径"], ["持续时间"] = cfg["镇魂印持续秒"], ["来源单位"] = boss},
        ["on周期"] = function(units)
            if context["战斗已结束"] or context["镇魂印"] ~= seal then
                area["销毁"](area)
                return
            end
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            do
                local i = 0
                while i < #units do
                    do
                        local target = units[i + 1]
                        if not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_5728_5217_8868_4E2D(target, heroes) then
                            goto __continue14
                        end
                        _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                            boss,
                            target,
                            0.12,
                            0.12,
                            0.4
                        )
                        _____5F00_59CB_7275_5F15(target, {
                            ["中心X"] = x,
                            ["中心Y"] = y,
                            ["主单位"] = boss,
                            ["主单位死亡时中断"] = true,
                            ["持续时间"] = 0.28,
                            ["每秒速度"] = 80,
                            ["最小距离"] = 72,
                            ["到达距离"] = 72,
                            ["到达后结束"] = true,
                            ["检查地形"] = true,
                            ["禁用碰撞"] = false,
                            ["暂停单位"] = false,
                            ["启用闪电效果"] = false
                        })
                    end
                    ::__continue14::
                    i = i + 1
                end
            end
        end,
        ["on销毁"] = function()
            if context["镇魂印"] == seal then
                context["镇魂印"] = nil
            end
        end
    })
    seal["区域实例"] = area
    context["镇魂印"] = seal
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local radius2 = cfg["镇魂印半径"] * cfg["镇魂印半径"]
    do
        local i = 0
        while i < #heroes do
            do
                local hit = heroes[i + 1]
                local dx = GetUnitX(hit) - x
                local dy = GetUnitY(hit) - y
                if dx * dx + dy * dy > radius2 then
                    goto __continue19
                end
                local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, hit, {["来源攻击力比例"] = cfg["伤害攻击力比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"]})
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = hit,
                    ["伤害"] = damage,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能",
                    ["标签"] = "祖地双灵卫·灵印折步镇魂印"
                })
            end
            ::__continue19::
            i = i + 1
        end
    end
    local ____self_8 = context["清理"]
    ____self_8["登记清理"](
        ____self_8,
        "祖地双灵卫-镇魂印区域",
        function()
            area["销毁"](area)
        end
    )
end
____exports["释放灵印折步"] = function(context, target)
    local boss = context["赤誓灵卫单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["战斗已结束"] or context["赤誓灵卫形态"] ~= "正常" then
        return false
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["灵印折步"]
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local facing = Atan2(
        GetUnitY(target) - startY,
        GetUnitX(target) - startX
    ) * RAD_TO_DEG
    local landing = _____9650_5236_5728_573A_5730_5185(
        context,
        startX + CosBJ(facing) * cfg["位移距离"],
        startY + SinBJ(facing) * cfg["位移距离"]
    )
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, facing)
    _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5(boss, cfg["前摇秒"], "灵印折步", "赤誓灵卫将折步到锁定位置")
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = landing.X,
        Y = landing.Y,
        ["半径"] = cfg["镇魂印半径"],
        ["持续时间"] = cfg["前摇秒"],
        ["来源单位"] = boss
    })
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["前摇秒"] + 0.2, ["恢复动画编号"] = cfg["恢复动画编号"]})
    local vanish = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["灵印折步"]["消失特效路径"], startX, startY)
    if vanish ~= nil and vanish ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["前摇秒"] + 0.4, vanish)
    end
    local delayedId = addDelayedCallback(
        cfg["前摇秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                return
            end
            if not _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(boss, landing.X, landing.Y) then
                return
            end
            ____exports["创建赤誓镇魂印"](context, startX, startY)
            local arrival = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["灵印折步"]["出现特效路径"], landing.X, landing.Y)
            if arrival ~= nil and arrival ~= 0 then
                YDWETimerDestroyEffectSafe(0.8, arrival)
            end
        end
    )
    local ____self_9 = context["清理"]
    ____self_9["登记延迟回调"](____self_9, "祖地双灵卫-灵印折步落地", delayedId)
    return true
end
____exports["灵印折步技能状态"] = {
    ["所属守卫"] = "赤誓灵卫",
    ["所属形态"] = "正常",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = true,
    ["实现要求"] = "瞬移走统一战斗自身传送封装；原位置只保留一个带低伤害脉冲、轻减速与柔和牵引的镇魂印。"
}
return ____exports
