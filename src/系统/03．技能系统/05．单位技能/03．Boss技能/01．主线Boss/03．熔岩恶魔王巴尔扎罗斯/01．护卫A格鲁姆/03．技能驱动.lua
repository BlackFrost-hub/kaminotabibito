--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7194_5CA9_91CD_9524 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.01．熔岩重锤")
local _____91CA_653E_683C_9C81_59C6_91CD_9524 = ____01_FF0E_7194_5CA9_91CD_9524["释放格鲁姆重锤"]
local ____02_FF0E_7194_5CA9_706B_5F84 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.02．熔岩火径")
local _____91CA_653E_683C_9C81_59C6_706B_5F84 = ____02_FF0E_7194_5CA9_706B_5F84["释放格鲁姆火径"]
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.00．公共")
local _____683C_9C81_59C6_516C_5171 = ____00_FF0E_516C_5171["格鲁姆公共"]
local ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.13．战斗技能调度模板.01．战斗技能调度模板")
local _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668 = ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F["创建战斗技能调度器"]
local ____683C_9C81_59C6_516C_5171_0 = _____683C_9C81_59C6_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____683C_9C81_59C6_516C_5171_0["巴尔扎罗斯技能数值配置"]
local GetUnitX = ____683C_9C81_59C6_516C_5171_0.GetUnitX
local GetUnitY = ____683C_9C81_59C6_516C_5171_0.GetUnitY
local _____5355_4F4D_6709_6548 = ____683C_9C81_59C6_516C_5171_0["单位有效"]
local _____53D6_5355_4F4DID = ____683C_9C81_59C6_516C_5171_0["取单位ID"]
local _____53D6_76EE_6807_5355_4F4D = ____683C_9C81_59C6_516C_5171_0["取目标单位"]
local _____70B9_5230_5355_4F4D_8DDD_79BB_5E73_65B9 = ____683C_9C81_59C6_516C_5171_0["点到单位距离平方"]
local function _____683C_9C81_59C6_53EF_8C03_5EA6(context)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and _____5355_4F4D_6709_6548(context["格鲁姆"])
end
local function _____53D6_683C_9C81_59C6_4E0A_4E0B_6587_952E(context)
    return _____53D6_5355_4F4DID(context["格鲁姆"])
end
local function _____9009_62E9_683C_9C81_59C6_76EE_6807(context)
    return _____53D6_76EE_6807_5355_4F4D(context)
end
local function _____683C_9C81_59C6_91CD_9524_76EE_6807_6709_6548(context, target)
    local grum = context["格鲁姆"]
    if not _____5355_4F4D_6709_6548(grum) or not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local hammer = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩重锤"]
    return _____70B9_5230_5355_4F4D_8DDD_79BB_5E73_65B9(
        target,
        GetUnitX(grum),
        GetUnitY(grum)
    ) <= hammer["施法距离"] * hammer["施法距离"]
end
____exports["初始化巴尔扎罗斯格鲁姆技能"] = function(context)
    if context["格鲁姆技能已初始化"] then
        return
    end
    context["格鲁姆技能已初始化"] = true
    local hammer = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩重锤"]
    local firePath = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "巴尔扎罗斯-格鲁姆技能调度",
        ["清理"] = context["清理"],
        ["间隔毫秒"] = 500,
        ["取上下文列表"] = function()
            return {context}
        end,
        ["取上下文键"] = _____53D6_683C_9C81_59C6_4E0A_4E0B_6587_952E,
        ["可调度"] = _____683C_9C81_59C6_53EF_8C03_5EA6,
        ["技能列表"] = {
            {
                key = "熔岩重锤",
                ["冷却毫秒"] = hammer["冷却秒"] * 1000,
                ["首次延迟毫秒"] = 0,
                ["优先级"] = 20,
                ["选择目标"] = _____9009_62E9_683C_9C81_59C6_76EE_6807,
                ["目标有效"] = _____683C_9C81_59C6_91CD_9524_76EE_6807_6709_6548,
                ["执行"] = function(skillContext, target)
                    _____91CA_653E_683C_9C81_59C6_91CD_9524(skillContext, target)
                    return true
                end
            },
            {
                key = "熔岩火径",
                ["冷却毫秒"] = firePath["冷却秒"] * 1000,
                ["首次延迟毫秒"] = 0,
                ["优先级"] = 10,
                ["选择目标"] = _____9009_62E9_683C_9C81_59C6_76EE_6807,
                ["目标有效"] = function(_context, target)
                    return _____5355_4F4D_6709_6548(target)
                end,
                ["执行"] = function(skillContext, target)
                    _____91CA_653E_683C_9C81_59C6_706B_5F84(skillContext, target)
                    return true
                end
            }
        }
    })
end
return ____exports
