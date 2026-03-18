local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
--- 【通用 DOT 框架】持续伤害/减益（如反恢复、燃烧、中毒等）统一在此注册与驱动。
-- 
-- 设计说明（给后续维护或 AI 参考）：
-- - 每种 DOT 通过 registerDotType(config) 注册，配置里包含：解析装备 Buff、取“最强”参数、算每秒伤害、伤害类型、特效模型等。
-- - 覆盖规则：新效果×新持续 > 当前效果×当前剩余 才覆盖；同一次或自己 DOT 触发的伤害不会重复施加（通过 ignoredTargetByType 忽略）。
-- - 共用一套计时器：tickTimer 每 TICK 秒减 remaining；dotTimer 每 1 秒按条目的 amount 造成伤害并播特效；effectRecycleTimer 统一回收特效，无单次计时器泄漏。
-- - 若某 DOT 需要“附加效果”（如 10 秒内减 50 攻），可在 config 里提供 onApply/onTick/onEnd 回调，在施加/每跳/结束时执行。
-- 
-- 当前仅注册一种：反恢复（装备 Buff:dmg:AntiHeal200%;time3，精神伤害，持续 3 秒，每秒 regenHP×200%）。
local jass = require("jass.common")
local g = require("jass.globals")
local damageEventModule = require("系统.伤害.伤害事件")
local leakCore = require("系统.00_核心.泄露审计")
local ____leakCore_LeakWatcher_0 = leakCore.LeakWatcher
if ____leakCore_LeakWatcher_0 == nil then
    ____leakCore_LeakWatcher_0 = leakCore
