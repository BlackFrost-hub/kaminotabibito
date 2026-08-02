--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____5361_745F_62C9BuffID
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____01_FF0E_9636_6BB5_4E0A_4E0B_6587 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.01．阶段上下文")
local _____521B_5EFA_9636_6BB5_4E0A_4E0B_6587 = ____01_FF0E_9636_6BB5_4E0A_4E0B_6587["创建阶段上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.00．配置")
local _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["卡瑟拉单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local ____08_FF0E_89E6_624B_89E3_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.08．触手解放")
local _____89E6_53D1_5361_745F_62C9_89E6_624B_89E3_653E = ____08_FF0E_89E6_624B_89E3_653E["触发卡瑟拉触手解放"]
____exports["刷新玩家触手残片Buff"] = function(_context, unit, stack)
    local current = stack ~= nil and stack or 0
    if current <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____5361_745F_62C9BuffID["触手残片"])
        return
    end
    registerManualBuff(
        unit,
        _____5361_745F_62C9BuffID["触手残片"],
        120,
        current,
        {stack = current, sourceName = "卡瑟拉-触手残片"}
    )
end
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_0.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.02．卡瑟拉")
_____5361_745F_62C9BuffID = ____require_result_1["卡瑟拉BuffID"]
local function _____521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(boss, _____6E05_7406)
    local context = {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["阶段上下文"] = nil,
        ["已初始化"] = false,
        ["清理"] = _____6E05_7406,
        ["触手残片数量"] = 0,
        ["玩家触手残片表"] = {},
        ["玩家触手残片单位表"] = {},
        ["场上触手残片列表"] = {},
        ["绝缘珊瑚列表"] = {},
        ["触手解放已触发"] = false,
        ["触手再生节点已注册"] = false,
        ["Boss潜入中"] = false,
        ["触手精华层数"] = 0
    }
    context["阶段上下文"] = _____521B_5EFA_9636_6BB5_4E0A_4E0B_6587({
        ["清理"] = _____6E05_7406,
        ["名称"] = "卡瑟拉",
        ["单位"] = boss,
        ["初始阶段ID"] = "P1",
        ["Tick间隔毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"],
        ["阶段列表"] = {
            {ID = "P1"},
            {
                ID = "P2",
                ["血量百分比"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P2生命比例"],
                ["on进入"] = function()
                    context["阶段"] = 2
                end
            },
            {
                ID = "P3",
                ["血量百分比"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P3生命比例"],
                ["on进入"] = function()
                    context["阶段"] = 3
                    _____89E6_53D1_5361_745F_62C9_89E6_624B_89E3_653E(context)
                end
            }
        }
    })
    return context
end
local _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "卡瑟拉", ["主动技能提示"] = _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587, ["死亡时自动清理"] = true})
____exports["获取卡瑟拉上下文"] = function(boss)
    return _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建卡瑟拉上下文"] = function(boss)
    return _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取全部卡瑟拉上下文"] = function()
    return _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["清理卡瑟拉上下文"] = function(boss)
    _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["增加玩家触手残片"] = function(context, unit, amount)
    if amount == nil then
        amount = 1
    end
    local id = _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382["取单位ID"](unit)
    if id == 0 then
        return 0
    end
    local max = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]["玩家持有上限"]
    local next = (context["玩家触手残片表"][id] or 0) + amount
    if next > max then
        next = max
    end
    if next < 0 then
        next = 0
    end
    context["玩家触手残片表"][id] = next
    context["玩家触手残片单位表"][id] = unit
    ____exports["刷新玩家触手残片Buff"](context, unit, next)
    return next
end
____exports["设置玩家触手残片"] = function(context, unit, amount)
    local id = _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382["取单位ID"](unit)
    if id == 0 then
        return 0
    end
    local max = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]["玩家持有上限"]
    local next = amount
    if next > max then
        next = max
    end
    if next < 0 then
        next = 0
    end
    context["玩家触手残片表"][id] = next
    context["玩家触手残片单位表"][id] = unit
    ____exports["刷新玩家触手残片Buff"](context, unit, next)
    return next
end
____exports["取玩家触手残片"] = function(context, unit)
    local id = _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382["取单位ID"](unit)
    return id == 0 and 0 or (context["玩家触手残片表"][id] or 0)
end
____exports["消耗玩家触手残片"] = function(context, unit, amount)
    local id = _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382["取单位ID"](unit)
    if id == 0 then
        return false
    end
    local current = context["玩家触手残片表"][id] or 0
    if current < amount then
        return false
    end
    context["玩家触手残片表"][id] = current - amount
    context["玩家触手残片单位表"][id] = unit
    ____exports["刷新玩家触手残片Buff"](context, unit, current - amount)
    return true
end
return ____exports
