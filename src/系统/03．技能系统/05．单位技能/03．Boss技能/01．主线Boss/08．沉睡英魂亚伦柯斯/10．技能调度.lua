--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.01．运行时上下文")
local _____83B7_53D6_5168_90E8_4E9A_4F26_67EF_65AF_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部亚伦柯斯运行时上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.02．数值与表现配置")
local _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["亚伦柯斯正式设计配置"]
local ____03_FF0E_4EA1_51A5_82F1_65A9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.03．亡冥英斩")
local _____91CA_653E_4E9A_4F26_67EF_65AF_4EA1_51A5_82F1_65A9 = ____03_FF0E_4EA1_51A5_82F1_65A9["释放亚伦柯斯亡冥英斩"]
local ____04_FF0E_82F1_7075_9668_661F = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.04．英灵陨星")
local _____91CA_653E_4E9A_4F26_67EF_65AF_82F1_7075_9668_661F = ____04_FF0E_82F1_7075_9668_661F["释放亚伦柯斯英灵陨星"]
local ____07_FF0E_4EA1_8005_51DD_89C6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.07．亡者凝视")
local _____91CA_653E_4E9A_4F26_67EF_65AF_4EA1_8005_51DD_89C6 = ____07_FF0E_4EA1_8005_51DD_89C6["释放亚伦柯斯亡者凝视"]
local ____08_FF0E_65E7_8A93_5893_7891 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.08．旧誓墓碑")
local _____542F_52A8_4E9A_4F26_67EF_65AF_65E7_8A93_5893_7891 = ____08_FF0E_65E7_8A93_5893_7891["启动亚伦柯斯旧誓墓碑"]
local ____09_FF0E_4E0D_706D_519B_9B42 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.09．不灭军魂")
local _____542F_7528_4E9A_4F26_67EF_65AF_4E0D_706D_519B_9B42 = ____09_FF0E_4E0D_706D_519B_9B42["启用亚伦柯斯不灭军魂"]
local _____89E6_53D1_4E9A_4F26_67EF_65AF_6700_7EC8_5F3A_5316 = ____09_FF0E_4E0D_706D_519B_9B42["触发亚伦柯斯最终强化"]
local ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.13．战斗技能调度模板.01．战斗技能调度模板")
local _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668 = ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F["创建战斗技能调度器"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4 = ____require_result_0["获取Boss技能最近敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_0["获取Boss技能随机敌对英雄"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____4E9A_4F26_67EF_65AF_8C03_5EA6_5668
local function _____53D6_4E0A_4E0B_6587_952E(context)
    return _____53D6_5355_4F4DID(context["Boss单位"])
end
local function _____53EF_8C03_5EA6(context, now)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and not context["战斗已结束"] and context["当前大型技能"] == nil and now >= context["普通机制忙碌到Ms"]
end
local function _____9009_62E9_6700_8FD1_76EE_6807(context)
    return _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4(context["Boss单位"])
end
local function _____9009_62E9_968F_673A_76EE_6807(context)
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(context["Boss单位"])
end
local function _____53D6_9636_6BB5_51B7_5374_6BEB_79D2(context, baseSeconds)
    local multiplier = context["阶段"] == "P3最后的誓约" and 1 - _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["不灭军魂"]["P3技能间隔缩短比例"] or 1
    return baseSeconds * multiplier * 1000
end
local function _____53D6_4EA1_51A5_82F1_65A9_51B7_5374(context)
    return _____53D6_9636_6BB5_51B7_5374_6BEB_79D2(context, _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["亡冥英斩"]["冷却秒"])
end
local function _____53D6_82F1_7075_9668_661F_51B7_5374(context)
    return _____53D6_9636_6BB5_51B7_5374_6BEB_79D2(context, _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["英灵陨星"]["冷却秒"])
end
local function _____53D6_4EA1_8005_51DD_89C6_51B7_5374(context)
    return _____53D6_9636_6BB5_51B7_5374_6BEB_79D2(context, _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["亡者凝视"]["冷却秒"])
end
local function _____5230_8FBE_6700_7EC8_5F3A_5316_9608_503C(context)
    local maxLife = GetUnitState(context["Boss单位"], UNIT_STATE_MAX_LIFE)
    return maxLife > 0 and GetUnitState(context["Boss单位"], UNIT_STATE_LIFE) / maxLife <= _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["阶段阈值"]["最终强化生命比例"]
end
____exports["注册亚伦柯斯技能调度"] = function()
    if _____4E9A_4F26_67EF_65AF_8C03_5EA6_5668 ~= nil then
        return
    end
    local slash = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["亡冥英斩"]
    local meteor = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["英灵陨星"]
    local gaze = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["亡者凝视"]
    _____4E9A_4F26_67EF_65AF_8C03_5EA6_5668 = _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "亚伦柯斯战斗技能调度",
        ["间隔毫秒"] = 100,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_4E9A_4F26_67EF_65AF_8FD0_884C_65F6_4E0A_4E0B_6587,
        ["取上下文键"] = _____53D6_4E0A_4E0B_6587_952E,
        ["自动启动"] = false,
        ["可调度"] = _____53EF_8C03_5EA6,
        ["技能列表"] = {
            {
                key = "旧誓墓碑启动",
                ["冷却毫秒"] = 3600000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = 400,
                ["优先级"] = 120,
                ["权重"] = 1,
                ["互斥组"] = "亚伦柯斯主要机制",
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P2旧誓回响"
                end,
                ["可释放"] = function(context)
                    return not context["墓碑机制已启动"]
                end,
                ["执行"] = function(context)
                    return _____542F_52A8_4E9A_4F26_67EF_65AF_65E7_8A93_5893_7891(context)
                end
            },
            {
                key = "不灭军魂启动",
                ["冷却毫秒"] = 3600000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = 300,
                ["优先级"] = 115,
                ["权重"] = 1,
                ["互斥组"] = "亚伦柯斯主要机制",
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P3最后的誓约"
                end,
                ["可释放"] = function(context)
                    return not context["不灭军魂已启用"]
                end,
                ["执行"] = function(context)
                    return _____542F_7528_4E9A_4F26_67EF_65AF_4E0D_706D_519B_9B42(context)
                end
            },
            {
                key = "最终强化",
                ["冷却毫秒"] = 3600000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = 1200,
                ["优先级"] = 110,
                ["权重"] = 1,
                ["互斥组"] = "亚伦柯斯主要机制",
                ["阶段允许"] = function(context)
                    return context["阶段"] == "P3最后的誓约"
                end,
                ["可释放"] = function(context)
                    return not context["已触发最终强化"] and _____5230_8FBE_6700_7EC8_5F3A_5316_9608_503C(context)
                end,
                ["执行"] = function(context)
                    return _____89E6_53D1_4E9A_4F26_67EF_65AF_6700_7EC8_5F3A_5316(context)
                end
            },
            {
                key = "英灵陨星",
                ["冷却毫秒"] = _____53D6_82F1_7075_9668_661F_51B7_5374,
                ["首次延迟毫秒"] = 5200,
                ["忙碌毫秒"] = (meteor["预警秒"] + meteor["P2落点数量"] * meteor["落点间隔秒"] + 0.5) * 1000,
                ["优先级"] = 25,
                ["权重"] = 1,
                ["互斥组"] = "亚伦柯斯主要机制",
                ["执行"] = function(context)
                    return _____91CA_653E_4E9A_4F26_67EF_65AF_82F1_7075_9668_661F(context)
                end
            },
            {
                key = "亡者凝视",
                ["冷却毫秒"] = _____53D6_4EA1_8005_51DD_89C6_51B7_5374,
                ["首次延迟毫秒"] = 4200,
                ["忙碌毫秒"] = (gaze["前摇秒"] + 0.5) * 1000,
                ["优先级"] = 20,
                ["权重"] = 1,
                ["互斥组"] = "亚伦柯斯主要机制",
                ["选择目标"] = _____9009_62E9_968F_673A_76EE_6807,
                ["执行"] = function(context, target)
                    return _____91CA_653E_4E9A_4F26_67EF_65AF_4EA1_8005_51DD_89C6(context, target)
                end
            },
            {
                key = "亡冥英斩",
                ["冷却毫秒"] = _____53D6_4EA1_51A5_82F1_65A9_51B7_5374,
                ["首次延迟毫秒"] = 2600,
                ["忙碌毫秒"] = (slash["前摇秒"] + slash["推进秒"] + slash["P3归魂延迟秒"] + 0.4) * 1000,
                ["优先级"] = 20,
                ["权重"] = 1,
                ["互斥组"] = "亚伦柯斯主要机制",
                ["选择目标"] = _____9009_62E9_6700_8FD1_76EE_6807,
                ["执行"] = function(context, target)
                    return _____91CA_653E_4E9A_4F26_67EF_65AF_4EA1_51A5_82F1_65A9(context, target)
                end
            }
        },
        ["成功后"] = function(context)
            local minimumBusy = getServerTime() + 900
            if context["普通机制忙碌到Ms"] < minimumBusy then
                context["普通机制忙碌到Ms"] = minimumBusy
            end
        end
    })
    _____4E9A_4F26_67EF_65AF_8C03_5EA6_5668["启动"](_____4E9A_4F26_67EF_65AF_8C03_5EA6_5668)
end
____exports["亚伦柯斯技能调度状态"] = {
    ["类型"] = "阶段与大型技能调度器",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "错开亡冥英斩、英灵陨星、亡者凝视和墓碑残影，确保同一时刻只有一套主要走位预警。"
}
return ____exports
