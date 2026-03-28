local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
local getEventUnitDamaged, lowestSetBit, onAnyUnitDamagedAction, runDeferredDamageDisplay, recreateDamageTrigger, jass, g, EVENT_UNIT_DAMAGED_ID, DamageEventQueue, DamageCallbacks, DamageEventNumber, MNDamageEventTrigger, ta, UnitGroup, damagePendingQueue, dotBatchMarkQueue, damageTypeOverrideQueue, remainingType, remainingHigh, ATTR_BITS
function getEventUnitDamaged(self)
    if type(jass.ConvertUnitEvent) == "function" then
        return jass.ConvertUnitEvent(EVENT_UNIT_DAMAGED_ID)
    end
    return nil
end
--- 检测位标志（Lua5.1 无 & 运算符）
function ____exports.hasBit(self, v, ____bit)
    return math.floor(v / ____bit) % 2 >= 1
end
function lowestSetBit(self, v)
    do
        local i = 0
        while i < #ATTR_BITS do
            if ____exports.hasBit(nil, v, ATTR_BITS[i + 1]) then
                return ATTR_BITS[i + 1]
            end
            i = i + 1
        end
    end
    return 0
end
function onAnyUnitDamagedAction(self)
    local gu = g
    local j = jass
    local ____temp_5
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_5 = jass.GetTriggerUnit()
    else
        local ____temp_4
        if j.udg_TempUnit ~= nil then
            ____temp_4 = j.udg_TempUnit[5]
        else
            ____temp_4 = nil
        end
        ____temp_5 = ____temp_4
    end
    local savedUnit = ____temp_5
    local jr = jass.udg_TempReal
    local ____temp_6
    if type(jass.GetEventDamage) == "function" then
        ____temp_6 = jass.GetEventDamage()
    else
        ____temp_6 = jr ~= nil and type(jr[1]) == "number" and jr[1] or 0
    end
    local savedDamage = ____temp_6
    local savedSource = nil
    if type(g.GetEventDamageSource) == "function" then
        savedSource = g:GetEventDamageSource()
    end
    if savedSource == nil and type(jass.GetEventDamageSource) == "function" then
        savedSource = jass.GetEventDamageSource()
    end
    if savedSource == nil and type(jass.BlzGetEventDamageSource) == "function" then
        savedSource = jass.BlzGetEventDamageSource()
    end
    if savedSource == nil and j.udg_TempUnit ~= nil and j.udg_TempUnit[6] ~= nil then
        savedSource = j.udg_TempUnit[6]
    end
    if j.udg_TempUnit ~= nil then
        j.udg_TempUnit[5] = savedUnit
        if savedSource ~= nil then
            j.udg_TempUnit[6] = savedSource
        end
    end
    if jr ~= nil then
        jr[10] = 0
    end
    local i = 0
    while i < DamageEventNumber do
        local trg = DamageEventQueue[i + 1]
        if trg ~= nil and type(jass.IsTriggerEnabled) == "function" and jass.IsTriggerEnabled(trg) then
            if type(jass.TriggerEvaluate) == "function" and jass.TriggerEvaluate(trg) then
                if type(jass.TriggerExecute) == "function" then
                    jass.TriggerExecute(trg)
                end
            end
        end
        i = i + 1
    end
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local tRead = jass.CreateTimer()
        local function afterRead()
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(tRead)
            end
            local jrAfter = jass.udg_TempReal
            local ____temp_7
            if jrAfter ~= nil then
                ____temp_7 = jrAfter[10]
            else
                ____temp_7 = nil
            end
            local tr10 = ____temp_7
            if jrAfter ~= nil then
                jrAfter[10] = 0
            end
            local finalDamage = savedDamage
            if type(tr10) == "number" and not __TS__NumberIsNaN(__TS__Number(tr10)) and tr10 > 0 then
                finalDamage = tr10
            end
            if jr ~= nil then
                jr[1] = finalDamage
            end
            local ____temp_8
            if #damageTypeOverrideQueue > 0 then
                ____temp_8 = table.remove(damageTypeOverrideQueue, 1)
            else
                ____temp_8 = nil
            end
            local override = ____temp_8
            local ____temp_9
            if #dotBatchMarkQueue > 0 then
                ____temp_9 = table.remove(dotBatchMarkQueue, 1) == true
            else
                ____temp_9 = false
            end
            local fromDotTickBatch = ____temp_9
            damagePendingQueue[#damagePendingQueue + 1] = {
                unit = savedUnit,
                damage = finalDamage,
                source = savedSource,
                damageTypeOverride = type(override) == "number" and override or nil,
                fromDotTickBatch = fromDotTickBatch
            }
            runDeferredDamageDisplay(nil)
        end
        jass.TimerStart(tRead, 0, false, afterRead)
    else
        local jrAfter = jass.udg_TempReal
        local ____temp_10
        if jrAfter ~= nil then
            ____temp_10 = jrAfter[10]
        else
            ____temp_10 = nil
        end
        local tr10 = ____temp_10
        if jrAfter ~= nil then
            jrAfter[10] = 0
        end
        local finalDamage = savedDamage
        if type(tr10) == "number" and not __TS__NumberIsNaN(__TS__Number(tr10)) and tr10 > 0 then
            finalDamage = tr10
        end
        if jr ~= nil then
            jr[1] = finalDamage
        end
        local ____temp_11
        if #damageTypeOverrideQueue > 0 then
            ____temp_11 = table.remove(damageTypeOverrideQueue, 1)
        else
            ____temp_11 = nil
        end
        local override = ____temp_11
        local ____temp_12
        if #dotBatchMarkQueue > 0 then
            ____temp_12 = table.remove(dotBatchMarkQueue, 1) == true
        else
            ____temp_12 = false
        end
        local fromDotTickBatch = ____temp_12
        damagePendingQueue[#damagePendingQueue + 1] = {
            unit = savedUnit,
            damage = finalDamage,
            source = savedSource,
            damageTypeOverride = type(override) == "number" and override or nil,
            fromDotTickBatch = fromDotTickBatch
        }
        runDeferredDamageDisplay(nil)
    end
