local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却")
local _____53D6_88C5_5907_51B7_5374_952E = ____require_result_0["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____require_result_0["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____require_result_0["进入装备冷却并显示"]
local GetHandleId = jass.GetHandleId
local _____6267_884C_4E2D_8BB0_5F55 = {}
local function _____83B7_53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____751F_6210_72B6_6001_952E(_____540D_79F0, _____5355_4F4D)
    local id = _____83B7_53D6_53E5_67C4ID(_____5355_4F4D)
    if id <= 0 then
        return ""
    end
    return (_____540D_79F0 .. ":") .. tostring(id)
end
____exports["攻击效果是否在冷却中"] = function(_____540D_79F0, _____5355_4F4D, _____51B7_5374_6BEB_79D2)
    if not _____540D_79F0 or _____51B7_5374_6BEB_79D2 <= 0 then
        return false
    end
    local _____952E = _____53D6_88C5_5907_51B7_5374_952E(_____5355_4F4D, _____540D_79F0, "攻击效果")
    if _____952E == "" then
        return false
    end
    return _____88C5_5907_51B7_5374_4E2D(_____952E)
end
____exports["攻击效果进入冷却"] = function(_____540D_79F0, _____5355_4F4D, _____51B7_5374_6BEB_79D2)
    if _____51B7_5374_6BEB_79D2 == nil then
        _____51B7_5374_6BEB_79D2 = 0
    end
    if not (_____51B7_5374_6BEB_79D2 > 0) then
        return
    end
    local _____952E = _____53D6_88C5_5907_51B7_5374_952E(_____5355_4F4D, _____540D_79F0, "攻击效果")
    if _____952E == "" then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(_____952E, _____51B7_5374_6BEB_79D2 / 1000, _____5355_4F4D, _____540D_79F0)
end
____exports["攻击效果清除冷却"] = function(_____540D_79F0, _____5355_4F4D)
end
____exports["攻击效果是否正在执行"] = function(_____540D_79F0, _____5355_4F4D)
    local _____952E = _____751F_6210_72B6_6001_952E(_____540D_79F0, _____5355_4F4D)
    if _____952E == "" then
        return false
    end
    return _____6267_884C_4E2D_8BB0_5F55[_____952E] == true
end
____exports["攻击效果开始执行"] = function(_____540D_79F0, _____5355_4F4D)
    local _____952E = _____751F_6210_72B6_6001_952E(_____540D_79F0, _____5355_4F4D)
    if _____952E == "" then
        return false
    end
    if _____6267_884C_4E2D_8BB0_5F55[_____952E] == true then
        return false
    end
    _____6267_884C_4E2D_8BB0_5F55[_____952E] = true
    return true
end
____exports["攻击效果结束执行"] = function(_____540D_79F0, _____5355_4F4D)
    local _____952E = _____751F_6210_72B6_6001_952E(_____540D_79F0, _____5355_4F4D)
    if _____952E == "" then
        return
    end
    __TS__Delete(_____6267_884C_4E2D_8BB0_5F55, _____952E)
end
return ____exports
