local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__NumberToFixed = ____lualib.__TS__NumberToFixed
local __TS__StringSplit = ____lualib.__TS__StringSplit
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
-- 与 `01．Buff表.ts` 对应：D001「反恢复」、D002「燃烧」。
-- - 反恢复：装备 `Buff:dmg:AntiHeal200%;time3` → 精神伤害，每秒 regenHP×200%，持续 time 秒。
-- - 燃烧：装备 `Buff:dmg:Burn50;time5` → 火焰伤害，每秒固定 damage 点，持续 time 秒（数值由解析结果决定）。
local jass = require("jass.common")
local g = require("jass.globals")
local damageEventModule = require("系统.04．伤害系统.伤害事件")
local leakCore = require("系统.00．核心系统.泄露审计")
local ____leakCore_LeakWatcher_0 = leakCore.LeakWatcher
if ____leakCore_LeakWatcher_0 == nil then
    ____leakCore_LeakWatcher_0 = leakCore
end
local LeakWatcher = ____leakCore_LeakWatcher_0
local debuffMod = require("系统.05．Buff系统.01．Buff表")
local debuffBuffs = debuffMod.buffs
local ____opt_1 = debuffBuffs.D001
local ____temp_5 = ____opt_1 and ____opt_1.buffID or "D001"
local ____opt_3 = debuffBuffs.D002
--- 与 Buff表 D001「反恢复」、D002「燃烧」buffID 对齐，供 UI/其它系统引用
____exports.DOT_DEBUFF_IDS = {antiHeal = ____temp_5, burn = ____opt_3 and ____opt_3.buffID or "D002"}
local TICK = 0.25
--- 伤害类型位：2048=技能 256=精神，用于 Lua 造成的伤害在事件里显示正确文案
local DAMAGE_TYPE_SKILL = 2048
local DAMAGE_TYPE_MIND = 256
--- 火焰在「伤害事件展示位」里与 伤害测试 里 attr 表一致：bit4 = 火属性（勿用 common.j 的 32，否则会被显示成「金属性」）。
-- UnitDamageTarget 第 7 参仍传 jass.DAMAGE_TYPE_FIRE（句柄）。
local DAMAGE_TYPE_FIRE_UI_BITS_FOR_DISPLAY = 4
local dotTypes = {}
--- 注册一种 DOT，后续伤害回调会按配置解析装备并施加/覆盖
function ____exports.registerDotType(self, config)
    dotTypes[#dotTypes + 1] = config
end
--- Buff 池同步：避免顶层 require 循环，运行时加载 05．Buff系统.Buff系统
local function notifyBuffPool(self, typeId, target, state)
    pcall(function ()
            local m = require("系统.05．Buff系统.Buff系统")
            if m ~= nil and type(m.syncDotBuff) == "function" then
                m:syncDotBuff(typeId, target, state)
            end
        end
    )
end
--- 按类型、再按目标存状态。stateByType[typeId][GetHandleId(target)] = { effect, remaining, _dotUnitRef?, ... }
local stateByType = {}
local dotTicks = {}
--- 刚被我们「某类型」伤害打到的单位，下一帧伤害回调里跳过对该类型施加，避免 DOT 触发的伤害再次叠 DOT
local ignoredTargetByType = {}
--- 一次 dotTickRun 内可能多次 UnitDamageTarget，ignored 被前一次 onDamage 清空后后续 DOT 仍会进 apply；本表在整轮 tick 内抑制对该目标的装备叠层
local dotTickBatchTargetHids = nil
--- 与 dotTickBatchTargetHids 同步快照，供 notify 时比对；秒跳批次数清依赖 伤害事件 延后回调而非 Timer(0)
local dotBatchSnapForClear = nil
local dotBatchDeferredRemaining = 0
local tickTimer = nil
local dotTimer = nil
--- 特效回收：每 0.2s 检查，到期 DestroyEffect；只用一个周期计时器，不创建单次计时器
local EFFECT_RECYCLE_INTERVAL = 0.2
local effectRecycleList = {}
local effectRecycleTimer = nil
local itemsData = require("系统.02．物品系统.01．装备数据").items or require("系统.02．物品系统.01．装备数据").default or ({})
--- Lua 下单位作表键时，伤害回调的 target 与选中枚举的 sole 可能不是同一 userdata；统一用 GetHandleId 作键。
local function unitHid(self, u)
    if u == nil or u == 0 then
        return 0
    end
    if type(jass.GetHandleId) ~= "function" then
        return 0
    end
    return jass.GetHandleId(u)
end
--- 该目标上本类 DOT 是否仍有未执行的秒级跳数（与 state.remaining 不同步时作兜底）
local function hasPendingDotTick(self, typeId, hid)
    do
        local i = 0
        while i < #dotTicks do
            local e = dotTicks[i + 1]
            if e.typeId == typeId and unitHid(nil, e.target) == hid and e.ticksLeft > 0 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function getDotSourceDisplayName(self, u)
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
--- 为 true 时在屏幕刷 [DOT] 诊断（tick 序号、ticksLeft、施加/跳过原因）。排查完改回 false。
____exports.DOT_DAMAGE_DEBUG = false
local dotDbgTickSeq = 0
local function dotDbg(self, msg)
    if not ____exports.DOT_DAMAGE_DEBUG then
        return
    end
    local pr = _G.print
    if type(pr) == "function" then
        pr("[DOT] " .. msg)
    end
    if type(jass.DisplayTextToPlayer) ~= "function" then
        return
    end
    do
        local pi = 0
        while pi <= 3 do
            local p = jass.Player(pi)
            if p ~= nil then
                jass.DisplayTextToPlayer(p, 0, 0, "[DOT] " .. msg)
            end
            pi = pi + 1
        end
    end
end
--- `IsUnitType` 第二参为 unittype。common.j 里 `UNIT_TYPE_STRUCTURE` 已是 unittype，不可再 `ConvertUnitType(UNIT_TYPE_STRUCTURE)`（该 native 只吃整数索引，如 64）。
local function getStructureUnitTypeHandle(self)
    local jc = jass
    local gg = g
    local ____jc_UNIT_TYPE_STRUCTURE_6 = jc.UNIT_TYPE_STRUCTURE
    if ____jc_UNIT_TYPE_STRUCTURE_6 == nil then
        ____jc_UNIT_TYPE_STRUCTURE_6 = gg.UNIT_TYPE_STRUCTURE
    end
    local direct = ____jc_UNIT_TYPE_STRUCTURE_6
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
    local ____jass_UNIT_TYPE_HERO_7 = jass.UNIT_TYPE_HERO
    if ____jass_UNIT_TYPE_HERO_7 == nil then
        ____jass_UNIT_TYPE_HERO_7 = g.UNIT_TYPE_HERO
    end
    local direct = ____jass_UNIT_TYPE_HERO_7
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
--- stateByType 槽位应为 DotState 表；若被污染为数字等则剔除，避免 cur.remaining 报错
local function isValidDotStateRow(self, v)
    return v ~= nil and type(v) == "table" and type(v.remaining) == "number" and type(v.effect) == "number"
end
local function tick(self)
    for typeId in pairs(stateByType) do
        do
            local __continue55
            repeat
                local tab = stateByType[typeId]
                if tab == nil then
                    __continue55 = true
                    break
                end
                for k in pairs(tab) do
                    do
                        local __continue57
                        repeat
                            local v = tab[k]
                            if v == nil then
                                __continue57 = true
                                break
                            end
                            if not isValidDotStateRow(nil, v) then
                                __TS__Delete(tab, k)
                                __continue57 = true
                                break
                            end
                            v.remaining = v.remaining - TICK
                            if v.remaining <= 0 then
                                local cfg = __TS__ArrayFind(
                                    dotTypes,
                                    function(____, c) return c.id == typeId end
                                )
                                if cfg ~= nil and type(cfg.onEnd) == "function" then
                                    local uref = v._dotUnitRef
                                    local ____self_9 = cfg
                                    local ____self_9_onEnd_10 = ____self_9.onEnd
                                    local ____temp_8
                                    if uref ~= nil then
                                        ____temp_8 = uref
                                    else
                                        ____temp_8 = k
                                    end
                                    ____self_9_onEnd_10(____self_9, ____temp_8, v)
                                end
                                notifyBuffPool(nil, typeId, k, nil)
                                __TS__Delete(tab, k)
                            end
                            __continue57 = true
                        until true
                        if not __continue57 then
                            break
                        end
                    end
                end
                __continue55 = true
            until true
            if not __continue55 then
                break
            end
        end
    end
    local hasAny = false
    for typeId in pairs(stateByType) do
        do
            local __continue65
            repeat
                local tab = stateByType[typeId]
                if tab == nil then
                    __continue65 = true
                    break
                end
                for _ in pairs(tab) do
                    hasAny = true
                    break
                end
                if hasAny then
                    break
                end
                __continue65 = true
            until true
            if not __continue65 then
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
local function dotTickRun(self)
    dotDbgTickSeq = dotDbgTickSeq + 1
    dotDbg(
        nil,
        (("dotTick#" .. tostring(dotDbgTickSeq)) .. " entries=") .. tostring(#dotTicks)
    )
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
            dotDbg(
                nil,
                (((((("deal " .. e.typeId) .. " hid=") .. tostring(unitHid(nil, e.target))) .. " ticksLeft=") .. tostring(e.ticksLeft)) .. " amt=") .. tostring(e.amount)
            )
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
            local ____temp_12
            if stTab ~= nil then
                local ____stTab_unitHid_result_11 = stTab[unitHid(nil, e.target)]
                if ____stTab_unitHid_result_11 == nil then
                    ____stTab_unitHid_result_11 = stTab[e.target]
                end
                ____temp_12 = ____stTab_unitHid_result_11
            else
                ____temp_12 = nil
            end
            local stateRaw = ____temp_12
            local state = isValidDotStateRow(nil, stateRaw) and stateRaw or nil
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
local function onDamage(self, target, damage, damageType)
    if not target or damage <= 0 then
        return
    end
    --- 禁止 const j=jass 再 j.GetUnitName / j.IsUnitType，TSTL 会编成 j:GetXxx 导致 bad self
    local ju = jass
    local tgtName = type(ju.GetUnitName) == "function" and tostring(jass.GetUnitName(target)) or "?"
    local tgtHidEarly = unitHid(nil, target)
    local ____temp_13
    if ju.udg_TempUnit ~= nil and ju.udg_TempUnit[6] ~= nil then
        ____temp_13 = ju.udg_TempUnit[6]
    else
        ____temp_13 = nil
    end
    local source = ____temp_13
    local srcName = source ~= nil and type(ju.GetUnitName) == "function" and tostring(jass.GetUnitName(source)) or "?"
    local srcHid = source ~= nil and unitHid(nil, source) or 0
    if ____exports.DOT_DAMAGE_DEBUG then
        dotDbg(
            nil,
            (((((((((((("hit dmg=" .. tostring(damage)) .. " dt=") .. tostring(damageType)) .. " tgt=") .. tgtName) .. "[") .. tostring(tgtHidEarly)) .. "] src=") .. srcName) .. "[") .. tostring(srcHid)) .. "] u6=") .. tostring(source ~= nil)
        )
    end
    if not source then
        dotDbg(nil, "abort: udg_TempUnit[6] nil (伤害事件未写攻击者)")
        return
    end
    local utHeroDbg = heroUnitTypeForIsUnitType(nil)
    local ____temp_14
    if type(jass.IsUnitType) == "function" and utHeroDbg ~= nil then
        ____temp_14 = jass.IsUnitType(source, utHeroDbg) == true
    else
        ____temp_14 = false
    end
    local isHeroUnit = ____temp_14
    local ____temp_15
    if type(jass.GetHeroLevel) == "function" then
        ____temp_15 = jass.GetHeroLevel(source)
    else
        ____temp_15 = -1
    end
    local heroLv = ____temp_15
    local heroGate = isSourceHeroPlayer1to4(nil, source)
    if ____exports.DOT_DAMAGE_DEBUG then
        local uj = jass.UNIT_TYPE_HERO
        local ug = g.UNIT_TYPE_HERO
        dotDbg(
            nil,
            (((((((((((("heroGate=" .. tostring(heroGate)) .. " IsUT=") .. tostring(isHeroUnit)) .. " heroLv=") .. tostring(heroLv)) .. " utJ=") .. (uj ~= nil and "yes" or "nil")) .. " utG=") .. (ug ~= nil and "yes" or "nil")) .. " fb=") .. (uj == nil and ug == nil and "yes" or "no")) .. " debuffOk=") .. tostring(isDebuffDotTargetOk(nil, source, target))
        )
    end
    if not heroGate then
        dotDbg(nil, "abort: need P1-4 hero attacker")
        return
    end
    do
        local t = 0
        while t < #dotTypes do
            do
                local __continue114
                repeat
                    local cfg = dotTypes[t + 1]
                    local typeId = cfg.id
                    local tgtHid = unitHid(nil, target)
                    if ignoredTargetByType[typeId] ~= nil and ignoredTargetByType[typeId][tgtHid] == true then
                        __TS__Delete(ignoredTargetByType[typeId], tgtHid)
                        dotDbg(
                            nil,
                            (("ignored " .. typeId) .. " hid=") .. tostring(tgtHid)
                        )
                        __continue114 = true
                        break
                    end
                    if dotTickBatchTargetHids ~= nil and dotTickBatchTargetHids[tgtHid] == true then
                        dotDbg(
                            nil,
                            (("skipApplyDotTickBatch " .. typeId) .. " hid=") .. tostring(tgtHid)
                        )
                        __continue114 = true
                        break
                    end
                    if cfg.debuffDotEnemyNoStructure == true and not isDebuffDotTargetOk(nil, source, target) then
                        dotDbg(
                            nil,
                            ((("skipDebuffTarget " .. typeId) .. " hid=") .. tostring(tgtHid)) .. " (need enemy, not structure)"
                        )
                        __continue114 = true
                        break
                    end
                    local best = cfg:getBestFromUnit(source)
                    if best == nil then
                        dotDbg(nil, ("noBest " .. typeId) .. " (装备栏无本类 Buff 段)")
                        __continue114 = true
                        break
                    end
                    local amount = cfg:computeAmount(target, best)
                    if amount <= 0 then
                        dotDbg(
                            nil,
                            (("noAmount " .. typeId) .. " amt=") .. tostring(amount)
                        )
                        __continue114 = true
                        break
                    end
                    if stateByType[typeId] == nil then
                        stateByType[typeId] = {}
                    end
                    local tab = stateByType[typeId]
                    local curRaw = tab[tgtHid]
                    local cur = isValidDotStateRow(nil, curRaw) and curRaw or nil
                    if curRaw ~= nil and cur == nil then
                        __TS__Delete(tab, tgtHid)
                        dotDbg(
                            nil,
                            (("dropCorruptState " .. typeId) .. " hid=") .. tostring(tgtHid)
                        )
                    end
                    --- 同解析持续 + 每跳强度接近 + 效果尚未结束：不因后续伤害事件再叠一层「满 time」。
                    -- 反恢复等会有浮点抖动，eps 过严会失败；若仅用 amount×满持续 与 effect×剩余 比乘积，剩余变短时必「假更强」而刷新，总时长会超过 timeN（如一次普攻打出 5 秒跳）。
                    local durNear = cur ~= nil and cur._dotParsedDuration ~= nil and math.abs(best.duration - cur._dotParsedDuration) < 0.05
                    local amtNear = cur ~= nil and math.abs(amount - cur.effect) < 1
                    if cur ~= nil and durNear and amtNear and cur.remaining > 0.01 then
                        dotDbg(
                            nil,
                            (((("skipSameBuffActive " .. typeId) .. " hid=") .. tostring(tgtHid)) .. " rem=") .. __TS__NumberToFixed(cur.remaining, 2)
                        )
                        __continue114 = true
                        break
                    end
                    if cur ~= nil and durNear and amtNear and hasPendingDotTick(nil, typeId, tgtHid) then
                        dotDbg(
                            nil,
                            (("skipWhileTicksPending " .. typeId) .. " hid=") .. tostring(tgtHid)
                        )
                        __continue114 = true
                        break
                    end
                    local currentProduct = cur ~= nil and cur.effect * cur.remaining or 0
                    local newProduct = amount * best.duration
                    if newProduct <= currentProduct then
                        dotDbg(
                            nil,
                            (((((("skipWeak " .. typeId) .. " hid=") .. tostring(tgtHid)) .. " newP=") .. tostring(newProduct)) .. " curP=") .. tostring(currentProduct)
                        )
                        __continue114 = true
                        break
                    end
                    if cur ~= nil and type(cfg.onEnd) == "function" then
                        cfg:onEnd(target, cur)
                    end
                    dotDbg(
                        nil,
                        (((((((("apply " .. typeId) .. " hid=") .. tostring(tgtHid)) .. " dur=") .. tostring(best.duration)) .. " amt=") .. tostring(amount)) .. " ticks=") .. tostring(best.duration)
                    )
                    local state = {
                        effect = amount,
                        remaining = best.duration,
                        _dotUnitRef = target,
                        sourceName = getDotSourceDisplayName(nil, source),
                        _dotParsedDuration = best.duration
                    }
                    tab[tgtHid] = state
                    notifyBuffPool(nil, typeId, target, state)
                    if type(cfg.onApply) == "function" then
                        cfg:onApply(target, state)
                    end
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
                    __continue114 = true
                until true
                if not __continue114 then
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
                local __continue155
                repeat
                    local item = unitItemInSlot(nil, unit, slot)
                    if not item then
                        __continue155 = true
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
                                local __continue158
                                repeat
                                    local parsed = parseAntiHealBuff(nil, segments[si + 1])
                                    if not parsed then
                                        __continue158 = true
                                        break
                                    end
                                    local product = parsed.effectPct * parsed.duration
                                    if best == nil or product > best.product then
                                        best = {effectPct = parsed.effectPct, duration = parsed.duration, product = product}
                                    end
                                    __continue158 = true
                                until true
                                if not __continue158 then
                                    break
                                end
                            end
                            si = si + 1
                        end
                    end
                    __continue155 = true
                until true
                if not __continue155 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return best ~= nil and ({effectPct = best.effectPct, duration = best.duration}) or nil
end
local function parseBurnBuff(self, buffStr)
    if not buffStr or type(buffStr) ~= "string" then
        return nil
    end
    local s = __TS__StringTrim(buffStr)
    if (string.find(s, "Buff:dmg:", nil, true) or 0) - 1 ~= 0 then
        return nil
    end
    local rest = __TS__StringSubstring(s, 9)
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
    return {damagePerSec = damagePerSec, duration = duration}
end
local function getBestBurnFromUnit(self, unit)
    local best = nil
    do
        local slot = 0
        while slot <= 5 do
            do
                local __continue175
                repeat
                    local item = unitItemInSlot(nil, unit, slot)
                    if not item then
                        __continue175 = true
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
                                local __continue178
                                repeat
                                    local parsed = parseBurnBuff(nil, segments[si + 1])
                                    if not parsed then
                                        __continue178 = true
                                        break
                                    end
                                    local product = parsed.damagePerSec * parsed.duration
                                    if best == nil or product > best.product then
                                        best = {damagePerSec = parsed.damagePerSec, duration = parsed.duration, product = product}
                                    end
                                    __continue178 = true
                                until true
                                if not __continue178 then
                                    break
                                end
                            end
                            si = si + 1
                        end
                    end
                    __continue175 = true
                until true
                if not __continue175 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return best ~= nil and ({damagePerSec = best.damagePerSec, duration = best.duration}) or nil
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
        effectModel = "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl",
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
        effectModel = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",
        effectDuration = 0.75
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
    if tab == nil or unit == nil or unit == 0 then
        return nil
    end
    local h = unitHid(nil, unit)
    if h ~= 0 and tab[h] ~= nil then
        return isValidDotStateRow(nil, tab[h]) and tab[h] or nil
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
    if h ~= 0 and tab[h] ~= nil then
        return isValidDotStateRow(nil, tab[h]) and tab[h] or nil
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
