local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
--- 可充能层数 Buff 的统一显示：有层时显示层持续时间，0 层时显示下次充能时间。
-- 当前层数会原样写入 Buff UI，因此支持 0 层角标。
____exports["同步可充能层数Buff"] = function(_____53C2_6570)
    if _____53C2_6570["单位"] == nil or _____53C2_6570["单位"] == 0 or _____53C2_6570.BuffID == "" then
        return
    end
    local _____5F53_524D_5C42_6570 = _____53C2_6570["当前层数"] > 0 and _____53C2_6570["当前层数"] or 0
    local _____663E_793A_5269_4F59_6BEB_79D2 = _____5F53_524D_5C42_6570 > 0 and _____53C2_6570["有层剩余毫秒"] or _____53C2_6570["下次充能剩余毫秒"]
    local _____6700_77ED_663E_793A_6BEB_79D2 = _____53C2_6570["最短显示毫秒"] ~= nil and _____53C2_6570["最短显示毫秒"] > 0 and _____53C2_6570["最短显示毫秒"] or 100
    if _____663E_793A_5269_4F59_6BEB_79D2 <= 0 then
        _____663E_793A_5269_4F59_6BEB_79D2 = _____6700_77ED_663E_793A_6BEB_79D2
    end
    local ____registerManualBuff_3 = registerManualBuff
    local ____array_2 = __TS__SparseArrayNew(_____53C2_6570["单位"], _____53C2_6570.BuffID, _____663E_793A_5269_4F59_6BEB_79D2 / 1000, _____53C2_6570["Buff显示值"])
    local ____53C2_6570_Buff_9644_52A0_53C2_6570_1 = _____53C2_6570["Buff附加参数"]
    if ____53C2_6570_Buff_9644_52A0_53C2_6570_1 == nil then
        ____53C2_6570_Buff_9644_52A0_53C2_6570_1 = {}
    end
    __TS__SparseArrayPush(
        ____array_2,
        __TS__ObjectAssign({}, ____53C2_6570_Buff_9644_52A0_53C2_6570_1, {stack = _____5F53_524D_5C42_6570, allowZeroStack = true})
    )
    ____registerManualBuff_3(__TS__SparseArraySpread(____array_2))
end
____exports["清除可充能层数Buff"] = function(_____5355_4F4D, BuffID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or BuffID == "" then
        return false
    end
    return _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____5355_4F4D, BuffID)
end
return ____exports
