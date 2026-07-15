--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____83B7_53D6_5168_90E8_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部夏提雅运行时上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____05_FF0E_6EF4_7BA1_7A7F_5FC3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.05．滴管穿心")
local _____91CA_653E_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3 = ____05_FF0E_6EF4_7BA1_7A7F_5FC3["释放夏提雅滴管穿心"]
local ____06_FF0E_8840_6708_8F6E_821E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.06．血月轮舞")
local _____91CA_653E_590F_63D0_96C5_8840_6708_8F6E_821E = ____06_FF0E_8840_6708_8F6E_821E["释放夏提雅血月轮舞"]
local ____07_FF0E_51C0_5316_6295_67AA = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.07．净化投枪")
local _____91CA_653E_590F_63D0_96C5_51C0_5316_6295_67AA = ____07_FF0E_51C0_5316_6295_67AA["释放夏提雅净化投枪"]
local ____08_FF0E_9C9C_8840_56DE_6536 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.08．鲜血回收")
local _____91CA_653E_590F_63D0_96C5_9C9C_8840_56DE_6536 = ____08_FF0E_9C9C_8840_56DE_6536["释放夏提雅鲜血回收"]
local ____09_FF0E_82F1_7075_6218_4E59_5973 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.09．英灵战乙女")
local _____83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71 = ____09_FF0E_82F1_7075_6218_4E59_5973["获取夏提雅英灵投影"]
local _____542F_52A8_590F_63D0_96C5_82F1_7075_6218_4E59_5973_9636_6BB5 = ____09_FF0E_82F1_7075_6218_4E59_5973["启动夏提雅英灵战乙女阶段"]
local ____10_FF0E_955C_50CF_5939_51FB = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.10．镜像夹击")
local _____91CA_653E_590F_63D0_96C5_955C_50CF_5939_51FB = ____10_FF0E_955C_50CF_5939_51FB["释放夏提雅镜像夹击"]
local ____11_FF0E_771F_7956_8840_5BB4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.11．真祖血宴")
local _____91CA_653E_590F_63D0_96C5_771F_7956_8840_5BB4 = ____11_FF0E_771F_7956_8840_5BB4["释放夏提雅真祖血宴"]
local ____12_FF0E_8840_6708_7EC8_821E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.12．血月终舞")
local _____91CA_653E_590F_63D0_96C5_8840_6708_7EC8_821E = ____12_FF0E_8840_6708_7EC8_821E["释放夏提雅血月终舞"]
local ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.13．战斗技能调度模板.01．战斗技能调度模板")
local _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668 = ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F["创建战斗技能调度器"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4 = ____require_result_0["获取Boss技能最近敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_0["获取Boss技能随机敌对英雄"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local GetRandomReal = jass.GetRandomReal
local _____590F_63D0_96C5_8C03_5EA6_5668
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_4E0A_4E0B_6587_952E(context)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and GetHandleId(context["Boss单位"]) or 0
end
local function _____53EF_8C03_5EA6(context, now)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and not context["挑战已结束"] and context["当前大型技能"] == nil and now >= context["普通机制忙碌到Ms"]
end
local function _____9009_62E9_6700_8FD1_76EE_6807(context)
    return _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4(context["Boss单位"])
end
local function _____9009_62E9_6295_67AA_76EE_6807(context)
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(
        context["Boss单位"],
        nil,
        nil,
        nil,
        function(hero)
            return GetHandleId(hero) ~= context["上次净化投枪目标ID"]
        end
    )
    local ____target_2 = target
    if ____target_2 == nil then
        ____target_2 = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(context["Boss单位"])
    end
    return ____target_2
end
local function _____53D6_72C2_70ED_51B7_5374_6BEB_79D2(context, baseSeconds)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]
    local ____self_3 = context["血之狂热控制器"]
    local layers = ____self_3["取层数"](____self_3, context["Boss单位"])
    return baseSeconds * 1000 / (1 + layers * cfg["血之狂热每层技能冷却恢复提高"])
end
local function _____53D6_6EF4_7BA1_7A7F_5FC3_51B7_5374(context)
    return _____53D6_72C2_70ED_51B7_5374_6BEB_79D2(context, _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管穿心"]["冷却秒"])
end
local function _____53D6_8840_6708_8F6E_821E_51B7_5374(context)
    return _____53D6_72C2_70ED_51B7_5374_6BEB_79D2(context, _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血月轮舞"]["冷却秒"])
end
local function _____53D6_51C0_5316_6295_67AA_51B7_5374(context)
    return _____53D6_72C2_70ED_51B7_5374_6BEB_79D2(context, _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["净化投枪"]["冷却秒"])
end
local function _____53D6_9C9C_8840_56DE_6536_51B7_5374(context)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]
    return _____53D6_72C2_70ED_51B7_5374_6BEB_79D2(
        context,
        GetRandomReal(cfg["回收最小周期秒"], cfg["回收最大周期秒"])
    )
end
local function _____53D6_955C_50CF_5939_51FB_51B7_5374(context)
    return _____53D6_72C2_70ED_51B7_5374_6BEB_79D2(context, _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["镜像夹击冷却秒"])
end
local function _____53D6_8840_6708_7EC8_821E_5FD9_788C_6BEB_79D2(context)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3
    local pace = 1 / (1 + context["血宴层数"] * cfg["血宴每层技能节奏提高"])
    return (cfg["扇区预警秒"] * pace * 4 + cfg["终舞冲锋秒"] * pace + cfg["血月终舞回落最大秒"]) * 1000
end
local function _____53D6_51C0_5316_6295_67AA_5FD9_788C_6BEB_79D2(context)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["净化投枪"]
    return (cfg["预警秒"] + (context["阶段"] == "P3真祖血宴" and cfg["P3第二枚投枪延迟秒"] or 0) + 0.4) * 1000
end
local function _____53D6_8840_6708_8F6E_821E_5FD9_788C_6BEB_79D2(context)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血月轮舞"]
    local secondDelay = context["阶段"] == "P3真祖血宴" and cfg["第二段延迟秒"] * cfg["P3第二段延迟倍率"] or cfg["第二段延迟秒"]
    return (cfg["第一段预警秒"] + secondDelay + 0.5) * 1000
end
____exports["注册夏提雅技能调度"] = function()
    if _____590F_63D0_96C5_8C03_5EA6_5668 ~= nil then
        return
    end
    local thrust = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管穿心"]
    _____590F_63D0_96C5_8C03_5EA6_5668 = _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "夏提雅战斗技能调度",
        ["间隔毫秒"] = 100,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587,
        ["取上下文键"] = _____53D6_4E0A_4E0B_6587_952E,
        ["自动启动"] = false,
        ["可调度"] = _____53EF_8C03_5EA6,
        ["技能列表"] = {
            {
                key = "真祖血宴转阶段",
                ["冷却毫秒"] = 3600000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = (_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["转阶段演出秒"] + 0.25) * 1000,
                ["优先级"] = 110,
                ["权重"] = 1,
                ["互斥组"] = "夏提雅普通技能",
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P3真祖血宴"
                end,
                ["可释放"] = function(context)
                    return not context["P3转阶段已处理"]
                end,
                ["执行"] = function(context)
                    return _____91CA_653E_590F_63D0_96C5_771F_7956_8840_5BB4(context)
                end
            },
            {
                key = "血月终舞",
                ["冷却毫秒"] = 3600000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = _____53D6_8840_6708_7EC8_821E_5FD9_788C_6BEB_79D2,
                ["优先级"] = 90,
                ["权重"] = 1,
                ["互斥组"] = "夏提雅普通技能",
                ["选择目标"] = _____9009_62E9_6700_8FD1_76EE_6807,
                ["阶段允许"] = function(context, now)
                    return context["阶段"] == "P3真祖血宴" and context["P3转阶段已处理"] and now >= context["上次阶段变化Ms"] + _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["血月终舞触发延迟秒"] * 1000
                end,
                ["可释放"] = function(context)
                    return not context["血月终舞已释放"]
                end,
                ["执行"] = function(context, target)
                    return _____91CA_653E_590F_63D0_96C5_8840_6708_7EC8_821E(context, target)
                end
            },
            {
                key = "英灵战乙女登场",
                ["冷却毫秒"] = 1000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = 1500,
                ["优先级"] = 100,
                ["权重"] = 1,
                ["互斥组"] = "夏提雅普通技能",
                ["选择目标"] = _____9009_62E9_6700_8FD1_76EE_6807,
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P2英灵战乙女"
                end,
                ["可释放"] = function(context)
                    return _____83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71(context) == nil
                end,
                ["执行"] = function(context, target)
                    return _____542F_52A8_590F_63D0_96C5_82F1_7075_6218_4E59_5973_9636_6BB5(context, target)
                end
            },
            {
                key = "镜像夹击",
                ["冷却毫秒"] = _____53D6_955C_50CF_5939_51FB_51B7_5374,
                ["首次延迟毫秒"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["镜像夹击首次延迟秒"] * 1000,
                ["忙碌毫秒"] = (_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["镜像夹击预警秒"] + _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["镜像夹击第二段延迟秒"] + _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["镜像夹击投影突进秒"] + _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["镜像夹击恢复窗口秒"]) * 1000,
                ["优先级"] = 40,
                ["权重"] = 1,
                ["互斥组"] = "夏提雅普通技能",
                ["选择目标"] = _____9009_62E9_6700_8FD1_76EE_6807,
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P2英灵战乙女"
                end,
                ["执行"] = function(context, target)
                    return _____91CA_653E_590F_63D0_96C5_955C_50CF_5939_51FB(context, target)
                end
            },
            {
                key = "鲜血回收",
                ["冷却毫秒"] = _____53D6_9C9C_8840_56DE_6536_51B7_5374,
                ["首次延迟毫秒"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]["回收最小周期秒"] * 1000,
                ["忙碌毫秒"] = (_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]["回收前摇秒"] + 0.25) * 1000,
                ["优先级"] = 30,
                ["权重"] = 1,
                ["互斥组"] = "夏提雅普通技能",
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P1鲜血女武神" or context["阶段"] == "P2英灵战乙女"
                end,
                ["可释放"] = function(context)
                    return #context["血印句柄列表"] > 0
                end,
                ["执行"] = function(context)
                    return _____91CA_653E_590F_63D0_96C5_9C9C_8840_56DE_6536(context)
                end
            },
            {
                key = "净化投枪",
                ["冷却毫秒"] = _____53D6_51C0_5316_6295_67AA_51B7_5374,
                ["首次延迟毫秒"] = 5000,
                ["忙碌毫秒"] = _____53D6_51C0_5316_6295_67AA_5FD9_788C_6BEB_79D2,
                ["优先级"] = 20,
                ["权重"] = 1,
                ["互斥组"] = "夏提雅普通技能",
                ["选择目标"] = _____9009_62E9_6295_67AA_76EE_6807,
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P1鲜血女武神" or context["阶段"] == "P2英灵战乙女" or context["阶段"] == "P3真祖血宴"
                end,
                ["执行"] = function(context, target)
                    return _____91CA_653E_590F_63D0_96C5_51C0_5316_6295_67AA(context, target)
                end
            },
            {
                key = "血月轮舞",
                ["冷却毫秒"] = _____53D6_8840_6708_8F6E_821E_51B7_5374,
                ["首次延迟毫秒"] = 6500,
                ["忙碌毫秒"] = _____53D6_8840_6708_8F6E_821E_5FD9_788C_6BEB_79D2,
                ["优先级"] = 20,
                ["权重"] = 1,
                ["互斥组"] = "夏提雅普通技能",
                ["选择目标"] = _____9009_62E9_6700_8FD1_76EE_6807,
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P1鲜血女武神" or context["阶段"] == "P2英灵战乙女" or context["阶段"] == "P3真祖血宴"
                end,
                ["执行"] = function(context, target)
                    return _____91CA_653E_590F_63D0_96C5_8840_6708_8F6E_821E(context, target)
                end
            },
            {
                key = "滴管穿心",
                ["冷却毫秒"] = _____53D6_6EF4_7BA1_7A7F_5FC3_51B7_5374,
                ["首次延迟毫秒"] = 3500,
                ["忙碌毫秒"] = (thrust["预警秒"] + thrust["冲锋秒"] + 0.4) * 1000,
                ["优先级"] = 20,
                ["权重"] = 1,
                ["互斥组"] = "夏提雅普通技能",
                ["选择目标"] = _____9009_62E9_6700_8FD1_76EE_6807,
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P1鲜血女武神" or context["阶段"] == "P2英灵战乙女" or context["阶段"] == "P3真祖血宴"
                end,
                ["执行"] = function(context, target)
                    return _____91CA_653E_590F_63D0_96C5_6EF4_7BA1_7A7F_5FC3(context, target)
                end
            }
        },
        ["成功后"] = function(context)
            context["普通机制忙碌到Ms"] = getServerTime() + 1800
        end
    })
    _____590F_63D0_96C5_8C03_5EA6_5668["启动"](_____590F_63D0_96C5_8C03_5EA6_5668)
end
____exports["夏提雅技能调度状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["当前覆盖"] = "滴管穿心、血月轮舞、净化投枪、鲜血回收、P2英灵登场与镜像夹击；统一冷却、目标选择、普通技能互斥与普攻窗口",
    ["语义"] = "在技能间隔中保留长枪普攻窗口，并让回收、镜像、血月终舞与复生仪式保持互斥。"
}
return ____exports
