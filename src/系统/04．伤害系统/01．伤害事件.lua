--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local getEventUnitDamaged, getUnitTypeHero, unitDeathCondition, unitDeathAction, onAnyUnitDamagedAction, processDamageEntry, anyUnitDamagedFilter, initEnumUnit, recreateDamageTrigger, timeout, initDamageEventOnce, jass, g, _____4F24_5BB3_51FD_6570, ALOC, EVENT_UNIT_DAMAGED_ID, DamageEventQueue, DamageCallbacks, DamageEventNumber, MNDamageEventTrigger, ta, TimerHandle, UnitGroup, dotBatchMarkQueue
function getEventUnitDamaged(self)
    if type(jass.ConvertUnitEvent) == "function" then
        return jass.ConvertUnitEvent(EVENT_UNIT_DAMAGED_ID)
    end
    return nil
end
function getUnitTypeHero(self)
    local ____jass_UNIT_TYPE_HERO_0 = jass.UNIT_TYPE_HERO
    if ____jass_UNIT_TYPE_HERO_0 == nil then
        ____jass_UNIT_TYPE_HERO_0 = g.UNIT_TYPE_HERO
    end
    local direct = ____jass_UNIT_TYPE_HERO_0
    if direct ~= nil then
        return direct
    end
    if type(jass.ConvertUnitType) ~= "function" then
        return nil
    end
    return jass.ConvertUnitType(2)
end
function unitDeathCondition(self)
    local ____temp_1
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_1 = jass.GetTriggerUnit()
    else
        ____temp_1 = nil
    end
    local u = ____temp_1
    if not u then
        return false
    end
    local utHero = getUnitTypeHero()
    local ____temp_2
    if utHero ~= nil and type(jass.IsUnitType) == "function" then
        ____temp_2 = jass.IsUnitType(u, utHero)
    else
        ____temp_2 = false
    end
    local isHero = ____temp_2
    return isHero ~= true
end
function unitDeathAction(self)
    if not UnitGroup then
        return
    end
    local ____temp_3
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_3 = jass.GetTriggerUnit()
    else
        ____temp_3 = nil
    end
    local u = ____temp_3
    if not u then
        return
    end
    if type(jass.GroupRemoveUnit) == "function" then
        jass.GroupRemoveUnit(UnitGroup, u)
    end
    recreateDamageTrigger()
end
function onAnyUnitDamagedAction(self)
    local j = jass
    local ____temp_4
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_4 = jass.GetTriggerUnit()
    else
        ____temp_4 = nil
    end
    local savedUnit = ____temp_4
    local ____temp_5
    if type(jass.GetEventDamage) == "function" then
        ____temp_5 = jass.GetEventDamage()
    else
        ____temp_5 = 0
    end
    local savedDamage = ____temp_5
    local savedSource = nil
    if type(jass.GetEventDamageSource) == "function" then
        pcall(function ()
                savedSource = jass.GetEventDamageSource()
            end
        )
    end
    if savedSource == nil then
        pcall(function ()
                savedSource = GetEventDamageSource()
            end
        )
    end
    if savedSource == nil and type(jass.BlzGetEventDamageSource) == "function" then
        pcall(function ()
                savedSource = jass.BlzGetEventDamageSource()
            end
        )
    end
    local i = 0
    while i < DamageEventNumber do
        local trg = DamageEventQueue[i + 1]
        if trg ~= nil then
            local enabled = false
            local evaluated = false
            if type(jass.IsTriggerEnabled) == "function" then
                pcall(function ()
                        if jass.IsTriggerEnabled(trg) then
                            enabled = true
                        end
                    end
                )
            end
            if enabled then
                if type(jass.TriggerEvaluate) == "function" then
                    pcall(function ()
                            if jass.TriggerEvaluate(trg) then
                                evaluated = true
                            end
                        end
                    )
                end
                if evaluated then
                    if type(jass.TriggerExecute) == "function" then
                        pcall(function ()
                                jass.TriggerExecute(trg)
                            end
                        )
                    end
                end
            end
        end
        i = i + 1
    end
    local ____temp_6
    if #dotBatchMarkQueue > 0 then
        ____temp_6 = table.remove(dotBatchMarkQueue, 1) == true
    else
        ____temp_6 = false
    end
    local fromDotTickBatchForEvent = ____temp_6
    local isNormalAttackSnap = false
    if not fromDotTickBatchForEvent then
        pcall(function ()
                if _____4F24_5BB3_51FD_6570.isNormalAttack() == true then
                    isNormalAttackSnap = true
                end
            end
        )
    end
    local entry = {
        unit = savedUnit,
        damage = savedDamage,
        source = savedSource,
        fromDotTickBatch = fromDotTickBatchForEvent,
        isNormalAttack = isNormalAttackSnap
    }
    processDamageEntry(nil, entry)
