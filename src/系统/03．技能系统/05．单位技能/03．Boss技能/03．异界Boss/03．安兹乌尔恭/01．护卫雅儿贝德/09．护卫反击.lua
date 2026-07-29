--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____01_FF0E_53CD_51FB_7A97_53E3_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.01．反击窗口模板")
local _____521B_5EFA_53CD_51FB_7A97_53E3_6A21_677F = ____01_FF0E_53CD_51FB_7A97_53E3_6A21_677F["创建反击窗口模板"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51B2_950B = _____51FB_9000_7CFB_7EDF["开始冲锋"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local getServerTime = ____require_result_1.getServerTime
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local IsUnitEnemy = jass.IsUnitEnemy
local GetOwningPlayer = jass.GetOwningPlayer
local SetUnitFacing = jass.SetUnitFacing
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local SquareRoot = jass.SquareRoot
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local function _____7ED3_7B97_62A4_536B_53CD_51FB(context, attacker, token)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(attacker) or context["挑战已结束"] then
        local ____opt_4 = state and state["独占状态"]
        if ____opt_4 ~= nil then
            ____opt_4["结束"](____opt_4, token, "取消", "反击目标失效")
        end
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local dx = GetUnitX(attacker) - GetUnitX(albedo)
    local dy = GetUnitY(attacker) - GetUnitY(albedo)
    if dx * dx + dy * dy <= cfg["护卫反击攻击距离"] * cfg["护卫反击攻击距离"] then
        local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(albedo, attacker, {["来源攻击力比例"] = cfg["护卫反击伤害攻击力比例"], ["目标最大生命比例"] = cfg["护卫反击伤害目标最大生命比例"]})
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = albedo,
            ["目标"] = attacker,
            ["伤害"] = damage,
            attack = false,
            ranged = false,
            attackType = ATTACK_TYPE_NORMAL,
            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
            ["来源类型"] = "Boss技能",
            ["标签"] = "雅儿贝德·护卫反击"
        })
    end
    local ____opt_8 = state["独占状态"]
    if ____opt_8 ~= nil then
        ____opt_8["结束"](____opt_8, token, "完成")
    end
end
local function _____542F_52A8_62A4_536B_53CD_51FB_52A8_4F5C(context, attacker, token)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(attacker) or context["挑战已结束"] then
        local ____opt_12 = state and state["独占状态"]
        if ____opt_12 ~= nil then
            ____opt_12["结束"](____opt_12, token, "取消", "反击目标失效")
        end
        return
    end
    local guardState = state
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local dx = GetUnitX(attacker) - GetUnitX(albedo)
    local dy = GetUnitY(attacker) - GetUnitY(albedo)
    local distance = SquareRoot(dx * dx + dy * dy)
    local angle = Atan2(dy, dx)
    SetUnitFacing(albedo, angle * RAD_TO_DEG)
    local needMove = distance > cfg["护卫反击攻击距离"]
    local moveDistance = needMove and (distance - cfg["护卫反击攻击距离"] < cfg["护卫反击最大冲锋距离"] and distance - cfg["护卫反击攻击距离"] or cfg["护卫反击最大冲锋距离"]) or 0
    local function _____64AD_653E_53CD_51FB_7838_51FB_5E76_7ED3_7B97()
        _____64AD_653EBoss_5750_6807_97F3_6548(
            _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["雅儿贝德护卫拦截"],
            GetUnitX(albedo),
            GetUnitY(albedo),
            _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
        )
        if not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(attacker) or context["挑战已结束"] then
            local ____opt_16 = guardState["独占状态"]
            if ____opt_16 ~= nil then
                ____opt_16["结束"](____opt_16, token, "取消", "反击目标失效")
            end
            return
        end
        SetUnitFacing(
            albedo,
            Atan2(
                GetUnitY(attacker) - GetUnitY(albedo),
                GetUnitX(attacker) - GetUnitX(albedo)
            ) * RAD_TO_DEG
        )
        _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = albedo, ["动画编号"] = cfg["护卫反击攻击动画编号"], ["持续秒"] = cfg["护卫反击结算延迟秒"] + 0.35, ["恢复动画编号"] = 1})
        local damageId = addDelayedCallback(
            cfg["护卫反击结算延迟秒"] * 1000,
            function()
                _____7ED3_7B97_62A4_536B_53CD_51FB(context, attacker, token)
            end
        )
        local ____self_18 = context["清理"]
        ____self_18["登记延迟回调"](____self_18, "雅儿贝德-护卫反击结算", damageId)
    end
    if moveDistance <= 1 then
        _____64AD_653E_53CD_51FB_7838_51FB_5E76_7ED3_7B97()
        return
    end
    local endX = GetUnitX(albedo) + Cos(angle) * moveDistance
    local endY = GetUnitY(albedo) + Sin(angle) * moveDistance
    local chargeId = _____5F00_59CB_51B2_950B(
        albedo,
        {
            ["目标X"] = endX,
            ["目标Y"] = endY,
            ["距离"] = moveDistance,
            ["持续时间"] = cfg["护卫反击冲锋秒"],
            ["检查地形"] = true,
            ["暂停单位"] = true,
            ["禁用碰撞"] = true,
            ["结束回调"] = function()
                _____64AD_653E_53CD_51FB_7838_51FB_5E76_7ED3_7B97()
            end
        }
    )
    if chargeId == 0 then
        _____64AD_653E_53CD_51FB_7838_51FB_5E76_7ED3_7B97()
    end
