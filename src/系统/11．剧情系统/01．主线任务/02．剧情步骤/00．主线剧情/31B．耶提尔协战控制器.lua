--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local _____6267_884C_901A_7528_5267_60C5_52A8_4F5C = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["执行通用剧情动作"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local registerImmediateOrderListener = ____require_result_0.registerImmediateOrderListener
local registerPointOrderListener = ____require_result_0.registerPointOrderListener
local registerTargetOrderListener = ____require_result_0.registerTargetOrderListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_2["广播单位提示"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local ____require_result_4 = require("系统.00．核心系统.07．联机安全工具")
local safeForForce = ____require_result_4.safeForForce
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerOneShotUnitRangeListener = ____require_result_5.registerOneShotUnitRangeListener
local ____require_result_6 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_6["是玩家英雄组单位"]
local ____require_result_7 = require("系统.02．物品系统.18．首领奖励选择.08．奖励物品发放")
local _____53D1_653E_9996_9886_5956_52B1_88C5_5907 = ____require_result_7["发放首领奖励装备"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.11．装备常量")
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____require_result_8["第二章后段Boss战利品装备名"]
local GetDestructableX = jass.GetDestructableX
local GetDestructableY = jass.GetDestructableY
local GetItemX = jass.GetItemX
local GetItemY = jass.GetItemY
local GetEnumPlayer = jass.GetEnumPlayer
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerState = jass.GetPlayerState
local GetRandomInt = jass.GetRandomInt
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssueTargetOrder = jass.IssueTargetOrder
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitOwner = jass.SetUnitOwner
local SetUnitPosition = jass.SetUnitPosition
local SetPlayerState = jass.SetPlayerState
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PLAYER_STATE_RESOURCE_LUMBER = jass.PLAYER_STATE_RESOURCE_LUMBER
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local bj_QUESTMESSAGE_ITEMACQUIRED = require("jass.globals").bj_QUESTMESSAGE_ITEMACQUIRED
local _____8036_63D0_5C14_7EA6_675F_8DDD_79BB = 1200
local _____8036_63D0_5C14_7EA6_675F_8DDD_79BB_5E73_65B9 = _____8036_63D0_5C14_7EA6_675F_8DDD_79BB * _____8036_63D0_5C14_7EA6_675F_8DDD_79BB
local _____8036_63D0_5C14_5165_573A_9760_8FD1_73A9_5BB6_8DDD_79BB_5E73_65B9 = 900 * 900
local _____8036_63D0_5C14_8D8A_754C_68C0_67E5_95F4_9694_6BEB_79D2 = 100
local _____8036_63D0_5C14_4E34_65F6_8131_79BB_63A7_5236_6BEB_79D2 = 1000
local ____Boss_8F6C_573A_7B49_5F85_6BEB_79D2 = 2200
local _____8036_63D0_5C14_8D8A_754C_5BF9_767D = "不能再退了！菲利斯就在眼前——先解决他！"
local _____8036_63D0_5C14_6218_540E_4F4D_7F6EX = -10430.3
local _____8036_63D0_5C14_6218_540E_4F4D_7F6EY = -13610.4
local _____8036_63D0_5C14_6218_540E_671D_5411 = 270
local _____8036_63D0_5C14_6218_540E_5956_52B1_89E6_53D1_8303_56F4 = 450
local _____8036_63D0_5C14_6218_540E_5BF9_767D_6301_7EED_6BEB_79D2 = 5200
local _____8036_63D0_5C14_6218_540E_5BF9_767D = "诸位，城门一战辛苦了。菲利斯投影消散后留下了一些东西，我替你们收在兵营里——这些战利品理应归你们。"
local _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001
local _____8036_63D0_5C14_534F_6218_4E16_4EE3 = 0
local _____5DF2_6CE8_518C_8036_63D0_5C14_6307_4EE4_76D1_542C = false
local _____5F53_524D_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001
local _____8036_63D0_5C14_6218_540E_5956_52B1_4E16_4EE3 = 0
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0
end
local function _____5750_6807_8D85_51FA_83F2_5229_65AF_7EA6_675F(_____72B6_6001, x, y)
    if not _____5355_4F4D_6709_6548(_____72B6_6001["菲利斯"]) then
        return false
    end
    local dx = x - GetUnitX(_____72B6_6001["菲利斯"])
    local dy = y - GetUnitY(_____72B6_6001["菲利斯"])
    return dx * dx + dy * dy > _____8036_63D0_5C14_7EA6_675F_8DDD_79BB_5E73_65B9
end
local function _____8BBE_7F6E_73A9_5BB6_79BB_573A_610F_56FE(unit, x, y)
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001
    if _____72B6_6001 == nil or unit ~= _____72B6_6001["耶提尔"] or _____72B6_6001["正在强制回战"] then
        return
    end
    _____72B6_6001["玩家主动离场"] = _____5750_6807_8D85_51FA_83F2_5229_65AF_7EA6_675F(_____72B6_6001, x, y)
end
local function ____on_8036_63D0_5C14_70B9_76EE_6807_6307_4EE4(unit, _orderId, x, y)
    _____8BBE_7F6E_73A9_5BB6_79BB_573A_610F_56FE(unit, x, y)
end
local function ____on_8036_63D0_5C14_5355_4F4D_76EE_6807_6307_4EE4(unit, _orderId, targetUnit, targetItem, targetDestructable)
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001
    if _____72B6_6001 == nil or unit ~= _____72B6_6001["耶提尔"] or _____72B6_6001["正在强制回战"] then
        return
    end
    if targetUnit ~= nil and targetUnit ~= 0 then
        _____8BBE_7F6E_73A9_5BB6_79BB_573A_610F_56FE(
            unit,
            GetUnitX(targetUnit),
            GetUnitY(targetUnit)
        )
        return
    end
    if targetItem ~= nil and targetItem ~= 0 then
        _____8BBE_7F6E_73A9_5BB6_79BB_573A_610F_56FE(
            unit,
            GetItemX(targetItem),
            GetItemY(targetItem)
        )
        return
    end
    if targetDestructable ~= nil and targetDestructable ~= 0 then
        _____8BBE_7F6E_73A9_5BB6_79BB_573A_610F_56FE(
            unit,
            GetDestructableX(targetDestructable),
            GetDestructableY(targetDestructable)
        )
        return
    end
    _____72B6_6001["玩家主动离场"] = false
end
local function ____on_8036_63D0_5C14_7ACB_5373_6307_4EE4(unit, _orderId)
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001
    if _____72B6_6001 == nil or unit ~= _____72B6_6001["耶提尔"] or _____72B6_6001["正在强制回战"] then
        return
    end
    _____72B6_6001["玩家主动离场"] = false
end
local function _____786E_4FDD_8036_63D0_5C14_6307_4EE4_76D1_542C()
    if _____5DF2_6CE8_518C_8036_63D0_5C14_6307_4EE4_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_8036_63D0_5C14_6307_4EE4_76D1_542C = true
    registerPointOrderListener(____on_8036_63D0_5C14_70B9_76EE_6807_6307_4EE4)
    registerTargetOrderListener(____on_8036_63D0_5C14_5355_4F4D_76EE_6807_6307_4EE4)
    registerImmediateOrderListener(____on_8036_63D0_5C14_7ACB_5373_6307_4EE4)
end
local function _____505C_6B62_5F53_524D_8036_63D0_5C14_534F_6218()
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001
    if _____72B6_6001 ~= nil then
        if _____72B6_6001["周期回调ID"] ~= 0 then
            removePeriodicCallback(_____72B6_6001["周期回调ID"])
        end
        if _____5355_4F4D_6709_6548(_____72B6_6001["耶提尔"]) then
            SetUnitOwner(_____72B6_6001["耶提尔"], _____72B6_6001["原归属玩家"], true)
            IssueImmediateOrder(_____72B6_6001["耶提尔"], "stop")
        end
    end
    _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001 = nil
end
local function _____505C_6B62_8036_63D0_5C14_534F_6218Tick(_____72B6_6001)
    if _____72B6_6001["周期回调ID"] == 0 then
        return
    end
    removePeriodicCallback(_____72B6_6001["周期回调ID"])
    _____72B6_6001["周期回调ID"] = 0
end
local function _____8BA1_7B97_8036_63D0_5C14_5B58_6D3B_5956_52B1_6863_4F4D(_____8036_63D0_5C14)
    if not _____5355_4F4D_6709_6548(_____8036_63D0_5C14) then
        return 0
    end
    local _____5F53_524D_751F_547D = GetUnitState(_____8036_63D0_5C14, UNIT_STATE_LIFE)
    local _____6700_5927_751F_547D = GetUnitStateJapi(_____8036_63D0_5C14, UNIT_STATE_MAX_LIFE)
    if _____5F53_524D_751F_547D <= 0.405 or _____6700_5927_751F_547D <= 0 then
        return 0
    end
    local _____751F_547D_6BD4_4F8B = _____5F53_524D_751F_547D / _____6700_5927_751F_547D
    if _____751F_547D_6BD4_4F8B >= 0.75 then
        return 3
    end
    if _____751F_547D_6BD4_4F8B >= 0.4 then
        return 2
    end
    return 1
end
local function ____on_53D1_653E_83F2_5229_65AF_968F_673A_88C5_5907()
    local _____73A9_5BB6 = GetEnumPlayer()
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____88C5_5907_540D = GetRandomInt(0, 1) == 0 and _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["菲利斯的战阵徽章"] or _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["第二军团攻城秘戒"]
    _____53D1_653E_9996_9886_5956_52B1_88C5_5907(_____73A9_5BB6, _____88C5_5907_540D)
end
local function ____on_53D1_653E_4E00_679A_80FD_91CF_788E_7247()
    local _____73A9_5BB6 = GetEnumPlayer()
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____5F53_524D_80FD_91CF_788E_7247 = GetPlayerState(_____73A9_5BB6, PLAYER_STATE_RESOURCE_LUMBER)
    SetPlayerState(_____73A9_5BB6, PLAYER_STATE_RESOURCE_LUMBER, _____5F53_524D_80FD_91CF_788E_7247 + 1)
end
local function _____904D_5386_5267_60C5_73A9_5BB6_7EC4(callback)
    local _____73A9_5BB6_7EC4 = YDUserDataGetSafe("string", "玩家", "玩家组", "force")
    if _____73A9_5BB6_7EC4 == nil or _____73A9_5BB6_7EC4 == 0 then
        return
    end
    safeForForce(_____73A9_5BB6_7EC4, callback)
end
local function _____53D1_653E_8036_63D0_5C14_5B58_6D3B_5956_52B1(_____5956_52B1_6863_4F4D)
    if _____5956_52B1_6863_4F4D == 3 then
        _____904D_5386_5267_60C5_73A9_5BB6_7EC4(____on_53D1_653E_83F2_5229_65AF_968F_673A_88C5_5907)
        _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F({["消息类型"] = bj_QUESTMESSAGE_ITEMACQUIRED, ["文本"] = "|cffffff00『额外奖励』：|r耶提尔状态良好，所有英雄分别收到一件|cff66ccff『菲利斯战利品』|r！"})
        return
    end
    if _____5956_52B1_6863_4F4D == 2 then
        _____6267_884C_901A_7528_5267_60C5_52A8_4F5C({["发放金币"] = 10000})
        _____904D_5386_5267_60C5_73A9_5BB6_7EC4(____on_53D1_653E_4E00_679A_80FD_91CF_788E_7247)
        _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F({["消息类型"] = bj_QUESTMESSAGE_ITEMACQUIRED, ["文本"] = "|cffffff00『额外奖励』：|r所有英雄收到|cffffff0010000金币|r与|cff66ccff1能量碎片|r！"})
        return
    end
    if _____5956_52B1_6863_4F4D == 1 then
        _____6267_884C_901A_7528_5267_60C5_52A8_4F5C({["发放金币"] = 5000})
        _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F({["消息类型"] = bj_QUESTMESSAGE_ITEMACQUIRED, ["文本"] = "|cffffff00『额外奖励』：|r所有英雄收到|cffffff005000金币|r！"})
    end
end
local function _____6E05_7406_8036_63D0_5C14_6218_540E_9886_53D6_76D1_542C(_____72B6_6001)
    local _____53D6_6D88_76D1_542C = _____72B6_6001["取消领取监听"]
    _____72B6_6001["取消领取监听"] = nil
    if _____53D6_6D88_76D1_542C ~= nil then
        _____53D6_6D88_76D1_542C()
    end
end
local function _____6E05_7A7A_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001()
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001
    _____5F53_524D_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001 = nil
    if _____72B6_6001 ~= nil then
        _____6E05_7406_8036_63D0_5C14_6218_540E_9886_53D6_76D1_542C(_____72B6_6001)
    end
end
local function ____on_53D1_653E_8036_63D0_5C14_6218_540E_5956_52B1(variable)
    local _____53C2_6570 = variable
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001
    if _____53C2_6570 == nil or _____72B6_6001 == nil or _____53C2_6570["世代"] ~= _____72B6_6001["世代"] or not _____72B6_6001["已领取"] then
        return
    end
    _____5F53_524D_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001 = nil
    _____53D1_653E_8036_63D0_5C14_5B58_6D3B_5956_52B1(_____72B6_6001["奖励档位"])
end
local function ____on_8036_63D0_5C14_6218_540E_5956_52B1_63A5_8FD1(_____8FDB_5165_5355_4F4D)
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已领取"] then
        return true
    end
    if not _____5355_4F4D_6709_6548(_____8FDB_5165_5355_4F4D) then
        return false
    end
    _____72B6_6001["已领取"] = true
    _____72B6_6001["取消领取监听"] = nil
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____72B6_6001["耶提尔"], _____8036_63D0_5C14_6218_540E_5BF9_767D, _____8036_63D0_5C14_6218_540E_5BF9_767D_6301_7EED_6BEB_79D2)
    addDelayedCallback(_____8036_63D0_5C14_6218_540E_5BF9_767D_6301_7EED_6BEB_79D2, ____on_53D1_653E_8036_63D0_5C14_6218_540E_5956_52B1, {["世代"] = _____72B6_6001["世代"]})
    return true
end
____exports["布置耶提尔战后奖励NPC"] = function()
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["已领取"] or _____72B6_6001["奖励档位"] <= 0 then
        return
    end
    if not _____5355_4F4D_6709_6548(_____72B6_6001["耶提尔"]) or GetUnitState(_____72B6_6001["耶提尔"], UNIT_STATE_LIFE) <= 0.405 then
        _____6E05_7A7A_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001()
        return
    end
    _____6E05_7406_8036_63D0_5C14_6218_540E_9886_53D6_76D1_542C(_____72B6_6001)
    SetUnitPosition(_____72B6_6001["耶提尔"], _____8036_63D0_5C14_6218_540E_4F4D_7F6EX, _____8036_63D0_5C14_6218_540E_4F4D_7F6EY)
    SetUnitFacing(_____72B6_6001["耶提尔"], _____8036_63D0_5C14_6218_540E_671D_5411)
    IssueImmediateOrder(_____72B6_6001["耶提尔"], "holdposition")
    _____72B6_6001["取消领取监听"] = registerOneShotUnitRangeListener(_____72B6_6001["耶提尔"], _____8036_63D0_5C14_6218_540E_5956_52B1_89E6_53D1_8303_56F4, ____on_8036_63D0_5C14_6218_540E_5956_52B1_63A5_8FD1, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D)
end
____exports["结算耶提尔菲利斯协战"] = function()
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001
    if _____72B6_6001 == nil then
        return
    end
    _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001 = nil
    _____505C_6B62_8036_63D0_5C14_534F_6218Tick(_____72B6_6001)
    local _____5956_52B1_6863_4F4D = _____8BA1_7B97_8036_63D0_5C14_5B58_6D3B_5956_52B1_6863_4F4D(_____72B6_6001["耶提尔"])
    if _____5355_4F4D_6709_6548(_____72B6_6001["耶提尔"]) then
        SetUnitOwner(_____72B6_6001["耶提尔"], _____72B6_6001["原归属玩家"], true)
        if _____5956_52B1_6863_4F4D > 0 then
            IssueImmediateOrder(_____72B6_6001["耶提尔"], "stop")
        end
    end
    _____6E05_7A7A_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001()
    if _____5956_52B1_6863_4F4D <= 0 then
        return
    end
    _____8036_63D0_5C14_6218_540E_5956_52B1_4E16_4EE3 = _____8036_63D0_5C14_6218_540E_5956_52B1_4E16_4EE3 + 1
    _____5F53_524D_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001 = {
        ["世代"] = _____8036_63D0_5C14_6218_540E_5956_52B1_4E16_4EE3,
        ["耶提尔"] = _____72B6_6001["耶提尔"],
        ["奖励档位"] = _____5956_52B1_6863_4F4D,
        ["已领取"] = false,
        ["取消领取监听"] = nil
    }
end
local function ____on_6062_590D_8036_63D0_5C14_73A9_5BB6_63A7_5236(variable)
    local _____53C2_6570 = variable
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001
    if _____53C2_6570 == nil or _____72B6_6001 == nil or _____53C2_6570["世代"] ~= _____72B6_6001["世代"] then
        return
    end
    if not _____5355_4F4D_6709_6548(_____72B6_6001["耶提尔"]) or not _____5355_4F4D_6709_6548(_____72B6_6001["菲利斯"]) then
        _____505C_6B62_5F53_524D_8036_63D0_5C14_534F_6218()
        return
    end
    SetUnitOwner(_____72B6_6001["耶提尔"], _____72B6_6001["控制玩家"], true)
    IssueTargetOrder(_____72B6_6001["耶提尔"], "attack", _____72B6_6001["菲利斯"])
    _____72B6_6001["正在强制回战"] = false
end
local function _____5F3A_5236_8036_63D0_5C14_8FD4_56DE_6218_6597(_____72B6_6001)
    _____72B6_6001["玩家主动离场"] = false
    _____72B6_6001["正在强制回战"] = true
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____72B6_6001["耶提尔"], _____8036_63D0_5C14_8D8A_754C_5BF9_767D, 3200)
    SetUnitOwner(
        _____72B6_6001["耶提尔"],
        Player(PLAYER_NEUTRAL_PASSIVE),
        true
    )
    IssueTargetOrder(_____72B6_6001["耶提尔"], "attack", _____72B6_6001["菲利斯"])
    addDelayedCallback(_____8036_63D0_5C14_4E34_65F6_8131_79BB_63A7_5236_6BEB_79D2, ____on_6062_590D_8036_63D0_5C14_73A9_5BB6_63A7_5236, {["世代"] = _____72B6_6001["世代"]})
end
local function ____on_8036_63D0_5C14_8D8A_754C_68C0_67E5()
    local _____72B6_6001 = _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001
    if _____72B6_6001 == nil then
        return
    end
    if not _____5355_4F4D_6709_6548(_____72B6_6001["菲利斯"]) then
        _____505C_6B62_5F53_524D_8036_63D0_5C14_534F_6218()
        return
    end
    if not _____5355_4F4D_6709_6548(_____72B6_6001["耶提尔"]) or GetUnitState(_____72B6_6001["耶提尔"], UNIT_STATE_LIFE) <= 0.405 then
        _____505C_6B62_8036_63D0_5C14_534F_6218Tick(_____72B6_6001)
        return
    end
    if not _____72B6_6001["玩家主动离场"] or _____72B6_6001["正在强制回战"] then
        return
    end
    if not _____5750_6807_8D85_51FA_83F2_5229_65AF_7EA6_675F(
        _____72B6_6001,
        GetUnitX(_____72B6_6001["耶提尔"]),
        GetUnitY(_____72B6_6001["耶提尔"])
    ) then
        return
    end
    _____5F3A_5236_8036_63D0_5C14_8FD4_56DE_6218_6597(_____72B6_6001)
end
local function ____on_8036_63D0_5C14_534F_6218_8F6C_573A_5B8C_6210(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or _____53C2_6570["世代"] ~= _____8036_63D0_5C14_534F_6218_4E16_4EE3 then
        return
    end
    local _____8036_63D0_5C14 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.耶提尔")
    if not _____5355_4F4D_6709_6548(_____8036_63D0_5C14) or not _____5355_4F4D_6709_6548(_____53C2_6570["菲利斯"]) or not _____5355_4F4D_6709_6548(_____53C2_6570["玩家单位"]) then
        return
    end
    local _____73A9_5BB6X = GetUnitX(_____53C2_6570["玩家单位"])
    local _____73A9_5BB6Y = GetUnitY(_____53C2_6570["玩家单位"])
    local bossX = GetUnitX(_____53C2_6570["菲利斯"])
    local bossY = GetUnitY(_____53C2_6570["菲利斯"])
    local dx = _____73A9_5BB6X - bossX
    local dy = _____73A9_5BB6Y - bossY
    local _____9760_8FD1_73A9_5BB6 = dx * dx + dy * dy <= _____8036_63D0_5C14_5165_573A_9760_8FD1_73A9_5BB6_8DDD_79BB_5E73_65B9
    SetUnitPosition(_____8036_63D0_5C14, _____9760_8FD1_73A9_5BB6 and _____73A9_5BB6X + 160 or bossX - 400, _____9760_8FD1_73A9_5BB6 and _____73A9_5BB6Y or bossY)
    local _____63A7_5236_73A9_5BB6 = GetOwningPlayer(_____53C2_6570["玩家单位"])
    local _____539F_5F52_5C5E_73A9_5BB6 = GetOwningPlayer(_____8036_63D0_5C14)
    SetUnitOwner(_____8036_63D0_5C14, _____63A7_5236_73A9_5BB6, true)
    _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001 = {
        ["世代"] = _____53C2_6570["世代"],
        ["耶提尔"] = _____8036_63D0_5C14,
        ["菲利斯"] = _____53C2_6570["菲利斯"],
        ["控制玩家"] = _____63A7_5236_73A9_5BB6,
        ["原归属玩家"] = _____539F_5F52_5C5E_73A9_5BB6,
        ["玩家主动离场"] = false,
        ["正在强制回战"] = true,
        ["周期回调ID"] = 0
    }
    IssueTargetOrder(_____8036_63D0_5C14, "attack", _____53C2_6570["菲利斯"])
    _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001["正在强制回战"] = false
    _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001["周期回调ID"] = addPeriodicCallback(_____8036_63D0_5C14_8D8A_754C_68C0_67E5_95F4_9694_6BEB_79D2, ____on_8036_63D0_5C14_8D8A_754C_68C0_67E5)
end
____exports["准备耶提尔菲利斯协战"] = function(_____83F2_5229_65AF, _____73A9_5BB6_5355_4F4D)
    _____505C_6B62_5F53_524D_8036_63D0_5C14_534F_6218()
    _____6E05_7A7A_8036_63D0_5C14_6218_540E_5956_52B1_72B6_6001()
    if not _____5355_4F4D_6709_6548(_____83F2_5229_65AF) or not _____5355_4F4D_6709_6548(_____73A9_5BB6_5355_4F4D) then
        return
    end
    _____786E_4FDD_8036_63D0_5C14_6307_4EE4_76D1_542C()
    _____8036_63D0_5C14_534F_6218_4E16_4EE3 = _____8036_63D0_5C14_534F_6218_4E16_4EE3 + 1
    addDelayedCallback(____Boss_8F6C_573A_7B49_5F85_6BEB_79D2, ____on_8036_63D0_5C14_534F_6218_8F6C_573A_5B8C_6210, {["世代"] = _____8036_63D0_5C14_534F_6218_4E16_4EE3, ["菲利斯"] = _____83F2_5229_65AF, ["玩家单位"] = _____73A9_5BB6_5355_4F4D})
end
return ____exports
