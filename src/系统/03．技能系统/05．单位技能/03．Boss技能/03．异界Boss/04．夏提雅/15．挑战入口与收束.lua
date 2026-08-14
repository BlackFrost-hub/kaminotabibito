--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____6E05_7406_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清理夏提雅运行时上下文"]
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.00．配置")
local _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["夏提雅单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____13_FF0E_8840_4E4B_590D_751F = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.13．血之复生")
local _____542F_52A8_590F_63D0_96C5_8840_4E4B_590D_751F = ____13_FF0E_8840_4E4B_590D_751F["启动夏提雅血之复生"]
local ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.09．伤害生命下限保护")
local _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4["创建伤害生命下限保护"]
local ____24_FF0E_975E_6B7B_4EA1Boss_6536_675F_65F6_95F4_7EBF = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.24．非死亡Boss收束时间线")
local _____542F_52A8_975E_6B7B_4EA1Boss_6536_675F_65F6_95F4_7EBF = ____24_FF0E_975E_6B7B_4EA1Boss_6536_675F_65F6_95F4_7EBF["启动非死亡Boss收束时间线"]
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动")
local _____4E3B_52A8_7ED3_675FBoss_6218_8FD0_884C = ____require_result_0["主动结束Boss战运行"]
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6E05_7406Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587 = ____require_result_1["清理Boss自动技能启动上下文"]
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI = ____require_result_2["打开Boss死亡首领奖励UI"]
local ____require_result_3 = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.21．异界_夏提雅战利品")
local _____590F_63D0_96C5_5956_52B1_6C60ID = ____require_result_3["夏提雅奖励池ID"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_5["广播单位提示"]
local ____require_result_6 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____5173_95ED_541F_5531_6761 = ____require_result_6["关闭吟唱条"]
local ____require_result_7 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_7.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ShowUnit = jass.ShowUnit
local AddSpecialEffect = jass.AddSpecialEffect
local _____8840_4E4B_590D_751F_6280_80FDKey = "血之复生"
local _____590F_63D0_96C5_6311_6218_6536_675F_6682_505C_6765_6E90 = "Boss:夏提雅:挑战收束"
____exports["启动夏提雅挑战收束"] = function(context, _____662F_5426_518D_6B21_6218_8D25)
    if _____662F_5426_518D_6B21_6218_8D25 == nil then
        _____662F_5426_518D_6B21_6218_8D25 = false
    end
    local boss = context["Boss单位"]
    if context["挑战已结束"] or not _____5355_4F4D_6709_6548(boss) then
        return false
    end
    context["挑战已结束"] = true
    context["阶段"] = "挑战收束"
    context["当前大型技能"] = nil
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
    _____5173_95ED_541F_5531_6761("大招")
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E
    return _____542F_52A8_975E_6B7B_4EA1Boss_6536_675F_65F6_95F4_7EBF({
        ["名称"] = "夏提雅-挑战收束",
        ["清理"] = context["清理"],
        ["成员"] = {{["单位"] = boss, ["暂停来源"] = _____590F_63D0_96C5_6311_6218_6536_675F_6682_505C_6765_6E90, ["离场动画编号"] = cfg["挑战收束"]["离场动画编号"], ["恢复动画编号"] = 0}},
        ["离场延迟秒"] = cfg["挑战收束"]["离场延迟秒"],
        ["开始回调"] = function()
            local effect = AddSpecialEffect(
                cfg["表现资源"]["挑战结束离场特效路径"],
                GetUnitX(boss),
                GetUnitY(boss)
            )
            if effect ~= nil and effect ~= 0 then
                YDWETimerDestroyEffectSafe(cfg["挑战收束"]["离场特效持续秒"], effect)
            end
            if _____662F_5426_518D_6B21_6218_8D25 then
                _____5E7F_64AD_5355_4F4D_63D0_793A(boss, _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["台词"]["再次战败"][1], 3600)
            end
        end,
        ["结算回调"] = function()
            ShowUnit(boss, false)
            _____4E3B_52A8_7ED3_675FBoss_6218_8FD0_884C(boss, {["跳过死亡音效"] = true, ["跳过死亡剧情"] = true})
            _____6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI(_____590F_63D0_96C5_5956_52B1_6C60ID)
            _____6E05_7406Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587(boss)
            _____6E05_7406_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587(boss)
        end,
        ["延迟登记名"] = "夏提雅-挑战收束离场"
    })
end
local function _____590F_63D0_96C5_590D_751F_5931_8D25_540E_6536_675F(context)
    ____exports["启动夏提雅挑战收束"](context, false)
end
____exports["绑定夏提雅挑战生命下限"] = function(context)
    if context["挑战生命下限保护"] ~= nil then
        return
    end
    context["挑战生命下限保护"] = _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4({
        ["名称"] = "夏提雅-复生与挑战收束锁血",
        ["单位"] = context["Boss单位"],
        ["固定生命下限"] = 1,
        ["修正优先级"] = -100,
        ["清理"] = context["清理"],
        ["过滤伤害"] = function()
            return not context["挑战已结束"] and context["阶段"] ~= "挑战收束" and context["阶段"] ~= "已结束"
        end,
        ["伤害预处理"] = function(_damage, current)
            return context["阶段"] == "复生仪式" and 0 or current
        end,
        ["离开下限后重置触底"] = true,
        ["on首次触底"] = function()
            if not context["已触发复生"] then
                context["已触发复生"] = true
                context["阶段"] = "复生仪式"
                context["当前大型技能"] = _____8840_4E4B_590D_751F_6280_80FDKey
                addDelayedCallback(
                    0,
                    function()
                        if not _____542F_52A8_590F_63D0_96C5_8840_4E4B_590D_751F(context, _____590F_63D0_96C5_590D_751F_5931_8D25_540E_6536_675F) then
                            ____exports["启动夏提雅挑战收束"](context, false)
                        end
                    end
                )
            else
                context["阶段"] = "挑战收束"
                context["当前大型技能"] = nil
                addDelayedCallback(
                    0,
                    function()
                        ____exports["启动夏提雅挑战收束"](context, true)
                    end
                )
            end
        end
    })
end
____exports["夏提雅挑战入口与收束状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "巴尔扎罗斯战败清理后生成血红镜面挑战媒介；结束后夏提雅通过血雾或镜面离场，主线道路不受影响。",
    ["当前覆盖"] = "首次致死进入一次性复生仪式；复生失败或第二次致死后消散离场、主动结束Boss战并打开夏提雅首领奖励。",
    ["场景入口状态"] = "巴尔扎罗斯战后镜面挑战媒介仍需绑定真实场景事件挂点，不在Boss技能目录中猜测事件名。"
}
return ____exports
