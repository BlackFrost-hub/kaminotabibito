local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local ____exports = {}
local notifyBuffPool, unitHid, tabRowForHid, tabSetHid, getDotSourceDisplayName, isValidDotStateRow, addDotEffectOnUnit, dealDamageForType, ensureDotTimers, pushDotTickForTarget, fillDotStateRow, applyEquipmentDotOnHeroAttack, dotTickRun, jass, damageEventModule, LeakWatcher, DAMAGE_TYPE_SKILL, DAMAGE_TYPE_MIND, dotTypes, stateByType, dotTicks, ignoredTargetByType, dotTickBatchTargetHids, dotBatchSnapForClear, dotBatchDeferredRemaining, dotTimer, EFFECT_RECYCLE_INTERVAL, effectRecycleList, effectRecycleTimer
function notifyBuffPool(self, typeId, target, state)
    pcall(function ()
            local m = require("系统.05．Buff系统.00．Buff系统")
            if m ~= nil and type(m.syncDotBuff) == "function" then
                m:syncDotBuff(typeId, target, state)
            end
        end
    )
end
function unitHid(self, u)
    if u == nil or u == 0 then
        return 0
    end
    if type(jass.GetHandleId) ~= "function" then
        return 0
    end
    return jass.GetHandleId(u)
end
function tabRowForHid(self, tab, hid)
    if hid == 0 then
        return nil
    end
    local n = tab[hid]
    if n ~= nil then
        return n
    end
    return tab[tostring(hid)]
end
function tabSetHid(self, tab, hid, state)
    if hid == 0 then
        return
    end
    __TS__Delete(
        tab,
        tostring(hid)
    )
    tab[hid] = state
end
function getDotSourceDisplayName(self, u)
    if u == nil or u == 0 then
        return "未知"
    end
    if type(jass.GetUnitName) == "function" then
        local n = jass.GetUnitName(u)
        if n ~= nil and n ~= nil and tostring(n) ~= "" then
            return tostring(n)
        end
    end
    return "未知"
end
function isValidDotStateRow(self, v)
    return v ~= nil and type(v) == "table" and type(v.remaining) == "number" and type(v.effect) == "number"
end
function addDotEffectOnUnit(self, unit, model, duration)
    if not unit or not model or model == "" or type(jass.AddSpecialEffectTarget) ~= "function" then
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
function dealDamageForType(self, typeId, source, target, amount)
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
    --- 本次伤害由本模块 DOT 造成：须让 onDamage 里「所有」装备 DOT 类型都跳过施加，否则会只忽略当前 type，另一类型仍走 newProduct>effect*remaining 把剩余时间刷新满，导致跳数远超 time（如 3 秒变 5+ 跳）。
    local dh = unitHid(nil, target)
    do
        local di = 0
        while di < #dotTypes do
            local tid = dotTypes[di + 1].id
            if ignoredTargetByType[tid] == nil then
                ignoredTargetByType[tid] = {}
            end
            ignoredTargetByType[tid][dh] = true
            di = di + 1
        end
    end
    local typeBits = cfg.nextDamageTypeOverride ~= nil and cfg.nextDamageTypeOverride or DAMAGE_TYPE_SKILL + DAMAGE_TYPE_MIND
    damageEventModule:setNextDamageTypeOverride(typeBits)
    if type(damageEventModule.markNextPendingDamageAsDotTickBatch) == "function" then
        damageEventModule:markNextPendingDamageAsDotTickBatch()
    end
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
function ensureDotTimers(self)
    if dotTimer == nil and type(jass.TimerStart) == "function" then
        dotTimer = LeakWatcher:createTimer("dot_tick")
        jass.TimerStart(dotTimer, 1, true, dotTickRun)
    end
end
function pushDotTickForTarget(self, typeId, source, target, tgtHid, amount, duration, cfg)
    do
        local i = #dotTicks - 1
        while i >= 0 do
            local e = dotTicks[i + 1]
            if e.typeId == typeId and unitHid(nil, e.target) == tgtHid then
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
        effectModel = cfg.effectModel,
        effectDuration = cfg.effectDuration
    }
end
function fillDotStateRow(self, cur, target, source, amount, bestDuration)
    cur.effect = amount
    cur.remaining = bestDuration
    cur._dotParsedDuration = bestDuration
    cur._dotUnitRef = target
    cur.sourceName = getDotSourceDisplayName(nil, source)
end
function applyEquipmentDotOnHeroAttack(self, typeId, cfg, tab, tgtHid, target, source, amount, bestDuration, cur)
    if cur ~= nil then
        fillDotStateRow(
            nil,
            cur,
            target,
            source,
            amount,
            bestDuration
        )
        pushDotTickForTarget(
            nil,
            typeId,
            source,
            target,
            tgtHid,
            amount,
            bestDuration,
            cfg
        )
        notifyBuffPool(nil, typeId, target, cur)
    else
        local state = {
            effect = amount,
            remaining = bestDuration,
            _dotUnitRef = target,
            sourceName = getDotSourceDisplayName(nil, source),
            _dotParsedDuration = bestDuration
        }
        tabSetHid(nil, tab, tgtHid, state)
        pushDotTickForTarget(
            nil,
            typeId,
            source,
            target,
            tgtHid,
            amount,
            bestDuration,
            cfg
        )
        notifyBuffPool(nil, typeId, target, state)
        if type(cfg.onApply) == "function" then
            cfg:onApply(target, state)
        end
    end
    ensureDotTimers(nil)
