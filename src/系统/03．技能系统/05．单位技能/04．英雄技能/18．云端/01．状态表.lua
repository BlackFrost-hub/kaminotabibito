--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____72B6_6001_8868 = {}
____exports["获取或创建云端状态"] = function(_____5355_4F4D)
    local id = GetHandleId(_____5355_4F4D)
    local record = _____72B6_6001_8868[id]
    if record == nil then
        record = {
            ["英雄句柄ID"] = id,
            ["施法者"] = _____5355_4F4D,
            ["W下一发为光剑"] = true,
            ["E冷却中"] = false,
            ["E冷却回调ID"] = 0
        }
        _____72B6_6001_8868[id] = record
    end
    return record
end
____exports["获取云端状态"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return _____72B6_6001_8868[GetHandleId(_____5355_4F4D)]
end
--- W 施法入口调用：取走本次光/暗分支并切换下一发状态（同步入口一次确定）。
____exports["消耗云端W模式"] = function(_____5355_4F4D)
    local record = ____exports["获取或创建云端状态"](_____5355_4F4D)
    local _____672C_6B21 = record["W下一发为光剑"] and "光剑" or "暗剑"
    record["W下一发为光剑"] = not record["W下一发为光剑"]
    return _____672C_6B21
end
____exports["云端E是否冷却中"] = function(_____5355_4F4D)
    local record = ____exports["获取云端状态"](_____5355_4F4D)
    return record ~= nil and record["E冷却中"] == true
end
____exports["设置云端E冷却"] = function(_____5355_4F4D, _____51B7_5374_4E2D)
    ____exports["获取或创建云端状态"](_____5355_4F4D)["E冷却中"] = _____51B7_5374_4E2D
end
return ____exports
