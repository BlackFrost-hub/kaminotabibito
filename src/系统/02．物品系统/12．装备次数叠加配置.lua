local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．颜色常量")
local _____53BB_9664_989C_8272_4EE3_7801 = ____require_result_0["去除颜色代码"]
local _____53EF_53E0_52A0_6B21_6570_88C5_5907_540D_79F0 = __TS__New(Set, {})
____exports["是否允许装备次数叠加"] = function(_____88C5_5907_540D)
    local _____89C4_8303_540D = __TS__StringTrim(_____53BB_9664_989C_8272_4EE3_7801(_____88C5_5907_540D or ""))
    if _____89C4_8303_540D == "" then
        return false
    end
    return _____53EF_53E0_52A0_6B21_6570_88C5_5907_540D_79F0:has(_____89C4_8303_540D)
end
return ____exports
