--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.纯跳链系统")
local _____5F00_59CB_7EAF_8DF3_94FE = ____require_result_0["开始纯跳链"]
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.00．常量定义")
local DEFAULT_HEAL_EFFECT_PATH = ____require_result_1.DEFAULT_HEAL_EFFECT_PATH
local _____9ED8_8BA4_6CBB_7597_6CE2_7279_6548 = DEFAULT_HEAL_EFFECT_PATH
local _____9ED8_8BA4_6CBB_7597_6CE2_95EA_7535_4EE3_7801 = "HWPB"
local _____9ED8_8BA4_6BCF_8DF3_6700_5927_8DDD_79BB = 600
local _____9ED8_8BA4_8DF3_8DC3_95F4_9694 = 0.1
local _____9ED8_8BA4_6700_5927_8DF3_6570 = 7
____exports["发起治疗波跳链"] = function(_____53C2_6570)
    local _____6CBB_7597_7279_6548 = _____53C2_6570["治疗特效路径"] or _____9ED8_8BA4_6CBB_7597_6CE2_7279_6548
    local _____6BCF_8DF3_56DE_8C03Wrapper
    if _____53C2_6570["每跳回调"] ~= nil then
        local _____6BCF_8DF3_56DE_8C03 = _____53C2_6570["每跳回调"]
        _____6BCF_8DF3_56DE_8C03Wrapper = function(_____5355_4F4D, _____6570_503C, _____5F53_524D_8DF3_6570, _____8DF3_94FEID)
            _____6BCF_8DF3_56DE_8C03(_____5355_4F4D, _____6570_503C, _____5F53_524D_8DF3_6570)
        end
    end
    local _____7ED3_675F_56DE_8C03Wrapper
    if _____53C2_6570["结束回调"] ~= nil then
        local _____7ED3_675F_56DE_8C03 = _____53C2_6570["结束回调"]
        _____7ED3_675F_56DE_8C03Wrapper = function(_____539F_56E0, _____5DF2_5B8C_6210_8DF3_6570, _____8DF3_94FEID)
            _____7ED3_675F_56DE_8C03(_____5DF2_5B8C_6210_8DF3_6570)
        end
    end
    local _____8DF3_94FE_53C2_6570 = {
        ["起始目标"] = _____53C2_6570["起始目标"],
        ["来源单位"] = _____53C2_6570["来源单位"],
        ["模式"] = "治疗",
        ["影响目标"] = _____53C2_6570["影响目标"] or "友方",
        ["最大跳数"] = _____53C2_6570["最大跳数"] or _____9ED8_8BA4_6700_5927_8DF3_6570,
        ["每跳最大距离"] = _____53C2_6570["每跳最大距离"] or _____9ED8_8BA4_6BCF_8DF3_6700_5927_8DDD_79BB,
        ["初始数值"] = _____53C2_6570["初始治疗量"],
        ["每跳衰减系数"] = _____53C2_6570["每跳衰减系数"] or 0,
        ["允许重复命中"] = _____53C2_6570["允许重复治疗"],
        ["跳跃间隔"] = _____53C2_6570["跳跃间隔"] or _____9ED8_8BA4_8DF3_8DC3_95F4_9694,
        ["闪电效果代码"] = _____53C2_6570["闪电效果代码"] or _____9ED8_8BA4_6CBB_7597_6CE2_95EA_7535_4EE3_7801,
        ["闪电持续时间"] = nil,
        ["治疗特效路径"] = _____6CBB_7597_7279_6548,
        ["目标筛选"] = _____53C2_6570["目标筛选"],
        ["每跳回调"] = _____6BCF_8DF3_56DE_8C03Wrapper,
        ["结束回调"] = _____7ED3_675F_56DE_8C03Wrapper
    }
    return _____5F00_59CB_7EAF_8DF3_94FE(_____8DF3_94FE_53C2_6570)
end
return ____exports
