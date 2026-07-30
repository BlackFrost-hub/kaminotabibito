--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51FB_9000 = _____51FB_9000_7CFB_7EDF["开始击退"]
local ____00_FF0E_51B2_950B_8868_73B0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.00．冲锋表现")
local _____5F00_59CB_96C5_513F_8D1D_5FB7_51B2_950B = ____00_FF0E_51B2_950B_8868_73B0["开始雅儿贝德冲锋"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_1["造成AOE技能伤害"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local getServerTime = ____require_result_2.getServerTime
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local SquareRoot = jass.SquareRoot
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
____exports["释放雅儿贝德守护回归"] = function(context)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    local boss = context["安兹单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    if state["阶段状态"] == "失衡" or state["阶段状态"] == "已离场" then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local now = getServerTime()
    local cooldown = cfg["守护回归冷却秒"] * (state["阶段状态"] == "狂怒护卫" and cfg["守护回归狂怒冷却倍率"] or 1) * 1000
    if now < state["上次守护回归Ms"] + cooldown then
        return false
    end
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    local startX = GetUnitX(albedo)
    local startY = GetUnitY(albedo)
    local fromBossAngle = Atan2(startY - bossY, startX - bossX)
    local endX = bossX + Cos(fromBossAngle) * cfg["守护回归落点距安兹"]
    local endY = bossY + Sin(fromBossAngle) * cfg["守护回归落点距安兹"]
    local dx = endX - startX
    local dy = endY - startY
    local distance = SquareRoot(dx * dx + dy * dy)
    if distance <= 1 then
        return false
    end
    local exclusive = state["独占状态"]
    local token = exclusive and exclusive["开始"](exclusive, {key = "雅儿贝德-守护回归", ["优先级"] = 40, ["持续毫秒"] = (cfg["守护回归预警秒"] + cfg["守护回归冲锋秒"] + 0.5) * 1000, ["可被抢占"] = false}) or 0
    if token == 0 then
        return false
    end
    state["守护连接生效"] = false
    state["上次守护回归Ms"] = now
    local facing = Atan2(dy, dx) * RAD_TO_DEG
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(albedo, facing)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = startX,
        Y = startY,
        ["宽度"] = cfg["守护回归路径宽度"],
        ["长度"] = distance,
        ["朝向"] = facing,
        ["持续时间"] = cfg["守护回归预警秒"],
        ["来源单位"] = albedo
    })
    local delayedId = addDelayedCallback(
        cfg["守护回归预警秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
                if exclusive ~= nil then
                    exclusive["结束"](exclusive, token, "取消", "阶段状态变化")
                end
                return
            end
            local chargeId = _____5F00_59CB_96C5_513F_8D1D_5FB7_51B2_950B(
                albedo,
                {
                    ["目标X"] = endX,
                    ["目标Y"] = endY,
                    ["距离"] = distance,
                    ["持续时间"] = cfg["守护回归冲锋秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["命中半径"] = cfg["守护回归命中半径"],
                    ["只命中敌人"] = true,
                    ["允许重复命中"] = false,
                    ["命中后结束"] = false,
                    ["命中回调"] = function(mover, target)
                        local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(mover, target, {["来源攻击力比例"] = cfg["守护回归伤害攻击力比例"], ["目标最大生命比例"] = cfg["守护回归伤害目标最大生命比例"]})
                        if damage > 0 then
                            _____9020_6210AOE_6280_80FD_4F24_5BB3({
                                ["来源"] = mover,
                                ["目标"] = target,
                                ["伤害"] = damage,
                                attack = false,
                                ranged = false,
                                attackType = ATTACK_TYPE_NORMAL,
                                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                                weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                                ["来源类型"] = "Boss技能",
                                ["标签"] = "雅儿贝德·守护回归"
                            })
                        end
                        _____5F00_59CB_51FB_9000(target, {
                            ["来源单位"] = mover,
                            ["距离"] = cfg["守护回归击退距离"],
                            ["持续时间"] = cfg["守护回归击退秒"],
                            ["检查地形"] = true,
                            ["暂停单位"] = true
                        })
                    end,
                    ["开始回调"] = function()
                        _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(albedo, facing)
                        _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = albedo, ["动画编号"] = cfg["守护回归动画编号"], ["持续秒"] = cfg["守护回归冲锋秒"], ["恢复动画编号"] = 1})
                    end,
                    ["结束回调"] = function()
                        if exclusive ~= nil then
                            exclusive["结束"](exclusive, token, "完成")
                        end
                    end
                }
            )
            if chargeId == 0 then
                if exclusive ~= nil then
                    exclusive["结束"](exclusive, token, "取消", "位移受阻")
                end
            end
        end
    )
    local ____self_13 = context["清理"]
    ____self_13["登记延迟回调"](____self_13, "雅儿贝德-守护回归预警", delayedId)
    return true
end
____exports["守护回归技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = true,
    ["语义"] = "雅儿贝德远离安兹时沿清楚预警路线冲回护卫区，沿途可命中并击退玩家。"
}
return ____exports
