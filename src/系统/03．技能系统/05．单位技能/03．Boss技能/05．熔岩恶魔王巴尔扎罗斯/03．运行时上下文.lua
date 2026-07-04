--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.01．场地配置")
local _____521B_5EFA_5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_7EC4 = ____01_FF0E_573A_5730_914D_7F6E["创建巴尔扎罗斯战斗区域组"]
local _____6E05_7406_5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_7EC4 = ____01_FF0E_573A_5730_914D_7F6E["清理巴尔扎罗斯战斗区域组"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local function _____521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["开战时间Ms"] = getServerTime(),
        ["清理"] = _____6E05_7406,
        ["战斗区域组"] = _____521B_5EFA_5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_7EC4(),
        ["护卫机制已初始化"] = false,
        ["格鲁姆技能已初始化"] = false,
        ["塞拉技能已初始化"] = false,
        ["熔核封印已解除"] = false,
        ["地核召唤节点已初始化"] = false,
        ["熔岩护盾节点已初始化"] = false,
        ["末日熔爆节点已初始化"] = false,
        ["末日熔爆引导中"] = false,
        ["末日熔爆下一次允许Ms"] = 0,
        ["已触发低血量末日熔爆"] = false,
        ["元素安全印记列表"] = {},
        ["恶魔咆哮波命中记录"] = {},
        ["王者天罚命中记录"] = {}
    }
end
local _____5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({
    ["名称"] = "巴尔扎罗斯",
    ["主动技能提示"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"],
    ["创建上下文"] = _____521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587,
    ["on清理"] = function(context)
        _____6E05_7406_5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_7EC4(context["战斗区域组"])
    end
})
____exports["获取巴尔扎罗斯上下文"] = function(boss)
    return _____5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建巴尔扎罗斯上下文"] = function(boss)
    return _____5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["清理巴尔扎罗斯上下文"] = function(boss)
    _____5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["注册巴尔扎罗斯运行时"] = function()
end
____exports["记录巴尔扎罗斯元素安全印记"] = function(boss, x, y)
    local context = ____exports["获取或创建巴尔扎罗斯上下文"](boss)
    if context == nil then
        return
    end
    local ____context__5143_7D20_5B89_5168_5370_8BB0_5217_8868_1 = context["元素安全印记列表"]
    ____context__5143_7D20_5B89_5168_5370_8BB0_5217_8868_1[#____context__5143_7D20_5B89_5168_5370_8BB0_5217_8868_1 + 1] = {X = x, Y = y}
end
return ____exports
