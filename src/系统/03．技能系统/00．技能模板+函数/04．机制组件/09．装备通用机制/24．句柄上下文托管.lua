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
____exports["创建句柄上下文托管器"] = function(_____540D_79F0)
    local _____8868 = {}
    return {
        ["名称"] = _____540D_79F0,
        ["写入"] = function(handle, _____4E0A_4E0B_6587)
            local id = _____53D6_53E5_67C4_952E(handle)
            if id ~= 0 then
                _____8868[id] = _____4E0A_4E0B_6587
            end
        end,
        ["读取"] = function(handle)
            local id = _____53D6_53E5_67C4_952E(handle)
            if id == 0 then
                return nil
            end
            return _____8868[id]
        end,
        ["取出"] = function(handle)
            local id = _____53D6_53E5_67C4_952E(handle)
            if id == 0 then
                return nil
            end
            local _____4E0A_4E0B_6587 = _____8868[id]
            __TS__Delete(_____8868, id)
            return _____4E0A_4E0B_6587
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
