local ____lualib = require("lualib_bundle")
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
local _____8DF3_8FC7_8868_8FBE_5F0F_7A7A_683C, _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0, _____8BFB_53D6_8868_8FBE_5F0F_6570_5B57, _____8BFB_53D6_8868_8FBE_5F0F_57FA_7840_503C, _____8BFB_53D6_8868_8FBE_5F0F_4E58_9664, _____8BFB_53D6_8868_8FBE_5F0F_52A0_51CF
local ____index = require("lib.扩展函数.BJ函数.index")
local IMaxBJ = ____index.IMaxBJ
local ____index = require("lib.扩展函数.自定义扩展函数.index")
local getPlayerFirstHero = ____index.getPlayerFirstHero
local ____06_FF0E_4EFB_52A1_5956_52B1_89E3_6790 = require("系统.09．表现系统.02．对话框系统.06．任务奖励解析")
local bindRewardParseHeroResolver = ____06_FF0E_4EFB_52A1_5956_52B1_89E3_6790.bindRewardParseHeroResolver
local isConditionMatchedWithContext = ____06_FF0E_4EFB_52A1_5956_52B1_89E3_6790.isConditionMatchedWithContext
function _____8DF3_8FC7_8868_8FBE_5F0F_7A7A_683C(_____72B6_6001)
    while _____72B6_6001["位置"] < #_____72B6_6001["文本"] and __TS__StringCharAt(_____72B6_6001["文本"], _____72B6_6001["位置"]) == " " do
        _____72B6_6001["位置"] = _____72B6_6001["位置"] + 1
    end
end
function _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, _____6807_8BB0)
    _____8DF3_8FC7_8868_8FBE_5F0F_7A7A_683C(_____72B6_6001)
    if __TS__StringSubstring(_____72B6_6001["文本"], _____72B6_6001["位置"], _____72B6_6001["位置"] + #_____6807_8BB0) ~= _____6807_8BB0 then
        return false
    end
    _____72B6_6001["位置"] = _____72B6_6001["位置"] + #_____6807_8BB0
    return true
end
function _____8BFB_53D6_8868_8FBE_5F0F_6570_5B57(_____72B6_6001)
    _____8DF3_8FC7_8868_8FBE_5F0F_7A7A_683C(_____72B6_6001)
    local _____6574_6570 = 0
    local _____5C0F_6570 = 0
    local _____5C0F_6570_4F4D_500D_7387 = 0.1
    local _____5DF2_8BFB_53D6 = false
    local _____6B63_5728_8BFB_53D6_5C0F_6570 = false
    while _____72B6_6001["位置"] < #_____72B6_6001["文本"] do
        do
            local _____5B57_7B26 = __TS__StringCharAt(_____72B6_6001["文本"], _____72B6_6001["位置"])
            if _____5B57_7B26 >= "0" and _____5B57_7B26 <= "9" then
                _____5DF2_8BFB_53D6 = true
                local _____6570_5B57 = (string.byte(_____5B57_7B26, 1) or 0 / 0) - 48
                if _____6B63_5728_8BFB_53D6_5C0F_6570 then
                    _____5C0F_6570 = _____5C0F_6570 + _____6570_5B57 * _____5C0F_6570_4F4D_500D_7387
                    _____5C0F_6570_4F4D_500D_7387 = _____5C0F_6570_4F4D_500D_7387 * 0.1
                else
                    _____6574_6570 = _____6574_6570 * 10 + _____6570_5B57
                end
                _____72B6_6001["位置"] = _____72B6_6001["位置"] + 1
                goto __continue46
            end
            if _____5B57_7B26 == "." and not _____6B63_5728_8BFB_53D6_5C0F_6570 then
                _____6B63_5728_8BFB_53D6_5C0F_6570 = true
                _____72B6_6001["位置"] = _____72B6_6001["位置"] + 1
                goto __continue46
            end
            break
        end
        ::__continue46::
    end
    return _____5DF2_8BFB_53D6 and _____6574_6570 + _____5C0F_6570 or 0
end
function _____8BFB_53D6_8868_8FBE_5F0F_57FA_7840_503C(_____72B6_6001)
    _____8DF3_8FC7_8868_8FBE_5F0F_7A7A_683C(_____72B6_6001)
    if _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "+") then
        return _____8BFB_53D6_8868_8FBE_5F0F_57FA_7840_503C(_____72B6_6001)
    end
    if _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "-") then
        return 0 - _____8BFB_53D6_8868_8FBE_5F0F_57FA_7840_503C(_____72B6_6001)
    end
    if _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "(") then
        local _____6570_503C = _____8BFB_53D6_8868_8FBE_5F0F_52A0_51CF(_____72B6_6001)
        _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, ")")
        return _____6570_503C
    end
    if _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "IMaxBJ") then
        if not _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "(") then
            return 0
        end
        local _____5DE6_503C = _____8BFB_53D6_8868_8FBE_5F0F_52A0_51CF(_____72B6_6001)
        _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, ",")
        local _____53F3_503C = _____8BFB_53D6_8868_8FBE_5F0F_52A0_51CF(_____72B6_6001)
        _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, ")")
        return IMaxBJ(_____5DE6_503C, _____53F3_503C)
    end
    if _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "英雄等级") or _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "等级") then
        return _____72B6_6001["英雄等级"]
    end
    return _____8BFB_53D6_8868_8FBE_5F0F_6570_5B57(_____72B6_6001)
