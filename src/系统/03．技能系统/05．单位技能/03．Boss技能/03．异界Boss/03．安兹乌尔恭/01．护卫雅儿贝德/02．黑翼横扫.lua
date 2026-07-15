--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local _____6247_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF = _____6247_5F62_533A_57DF["单位是否在扇形区域"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51FB_9000 = _____51FB_9000_7CFB_7EDF["开始击退"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____require_result_0["计算组合技能伤害"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_4["造成AOE技能伤害"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_5.YDWETimerDestroyEffectSafe
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_6.getServerTime
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local EXSetEffectSize = japi.EXSetEffectSize
local EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local RAD_TO_DEG = 57.29577951308232
local function _____64AD_653E_9ED1_7FFC_6A2A_626B_8868_73B0(albedo, facing)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local x = GetUnitX(albedo)
    local y = GetUnitY(albedo)
    local pressure = AddSpecialEffect(cfg["表现资源"]["雅儿贝德黑翼横扫特效路径"], x, y)
    local impact = AddSpecialEffect(cfg["表现资源"]["雅儿贝德重击特效路径"], x, y)
    local effects = {pressure, impact}
    do
        local i = 0
        while i < #effects do
            do
                local effect = effects[i + 1]
                if effect == nil or effect == 0 then
                    goto __continue4
                end
                EXEffectMatRotateZ(effect, facing)
                EXSetEffectSize(effect, cfg["守护者模式"]["黑翼横扫特效缩放"])
                YDWETimerDestroyEffectSafe(cfg["守护者模式"]["黑翼横扫特效持续秒"], effect)
            end
            ::__continue4::
            i = i + 1
        end
    end
end
local function _____7ED3_7B97_9ED1_7FFC_6A2A_626B(context, facing)
    local ____opt_7 = context["雅儿贝德"]
    local albedo = ____opt_7 and ____opt_7["单位"]
    if not _____5355_4F4D_6709_6548(albedo) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local x = GetUnitX(albedo)
    local y = GetUnitY(albedo)
    _____64AD_653E_9ED1_7FFC_6A2A_626B_8868_73B0(albedo, facing)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["安兹单位"])
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF(
                    target,
                    x,
                    y,
                    cfg["黑翼横扫半径"],
                    facing,
                    cfg["黑翼横扫角度"]
                ) then
                    goto __continue9
                end
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = albedo,
                    ["目标"] = target,
                    ["伤害"] = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(albedo, target, {["来源攻击力比例"] = cfg["黑翼横扫伤害攻击力比例"], ["目标最大生命比例"] = cfg["黑翼横扫伤害目标最大生命比例"]}),
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                    ["来源类型"] = "Boss技能",
                    ["标签"] = "雅儿贝德·黑翼横扫"
                })
                _____5F00_59CB_51FB_9000(target, {
                    ["来源单位"] = albedo,
                    ["距离"] = cfg["黑翼横扫击退距离"],
                    ["持续时间"] = cfg["黑翼横扫击退秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["只命中敌人"] = false
                })
            end
            ::__continue9::
            i = i + 1
        end
    end
end
____exports["释放雅儿贝德黑翼横扫"] = function(context, target)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(target) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    if state["阶段状态"] == "失衡" or state["阶段状态"] == "已离场" then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local facing = Atan2(
        GetUnitY(target) - GetUnitY(albedo),
        GetUnitX(target) - GetUnitX(albedo)
    ) * RAD_TO_DEG
    local ____opt_11 = state["独占状态"]
    local token = ____opt_11 and ____opt_11["开始"](____opt_11, {key = "雅儿贝德-黑翼横扫", ["优先级"] = 30, ["持续毫秒"] = (cfg["黑翼横扫预警秒"] + 1) * 1000, ["可被抢占"] = false}) or 0
    if token == 0 then
        return false
    end
    state["守护连接生效"] = false
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(albedo, facing)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "红色扇形",
        X = GetUnitX(albedo),
        Y = GetUnitY(albedo),
        ["半径"] = cfg["黑翼横扫半径"],
        ["扇形角度"] = cfg["黑翼横扫角度"],
        ["朝向"] = facing,
        ["持续时间"] = cfg["黑翼横扫预警秒"],
        ["来源单位"] = albedo
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = albedo,
        ["硬直秒"] = cfg["黑翼横扫预警秒"],
        ["动画编号"] = cfg["黑翼横扫动画编号"],
        ["动画速度"] = cfg["黑翼横扫动画速度"],
        ["恢复动画编号"] = 1,
        ["on生效"] = function()
            _____7ED3_7B97_9ED1_7FFC_6A2A_626B(context, facing)
        end
    })
    state["上次普通技能Ms"] = getServerTime()
    return true
end
____exports["黑翼横扫技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = false,
    ["语义"] = "以宽扇形黑翼风压将玩家推出安兹附近，方向清楚且不覆盖阶段安全区。"
}
return ____exports
