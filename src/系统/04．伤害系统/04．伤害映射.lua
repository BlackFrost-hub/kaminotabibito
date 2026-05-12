--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 04．伤害映射
-- 
-- 将玩家 0-4 所有单位（英雄 + 宠物 + 召唤物 + 马甲）造成的伤害，
-- 映射为当前玩家唯一英雄造成的伤害。
-- 
-- 使用方式：仇恨计算系统在收到伤害回调后，调用 获取映射攻击者(attacker, target)
-- 将非英雄的攻击者替换为玩家英雄。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local _____73A9_5BB6_5E38_91CF = require("系统.00．核心系统.00．玩家系统.00．常量")
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local IsUnitType = jass.IsUnitType
--- 玩家 ID → 该玩家的英雄引用缓存
local _____73A9_5BB6_82F1_96C4_7F13_5B58 = {}
--- 获取玩家 0-4 的英雄（带缓存，首次通过 YDUserData 查询）
local function _____53D6_73A9_5BB6_82F1_96C4(playerId)
    if playerId < 0 or playerId > 4 then
        return nil
    end
    if _____73A9_5BB6_82F1_96C4_7F13_5B58[playerId] ~= nil then
        return _____73A9_5BB6_82F1_96C4_7F13_5B58[playerId]
    end
    local player = jass.Player(playerId)
    local hero = YDUserDataGet(
        nil,
        "player",
        player,
        _____73A9_5BB6_5E38_91CF.YD_ATTR_PLAYER_HERO_UNIT,
        "unit"
    )
    if hero ~= nil and hero ~= 0 then
        _____73A9_5BB6_82F1_96C4_7F13_5B58[playerId] = hero
        return hero
    end
    return nil
end
--- 获取映射后的攻击者。
-- 若 attacker 是玩家 0-4 的非英雄单位（非自伤），返回对应的玩家英雄；
-- 否则返回原 attacker。
____exports["获取映射攻击者"] = function(attacker, target)
    if attacker == nil or attacker == 0 then
        return attacker
    end
    if target == nil or target == 0 then
        return attacker
    end
    if attacker == target then
        return attacker
    end
    if IsUnitType(attacker, jass.UNIT_TYPE_HERO) then
        return attacker
    end
    local owner = GetOwningPlayer(attacker)
    if owner == nil or owner == 0 then
        return attacker
    end
    local pid = GetPlayerId(owner)
    if pid < 0 or pid > 4 then
        return attacker
    end
    local hero = _____53D6_73A9_5BB6_82F1_96C4(pid)
    local ____temp_1
    if hero ~= nil and hero ~= 0 then
        ____temp_1 = hero
    else
        ____temp_1 = attacker
    end
    return ____temp_1
end
return ____exports
