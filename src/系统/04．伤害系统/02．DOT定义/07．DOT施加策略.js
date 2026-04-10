// ========== 虚拟分区：策略工厂 ==========
export function createDotApplyStrategy(deps) {
    // ========== 虚拟分区：常量 ==========
    const DURATION_TIER_EPS = 0.05;
    // ========== 虚拟分区：工具函数 ==========
    function sameDurationTier(cur, bestDuration) {
        return cur._dotParsedDuration != null && Math.abs(bestDuration - cur._dotParsedDuration) < DURATION_TIER_EPS;
    }
    // ========== 虚拟分区：tick 记录 ==========
    function pushDotTickForTarget(typeId, source, target, tgtHid, amount, _duration, cfg) {
        for (let i = deps.dotTicks.length - 1; i >= 0; i--) {
            const e = deps.dotTicks[i];
            if (e.typeId === typeId && deps.unitHid(e.target) === tgtHid)
                deps.dotTicks.splice(i, 1);
        }
        deps.dotTicks.push({
            typeId,
            source,
            target,
            amount,
            effectModel: cfg.effectModel,
            effectDuration: cfg.effectDuration,
        });
    }
    // ========== 虚拟分区：状态填充 ==========
    function fillDotStateRow(cur, target, source, amount, bestDuration) {
        cur.effect = amount;
        cur.remaining = bestDuration;
        cur._dotParsedDuration = bestDuration;
        cur._dotUnitRef = target;
        cur.sourceName = deps.getDotSourceDisplayName(source);
    }
    // ========== 虚拟分区：普攻施加策略 ==========
    function applyEquipmentDotOnHeroAttack(typeId, cfg, tab, tgtHid, target, source, amount, bestDuration, cur) {
        if (cur != null) {
            fillDotStateRow(cur, target, source, amount, bestDuration);
            pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
            deps.notifyBuffPool(typeId, target, cur);
        }
        else {
            const state = {
                effect: amount,
                remaining: bestDuration,
                _dotUnitRef: target,
                sourceName: deps.getDotSourceDisplayName(source),
                _dotParsedDuration: bestDuration,
            };
            deps.tabSetHid(tab, tgtHid, state);
            pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
            deps.notifyBuffPool(typeId, target, state);
            if (typeof cfg.onApply === "function")
                cfg.onApply(target, state);
        }
        deps.ensureDotTimers();
    }
    // ========== 虚拟分区：非普攻施加策略 ==========
    function applyEquipmentDotOnNonAttack(typeId, cfg, tab, tgtHid, target, source, amount, bestDuration, cur) {
        if (cur == null) {
            const state = {
                effect: amount,
                remaining: bestDuration,
                _dotUnitRef: target,
                sourceName: deps.getDotSourceDisplayName(source),
                _dotParsedDuration: bestDuration,
            };
            deps.tabSetHid(tab, tgtHid, state);
            pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
            deps.notifyBuffPool(typeId, target, state);
            if (typeof cfg.onApply === "function")
                cfg.onApply(target, state);
            deps.ensureDotTimers();
            return;
        }
        if (sameDurationTier(cur, bestDuration)) {
            fillDotStateRow(cur, target, source, amount, bestDuration);
            pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
            deps.notifyBuffPool(typeId, target, cur);
            deps.ensureDotTimers();
            return;
        }
        const currentProduct = cur.effect * cur.remaining;
        const newProduct = amount * bestDuration;
        if (newProduct <= currentProduct)
            return;
        if (typeof cfg.onEnd === "function")
            cfg.onEnd(target, cur);
        const state = {
            effect: amount,
            remaining: bestDuration,
            _dotUnitRef: target,
            sourceName: deps.getDotSourceDisplayName(source),
            _dotParsedDuration: bestDuration,
        };
        deps.tabSetHid(tab, tgtHid, state);
        pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
        deps.notifyBuffPool(typeId, target, state);
        if (typeof cfg.onApply === "function")
            cfg.onApply(target, state);
        deps.ensureDotTimers();
    }
    // ========== 虚拟分区：普攻装备入口 ==========
    function tryApplyHeroAttackGearDots(source, target, _damage) {
        if (!target || !source)
            return;
        if (!deps.isSourceHeroPlayer1to4(source))
            return;
        const tgtHid = deps.unitHid(target);
        for (let t = 0; t < deps.dotTypes.length; t++) {
            const cfg = deps.dotTypes[t];
            const typeId = cfg.id;
            if (cfg.debuffDotEnemyNoStructure === true && !deps.isDebuffDotTargetOk(source, target))
                continue;
            const best = cfg.getBestFromUnit(source);
            if (best == null)
                continue;
            const amount = cfg.computeAmount(target, best);
            if (amount <= 0)
                continue;
            if (deps.stateByType[typeId] == null)
                deps.stateByType[typeId] = {};
            const tab = deps.stateByType[typeId];
            const curRaw = deps.tabRowForHid(tab, tgtHid);
            let cur = deps.isValidDotStateRow(curRaw) ? curRaw : null;
            if (curRaw != null && cur == null)
                deps.tabDeleteHid(tab, tgtHid);
            applyEquipmentDotOnHeroAttack(typeId, cfg, tab, tgtHid, target, source, amount, best.duration, cur);
        }
    }
    // ========== 虚拟分区：伤害回调入口 ==========
    function onDamage(target, damage, _damageType, fromDotTickBatch, source, isNormalAttackHit) {
        if (!target)
            return;
        const isAttackHitForDot = isNormalAttackHit === true;
        if (damage <= 0 && !isAttackHitForDot)
            return;
        if (!source)
            return;
        if (!deps.isSourceHeroPlayer1to4(source))
            return;
        const tgtHid = deps.unitHid(target);
        const dotTickBatchTargetHids = deps.getDotTickBatchTargetHids();
        const suppressDotApplyForBatch = fromDotTickBatch === true && dotTickBatchTargetHids != null && dotTickBatchTargetHids[tgtHid] === true && !isAttackHitForDot;
        for (let t = 0; t < deps.dotTypes.length; t++) {
            const cfg = deps.dotTypes[t];
            const typeId = cfg.id;
            if (deps.ignoredTargetByType[typeId] != null && deps.ignoredTargetByType[typeId][tgtHid] === true) {
                delete deps.ignoredTargetByType[typeId][tgtHid];
                continue;
            }
            if (suppressDotApplyForBatch)
                continue;
            if (isAttackHitForDot)
                continue;
            if (cfg.debuffDotEnemyNoStructure === true && !deps.isDebuffDotTargetOk(source, target))
                continue;
            const best = cfg.getBestFromUnit(source);
            if (best == null)
                continue;
            if (best.attackOnly === true || cfg.attackOnlyTrigger === true) {
                if (!isAttackHitForDot)
                    continue;
            }
            const amount = cfg.computeAmount(target, best);
            if (amount <= 0)
                continue;
            if (deps.stateByType[typeId] == null)
                deps.stateByType[typeId] = {};
            const tab = deps.stateByType[typeId];
            const curRaw = deps.tabRowForHid(tab, tgtHid);
            let cur = deps.isValidDotStateRow(curRaw) ? curRaw : null;
            if (curRaw != null && cur == null)
                deps.tabDeleteHid(tab, tgtHid);
            if (isAttackHitForDot) {
                applyEquipmentDotOnHeroAttack(typeId, cfg, tab, tgtHid, target, source, amount, best.duration, cur);
            }
            else {
                applyEquipmentDotOnNonAttack(typeId, cfg, tab, tgtHid, target, source, amount, best.duration, cur);
            }
        }
    }
    // ========== 虚拟分区：对外导出 ==========
    return {
        tryApplyHeroAttackGearDots,
        onDamage,
    };
}
