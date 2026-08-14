--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local getEventUnitDamaged, ______pcall_8BFB_53D6Jass_4F24_5BB3_6765_6E90, ______pcall_8BFB_53D6_5168_5C40_4F24_5BB3_6765_6E90, ______pcall_68C0_67E5_89E6_53D1_5668_542F_7528, ______pcall_8BC4_4F30_89E6_53D1_5668, ______pcall_6267_884C_89E6_53D1_5668, ______pcall_68C0_67E5_666E_901A_653B_51FB, ______pcall_5E94_7528_82F1_96C4_666E_653B_88C5_5907Dot, ______pcall_901A_77E5Dot_6279_6B21_4F24_5BB3_663E_793A, onUnitDeathForDamage, onAnyUnitDamagedAction, processDamageEntry, anyUnitDamagedFilter, alwaysCollectUnitFilter, _____679A_4E3E_5DF2_6709_4F24_5BB3_5355_4F4D, unitHidKey, registerDamageUnit, unregisterDamageUnit, initEnumUnit, initDamageEventOnce, jass, _____4F24_5BB3_51FD_6570, isHeroUnit, forEachUnitInGroup, registerDeathListener, _____83B7_53D6_4F24_5BB3_8BA1_7B97_56DE_8C03, ALOC, DamageEventQueue, DamageCallbacks, DamageEventNumber, UnitGroup, DamageEventInitialized, DamageTriggerByUnitHid, DamageTriggerActionByUnitHid, ______pcall_4F24_5BB3_6765_6E90, ______pcall_89E6_53D1_5668, ______pcall_5E03_5C14_7ED3_679C, ______pcall_4F24_5BB3Entry, dotBatchMarkQueue, GetFilterUnit, GetUnitAbilityLevel, CreateTrigger, CreateRegion, CreateGroup, GetWorldBounds, RegionAddRect, Condition, TriggerRegisterEnterRegion, GroupEnumUnitsInRect
function getEventUnitDamaged(self)
    return jass.EVENT_UNIT_DAMAGED
end
function ______pcall_8BFB_53D6Jass_4F24_5BB3_6765_6E90(self)
    ______pcall_4F24_5BB3_6765_6E90 = jass.GetEventDamageSource()
end
function ______pcall_8BFB_53D6_5168_5C40_4F24_5BB3_6765_6E90(self)
    ______pcall_4F24_5BB3_6765_6E90 = GetEventDamageSource()
end
function ______pcall_68C0_67E5_89E6_53D1_5668_542F_7528(self)
    ______pcall_5E03_5C14_7ED3_679C = jass.IsTriggerEnabled(______pcall_89E6_53D1_5668) == true
end
function ______pcall_8BC4_4F30_89E6_53D1_5668(self)
    ______pcall_5E03_5C14_7ED3_679C = jass.TriggerEvaluate(______pcall_89E6_53D1_5668) == true
end
function ______pcall_6267_884C_89E6_53D1_5668(self)
    jass.TriggerExecute(______pcall_89E6_53D1_5668)
end
function ______pcall_68C0_67E5_666E_901A_653B_51FB(self)
    ______pcall_5E03_5C14_7ED3_679C = _____4F24_5BB3_51FD_6570.isNormalAttack() == true
end
function ______pcall_5E94_7528_82F1_96C4_666E_653B_88C5_5907Dot(self)
    local entry = ______pcall_4F24_5BB3Entry
    if entry == nil then
        return
    end
    local dm = require("系统.04．伤害系统.02．dot伤害")
    if dm ~= nil and type(dm.tryApplyHeroAttackGearDots) == "function" then
        local ____dm_tryApplyHeroAttackGearDots_3 = dm.tryApplyHeroAttackGearDots
        local ____temp_2
        if entry.source ~= nil then
            ____temp_2 = entry.source
        else
            ____temp_2 = nil
        end
        ____dm_tryApplyHeroAttackGearDots_3(dm, ____temp_2, entry.unit, entry.damage)
    end
end
function ______pcall_901A_77E5Dot_6279_6B21_4F24_5BB3_663E_793A(self)
    local m = require("系统.04．伤害系统.02．dot伤害")
    if m ~= nil and type(m.notifyDotTickBatchDamageDisplayed) == "function" then
        m:notifyDotTickBatchDamageDisplayed()
    end
end
function onUnitDeathForDamage(dyingUnit)
    if not UnitGroup or not dyingUnit then
        return
    end
    if isHeroUnit(nil, dyingUnit) then
        return
    end
    jass.GroupRemoveUnit(UnitGroup, dyingUnit)
    unregisterDamageUnit(nil, dyingUnit)
