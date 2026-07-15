--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51B2_950B = _____51FB_9000_7CFB_7EDF["开始冲锋"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____09_FF0E_82F1_7075_6218_4E59_5973 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.09．英灵战乙女")
local _____83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71 = ____09_FF0E_82F1_7075_6218_4E59_5973["获取夏提雅英灵投影"]
local _____5C1D_8BD5_89E6_53D1_82F1_7075_6218_4E59_5973_590D_523B = ____09_FF0E_82F1_7075_6218_4E59_5973["尝试触发英灵战乙女复刻"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_1["造成AOE技能伤害"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local GetRandomReal = jass.GetRandomReal
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____5C1D_8BD5_5B89_6392_6EF4_7BA1_7A7F_5FC3_82F1_7075_590D_523B(context, lockedX, lockedY)
    local projection = _____83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71(context)
    if not _____5355_4F4D_6709_6548(projection) then
        return
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管穿心"]
    local p2 = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local startX = GetUnitX(projection)
    local startY = GetUnitY(projection)
    local dx = lockedX - startX
    local dy = lockedY - startY
    local rawDistance = SquareRoot(dx * dx + dy * dy)
    if not (rawDistance > 1) then
        return
    end
    local distance = rawDistance < cfg["最大距离"] and rawDistance or cfg["最大距离"]
    local ratio = distance / rawDistance
    local endX = startX + dx * ratio
    local endY = startY + dy * ratio
    local facing = Atan2(dy, dx) * RAD_TO_DEG
    local delay = GetRandomReal(p2["英灵复刻延迟最小秒"], p2["英灵复刻延迟最大秒"])
    local started = _____5C1D_8BD5_89E6_53D1_82F1_7075_6218_4E59_5973_590D_523B(
        context,
        "滴管穿心",
        {
            X = startX,
            Y = startY,
            ["朝向"] = facing,
            ["延迟秒"] = delay,
            ["复刻结算"] = function()
                _____5F00_59CB_51B2_950B(
                    projection,
                    {
                        ["目标X"] = endX,
                        ["目标Y"] = endY,
                        ["距离"] = distance,
                        ["持续时间"] = cfg["冲锋秒"],
                        ["检查地形"] = true,
                        ["暂停单位"] = false,
                        ["禁用碰撞"] = true,
                        ["位移特效"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["滴管长枪拖尾特效路径"],
                        ["命中半径"] = cfg["命中半径"],
                        ["只命中敌人"] = true,
                        ["允许重复命中"] = false,
                        ["命中后结束"] = false,
                        ["命中回调"] = function(_source, hit)
                            local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(context["Boss单位"], hit, {["来源攻击力比例"] = cfg["伤害攻击力比例"] * p2["英灵复刻伤害比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"] * p2["英灵复刻伤害比例"]})
                            _____9020_6210AOE_6280_80FD_4F24_5BB3({
                                ["来源"] = context["Boss单位"],
                                ["目标"] = hit,
                                ["伤害"] = damage,
                                attack = false,
                                ranged = false,
                                attackType = ATTACK_TYPE_NORMAL,
                                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                                weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                                ["来源类型"] = "Boss技能",
                                ["标签"] = "夏提雅·英灵复刻-滴管穿心"
                            })
                        end
                    }
                )
            end
        }
    )
    if started then
        _____521B_5EFA_6280_80FD_63D0_793A_5708({
            ["类型"] = "方向直线",
            X = startX,
            Y = startY,
            ["宽度"] = cfg["路径宽度"],
            ["长度"] = distance,
            ["朝向"] = facing,
            ["持续时间"] = delay,
            ["来源单位"] = context["Boss单位"]
        })
    end
end
____exports["释放夏提雅滴管穿心"] = function(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管穿心"]
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local dx = targetX - startX
    local dy = targetY - startY
    local rawDistance = SquareRoot(dx * dx + dy * dy)
    if not (rawDistance > 1) then
        return false
    end
    local distance = rawDistance < cfg["最大距离"] and rawDistance or cfg["最大距离"]
    local ratio = distance / rawDistance
    local endX = startX + dx * ratio
    local endY = startY + dy * ratio
    local facing = Atan2(dy, dx) * RAD_TO_DEG
    context["普通机制忙碌到Ms"] = getServerTime() + (cfg["预警秒"] + cfg["冲锋秒"]) * 1000
    context["当前猎血目标"] = nil
    context["当前猎血段数"] = 0
    context["猎血段数过期时间Ms"] = 0
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = startX,
        Y = startY,
        ["宽度"] = cfg["路径宽度"],
        ["长度"] = distance,
        ["朝向"] = facing,
        ["持续时间"] = cfg["预警秒"],
        ["来源单位"] = boss
    })
    local mainTargetId = GetHandleId(target)
    local delayedId = addDelayedCallback(
        cfg["预警秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
                return
            end
            local chargeId = _____5F00_59CB_51B2_950B(
                boss,
                {
                    ["目标X"] = endX,
                    ["目标Y"] = endY,
                    ["距离"] = distance,
                    ["持续时间"] = cfg["冲锋秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["位移特效"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["滴管长枪拖尾特效路径"],
                    ["命中半径"] = cfg["命中半径"],
                    ["只命中敌人"] = true,
                    ["允许重复命中"] = false,
                    ["命中后结束"] = false,
                    ["命中回调"] = function(source, hit)
                        local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(source, hit, {["来源攻击力比例"] = cfg["伤害攻击力比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"]})
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["来源"] = source,
                            ["目标"] = hit,
                            ["伤害"] = damage,
                            attack = false,
                            ranged = false,
                            attackType = ATTACK_TYPE_NORMAL,
                            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                            weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                            ["来源类型"] = "Boss技能",
                            ["标签"] = "夏提雅·滴管穿心"
                        })
                        local effect = AddSpecialEffect(
                            _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["滴管穿心命中特效路径"],
                            GetUnitX(hit),
                            GetUnitY(hit)
                        )
                        if effect ~= nil and effect ~= 0 then
                            YDWETimerDestroyEffectSafe(cfg["命中特效持续秒"], effect)
                        end
                        if GetHandleId(hit) == mainTargetId then
                            context["当前猎血目标"] = hit
                            context["当前猎血段数"] = 1
                            context["猎血段数过期时间Ms"] = getServerTime() + _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]["连击过期秒"] * 1000
                        end
                    end,
                    ["开始回调"] = function()
                        _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["冲锋秒"], ["恢复动画编号"] = 0})
                    end,
                    ["结束回调"] = function(_source, reason)
                        if reason == "完成" or reason == "撞墙" then
                            _____5C1D_8BD5_5B89_6392_6EF4_7BA1_7A7F_5FC3_82F1_7075_590D_523B(context, targetX, targetY)
                        end
                    end
                }
            )
            if chargeId == 0 then
                context["普通机制忙碌到Ms"] = getServerTime()
            end
        end
    )
    local ____self_4 = context["清理"]
    ____self_4["登记延迟回调"](____self_4, "夏提雅-滴管穿心预警", delayedId)
    return true
end
____exports["滴管穿心技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = true,
    ["语义"] = "锁定目标当前位置并沿预警路径突进；路径每个目标只结算一次，主目标命中后建立猎血第一段。"
}
return ____exports
