local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_0.SGSS_SetState
local CreateTimer = jass.CreateTimer
local GetExpiredTimer = jass.GetExpiredTimer
local GetHandleId = jass.GetHandleId
local DestroyTimer = jass.DestroyTimer
local TimerStart = jass.TimerStart
local _____4E34_65F6_9644_52A0_653B_51FB_8BA1_65F6_5668_8868 = {}
local function _____7EDD_5BF9_503C(_____6570_503C)
    return _____6570_503C >= 0 and _____6570_503C or -_____6570_503C
end
local function _____8C03_6574_5355_4F4D_9644_52A0_653B_51FB(_____5355_4F4D, _____6570_503C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    if _____6570_503C == 0 then
        return
    end
    SGSS_SetState(_____5355_4F4D, 1, _____6570_503C)
end
local function ____on_4E34_65F6_9644_52A0_653B_51FB_7ED3_675F()
    local _____8BA1_65F6_5668 = GetExpiredTimer()
    if _____8BA1_65F6_5668 == nil or _____8BA1_65F6_5668 == 0 then
        return
    end
    local _____8BA1_65F6_5668ID = GetHandleId(_____8BA1_65F6_5668)
    local _____5B9E_4F8B = _____4E34_65F6_9644_52A0_653B_51FB_8BA1_65F6_5668_8868[_____8BA1_65F6_5668ID]
    __TS__Delete(_____4E34_65F6_9644_52A0_653B_51FB_8BA1_65F6_5668_8868, _____8BA1_65F6_5668ID)
    DestroyTimer(_____8BA1_65F6_5668)
    if _____5B9E_4F8B == nil then
        return
    end
    _____8C03_6574_5355_4F4D_9644_52A0_653B_51FB(
        _____5B9E_4F8B["单位"],
        -_____7EDD_5BF9_503C(_____5B9E_4F8B["数值"])
    )
end
____exports["施加临时附加攻击"] = function(_____5355_4F4D, _____6570_503C, _____6301_7EED_65F6_95F4)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    if _____6570_503C == 0 or not (_____6301_7EED_65F6_95F4 > 0) then
        return
    end
    _____8C03_6574_5355_4F4D_9644_52A0_653B_51FB(_____5355_4F4D, _____6570_503C)
    local _____8BA1_65F6_5668 = CreateTimer()
    local _____8BA1_65F6_5668ID = GetHandleId(_____8BA1_65F6_5668)
    _____4E34_65F6_9644_52A0_653B_51FB_8BA1_65F6_5668_8868[_____8BA1_65F6_5668ID] = {["单位"] = _____5355_4F4D, ["数值"] = _____6570_503C}
    TimerStart(_____8BA1_65F6_5668, _____6301_7EED_65F6_95F4, false, ____on_4E34_65F6_9644_52A0_653B_51FB_7ED3_675F)
end
return ____exports