end
function dotTickRun(self)
    local buffM = require("系统.05．Buff系统.00．Buff系统")
    do
        local i = #dotTicks - 1
        while i >= 0 do
            local e = dotTicks[i + 1]
            local eh = unitHid(nil, e.target)
            local ____temp_20
            if buffM.DOT_TYPE_TO_BUFF_ID ~= nil then
                ____temp_20 = buffM.DOT_TYPE_TO_BUFF_ID[e.typeId]
            else
                ____temp_20 = nil
            end
            local bid = ____temp_20
            local ____temp_21
            if bid ~= nil and bid ~= "" and type(buffM.getBuffRuntimeByHid) == "function" then
                ____temp_21 = buffM:getBuffRuntimeByHid(eh, bid)
            else
                ____temp_21 = nil
            end
            local rt = ____temp_21
            if rt == nil or rt.remaining <= 0.001 then
                __TS__ArraySplice(dotTicks, i, 1)
            end
            i = i - 1
        end
    end
    local batch = {}
    do
        local bi = #dotTicks - 1
        while bi >= 0 do
            local bh = unitHid(nil, dotTicks[bi + 1].target)
            if bh ~= 0 then
                batch[bh] = true
            end
            bi = bi - 1
        end
    end
    local batchSnap = batch
    dotTickBatchTargetHids = batchSnap
    local nDeals = #dotTicks
    dotBatchSnapForClear = batchSnap
    dotBatchDeferredRemaining = nDeals
    do
        local i = #dotTicks - 1
        while i >= 0 do
            local e = dotTicks[i + 1]
            local eh = unitHid(nil, e.target)
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
            local stTab = stateByType[e.typeId]
            local ____temp_23
            if stTab ~= nil then
                local ____tabRowForHid_result_22 = tabRowForHid(nil, stTab, eh)
                if ____tabRowForHid_result_22 == nil then
                    ____tabRowForHid_result_22 = stTab[e.target]
                end
                ____temp_23 = ____tabRowForHid_result_22
            else
                ____temp_23 = nil
            end
            local stateRaw = ____temp_23
            local state = isValidDotStateRow(nil, stateRaw) and stateRaw or nil
            if cfg ~= nil and type(cfg.onTick) == "function" and state ~= nil then
                cfg:onTick(e.target, state)
            end
            i = i - 1
        end
    end
    if nDeals <= 0 then
        dotTickBatchTargetHids = nil
        dotBatchSnapForClear = nil
        dotBatchDeferredRemaining = 0
    end
    if #dotTicks == 0 and dotTimer ~= nil then
        LeakWatcher:destroyTimer(dotTimer)
        dotTimer = nil
    end
end
jass = require("jass.common")
local g = require("jass.globals")
damageEventModule = require("系统.04．伤害系统.01．伤害事件")
local hasBit = damageEventModule.hasBit
local leakCore = require("系统.00．核心系统.05．泄露审计")
local ____leakCore_LeakWatcher_0 = leakCore.LeakWatcher
if ____leakCore_LeakWatcher_0 == nil then
    ____leakCore_LeakWatcher_0 = leakCore
end
LeakWatcher = ____leakCore_LeakWatcher_0
local debuffMod = require("系统.05．Buff系统.01．Buff表")
local debuffBuffs = debuffMod.buffs
--- DOT 每跳 `AddSpecialEffectTarget` 的模型路径，与同 ID 行的 `effect` 一致
local function dotEffectModelFromBuffRow(self, rowId)
    local row = debuffBuffs[rowId]
    return row ~= nil and type(row.effect) == "string" and row.effect ~= "" and row.effect or ""
