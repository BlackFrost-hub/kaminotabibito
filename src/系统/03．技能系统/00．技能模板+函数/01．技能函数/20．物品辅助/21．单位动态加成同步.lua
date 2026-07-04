local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local function _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
____exports["创建单位动态加成同步器"] = function(_____5E94_7528_56DE_8C03)
    local _____72B6_6001_8868 = {}
    local function _____6E05_7406(_____5355_4F4D)
        local id = _____53D6_5355_4F4DID(_____5355_4F4D)
        if id == 0 then
            return
        end
        local _____5F53_524D = _____72B6_6001_8868[id]
        if _____5F53_524D ~= nil and _____5F53_524D["数值"] ~= 0 then
            _____5E94_7528_56DE_8C03(_____5355_4F4D, _____5F53_524D["键"], -_____5F53_524D["数值"])
        end
        __TS__Delete(_____72B6_6001_8868, id)
    end
    local function _____540C_6B65(_____5355_4F4D, _____952E, _____6570_503C)
        local id = _____53D6_5355_4F4DID(_____5355_4F4D)
        if id == 0 then
            return
        end
        local _____5F53_524D = _____72B6_6001_8868[id]
        local _____4E0B_6B21_6570_503C = _____6570_503C or 0
        if _____952E == nil or _____4E0B_6B21_6570_503C == 0 then
            _____6E05_7406(_____5355_4F4D)
            return
        end
        if _____5F53_524D ~= nil and _____5F53_524D["键"] == _____952E then
            local _____589E_91CF = _____4E0B_6B21_6570_503C - _____5F53_524D["数值"]
            if _____589E_91CF ~= 0 then
                _____5E94_7528_56DE_8C03(_____5355_4F4D, _____952E, _____589E_91CF)
                _____5F53_524D["数值"] = _____4E0B_6B21_6570_503C
            end
            return
        end
        if _____5F53_524D ~= nil and _____5F53_524D["数值"] ~= 0 then
            _____5E94_7528_56DE_8C03(_____5355_4F4D, _____5F53_524D["键"], -_____5F53_524D["数值"])
        end
        _____5E94_7528_56DE_8C03(_____5355_4F4D, _____952E, _____4E0B_6B21_6570_503C)
        _____72B6_6001_8868[id] = {["键"] = _____952E, ["数值"] = _____4E0B_6B21_6570_503C}
    end
    local function _____8BFB_53D6(_____5355_4F4D)
        local id = _____53D6_5355_4F4DID(_____5355_4F4D)
        if id == 0 then
            return nil
        end
        return _____72B6_6001_8868[id] or nil
    end
    return {["同步"] = _____540C_6B65, ["清理"] = _____6E05_7406, ["读取"] = _____8BFB_53D6}
end
return ____exports
