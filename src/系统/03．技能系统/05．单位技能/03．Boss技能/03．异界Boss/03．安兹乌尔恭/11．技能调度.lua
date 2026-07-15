--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____83B7_53D6_5168_90E8_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部安兹运行时上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____07_FF0E_65F6_95F4_505C_6B62 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.07．时间停止")
local _____91CA_653E_5B89_5179_65F6_95F4_505C_6B62 = ____07_FF0E_65F6_95F4_505C_6B62["释放安兹时间停止"]
local ____08_FF0E_9AD8_9636_4EA1_7075_53EC_5524 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.08．高阶亡灵召唤")
local _____91CA_653E_5B89_5179_9AD8_9636_4EA1_7075_53EC_5524 = ____08_FF0E_9AD8_9636_4EA1_7075_53EC_5524["释放安兹高阶亡灵召唤"]
local ____09_FF0E_5929_7A7A_5760_843D = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.09．天空坠落")
local _____91CA_653E_5B89_5179_5929_7A7A_5760_843D = ____09_FF0E_5929_7A7A_5760_843D["释放安兹天空坠落"]
local ____10_FF0E_4E00_5207_751F_547D_7684_7EC8_70B9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.10．一切生命的终点")
local _____91CA_653E_5B89_5179_4E00_5207_751F_547D_7684_7EC8_70B9 = ____10_FF0E_4E00_5207_751F_547D_7684_7EC8_70B9["释放安兹一切生命的终点"]
local ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.13．战斗技能调度模板.01．战斗技能调度模板")
local _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668 = ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F["创建战斗技能调度器"]
local jass = require("jass.common")
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____5B89_5179_6280_80FD_8C03_5EA6_5668
local function _____53D6_5B89_5179_4E0A_4E0B_6587_952E(context)
    return _____53D6_5355_4F4DID(context["安兹单位"])
end
local function _____53EF_8C03_5EA6_5B89_5179_6280_80FD(context)
    local ____temp_1 = _____5355_4F4D_6709_6548(context["安兹单位"]) and not context["挑战已结束"]
    if ____temp_1 then
        local ____self_0 = context["清理"]
        ____temp_1 = not ____self_0["已清理"](____self_0)
    end
    return ____temp_1
end
local function _____521B_5EFA_5B89_5179_6218_6597_6280_80FD_8C03_5EA6_5668()
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    local maximumDurationMs = (cfg["天空坠落施法最大秒"] + cfg["天空坠落回落最大秒"]) * 1000
    local timeStopDurationMs = (cfg["时间停止预展示秒"] + cfg["时间停止冻结秒"] + cfg["时间停止结算间隔秒"] * 2 + cfg["时间停止收尾秒"] + 1) * 1000
    local undeadSummonDurationMs = (cfg["高阶亡灵召唤施法秒"] + cfg["高阶亡灵召唤收尾秒"] + 0.5) * 1000
    local deathEndDurationMs = (cfg["一切生命的终点倒计时秒"] + cfg["一切生命的终点破解输出窗口秒"] + 2) * 1000
    return _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "安兹·乌尔·恭技能调度",
        ["间隔毫秒"] = 100,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587,
        ["取上下文键"] = _____53D6_5B89_5179_4E0A_4E0B_6587_952E,
        ["自动启动"] = false,
        ["可调度"] = _____53EF_8C03_5EA6_5B89_5179_6280_80FD,
        ["技能列表"] = {
            {
                key = "一切生命的终点",
                ["冷却毫秒"] = deathEndDurationMs,
                ["忙碌毫秒"] = deathEndDurationMs,
                ["优先级"] = 120,
                ["互斥组"] = "安兹大型技能",
                ["互斥持续毫秒"] = deathEndDurationMs,
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P3死亡是众生的终点"
                end,
                ["可释放"] = function(context, nowMs)
                    return not context["一切生命的终点已释放"] and context["当前大型技能"] == nil and nowMs >= context["普通机制忙碌到Ms"]
                end,
                ["执行"] = function(context)
                    return _____91CA_653E_5B89_5179_4E00_5207_751F_547D_7684_7EC8_70B9(context)
                end
            },
            {
                key = "天空坠落",
                ["冷却毫秒"] = maximumDurationMs,
                ["忙碌毫秒"] = maximumDurationMs,
                ["优先级"] = 100,
                ["互斥组"] = "安兹大型技能",
                ["互斥持续毫秒"] = maximumDurationMs,
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P2死亡支配者"
                end,
                ["可释放"] = function(context, nowMs)
                    return not context["天空坠落已释放"] and context["当前大型技能"] == nil and nowMs >= context["普通机制忙碌到Ms"]
                end,
                ["执行"] = function(context)
                    return _____91CA_653E_5B89_5179_5929_7A7A_5760_843D(context)
                end
            },
            {
                key = "时间停止",
                ["冷却毫秒"] = cfg["时间停止冷却秒"] * 1000,
                ["忙碌毫秒"] = timeStopDurationMs,
                ["优先级"] = 60,
                ["互斥组"] = "安兹大型技能",
                ["互斥持续毫秒"] = timeStopDurationMs,
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P2死亡支配者"
                end,
                ["可释放"] = function(context, nowMs)
                    return context["天空坠落已释放"] and not context["时间停止中"] and context["当前大型技能"] == nil and nowMs >= context["普通机制忙碌到Ms"] and nowMs >= context["上次大型技能结束Ms"] + cfg["时间停止大型技能后间隔秒"] * 1000
                end,
                ["执行"] = function(context)
                    return _____91CA_653E_5B89_5179_65F6_95F4_505C_6B62(context)
                end
            },
            {
                key = "高阶亡灵召唤",
                ["冷却毫秒"] = cfg["高阶亡灵召唤冷却秒"] * 1000,
                ["忙碌毫秒"] = undeadSummonDurationMs,
                ["优先级"] = 40,
                ["互斥组"] = "安兹大型技能",
                ["互斥持续毫秒"] = undeadSummonDurationMs,
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P2死亡支配者"
                end,
                ["可释放"] = function(context, nowMs)
                    return not _____5355_4F4D_6709_6548(context["高阶亡灵召唤物"]) and context["当前大型技能"] == nil and nowMs >= context["普通机制忙碌到Ms"] and nowMs >= context["上次大型技能结束Ms"] + cfg["高阶亡灵召唤大型技能后间隔秒"] * 1000
                end,
                ["执行"] = function(context)
                    return _____91CA_653E_5B89_5179_9AD8_9636_4EA1_7075_53EC_5524(context)
                end
            }
        }
    })
end
____exports["注册安兹技能调度"] = function()
    if _____5B89_5179_6280_80FD_8C03_5EA6_5668 ~= nil then
        return
    end
    _____5B89_5179_6280_80FD_8C03_5EA6_5668 = _____521B_5EFA_5B89_5179_6218_6597_6280_80FD_8C03_5EA6_5668()
    _____5B89_5179_6280_80FD_8C03_5EA6_5668["启动"](_____5B89_5179_6280_80FD_8C03_5EA6_5668)
end
____exports["安兹技能调度状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["当前覆盖"] = "P2天空坠落、时间停止、高阶亡灵召唤，P3一切生命的终点与普通机制/大型技能互斥",
    ["语义"] = "统一调度阶段大招并保证大招破解窗口不被普通技能覆盖；其余阶段技能后续继续接入同一调度器。"
}
return ____exports
