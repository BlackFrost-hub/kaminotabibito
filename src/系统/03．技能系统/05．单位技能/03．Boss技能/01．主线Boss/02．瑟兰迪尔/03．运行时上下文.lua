--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.00．配置")
local _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["瑟兰迪尔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_9636_6BB5_9608_503C = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔阶段阈值"]
local ____04_FF0E_6267_6CD5_5370_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.04．执法印记")
local _____5C1D_8BD5_89E6_53D1_745F_5170_8FEA_5C14_6267_6CD5_5370_8BB0 = ____04_FF0E_6267_6CD5_5370_8BB0["尝试触发瑟兰迪尔执法印记"]
local ____07_FF0E_79E9_5E8F_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.07．秩序领域")
local _____5237_65B0_745F_5170_8FEA_5C14_79E9_5E8F_9886_57DF = ____07_FF0E_79E9_5E8F_9886_57DF["刷新瑟兰迪尔秩序领域"]
local _____6E05_7406_745F_5170_8FEA_5C14_79E9_5E8F_9886_57DF = ____07_FF0E_79E9_5E8F_9886_57DF["清理瑟兰迪尔秩序领域"]
local ____08_FF0E_5BA1_5224_4E4B_73AF = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.08．审判之环")
local _____5C1D_8BD5_89E6_53D1_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF = ____08_FF0E_5BA1_5224_4E4B_73AF["尝试触发瑟兰迪尔审判之环"]
local ____11_FF0E_6708_5149_704C_6CE8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.11．月光灌注")
local _____5C1D_8BD5_89E6_53D1_745F_5170_8FEA_5C14_6708_5149_704C_6CE8 = ____11_FF0E_6708_5149_704C_6CE8["尝试触发瑟兰迪尔月光灌注"]
local _____6E05_7406_745F_5170_8FEA_5C14_6708_5149_704C_6CE8 = ____11_FF0E_6708_5149_704C_6CE8["清理瑟兰迪尔月光灌注"]
local ____12_FF0E_7EC8_672B_5BA1_5224 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.12．终末审判")
local _____5C1D_8BD5_89E6_53D1_745F_5170_8FEA_5C14_7EC8_672B_5BA1_5224 = ____12_FF0E_7EC8_672B_5BA1_5224["尝试触发瑟兰迪尔终末审判"]
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
do
    local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
    ____exports["播放瑟兰迪尔台词"] = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local IsUnitType = jass.IsUnitType
local GetUnitState = jass.GetUnitState
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____745F_5170_8FEA_5C14_8FD0_884C_65F6_5DF2_6CE8_518C = false
local function _____521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["开战时间Ms"] = getServerTime(),
        ["清理"] = _____6E05_7406,
        ["上次执法印记Ms"] = 0,
        ["上次审判之环Ms"] = 0,
        ["审判之环进行中"] = false,
        ["上次终末审判Ms"] = 0,
        ["已触发月光灌注"] = false
    }
end
local function _____6E05_7406_745F_5170_8FEA_5C14_4E0A_4E0B_6587_673A_5236(context)
    _____6E05_7406_745F_5170_8FEA_5C14_79E9_5E8F_9886_57DF(context["Boss单位"])
    _____6E05_7406_745F_5170_8FEA_5C14_6708_5149_704C_6CE8()
end
local _____745F_5170_8FEA_5C14_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "瑟兰迪尔", ["主动技能提示"] = _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587, ["on清理"] = _____6E05_7406_745F_5170_8FEA_5C14_4E0A_4E0B_6587_673A_5236})
____exports["获取瑟兰迪尔上下文"] = function(boss)
    return _____745F_5170_8FEA_5C14_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建瑟兰迪尔上下文"] = function(boss)
    return _____745F_5170_8FEA_5C14_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["清理瑟兰迪尔上下文"] = function(boss)
    _____745F_5170_8FEA_5C14_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____5237_65B0_745F_5170_8FEA_5C14_9636_6BB5(context)
    local boss = context["Boss单位"]
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    if context["阶段"] == 1 and ratio <= _____745F_5170_8FEA_5C14_9636_6BB5_9608_503C["第二阶段生命比例"] then
        context["阶段"] = 2
        _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "转阶段70")
    end
    if context["阶段"] == 2 and ratio <= _____745F_5170_8FEA_5C14_9636_6BB5_9608_503C["第三阶段生命比例"] then
        context["阶段"] = 3
        _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "转阶段40")
    end
end
local function _____63A8_8FDB_745F_5170_8FEA_5C14_8FD0_884C_65F6()
    local contexts = _____745F_5170_8FEA_5C14_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if context == nil then
                    goto __continue14
                end
                if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                    ____exports["清理瑟兰迪尔上下文"](context["Boss单位"])
                    goto __continue14
                end
                _____5237_65B0_745F_5170_8FEA_5C14_9636_6BB5(context)
                _____5C1D_8BD5_89E6_53D1_745F_5170_8FEA_5C14_6267_6CD5_5370_8BB0(context)
                _____5237_65B0_745F_5170_8FEA_5C14_79E9_5E8F_9886_57DF(context)
                _____5C1D_8BD5_89E6_53D1_745F_5170_8FEA_5C14_6708_5149_704C_6CE8(context)
                if context["阶段"] >= 2 then
                    _____5C1D_8BD5_89E6_53D1_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF(context)
                end
                if context["阶段"] >= 3 then
                    _____5C1D_8BD5_89E6_53D1_745F_5170_8FEA_5C14_7EC8_672B_5BA1_5224(context)
                end
            end
            ::__continue14::
            i = i + 1
        end
    end
end
____exports["注册瑟兰迪尔运行时"] = function()
    if _____745F_5170_8FEA_5C14_8FD0_884C_65F6_5DF2_6CE8_518C then
        return
    end
    _____745F_5170_8FEA_5C14_8FD0_884C_65F6_5DF2_6CE8_518C = true
    addPeriodicCallback(250, _____63A8_8FDB_745F_5170_8FEA_5C14_8FD0_884C_65F6)
end
return ____exports
