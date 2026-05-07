--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local getEventUnitDamaged, onUnitDeathForDamage, onAnyUnitDamagedAction, processDamageEntry, anyUnitDamagedFilter, initEnumUnit, recreateDamageTrigger, timeout, initDamageEventOnce, jass, luaPcall, _____4F24_5BB3_51FD_6570, isHeroUnit, forEachUnitInGroup, registerDeathListener, ALOC, DamageEventQueue, DamageCallbacks, DamageEventNumber, MNDamageEventTrigger, ta, TimerHandle, UnitGroup, dotBatchMarkQueue
function getEventUnitDamaged()
    return jass.EVENT_UNIT_DAMAGED
end
function onUnitDeathForDamage(dyingUnit)
    if not UnitGroup or not dyingUnit then
        return
    end
    if isHeroUnit(nil, dyingUnit) then
        return
    end
    jass:GroupRemoveUnit(UnitGroup, dyingUnit)
    recreateDamageTrigger()
end
function onAnyUnitDamagedAction()
    local j = jass
    local savedUnit = jass:GetTriggerUnit()
    local savedDamage = jass:GetEventDamage()
    local savedSource = nil
    luaPcall(function()
        savedSource = jass:GetEventDamageSource()
    end)
    if savedSource == nil then
        luaPcall(function()
            savedSource = GetEventDamageSource(nil)
        end)
    end
    local ____temp_3
    if #dotBatchMarkQueue > 0 then
        ____temp_3 = table.remove(dotBatchMarkQueue, 1) == true
    else
        ____temp_3 = false
    end
    local fromDotTickBatchForEvent = ____temp_3
    if not fromDotTickBatchForEvent and savedUnit ~= nil and savedDamage > 0.1 then
        luaPcall(function()
            local dmgCalc = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
            local ____temp_4
            if dmgCalc ~= nil then
                ____temp_4 = dmgCalc.onDamageEvent
            else
                ____temp_4 = nil
            end
            local onDamageEvent = ____temp_4
            if onDamageEvent ~= nil then
                onDamageEvent(nil, savedUnit, savedSource, savedDamage)
            end
        end)
    end
    local i = 0
    while i < DamageEventNumber do
        local trg = DamageEventQueue[i + 1]
        if trg ~= nil then
            local enabled = false
            local evaluated = false
            luaPcall(function()
                if jass:IsTriggerEnabled(trg) then
                    enabled = true
                end
            end)
            if enabled then
                luaPcall(function()
                    if jass:TriggerEvaluate(trg) then
                        evaluated = true
                    end
                end)
                if evaluated then
                    luaPcall(function()
                        jass:TriggerExecute(trg)
                    end)
                end
            end
        end
        i = i + 1
    end
    local isNormalAttackSnap = false
    if not fromDotTickBatchForEvent then
        luaPcall(function()
            if _____4F24_5BB3_51FD_6570:isNormalAttack() == true then
                isNormalAttackSnap = true
            end
        end)
    end
    local entry = {
        unit = savedUnit,
        damage = savedDamage,
        source = savedSource,
        fromDotTickBatch = fromDotTickBatchForEvent,
        isNormalAttack = isNormalAttackSnap
    }
    processDamageEntry(entry)
end
function processDamageEntry(entry)
    local su = entry.unit
    local sd = entry.damage
    local isDotTickDamage = entry.fromDotTickBatch == true
    if entry.isNormalAttack == true and not isDotTickDamage then
        luaPcall(function()
            local dm = require("系统.04．伤害系统.02．dot伤害")
            if dm ~= nil and type(dm.tryApplyHeroAttackGearDots) == "function" then
                local tryApplyHeroAttackGearDots = dm.tryApplyHeroAttackGearDots
                local ____temp_5
                if entry.source ~= nil then
                    ____temp_5 = entry.source
                else
                    ____temp_5 = nil
                end
                tryApplyHeroAttackGearDots(____temp_5, su, sd)
            end
        end)
    end
    do
        local c = 0
        while c < #DamageCallbacks do
            local cb = DamageCallbacks[c + 1]
            if cb ~= nil then
                local cbStr = tostring(nil, cb)
                if (string.find(cbStr, "damageCallback", nil, true) or 0) - 1 == -1 and (string.find(cbStr, "damageCalculation", nil, true) or 0) - 1 == -1 then
                    local invokeCallback = cb
                    invokeCallback(
                        su,
                        sd,
                        0,
                        isDotTickDamage,
                        entry.source,
                        entry.isNormalAttack
                    )
                end
            end
            c = c + 1
        end
    end
    if isDotTickDamage then
        luaPcall(function()
            local m = require("系统.04．伤害系统.02．dot伤害")
            if m ~= nil and type(m.notifyDotTickBatchDamageDisplayed) == "function" then
                local notifyDotTickBatchDamageDisplayed = m.notifyDotTickBatchDamageDisplayed
                notifyDotTickBatchDamageDisplayed()
            end
        end)
    end