end
function _____8BFB_53D6_8868_8FBE_5F0F_4E58_9664(_____72B6_6001)
    local _____6570_503C = _____8BFB_53D6_8868_8FBE_5F0F_57FA_7840_503C(_____72B6_6001)
    while _____72B6_6001["位置"] < #_____72B6_6001["文本"] do
        do
            if _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "*") then
                _____6570_503C = _____6570_503C * _____8BFB_53D6_8868_8FBE_5F0F_57FA_7840_503C(_____72B6_6001)
                goto __continue59
            end
            if _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "/") then
                local _____9664_6570 = _____8BFB_53D6_8868_8FBE_5F0F_57FA_7840_503C(_____72B6_6001)
                if _____9664_6570 ~= 0 then
                    _____6570_503C = _____6570_503C / _____9664_6570
                end
                goto __continue59
            end
            break
        end
        ::__continue59::
    end
    return _____6570_503C
end
function _____8BFB_53D6_8868_8FBE_5F0F_52A0_51CF(_____72B6_6001)
    local _____6570_503C = _____8BFB_53D6_8868_8FBE_5F0F_4E58_9664(_____72B6_6001)
    while _____72B6_6001["位置"] < #_____72B6_6001["文本"] do
        do
            if _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "+") then
                _____6570_503C = _____6570_503C + _____8BFB_53D6_8868_8FBE_5F0F_4E58_9664(_____72B6_6001)
                goto __continue64
            end
            if _____5C1D_8BD5_8BFB_53D6_8868_8FBE_5F0F_6807_8BB0(_____72B6_6001, "-") then
                _____6570_503C = _____6570_503C - _____8BFB_53D6_8868_8FBE_5F0F_4E58_9664(_____72B6_6001)
                goto __continue64
            end
            break
        end
        ::__continue64::
    end
    return _____6570_503C
end
local jass = require("jass.common")
local japi = require("jass.japi")
local DzGetUnitNeededXP = japi.DzGetUnitNeededXP
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.02．GS单位属性")
local GS_UnitPry = ____require_result_0.GS_UnitPry
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_1["调整玩家属性"]
local function getUserPlayers(self)
    local out = {}
    do
        local i = 0
        while i < 4 do
            local p = jass:Player(i)
            if p and jass:GetPlayerController(p) == jass.MAP_CONTROL_USER then
                out[#out + 1] = p
            end
            i = i + 1
        end
    end
    return out
end
bindRewardParseHeroResolver(nil, getPlayerFirstHero)
local function gainGold(self, players, value)
    for ____, p in ipairs(players) do
        local cur = jass:GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD) or 0
        jass:SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD, cur + value)
    end
end
local function gainLumber(self, players, value)
    for ____, p in ipairs(players) do
        local cur = jass:GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER) or 0
        jass:SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER, cur + value)
    end
