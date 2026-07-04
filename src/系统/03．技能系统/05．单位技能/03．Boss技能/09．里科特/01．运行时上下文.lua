local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local GetUnitState, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.00．配置")
local _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["里科特单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特数值与表现配置"]
____exports["取里科特当前阶段"] = function(boss)
    if boss == nil or boss == 0 then
        return 1
    end
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return 1
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    if ratio <= _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P3生命比例"] then
        return 3
    end
    if ratio <= _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P2生命比例"] then
        return 2
    end
    return 1
end
local jass = require("jass.common")
GetUnitState = jass.GetUnitState
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local function _____521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {
        ["Boss单位"] = boss,
        ["阶段"] = ____exports["取里科特当前阶段"](boss),
        ["已初始化"] = false,
        ["清理"] = _____6E05_7406,
        ["神风护体层数"] = 0,
        ["神风印记表"] = {},
        ["神风印记单位表"] = {},
        ["破魔反击中"] = false
    }
end
local _____91CC_79D1_7279_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "里科特", ["主动技能提示"] = _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587})
local function _____53D6_5355_4F4DID(unit)
    return _____91CC_79D1_7279_4E0A_4E0B_6587_5DE5_5382["取单位ID"](unit)
end
____exports["获取里科特上下文"] = function(boss)
    return _____91CC_79D1_7279_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建里科特上下文"] = function(boss)
    return _____91CC_79D1_7279_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取全部里科特上下文"] = function()
    return _____91CC_79D1_7279_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["清理里科特上下文"] = function(boss)
    _____91CC_79D1_7279_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["刷新里科特阶段"] = function(context)
    context["阶段"] = ____exports["取里科特当前阶段"](context["Boss单位"])
    return context["阶段"]
end
____exports["增加里科特神风印记"] = function(context, unit, amount)
    if amount == nil then
        amount = 1
    end
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return 0
    end
    local next = (context["神风印记表"][id] or 0) + amount
    context["神风印记表"][id] = next
    context["神风印记单位表"][id] = unit
    return next
end
____exports["取里科特神风印记"] = function(context, unit)
    local id = _____53D6_5355_4F4DID(unit)
    return id == 0 and 0 or (context["神风印记表"][id] or 0)
end
____exports["清除里科特神风印记"] = function(context, unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id ~= 0 then
        __TS__Delete(context["神风印记表"], id)
        __TS__Delete(context["神风印记单位表"], id)
    end
end
____exports["注册里科特运行时"] = function()
end
return ____exports
