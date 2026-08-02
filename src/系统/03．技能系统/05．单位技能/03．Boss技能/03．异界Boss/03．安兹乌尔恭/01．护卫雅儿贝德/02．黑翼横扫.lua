--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local _____6247_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF = _____6247_5F62_533A_57DF["单位是否在扇形区域"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51FB_9000 = _____51FB_9000_7CFB_7EDF["开始击退"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_4.getServerTime
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____8BBE_7F6E_7279_6548_989C_8272 = ____require_result_5["设置特效颜色"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local EXSetEffectSize = japi.EXSetEffectSize
local EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local RAD_TO_DEG = 57.29577951308232
local function _____8BBE_7F6E_9ED1_7FFC_6A2A_626B_7279_6548_8868_73B0(effect, facing, scale, duration)
    if effect == nil or effect == 0 then
        return
    end
    EXEffectMatRotateZ(effect, facing)
    EXSetEffectSize(effect, scale)
    YDWETimerDestroyEffectSafe(duration, effect)
end
local function _____64AD_653E_9ED1_7FFC_6A2A_626B_8868_73B0(albedo, facing, _____91CD_51FBX, _____91CD_51FBY)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local x = GetUnitX(albedo)
    local y = GetUnitY(albedo)
    local pressure = AddSpecialEffect(cfg["表现资源"]["雅儿贝德黑翼横扫特效路径"], x, y)
    local impact = AddSpecialEffect(cfg["表现资源"]["雅儿贝德重击特效路径"], _____91CD_51FBX, _____91CD_51FBY)
    local visual = cfg["守护者模式"]
    _____8BBE_7F6E_7279_6548_989C_8272(pressure, visual["黑翼横扫风压特效红"], visual["黑翼横扫风压特效绿"], visual["黑翼横扫风压特效蓝"])
    _____8BBE_7F6E_9ED1_7FFC_6A2A_626B_7279_6548_8868_73B0(pressure, facing, visual["黑翼横扫风压特效缩放"], visual["黑翼横扫特效持续秒"])
    _____8BBE_7F6E_9ED1_7FFC_6A2A_626B_7279_6548_8868_73B0(impact, facing, visual["雅儿贝德重击特效缩放"], visual["雅儿贝德重击特效持续秒"])
end
local function _____7ED3_7B97_9ED1_7FFC_6A2A_626B(context, facing)
    local ____opt_6 = context["雅儿贝德"]
    local albedo = ____opt_6 and ____opt_6["单位"]
    if not _____5355_4F4D_6709_6548(albedo) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local x = GetUnitX(albedo)
    local y = GetUnitY(albedo)
    local radians = facing / RAD_TO_DEG
    local impactX = x + Cos(radians) * cfg["黑翼横扫半径"]
    local impactY = y + Sin(radians) * cfg["黑翼横扫半径"]
    _____64AD_653E_9ED1_7FFC_6A2A_626B_8868_73B0(albedo, facing, impactX, impactY)
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
                    goto __continue8
                end
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = albedo,
                    ["目标"] = target,
                    ["伤害公式"] = {["来源攻击力比例"] = cfg["黑翼横扫伤害攻击力比例"], ["目标最大生命比例"] = cfg["黑翼横扫伤害目标最大生命比例"]},
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
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
            ::__continue8::
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
    local ____opt_10 = state["独占状态"]
    local token = ____opt_10 and ____opt_10["开始"](____opt_10, {key = "雅儿贝德-黑翼横扫", ["优先级"] = 30, ["持续毫秒"] = (cfg["黑翼横扫预警秒"] + 1) * 1000, ["可被抢占"] = false}) or 0
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