end
____exports["释放雅儿贝德护卫反击"] = function(context)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    if state["阶段状态"] == "失衡" or state["阶段状态"] == "已离场" then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local now = getServerTime()
    if now < state["上次护卫反击Ms"] + cfg["护卫反击冷却秒"] * 1000 then
        return false
    end
    local window
    local counterTriggered = false
    local exclusive = state["独占状态"]
    local token = exclusive and exclusive["开始"](
        exclusive,
        {
            key = "雅儿贝德-护卫反击",
            ["优先级"] = 20,
            ["持续毫秒"] = (cfg["护卫反击窗口秒"] + cfg["护卫反击冲锋秒"] + cfg["护卫反击结算延迟秒"] + 1) * 1000,
            ["可被抢占"] = true,
            ["on结束"] = function()
                if window ~= nil then
                    window["取消"](window, "手动取消")
                end
            end
        }
    ) or 0
    if token == 0 then
        return false
    end
    state["守护连接生效"] = false
    state["上次护卫反击Ms"] = now
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = albedo, ["动画编号"] = cfg["护卫反击守势动画编号"], ["持续秒"] = cfg["护卫反击窗口秒"], ["恢复动画编号"] = 1})
    window = _____521B_5EFA_53CD_51FB_7A97_53E3_6A21_677F({
        ["清理"] = context["清理"],
        ["名称"] = "雅儿贝德-护卫反击窗口",
        ["单位"] = albedo,
        ["持续秒"] = cfg["护卫反击窗口秒"],
        ["正面减伤角度"] = cfg["护卫反击正面角度"],
        ["正面伤害倍率"] = cfg["护卫反击承伤倍率"],
        ["修正优先级"] = 45,
        ["触发条件"] = function(damage)
            if not _____5355_4F4D_6709_6548(damage.attacker) or not IsUnitEnemy(
                damage.attacker,
                GetOwningPlayer(albedo)
            ) then
                return false
            end
            if damage.isNormalAttack ~= true and damage.isSkillDamage ~= true and damage.isSkillAttack ~= true then
                return false
            end
            return damage.currentDamage >= GetUnitStateJapi(albedo, UNIT_STATE_MAX_LIFE) * cfg["护卫反击触发伤害最大生命比例"]
        end,
        ["on反击"] = function(damage)
            if counterTriggered then
                return
            end
            counterTriggered = true
            local attacker = damage.attacker
            local triggerId = addDelayedCallback(
                0,
                function()
                    if window ~= nil then
                        window["取消"](window, "手动取消")
                    end
                    _____542F_52A8_62A4_536B_53CD_51FB_52A8_4F5C(context, attacker, token)
                end
            )
            local ____self_27 = context["清理"]
            ____self_27["登记延迟回调"](____self_27, "雅儿贝德-护卫反击启动", triggerId)
        end,
        ["on结束"] = function()
            if not counterTriggered then
                if exclusive ~= nil then
                    exclusive["结束"](exclusive, token, "完成")
                end
            end
        end
    })
    return true
end
____exports["护卫反击技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "单体",
    ["包含战斗自身位移"] = true,
    ["语义"] = "短暂守势只格挡一次来自正面的高额直接伤害，并向原攻击者发动短距离反击。"
}
return ____exports
