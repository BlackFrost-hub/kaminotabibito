--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 01．仇恨计算
-- 
-- 注册到伤害系统最终伤害通知，敌人（target）对攻击者（attacker）产生仇恨。
-- 公式：仇恨值 = (实际伤害 / 目标最大生命值) * 1000
-- 
-- 攻击者会经过 伤害映射 处理：玩家 0-4 的非英雄单位被映射为对应玩家英雄。
-- 玩家判定范围 0-4（含未来扩展的玩家4）。
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_1.isUnitEnemy
local ____require_result_2 = require("系统.04．伤害系统.04．伤害映射")
local _____83B7_53D6_6620_5C04_653B_51FB_8005 = ____require_result_2["获取映射攻击者"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local addThreat = ____require_result_3.addThreat
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
--- 仇恨系统自己的玩家判定：玩家 0-4 为玩家单位，其余为 NPC/电脑
local function _____662F_73A9_5BB6_5355_4F4D(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    local pid = GetPlayerId(owner)
    return pid >= 0 and pid <= 4
end
local _____5DF2_6CE8_518C = false
local function onDamage(target, attacker, applied)
    if attacker == nil or attacker == 0 then
        return
    end
    if target == nil or target == 0 then
        return
    end
    if target == attacker then
        return
    end
    if applied <= 0 then
        return
    end
    attacker = _____83B7_53D6_6620_5C04_653B_51FB_8005(attacker, target)
    local _____654C_5BF9_7ED3_679C = isUnitEnemy(attacker, target)
    local ____attacker_662F_73A9_5BB6_5355_4F4D = _____662F_73A9_5BB6_5355_4F4D(attacker)
    local ____target_662F_73A9_5BB6_5355_4F4D = _____662F_73A9_5BB6_5355_4F4D(target)
    if not _____654C_5BF9_7ED3_679C then
        return
    end
    if ____target_662F_73A9_5BB6_5355_4F4D then
        return
    end
    if not ____attacker_662F_73A9_5BB6_5355_4F4D then
        return
    end
    local maxHp = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    if maxHp <= 0 then
        return
    end
    local threat = applied / maxHp * 1000
    addThreat(target, attacker, threat)
end
____exports["注册伤害仇恨回调"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(onDamage)
end
return ____exports
