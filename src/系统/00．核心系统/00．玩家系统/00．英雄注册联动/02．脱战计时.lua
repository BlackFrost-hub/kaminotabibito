--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 脱战计时系统
-- 
-- 功能：
-- 1. 玩家英雄受到伤害时启动18秒计时器
-- 2. 计时器到期后恢复生命/魔法到100%，添加脱战移速技能
-- 3. 若有脱战buff且受到超过1%最大生命伤害，移除脱战移速技能
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("lib.扩展函数.BJ函数.index")
local SetUnitLifePercentBJ = ____require_result_1.SetUnitLifePercentBJ
local SetUnitManaPercentBJ = ____require_result_1.SetUnitManaPercentBJ
local UnitHasBuffBJ = ____require_result_1.UnitHasBuffBJ
local ____require_result_2 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_2.registerDamageCallback
--- 脱战计时时间（秒）
local OUT_OF_COMBAT_TIME = 18
--- 脱战移速技能ID
local OUT_OF_COMBAT_SPEED_ABILITY = 1093677378
--- 脱战buff ID
local OUT_OF_COMBAT_BUFF = 1110454321
--- 伤害阈值比例（1%）
local DAMAGE_THRESHOLD_RATIO = 0.01
--- 玩家脱战计时器（玩家0-3对应索引1-4）
local outOfCombatTimers = {
    nil,
    nil,
    nil,
    nil,
    nil
}
local timerTrigger = nil
--- 检查单位是否为玩家英雄
local function isPlayerHero(self, unit)
    if unit == nil then
        return false
    end
    if not jass.IsUnitType(unit, jass.UNIT_TYPE_HERO) then
        return false
    end
    local heroGroup = YDUserDataGet(
        nil,
        "string",
        "玩家英雄",
        "单位组",
        "group"
    )
    if heroGroup == nil then
        return false
    end
    local found = false
    jass.ForGroup(
        heroGroup,
        function()
            if jass.GetEnumUnit() == unit then
                found = true
            end
        end
    )
    return found
end
--- 获取玩家ID（0-3）
local function getPlayerId(self, unit)
    if unit == nil then
        return -1
    end
    local owner = jass.GetOwningPlayer(unit)
    if owner == nil then
        return -1
    end
    return jass.GetPlayerId(owner)
end
--- 启动脱战计时器
local function startOutOfCombatTimer(self, playerId)
    if playerId < 0 or playerId > 3 then
        return
    end
    local timerIndex = playerId + 1
    local timer = outOfCombatTimers[timerIndex + 1]
    if timer == nil then
        timer = jass.CreateTimer()
        outOfCombatTimers[timerIndex + 1] = timer
    end
    jass.TimerStart(
        timer,
        OUT_OF_COMBAT_TIME,
        false,
        function()
        end
    )
end
--- 处理脱战完成
local function onOutOfCombat(self, playerId)
    local heroGroup = YDUserDataGet(
        nil,
        "string",
        "玩家英雄",
        "单位组",
        "group"
    )
    if heroGroup == nil then
        return
    end
    jass.ForGroup(
        heroGroup,
        function()
            local unit = jass.GetEnumUnit()
            if unit == nil then
                return
            end
            local owner = jass.GetOwningPlayer(unit)
            if jass.GetPlayerId(owner) ~= playerId then
                return
            end
            jass.DisplayTimedTextToPlayer(
                owner,
                0,
                0,
                30,
                "脱战成功！生命和魔法已恢复。"
            )
            jass.UnitAddAbility(unit, OUT_OF_COMBAT_SPEED_ABILITY)
            SetUnitLifePercentBJ(nil, unit, 100)
            SetUnitManaPercentBJ(nil, unit, 100)
            jass.SetUnitPathing(unit, true)
        end
    )
end
--- 检查并移除脱战buff（受到大伤害时）
local function checkRemoveOutOfCombatBuff(self, unit, damage)
    if not UnitHasBuffBJ(nil, unit, OUT_OF_COMBAT_BUFF) then
        return
    end
    local maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE)
    local threshold = maxLife * DAMAGE_THRESHOLD_RATIO
    if damage >= threshold then
        jass.UnitRemoveAbility(unit, OUT_OF_COMBAT_SPEED_ABILITY)
        jass.UnitRemoveAbility(unit, OUT_OF_COMBAT_BUFF)
        local owner = jass.GetOwningPlayer(unit)
        jass.DisplayTimedTextToPlayer(
            owner,
            0,
            0,
            30,
            "|cffff0000『进入战斗状态』|r"
        )
    end
end
--- 单位受伤事件处理（通过统一伤害事件回调）
local function onUnitDamaged(self, unit, damage, _damageType, _fromDotTickBatch, _source, _isNormalAttack)
    if jass.IsUnitIllusion(unit) then
        return
    end
    if damage < 1 then
        return
    end
    if not isPlayerHero(nil, unit) then
        return
    end
    checkRemoveOutOfCombatBuff(nil, unit, damage)
    local playerId = getPlayerId(nil, unit)
    startOutOfCombatTimer(nil, playerId)
end
--- 计时器到期事件处理
local function onTimerExpire(self)
    local expiredTimer = jass.GetExpiredTimer()
    do
        local i = 1
        while i <= 4 do
            if outOfCombatTimers[i + 1] == expiredTimer then
                onOutOfCombat(nil, i - 1)
                return
            end
            i = i + 1
        end
    end
end
local _initialized = false
--- 初始化脱战计时系统
function ____exports.initOutOfCombat(self)
    if _initialized then
        return
    end
    _initialized = true
    registerDamageCallback(nil, onUnitDamaged)
    timerTrigger = jass.CreateTrigger()
    do
        local i = 1
        while i <= 4 do
            local timer = jass.CreateTimer()
            outOfCombatTimers[i + 1] = timer
            jass.TriggerRegisterTimerExpireEvent(timerTrigger, timer)
            i = i + 1
        end
    end
    jass.TriggerAddAction(timerTrigger, onTimerExpire)
end
return ____exports
