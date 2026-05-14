local ____lualib = require("lualib_bundle")
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_9ED8_8BA4_5934_50CF = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示默认头像"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ydwe = require("lib.扩展函数.YDWE函数.index")
local GetUnitTypeId = jass.GetUnitTypeId
local getObjectProperty = ydwe.getObjectProperty
local ObjectType = ydwe.ObjectType
local _____5355_4F4D_5934_50CF_7F13_5B58 = {}
local function _____662F_8D34_56FE_8DEF_5F84(_____8DEF_5F84)
    if _____8DEF_5F84 == nil or _____8DEF_5F84 == "" then
        return false
    end
    local _____5C0F_5199_8DEF_5F84 = string.lower(_____8DEF_5F84)
    return __TS__StringEndsWith(_____5C0F_5199_8DEF_5F84, ".blp") or __TS__StringEndsWith(_____5C0F_5199_8DEF_5F84, ".dds") or __TS__StringEndsWith(_____5C0F_5199_8DEF_5F84, ".tga")
end
____exports["取单位类型头像"] = function(_____5355_4F4D_7C7B_578BID)
    if _____5355_4F4D_7C7B_578BID == nil or _____5355_4F4D_7C7B_578BID == 0 then
        return _____5E7F_64AD_63D0_793A_9ED8_8BA4_5934_50CF
    end
    local _____7F13_5B58 = _____5355_4F4D_5934_50CF_7F13_5B58[_____5355_4F4D_7C7B_578BID]
    if _____7F13_5B58 ~= nil then
        return _____7F13_5B58
    end
    local _____7F8E_672F_8DEF_5F84 = getObjectProperty(ObjectType.UNIT, _____5355_4F4D_7C7B_578BID, "Art")
    if _____662F_8D34_56FE_8DEF_5F84(_____7F8E_672F_8DEF_5F84) then
        _____5355_4F4D_5934_50CF_7F13_5B58[_____5355_4F4D_7C7B_578BID] = _____7F8E_672F_8DEF_5F84
        return _____7F8E_672F_8DEF_5F84
    end
    local _____56FE_6807_8DEF_5F84 = getObjectProperty(ObjectType.UNIT, _____5355_4F4D_7C7B_578BID, "uico")
    if _____662F_8D34_56FE_8DEF_5F84(_____56FE_6807_8DEF_5F84) then
        _____5355_4F4D_5934_50CF_7F13_5B58[_____5355_4F4D_7C7B_578BID] = _____56FE_6807_8DEF_5F84
        return _____56FE_6807_8DEF_5F84
    end
    _____5355_4F4D_5934_50CF_7F13_5B58[_____5355_4F4D_7C7B_578BID] = _____5E7F_64AD_63D0_793A_9ED8_8BA4_5934_50CF
    return _____5E7F_64AD_63D0_793A_9ED8_8BA4_5934_50CF
end
____exports["取单位头像"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return _____5E7F_64AD_63D0_793A_9ED8_8BA4_5934_50CF
    end
    return ____exports["取单位类型头像"](GetUnitTypeId(_____5355_4F4D))
end
return ____exports