end
function processDamageEntry(self, entry)
    local su = entry.unit
    local sd = entry.damage
    local isDotTickDamage = entry.fromDotTickBatch == true
    if entry.isNormalAttack == true and not isDotTickDamage then
        pcall(function ()
                local dm = require("系统.04．伤害系统.02．dot伤害")
                if dm ~= nil and type(dm.tryApplyHeroAttackGearDots) == "function" then
                    local ____dm_tryApplyHeroAttackGearDots_8 = dm.tryApplyHeroAttackGearDots
                    local ____temp_7
                    if entry.source ~= nil then
                        ____temp_7 = entry.source
                    else
                        ____temp_7 = nil
                    end
                    ____dm_tryApplyHeroAttackGearDots_8(dm, ____temp_7, su, sd)
                end
            end
        )
    end
    do
        local c = 0
        while c < #DamageCallbacks do
            local cb = DamageCallbacks[c + 1]
            if cb ~= nil then
                cb(
                    nil,
                    su,
                    sd,
                    0,
                    isDotTickDamage,
                    entry.source,
                    entry.isNormalAttack
                )
            end
            c = c + 1
        end
    end
    if isDotTickDamage then
        pcall(function ()
                local m = require("系统.04．伤害系统.02．dot伤害")
                if m ~= nil and type(m.notifyDotTickBatchDamageDisplayed) == "function" then
                    m:notifyDotTickBatchDamageDisplayed()
                end
            end
        )
    end
end
function anyUnitDamagedFilter(self)
    local ____temp_9
    if type(jass.GetFilterUnit) == "function" then
        ____temp_9 = jass.GetFilterUnit()
    else
        ____temp_9 = nil
    end
    local u = ____temp_9
    if not u then
        return false
    end
    local ____temp_10
    if type(jass.GetUnitAbilityLevel) == "function" then
        ____temp_10 = jass.GetUnitAbilityLevel(u, ALOC)
    else
        ____temp_10 = 0
    end
    local lvl = ____temp_10
    if lvl > 0 then
        return false
    end
    if UnitGroup and type(jass.GroupAddUnit) == "function" then
        jass.GroupAddUnit(UnitGroup, u)
    end
    if MNDamageEventTrigger and type(jass.TriggerRegisterUnitEvent) == "function" then
        local ev = getEventUnitDamaged()
        if ev ~= nil then
            jass.TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev)
        end
    end
    return false
end
function initEnumUnit(self)
    local CreateTrigger = jass.CreateTrigger
    local CreateRegion = jass.CreateRegion
    local CreateGroup = jass.CreateGroup
    local GetWorldBounds = jass.GetWorldBounds
    local RegionAddRect = jass.RegionAddRect
    local TriggerRegisterEnterRegion = jass.TriggerRegisterEnterRegion
    local Condition = jass.Condition
    local TriggerAddCondition = jass.TriggerAddCondition
    local TriggerAddAction = jass.TriggerAddAction
    local GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect
    local DestroyGroup = jass.DestroyGroup
    local RegisterPlayerUnitEvent = jass.TriggerRegisterPlayerUnitEvent
    local ____jass_EVENT_PLAYER_UNIT_DEATH_11 = jass.EVENT_PLAYER_UNIT_DEATH
    if ____jass_EVENT_PLAYER_UNIT_DEATH_11 == nil then
        ____jass_EVENT_PLAYER_UNIT_DEATH_11 = 52
    end
    local evDeath = ____jass_EVENT_PLAYER_UNIT_DEATH_11
    if type(CreateTrigger) ~= "function" or type(CreateRegion) ~= "function" then
        return
    end
    local t = CreateTrigger()
    local r = CreateRegion()
    local ____temp_12
    if type(CreateGroup) == "function" then
        ____temp_12 = CreateGroup()
    else
        ____temp_12 = nil
    end
    local grp = ____temp_12
    local ____temp_13
    if type(GetWorldBounds) == "function" then
        ____temp_13 = GetWorldBounds()
    else
        ____temp_13 = nil
    end
    local bounds = ____temp_13
    if bounds and type(RegionAddRect) == "function" then
        RegionAddRect(r, bounds)
    end
    if type(TriggerRegisterEnterRegion) == "function" then
        local ____temp_14
        if type(Condition) == "function" then
            ____temp_14 = Condition(anyUnitDamagedFilter)
        else
            ____temp_14 = nil
        end
        TriggerRegisterEnterRegion(t, r, ____temp_14)
    end
    if grp and bounds and type(GroupEnumUnitsInRect) == "function" and type(Condition) == "function" then
        local function alwaysTrue()
            return true
        end
        GroupEnumUnitsInRect(grp,
            bounds,
            Condition(alwaysTrue)
        )
        if UnitGroup and MNDamageEventTrigger and type(jass.ForGroup) == "function" and type(jass.TriggerRegisterUnitEvent) == "function" then
            jass.ForGroup(
                grp,
                function()
                    local u = jass.GetEnumUnit()
                    if not u then
                        return
                    end
                    local ____temp_15
                    if type(jass.GetUnitAbilityLevel) == "function" then
                        ____temp_15 = jass.GetUnitAbilityLevel(u, ALOC)
                    else
                        ____temp_15 = 0
                    end
                    local lvl = ____temp_15
                    if lvl > 0 then
                        return
                    end
                    jass.GroupAddUnit(UnitGroup, u)
                    local ev = getEventUnitDamaged()
                    if ev ~= nil and type(jass.TriggerRegisterUnitEvent) == "function" then
                        jass.TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev)
                    end
                end
            )
        end
    end
    local trideath = CreateTrigger()
    if type(RegisterPlayerUnitEvent) == "function" and evDeath ~= nil then
        do
            local pi = 0
            while pi <= 15 do
                local p = jass.Player(pi)
                if p ~= nil then
                    RegisterPlayerUnitEvent(trideath,
                        p,
                        evDeath,
                        nil
                    )
                end
                pi = pi + 1
            end
        end
    end
    if type(TriggerAddCondition) == "function" and type(Condition) == "function" then
        TriggerAddCondition(trideath,
            Condition(unitDeathCondition)
        )
    end
    if type(TriggerAddAction) == "function" then
        TriggerAddAction(trideath, unitDeathAction)
    end
    if type(DestroyGroup) == "function" and grp then
        DestroyGroup(grp)
    end
