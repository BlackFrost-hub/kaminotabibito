--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_0["广播单位提示"]
local GetRandomInt = jass.GetRandomInt
____exports["取Boss台词文本"] = function(_____53F0_8BCD_8868, _____7C7B_578B, index)
    local lines = _____53F0_8BCD_8868[_____7C7B_578B]
    if lines == nil or #lines <= 0 then
        return nil
    end
    local lineIndex = index or GetRandomInt(0, #lines - 1)
    return lines[lineIndex + 1] or lines[1]
end
____exports["播放Boss台词广播"] = function(_____6765_6E90_5355_4F4D, _____53F0_8BCD_8868, _____7C7B_578B, _____6301_7EED_65F6_95F4Ms, index)
    local text = ____exports["取Boss台词文本"](_____53F0_8BCD_8868, _____7C7B_578B, index)
    if text == nil or text == "" then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____6765_6E90_5355_4F4D, text, _____6301_7EED_65F6_95F4Ms)
end
return ____exports
