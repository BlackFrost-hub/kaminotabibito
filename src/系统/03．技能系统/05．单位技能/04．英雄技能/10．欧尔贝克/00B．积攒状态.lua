local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 欧尔贝克 - 积攒计数状态
-- 
-- W（积攒）期间记录“剩余普攻次数”，普攻命中时递减，归零后 W 提前结束。
-- 源 JASS：YDHT[unit].0x441F0510（初始 5，每次造成伤害 -1）。
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____79EF_6512_8BA1_6570_8868 = {}
____exports["获取欧尔贝克积攒计数"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return _____79EF_6512_8BA1_6570_8868[GetHandleId(unit)] or 0
end
____exports["设置欧尔贝克积攒计数"] = function(unit, value)
    if unit == nil or unit == 0 then
        return
    end
    if value <= 0 then
        __TS__Delete(
            _____79EF_6512_8BA1_6570_8868,
            GetHandleId(unit)
        )
        return
    end
    _____79EF_6512_8BA1_6570_8868[GetHandleId(unit)] = value
end
____exports["消耗欧尔贝克积攒"] = function(unit)
    local current = ____exports["获取欧尔贝克积攒计数"](unit)
    if current <= 0 then
        return
    end
    ____exports["设置欧尔贝克积攒计数"](unit, current - 1)
end
return ____exports