end
function recreateDamageTrigger(self)
    if MNDamageEventTrigger and type(jass.TriggerRemoveAction) == "function" and ta ~= nil then
        jass.TriggerRemoveAction(MNDamageEventTrigger, ta)
    end
    if MNDamageEventTrigger and type(jass.DestroyTrigger) == "function" then
        jass.DestroyTrigger(MNDamageEventTrigger)
    end
    if type(jass.CreateTrigger) == "function" then
        MNDamageEventTrigger = jass.CreateTrigger()
    end
    if MNDamageEventTrigger and type(jass.TriggerAddAction) == "function" then
        ta = jass.TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction)
    end
    if UnitGroup and type(jass.ForGroup) == "function" and MNDamageEventTrigger then
        local ev = getEventUnitDamaged()
        if ev ~= nil then
            jass.ForGroup(
                UnitGroup,
                function()
                    local u = jass.GetEnumUnit()
                    if u and type(jass.TriggerRegisterUnitEvent) == "function" then
                        jass.TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev)
                    end
                end
            )
        end
    end
end
function timeout(self)
    recreateDamageTrigger()
end
function initDamageEventOnce(self, intervalSeconds)
    if MNDamageEventTrigger ~= nil then
        return
    end
    if type(jass.CreateTrigger) == "function" then
        MNDamageEventTrigger = jass.CreateTrigger()
    end
    if type(jass.CreateGroup) == "function" then
        UnitGroup = jass.CreateGroup()
    end
    if MNDamageEventTrigger and type(jass.TriggerAddAction) == "function" then
        ta = jass.TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction)
    end
    initEnumUnit()
    local sec = type(intervalSeconds) == "number" and intervalSeconds > 0 and intervalSeconds or 60
    if type(jass.CreateTimer) == "function" and TimerHandle == nil then
        TimerHandle = jass.CreateTimer()
        if TimerHandle and type(jass.TimerStart) == "function" then
            jass.TimerStart(TimerHandle, sec, true, timeout)
        end
    end
end
jass = require("jass.common")
g = require("jass.globals")
_____4F24_5BB3_51FD_6570 = require("系统.00．核心系统.08．伤害函数")
ALOC = 1097625443
EVENT_UNIT_DAMAGED_ID = 52
DamageEventQueue = {}
DamageCallbacks = {}
DamageEventNumber = 0
MNDamageEventTrigger = nil
ta = nil
TimerHandle = nil
UnitGroup = nil
--- 伤害事件队列
local damagePendingQueue = {}
dotBatchMarkQueue = {}
--- 由 dot伤害.dealDamageForType 调用：标记「下一次因伤入队」来自本帧 DOT 秒跳，便于延后清空 dotTickBatchTargetHids
function ____exports.markNextPendingDamageAsDotTickBatch(self)
    dotBatchMarkQueue[#dotBatchMarkQueue + 1] = true
end
--- 注册一个触发器：当任意单位受到伤害时，若该触发器启用且条件通过则执行。
-- 
-- @param trg 触发器（需在 JASS/TS 中创建并设置 condition/action）
-- @param intervalSeconds 定期重建伤害触发的间隔（秒），用于避免泄漏/堆积
function ____exports.MNAnyUnitDamaged(self, trg, intervalSeconds)
    if trg == nil then
        return
    end
    initDamageEventOnce(nil, intervalSeconds)
    DamageEventQueue[DamageEventNumber + 1] = trg
    DamageEventNumber = DamageEventNumber + 1
end
--- 注册 Lua 回调：单位受伤时直接调用，不依赖 TriggerExecute（引擎可能不执行 Lua 动作）
function ____exports.registerDamageCallback(self, cb, intervalSeconds)
    if cb == nil then
        return
    end
    initDamageEventOnce(nil, intervalSeconds)
    DamageCallbacks[#DamageCallbacks + 1] = cb
end
return ____exports
