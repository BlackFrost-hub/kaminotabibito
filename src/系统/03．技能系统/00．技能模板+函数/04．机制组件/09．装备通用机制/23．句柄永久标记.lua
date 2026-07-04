local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local function _____53D6_53E5_67C4_952E(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
____exports["创建句柄永久标记"] = function(_____540D_79F0)
    local _____8868 = {}
    return {
        ["名称"] = _____540D_79F0,
        ["标记"] = function(handle)
            local id = _____53D6_53E5_67C4_952E(handle)
            if id ~= 0 then
                _____8868[id] = true
            end
        end,
        ["存在"] = function(handle)
            local id = _____53D6_53E5_67C4_952E(handle)
            return id ~= 0 and _____8868[id] == true
        end,
        ["标记若不存在"] = function(handle)
            local id = _____53D6_53E5_67C4_952E(handle)
            if id == 0 or _____8868[id] == true then
                return false
            end
            _____8868[id] = true
            return true
        end,
        ["清空"] = function(handle)
            if handle == nil then
                _____8868 = {}
                return
            end
            __TS__Delete(
                _____8868,
                _____53D6_53E5_67C4_952E(handle)
            )
        end
    }
end
return ____exports
