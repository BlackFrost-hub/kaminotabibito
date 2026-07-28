--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
---
-- @noSelfInFile
local jass = require("jass.common")
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
local GetDestructableX = jass.GetDestructableX
local GetDestructableY = jass.GetDestructableY
local GetItemX = jass.GetItemX
local GetItemY = jass.GetItemY
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueTargetOrder = jass.IssueTargetOrder
local Player = jass.Player
local SetUnitOwner = jass.SetUnitOwner
local SetUnitPosition = jass.SetUnitPosition
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local _____8036_63D0_5C14_7EA6_675F_8DDD_79BB = 1200
local _____8036_63D0_5C14_7EA6_675F_8DDD_79BB_5E73_65B9 = _____8036_63D0_5C14_7EA6_675F_8DDD_79BB * _____8036_63D0_5C14_7EA6_675F_8DDD_79BB
local _____8036_63D0_5C14_5165_573A_9760_8FD1_73A9_5BB6_8DDD_79BB_5E73_65B9 = 900 * 900
local _____8036_63D0_5C14_8D8A_754C_68C0_67E5_95F4_9694_6BEB_79D2 = 100
local _____8036_63D0_5C14_4E34_65F6_8131_79BB_63A7_5236_6BEB_79D2 = 1000
local ____Boss_8F6C_573A_7B49_5F85_6BEB_79D2 = 2200
local _____8036_63D0_5C14_8D8A_754C_5BF9_767D = "不能再退了！菲利斯就在眼前——先解决他！"
local _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001
local _____8036_63D0_5C14_534F_6218_4E16_4EE3 = 0
local _____5DF2_6CE8_518C_8036_63D0_5C14_6307_4EE4_76D1_542C = false
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
    if _____72B6_6001 ~= nil and _____72B6_6001["周期回调ID"] ~= 0 then
        removePeriodicCallback(_____72B6_6001["周期回调ID"])
    end
    _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001 = nil
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
    if not _____5355_4F4D_6709_6548(_____72B6_6001["耶提尔"]) or not _____5355_4F4D_6709_6548(_____72B6_6001["菲利斯"]) then
        _____505C_6B62_5F53_524D_8036_63D0_5C14_534F_6218()
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
    SetUnitOwner(_____8036_63D0_5C14, _____63A7_5236_73A9_5BB6, true)
    _____5F53_524D_8036_63D0_5C14_534F_6218_72B6_6001 = {
        ["世代"] = _____53C2_6570["世代"],
        ["耶提尔"] = _____8036_63D0_5C14,
        ["菲利斯"] = _____53C2_6570["菲利斯"],
        ["控制玩家"] = _____63A7_5236_73A9_5BB6,
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
    if not _____5355_4F4D_6709_6548(_____83F2_5229_65AF) or not _____5355_4F4D_6709_6548(_____73A9_5BB6_5355_4F4D) then
        return
    end
    _____786E_4FDD_8036_63D0_5C14_6307_4EE4_76D1_542C()
    _____8036_63D0_5C14_534F_6218_4E16_4EE3 = _____8036_63D0_5C14_534F_6218_4E16_4EE3 + 1
    addDelayedCallback(____Boss_8F6C_573A_7B49_5F85_6BEB_79D2, ____on_8036_63D0_5C14_534F_6218_8F6C_573A_5B8C_6210, {["世代"] = _____8036_63D0_5C14_534F_6218_4E16_4EE3, ["菲利斯"] = _____83F2_5229_65AF, ["玩家单位"] = _____73A9_5BB6_5355_4F4D})
end
return ____exports
