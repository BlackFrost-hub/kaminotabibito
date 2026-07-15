local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_51B0_7130_53CC_661F = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.01．冰焰双星")
local _____91CA_653E_51B0_7130_53CC_661F = ____01_FF0E_51B0_7130_53CC_661F["释放冰焰双星"]
local ____02_FF0E_7EDD_5BF9_96F6_5EA6_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.02．绝对零度领域")
local _____91CA_653E_7EDD_5BF9_96F6_5EA6_9886_57DF = ____02_FF0E_7EDD_5BF9_96F6_5EA6_9886_57DF["释放绝对零度领域"]
local ____03_FF0E_5143_7D20_8F6C_6362 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.03．元素转换")
local _____5207_6362_585E_62C9_5F62_6001 = ____03_FF0E_5143_7D20_8F6C_6362["切换塞拉形态"]
local _____786E_4FDD_585E_62C9_4F24_5BB3_4FEE_6B63 = ____03_FF0E_5143_7D20_8F6C_6362["确保塞拉伤害修正"]
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.00．公共")
local _____585E_62C9_516C_5171 = ____00_FF0E_516C_5171["塞拉公共"]
local ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.13．战斗技能调度模板.01．战斗技能调度模板")
local _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668 = ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F["创建战斗技能调度器"]
local ____585E_62C9_516C_5171_0 = _____585E_62C9_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____585E_62C9_516C_5171_0["巴尔扎罗斯技能数值配置"]
local GetUnitX = ____585E_62C9_516C_5171_0.GetUnitX
local GetUnitY = ____585E_62C9_516C_5171_0.GetUnitY
local _____5355_4F4D_6709_6548 = ____585E_62C9_516C_5171_0["单位有效"]
local _____53D6_5355_4F4DID = ____585E_62C9_516C_5171_0["取单位ID"]
local _____70B9_8DDD_79BB_5E73_65B9 = ____585E_62C9_516C_5171_0["点距离平方"]
local _____53D6_585E_62C9_5F62_6001 = ____585E_62C9_516C_5171_0["取塞拉形态"]
local _____53D6_585E_62C9_6280_80FD_76EE_6807 = ____585E_62C9_516C_5171_0["取塞拉技能目标"]
local _____585E_62C9_5F62_6001_8868 = ____585E_62C9_516C_5171_0["塞拉形态表"]
local _____7EDD_5BF9_96F6_5EA6_9886_57DF_72B6_6001_8868 = ____585E_62C9_516C_5171_0["绝对零度领域状态表"]
local function _____585E_62C9_53EF_8C03_5EA6(context)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and _____5355_4F4D_6709_6548(context["塞拉"])
end
local function _____53D6_585E_62C9_4E0A_4E0B_6587_952E(context)
    return _____53D6_5355_4F4DID(context["塞拉"])
end
local function _____9009_62E9_585E_62C9_76EE_6807(context)
    return _____53D6_585E_62C9_6280_80FD_76EE_6807(context)
end
local function _____585E_62C9_51B0_7130_53CC_661F_76EE_6807_6709_6548(context, target)
    local sera = context["塞拉"]
    if not _____5355_4F4D_6709_6548(sera) or not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local iceFire = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["冰焰双星"]
    local distanceSq = _____70B9_8DDD_79BB_5E73_65B9(
        GetUnitX(sera),
        GetUnitY(sera),
        GetUnitX(target),
        GetUnitY(target)
    )
    return distanceSq <= iceFire["施法距离"] * iceFire["施法距离"]
end
____exports["初始化巴尔扎罗斯塞拉技能"] = function(context)
    if context["塞拉技能已初始化"] then
        return
    end
    context["塞拉技能已初始化"] = true
    _____786E_4FDD_585E_62C9_4F24_5BB3_4FEE_6B63()
    if _____5355_4F4D_6709_6548(context["塞拉"]) then
        local id = _____53D6_5355_4F4DID(context["塞拉"])
        _____5207_6362_585E_62C9_5F62_6001(context, "火焰", false)
        local ____self_1 = context["清理"]
        ____self_1["登记清理"](
            ____self_1,
            "巴尔扎罗斯-塞拉技能状态",
            function()
                __TS__Delete(_____585E_62C9_5F62_6001_8868, id)
                __TS__Delete(_____7EDD_5BF9_96F6_5EA6_9886_57DF_72B6_6001_8868, id)
            end
        )
    end
    local conversion = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["元素转换"]
    local iceFire = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["冰焰双星"]
    local zero = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["绝对零度领域"]
    _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "巴尔扎罗斯-塞拉技能调度",
        ["清理"] = context["清理"],
        ["间隔毫秒"] = 500,
        ["取上下文列表"] = function()
            return {context}
        end,
        ["取上下文键"] = _____53D6_585E_62C9_4E0A_4E0B_6587_952E,
        ["可调度"] = _____585E_62C9_53EF_8C03_5EA6,
        ["技能列表"] = {
            {
                key = "元素转换",
                ["冷却毫秒"] = conversion["周期秒"] * 1000,
                ["首次延迟毫秒"] = conversion["周期秒"] * 1000,
                ["优先级"] = 30,
                ["执行"] = function(skillContext)
                    local next = _____53D6_585E_62C9_5F62_6001(skillContext) == "火焰" and "冰霜" or "火焰"
                    _____5207_6362_585E_62C9_5F62_6001(skillContext, next, true)
                    return true
                end
            },
            {
                key = "冰焰双星",
                ["冷却毫秒"] = iceFire["冷却秒"] * 1000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = iceFire["施法硬直秒"] * 1000,
                ["优先级"] = 20,
                ["选择目标"] = _____9009_62E9_585E_62C9_76EE_6807,
                ["目标有效"] = _____585E_62C9_51B0_7130_53CC_661F_76EE_6807_6709_6548,
                ["执行"] = function(skillContext, target)
                    _____91CA_653E_51B0_7130_53CC_661F(skillContext, target)
                    return true
                end
            },
            {
                key = "绝对零度领域",
                ["冷却毫秒"] = zero["冷却秒"] * 1000,
                ["首次延迟毫秒"] = 0,
                ["忙碌毫秒"] = zero["施法硬直秒"] * 1000,
                ["优先级"] = 10,
                ["选择目标"] = _____9009_62E9_585E_62C9_76EE_6807,
                ["目标有效"] = function(_context, target)
                    return _____5355_4F4D_6709_6548(target)
                end,
                ["执行"] = function(skillContext, target)
                    _____91CA_653E_7EDD_5BF9_96F6_5EA6_9886_57DF(skillContext, target)
                    return true
                end
            }
        }
    })
end
____exports["注册巴尔扎罗斯护卫塞拉"] = function()
    _____786E_4FDD_585E_62C9_4F24_5BB3_4FEE_6B63()
end
return ____exports
