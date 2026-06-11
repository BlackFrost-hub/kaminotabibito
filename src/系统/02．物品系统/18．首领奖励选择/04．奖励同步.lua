local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
---
-- @noSelfInFile
____exports["首领奖励同步前缀"] = "首领奖励领取"
____exports["首领奖励同步分隔符"] = "|"
____exports["编码首领奖励同步请求"] = function(_____8BF7_6C42)
    local _____5185_5BB9 = _____8BF7_6C42["奖励池ID"]
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < #_____8BF7_6C42["已选装备名"] do
            _____5185_5BB9 = (_____5185_5BB9 .. ____exports["首领奖励同步分隔符"]) .. _____8BF7_6C42["已选装备名"][_____5E8F_53F7 + 1]
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    return _____5185_5BB9
end
____exports["解码首领奖励同步请求"] = function(_____5185_5BB9)
    local _____5206_6BB5 = __TS__StringSplit(_____5185_5BB9, ____exports["首领奖励同步分隔符"])
    local _____5DF2_9009_88C5_5907_540D = {}
    do
        local _____5E8F_53F7 = 1
        while _____5E8F_53F7 < #_____5206_6BB5 do
            _____5DF2_9009_88C5_5907_540D[#_____5DF2_9009_88C5_5907_540D + 1] = _____5206_6BB5[_____5E8F_53F7 + 1]
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    return {["奖励池ID"] = _____5206_6BB5[1] or "", ["已选装备名"] = _____5DF2_9009_88C5_5907_540D}
end
return ____exports
