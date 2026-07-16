--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____6E05_7406_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清理安兹运行时上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.09．伤害生命下限保护")
local _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4["创建伤害生命下限保护"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．台词播放")
local _____64AD_653E_5B89_5179_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放安兹台词"]
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动")
local _____4E3B_52A8_7ED3_675FBoss_6218_8FD0_884C = ____require_result_0["主动结束Boss战运行"]
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6E05_7406Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587 = ____require_result_1["清理Boss自动技能启动上下文"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local ShowUnit = jass.ShowUnit
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local function _____64AD_653E_6311_6218_7ED3_675F_95E8_6249(x, y)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local paths = {cfg["表现资源"]["挑战结束传送门框路径"], cfg["表现资源"]["挑战结束传送核心路径"], cfg["表现资源"]["挑战结束传送旋涡路径"]}
    do
        local i = 0
        while i < #paths do
            local effect = AddSpecialEffect(paths[i + 1], x, y)
            if effect ~= nil and effect ~= 0 then
                YDWETimerDestroyEffectSafe(cfg["守护者模式"]["挑战收束门扉持续秒"], effect)
            end
            i = i + 1
        end
    end
end
____exports["启动安兹挑战收束"] = function(context)
    local boss = context["安兹单位"]
    local ____opt_4 = context["雅儿贝德"]
    local albedo = ____opt_4 and ____opt_4["单位"]
    if context["挑战已结束"] or not _____5355_4F4D_6709_6548(boss) then
        return false
    end
    context["挑战已结束"] = true
    context["阶段"] = "挑战收束"
    context["当前大型技能"] = nil
    SetUnitInvulnerable(boss, true)
    PauseUnit(boss, true)
    if _____5355_4F4D_6709_6548(albedo) then
        SetUnitInvulnerable(albedo, true)
        PauseUnit(albedo, true)
        if context["雅儿贝德"] ~= nil then
            context["雅儿贝德"]["阶段状态"] = "终局拦截"
        end
    end
    local ____opt_8 = context["雅儿贝德"]
    local ____opt_6 = ____opt_8 and ____opt_8["独占状态"]
    if ____opt_6 ~= nil then
        ____opt_6["取消当前"](____opt_6, "清理", "安兹挑战收束")
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["守护者模式"]["挑战收束安兹姿势动画编号"], ["持续秒"] = cfg["守护者模式"]["挑战收束离场延迟秒"], ["恢复动画编号"] = 0})
    if _____5355_4F4D_6709_6548(albedo) then
        _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = albedo, ["动画编号"] = cfg["守护者模式"]["挑战收束雅儿贝德姿势动画编号"], ["持续秒"] = cfg["守护者模式"]["挑战收束离场延迟秒"], ["恢复动画编号"] = 1})
    end
    _____64AD_653E_6311_6218_7ED3_675F_95E8_6249(
        GetUnitX(boss),
        GetUnitY(boss)
    )
    _____64AD_653E_5B89_5179_53F0_8BCD(boss, "挑战结束")
    local delayedId = addDelayedCallback(
        cfg["守护者模式"]["挑战收束离场延迟秒"] * 1000,
        function()
            local ____opt_12 = context["雅儿贝德"]
            local ____opt_10 = ____opt_12 and ____opt_12["成员生命周期"]
            if ____opt_10 ~= nil then
                ____opt_10["设置状态"](____opt_10, "雅儿贝德", "离场", "服从至尊命令")
            end
            local ____opt_16 = context["雅儿贝德"]
            local ____opt_14 = ____opt_16 and ____opt_16["成员生命周期"]
            if ____opt_14 ~= nil then
                ____opt_14["设置状态"](____opt_14, "安兹", "离场", "试炼结束")
            end
            if _____5355_4F4D_6709_6548(albedo) then
                ShowUnit(albedo, false)
            end
            ShowUnit(boss, false)
            _____4E3B_52A8_7ED3_675FBoss_6218_8FD0_884C(boss, {["跳过死亡音效"] = true, ["跳过死亡剧情"] = true})
            _____6E05_7406Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587(boss)
            _____6E05_7406_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587(boss)
        end
    )
    local ____self_18 = context["清理"]
    ____self_18["登记延迟回调"](____self_18, "安兹-挑战收束离场", delayedId)
    return true
end
____exports["绑定安兹挑战生命下限"] = function(context)
    if context["挑战生命下限保护"] ~= nil then
        return
    end
    context["挑战生命下限保护"] = _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4({
        ["名称"] = "安兹-挑战收束锁血",
        ["单位"] = context["安兹单位"],
        ["固定生命下限"] = 1,
        ["修正优先级"] = -100,
        ["清理"] = context["清理"],
        ["过滤伤害"] = function()
            return not context["挑战已结束"] and context["阶段"] ~= "挑战收束" and context["阶段"] ~= "已结束"
        end,
        ["on首次触底"] = function()
            if context["挑战已结束"] or context["阶段"] == "挑战收束" then
                return
            end
            context["阶段"] = "挑战收束"
            addDelayedCallback(
                0,
                function()
                    ____exports["启动安兹挑战收束"](context)
                end
            )
        end
    })
end
____exports["安兹挑战入口与收束状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "亚伦柯斯战败归静并完成清理后生成挑战媒介；安兹归零时锁血、宣布试炼结束并通过黑金门离开。",
    ["实现要求"] = "该入口最终接剧情或异界挑战系统，不在普通技能文件中直接注册Boss死亡事件。"
}
return ____exports
