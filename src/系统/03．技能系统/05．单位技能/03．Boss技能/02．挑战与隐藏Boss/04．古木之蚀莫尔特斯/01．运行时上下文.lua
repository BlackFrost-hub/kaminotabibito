--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_62A4_76FE, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE, _____83AB_5C14_7279_65AFBuffID, _____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____01_FF0E_9636_6BB5_4E0A_4E0B_6587 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.01．阶段上下文")
local _____521B_5EFA_9636_6BB5_4E0A_4E0B_6587 = ____01_FF0E_9636_6BB5_4E0A_4E0B_6587["创建阶段上下文"]
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
function _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_62A4_76FE(context)
    local boss = context["Boss单位"]
    if boss ~= nil and boss ~= 0 then
        _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE(boss, _____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E)
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____83AB_5C14_7279_65AFBuffID["腐败护盾"])
    context["腐败护盾值"] = 0
end
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____83AB_5C14_7279_65AF_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____5F00_59CB_62A4_76FE = ____require_result_2["开始护盾"]
local _____62A4_76FE_7C7B_578B = ____require_result_2["护盾类型"]
local _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C = ____require_result_2["查询单位标签护盾值"]
local _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE = ____require_result_2["充能单位标签护盾"]
local _____5237_65B0_5355_4F4D_6807_7B7E_62A4_76FE_6301_7EED_65F6_95F4 = ____require_result_2["刷新单位标签护盾持续时间"]
_____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE = ____require_result_2["移除单位标签护盾"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
local ____require_result_4 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯")
_____83AB_5C14_7279_65AFBuffID = ____require_result_4["莫尔特斯BuffID"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_5.YDUserDataSetSafe
_____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E = "莫尔特斯-腐败护盾"
local function _____521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(boss, _____6E05_7406)
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "开场", 0)
    local context = {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["阶段上下文"] = nil,
        ["已初始化"] = false,
        ["清理"] = _____6E05_7406,
        ["玩家腐败值表"] = {},
        ["玩家腐败值单位表"] = {},
        ["根系觉醒已触发"] = false,
        ["腐朽领域已触发"] = false,
        ["腐朽领域已生效"] = false,
        ["腐败传输节点已注册"] = false,
        ["腐败护盾值"] = 0
    }
    context["阶段上下文"] = _____521B_5EFA_9636_6BB5_4E0A_4E0B_6587({
        ["清理"] = _____6E05_7406,
        ["名称"] = "莫尔特斯",
        ["单位"] = boss,
        ["初始阶段ID"] = "P1",
        ["Tick间隔毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"],
        ["阶段列表"] = {
            {ID = "P1"},
            {
                ID = "P2",
                ["血量百分比"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P2生命比例"],
                ["on进入"] = function()
                    context["阶段"] = 2
                end
            },
            {
                ID = "P3",
                ["血量百分比"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P3生命比例"],
                ["on进入"] = function()
                    context["阶段"] = 3
                end
            }
        }
    })
    return context
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
    local context = _____83AB_5C14_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
    if context ~= nil then
        _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_62A4_76FE(context)
    end
    _____83AB_5C14_7279_65AF_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
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
                goto __continue21
            end
            if value > bestValue then
                bestValue = value
                best = unit
            end
        end
        ::__continue21::
    end
    return best
end
local function _____64AD_653E_83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_7834_88C2_7279_6548(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败传输"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["护盾破裂特效路径"],
        X = GetUnitX(unit),
        Y = GetUnitY(unit),
        ["持续秒"] = cfg["护盾破裂特效持续秒"]
    })
end
local function _____521B_5EFA_83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_53C2_6570(context, boss, value)
    return {
        ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
        ["数值"] = value,
        ["持续时间"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败传输"]["护盾持续秒"],
        ["来源单位"] = boss,
        ["标签"] = _____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E,
        ["结束回调"] = function(unit, _shieldID, _reason)
            context["腐败护盾值"] = _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(unit, _____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E)
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____83AB_5C14_7279_65AFBuffID["腐败护盾"])
        end,
        ["破碎回调"] = function(unit, _shieldID, _absorbed)
            context["腐败护盾值"] = 0
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____83AB_5C14_7279_65AFBuffID["腐败护盾"])
            _____64AD_653E_83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_7834_88C2_7279_6548(unit)
        end
    }
end
____exports["同步Boss腐败护盾值"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        context["腐败护盾值"] = 0
        return 0
    end
    local current = _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(boss, _____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E)
    context["腐败护盾值"] = current > 0 and current or 0
    return context["腐败护盾值"]
end
____exports["刷新Boss腐败护盾Buff"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["腐败护盾值"] <= 0 then
        _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_62A4_76FE(context)
        return
    end
    local desired = context["腐败护盾值"]
    local current = _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(boss, _____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E)
    if current <= 0 then
        _____5F00_59CB_62A4_76FE(
            boss,
            _____521B_5EFA_83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_53C2_6570(context, boss, desired)
        )
    elseif desired > current then
        _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE(boss, _____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E, desired - current, desired)
    end
    _____5237_65B0_5355_4F4D_6807_7B7E_62A4_76FE_6301_7EED_65F6_95F4(boss, _____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E, _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败传输"]["护盾持续秒"])
    local actual = _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(boss, _____83AB_5C14_7279_65AF_8150_8D25_62A4_76FE_6807_7B7E)
    context["腐败护盾值"] = actual > 0 and actual or 0
    if context["腐败护盾值"] <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____83AB_5C14_7279_65AFBuffID["腐败护盾"])
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
