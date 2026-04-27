local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
function ____exports.createDotApplyStrategy(self, deps)
    local DURATION_TIER_EPS = 0.05
    local function abs(self, value)
        return value < 0 and -value or value
    end
    local function sameDurationTier(self, cur, bestDuration)
        return cur._dotParsedDuration ~= nil and abs(nil, bestDuration - cur._dotParsedDuration) < DURATION_TIER_EPS
    end
    local function pushDotTickForTarget(self, typeId, source, target, tgtHid, amount, _duration, cfg)
        do
            local i = #deps.dotTicks - 1
            while i >= 0 do
                local e = deps.dotTicks[i + 1]
                if e.typeId == typeId and deps:unitHid(e.target) == tgtHid then
                    __TS__ArraySplice(deps.dotTicks, i, 1)
                end
                i = i - 1
            end
        end
        local ____deps_dotTicks_0 = deps.dotTicks
        ____deps_dotTicks_0[#____deps_dotTicks_0 + 1] = {
            typeId = typeId,
            source = source,
            target = target,
            amount = amount,
            effectModel = cfg.effectModel,
            effectDuration = cfg.effectDuration
        }
    end
    local function fillDotStateRow(self, cur, target, source, amount, bestDuration)
        cur.effect = amount
        cur.remaining = bestDuration
        cur._dotParsedDuration = bestDuration
        cur._dotUnitRef = target
        cur.sourceName = deps:getDotSourceDisplayName(source)
    end
    local function applyEquipmentDotOnHeroAttack(self, typeId, cfg, tab, tgtHid, target, source, amount, bestDuration, cur)
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
            deps:notifyBuffPool(typeId, target, cur)
        else
            local state = {
                effect = amount,
                remaining = bestDuration,
                _dotUnitRef = target,
                sourceName = deps:getDotSourceDisplayName(source),
                _dotParsedDuration = bestDuration
            }
            deps:tabSetHid(tab, tgtHid, state)
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
            deps:notifyBuffPool(typeId, target, state)
            if type(cfg.onApply) == "function" then
                cfg:onApply(target, state)
            end
        end
        deps:ensureDotTimers()
    end
    local function applyEquipmentDotOnNonAttack(self, typeId, cfg, tab, tgtHid, target, source, amount, bestDuration, cur)
        if cur == nil then
            local state = {
                effect = amount,
                remaining = bestDuration,
                _dotUnitRef = target,
                sourceName = deps:getDotSourceDisplayName(source),
                _dotParsedDuration = bestDuration
            }
            deps:tabSetHid(tab, tgtHid, state)
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
            deps:notifyBuffPool(typeId, target, state)
            if type(cfg.onApply) == "function" then
                cfg:onApply(target, state)
            end
            deps:ensureDotTimers()
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
            deps:notifyBuffPool(typeId, target, cur)
            deps:ensureDotTimers()
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
            sourceName = deps:getDotSourceDisplayName(source),
            _dotParsedDuration = bestDuration
        }
        deps:tabSetHid(tab, tgtHid, state)
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
        deps:notifyBuffPool(typeId, target, state)
        if type(cfg.onApply) == "function" then
            cfg:onApply(target, state)
        end
        deps:ensureDotTimers()
    end
    local function tryApplyHeroAttackGearDots(self, source, target, _damage)
        if not target or not source then
            return
        end
        if not deps:isSourceHeroPlayer1to4(source) then
            return
        end
        local tgtHid = deps:unitHid(target)
        do
            local t = 0
            while t < #deps.dotTypes do
                do
                    local cfg = deps.dotTypes[t + 1]
                    local typeId = cfg.id
                    if cfg.debuffDotEnemyNoStructure == true and not deps:isDebuffDotTargetOk(source, target) then
                        goto __continue25
                    end
                    local best = cfg:getBestFromUnit(source)
                    if best == nil then
                        goto __continue25
                    end
                    local amount = cfg:computeAmount(target, best)
                    if amount <= 0 then
                        goto __continue25
                    end
                    if deps.stateByType[typeId] == nil then
                        deps.stateByType[typeId] = {}
                    end
                    local tab = deps.stateByType[typeId]
                    local curRaw = deps:tabRowForHid(tab, tgtHid)
                    local cur = deps:isValidDotStateRow(curRaw) and curRaw or nil
                    if curRaw ~= nil and cur == nil then
                        deps:tabDeleteHid(tab, tgtHid)
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
                end
                ::__continue25::
                t = t + 1
            end
        end
    end
    local function onDamage(self, target, damage, _damageType, fromDotTickBatch, source, isNormalAttackHit)
        if not target then
            return
        end
        local isAttackHitForDot = isNormalAttackHit == true
        if damage <= 0 and not isAttackHitForDot then
            return
        end
        if not source then
            return
        end
        if not deps:isSourceHeroPlayer1to4(source) then
            return
        end
        local tgtHid = deps:unitHid(target)
        local dotTickBatchTargetHids = deps:getDotTickBatchTargetHids()
        local suppressDotApplyForBatch = fromDotTickBatch == true and dotTickBatchTargetHids ~= nil and dotTickBatchTargetHids[tgtHid] == true and not isAttackHitForDot
        do
            local t = 0
            while t < #deps.dotTypes do
                do
                    local cfg = deps.dotTypes[t + 1]
                    local typeId = cfg.id
                    if deps.ignoredTargetByType[typeId] ~= nil and deps.ignoredTargetByType[typeId][tgtHid] == true then
                        __TS__Delete(deps.ignoredTargetByType[typeId], tgtHid)
                        goto __continue37
                    end
                    if suppressDotApplyForBatch then
                        goto __continue37
                    end
                    if isAttackHitForDot then
                        goto __continue37
                    end
                    if cfg.debuffDotEnemyNoStructure == true and not deps:isDebuffDotTargetOk(source, target) then
                        goto __continue37
                    end
                    local best = cfg:getBestFromUnit(source)
                    if best == nil then
                        goto __continue37
                    end
                    if best.attackOnly == true or cfg.attackOnlyTrigger == true then
                        if not isAttackHitForDot then
                            goto __continue37
                        end
                    end
                    local amount = cfg:computeAmount(target, best)
                    if amount <= 0 then
                        goto __continue37
                    end
                    if deps.stateByType[typeId] == nil then
                        deps.stateByType[typeId] = {}
                    end
                    local tab = deps.stateByType[typeId]
                    local curRaw = deps:tabRowForHid(tab, tgtHid)
                    local cur = deps:isValidDotStateRow(curRaw) and curRaw or nil
                    if curRaw ~= nil and cur == nil then
                        deps:tabDeleteHid(tab, tgtHid)
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
                end
                ::__continue37::
                t = t + 1
            end
        end
    end
    return {tryApplyHeroAttackGearDots = tryApplyHeroAttackGearDots, onDamage = onDamage}
end
return ____exports
