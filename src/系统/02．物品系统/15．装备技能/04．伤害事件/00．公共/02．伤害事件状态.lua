local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____4F24_5BB3_4E8B_4EF6_72B6_6001Tick, getServerTime, _____5468_671F_6548_679C_5217_8868, _____5468_671F_5904_7406_8868
function _____4F24_5BB3_4E8B_4EF6_72B6_6001Tick()
    local _____5F53_524D_65F6_95F4 = getServerTime()
    local index = 0
    while index < #_____5468_671F_6548_679C_5217_8868 do
        do
            local _____8BB0_5F55 = _____5468_671F_6548_679C_5217_8868[index + 1]
            if _____8BB0_5F55 == nil or _____5F53_524D_65F6_95F4 >= _____8BB0_5F55["结束时间"] then
                __TS__ArraySplice(_____5468_671F_6548_679C_5217_8868, index, 1)
                goto __continue5
            end
            if _____5F53_524D_65F6_95F4 >= _____8BB0_5F55["下次时间"] then
                _____8BB0_5F55["下次时间"] = _____5F53_524D_65F6_95F4 + _____8BB0_5F55["间隔毫秒"]
                local _____5904_7406 = _____5468_671F_5904_7406_8868[_____8BB0_5F55["类型"]]
                if _____5904_7406 ~= nil then
                    _____5904_7406(_____8BB0_5F55)
                end
            end
            index = index + 1
        end
        ::__continue5::
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
getServerTime = ____require_result_0.getServerTime
local _____51B7_5374_8868 = {}
_____5468_671F_6548_679C_5217_8868 = {}
_____5468_671F_5904_7406_8868 = {}
local _____5DF2_542F_52A8_72B6_6001Tick = false
local function _____786E_4FDD_72B6_6001Tick()
    if _____5DF2_542F_52A8_72B6_6001Tick then
        return
    end
    _____5DF2_542F_52A8_72B6_6001Tick = true
    addPeriodicCallback(50, _____4F24_5BB3_4E8B_4EF6_72B6_6001Tick)
end
____exports["注册周期效果处理"] = function(_____7C7B_578B, _____5904_7406)
    _____5468_671F_5904_7406_8868[_____7C7B_578B] = _____5904_7406
    _____786E_4FDD_72B6_6001Tick()
end
____exports["添加周期效果"] = function(_____8BB0_5F55)
    if _____8BB0_5F55["间隔毫秒"] <= 0 or _____8BB0_5F55["结束时间"] <= getServerTime() then
        return
    end
    _____5468_671F_6548_679C_5217_8868[#_____5468_671F_6548_679C_5217_8868 + 1] = _____8BB0_5F55
    _____786E_4FDD_72B6_6001Tick()
end
____exports["单位冷却中"] = function(_____952E)
    local _____5230_671F = _____51B7_5374_8868[_____952E] or 0
    return _____5230_671F > getServerTime()
end
____exports["设置单位冷却"] = function(_____952E, _____79D2_6570)
    if _____79D2_6570 <= 0 then
        __TS__Delete(_____51B7_5374_8868, _____952E)
        return
    end
    _____51B7_5374_8868[_____952E] = getServerTime() + _____79D2_6570 * 1000
    _____786E_4FDD_72B6_6001Tick()
end
____exports["取当前毫秒"] = function()
    return getServerTime()
end
return ____exports
