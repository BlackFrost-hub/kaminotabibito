local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____83B7_53D6_53E5_67C4ID = jass.GetHandleId
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local _____6A21_5757_540D = "克劳德-联动"
local _____51F6_65A9_547D_4E2D_8868 = {}
local _____7A7A_7259Q_8054_52A8_8868 = {}
local function _____53D6_952E(_____65BD_6CD5_8005, _____76EE_6807)
    return (tostring(_____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005)) .. "|") .. tostring(_____83B7_53D6_53E5_67C4ID(_____76EE_6807))
end
local function _____6E05_7406_51F6_65A9_547D_4E2D_6807_8BB0(variable)
    local record = variable
    if record == nil then
        return
    end
    local key = _____53D6_952E(record["施法者"], record["目标"])
    if _____51F6_65A9_547D_4E2D_8868[key] == record then
        __TS__Delete(_____51F6_65A9_547D_4E2D_8868, key)
    end
end
____exports["标记凶斩命中"] = function(_____65BD_6CD5_8005, _____76EE_6807, _____6301_7EED_79D2)
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = 5
    end
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        debugLogForce(
            _____6A21_5757_540D,
            "标记凶斩命中 参数无效",
            "施法者",
            _____65BD_6CD5_8005,
            "目标",
            _____76EE_6807
        )
        return
    end
    local key = _____53D6_952E(_____65BD_6CD5_8005, _____76EE_6807)
    local old = _____51F6_65A9_547D_4E2D_8868[key]
    local record = {["施法者"] = _____65BD_6CD5_8005, ["目标"] = _____76EE_6807, ["版本"] = (old and old["版本"] or 0) + 1}
    _____51F6_65A9_547D_4E2D_8868[key] = record
    debugLogForce(
        _____6A21_5757_540D,
        "标记凶斩命中",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005),
        "目标",
        _____83B7_53D6_53E5_67C4ID(_____76EE_6807),
        "版本",
        record["版本"],
        "持续秒",
        _____6301_7EED_79D2
    )
    addDelayedCallback(_____6301_7EED_79D2 * 1000, _____6E05_7406_51F6_65A9_547D_4E2D_6807_8BB0, record)
end
____exports["读取凶斩命中"] = function(_____65BD_6CD5_8005, _____76EE_6807)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    local _____547D_4E2D = _____51F6_65A9_547D_4E2D_8868[_____53D6_952E(_____65BD_6CD5_8005, _____76EE_6807)] ~= nil
    debugLogForce(
        _____6A21_5757_540D,
        "读取凶斩命中",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005),
        "目标",
        _____83B7_53D6_53E5_67C4ID(_____76EE_6807),
        "命中",
        _____547D_4E2D
    )
    return _____547D_4E2D
end
____exports["设置空牙Q联动"] = function(_____65BD_6CD5_8005, _____65B9_5411_89D2, _____76EE_6807_5217_8868)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        debugLogForce(_____6A21_5757_540D, "设置空牙Q联动 施法者无效", "施法者", _____65BD_6CD5_8005)
        return
    end
    _____7A7A_7259Q_8054_52A8_8868[_____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005)] = {["施法者"] = _____65BD_6CD5_8005, ["方向角"] = _____65B9_5411_89D2, ["目标列表"] = _____76EE_6807_5217_8868, ["进行中"] = true}
    debugLogForce(
        _____6A21_5757_540D,
        "设置空牙Q联动",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005),
        "方向角",
        _____65B9_5411_89D2,
        "目标数",
        #_____76EE_6807_5217_8868
    )
end
____exports["获取空牙Q联动"] = function(_____65BD_6CD5_8005)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        return nil
    end
    local record = _____7A7A_7259Q_8054_52A8_8868[_____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005)]
    local _____6709_6548 = (record and record["进行中"]) == true
    debugLogForce(
        _____6A21_5757_540D,
        "获取空牙Q联动",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005),
        "有效",
        _____6709_6548
    )
    return _____6709_6548 and record or nil
end
____exports["消耗空牙Q联动"] = function(_____65BD_6CD5_8005)
    local record = ____exports["获取空牙Q联动"](_____65BD_6CD5_8005)
    if record ~= nil then
        record["进行中"] = false
        debugLogForce(
            _____6A21_5757_540D,
            "消耗空牙Q联动 成功",
            "施法者",
            _____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005),
            "目标数",
            #record["目标列表"]
        )
    else
        debugLogForce(
            _____6A21_5757_540D,
            "消耗空牙Q联动 无记录",
            "施法者",
            (_____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0) and "nil" or _____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005)
        )
    end
    return record
end
____exports["清理空牙Q联动"] = function(_____65BD_6CD5_8005)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "清理空牙Q联动",
        "施法者",
        _____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005)
    )
    __TS__Delete(
        _____7A7A_7259Q_8054_52A8_8868,
        _____83B7_53D6_53E5_67C4ID(_____65BD_6CD5_8005)
    )
end
return ____exports