end
local function gainExp(self, players, value)
    for ____, p in ipairs(players) do
        local hero = getPlayerFirstHero(nil, p)
        if hero then
            jass:AddHeroXP(hero, value, true)
        end
    end
end
local function gainCurrentLevelNeededExpRate(players, rate)
    if rate <= 0 then
        return
    end
    for ____, p in ipairs(players) do
        do
            local hero = getPlayerFirstHero(nil, p)
            if not hero then
                goto __continue18
            end
            local level = jass:GetHeroLevel(hero)
            local neededExp = DzGetUnitNeededXP(hero, level)
            local value = jass:R2I(neededExp * rate)
            if value > 0 then
                jass:AddHeroXP(hero, value, true)
            end
        end
        ::__continue18::
    end
end
local function gainLevel(self, players, value)
    for ____, p in ipairs(players) do
        local hero = getPlayerFirstHero(nil, p)
        if hero then
            local lv = jass:GetHeroLevel(hero)
            jass:SetHeroLevel(hero, lv + value, false)
        end
    end
end
local function gainHeroStat(self, players, statName, value)
    local integerValue = jass:R2I(value)
    for ____, p in ipairs(players) do
        do
            local hero = getPlayerFirstHero(nil, p)
            if not hero then
                goto __continue27
            end
            if statName == "力量" then
                jass:SetHeroStr(
                    hero,
                    jass:GetHeroStr(hero, false) + integerValue,
                    true
                )
            elseif statName == "敏捷" then
                jass:SetHeroAgi(
                    hero,
                    jass:GetHeroAgi(hero, false) + integerValue,
                    true
                )
            elseif statName == "智力" then
                jass:SetHeroInt(
                    hero,
                    jass:GetHeroInt(hero, false) + integerValue,
                    true
                )
            end
        end
        ::__continue27::
    end
end
local function gainAttack(players, value)
    for ____, p in ipairs(players) do
        local hero = getPlayerFirstHero(nil, p)
        if hero then
            GS_UnitPry(hero, 0, 2, value)
        end
    end
end
local function gainPlayerAttribute(players, attributeName, value)
    for ____, player in ipairs(players) do
        local hero = getPlayerFirstHero(nil, player)
        if hero then
            _____8C03_6574_73A9_5BB6_5C5E_6027(hero, attributeName, value)
        end
    end
end
local function _____83B7_53D6_5956_52B1_82F1_96C4_7B49_7EA7(triggerPlayerId)
    local ____temp_2
    if triggerPlayerId ~= nil then
        ____temp_2 = jass:Player(triggerPlayerId)
    else
        ____temp_2 = nil
    end
    local player = ____temp_2
    local ____player_3
    if player then
        ____player_3 = getPlayerFirstHero(nil, player)
    else
        ____player_3 = nil
    end
    local hero = ____player_3
    return hero and jass:GetHeroLevel(hero) or 1
end
local function resolveAmountExpr(self, expr, triggerPlayerId)
    local _____72B6_6001 = {
        ["文本"] = __TS__StringTrim(expr),
        ["位置"] = 0,
        ["英雄等级"] = _____83B7_53D6_5956_52B1_82F1_96C4_7B49_7EA7(triggerPlayerId)
    }
    return _____8BFB_53D6_8868_8FBE_5F0F_52A0_51CF(_____72B6_6001)
end
local function _____63D0_53D6_7C7B_578B_524D_6570_503C_8868_8FBE_5F0F(_____6587_672C, _____7C7B_578B_540D)
    local _____4F4D_7F6E = (string.find(_____6587_672C, _____7C7B_578B_540D, nil, true) or 0) - 1
    return _____4F4D_7F6E >= 0 and __TS__StringTrim(__TS__StringSubstring(_____6587_672C, 0, _____4F4D_7F6E)) or ""
