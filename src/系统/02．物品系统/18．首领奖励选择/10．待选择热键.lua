--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local KEY_F = ____index.KEY_F
local KEY_STATE = ____index.KEY_STATE
local ____05_FF0E_5956_52B1_9009_62E9_754C_9762 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____5207_6362_9996_9886_5956_52B1_9009_62E9_754C_9762 = ____05_FF0E_5956_52B1_9009_62E9_754C_9762["切换首领奖励选择界面"]
local ____09_FF0E_5F85_9009_62E9_5956_52B1 = require("系统.02．物品系统.18．首领奖励选择.09．待选择奖励")
local _____83B7_53D6_9996_9886_5956_52B1_5F85_9009_62E9_8BB0_5F55 = ____09_FF0E_5F85_9009_62E9_5956_52B1["获取首领奖励待选择记录"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local _____70ED_952E_5DF2_6CE8_518C = false
local ____F7_672C_673A_6309_952E_89E6_53D1_5668 = nil
local ____F7_540C_6B65_89E6_53D1_5668 = nil
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local DzTriggerRegisterKeyEventByCode = japi.DzTriggerRegisterKeyEventByCode
local DzTriggerRegisterSyncData = japi.DzTriggerRegisterSyncData
local DzSyncData = japi.DzSyncData
local DzGetTriggerSyncPlayer = japi.DzGetTriggerSyncPlayer
local DzIsChatBoxOpen = japi.DzIsChatBoxOpen
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____F7_540C_6B65_524D_7F00 = "BRF7"
local ____F7_8C03_8BD5_6A21_5757 = "首领奖励F7诊断"
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
local function ____F7_672C_673A_6309_952E()
    local _____804A_5929_6846_6253_5F00 = DzIsChatBoxOpen() == true
    debugLogForce(____F7_8C03_8BD5_6A21_5757, "本机F7回调", "聊天框", _____804A_5929_6846_6253_5F00)
    if _____804A_5929_6846_6253_5F00 then
        return
    end
    DzSyncData(____F7_540C_6B65_524D_7F00, "1")
end
local function ____F7_5207_6362_5F85_9009_62E9_9996_9886_5956_52B1()
    local _____73A9_5BB6 = DzGetTriggerSyncPlayer()
    local _____8BB0_5F55 = _____83B7_53D6_9996_9886_5956_52B1_5F85_9009_62E9_8BB0_5F55(_____73A9_5BB6)
    debugLogForce(____F7_8C03_8BD5_6A21_5757, "收到同步消息", "待选择记录", _____8BB0_5F55 ~= nil)
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
    ____F7_540C_6B65_89E6_53D1_5668 = CreateTrigger()
    TriggerAddAction(____F7_540C_6B65_89E6_53D1_5668, ____F7_5207_6362_5F85_9009_62E9_9996_9886_5956_52B1)
    DzTriggerRegisterSyncData(____F7_540C_6B65_89E6_53D1_5668, ____F7_540C_6B65_524D_7F00, false)
    ____F7_672C_673A_6309_952E_89E6_53D1_5668 = CreateTrigger()
    DzTriggerRegisterKeyEventByCode(
        ____F7_672C_673A_6309_952E_89E6_53D1_5668,
        KEY_F.F7,
        KEY_STATE.DOWN,
        false,
        ____F7_672C_673A_6309_952E
    )
    debugLogForce(____F7_8C03_8BD5_6A21_5757, "初始化完成")
end
return ____exports
