local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local IsUnitType = jass.IsUnitType
local _____9636_6BB5_72B6_6001_8868 = {}
local function _____6E05_7406Boss_9636_6BB5_72B6_6001(_____53D8_91CF)
    local _____72B6_6001 = _____53D8_91CF
    local id = GetHandleId(_____72B6_6001["单位"])
    if _____9636_6BB5_72B6_6001_8868[id] == _____72B6_6001 then
        __TS__Delete(_____9636_6BB5_72B6_6001_8868, id)
    end
end
____exports["注册Boss阶段状态"] = function(_____5355_4F4D, _____9636_6BB5_9608_503C, _____8BFB_53D6_9636_6BB5_5E8F_53F7, _____4E0A_4E0B_6587, _____6E05_7406)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____72B6_6001 = {["单位"] = _____5355_4F4D, ["阶段阈值"] = _____9636_6BB5_9608_503C, ["读取阶段序号"] = _____8BFB_53D6_9636_6BB5_5E8F_53F7, ["上下文"] = _____4E0A_4E0B_6587}
    _____9636_6BB5_72B6_6001_8868[GetHandleId(_____5355_4F4D)] = _____72B6_6001
    _____6E05_7406["登记清理"](_____6E05_7406, "Boss阶段状态", _____6E05_7406Boss_9636_6BB5_72B6_6001, _____72B6_6001)
end
--- 读取实际已进入阶段，不从回血后的生命值反推阶段。
____exports["读取Boss当前阶段阈值"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or GetUnitTypeId(_____5355_4F4D) == 0 or IsUnitType(_____5355_4F4D, jass.UNIT_TYPE_DEAD) then
        return nil
    end
    local _____72B6_6001 = _____9636_6BB5_72B6_6001_8868[GetHandleId(_____5355_4F4D)]
    if _____72B6_6001 == nil or _____72B6_6001["单位"] ~= _____5355_4F4D then
        return nil
    end
    local _____9636_6BB5 = _____72B6_6001["读取阶段序号"](_____72B6_6001["上下文"])
    if _____9636_6BB5 >= 4 and _____72B6_6001["阶段阈值"]["P4生命比例"] ~= nil then
        return _____72B6_6001["阶段阈值"]["P4生命比例"]
    end
    if _____9636_6BB5 >= 3 and _____72B6_6001["阶段阈值"]["P3生命比例"] ~= nil then
        return _____72B6_6001["阶段阈值"]["P3生命比例"]
    end
    if _____9636_6BB5 >= 2 and _____72B6_6001["阶段阈值"]["P2生命比例"] ~= nil then
        return _____72B6_6001["阶段阈值"]["P2生命比例"]
    end
    return 1
end
--- 数字阶段上下文共用此读取器；特殊阶段只在注册处转换一次。
____exports["读取Boss阶段序号"] = function(_____4E0A_4E0B_6587)
    return _____4E0A_4E0B_6587["阶段"]
end
return ____exports