end
local LeakWatcher = ____leakCore_LeakWatcher_0
local TICK = 0.25
--- 伤害类型位：2048=技能 256=精神，用于 Lua 造成的伤害在事件里显示正确文案
local DAMAGE_TYPE_SKILL = 2048
local DAMAGE_TYPE_MIND = 256
local dotTypes = {}
--- 注册一种 DOT，后续伤害回调会按配置解析装备并施加/覆盖
function ____exports.registerDotType(self, config)
    dotTypes[#dotTypes + 1] = config
end
--- 按类型、再按目标存状态。stateByType[typeId][target] = { effect, remaining, ... }
local stateByType = {}
local dotTicks = {}
--- 刚被我们「某类型」伤害打到的单位，下一帧伤害回调里跳过对该类型施加，避免 DOT 触发的伤害再次叠 DOT
local ignoredTargetByType = {}
local tickTimer = nil
local dotTimer = nil
--- 特效回收：每 0.2s 检查，到期 DestroyEffect；只用一个周期计时器，不创建单次计时器
local EFFECT_RECYCLE_INTERVAL = 0.2
local effectRecycleList = {}
local effectRecycleTimer = nil
local itemsData = require("系统.装备.装备数据").items or require("系统.装备.装备数据").default or ({})
local function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
local function unitItemInSlot(self, unit, slot)
    if type(jass.UnitItemInSlot) ~= "function" then
        return nil
    end
    return jass.UnitItemInSlot(unit, slot)
end
local function getItemTypeId(self, item)
    if type(jass.GetItemTypeId) ~= "function" then
        return 0
    end
    return jass.GetItemTypeId(item)
end
--- 来源是否为玩家 1–4 的英雄（当前仅这类来源会触发装备 DOT）
local function isSourceHeroPlayer1to4(self, unit)
    if not unit or type(jass.GetOwningPlayer) ~= "function" or type(jass.IsUnitType) ~= "function" then
        return false
    end
    local owner = jass.GetOwningPlayer(unit)
    local playerIdx = -1
    do
        local i = 0
        while i <= 15 do
            if jass.Player(i) == owner then
                playerIdx = i
                break
            end
            i = i + 1
        end
    end
    if playerIdx < 0 or playerIdx > 3 then
        return false
    end
    local ____temp_1
    if jass.ConvertUnitType and jass.UNIT_TYPE_HERO ~= nil then
        ____temp_1 = jass.ConvertUnitType(jass.UNIT_TYPE_HERO)
    else
        ____temp_1 = nil
    end
    local utHero = ____temp_1
    if utHero == nil then
        return true
    end
    return jass.IsUnitType(unit, utHero) == true
end
local function tick(self)
    for typeId in pairs(stateByType) do
        do
            local __continue16
            repeat
                local tab = stateByType[typeId]
                if tab == nil then
                    __continue16 = true
                    break
                end
                for k in pairs(tab) do
                    do
                        local __continue18
                        repeat
                            local v = tab[k]
                            if v == nil then
                                __continue18 = true
                                break
                            end
                            v.remaining = v.remaining - TICK
                            if v.remaining <= 0 then
                                local cfg = __TS__ArrayFind(
                                    dotTypes,
                                    function(____, c) return c.id == typeId end
                                )
                                if cfg ~= nil and type(cfg.onEnd) == "function" then
                                    cfg:onEnd(k, v)
                                end
                                __TS__Delete(tab, k)
                            end
                            __continue18 = true
                        until true
                        if not __continue18 then
                            break
                        end
                    end
                end
                __continue16 = true
            until true
            if not __continue16 then
                break
            end
        end
    end
    local hasAny = false
    for typeId in pairs(stateByType) do
        do
            local __continue25
            repeat
                local tab = stateByType[typeId]
                if tab == nil then
                    __continue25 = true
                    break
                end
                for _ in pairs(tab) do
                    hasAny = true
                    break
                end
                if hasAny then
                    break
                end
                __continue25 = true
            until true
            if not __continue25 then
                break
            end
        end
    end
    if not hasAny and tickTimer ~= nil then
        LeakWatcher:destroyTimer(tickTimer)
        tickTimer = nil
    end
end
--- 在目标身上挂特效，model/duration 由调用方传入；回收走统一列表
local function addDotEffectOnUnit(self, unit, model, duration)
    if not unit or type(jass.AddSpecialEffectTarget) ~= "function" then
        return
    end
    local eff = jass.AddSpecialEffectTarget(model, unit, "origin")
    if eff == nil then
        return
    end
    if type(jass.YDWETimerDestroyEffect) == "function" then
        jass.YDWETimerDestroyEffect(duration, eff)
        return
    end
    local ticks = math.ceil(duration / EFFECT_RECYCLE_INTERVAL)
    effectRecycleList[#effectRecycleList + 1] = {eff = eff, ticksLeft = ticks}
    if effectRecycleTimer == nil and type(jass.TimerStart) == "function" then
        effectRecycleTimer = LeakWatcher:createTimer("dot_effectRecycle")
        jass.TimerStart(
            effectRecycleTimer,
            EFFECT_RECYCLE_INTERVAL,
            true,
            function()
                do
                    local i = #effectRecycleList - 1
                    while i >= 0 do
                        local x = effectRecycleList[i + 1]
                        x.ticksLeft = x.ticksLeft - 1
                        if x.ticksLeft <= 0 then
                            if x.eff ~= nil and type(jass.DestroyEffect) == "function" then
                                jass.DestroyEffect(x.eff)
                            end
                            __TS__ArraySplice(effectRecycleList, i, 1)
                        end
                        i = i - 1
                    end
                end
                if #effectRecycleList == 0 and effectRecycleTimer ~= nil then
                    LeakWatcher:destroyTimer(effectRecycleTimer)
                    effectRecycleTimer = nil
                end
            end
        )
    end
end
--- 造成指定类型的 DOT 伤害，并标记该目标为本类型“自伤”，避免回调里再次施加。来源/目标写入 udg_TempUnit[4]/[3] 供 JASS 读
local function dealDamageForType(self, typeId, source, target, amount)
    if type(jass.UnitDamageTarget) ~= "function" then
        return
    end
    local cfg = __TS__ArrayFind(
        dotTypes,
        function(____, c) return c.id == typeId end
    )
    if cfg == nil then
        return
    end
    local j = jass
    if j.udg_TempUnit ~= nil then
        j.udg_TempUnit[3] = target
        j.udg_TempUnit[4] = source
    end
    if ignoredTargetByType[typeId] == nil then
        ignoredTargetByType[typeId] = {}
    end
    ignoredTargetByType[typeId][target] = true
    damageEventModule:setNextDamageTypeOverride(DAMAGE_TYPE_SKILL + DAMAGE_TYPE_MIND)
    jass.UnitDamageTarget(
        source,
        target,
        amount,
        false,
        false,
        jass.ATTACK_TYPE_NORMAL,
        cfg.damageType,
        jass.WEAPON_TYPE_WHOKNOWS
    )
end
local function dotTickRun(self)
    do
        local i = #dotTicks - 1
        while i >= 0 do
            local e = dotTicks[i + 1]
            dealDamageForType(
                nil,
                e.typeId,
                e.source,
                e.target,
                e.amount
            )
            addDotEffectOnUnit(nil, e.target, e.effectModel, e.effectDuration)
            local cfg = __TS__ArrayFind(
                dotTypes,
                function(____, c) return c.id == e.typeId end
            )
            local ____temp_2
            if stateByType[e.typeId] ~= nil then
                ____temp_2 = stateByType[e.typeId][e.target]
            else
                ____temp_2 = nil
            end
            local state = ____temp_2
            if cfg ~= nil and type(cfg.onTick) == "function" and state ~= nil then
                cfg:onTick(e.target, state)
            end
            e.ticksLeft = e.ticksLeft - 1
            if e.ticksLeft <= 0 then
                __TS__ArraySplice(dotTicks, i, 1)
            end
            i = i - 1
        end
    end
    if #dotTicks == 0 and dotTimer ~= nil then
        LeakWatcher:destroyTimer(dotTimer)
        dotTimer = nil
    end
end
local function onDamage(self, target, damage, damageType)
    if not target or damage <= 0 then
        return
    end
    local j = jass
    local ____temp_3
    if j.udg_TempUnit ~= nil and j.udg_TempUnit[6] ~= nil then
        ____temp_3 = j.udg_TempUnit[6]
    else
        ____temp_3 = nil
    end
    local source = ____temp_3
    if not source then
        return
    end
    if not isSourceHeroPlayer1to4(nil, source) then
        return
    end
    do
        local t = 0
        while t < #dotTypes do
            do
                local __continue61
                repeat
                    local cfg = dotTypes[t + 1]
                    local typeId = cfg.id
                    if ignoredTargetByType[typeId] ~= nil and ignoredTargetByType[typeId][target] == true then
                        __TS__Delete(ignoredTargetByType[typeId], target)
                        __continue61 = true
                        break
                    end
                    local best = cfg:getBestFromUnit(source)
                    if best == nil then
                        __continue61 = true
                        break
                    end
                    local amount = cfg:computeAmount(target, best)
                    if amount <= 0 then
                        __continue61 = true
                        break
                    end
                    if stateByType[typeId] == nil then
                        stateByType[typeId] = {}
                    end
                    local tab = stateByType[typeId]
                    local cur = tab[target]
                    local currentProduct = cur ~= nil and cur.effect * cur.remaining or 0
                    local newProduct = amount * best.duration
                    if newProduct <= currentProduct then
                        __continue61 = true
                        break
                    end
                    if cur ~= nil and type(cfg.onEnd) == "function" then
                        cfg:onEnd(target, cur)
                    end
                    local state = {effect = amount, remaining = best.duration}
                    tab[target] = state
                    if type(cfg.onApply) == "function" then
                        cfg:onApply(target, state)
                    end
                    do
                        local i = #dotTicks - 1
                        while i >= 0 do
                            if dotTicks[i + 1].target == target and dotTicks[i + 1].typeId == typeId then
                                __TS__ArraySplice(dotTicks, i, 1)
                            end
                            i = i - 1
                        end
                    end
                    dotTicks[#dotTicks + 1] = {
                        typeId = typeId,
                        source = source,
                        target = target,
                        amount = amount,
                        ticksLeft = best.duration,
                        effectModel = cfg.effectModel,
                        effectDuration = cfg.effectDuration
                    }
                    if dotTimer == nil and type(jass.TimerStart) == "function" then
                        dotTimer = LeakWatcher:createTimer("dot_tick")
                        jass.TimerStart(dotTimer, 1, true, dotTickRun)
                    end
                    if tickTimer == nil and type(jass.TimerStart) == "function" then
                        tickTimer = LeakWatcher:createTimer("dot_state")
                        jass.TimerStart(tickTimer, TICK, true, tick)
                    end
                    __continue61 = true
                until true
                if not __continue61 then
                    break
                end
            end
            t = t + 1
        end
    end
end
local function parseAntiHealBuff(self, buffStr)
    if not buffStr or type(buffStr) ~= "string" then
        return nil
    end
    local s = __TS__StringTrim(buffStr)
    if (string.find(s, "Buff:dmg:", nil, true) or 0) - 1 ~= 0 then
        return nil
    end
    local rest = __TS__StringSubstring(s, 9)
    local antiIdx = (string.find(rest, "AntiHeal", nil, true) or 0) - 1
    if antiIdx < 0 then
        return nil
    end
    local numEnd = antiIdx + 8
    while numEnd < #rest do
        local c = __TS__StringCharAt(rest, numEnd)
        if c >= "0" and c <= "9" then
            numEnd = numEnd + 1
        else
            break
        end
    end
    local effectPct = numEnd > antiIdx + 8 and (__TS__ParseInt(
        __TS__StringSubstring(rest, antiIdx + 8, numEnd),
        10
    ) or 0) or 0
    local timeIdx = (string.find(rest, "time", nil, true) or 0) - 1
    if timeIdx < 0 then
        return nil
    end
    local tEnd = timeIdx + 4
    while tEnd < #rest do
        local c = __TS__StringCharAt(rest, tEnd)
        if c >= "0" and c <= "9" then
            tEnd = tEnd + 1
        else
            break
        end
    end
    local duration = tEnd > timeIdx + 4 and (__TS__ParseInt(
        __TS__StringSubstring(rest, timeIdx + 4, tEnd),
        10
    ) or 0) or 0
    if duration <= 0 then
        return nil
    end
    return {effectPct = effectPct, duration = duration}
end
local function getTargetRegenHP(self, targetUnit)
    if type(jass.GetUnitTypeId) ~= "function" or not targetUnit then
        return 0
    end
    local typeId = jass.GetUnitTypeId(targetUnit)
    local idStr = fourCCToString(nil, typeId)
    local slk = _G.slk
    local slkUnit = slk ~= nil and slk.unit and slk.unit[idStr] or nil
    if slkUnit == nil then
        return 0
    end
    local regenStr = slkUnit.regenHP or slkUnit.regenHP
    if regenStr == nil or type(regenStr) ~= "string" then
        return 0
    end
    local n = __TS__ParseFloat(regenStr)
    return type(n) == "number" and not __TS__NumberIsNaN(__TS__Number(n)) and n or 0
end
local function getBestAntiHealFromUnit(self, unit)
    local best = nil
    do
        local slot = 0
        while slot <= 5 do
            do
                local __continue92
                repeat
                    local item = unitItemInSlot(nil, unit, slot)
                    if not item then
                        __continue92 = true
                        break
                    end
                    local idStr = fourCCToString(
                        nil,
                        getItemTypeId(nil, item)
                    )
                    local entry = itemsData[idStr]
                    local ____temp_6
                    if (entry and entry.Buff) ~= nil then
                        ____temp_6 = parseAntiHealBuff(nil, entry.Buff)
                    else
                        ____temp_6 = nil
                    end
                    local parsed = ____temp_6
                    if not parsed then
                        __continue92 = true
                        break
                    end
                    local product = parsed.effectPct * parsed.duration
                    if best == nil or product > best.product then
                        best = {effectPct = parsed.effectPct, duration = parsed.duration, product = product}
                    end
                    __continue92 = true
                until true
                if not __continue92 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return best ~= nil and ({effectPct = best.effectPct, duration = best.duration}) or nil
end
____exports.registerDotType(
    nil,
    {
        id = "antiHeal",
        parseBuff = parseAntiHealBuff,
        getBestFromUnit = getBestAntiHealFromUnit,
        computeAmount = function(____, target, parsed)
            local regenHP = getTargetRegenHP(nil, target)
            return regenHP * (parsed.effectPct / 100)
        end,
        damageType = jass.DAMAGE_TYPE_MIND,
        effectModel = "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl",
        effectDuration = 0.8
    }
)
local registered = false
local function init(self, damageEvent)
    if registered then
        return
    end
    registered = true
    damageEvent:registerDamageCallback(function(____, unit, damage, dmgType)
        onDamage(nil, unit, damage, dmgType)
    end)
end
--- 供治疗等系统读取：单位当前反恢复状态，无则返回 null
function ____exports.getUnitAntiHeal(self, unit)
    local tab = stateByType.antiHeal
    local ____temp_8
    if tab ~= nil then
        local ____tab_unit_7 = tab[unit]
        if ____tab_unit_7 == nil then
            ____tab_unit_7 = nil
        end
        ____temp_8 = ____tab_unit_7
    else
        ____temp_8 = nil
    end
    return ____temp_8
end
--- 造成精神伤害（供外部直接调用，如其他技能）；会标记 target 以免伤害回调再次施加同源 DOT。来源/目标由 dealDamageForType 写入 udg_TempUnit[4]/[3] 供 JASS 读
function ____exports.dealSpiritDamage(self, source, target, amount)
    dealDamageForType(
        nil,
        "antiHeal",
        source,
        target,
        amount
    )
end
init(nil, damageEventModule)
return ____exports
