local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____72B6_6001_8868 = {}
____exports["获取或创建黑崎一护状态"] = function(_____5355_4F4D)
    local id = GetHandleId(_____5355_4F4D)
    local record = _____72B6_6001_8868[id]
    if record == nil then
        record = {
            ["英雄句柄ID"] = id,
            ["施法者"] = _____5355_4F4D,
            ["卍解"] = false,
            ["卍解倒计时回调ID"] = 0,
            ["移速已突破"] = false,
            ["A键已武装"] = false,
            ["瞬步连携"] = false,
            ["连携窗口回调ID"] = 0,
            ["月牙飞行中"] = false,
            ["月牙X"] = 0,
            ["月牙Y"] = 0
        }
        _____72B6_6001_8868[id] = record
    end
    return record
end
____exports["获取黑崎一护状态"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return _____72B6_6001_8868[GetHandleId(_____5355_4F4D)]
end
____exports["黑崎一护是否卍解"] = function(_____5355_4F4D)
    local record = ____exports["获取黑崎一护状态"](_____5355_4F4D)
    return record ~= nil and record["卍解"] == true
end
____exports["设置黑崎一护卍解"] = function(_____5355_4F4D, _____5F00_542F)
    local record = ____exports["获取或创建黑崎一护状态"](_____5355_4F4D)
    record["卍解"] = _____5F00_542F
end
____exports["武装黑崎一护A键"] = function(_____5355_4F4D)
    ____exports["获取或创建黑崎一护状态"](_____5355_4F4D)["A键已武装"] = true
end
____exports["解除黑崎一护A键武装"] = function(_____5355_4F4D)
    local record = ____exports["获取黑崎一护状态"](_____5355_4F4D)
    if record ~= nil then
        record["A键已武装"] = false
    end
end
____exports["黑崎一护A键是否武装"] = function(_____5355_4F4D)
    local record = ____exports["获取黑崎一护状态"](_____5355_4F4D)
    return record ~= nil and record["A键已武装"] == true
end
____exports["开启瞬步连携"] = function(_____5355_4F4D)
    ____exports["获取或创建黑崎一护状态"](_____5355_4F4D)["瞬步连携"] = true
end
____exports["关闭瞬步连携"] = function(_____5355_4F4D)
    local record = ____exports["获取黑崎一护状态"](_____5355_4F4D)
    if record ~= nil then
        record["瞬步连携"] = false
    end
end
____exports["是否瞬步连携中"] = function(_____5355_4F4D)
    local record = ____exports["获取黑崎一护状态"](_____5355_4F4D)
    return record ~= nil and record["瞬步连携"] == true
end
____exports["记录月牙位置"] = function(_____5355_4F4D, x, y)
    local record = ____exports["获取或创建黑崎一护状态"](_____5355_4F4D)
    record["月牙飞行中"] = true
    record["月牙X"] = x
    record["月牙Y"] = y
end
____exports["清除月牙位置"] = function(_____5355_4F4D)
    local record = ____exports["获取黑崎一护状态"](_____5355_4F4D)
    if record == nil then
        return
    end
    record["月牙飞行中"] = false
end
____exports["月牙是否飞行中"] = function(_____5355_4F4D)
    local record = ____exports["获取黑崎一护状态"](_____5355_4F4D)
    return record ~= nil and record["月牙飞行中"] == true
end
____exports["清理黑崎一护状态"] = function(_____5355_4F4D)
    local id = GetHandleId(_____5355_4F4D)
    __TS__Delete(_____72B6_6001_8868, id)
end
return ____exports