end
local function _____63D0_53D6_5C5E_6027_6570_503C_8868_8FBE_5F0F(_____6587_672C, _____5C5E_6027_540D)
    local _____4F4D_7F6E = (string.find(_____6587_672C, _____5C5E_6027_540D, nil, true) or 0) - 1
    if _____4F4D_7F6E < 0 then
        return ""
    end
    local _____524D_6BB5 = __TS__StringTrim(__TS__StringSubstring(_____6587_672C, 0, _____4F4D_7F6E))
    if _____524D_6BB5 ~= "" then
        return __TS__StringTrim(table.concat(
            __TS__StringSplit(_____524D_6BB5, "%"),
            ""
        ))
    end
    local _____540E_6BB5 = __TS__StringTrim(__TS__StringSubstring(_____6587_672C, _____4F4D_7F6E + #_____5C5E_6027_540D))
    while string.sub(_____540E_6BB5, 1, 1) == ":" or string.sub(_____540E_6BB5, 1, 1) == "+" or string.sub(_____540E_6BB5, 1, 1) == "＋" do
        _____540E_6BB5 = __TS__StringTrim(__TS__StringSubstring(_____540E_6BB5, 1))
    end
    return __TS__StringTrim(table.concat(
        __TS__StringSplit(_____540E_6BB5, "%"),
        ""
    ))
end
local function executeOneRewardExpr(self, expr, triggerPlayerId)
    local text = __TS__StringTrim(expr)
    if text == "" or text == "null" then
        return
    end
    local allPlayers = getUserPlayers(nil)
    local targetPlayers = ((string.find(text, "完成任务的玩家", nil, true) or 0) - 1 >= 0 or (string.find(text, "Player", nil, true) or 0) - 1 >= 0) and (triggerPlayerId ~= nil and ({jass:Player(triggerPlayerId)}) or ({})) or allPlayers
    local payload = text
    local prefixes = {"所有玩家", "完成任务的玩家", "Player"}
    for ____, p in ipairs(prefixes) do
        if (string.find(payload, p, nil, true) or 0) - 1 == 0 then
            payload = __TS__StringTrim(__TS__StringSubstring(payload, #p))
            while string.sub(payload, 1, 1) == "+" or string.sub(payload, 1, 1) == "＋" do
                payload = __TS__StringTrim(__TS__StringSubstring(payload, 1))
            end
            break
        end
    end
    local neededExpMarker = "升级所需经验的"
    local neededExpMarkerPos = (string.find(payload, neededExpMarker, nil, true) or 0) - 1
    if neededExpMarkerPos >= 0 then
        local percentStart = neededExpMarkerPos + #neededExpMarker
        local percentEnd = (string.find(
            payload,
            "%",
            math.max(percentStart + 1, 1),
            true
        ) or 0) - 1
        if percentEnd >= percentStart then
            local percentText = __TS__StringTrim(__TS__StringSubstring(payload, percentStart, percentEnd))
            local rate = resolveAmountExpr(nil, percentText, triggerPlayerId) / 100
            gainCurrentLevelNeededExpRate(targetPlayers, rate)
        end
        return
    end
    if (string.find(payload, "经验", nil, true) or 0) - 1 >= 0 or (string.find(payload, "exp", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(
            nil,
            _____63D0_53D6_7C7B_578B_524D_6570_503C_8868_8FBE_5F0F(
                payload,
                (string.find(payload, "经验", nil, true) or 0) - 1 >= 0 and "经验" or "exp"
            ),
            triggerPlayerId
        )
        if value > 0 then
            gainExp(nil, targetPlayers, value)
        end
        return
    end
    if (string.find(payload, "金币", nil, true) or 0) - 1 >= 0 or (string.find(payload, "gold", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(
            nil,
            _____63D0_53D6_7C7B_578B_524D_6570_503C_8868_8FBE_5F0F(
                payload,
                (string.find(payload, "金币", nil, true) or 0) - 1 >= 0 and "金币" or "gold"
            ),
            triggerPlayerId
        )
        if value > 0 then
            gainGold(nil, targetPlayers, value)
        end
        return
    end
    if (string.find(payload, "能量碎片", nil, true) or 0) - 1 >= 0 or (string.find(payload, "木头", nil, true) or 0) - 1 >= 0 or (string.find(payload, "木材", nil, true) or 0) - 1 >= 0 or (string.find(payload, "wood", nil, true) or 0) - 1 >= 0 then
        local _____7C7B_578B_540D = "能量碎片"
        if (string.find(payload, "木头", nil, true) or 0) - 1 >= 0 then
            _____7C7B_578B_540D = "木头"
        elseif (string.find(payload, "木材", nil, true) or 0) - 1 >= 0 then
            _____7C7B_578B_540D = "木材"
        elseif (string.find(payload, "wood", nil, true) or 0) - 1 >= 0 then
            _____7C7B_578B_540D = "wood"
        end
        local value = resolveAmountExpr(
            nil,
            _____63D0_53D6_7C7B_578B_524D_6570_503C_8868_8FBE_5F0F(payload, _____7C7B_578B_540D),
            triggerPlayerId
        )
        if value > 0 then
            gainLumber(nil, targetPlayers, value)
        end
        return
    end
    local _____4EE5_7B49_7EA7_7ED3_5C3E = #payload > #"等级" and __TS__StringSubstring(payload, #payload - #"等级") == "等级"
    local _____4EE5Level_7ED3_5C3E = #payload > #"level" and __TS__StringSubstring(payload, #payload - #"level") == "level"
    if _____4EE5_7B49_7EA7_7ED3_5C3E or _____4EE5Level_7ED3_5C3E then
        local value = resolveAmountExpr(
            nil,
            _____63D0_53D6_7C7B_578B_524D_6570_503C_8868_8FBE_5F0F(payload, _____4EE5_7B49_7EA7_7ED3_5C3E and "等级" or "level"),
            triggerPlayerId
        )
        if value > 0 then
            gainLevel(nil, targetPlayers, value)
        end
        return
    end
    if (string.find(payload, "攻击力", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(
            nil,
            _____63D0_53D6_5C5E_6027_6570_503C_8868_8FBE_5F0F(payload, "攻击力"),
            triggerPlayerId
        )
        if value > 0 then
            gainAttack(targetPlayers, value)
        end
        return
    end
    if (string.find(payload, "智力成长", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(
            nil,
            _____63D0_53D6_5C5E_6027_6570_503C_8868_8FBE_5F0F(payload, "智力成长"),
            triggerPlayerId
        )
        if value ~= 0 then
            gainPlayerAttribute(targetPlayers, "智力成长", value)
        end
        return
    end
    local _____767E_5206_6BD4_5C5E_6027_540D_5217_8868 = {"金属性抗性", "魔法伤害", "暴击伤害", "暴击率"}
    for ____, _____5C5E_6027_540D in ipairs(_____767E_5206_6BD4_5C5E_6027_540D_5217_8868) do
        do
            if (string.find(payload, _____5C5E_6027_540D, nil, true) or 0) - 1 < 0 then
                goto __continue97
            end
            local value = resolveAmountExpr(
                nil,
                _____63D0_53D6_5C5E_6027_6570_503C_8868_8FBE_5F0F(payload, _____5C5E_6027_540D),
                triggerPlayerId
            )
            if value ~= 0 then
                gainPlayerAttribute(
                    targetPlayers,
                    _____5C5E_6027_540D,
                    (string.find(payload, "%", nil, true) or 0) - 1 >= 0 and value / 100 or value
                )
            end
            return
        end
        ::__continue97::
    end
    if (string.find(payload, "力量", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(
            nil,
            _____63D0_53D6_5C5E_6027_6570_503C_8868_8FBE_5F0F(payload, "力量"),
            triggerPlayerId
        )
        if value > 0 then
            gainHeroStat(nil, targetPlayers, "力量", value)
        end
        return
    end
    if (string.find(payload, "敏捷", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(
            nil,
            _____63D0_53D6_5C5E_6027_6570_503C_8868_8FBE_5F0F(payload, "敏捷"),
            triggerPlayerId
        )
        if value > 0 then
            gainHeroStat(nil, targetPlayers, "敏捷", value)
        end
        return
    end
    if (string.find(payload, "智力", nil, true) or 0) - 1 >= 0 then
        local value = resolveAmountExpr(
            nil,
            _____63D0_53D6_5C5E_6027_6570_503C_8868_8FBE_5F0F(payload, "智力"),
            triggerPlayerId
        )
        if value > 0 then
            gainHeroStat(nil, targetPlayers, "智力", value)
        end
    end
end
local function _____662F_5426_5956_52B1_6761_4EF6(_____6761_4EF6)
    local _____6587_672C = __TS__StringTrim(_____6761_4EF6)
    if (string.find(_____6587_672C, "英雄等级", nil, true) or 0) - 1 == 0 then
        return true
    end
    if (string.find(_____6587_672C, "装备等级", nil, true) or 0) - 1 == 0 then
        return true
    end
    return (string.find(_____6587_672C, "|", nil, true) or 0) - 1 >= 0 and (string.find(_____6587_672C, "I", nil, true) or 0) - 1 >= 0
end
function ____exports.applyRewardWithContext(self, rewardRaw, ctx)
    if not rewardRaw or rewardRaw == "" then
        return {matchedRuleIndex = -1, matchedCondition = ""}
    end
    local matchedRuleIndex = -1
    local matchedCondition = ""
    local lines = __TS__StringSplit(rewardRaw, "\n")
    do
        local lineIdx = 0
        while lineIdx < #lines do
            do
                local line = __TS__StringTrim(lines[lineIdx + 1])
                if line == "" then
                    goto __continue113
                end
                local colon = (string.find(line, ":", nil, true) or 0) - 1
                if colon > 0 and _____662F_5426_5956_52B1_6761_4EF6(__TS__StringSubstring(line, 0, colon)) then
                    local cond = __TS__StringTrim(__TS__StringSubstring(line, 0, colon))
                    local expr = __TS__StringTrim(__TS__StringSubstring(line, colon + 1))
                    if expr == "" then
                        goto __continue113
                    end
                    if not isConditionMatchedWithContext(nil, cond, ctx) then
                        goto __continue113
                    end
                    local parts = __TS__StringSplit(expr, ";")
                    for ____, p in ipairs(parts) do
                        executeOneRewardExpr(nil, p, ctx.triggerPlayerId)
                    end
                    matchedRuleIndex = lineIdx
                    matchedCondition = cond
                    break
                end
                local parts = __TS__StringSplit(line, ";")
                for ____, p in ipairs(parts) do
                    executeOneRewardExpr(nil, p, ctx.triggerPlayerId)
                end
            end
            ::__continue113::
            lineIdx = lineIdx + 1
        end
    end
    return {matchedRuleIndex = matchedRuleIndex, matchedCondition = matchedCondition}
end
function ____exports.previewRewardMatchWithContext(self, rewardRaw, ctx)
    if not rewardRaw or rewardRaw == "" then
        return {matchedRuleIndex = -1, matchedCondition = ""}
    end
    local lines = __TS__StringSplit(rewardRaw, "\n")
    do
        local lineIdx = 0
        while lineIdx < #lines do
            do
                local line = __TS__StringTrim(lines[lineIdx + 1])
                if line == "" then
                    goto __continue125
                end
                local colon = (string.find(line, ":", nil, true) or 0) - 1
                if colon <= 0 then
                    goto __continue125
                end
                local cond = __TS__StringTrim(__TS__StringSubstring(line, 0, colon))
                if not _____662F_5426_5956_52B1_6761_4EF6(cond) then
                    goto __continue125
                end
                if __TS__StringTrim(__TS__StringSubstring(line, colon + 1)) == "" then
                    goto __continue125
                end
                if isConditionMatchedWithContext(nil, cond, ctx) then
                    return {matchedRuleIndex = lineIdx, matchedCondition = cond}
                end
            end
            ::__continue125::
            lineIdx = lineIdx + 1
        end
    end
    return {matchedRuleIndex = -1, matchedCondition = ""}
end
function ____exports.giveRewardToPlayers(self, rewardRaw, triggerPlayerId)
    ____exports.applyRewardWithContext(nil, rewardRaw, {triggerPlayerId = triggerPlayerId})
end
____exports.getPlayerFirstHero = getPlayerFirstHero
return ____exports