end
function runDeferredDamageDisplay(self)
    local gu = g
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local t = jass.CreateTimer()
        local function deferred()
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(t)
            end
            local entry = table.remove(damagePendingQueue, 1)
            if entry == nil then
                return
            end
            local su = entry.unit
            local sd = entry.damage
            local j = jass
            if j.udg_TempUnit ~= nil then
                j.udg_TempUnit[5] = su
                local ____j_udg_TempUnit_14 = j.udg_TempUnit
                local ____temp_13
                if entry.source ~= nil then
                    ____temp_13 = entry.source
                else
                    ____temp_13 = j.udg_TempUnit[6]
                end
                ____j_udg_TempUnit_14[6] = ____temp_13
            end
            local mergedType
            local isFirstInBatch = false
            local isLastInBatch = false
            if entry.damageTypeOverride ~= nil and type(entry.damageTypeOverride) == "number" then
                mergedType = entry.damageTypeOverride
                isFirstInBatch = true
                isLastInBatch = true
            else
                if remainingType <= 0 then
                    isFirstInBatch = true
                    remainingHigh = 0
                    local raw = gu.udg_TempDamageType
                    local rawNum = type(raw) == "number" and raw or (raw == nil and 0 or __TS__Number(raw))
                    remainingType = rawNum - 2048 * math.floor(rawNum / 2048)
                    if remainingType < 0 then
                        remainingType = remainingType + 2048
                    end
                    remainingHigh = (____exports.hasBit(nil, rawNum, 2048) and 2048 or 0) + (____exports.hasBit(nil, rawNum, 4096) and 4096 or 0) + (____exports.hasBit(nil, rawNum, 8192) and 8192 or 0) + (____exports.hasBit(nil, rawNum, 16384) and 16384 or 0)
                    gu.udg_TempDamageType = 0
                end
                local oneBit = lowestSetBit(nil, remainingType)
                remainingType = remainingType - oneBit
                mergedType = oneBit + remainingHigh
                if remainingType <= 0 then
                    remainingHigh = 0
                    gu.udg_TempDamageType = 0
                end
                isFirstInBatch = remainingType <= 0
                isLastInBatch = remainingType <= 0
            end
            if remainingType <= 0 and entry.damageTypeOverride == nil then
                remainingHigh = 0
                gu.udg_TempDamageType = 0
            end
            ____exports.currentDamageType = mergedType
            do
                local c = 0
                while c < #DamageCallbacks do
                    local cb = DamageCallbacks[c + 1]
                    if type(cb) == "function" then
                        cb(nil, su,
                            sd,
                            mergedType,
                            isFirstInBatch,
                            isLastInBatch
                        )
                    end
                    c = c + 1
                end
            end
            if entry.fromDotTickBatch == true then
                pcall(function ()
                        local m = require("系统.04．伤害系统.dot伤害")
                        if m ~= nil and type(m.notifyDotTickBatchDamageDisplayed) == "function" then
                            m:notifyDotTickBatchDamageDisplayed()
                        end
                    end
                )
            end
        end
        jass.TimerStart(t, 0, false, deferred)
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
jass = require("jass.common")
g = require("jass.globals")
local ALOC = 1097625443
EVENT_UNIT_DAMAGED_ID = 52
DamageEventQueue = {}
DamageCallbacks = {}
DamageEventNumber = 0
--- 本次伤害的类型标志位（由 JASS udg_TempDamageType 读取后立即清零），供外部模块直接读取
____exports.currentDamageType = 0
MNDamageEventTrigger = nil
ta = nil
local TimerHandle = nil
UnitGroup = nil
damagePendingQueue = {}
dotBatchMarkQueue = {}
--- 由 dot伤害.dealDamageForType 调用：标记「下一次因伤入队」来自本帧 DOT 秒跳，便于延后清空 dotTickBatchTargetHids
function ____exports.markNextPendingDamageAsDotTickBatch(self)
    dotBatchMarkQueue[#dotBatchMarkQueue + 1] = true
end
damageTypeOverrideQueue = {}
--- Lua 造成的伤害（如 DOT）在调用 UnitDamageTarget 前调用此函数，传入合并类型（如 2048 技能+256 精神=2304），避免被 JASS GetDmgType 覆盖
function ____exports.setNextDamageTypeOverride(self, mergedType)
    damageTypeOverrideQueue[#damageTypeOverrideQueue + 1] = mergedType
end
remainingType = 0
remainingHigh = 0
ATTR_BITS = {
    1,
    2,
    4,
    8,
    16,
    32,
    64,
    128,
    256,
    512,
    1024
}
--- 与 JASS `IsUnitType(u, UNIT_TYPE_HERO)` 一致，优先 jass/globals 的 unittype 常量
local function getUnitTypeHero(self)
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
local function unitDeathCondition(self)
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
local function unitDeathAction(self)
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
local function anyUnitDamagedFilter(self)
    local ____temp_15
    if type(jass.GetFilterUnit) == "function" then
        ____temp_15 = jass.GetFilterUnit()
    else
        ____temp_15 = nil
    end
    local u = ____temp_15
    if not u then
        return false
    end
    local ____temp_16
    if type(jass.GetUnitAbilityLevel) == "function" then
        ____temp_16 = jass.GetUnitAbilityLevel(u, ALOC)
    else
        ____temp_16 = 0
    end
    local lvl = ____temp_16
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
local function initEnumUnit(self)
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
    local ____jass_EVENT_PLAYER_UNIT_DEATH_17 = jass.EVENT_PLAYER_UNIT_DEATH
    if ____jass_EVENT_PLAYER_UNIT_DEATH_17 == nil then
        ____jass_EVENT_PLAYER_UNIT_DEATH_17 = 52
    end
    local evDeath = ____jass_EVENT_PLAYER_UNIT_DEATH_17
    if type(CreateTrigger) ~= "function" or type(CreateRegion) ~= "function" then
        return
    end
    local t = CreateTrigger()
    local r = CreateRegion()
    local ____temp_18
    if type(CreateGroup) == "function" then
        ____temp_18 = CreateGroup()
    else
        ____temp_18 = nil
    end
    local grp = ____temp_18
    local ____temp_19
    if type(GetWorldBounds) == "function" then
        ____temp_19 = GetWorldBounds()
    else
        ____temp_19 = nil
    end
    local bounds = ____temp_19
    if bounds and type(RegionAddRect) == "function" then
        RegionAddRect(r, bounds)
    end
    if type(TriggerRegisterEnterRegion) == "function" then
        local ____temp_20
        if type(Condition) == "function" then
            ____temp_20 = Condition(anyUnitDamagedFilter)
        else
            ____temp_20 = nil
        end
        TriggerRegisterEnterRegion(t, r, ____temp_20)
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
                    local ____temp_21
                    if type(jass.GetUnitAbilityLevel) == "function" then
                        ____temp_21 = jass.GetUnitAbilityLevel(u, ALOC)
                    else
                        ____temp_21 = 0
                    end
                    local lvl = ____temp_21
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
local function timeout(self)
    recreateDamageTrigger()
end
--- 注册一个触发器：当任意单位受到伤害时，若该触发器启用且条件通过则执行。
-- 
-- @param trg 触发器（需在 JASS/TS 中创建并设置 condition/action）
-- @param intervalSeconds 定期重建伤害触发的间隔（秒），用于避免泄漏/堆积
function ____exports.MNAnyUnitDamaged(self, trg, intervalSeconds)
    if trg == nil then
        return
    end
    if DamageEventNumber == 0 then
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
        if type(jass.CreateTimer) == "function" and intervalSeconds > 0 then
            TimerHandle = jass.CreateTimer()
            if TimerHandle and type(jass.TimerStart) == "function" then
                jass.TimerStart(TimerHandle, intervalSeconds, true, timeout)
            end
        end
    end
    DamageEventQueue[DamageEventNumber + 1] = trg
    DamageEventNumber = DamageEventNumber + 1
end
--- 注册 Lua 回调：单位受伤时直接调用，不依赖 TriggerExecute（引擎可能不执行 Lua 动作）
function ____exports.registerDamageCallback(self, cb, intervalSeconds)
    if type(cb) ~= "function" then
        return
    end
    if MNDamageEventTrigger == nil then
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
        if type(jass.CreateTimer) == "function" then
            TimerHandle = jass.CreateTimer()
            if TimerHandle and type(jass.TimerStart) == "function" then
                jass.TimerStart(TimerHandle, sec, true, timeout)
            end
        end
    end
    DamageCallbacks[#DamageCallbacks + 1] = cb
end
return ____exports
