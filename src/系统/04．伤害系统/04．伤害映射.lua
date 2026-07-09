--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 04．伤害映射
-- 
-- 将召唤物、马甲等代理单位造成的伤害，
-- 映射为主人单位造成的伤害。
-- 
-- 默认规则：玩家 0-4 的非英雄单位归属到该玩家英雄。
-- 可选规则：业务可以显式调用 登记伤害来源主人(source, owner)，
-- 让非玩家代理单位也归属到指定主人。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local _____73A9_5BB6_5E38_91CF = require("系统.00．核心系统.00．玩家系统.00．常量")
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local IsUnitType = jass.IsUnitType
local GetHandleId = jass.GetHandleId
local Player = jass.Player
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
--- 玩家 ID → 该玩家的英雄引用缓存
local _____73A9_5BB6_82F1_96C4_7F13_5B58 = {}
--- 代理单位 handleId → 伤害主人单位
local _____663E_5F0F_4F24_5BB3_4E3B_4EBA_8868 = {}
--- 获取玩家 0-4 的英雄（带缓存，首次通过 YDUserData 查询）
local function _____53D6_73A9_5BB6_82F1_96C4(playerId)
    if playerId < 0 or playerId > 4 then
        return nil
    end
    if _____73A9_5BB6_82F1_96C4_7F13_5B58[playerId] ~= nil then
        return _____73A9_5BB6_82F1_96C4_7F13_5B58[playerId]
    end
    local player = Player(playerId)
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
--- 显式登记代理单位的伤害主人。
-- 适合 Boss/特殊召唤物这类无法只靠所属玩家推导主人单位的场景。
____exports["登记伤害来源主人"] = function(source, owner)
    if source == nil or source == 0 then
        return
    end
    if owner == nil or owner == 0 then
        return
    end
    if source == owner then
        return
    end
    _____663E_5F0F_4F24_5BB3_4E3B_4EBA_8868[GetHandleId(source)] = owner
end
--- 清除代理单位的显式伤害主人登记。
____exports["清除伤害来源主人"] = function(source)
    if source == nil or source == 0 then
        return
    end
    _____663E_5F0F_4F24_5BB3_4E3B_4EBA_8868[GetHandleId(source)] = nil
end
local function _____53D6_663E_5F0F_4F24_5BB3_4E3B_4EBA(source, target)
    local owner = _____663E_5F0F_4F24_5BB3_4E3B_4EBA_8868[GetHandleId(source)]
    if owner == nil or owner == 0 then
        return nil
    end
    if owner == source then
        return nil
    end
    if target ~= nil and target ~= 0 and owner == target then
        return nil
    end
    return owner
end
local function _____53D6_73A9_5BB6_4EE3_7406_4F24_5BB3_4E3B_4EBA(source)
    local owner = GetOwningPlayer(source)
    if owner == nil or owner == 0 then
        return nil
    end
    local pid = GetPlayerId(owner)
    if pid < 0 or pid > 4 then
        return nil
    end
    local hero = _____53D6_73A9_5BB6_82F1_96C4(pid)
    local ____temp_1
    if hero ~= nil and hero ~= 0 and hero ~= source then
        ____temp_1 = hero
    else
        ____temp_1 = nil
    end
    return ____temp_1
end
--- 获取归属后的伤害来源。
-- 若 attacker 是玩家 0-4 的非英雄代理单位，或显式登记过主人，返回主人单位；
-- 否则返回原 attacker。
____exports["获取伤害归属单位"] = function(attacker, target)
    if attacker == nil or attacker == 0 then
        return attacker
    end
    if target == nil or target == 0 then
        return attacker
    end
    if attacker == target then
        return attacker
    end
    if IsUnitType(attacker, UNIT_TYPE_HERO) then
        return attacker
    end
    local explicitOwner = _____53D6_663E_5F0F_4F24_5BB3_4E3B_4EBA(attacker, target)
    if explicitOwner ~= nil and explicitOwner ~= 0 then
        return explicitOwner
    end
    local playerOwner = _____53D6_73A9_5BB6_4EE3_7406_4F24_5BB3_4E3B_4EBA(attacker)
    local ____temp_2
    if playerOwner ~= nil and playerOwner ~= 0 then
        ____temp_2 = playerOwner
    else
        ____temp_2 = attacker
    end
    return ____temp_2
end
--- 兼容旧调用名。
____exports["获取映射攻击者"] = function(attacker, target)
    return ____exports["获取伤害归属单位"](attacker, target)
end
return ____exports
