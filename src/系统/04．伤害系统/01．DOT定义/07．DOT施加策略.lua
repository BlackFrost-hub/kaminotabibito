local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____04_FF0EDOT_5DE5_5177 = require("系统.04．伤害系统.01．DOT定义.04．DOT工具")
local clearIgnoredTarget = ____04_FF0EDOT_5DE5_5177.clearIgnoredTarget
local getDotState = ____04_FF0EDOT_5DE5_5177.getDotState
local isIgnoredTarget = ____04_FF0EDOT_5DE5_5177.isIgnoredTarget
local setDotState = ____04_FF0EDOT_5DE5_5177.setDotState
function ____exports.createDotApplyStrategy(self, deps)
    local dotTypes = deps.dotTypes
    local dotTicks = deps.dotTicks
    local unitHid = deps.unitHid
    local isSourceHeroPlayer1to4 = deps.isSourceHeroPlayer1to4
    local isDebuffDotTargetOk = deps.isDebuffDotTargetOk
    local getDotSourceDisplayName = deps.getDotSourceDisplayName
    local notifyBuffPool = deps.notifyBuffPool
    local ensureDotTimers = deps.ensureDotTimers
    local getDotTickBatchTargetHids = deps.getDotTickBatchTargetHids
    local DURATION_TIER_EPS = 0.05
    local function abs(self, value)
        return value < 0 and -value or value
    end
    local function sameDurationTier(self, cur, bestDuration)
        return cur._dotParsedDuration ~= nil and abs(nil, bestDuration - cur._dotParsedDuration) < DURATION_TIER_EPS
    end
    local function pushDotTickForTarget(self, typeId, source, target, tgtHid, amount, _duration, cfg)
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
    local function fillDotStateRow(self, cur, target, source, amount, bestDuration)
        cur.effect = amount
        cur.remaining = bestDuration
        cur._dotParsedDuration = bestDuration
        cur._dotUnitRef = target
        cur.sourceName = getDotSourceDisplayName(nil, source)
    end
    local function applyEquipmentDotOnHeroAttack(self, typeId, cfg, tgtHid, target, source, amount, bestDuration, cur)
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
            setDotState(nil, typeId, tgtHid, cur)
        else
            local state = {
                effect = amount,
                remaining = bestDuration,
                _dotUnitRef = target,
                sourceName = getDotSourceDisplayName(nil, source),
                _dotParsedDuration = bestDuration
            }
            setDotState(nil, typeId, tgtHid, state)
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
    local function applyEquipmentDotOnNonAttack(self, typeId, cfg, tgtHid, target, source, amount, bestDuration, cur)
        if cur == nil then
            local state = {
                effect = amount,
                remaining = bestDuration,
                _dotUnitRef = target,
                sourceName = getDotSourceDisplayName(nil, source),
                _dotParsedDuration = bestDuration
            }
            setDotState(nil, typeId, tgtHid, state)
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
            setDotState(nil, typeId, tgtHid, cur)
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
        setDotState(nil, typeId, tgtHid, state)
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
    local function tryApplyHeroAttackGearDots(self, source, target, _damage)
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
                    local cfg = dotTypes[t + 1]
                    local typeId = cfg.id
                    if cfg.debuffDotEnemyNoStructure == true and not isDebuffDotTargetOk(nil, source, target) then
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
                    local cur = getDotState(nil, typeId, tgtHid)
                    applyEquipmentDotOnHeroAttack(
                        nil,
                        typeId,
                        cfg,
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
        if not isSourceHeroPlayer1to4(nil, source) then
            return
        end
        local tgtHid = unitHid(nil, target)
        local dotTickBatchTargetHids = getDotTickBatchTargetHids(nil)
        local suppressDotApplyForBatch = fromDotTickBatch == true and dotTickBatchTargetHids ~= nil and dotTickBatchTargetHids[tgtHid] == true and not isAttackHitForDot
        do
            local t = 0
            while t < #dotTypes do
                do
                    local cfg = dotTypes[t + 1]
                    local typeId = cfg.id
                    if isIgnoredTarget(nil, typeId, tgtHid) then
                        clearIgnoredTarget(nil, typeId, tgtHid)
                        goto __continue35
                    end
                    if suppressDotApplyForBatch then
                        goto __continue35
                    end
                    if isAttackHitForDot then
                        goto __continue35
                    end
                    if cfg.debuffDotEnemyNoStructure == true and not isDebuffDotTargetOk(nil, source, target) then
                        goto __continue35
                    end
                    local best = cfg:getBestFromUnit(source)
                    if best == nil then
                        goto __continue35
                    end
                    if best.attackOnly == true or cfg.attackOnlyTrigger == true then
                        if not isAttackHitForDot then
                            goto __continue35
                        end
                    end
                    local amount = cfg:computeAmount(target, best)
                    if amount <= 0 then
                        goto __continue35
                    end
                    local cur = getDotState(nil, typeId, tgtHid)
                    if isAttackHitForDot then
                        applyEquipmentDotOnHeroAttack(
                            nil,
                            typeId,
                            cfg,
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
                            tgtHid,
                            target,
                            source,
                            amount,
                            best.duration,
                            cur
                        )
                    end
                end
                ::__continue35::
                t = t + 1
            end
        end
    end
    return {tryApplyHeroAttackGearDots = tryApplyHeroAttackGearDots, onDamage = onDamage}
end
return ____exports
