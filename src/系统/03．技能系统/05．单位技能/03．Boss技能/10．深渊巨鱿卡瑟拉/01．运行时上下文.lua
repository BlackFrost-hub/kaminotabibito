--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local GetUnitState, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____5361_745F_62C9BuffID
local ____15_FF0EBoss_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．Boss运行时上下文工厂")
local _____521B_5EFABoss_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0EBoss_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建Boss运行时上下文工厂"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.00．配置")
local _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["卡瑟拉单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
____exports["取卡瑟拉当前阶段"] = function(boss)
    if boss == nil or boss == 0 then
        return 1
    end
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return 1
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    if ratio <= _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P3生命比例"] then
        return 3
    end
    if ratio <= _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P2生命比例"] then
        return 2
    end
    return 1
end
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
local jass = require("jass.common")
GetUnitState = jass.GetUnitState
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_0.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("系统.05．Buff系统.03．Buff表.01．Boss.08．卡瑟拉")
_____5361_745F_62C9BuffID = ____require_result_1["卡瑟拉BuffID"]
local function _____521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {
        ["Boss单位"] = boss,
        ["阶段"] = ____exports["取卡瑟拉当前阶段"](boss),
        ["已初始化"] = false,
        ["清理"] = _____6E05_7406,
        ["触手残片数量"] = 0,
        ["玩家触手残片表"] = {},
        ["玩家触手残片单位表"] = {},
        ["场上触手残片列表"] = {},
        ["绝缘珊瑚列表"] = {},
        ["触手解放已触发"] = false,
        ["Boss潜入中"] = false,
        ["上次触手再生档位"] = 10,
        ["下次深渊召唤时间"] = 0,
        ["下次共生电击时间"] = 0,
        ["下次残片吸收时间"] = 0,
        ["下次残片牵引时间"] = 0,
        ["触手精华层数"] = 0
    }
end
local _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFABoss_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "卡瑟拉", ["主动技能提示"] = _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587})
local function _____53D6_5355_4F4DID(unit)
    return _____5361_745F_62C9_4E0A_4E0B_6587_5DE5_5382["取单位ID"](unit)
end
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
____exports["刷新卡瑟拉阶段"] = function(context)
    context["阶段"] = ____exports["取卡瑟拉当前阶段"](context["Boss单位"])
    return context["阶段"]
end
____exports["增加玩家触手残片"] = function(context, unit, amount)
    if amount == nil then
        amount = 1
    end
    local id = _____53D6_5355_4F4DID(unit)
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
    local id = _____53D6_5355_4F4DID(unit)
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
    local id = _____53D6_5355_4F4DID(unit)
    return id == 0 and 0 or (context["玩家触手残片表"][id] or 0)
end
____exports["消耗玩家触手残片"] = function(context, unit, amount)
    local id = _____53D6_5355_4F4DID(unit)
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
____exports["注册卡瑟拉运行时"] = function()
end
return ____exports
