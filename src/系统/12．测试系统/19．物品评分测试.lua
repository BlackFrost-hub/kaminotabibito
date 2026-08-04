local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_0["是允许测试玩家"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local _____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C = ____require_result_1["注册聊天命令前缀监听"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("lib.扩展函数.物品相关函数.index")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local _____88C5_5907_6570_636E_6A21_5757 = require("系统.02．物品系统.01．装备数据")
local _____88C5_5907_6570_636E = _____88C5_5907_6570_636E_6A21_5757.default or _____88C5_5907_6570_636E_6A21_5757.items or ({})
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____6A21_5757_540D = "物品评分测试"
local _____7269_54C1_8BC4_5206_547D_4EE4_524D_7F00 = "物品+"
local _____968F_673A6000_5206_88C5_5907_547D_4EE4 = "djcs"
local _____9ED8_8BA4_968F_673A_76EE_6807_8BC4_5206 = 6000
local _____8BC4_5206_6D6E_52A8_8303_56F4 = 500
local _____6279_91CF_521B_5EFA_6570_91CF = 10
local _____88C5_5907_7C7B_578B_8868 = {
    ["主武器"] = true,
    ["副武器"] = true,
    ["双手武器"] = true,
    ["衣服"] = true,
    ["裤子"] = true,
    ["头盔"] = true,
    ["鞋子"] = true,
    ["灵魂"] = true,
    ["道具/戒指/饰品"] = true
}
local _____6279_91CF_521B_5EFA_504F_79FB = {
    {-144, -48},
    {-48, -48},
    {48, -48},
    {144, -48},
    {-96, 48},
    {0, 48},
    {96, 48},
    {-96, 144},
    {0, 144},
    {96, 144}
}
local function _____662F_6709_6548_53E5_67C4(value)
    return value ~= nil and value ~= 0
end
local function _____662F_88C5_5907_7C7B_578B(____type)
    return ____type ~= nil and _____88C5_5907_7C7B_578B_8868[____type] == true
end
local function _____6309_8BC4_5206_7B5B_9009_88C5_5907(_____6700_4F4E_8BC4_5206, _____6700_9AD8_8BC4_5206)
    local result = {}
    for itemId in pairs(_____88C5_5907_6570_636E) do
        do
            if #itemId ~= 4 then
                goto __continue5
            end
            local data = _____88C5_5907_6570_636E[itemId]
            if data == nil or not _____662F_88C5_5907_7C7B_578B(data.type) then
                goto __continue5
            end
            if type(data.score) ~= "number" then
                goto __continue5
            end
            if data.score < _____6700_4F4E_8BC4_5206 or data.score > _____6700_9AD8_8BC4_5206 then
                goto __continue5
            end
            result[#result + 1] = itemId
        end
        ::__continue5::
    end
    __TS__ArraySort(result)
    return result
end
local function _____968F_673A_53D6_7269_54C1(_____5019_9009_7269_54C1)
    if #_____5019_9009_7269_54C1 <= 0 then
        return nil
    end
    local index = GetRandomInt(1, #_____5019_9009_7269_54C1) - 1
    return _____5019_9009_7269_54C1[index + 1]
end
local function _____89E3_6790_76EE_6807_8BC4_5206(command)
    if __TS__StringSubstring(command, 0, #_____7269_54C1_8BC4_5206_547D_4EE4_524D_7F00) ~= _____7269_54C1_8BC4_5206_547D_4EE4_524D_7F00 then
        return nil
    end
    local text = __TS__StringTrim(__TS__StringSubstring(command, #_____7269_54C1_8BC4_5206_547D_4EE4_524D_7F00))
    if text == "" then
        return nil
    end
    local score = __TS__Number(text)
    if score ~= score or score <= 0 then
        return nil
    end
    return score
end
local function _____521B_5EFA_7269_54C1(itemId, x, y)
    local itemTypeId = stringToFourCCSafe(itemId)
    if itemTypeId == 0 then
        return false
    end
    local item = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(itemTypeId, x, y)
    return _____662F_6709_6548_53E5_67C4(item)
end
local function _____83B7_53D6_6D4B_8BD5_82F1_96C4(player)
    local hero = getRegisteredPlayerHero(player)
    if _____662F_6709_6548_53E5_67C4(hero) then
        return hero
    end
    return nil
end
local function _____53D1_9001_5931_8D25_63D0_793A(player, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        6,
        "[物品测试] " .. text
    )
    debugLogForce(_____6A21_5757_540D, text)
end
local function _____521B_5EFA_5355_4EF6_8BC4_5206_88C5_5907(player, _____76EE_6807_8BC4_5206)
    local hero = _____83B7_53D6_6D4B_8BD5_82F1_96C4(player)
    if not _____662F_6709_6548_53E5_67C4(hero) then
        _____53D1_9001_5931_8D25_63D0_793A(player, "未找到该玩家的注册英雄。")
        return
    end
    local _____5019_9009_7269_54C1 = _____6309_8BC4_5206_7B5B_9009_88C5_5907(_____76EE_6807_8BC4_5206 - _____8BC4_5206_6D6E_52A8_8303_56F4, _____76EE_6807_8BC4_5206 + _____8BC4_5206_6D6E_52A8_8303_56F4)
    local itemId = _____968F_673A_53D6_7269_54C1(_____5019_9009_7269_54C1)
    if itemId == nil then
        _____53D1_9001_5931_8D25_63D0_793A(
            player,
            ("评分 " .. tostring(_____76EE_6807_8BC4_5206)) .. " 附近没有可创建的装备。"
        )
        return
    end
    local created = _____521B_5EFA_7269_54C1(
        itemId,
        GetUnitX(hero),
        GetUnitY(hero)
    )
    local data = _____88C5_5907_6570_636E[itemId]
    if not created then
        _____53D1_9001_5931_8D25_63D0_793A(player, ("创建装备失败：" .. itemId) .. "。")
        return
    end
    local name = data and data.name or itemId
    local score = data and data.score or 0
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        6,
        ((((((("[物品测试] 已创建 " .. name) .. "，评分 ") .. tostring(score)) .. "（目标 ") .. tostring(_____76EE_6807_8BC4_5206)) .. "+/-") .. tostring(_____8BC4_5206_6D6E_52A8_8303_56F4)) .. "）。"
    )
    debugLogForce(
        _____6A21_5757_540D,
        "创建单件装备",
        "itemId",
        itemId,
        "name",
        name,
        "score",
        score,
        "target",
        _____76EE_6807_8BC4_5206
    )
end
local function _____521B_5EFA_5341_4EF6_968F_673A_8BC4_5206_88C5_5907(player)
    local hero = _____83B7_53D6_6D4B_8BD5_82F1_96C4(player)
    if not _____662F_6709_6548_53E5_67C4(hero) then
        _____53D1_9001_5931_8D25_63D0_793A(player, "未找到该玩家的注册英雄。")
        return
    end
    local _____5019_9009_7269_54C1 = _____6309_8BC4_5206_7B5B_9009_88C5_5907(_____9ED8_8BA4_968F_673A_76EE_6807_8BC4_5206 - _____8BC4_5206_6D6E_52A8_8303_56F4, _____9ED8_8BA4_968F_673A_76EE_6807_8BC4_5206 + _____8BC4_5206_6D6E_52A8_8303_56F4)
    if #_____5019_9009_7269_54C1 <= 0 then
        _____53D1_9001_5931_8D25_63D0_793A(
            player,
            ("评分 " .. tostring(_____9ED8_8BA4_968F_673A_76EE_6807_8BC4_5206)) .. " 附近没有可创建的装备。"
        )
        return
    end
    local heroX = GetUnitX(hero)
    local heroY = GetUnitY(hero)
    local createdCount = 0
    local createdNames = ""
    local pool = __TS__ArraySlice(_____5019_9009_7269_54C1)
    do
        local i = 0
        while i < _____6279_91CF_521B_5EFA_6570_91CF do
            do
                local source = #pool > 0 and pool or _____5019_9009_7269_54C1
                local sourceIndex = GetRandomInt(1, #source) - 1
                local itemId = source[sourceIndex + 1]
                if #pool > 0 then
                    __TS__ArraySplice(pool, sourceIndex, 1)
                end
                local offset = _____6279_91CF_521B_5EFA_504F_79FB[i + 1]
                if not _____521B_5EFA_7269_54C1(itemId, heroX + offset[1], heroY + offset[2]) then
                    goto __continue30
                end
                createdCount = createdCount + 1
                local data = _____88C5_5907_6570_636E[itemId]
                local name = data and data.name or itemId
                if createdNames ~= "" then
                    createdNames = createdNames .. "、"
                end
                createdNames = (((createdNames .. name) .. "（") .. tostring(data and data.score or 0)) .. "）"
            end
            ::__continue30::
            i = i + 1
        end
    end
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        10,
        (((((("[物品测试] djcs 已创建 " .. tostring(createdCount)) .. "/") .. tostring(_____6279_91CF_521B_5EFA_6570_91CF)) .. " 件 6000+/-") .. tostring(_____8BC4_5206_6D6E_52A8_8303_56F4)) .. " 装备：") .. createdNames
    )
    debugLogForce(
        _____6A21_5757_540D,
        "批量创建装备",
        "count",
        createdCount,
        "target",
        _____9ED8_8BA4_968F_673A_76EE_6807_8BC4_5206,
        "range",
        _____8BC4_5206_6D6E_52A8_8303_56F4
    )
end
local function ____on_7269_54C1_8BC4_5206_547D_4EE4(player, command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local _____76EE_6807_8BC4_5206 = _____89E3_6790_76EE_6807_8BC4_5206(command)
    if _____76EE_6807_8BC4_5206 == nil then
        _____53D1_9001_5931_8D25_63D0_793A(player, "命令格式：物品+评分，例如 物品+6000。")
        return
    end
    _____521B_5EFA_5355_4EF6_8BC4_5206_88C5_5907(player, _____76EE_6807_8BC4_5206)
end
local function ____on_968F_673A6000_5206_88C5_5907_547D_4EE4(player, _command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    _____521B_5EFA_5341_4EF6_968F_673A_8BC4_5206_88C5_5907(player)
end
_____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C(_____7269_54C1_8BC4_5206_547D_4EE4_524D_7F00, ____on_7269_54C1_8BC4_5206_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____968F_673A6000_5206_88C5_5907_547D_4EE4, ____on_968F_673A6000_5206_88C5_5907_547D_4EE4)
return ____exports
