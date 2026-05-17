--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____require_result_0["广播提示玩家槽数"]
local _____5E7F_64AD_63D0_793A_5587_53ED_5934_50CF = ____require_result_0["广播提示喇叭头像"]
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6 = ____require_result_1["发送头像提示给玩家"]
local ____require_result_2 = require("系统.09．表现系统.06．广播提示消息.01．头像读取")
local _____53D6_5355_4F4D_7C7B_578BArt_5934_50CF = ____require_result_2["取单位类型Art头像"]
local Player = jass.Player
local GetUnitTypeId = jass.GetUnitTypeId
____exports["广播单位类型提示"] = function(_____5355_4F4D_7C7B_578BID, _____6587_672C, _____6301_7EED_65F6_95F4)
    if not _____5355_4F4D_7C7B_578BID or not _____6587_672C then
        return
    end
    local ____Art_5934_50CF_8DEF_5F84 = _____53D6_5355_4F4D_7C7B_578BArt_5934_50CF(_____5355_4F4D_7C7B_578BID)
    local _____5934_50CF_8DEF_5F84 = ____Art_5934_50CF_8DEF_5F84 ~= "" and ____Art_5934_50CF_8DEF_5F84 or _____5E7F_64AD_63D0_793A_5587_53ED_5934_50CF
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(
                Player(_____73A9_5BB6ID),
                _____5934_50CF_8DEF_5F84,
                _____6587_672C,
                _____6301_7EED_65F6_95F4
            )
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
____exports["广播宝箱主人提示"] = function(_____4E3B_4EBA_5355_4F4D, _____6587_672C, _____6301_7EED_65F6_95F4)
    if not _____4E3B_4EBA_5355_4F4D then
        return
    end
    ____exports["广播单位类型提示"](
        GetUnitTypeId(_____4E3B_4EBA_5355_4F4D),
        _____6587_672C,
        _____6301_7EED_65F6_95F4
    )
end
____exports.broadcastUnitTypeHint = ____exports["广播单位类型提示"]
____exports.broadcastChestOwnerHint = ____exports["广播宝箱主人提示"]
return ____exports
