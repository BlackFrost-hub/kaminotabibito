--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_5168_90E8_7C73_4E9A_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部米亚上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_8FD0_884C_65F6_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚运行时配置"]
local ____07_FF0E_7075_732B_5206_8EAB = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.07．灵猫分身")
local _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB = ____07_FF0E_7075_732B_5206_8EAB["触发米亚灵猫分身"]
local ____09_FF0E_6C61_67D3_8109_51B2 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.09．污染脉冲")
local _____91CA_653E_7C73_4E9A_6C61_67D3_8109_51B2 = ____09_FF0E_6C61_67D3_8109_51B2["释放米亚污染脉冲"]
local ____10_FF0E_6C61_6C34_67F1_7206_53D1 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.10．污水柱爆发")
local _____91CA_653E_7C73_4E9A_6C61_6C34_67F1_7206_53D1 = ____10_FF0E_6C61_6C34_67F1_7206_53D1["释放米亚污水柱爆发"]
local ____11_FF0E_8150_5316_8F6C_79FB = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.11．腐化转移")
local _____91CA_653E_7C73_4E9A_8150_5316_8F6C_79FB = ____11_FF0E_8150_5316_8F6C_79FB["释放米亚腐化转移"]
local ____13_FF0E_8150_5316_9ECF_6DB2_6D82_5C42 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.13．腐化黏液涂层")
local _____91CA_653E_7C73_4E9A_5168_573A_8150_5316_9ECF_6DB2 = ____13_FF0E_8150_5316_9ECF_6DB2_6D82_5C42["释放米亚全场腐化黏液"]
local ____14_FF0E_7EC8_6781_6C61_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.14．终极污染")
local _____89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3 = ____14_FF0E_7EC8_6781_6C61_67D3["触发米亚终极污染"]
local ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.13．战斗技能调度模板.01．战斗技能调度模板")
local _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668 = ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F["创建战斗技能调度器"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____7C73_4E9A_6280_80FD_8C03_5EA6_5668
local function _____53D6_7C73_4E9A_4E0A_4E0B_6587_952E(context)
    return _____53D6_5355_4F4DID(context["Boss单位"])
end
local function _____7C73_4E9A_53EF_8C03_5EA6(context)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and not context["终极污染引导中"]
end
local function _____5230_8FBE_751F_547D_9608_503C(context, threshold)
    local maxLife = GetUnitStateJapi(context["Boss单位"], UNIT_STATE_MAX_LIFE)
    return maxLife > 0 and GetUnitState(context["Boss单位"], UNIT_STATE_LIFE) / maxLife <= threshold
end
local function _____662FP1(context)
    return context["阶段"] == 1
end
local function _____662FP2(context)
    return context["阶段"] == 2
end
local function _____662FP3(context)
    return context["阶段"] == 3
end
____exports["注册米亚技能调度"] = function()
    if _____7C73_4E9A_6280_80FD_8C03_5EA6_5668 ~= nil then
        return
    end
    local clone = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["灵猫分身"]
    local pulse = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染脉冲"]
    local geyser = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水柱爆发"]
    local transfer = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化转移"]
    local slime = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化黏液涂层"]
    local ultimate = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["终极污染"]
    _____7C73_4E9A_6280_80FD_8C03_5EA6_5668 = _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "米亚战斗技能调度",
        ["间隔毫秒"] = _____7C73_4E9A_8FD0_884C_65F6_914D_7F6E["推进间隔毫秒"],
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_7C73_4E9A_4E0A_4E0B_6587,
        ["取上下文键"] = _____53D6_7C73_4E9A_4E0A_4E0B_6587_952E,
        ["可调度"] = _____7C73_4E9A_53EF_8C03_5EA6,
        ["自动启动"] = false,
        ["技能列表"] = {
            {
                key = "终极污染30",
                ["冷却毫秒"] = 3600000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = ultimate["引导秒"] * 1000,
                ["优先级"] = 300,
                ["阶段允许"] = _____662FP3,
                ["可释放"] = function(context)
                    return not context["已触发终极污染30"] and _____5230_8FBE_751F_547D_9608_503C(context, ultimate["触发生命比例"][1])
                end,
                ["执行"] = function(context)
                    return _____89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3(context, 0)
                end
            },
            {
                key = "终极污染15",
                ["冷却毫秒"] = 3600000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = ultimate["引导秒"] * 1000,
                ["优先级"] = 290,
                ["阶段允许"] = _____662FP3,
                ["可释放"] = function(context)
                    return not context["已触发终极污染15"] and _____5230_8FBE_751F_547D_9608_503C(context, ultimate["触发生命比例"][2])
                end,
                ["执行"] = function(context)
                    return _____89E6_53D1_7C73_4E9A_7EC8_6781_6C61_67D3(context, 1)
                end
            },
            {
                key = "灵猫分身第一阈值",
                ["冷却毫秒"] = 3600000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = _____7C73_4E9A_8FD0_884C_65F6_914D_7F6E["推进间隔毫秒"],
                ["优先级"] = 200,
                ["阶段允许"] = _____662FP1,
                ["可释放"] = function(context)
                    return not context["已触发分身80"] and _____5230_8FBE_751F_547D_9608_503C(context, clone["触发生命比例"][1])
                end,
                ["执行"] = function(context)
                    if not _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB(context) then
                        return false
                    end
                    context["已触发分身80"] = true
                    return true
                end
            },
            {
                key = "灵猫分身第二阈值",
                ["冷却毫秒"] = 3600000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = _____7C73_4E9A_8FD0_884C_65F6_914D_7F6E["推进间隔毫秒"],
                ["优先级"] = 190,
                ["阶段允许"] = _____662FP1,
                ["可释放"] = function(context)
                    return not context["已触发分身50"] and _____5230_8FBE_751F_547D_9608_503C(context, clone["触发生命比例"][2])
                end,
                ["执行"] = function(context)
                    if not _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB(context) then
                        return false
                    end
                    context["已触发分身50"] = true
                    return true
                end
            },
            {
                key = "污染脉冲",
                ["冷却毫秒"] = pulse["轮次间隔Ms"],
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = 1000,
                ["优先级"] = 30,
                ["阶段允许"] = _____662FP2,
                ["执行"] = function(context)
                    return _____91CA_653E_7C73_4E9A_6C61_67D3_8109_51B2(context)
                end
            },
            {
                key = "腐化转移",
                ["冷却毫秒"] = transfer["冷却Ms"],
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = transfer["预警秒"] * 1000 + transfer["恢复动作延迟Ms"],
                ["优先级"] = 20,
                ["阶段允许"] = _____662FP2,
                ["可释放"] = function(context)
                    return (context["腐化转移污染平台ID"] or "") == ""
                end,
                ["执行"] = function(context, _target, nowMs)
                    return _____91CA_653E_7C73_4E9A_8150_5316_8F6C_79FB(context, nowMs)
                end
            },
            {
                key = "污水柱爆发",
                ["冷却毫秒"] = geyser["冷却Ms"],
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = 1000,
                ["优先级"] = 10,
                ["阶段允许"] = _____662FP2,
                ["执行"] = function(context)
                    return _____91CA_653E_7C73_4E9A_6C61_6C34_67F1_7206_53D1(context)
                end
            },
            {
                key = "全场腐化黏液",
                ["冷却毫秒"] = slime["全场甩黏液间隔Ms"],
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = 500,
                ["优先级"] = 10,
                ["阶段允许"] = _____662FP3,
                ["执行"] = function(context)
                    return _____91CA_653E_7C73_4E9A_5168_573A_8150_5316_9ECF_6DB2(context)
                end
            }
        }
    })
    _____7C73_4E9A_6280_80FD_8C03_5EA6_5668["启动"](_____7C73_4E9A_6280_80FD_8C03_5EA6_5668)
end
return ____exports
