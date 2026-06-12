local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.00．配置")
local _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["瑟兰迪尔单位技能配置"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_1["广播单位提示"]
local GetHandleId = jass.GetHandleId
local _____745F_5170_8FEA_5C14_4E0A_4E0B_6587_8868 = {}
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["获取瑟兰迪尔上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return nil
    end
    return _____745F_5170_8FEA_5C14_4E0A_4E0B_6587_8868[id]
end
____exports["获取或创建瑟兰迪尔上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return nil
    end
    local context = _____745F_5170_8FEA_5C14_4E0A_4E0B_6587_8868[id]
    if context ~= nil then
        return context
    end
    context = {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["开战时间Ms"] = getServerTime(),
        ["上次执法印记Ms"] = 0,
        ["上次审判之环Ms"] = 0,
        ["上次终末审判Ms"] = 0,
        ["已触发月光灌注"] = false
    }
    _____745F_5170_8FEA_5C14_4E0A_4E0B_6587_8868[id] = context
    return context
end
____exports["清理瑟兰迪尔上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return
    end
    __TS__Delete(_____745F_5170_8FEA_5C14_4E0A_4E0B_6587_8868, id)
end
____exports["播放瑟兰迪尔台词"] = function(boss, _____7C7B_578B, index)
    if index == nil then
        index = 0
    end
    local lines = _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["台词"][_____7C7B_578B]
    local text = lines[index + 1] or lines[1]
    if text == nil then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(boss, text, _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["广播持续时间Ms"])
end
____exports["注册瑟兰迪尔运行时"] = function()
end
return ____exports
