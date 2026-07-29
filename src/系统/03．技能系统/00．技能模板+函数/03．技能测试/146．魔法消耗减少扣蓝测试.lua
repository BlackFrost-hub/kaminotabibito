--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_3["减少魔法值"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local GetPlayerId = jass.GetPlayerId
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local _____6A21_5757_540D = "魔法消耗减少扣蓝测试"
local _____6D4B_8BD5_547D_4EE4 = "146"
local _____9B54_6CD5_6D88_8017_51CF_5C11 = 0.2
local _____6D4B_8BD5_6263_84DD_503C = 100
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
local function _____8BFB_53D6_5F53_524D_9B54_6CD5(unit)
    return GetUnitState(unit, UNIT_STATE_MANA)
end
local function _____8BFB_53D6_6700_5927_9B54_6CD5(unit)
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA)
end
local function ____on_804A_5929146_9B54_6CD5_6D88_8017_51CF_5C11_6263_84DD_6D4B_8BD5(player, _command)
    local _____5927_6CD5_5E08 = getRegisteredPlayerHero(player)
    if not _____5355_4F4D_6709_6548(_____5927_6CD5_5E08) then
        debugLogForce(_____6A21_5757_540D, "测试失败：当前玩家没有注册玩家英雄，无法验证只对玩家英雄生效的魔法消耗减少")
        return
    end
    local _____6700_5927_9B54_6CD5 = _____8BFB_53D6_6700_5927_9B54_6CD5(_____5927_6CD5_5E08)
    SetUnitState(_____5927_6CD5_5E08, UNIT_STATE_MANA, _____6700_5927_9B54_6CD5)
    YDUserDataSetSafe(
        "player",
        player,
        "魔法消耗",
        "real",
        _____9B54_6CD5_6D88_8017_51CF_5C11
    )
    local _____5199_5165_540E_5C5E_6027 = YDUserDataGetSafe("player", player, "魔法消耗", "real")
    local _____6263_9664_524D_9B54_6CD5 = _____8BFB_53D6_5F53_524D_9B54_6CD5(_____5927_6CD5_5E08)
    local _____5B9E_9645_53D8_5316 = _____51CF_5C11_9B54_6CD5_503C(_____5927_6CD5_5E08, _____6D4B_8BD5_6263_84DD_503C, true, true)
    local _____6263_9664_540E_9B54_6CD5 = _____8BFB_53D6_5F53_524D_9B54_6CD5(_____5927_6CD5_5E08)
    debugLogForce(
        _____6A21_5757_540D,
        "完成",
        "playerId=",
        GetPlayerId(player),
        "魔法消耗减少=",
        _____5199_5165_540E_5C5E_6027,
        "请求扣蓝=",
        _____6D4B_8BD5_6263_84DD_503C,
        "预期实际扣蓝=",
        80,
        "实际变化=",
        _____5B9E_9645_53D8_5316,
        "扣除前=",
        _____6263_9664_524D_9B54_6CD5,
        "扣除后=",
        _____6263_9664_540E_9B54_6CD5
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929146_9B54_6CD5_6D88_8017_51CF_5C11_6263_84DD_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "给当前玩家英雄写入20%魔法消耗减少，并请求扣100蓝")
return ____exports
