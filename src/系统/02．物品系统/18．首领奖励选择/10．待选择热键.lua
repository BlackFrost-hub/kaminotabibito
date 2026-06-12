--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local KEY_F = ____index.KEY_F
local registerKeyUpSync = ____index.registerKeyUpSync
local ____05_FF0E_5956_52B1_9009_62E9_754C_9762 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____5207_6362_9996_9886_5956_52B1_9009_62E9_754C_9762 = ____05_FF0E_5956_52B1_9009_62E9_754C_9762["切换首领奖励选择界面"]
local ____09_FF0E_5F85_9009_62E9_5956_52B1 = require("系统.02．物品系统.18．首领奖励选择.09．待选择奖励")
local _____83B7_53D6_9996_9886_5956_52B1_5F85_9009_62E9_8BB0_5F55 = ____09_FF0E_5F85_9009_62E9_5956_52B1["获取首领奖励待选择记录"]
---
-- @noSelfInFile
local jass = require("jass.common")
local _____70ED_952E_5DF2_6CE8_518C = false
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local function _____63D0_793A_73A9_5BB6(_____73A9_5BB6, _____6587_672C)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    DisplayTimedTextToPlayer(
        _____73A9_5BB6,
        0,
        0,
        6,
        "|cffffcc00[首领奖励]|r " .. _____6587_672C
    )
end
local function ____F7_6253_5F00_5F85_9009_62E9_9996_9886_5956_52B1(self, _____73A9_5BB6, _key)
    local _____8BB0_5F55 = _____83B7_53D6_9996_9886_5956_52B1_5F85_9009_62E9_8BB0_5F55(_____73A9_5BB6)
    if _____8BB0_5F55 == nil then
        _____63D0_793A_73A9_5BB6(_____73A9_5BB6, "当前没有待选择的首领奖励。")
        return
    end
    _____5207_6362_9996_9886_5956_52B1_9009_62E9_754C_9762(_____8BB0_5F55["奖励池ID"], _____73A9_5BB6)
end
____exports["注册首领奖励待选择热键"] = function()
    if _____70ED_952E_5DF2_6CE8_518C then
        return
    end
    _____70ED_952E_5DF2_6CE8_518C = true
    registerKeyUpSync(nil, KEY_F.F7, ____F7_6253_5F00_5F85_9009_62E9_9996_9886_5956_52B1)
end
return ____exports
