--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_5168_90E8_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部莫尔特斯上下文"]
local _____6E05_7406_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清理莫尔特斯上下文"]
local _____53D6_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["取玩家腐败值"]
local _____589E_52A0_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加玩家腐败值"]
local _____6E05_9664_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清除玩家腐败值"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯音效配置"]
local ____08_FF0E_6839_7CFB_89C9_9192 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.08．根系觉醒")
local _____89E6_53D1_83AB_5C14_7279_65AF_6839_7CFB_89C9_9192 = ____08_FF0E_6839_7CFB_89C9_9192["触发莫尔特斯根系觉醒"]
local ____09_FF0E_8150_673D_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.09．腐朽领域")
local _____5904_7406_83AB_5C14_7279_65AF_6CBC_6CFD_8150_8D25 = ____09_FF0E_8150_673D_9886_57DF["处理莫尔特斯沼泽腐败"]
local _____5904_7406_83AB_5C14_7279_65AF_6CBC_6CFD_6839_987B = ____09_FF0E_8150_673D_9886_57DF["处理莫尔特斯沼泽根须"]
local _____89E6_53D1_83AB_5C14_7279_65AF_8150_673D_9886_57DF = ____09_FF0E_8150_673D_9886_57DF["触发莫尔特斯腐朽领域"]
local ____10_FF0E_5171_751F_8150_673D_866B_7FA4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.10．共生腐朽虫群")
local _____91CA_653E_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4 = ____10_FF0E_5171_751F_8150_673D_866B_7FA4["释放莫尔特斯共生腐朽虫群"]
local ____12_FF0E_8150_8D25_4F20_8F93 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.12．腐败传输")
local _____6CE8_518C_83AB_5C14_7279_65AF_8150_8D25_4F20_8F93_8282_70B9 = ____12_FF0E_8150_8D25_4F20_8F93["注册莫尔特斯腐败传输节点"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.13．战斗技能调度模板.01．战斗技能调度模板")
local _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668 = ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F["创建战斗技能调度器"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.05．闪电宫格区域")
local _____521B_5EFA_95EA_7535_4E5D_5BAB_683C_533A_57DF = ____require_result_1["创建闪电九宫格区域"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口")
local _____65BD_52A0_7981_9522 = ____require_result_2["施加禁锢"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local ____require_result_4 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯")
local _____83AB_5C14_7279_65AFBuffID = ____require_result_4["莫尔特斯BuffID"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____5DF2_6CE8_518C = false
local function _____786E_4FDD_6839_987B_5BAB_683C(context)
    if context["根须宫格"] ~= nil then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根须领域"]
    context["根须宫格"] = _____521B_5EFA_95EA_7535_4E5D_5BAB_683C_533A_57DF({
        ["名称"] = "莫尔特斯-根须领域",
        ["中心X"] = cfg["中心X"],
        ["中心Y"] = cfg["中心Y"],
        ["行数"] = cfg["行数"],
        ["列数"] = cfg["列数"],
        ["单格边长"] = cfg["单格边长"],
        ["闪电效果"] = cfg["闪电效果"],
        ["闪电高度"] = cfg["闪电高度"],
        ["闪电颜色"] = {r = 0.15, g = 0.85, b = 0.2, a = 0.7},
        ["清理篮子"] = context["清理"]
    })
end
local function _____89E6_53D1_8150_8D25_6EE1_5C42_7F20_7ED5(context, unit)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败值"]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["腐败值"]["满层缠绕"],
        GetUnitX(unit),
        GetUnitY(unit),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____65BD_52A0_7981_9522({
        ["来源单位"] = context["Boss单位"],
        ["目标单位"] = unit,
        ["持续时间"] = cfg["满层缠绕秒"],
        ["伤害"] = cfg["满层缠绕每秒伤害"],
        ["伤害间隔"] = 1
    })
    registerManualBuff(
        unit,
        _____83AB_5C14_7279_65AFBuffID["根须缠绕"],
        cfg["满层缠绕秒"],
        cfg["满层缠绕每秒伤害"],
        {sourceName = "莫尔特斯-腐败满层"}
    )
end
____exports["应用莫尔特斯腐败值"] = function(context, unit, amount)
    if not _____5355_4F4D_6709_6548(unit) or amount == 0 then
        return _____53D6_73A9_5BB6_8150_8D25_503C(context, unit)
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败值"]
    local oldValue = _____53D6_73A9_5BB6_8150_8D25_503C(context, unit)
    local next = _____589E_52A0_73A9_5BB6_8150_8D25_503C(context, unit, amount)
    if oldValue < cfg["缠绕阈值"] and next >= cfg["缠绕阈值"] then
        _____89E6_53D1_8150_8D25_6EE1_5C42_7F20_7ED5(context, unit)
    end
    return next
end
____exports["净化莫尔特斯腐败值"] = function(context, unit, amount, _____663E_793ABuff)
    if _____663E_793ABuff == nil then
        _____663E_793ABuff = false
    end
    if not _____5355_4F4D_6709_6548(unit) or not (amount > 0) then
        return _____53D6_73A9_5BB6_8150_8D25_503C(context, unit)
    end
    local next = _____6E05_9664_73A9_5BB6_8150_8D25_503C(context, unit, amount)
    if _____663E_793ABuff then
        registerManualBuff(
            unit,
            _____83AB_5C14_7279_65AFBuffID["净化庇护"],
            1.2,
            amount,
            {sourceName = "莫尔特斯-净化"}
        )
    end
    return next
end
____exports["使用腐败虫尸净化"] = function(context, unit)
    local amount = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败值"]["虫尸清除值"]
    ____exports["净化莫尔特斯腐败值"](context, unit, amount, false)
    registerManualBuff(
        unit,
        _____83AB_5C14_7279_65AFBuffID["腐败虫尸净化"],
        3,
        amount,
        {sourceName = "莫尔特斯-腐败虫尸"}
    )
end
local function _____53D6_83AB_5C14_7279_65AF_4E0A_4E0B_6587_952E(context)
    return _____53D6_5355_4F4DID(context["Boss单位"])
end
local function _____53EF_8C03_5EA6_83AB_5C14_7279_65AF_866B_7FA4(context)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and context["阶段"] >= 2
end
local function _____53EF_8C03_5EA6_83AB_5C14_7279_65AF_8150_673D_9886_57DF(context)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and context["腐朽领域已触发"]
end
local function ____on_83AB_5C14_7279_65AF_8FD0_884C_65F6_7EF4_62A4(context)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        _____6E05_7406_83AB_5C14_7279_65AF_4E0A_4E0B_6587(context["Boss单位"])
        return
    end
    _____786E_4FDD_6839_987B_5BAB_683C(context)
    if context["阶段"] >= 2 then
        _____89E6_53D1_83AB_5C14_7279_65AF_6839_7CFB_89C9_9192(context)
    end
    if context["阶段"] >= 3 then
        _____89E6_53D1_83AB_5C14_7279_65AF_8150_673D_9886_57DF(context)
    end
    _____6CE8_518C_83AB_5C14_7279_65AF_8150_8D25_4F20_8F93_8282_70B9(context)
end
____exports["注册莫尔特斯腐败值与根须领域"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({["名称"] = "莫尔特斯-运行时维护", ["间隔毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"], ["取上下文列表"] = _____83B7_53D6_5168_90E8_83AB_5C14_7279_65AF_4E0A_4E0B_6587, ["执行"] = ____on_83AB_5C14_7279_65AF_8FD0_884C_65F6_7EF4_62A4})
    _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "莫尔特斯-共生腐朽虫群调度",
        ["间隔毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"],
        ["取当前时间"] = getServerTime,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_83AB_5C14_7279_65AF_4E0A_4E0B_6587,
        ["取上下文键"] = _____53D6_83AB_5C14_7279_65AF_4E0A_4E0B_6587_952E,
        ["可调度"] = _____53EF_8C03_5EA6_83AB_5C14_7279_65AF_866B_7FA4,
        ["技能列表"] = {{key = "共生腐朽虫群", ["冷却毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]["触发间隔秒"] * 1000, ["首次延迟毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]["触发间隔秒"] * 1000, ["执行"] = _____91CA_653E_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4}}
    })
    _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "莫尔特斯-沼泽腐败调度",
        ["间隔毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"],
        ["取当前时间"] = getServerTime,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_83AB_5C14_7279_65AF_4E0A_4E0B_6587,
        ["取上下文键"] = _____53D6_83AB_5C14_7279_65AF_4E0A_4E0B_6587_952E,
        ["可调度"] = _____53EF_8C03_5EA6_83AB_5C14_7279_65AF_8150_673D_9886_57DF,
        ["技能列表"] = {{key = "沼泽腐败", ["冷却毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]["沼泽腐败间隔秒"] * 1000, ["首次延迟毫秒"] = 0, ["执行"] = _____5904_7406_83AB_5C14_7279_65AF_6CBC_6CFD_8150_8D25}}
    })
    _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "莫尔特斯-沼泽根须调度",
        ["间隔毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"],
        ["取当前时间"] = getServerTime,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_83AB_5C14_7279_65AF_4E0A_4E0B_6587,
        ["取上下文键"] = _____53D6_83AB_5C14_7279_65AF_4E0A_4E0B_6587_952E,
        ["可调度"] = _____53EF_8C03_5EA6_83AB_5C14_7279_65AF_8150_673D_9886_57DF,
        ["技能列表"] = {{key = "沼泽根须", ["冷却毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]["根须触发间隔秒"] * 1000, ["首次延迟毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]["根须触发间隔秒"] * 1000, ["执行"] = _____5904_7406_83AB_5C14_7279_65AF_6CBC_6CFD_6839_987B}}
    })
end
return ____exports
