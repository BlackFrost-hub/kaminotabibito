local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["创建单位驻留进度"] = function(_____540D_79F0, _____5141_8BB8_4F4D_79FB_8DDD_79BB)
    local _____8BB0_5F55_8868 = {}
    local _____6709_6548_4F4D_79FB_8DDD_79BB = _____5141_8BB8_4F4D_79FB_8DDD_79BB > 0 and _____5141_8BB8_4F4D_79FB_8DDD_79BB or 0
    local _____4F4D_79FB_8DDD_79BB_5E73_65B9 = _____6709_6548_4F4D_79FB_8DDD_79BB * _____6709_6548_4F4D_79FB_8DDD_79BB
    return {
        ["名称"] = _____540D_79F0,
        ["采样"] = function(unit, _____589E_91CF)
            if _____589E_91CF == nil then
                _____589E_91CF = 1
            end
            local id = _____53D6_5355_4F4DID(unit)
            if id == 0 then
                return 0
            end
            local x = GetUnitX(unit)
            local y = GetUnitY(unit)
            local _____8BB0_5F55 = _____8BB0_5F55_8868[id]
            if _____8BB0_5F55 == nil or (x - _____8BB0_5F55.X) * (x - _____8BB0_5F55.X) + (y - _____8BB0_5F55.Y) * (y - _____8BB0_5F55.Y) > _____4F4D_79FB_8DDD_79BB_5E73_65B9 then
                _____8BB0_5F55 = {X = x, Y = y, ["进度"] = 0}
                _____8BB0_5F55_8868[id] = _____8BB0_5F55
            end
            _____8BB0_5F55["进度"] = _____8BB0_5F55["进度"] + _____589E_91CF
            return _____8BB0_5F55["进度"]
        end,
        ["读取"] = function(unit)
            local ____opt_0 = _____8BB0_5F55_8868[_____53D6_5355_4F4DID(unit)]
            return ____opt_0 and ____opt_0["进度"] or 0
        end,
        ["清空"] = function(unit)
            if unit == nil then
                _____8BB0_5F55_8868 = {}
                return
            end
            __TS__Delete(
                _____8BB0_5F55_8868,
                _____53D6_5355_4F4DID(unit)
            )
        end
    }
end
return ____exports