end
function onAnyUnitDamagedAction()
    local j = jass
    local savedUnit = jass.GetTriggerUnit()
    local savedDamage = jass.GetEventDamage()
    if savedDamage <= 0 then
        return
    end
    local savedSource = nil
    ______pcall_4F24_5BB3_6765_6E90 = nil
    pcall(______pcall_8BFB_53D6Jass_4F24_5BB3_6765_6E90)
    savedSource = ______pcall_4F24_5BB3_6765_6E90
    if savedSource == nil then
        ______pcall_4F24_5BB3_6765_6E90 = nil
        pcall(______pcall_8BFB_53D6_5168_5C40_4F24_5BB3_6765_6E90)
        savedSource = ______pcall_4F24_5BB3_6765_6E90
    end
    local ____temp_5
    if #dotBatchMarkQueue > 0 then
        ____temp_5 = table.remove(dotBatchMarkQueue, 1) == true
    else
        ____temp_5 = false
    end
    local fromDotTickBatchForEvent = ____temp_5
    if not fromDotTickBatchForEvent and savedUnit ~= nil and savedDamage > 0.1 then
        local dmgCalc = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
        local ____temp_6
        if dmgCalc ~= nil then
            ____temp_6 = dmgCalc.onDamageEvent
        else
            ____temp_6 = nil
        end
        local onDamageEvent = ____temp_6
        if onDamageEvent ~= nil then
            onDamageEvent(savedUnit, savedSource, savedDamage)
        end
    end
    local i = 0
    while i < DamageEventNumber do
        local trg = DamageEventQueue[i + 1]
        if trg ~= nil then
            ______pcall_89E6_53D1_5668 = trg
            ______pcall_5E03_5C14_7ED3_679C = false
            pcall(______pcall_68C0_67E5_89E6_53D1_5668_542F_7528)
            local enabled = ______pcall_5E03_5C14_7ED3_679C
            if enabled then
                ______pcall_5E03_5C14_7ED3_679C = false
                pcall(______pcall_8BC4_4F30_89E6_53D1_5668)
                local evaluated = ______pcall_5E03_5C14_7ED3_679C
                if evaluated then
                    pcall(______pcall_6267_884C_89E6_53D1_5668)
                end
            end
            ______pcall_89E6_53D1_5668 = nil
        end
        i = i + 1
    end
    local isNormalAttackSnap = false
    if not fromDotTickBatchForEvent then
        ______pcall_5E03_5C14_7ED3_679C = false
        pcall(______pcall_68C0_67E5_666E_901A_653B_51FB)
        isNormalAttackSnap = ______pcall_5E03_5C14_7ED3_679C
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
        ______pcall_4F24_5BB3Entry = entry
        pcall(______pcall_5E94_7528_82F1_96C4_666E_653B_88C5_5907Dot)
        ______pcall_4F24_5BB3Entry = nil
    end
    local _____4F24_5BB3_8BA1_7B97_56DE_8C03 = _____83B7_53D6_4F24_5BB3_8BA1_7B97_56DE_8C03(nil)
    do
        local c = 0
        while c < #DamageCallbacks do
            do
                local cb = DamageCallbacks[c + 1]
                if cb ~= nil then
                    if _____4F24_5BB3_8BA1_7B97_56DE_8C03 ~= nil and cb == _____4F24_5BB3_8BA1_7B97_56DE_8C03 then
                        goto __continue33
                    end
                    cb(
                        su,
                        sd,
                        0,
                        isDotTickDamage,
                        entry.source,
                        entry.isNormalAttack
                    )
                end
            end
            ::__continue33::
            c = c + 1
        end
    end
    if isDotTickDamage then
        pcall(______pcall_901A_77E5Dot_6279_6B21_4F24_5BB3_663E_793A)
    end
end
function anyUnitDamagedFilter()
    local u = GetFilterUnit()
    if not u then
        return false
    end
    local lvl = GetUnitAbilityLevel(u, ALOC)
    if lvl > 0 then
        return false
    end
    registerDamageUnit(nil, u)
    return false
end
function alwaysCollectUnitFilter()
    return true
end
function _____679A_4E3E_5DF2_6709_4F24_5BB3_5355_4F4D(self, u)
    if not u then
        return
    end
    local lvl = jass.GetUnitAbilityLevel(u, ALOC)
    if lvl > 0 then
        return
    end
    registerDamageUnit(nil, u)
end
function unitHidKey(self, unit)
    return tostring(jass.GetHandleId(unit)
    )
end
function registerDamageUnit(self, unit)
    if not unit then
        return
    end
    local hid = unitHidKey(nil, unit)
    if DamageTriggerByUnitHid[hid] ~= nil then
        return
    end
    if UnitGroup and not jass.IsUnitInGroup(unit, UnitGroup) then
        jass.GroupAddUnit(UnitGroup, unit)
    end
    local ev = getEventUnitDamaged()
    if ev == nil then
        return
    end
    local trigger = jass.CreateTrigger()
    if not trigger then
        return
    end
    local action = jass.TriggerAddAction(trigger, onAnyUnitDamagedAction)
    jass.TriggerRegisterUnitEvent(trigger, unit, ev)
    DamageTriggerByUnitHid[hid] = trigger
    DamageTriggerActionByUnitHid[hid] = action