end
local ____opt_1 = debuffBuffs.D001
local ____temp_9 = ____opt_1 and ____opt_1.buffID or "D001"
local ____opt_3 = debuffBuffs.D002
local ____temp_10 = ____opt_3 and ____opt_3.buffID or "D002"
local ____opt_5 = debuffBuffs.D003
local ____temp_11 = ____opt_5 and ____opt_5.buffID or "D003"
local ____opt_7 = debuffBuffs.D004
--- 与 Buff表 buffID 对齐，供 UI/其它系统引用（新增 Debuff 时在表内加行并在此补键）
____exports.DOT_DEBUFF_IDS = {antiHeal = ____temp_9, burn = ____temp_10, poison = ____temp_11, trollCurse = ____opt_7 and ____opt_7.buffID or "D004"}
DAMAGE_TYPE_SKILL = 2048
DAMAGE_TYPE_MIND = 256
--- 金属性/酸性在「伤害事件展示位」里的 bit，与 伤害测试 attr 表一致：bit 32 = 金属性
local DAMAGE_TYPE_METAL_UI_BITS_FOR_DISPLAY = 32
--- 火焰在「伤害事件展示位」里与 伤害测试 里 attr 表一致：bit4 = 火属性（勿用 common.j 的 32，否则会被显示成「金属性」）。
-- UnitDamageTarget 第 7 参仍传 jass.DAMAGE_TYPE_FIRE（句柄）。
local DAMAGE_TYPE_FIRE_UI_BITS_FOR_DISPLAY = 4
--- 与伤害事件展示一致：4096 = 物理
local DAMAGE_TYPE_PHYSICAL_UI_BITS_FOR_DISPLAY = 4096
dotTypes = {}
--- 注册一种 DOT，后续伤害回调会按配置解析装备并施加/覆盖
function ____exports.registerDotType(self, config)
    dotTypes[#dotTypes + 1] = config
end
stateByType = {}
dotTicks = {}
--- Buff 池 buffID → dot typeId（与 00．Buff系统 DOT_TYPE_TO_BUFF_ID 互逆）
local function dotTypeIdFromBuffId(self, buffID)
    if buffID == "D001" then
        return "antiHeal"
    end
    if buffID == "D002" then
        return "burn"
    end
    if buffID == "D003" then
        return "poison"
    end
    if buffID == "D004" then
        return "trollCurse"
    end
    return nil
end
ignoredTargetByType = {}
dotTickBatchTargetHids = nil
dotBatchSnapForClear = nil
dotBatchDeferredRemaining = 0
dotTimer = nil
EFFECT_RECYCLE_INTERVAL = 0.2
effectRecycleList = {}
effectRecycleTimer = nil
local itemsData = require("系统.02．物品系统.01．装备数据").items or require("系统.02．物品系统.01．装备数据").default or ({})
local function removeDotTicksForTargetHid(self, typeId, tgtHid)
    do
        local i = #dotTicks - 1
        while i >= 0 do
            local e = dotTicks[i + 1]
            if e.typeId == typeId and unitHid(nil, e.target) == tgtHid then
                __TS__ArraySplice(dotTicks, i, 1)
            end
            i = i - 1
        end
    end
end
local function tabDeleteHid(self, tab, hid)
    if hid == 0 then
        return
    end
    __TS__Delete(tab, hid)
    __TS__Delete(
        tab,
        tostring(hid)
    )
end
local function collectHidsInTab(self, tab)
    local seen = {}
    local out = {}
    for k in pairs(tab) do
        do
            local __continue27
            repeat
                local kn = type(k) == "number" and k or __TS__ParseInt(k, 10)
                if __TS__NumberIsNaN(__TS__Number(kn)) or kn == 0 then
                    __continue27 = true
                    break
                end
                if seen[kn] then
                    __continue27 = true
                    break
                end
                seen[kn] = true
                out[#out + 1] = kn
                __continue27 = true
            until true
            if not __continue27 then
                break
            end
        end
    end
    return out
end
--- `IsUnitType` 第二参为 unittype。common.j 里 `UNIT_TYPE_STRUCTURE` 已是 unittype，不可再 `ConvertUnitType(UNIT_TYPE_STRUCTURE)`（该 native 只吃整数索引，如 64）。
local function getStructureUnitTypeHandle(self)
    local jc = jass
    local gg = g
    local ____jc_UNIT_TYPE_STRUCTURE_12 = jc.UNIT_TYPE_STRUCTURE
    if ____jc_UNIT_TYPE_STRUCTURE_12 == nil then
        ____jc_UNIT_TYPE_STRUCTURE_12 = gg.UNIT_TYPE_STRUCTURE
    end
    local direct = ____jc_UNIT_TYPE_STRUCTURE_12
    if direct ~= nil then
        return direct
    end
    if type(jass.ConvertUnitType) == "function" then
        return jass.ConvertUnitType(64)
    end
    return nil
end
--- 禁止用局部变量承接 jass API 再调用，TSTL 会编成 `j:Fn()` 导致 bad self
local function isDebuffDotTargetOk(self, source, target)
    if source == nil or target == nil or target == 0 then
        return false
    end
    local utStruct = getStructureUnitTypeHandle(nil)
    if type(jass.IsUnitType) == "function" and utStruct ~= nil then
        if jass.IsUnitType(target, utStruct) == true then
            return false
        end
    end
    if type(jass.GetOwningPlayer) ~= "function" then
        return false
    end
    local srcP = jass.GetOwningPlayer(source)
    if srcP == nil then
        return false
    end
    if type(jass.IsUnitEnemy) == "function" then
        return jass.IsUnitEnemy(target, srcP) == true
    end
    if type(jass.IsPlayerEnemy) == "function" then
        local tp = jass.GetOwningPlayer(target)
        if tp ~= nil then
            return jass.IsPlayerEnemy(srcP, tp) == true
        end
    end
    return false
end
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
--- 与 JASS `return IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO)` 一致：第二参为全局 `UNIT_TYPE_HERO`（unittype），
-- 同 `装备限制` / `任务管理器` 的 `jass.IsUnitType(unit, jass.UNIT_TYPE_HERO)`，不要对常量再套一层 `ConvertUnitType`。
-- 仅当 jass 与 `jass.globals` 都未注入该常量时，用 `ConvertUnitType(2)` 兜底（common.j 里 HERO=$02）。
local function heroUnitTypeForIsUnitType(self)
    local ____jass_UNIT_TYPE_HERO_13 = jass.UNIT_TYPE_HERO
    if ____jass_UNIT_TYPE_HERO_13 == nil then
        ____jass_UNIT_TYPE_HERO_13 = g.UNIT_TYPE_HERO
    end
    local direct = ____jass_UNIT_TYPE_HERO_13
    if direct ~= nil then
        return direct
    end
    if type(jass.ConvertUnitType) ~= "function" then
        return nil
    end
    return jass.ConvertUnitType(2)
end
--- 来源是否为玩家 1–4 的英雄（当前仅这类来源会触发装备 DOT）
local function isSourceHeroPlayer1to4(self, unit)
    if not unit or type(jass.GetOwningPlayer) ~= "function" then
        return false
    end
    local hasIsUnitType = type(jass.IsUnitType) == "function"
    local hasHeroLevel = type(jass.GetHeroLevel) == "function"
    if not hasIsUnitType and not hasHeroLevel then
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
    local utHero = heroUnitTypeForIsUnitType(nil)
    if hasIsUnitType and utHero ~= nil and jass.IsUnitType(unit, utHero) == true then
        return true
    end
    if hasHeroLevel and jass.GetHeroLevel(unit) > 0 then
        return true
    end
    return false
end
--- Buff 池每 0.1s 递减后调用：把池内 remaining/effect 写回 `stateByType`；池已无行则清理逻辑层与秒跳队列。
function ____exports.syncDotRemainingFromBuffPool(self)
    local buffM = require("系统.05．Buff系统.00．Buff系统")
    local map = buffM.DOT_TYPE_TO_BUFF_ID
    if map == nil or type(buffM.getBuffRuntimeByHid) ~= "function" then
        return
    end
    for typeId in pairs(stateByType) do
        do
            local __continue67
            repeat
                local tab = stateByType[typeId]
                if tab == nil then
                    __continue67 = true
                    break
                end
                local buffID = map[typeId]
                if buffID == nil or buffID == "" then
                    __continue67 = true
                    break
                end
                local hids = collectHidsInTab(nil, tab)
                do
                    local hi = 0
                    while hi < #hids do
                        do
                            local __continue71
                            repeat
                                local kn = hids[hi + 1]
                                local v = tabRowForHid(nil, tab, kn)
                                if v == nil or not isValidDotStateRow(nil, v) then
                                    tabDeleteHid(nil, tab, kn)
                                    __continue71 = true
                                    break
                                end
                                local rt = buffM:getBuffRuntimeByHid(kn, buffID)
                                if rt == nil or rt.remaining <= 0 then
                                    local cfg = __TS__ArrayFind(
                                        dotTypes,
                                        function(____, c) return c.id == typeId end
                                    )
                                    if cfg ~= nil and type(cfg.onEnd) == "function" then
                                        local uref = v._dotUnitRef
                                        local ____self_15 = cfg
                                        local ____self_15_onEnd_16 = ____self_15.onEnd
                                        local ____temp_14
                                        if uref ~= nil then
                                            ____temp_14 = uref
                                        else
                                            ____temp_14 = kn
                                        end
                                        ____self_15_onEnd_16(____self_15, ____temp_14, v)
                                    end
                                    notifyBuffPool(nil, typeId, kn, nil)
                                    tabDeleteHid(nil, tab, kn)
                                    removeDotTicksForTargetHid(nil, typeId, kn)
                                    __continue71 = true
                                    break
                                end
                                v.remaining = rt.remaining
                                v.effect = rt.effect
                                if rt.sourceName ~= nil then
                                    v.sourceName = rt.sourceName
                                end
                                if rt._dotParsedDuration ~= nil then
                                    v._dotParsedDuration = rt._dotParsedDuration
                                end
                                __continue71 = true
                            until true
                            if not __continue71 then
                                break
                            end
                        end
                        hi = hi + 1
                    end
                end
                __continue67 = true
            until true
            if not __continue67 then
                break
            end
        end
    end
end
--- Buff 池判定某 DOT 到期时调用（池行已删，勿再 syncDotBuff null）
function ____exports.clearDotByBuffPoolExpire(self, buffID, hid)
    local typeId = dotTypeIdFromBuffId(nil, buffID)
    if typeId == nil or hid == 0 then
        return
    end
    local tab = stateByType[typeId]
    if tab == nil then
        return
    end
    local v = tabRowForHid(nil, tab, hid)
    if v ~= nil and isValidDotStateRow(nil, v) then
        local cfg = __TS__ArrayFind(
            dotTypes,
            function(____, c) return c.id == typeId end
        )
        if cfg ~= nil and type(cfg.onEnd) == "function" then
            local uref = v._dotUnitRef
            local ____self_18 = cfg
            local ____self_18_onEnd_19 = ____self_18.onEnd
            local ____temp_17
            if uref ~= nil then
                ____temp_17 = uref
            else
                ____temp_17 = hid
            end
            ____self_18_onEnd_19(____self_18, ____temp_17, v)
        end
    end
    tabDeleteHid(nil, tab, hid)
    removeDotTicksForTargetHid(nil, typeId, hid)
end
--- 伤害事件延后展示前调用：用**整段** `udg_TempDamageType` 判定普攻位，每刀只叠一次装备 DOT，避免多段伤害丢 8192/16384。
-- 与 `onDamage` 内普攻分支互斥：回调里 `isAttackHitForDot` 为真时不再叠层。
function ____exports.tryApplyHeroAttackGearDots(self, source, target, _damage)
    if not target or not source then
        return
    end
    if not isSourceHeroPlayer1to4(nil, source) then
        return
    end
    local tgtHid = unitHid(nil, target)
    do
        local t = 0
        while t < #dotTypes do
            do
                local __continue89
                repeat
                    local cfg = dotTypes[t + 1]
                    local typeId = cfg.id
                    if cfg.debuffDotEnemyNoStructure == true and not isDebuffDotTargetOk(nil, source, target) then
                        __continue89 = true
                        break
                    end
                    local best = cfg:getBestFromUnit(source)
                    if best == nil then
                        __continue89 = true
                        break
                    end
                    local amount = cfg:computeAmount(target, best)
                    if amount <= 0 then
                        __continue89 = true
                        break
                    end
                    if stateByType[typeId] == nil then
                        stateByType[typeId] = {}
                    end
                    local tab = stateByType[typeId]
                    local curRaw = tabRowForHid(nil, tab, tgtHid)
                    local cur = isValidDotStateRow(nil, curRaw) and curRaw or nil
                    if curRaw ~= nil and cur == nil then
                        tabDeleteHid(nil, tab, tgtHid)
                    end
                    applyEquipmentDotOnHeroAttack(
                        nil,
                        typeId,
                        cfg,
                        tab,
                        tgtHid,
                        target,
                        source,
                        amount,
                        best.duration,
                        cur
                    )
                    __continue89 = true
                until true
                if not __continue89 then
                    break
                end
            end
            t = t + 1
        end
    end
end
--- 由 伤害事件.runDeferredDamageDisplay 在每段 DOT 伤害展示回调结束后调用，替代 Timer(0) 清空 batch（避免早于 deferred onDamage）
function ____exports.notifyDotTickBatchDamageDisplayed(self)
    if dotBatchDeferredRemaining <= 0 then
        return
    end
    dotBatchDeferredRemaining = dotBatchDeferredRemaining - 1
    if dotBatchDeferredRemaining <= 0 then
        if dotTickBatchTargetHids ~= nil and dotTickBatchTargetHids == dotBatchSnapForClear then
            dotTickBatchTargetHids = nil
        end
        dotBatchSnapForClear = nil
        dotBatchDeferredRemaining = 0
    end
end
--- 判定「同一件装备解析出的 time」是否与当前状态一致（仅用于非普攻叠层）
local DURATION_TIER_EPS = 0.05
local function sameDurationTier(self, cur, bestDuration)
    return cur._dotParsedDuration ~= nil and math.abs(bestDuration - cur._dotParsedDuration) < DURATION_TIER_EPS
end
--- 技能等非普攻伤害：同档刷新或乘积更强时换条
local function applyEquipmentDotOnNonAttack(self, typeId, cfg, tab, tgtHid, target, source, amount, bestDuration, cur)
    if cur == nil then
        local state = {
            effect = amount,
            remaining = bestDuration,
            _dotUnitRef = target,
            sourceName = getDotSourceDisplayName(nil, source),
            _dotParsedDuration = bestDuration
        }
        tabSetHid(nil, tab, tgtHid, state)
        pushDotTickForTarget(
            nil,
            typeId,
            source,
            target,
            tgtHid,
            amount,
            bestDuration,
            cfg
        )
        notifyBuffPool(nil, typeId, target, state)
        if type(cfg.onApply) == "function" then
            cfg:onApply(target, state)
        end
        ensureDotTimers(nil)
        return
    end
    if sameDurationTier(nil, cur, bestDuration) then
        fillDotStateRow(
            nil,
            cur,
            target,
            source,
            amount,
            bestDuration
        )
        pushDotTickForTarget(
            nil,
            typeId,
            source,
            target,
            tgtHid,
            amount,
            bestDuration,
            cfg
        )
        notifyBuffPool(nil, typeId, target, cur)
        ensureDotTimers(nil)
        return
    end
    local currentProduct = cur.effect * cur.remaining
    local newProduct = amount * bestDuration
    if newProduct <= currentProduct then
        return
    end
    if type(cfg.onEnd) == "function" then
        cfg:onEnd(target, cur)
    end
    local state = {
        effect = amount,
        remaining = bestDuration,
        _dotUnitRef = target,
        sourceName = getDotSourceDisplayName(nil, source),
        _dotParsedDuration = bestDuration
    }
    tabSetHid(nil, tab, tgtHid, state)
    pushDotTickForTarget(
        nil,
        typeId,
        source,
        target,
        tgtHid,
        amount,
        bestDuration,
        cfg
    )
    notifyBuffPool(nil, typeId, target, state)
    if type(cfg.onApply) == "function" then
        cfg:onApply(target, state)
    end
    ensureDotTimers(nil)
end
--- - `ignoredTargetByType`：DOT 自伤一轮内各类型各清一次并跳过叠层。
-- - `suppressDotApplyForBatch`：秒跳批内且无普攻位时跳过（普攻永远可走 `applyEquipmentDotOnHeroAttack`）。
local function onDamage(self, target, damage, damageType, fromDotTickBatch)
    if not target then
        return
    end
    local isAttackHitForDot = damageEventModule:damageTypeLooksLikeWeaponHitForGearDot(damageType)
    if damage <= 0 and not isAttackHitForDot then
        return
    end
    local ju = jass
    local ____temp_24
    if ju.udg_TempUnit ~= nil and ju.udg_TempUnit[6] ~= nil then
        ____temp_24 = ju.udg_TempUnit[6]
    else
        ____temp_24 = nil
    end
    local source = ____temp_24
    if not source then
        return
    end
    if not isSourceHeroPlayer1to4(nil, source) then
        return
    end
    local tgtHid = unitHid(nil, target)
    local suppressDotApplyForBatch = fromDotTickBatch == true and dotTickBatchTargetHids ~= nil and dotTickBatchTargetHids[tgtHid] == true and not isAttackHitForDot
    do
        local t = 0
        while t < #dotTypes do
            do
                local __continue157
                repeat
                    local cfg = dotTypes[t + 1]
                    local typeId = cfg.id
                    if ignoredTargetByType[typeId] ~= nil and ignoredTargetByType[typeId][tgtHid] == true then
                        __TS__Delete(ignoredTargetByType[typeId], tgtHid)
                        __continue157 = true
                        break
                    end
                    if suppressDotApplyForBatch then
                        __continue157 = true
                        break
                    end
                    if isAttackHitForDot then
                        __continue157 = true
                        break
                    end
                    if cfg.debuffDotEnemyNoStructure == true and not isDebuffDotTargetOk(nil, source, target) then
                        __continue157 = true
                        break
                    end
                    local best = cfg:getBestFromUnit(source)
                    if best == nil then
                        __continue157 = true
                        break
                    end
                    if best.attackOnly == true or cfg.attackOnlyTrigger == true then
                        if not isAttackHitForDot then
                            __continue157 = true
                            break
                        end
                    end
                    local amount = cfg:computeAmount(target, best)
                    if amount <= 0 then
                        __continue157 = true
                        break
                    end
                    if stateByType[typeId] == nil then
                        stateByType[typeId] = {}
                    end
                    local tab = stateByType[typeId]
                    local curRaw = tabRowForHid(nil, tab, tgtHid)
                    local cur = isValidDotStateRow(nil, curRaw) and curRaw or nil
                    if curRaw ~= nil and cur == nil then
                        tabDeleteHid(nil, tab, tgtHid)
                    end
                    if isAttackHitForDot then
                        applyEquipmentDotOnHeroAttack(
                            nil,
                            typeId,
                            cfg,
                            tab,
                            tgtHid,
                            target,
                            source,
                            amount,
                            best.duration,
                            cur
                        )
                    else
                        applyEquipmentDotOnNonAttack(
                            nil,
                            typeId,
                            cfg,
                            tab,
                            tgtHid,
                            target,
                            source,
                            amount,
                            best.duration,
                            cur
                        )
                    end
                    __continue157 = true
                until true
                if not __continue157 then
                    break
                end
            end
            t = t + 1
        end
    end
end
--- 装备 `Buff` 可多段，用 `+` 连接，例如：`Buff:dmg:...;timeN+Buff:dmg:...;timeN`
local function splitItemBuffSegments(self, buff)
    if not buff or type(buff) ~= "string" then
        return {}
    end
    local parts = __TS__StringSplit(buff, "+")
    local out = {}
    do
        local i = 0
        while i < #parts do
            local t = __TS__StringTrim(parts[i + 1])
            if t ~= "" then
                out[#out + 1] = t
            end
            i = i + 1
        end
    end
    return out
end
local function parseAntiHealBuff(self, buffStr)
    if not buffStr or type(buffStr) ~= "string" then
        return nil
    end
    local s = __TS__StringTrim(buffStr)
    local attackOnly = false
    if (string.find(s, "Buff:attack:", nil, true) or 0) - 1 == 0 then
        attackOnly = true
    elseif (string.find(s, "Buff:dmg:", nil, true) or 0) - 1 ~= 0 then
        return nil
    end
    local rest = __TS__StringSubstring(s, attackOnly and 12 or 9)
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
    return {effectPct = effectPct, duration = duration, attackOnly = attackOnly}
end
--- 目标最大生命（诅咒 DOT 按 %MaxHP 结算）。
-- 1.27 等环境 `jass.UNIT_STATE_MAX_LIFE` 常为 nil，需与 `装备回复` 一致用 `ConvertUnitState(1)` 取最大生命。
-- **禁止**用 `globalThis["GetUnitState"](u,s)`：TSTL 会编成 `gt:GetUnitState`，Lua 里变成 `(gt,u,s)` 参数错位，恒得 0。
local function getUnitMaxHp(self, targetUnit)
    if not targetUnit then
        return 0
    end
    if type(jass.BlzGetUnitMaxHP) == "function" then
        local m = jass.BlzGetUnitMaxHP(targetUnit)
        if type(m) == "number" and __TS__NumberIsFinite(__TS__Number(m)) and m > 0 then
            return m
        end
    end
    if type(jass.GetUnitState) ~= "function" then
        return 0
    end
    local jc = jass
    local gg = g
    local maxLifeState = nil
    if jc.UNIT_STATE_MAX_LIFE ~= nil then
        maxLifeState = jc.UNIT_STATE_MAX_LIFE
    elseif gg.UNIT_STATE_MAX_LIFE ~= nil then
        maxLifeState = gg.UNIT_STATE_MAX_LIFE
    elseif type(jass.ConvertUnitState) == "function" then
        maxLifeState = jass.ConvertUnitState(1)
    end
    if maxLifeState == nil then
        return 0
    end
    local v = jass.GetUnitState(targetUnit, maxLifeState)
    return type(v) == "number" and __TS__NumberIsFinite(__TS__Number(v)) and v > 0 and v or 0
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
                local __continue203
                repeat
                    local item = unitItemInSlot(nil, unit, slot)
                    if not item then
                        __continue203 = true
                        break
                    end
                    local idStr = fourCCToString(
                        nil,
                        getItemTypeId(nil, item)
                    )
                    local entry = itemsData[idStr]
                    local segments = (entry and entry.Buff) ~= nil and splitItemBuffSegments(nil, entry.Buff) or ({})
                    do
                        local si = 0
                        while si < #segments do
                            do
                                local __continue206
                                repeat
                                    local parsed = parseAntiHealBuff(nil, segments[si + 1])
                                    if not parsed then
                                        __continue206 = true
                                        break
                                    end
                                    local product = parsed.effectPct * parsed.duration
                                    if best == nil or product > best.product then
                                        best = {effectPct = parsed.effectPct, duration = parsed.duration, product = product, attackOnly = parsed.attackOnly}
                                    end
                                    __continue206 = true
                                until true
                                if not __continue206 then
                                    break
                                end
                            end
                            si = si + 1
                        end
                    end
                    __continue203 = true
                until true
                if not __continue203 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return best ~= nil and ({effectPct = best.effectPct, duration = best.duration, attackOnly = best.attackOnly}) or nil
end
local function parseBurnBuff(self, buffStr)
    if not buffStr or type(buffStr) ~= "string" then
        return nil
    end
    local s = __TS__StringTrim(buffStr)
    local attackOnly = false
    if (string.find(s, "Buff:attack:", nil, true) or 0) - 1 == 0 then
        attackOnly = true
    elseif (string.find(s, "Buff:dmg:", nil, true) or 0) - 1 ~= 0 then
        return nil
    end
    local rest = __TS__StringSubstring(s, attackOnly and 12 or 9)
    local burnIdx = (string.find(rest, "Burn", nil, true) or 0) - 1
    if burnIdx < 0 then
        return nil
    end
    local numEnd = burnIdx + 4
    while numEnd < #rest do
        local c = __TS__StringCharAt(rest, numEnd)
        if c >= "0" and c <= "9" then
            numEnd = numEnd + 1
        else
            break
        end
    end
    local damagePerSec = numEnd > burnIdx + 4 and (__TS__ParseInt(
        __TS__StringSubstring(rest, burnIdx + 4, numEnd),
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
    if duration <= 0 or damagePerSec <= 0 then
        return nil
    end
    return {damagePerSec = damagePerSec, duration = duration, attackOnly = attackOnly}
end
local function getBestBurnFromUnit(self, unit)
    local best = nil
    do
        local slot = 0
        while slot <= 5 do
            do
                local __continue224
                repeat
                    local item = unitItemInSlot(nil, unit, slot)
                    if not item then
                        __continue224 = true
                        break
                    end
                    local idStr = fourCCToString(
                        nil,
                        getItemTypeId(nil, item)
                    )
                    local entry = itemsData[idStr]
                    local segments = (entry and entry.Buff) ~= nil and splitItemBuffSegments(nil, entry.Buff) or ({})
                    do
                        local si = 0
                        while si < #segments do
                            do
                                local __continue227
                                repeat
                                    local parsed = parseBurnBuff(nil, segments[si + 1])
                                    if not parsed then
                                        __continue227 = true
                                        break
                                    end
                                    local product = parsed.damagePerSec * parsed.duration
                                    if best == nil or product > best.product then
                                        best = {damagePerSec = parsed.damagePerSec, duration = parsed.duration, product = product, attackOnly = parsed.attackOnly}
                                    end
                                    __continue227 = true
                                until true
                                if not __continue227 then
                                    break
                                end
                            end
                            si = si + 1
                        end
                    end
                    __continue224 = true
                until true
                if not __continue224 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return best ~= nil and ({damagePerSec = best.damagePerSec, duration = best.duration, attackOnly = best.attackOnly}) or nil
end
____exports.registerDotType(
    nil,
    {
        id = "antiHeal",
        debuffDotEnemyNoStructure = true,
        parseBuff = parseAntiHealBuff,
        getBestFromUnit = getBestAntiHealFromUnit,
        computeAmount = function(____, target, parsed)
            local regenHP = getTargetRegenHP(nil, target)
            return regenHP * (parsed.effectPct / 100)
        end,
        damageType = jass.DAMAGE_TYPE_MIND,
        effectModel = dotEffectModelFromBuffRow(nil, "D001"),
        effectDuration = 0.8
    }
)
____exports.registerDotType(
    nil,
    {
        id = "burn",
        debuffDotEnemyNoStructure = true,
        parseBuff = parseBurnBuff,
        getBestFromUnit = getBestBurnFromUnit,
        computeAmount = function(____, _target, parsed) return parsed.damagePerSec or 0 end,
        damageType = jass.DAMAGE_TYPE_FIRE,
        nextDamageTypeOverride = DAMAGE_TYPE_SKILL + DAMAGE_TYPE_FIRE_UI_BITS_FOR_DISPLAY,
        effectModel = dotEffectModelFromBuffRow(nil, "D002"),
        effectDuration = 0.75
    }
)
local function parsePoisonBuff(self, buffStr)
    if not buffStr or type(buffStr) ~= "string" then
        return nil
    end
    local s = __TS__StringTrim(buffStr)
    local attackOnly = false
    if (string.find(s, "attack:poison", nil, true) or 0) - 1 == 0 then
        attackOnly = true
    elseif (string.find(s, "dmg:poison", nil, true) or 0) - 1 ~= 0 then
        return nil
    end
    local rest = __TS__StringSubstring(s, attackOnly and 13 or 10)
    local numEnd = 0
    while numEnd < #rest do
        local c = __TS__StringCharAt(rest, numEnd)
        if c >= "0" and c <= "9" then
            numEnd = numEnd + 1
        else
            break
        end
    end
    local damagePerSec = numEnd > 0 and (__TS__ParseInt(
        __TS__StringSubstring(rest, 0, numEnd),
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
    if duration <= 0 or damagePerSec <= 0 then
        return nil
    end
    return {damagePerSec = damagePerSec, duration = duration, attackOnly = attackOnly}
end
local function getBestPoisonFromUnit(self, unit)
    local best = nil
    do
        local slot = 0
        while slot <= 5 do
            do
                local __continue246
                repeat
                    local item = unitItemInSlot(nil, unit, slot)
                    if not item then
                        __continue246 = true
                        break
                    end
                    local idStr = fourCCToString(
                        nil,
                        getItemTypeId(nil, item)
                    )
                    local entry = itemsData[idStr]
                    local segments = (entry and entry.Buff) ~= nil and splitItemBuffSegments(nil, entry.Buff) or ({})
                    do
                        local si = 0
                        while si < #segments do
                            do
                                local __continue249
                                repeat
                                    local parsed = parsePoisonBuff(nil, segments[si + 1])
                                    if not parsed then
                                        __continue249 = true
                                        break
                                    end
                                    local product = parsed.damagePerSec * parsed.duration
                                    if best == nil or product > best.product then
                                        best = {damagePerSec = parsed.damagePerSec, duration = parsed.duration, product = product, attackOnly = parsed.attackOnly}
                                    end
                                    __continue249 = true
                                until true
                                if not __continue249 then
                                    break
                                end
                            end
                            si = si + 1
                        end
                    end
                    __continue246 = true
                until true
                if not __continue246 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return best ~= nil and ({damagePerSec = best.damagePerSec, duration = best.duration, attackOnly = best.attackOnly}) or nil
end
____exports.registerDotType(
    nil,
    {
        id = "poison",
        debuffDotEnemyNoStructure = true,
        parseBuff = parsePoisonBuff,
        getBestFromUnit = getBestPoisonFromUnit,
        computeAmount = function(____, _target, parsed) return parsed.damagePerSec or 0 end,
        damageType = jass.DAMAGE_TYPE_ACID,
        nextDamageTypeOverride = DAMAGE_TYPE_SKILL + DAMAGE_TYPE_METAL_UI_BITS_FOR_DISPLAY,
        effectModel = dotEffectModelFromBuffRow(nil, "D003"),
        effectDuration = 0.8
    }
)
local function parseTrollCurseBuff(self, buffStr)
    if not buffStr or type(buffStr) ~= "string" then
        return nil
    end
    local s = __TS__StringTrim(buffStr)
    if (string.find(s, "Buff:", nil, true) or 0) - 1 == 0 then
        s = __TS__StringSubstring(s, 5)
    end
    local attackOnly = false
    local rest
    if (string.find(s, "attack:curse", nil, true) or 0) - 1 == 0 then
        attackOnly = true
        rest = __TS__StringSubstring(s, 13)
    elseif (string.find(s, "dmg:curse", nil, true) or 0) - 1 == 0 then
        rest = __TS__StringSubstring(s, 9)
    else
        return nil
    end
    local numEnd = 0
    while numEnd < #rest do
        local c = __TS__StringCharAt(rest, numEnd)
        if c >= "0" and c <= "9" then
            numEnd = numEnd + 1
        else
            break
        end
    end
    local pctMaxHpPerSec = numEnd > 0 and (__TS__ParseInt(
        __TS__StringSubstring(rest, 0, numEnd),
        10
    ) or 0) or 0
    local pctPos = (string.find(rest, "%MaxHP", nil, true) or 0) - 1
    if pctPos < 0 or pctPos ~= numEnd then
        return nil
    end
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
    if duration <= 0 or pctMaxHpPerSec <= 0 then
        return nil
    end
    return {pctMaxHpPerSec = pctMaxHpPerSec, duration = duration, attackOnly = attackOnly}
end
local function getBestTrollCurseFromUnit(self, unit)
    local best = nil
    do
        local slot = 0
        while slot <= 5 do
            do
                local __continue270
                repeat
                    local item = unitItemInSlot(nil, unit, slot)
                    if not item then
                        __continue270 = true
                        break
                    end
                    local idStr = fourCCToString(
                        nil,
                        getItemTypeId(nil, item)
                    )
                    local entry = itemsData[idStr]
                    local segments = (entry and entry.Buff) ~= nil and splitItemBuffSegments(nil, entry.Buff) or ({})
                    do
                        local si = 0
                        while si < #segments do
                            do
                                local __continue273
                                repeat
                                    local parsed = parseTrollCurseBuff(nil, segments[si + 1])
                                    if not parsed then
                                        __continue273 = true
                                        break
                                    end
                                    local product = parsed.pctMaxHpPerSec * parsed.duration
                                    if best == nil or product > best.product then
                                        best = {pctMaxHpPerSec = parsed.pctMaxHpPerSec, duration = parsed.duration, product = product, attackOnly = parsed.attackOnly}
                                    end
                                    __continue273 = true
                                until true
                                if not __continue273 then
                                    break
                                end
                            end
                            si = si + 1
                        end
                    end
                    __continue270 = true
                until true
                if not __continue270 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return best ~= nil and ({pctMaxHpPerSec = best.pctMaxHpPerSec, duration = best.duration, attackOnly = best.attackOnly}) or nil
end
____exports.registerDotType(
    nil,
    {
        id = "trollCurse",
        debuffDotEnemyNoStructure = true,
        parseBuff = parseTrollCurseBuff,
        getBestFromUnit = getBestTrollCurseFromUnit,
        computeAmount = function(____, target, parsed)
            local maxHp = getUnitMaxHp(nil, target)
            return maxHp * (parsed.pctMaxHpPerSec / 100)
        end,
        damageType = jass.DAMAGE_TYPE_NORMAL,
        nextDamageTypeOverride = DAMAGE_TYPE_SKILL + DAMAGE_TYPE_PHYSICAL_UI_BITS_FOR_DISPLAY,
        effectModel = dotEffectModelFromBuffRow(nil, "D004"),
        effectDuration = 0.8
    }
)
local registered = false
local function init(self, damageEvent)
    if registered then
        return
    end
    registered = true
    damageEvent:registerDamageCallback(function(____, unit, damage, dmgType, _f, _l, fromDotTickBatch)
        onDamage(
            nil,
            unit,
            damage,
            dmgType,
            fromDotTickBatch
        )
    end)
end
--- 供治疗等系统读取：单位当前反恢复状态，无则返回 null
function ____exports.getUnitAntiHeal(self, unit)
    local tab = stateByType.antiHeal
    if tab == nil or unit == nil or unit == 0 then
        return nil
    end
    local h = unitHid(nil, unit)
    local ____temp_33
    if h ~= 0 then
        ____temp_33 = tabRowForHid(nil, tab, h)
    else
        ____temp_33 = nil
    end
    local raw = ____temp_33
    if raw ~= nil then
        return isValidDotStateRow(nil, raw) and raw or nil
    end
    local u = tab[unit]
    return u ~= nil and isValidDotStateRow(nil, u) and u or nil
end
--- 供 UI 等读取：单位当前燃烧 DOT 状态，无则返回 null
function ____exports.getUnitBurn(self, unit)
    local tab = stateByType.burn
    if tab == nil or unit == nil or unit == 0 then
        return nil
    end
    local h = unitHid(nil, unit)
    local ____temp_34
    if h ~= 0 then
        ____temp_34 = tabRowForHid(nil, tab, h)
    else
        ____temp_34 = nil
    end
    local raw = ____temp_34
    if raw ~= nil then
        return isValidDotStateRow(nil, raw) and raw or nil
    end
    local u = tab[unit]
    return u ~= nil and isValidDotStateRow(nil, u) and u or nil
end
--- 供 UI 等读取：单位当前中毒 DOT 状态，无则返回 null
function ____exports.getUnitPoison(self, unit)
    local tab = stateByType.poison
    if tab == nil or unit == nil or unit == 0 then
        return nil
    end
    local h = unitHid(nil, unit)
    local ____temp_35
    if h ~= 0 then
        ____temp_35 = tabRowForHid(nil, tab, h)
    else
        ____temp_35 = nil
    end
    local raw = ____temp_35
    if raw ~= nil then
        return isValidDotStateRow(nil, raw) and raw or nil
    end
    local u = tab[unit]
    return u ~= nil and isValidDotStateRow(nil, u) and u or nil
end
--- 供 UI 等读取：D004 巨魔头颅诅咒（`registerDotType` id `trollCurse` 注册后才有状态）
function ____exports.getUnitTrollCurse(self, unit)
    local tab = stateByType.trollCurse
    if tab == nil or unit == nil or unit == 0 then
        return nil
    end
    local h = unitHid(nil, unit)
    local ____temp_36
    if h ~= 0 then
        ____temp_36 = tabRowForHid(nil, tab, h)
    else
        ____temp_36 = nil
    end
    local raw = ____temp_36
    if raw ~= nil then
        return isValidDotStateRow(nil, raw) and raw or nil
    end
    local u = tab[unit]
    return u ~= nil and isValidDotStateRow(nil, u) and u or nil
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
--- 造成火焰伤害（外部技能与 burn DOT 同源类型时可调用）
function ____exports.dealBurnDamage(self, source, target, amount)
    dealDamageForType(
        nil,
        "burn",
        source,
        target,
        amount
    )
end
init(nil, damageEventModule)
return ____exports