end
function anyUnitDamagedFilter()
    local u = jass:GetFilterUnit()
    if not u then
        return false
    end
    local lvl = jass:GetUnitAbilityLevel(u, ALOC)
    if lvl > 0 then
        return false
    end
    if UnitGroup and jass:IsUnitInGroup(u, UnitGroup) then
        return false
    end
    if UnitGroup then
        jass:GroupAddUnit(UnitGroup, u)
    end
    if MNDamageEventTrigger then
        local ev = getEventUnitDamaged()
        if ev ~= nil then
            jass:TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev)
        end
    end
    return false
end
function initEnumUnit()
    local t = jass:CreateTrigger()
    local r = jass:CreateRegion()
    local grp = jass:CreateGroup()
    local bounds = jass:GetWorldBounds()
    if bounds then
        jass:RegionAddRect(r, bounds)
    end
    jass:TriggerRegisterEnterRegion(
        t,
        r,
        jass:Condition(anyUnitDamagedFilter)
    )
    local function alwaysTrue()
        return true
    end
    jass:GroupEnumUnitsInRect(
        grp,
        bounds,
        jass:Condition(alwaysTrue)
    )
    if UnitGroup and MNDamageEventTrigger then
        forEachUnitInGroup(
            nil,
            grp,
            function(u)
                if not u then
                    return
                end
                local lvl = jass:GetUnitAbilityLevel(u, ALOC)
                if lvl > 0 then
                    return
                end
                if jass:IsUnitInGroup(u, UnitGroup) then
                    return
                end
                jass:GroupAddUnit(UnitGroup, u)
                local ev = getEventUnitDamaged()
                if ev ~= nil then
                    jass:TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev)
                end
            end
        )
    end
    if grp then
        jass:DestroyGroup(grp)
    end
end
function recreateDamageTrigger()
    if MNDamageEventTrigger and ta ~= nil then
        jass:TriggerRemoveAction(MNDamageEventTrigger, ta)
    end
    if MNDamageEventTrigger then
        jass:DestroyTrigger(MNDamageEventTrigger)
    end
    MNDamageEventTrigger = jass:CreateTrigger()
    if MNDamageEventTrigger then
        ta = jass:TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction)
    end
    if UnitGroup and MNDamageEventTrigger then
        local ev = getEventUnitDamaged()
        if ev ~= nil then
            forEachUnitInGroup(
                nil,
                UnitGroup,
                function(u)
                    if u then
                        jass:TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev)
                    end
                end
            )
        end
    end
end
function timeout()
    recreateDamageTrigger()
end
function initDamageEventOnce(intervalSeconds)
    if MNDamageEventTrigger ~= nil then
        return
    end
    MNDamageEventTrigger = jass:CreateTrigger()
    UnitGroup = jass:CreateGroup()
    if MNDamageEventTrigger then
        ta = jass:TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction)
    end
    initEnumUnit()
    registerDeathListener(onUnitDeathForDamage)
    local sec = type(intervalSeconds) == "number" and intervalSeconds > 0 and intervalSeconds or 60
    if TimerHandle == nil then
        TimerHandle = jass:CreateTimer()
        if TimerHandle then
            jass:TimerStart(TimerHandle, sec, true, timeout)
        end
    end
end
jass = require("jass.common")
local g = require("jass.globals")
luaPcall = pcall
_____4F24_5BB3_51FD_6570 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
isHeroUnit = ____require_result_0.isHeroUnit
forEachUnitInGroup = ____require_result_0.forEachUnitInGroup
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
registerDeathListener = ____require_result_1.registerDeathListener
ALOC = 1097625443
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
function ____exports.markNextPendingDamageAsDotTickBatch()
    dotBatchMarkQueue[#dotBatchMarkQueue + 1] = true
end
--- 与 JASS `IsUnitType(u, UNIT_TYPE_HERO)` 一致
local function getUnitTypeHero()
    local ____jass_UNIT_TYPE_HERO_2 = jass.UNIT_TYPE_HERO
    if ____jass_UNIT_TYPE_HERO_2 == nil then
        ____jass_UNIT_TYPE_HERO_2 = jass:ConvertUnitType(2)
    end
    return ____jass_UNIT_TYPE_HERO_2
end
--- 注册一个触发器：当任意单位受到伤害时，若该触发器启用且条件通过则执行。
-- 
-- @param trg 触发器（需在 JASS/TS 中创建并设置 condition/action）
-- @param intervalSeconds 定期重建伤害触发的间隔（秒），用于避免泄漏/堆积
function ____exports.MNAnyUnitDamaged(trg, intervalSeconds)
    if trg == nil then
        return
    end
    initDamageEventOnce(intervalSeconds)
    DamageEventQueue[DamageEventNumber + 1] = trg
    DamageEventNumber = DamageEventNumber + 1
end
--- 注册 Lua 回调：单位受伤时直接调用，不依赖 TriggerExecute（引擎可能不执行 Lua 动作）
function ____exports.registerDamageCallback(cb, intervalSeconds)
    if cb == nil then
        return
    end
    initDamageEventOnce(intervalSeconds)
    DamageCallbacks[#DamageCallbacks + 1] = cb
end
return ____exports