end
function unregisterDamageUnit(self, unit)
    if not unit then
        return
    end
    local hid = unitHidKey(nil, unit)
    local trigger = DamageTriggerByUnitHid[hid]
    if trigger == nil then
        return
    end
    local action = DamageTriggerActionByUnitHid[hid]
    if action ~= nil then
        jass.TriggerRemoveAction(trigger, action)
    end
    jass.DestroyTrigger(trigger)
    DamageTriggerByUnitHid[hid] = nil
    DamageTriggerActionByUnitHid[hid] = nil
end
function initEnumUnit(self)
    local t = CreateTrigger()
    local r = CreateRegion()
    local grp = CreateGroup()
    local bounds = GetWorldBounds()
    if bounds then
        RegionAddRect(r, bounds)
    end
    TriggerRegisterEnterRegion(
        t,
        r,
        Condition(anyUnitDamagedFilter)
    )
    GroupEnumUnitsInRect(
        grp,
        bounds,
        Condition(alwaysCollectUnitFilter)
    )
    if UnitGroup then
        forEachUnitInGroup(nil, grp, _____679A_4E3E_5DF2_6709_4F24_5BB3_5355_4F4D)
    end
    if grp then
        jass.DestroyGroup(grp)
    end
end
function initDamageEventOnce(self, intervalSeconds)
    if DamageEventInitialized then
        return
    end
    DamageEventInitialized = true
    UnitGroup = jass.CreateGroup()
    initEnumUnit()
    registerDeathListener(nil, onUnitDeathForDamage)
    local ____ = intervalSeconds
end
jass = require("jass.common")
local g = require("jass.globals")
_____4F24_5BB3_51FD_6570 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
isHeroUnit = ____require_result_0.isHeroUnit
forEachUnitInGroup = ____require_result_0.forEachUnitInGroup
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
registerDeathListener = ____require_result_1.registerDeathListener
_____83B7_53D6_4F24_5BB3_8BA1_7B97_56DE_8C03 = function()
    local _____6A21_5757 = require("系统.04．伤害系统.00．伤害计算.05．事件注册")
    return _____6A21_5757["伤害计算回调"]
end
ALOC = 1097625443
DamageEventQueue = {}
DamageCallbacks = {}
DamageEventNumber = 0
UnitGroup = nil
DamageEventInitialized = false
DamageTriggerByUnitHid = {}
DamageTriggerActionByUnitHid = {}
______pcall_4F24_5BB3_6765_6E90 = nil
______pcall_89E6_53D1_5668 = nil
______pcall_5E03_5C14_7ED3_679C = false
______pcall_4F24_5BB3Entry = nil
--- 伤害事件队列
local damagePendingQueue = {}
dotBatchMarkQueue = {}
--- 由 dot伤害.dealDamageForType 调用：标记「下一次因伤入队」来自本帧 DOT 秒跳，便于延后清空 dotTickBatchTargetHids
function ____exports.markNextPendingDamageAsDotTickBatch(self)
    dotBatchMarkQueue[#dotBatchMarkQueue + 1] = true
end
GetFilterUnit = jass.GetFilterUnit
GetUnitAbilityLevel = jass.GetUnitAbilityLevel
CreateTrigger = jass.CreateTrigger
CreateRegion = jass.CreateRegion
CreateGroup = jass.CreateGroup
GetWorldBounds = jass.GetWorldBounds
RegionAddRect = jass.RegionAddRect
Condition = jass.Condition
TriggerRegisterEnterRegion = jass.TriggerRegisterEnterRegion
GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect
--- 与 JASS `IsUnitType(u, UNIT_TYPE_HERO)` 一致
local function getUnitTypeHero(self)
    local ____jass_UNIT_TYPE_HERO_4 = jass.UNIT_TYPE_HERO
    if ____jass_UNIT_TYPE_HERO_4 == nil then
        ____jass_UNIT_TYPE_HERO_4 = jass.ConvertUnitType(2)
    end
    return ____jass_UNIT_TYPE_HERO_4
end
--- 注册一个触发器：当任意单位受到伤害时，若该触发器启用且条件通过则执行。
-- 
-- @param trg 触发器（需在 JASS/TS 中创建并设置 condition/action）
-- @param intervalSeconds 兼容旧接口；当前实现按单位死亡销毁对应伤害触发。
function ____exports.MNAnyUnitDamaged(self, trg, intervalSeconds)
    if trg == nil then
        return
    end
    initDamageEventOnce(nil, intervalSeconds)
    DamageEventQueue[DamageEventNumber + 1] = trg
    DamageEventNumber = DamageEventNumber + 1
end
--- 注册 Lua 回调：单位受伤时直接调用，不依赖 TriggerExecute（引擎可能不执行 Lua 动作）
function ____exports.registerDamageCallback(cb, intervalSeconds)
    if cb == nil then
        return
    end
    initDamageEventOnce(nil, intervalSeconds)
    DamageCallbacks[#DamageCallbacks + 1] = cb
end
return ____exports
