--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local GetUnitState, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____53D6_5355_4F4DID = ____16_FF0E_516C_5171_5DE5_5177["取单位ID"]
local stringToFourCC = ____16_FF0E_516C_5171_5DE5_5177.stringToFourCC
____exports["取莫尔特斯当前阶段"] = function(boss)
    if not _____5355_4F4D_6709_6548(boss) then
        return 1
    end
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return 1
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    if ratio <= 0.4 then
        return 3
    end
    if ratio <= 0.7 then
        return 2
    end
    return 1
end
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitState = jass.GetUnitState
local GetOwningPlayer = jass.GetOwningPlayer
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____83AB_5C14_7279_65AF_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯")
local _____83AB_5C14_7279_65AFBuffID = ____require_result_2["莫尔特斯BuffID"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local function _____521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(boss, _____6E05_7406)
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "开场", 0)
    return {
        ["Boss单位"] = boss,
        ["阶段"] = ____exports["取莫尔特斯当前阶段"](boss),
        ["已初始化"] = false,
        ["清理"] = _____6E05_7406,
        ["玩家腐败值表"] = {},
        ["玩家腐败值单位表"] = {},
        ["根系觉醒已触发"] = false,
        ["腐朽领域已触发"] = false,
        ["下次沼泽腐败时间"] = 0,
        ["下次沼泽根须时间"] = 0,
        ["下次虫群时间"] = 0,
        ["下次腐败传输档位"] = 95,
        ["腐败护盾值"] = 0
    }
end
local _____83AB_5C14_7279_65AF_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "莫尔特斯", ["主动技能提示"] = _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587})
____exports["获取莫尔特斯上下文"] = function(boss)
    return _____83AB_5C14_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建莫尔特斯上下文"] = function(boss)
    return _____83AB_5C14_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取全部莫尔特斯上下文"] = function()
    return _____83AB_5C14_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["清理莫尔特斯上下文"] = function(boss)
    _____83AB_5C14_7279_65AF_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["刷新莫尔特斯阶段"] = function(context)
    context["阶段"] = ____exports["取莫尔特斯当前阶段"](context["Boss单位"])
    return context["阶段"]
end
____exports["刷新玩家腐败值Buff"] = function(_context, unit, stack)
    local current = stack or 0
    if current <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____83AB_5C14_7279_65AFBuffID["腐败值"])
        return
    end
    registerManualBuff(
        unit,
        _____83AB_5C14_7279_65AFBuffID["腐败值"],
        _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败值"]["Buff显示秒"],
        current,
        {stack = current, sourceName = "莫尔特斯-腐败值"}
    )
end
____exports["取玩家腐败值"] = function(context, unit)
    local id = _____53D6_5355_4F4DID(unit)
    return id == 0 and 0 or (context["玩家腐败值表"][id] or 0)
end
____exports["设置玩家腐败值"] = function(context, unit, value)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return 0
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败值"]
    local next = value
    if next < 0 then
        next = 0
    end
    if next > cfg["上限"] then
        next = cfg["上限"]
    end
    context["玩家腐败值表"][id] = next
    context["玩家腐败值单位表"][id] = unit
    ____exports["刷新玩家腐败值Buff"](context, unit, next)
    local owner = GetOwningPlayer(unit)
    if owner ~= nil and owner ~= 0 then
        YDUserDataSetSafe(
            "player",
            owner,
            "腐败值",
            "real",
            next
        )
    end
    return next
end
____exports["增加玩家腐败值"] = function(context, unit, amount)
    local oldValue = ____exports["取玩家腐败值"](context, unit)
    local next = ____exports["设置玩家腐败值"](context, unit, oldValue + amount)
    return next
end
____exports["清除玩家腐败值"] = function(context, unit, amount)
    return ____exports["设置玩家腐败值"](
        context,
        unit,
        ____exports["取玩家腐败值"](context, unit) - amount
    )
end
____exports["取腐败值最高玩家"] = function(context)
    local best = nil
    local bestValue = -1
    for key in pairs(context["玩家腐败值表"]) do
        do
            local value = context["玩家腐败值表"][key] or 0
            local unit = context["玩家腐败值单位表"][key]
            if not _____5355_4F4D_6709_6548(unit) then
                goto __continue24
            end
            if value > bestValue then
                bestValue = value
                best = unit
            end
        end
        ::__continue24::
    end
    return best
end
____exports["刷新Boss腐败护盾Buff"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["腐败护盾值"] <= 0 then
        if _____5355_4F4D_6709_6548(boss) then
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____83AB_5C14_7279_65AFBuffID["腐败护盾"])
        end
        return
    end
    registerManualBuff(
        boss,
        _____83AB_5C14_7279_65AFBuffID["腐败护盾"],
        _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败传输"]["护盾持续秒"],
        context["腐败护盾值"],
        {stack = context["腐败护盾值"], sourceName = "莫尔特斯-腐败护盾"}
    )
end
local function ____on_83AB_5C14_7279_65AF_6B7B_4EA1(dyingUnit)
    if GetUnitTypeId(dyingUnit) ~= _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(dyingUnit, "死亡", 0)
    ____exports["清理莫尔特斯上下文"](dyingUnit)
end
____exports["注册莫尔特斯运行时"] = function()
    if _____83AB_5C14_7279_65AF_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____83AB_5C14_7279_65AF_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(____on_83AB_5C14_7279_65AF_6B7B_4EA1)
end
return ____exports
