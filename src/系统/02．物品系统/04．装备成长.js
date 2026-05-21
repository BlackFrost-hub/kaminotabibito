/** @noSelfInFile */
/**
 * 装备成长：单位使用物品时，若装备数据有 PowerUP 字段，执行属性成长。
 * 格式：  段1+段2+...，段内用 ; 分隔效果；time>0 表示临时（N秒后撤销），time0/无time=永久
 * 效果类型：Nstat / N%stat / Nexp / Nlevel / (level*N)stat / (level*N)exp
 * 规则详见 `.cursor/rules/equipment/heal-hot-format.md`
 */
const jass = require("jass.common");
const GetItemTypeId = jass.GetItemTypeId;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
const { round } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { onItemUse } = require("系统.00．核心系统.01．事件中心.04．物品事件中心");
const g = require("jass.globals");
const { AddGoldWithFeedback, fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { IsUnitIllusionBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展");
const itemRelatedFns = require("lib.扩展函数.物品相关函数.index");
const { applyEquipStatsTS } = require("lib.扩展函数.Star扩展函数.01．装备属性应用");
const { onSecond, offSecond } = globalThis;
function parsePowerUP(powerUpStr) {
    const segments = [];
    const rawSegs = powerUpStr.split("+");
    for (let si = 0; si < rawSegs.length; si++) {
        const rawSeg = rawSegs[si].trim();
        if (rawSeg === "")
            continue;
        const tokens = rawSeg.split(";").map((x) => x.trim()).filter((x) => x !== "");
        let timeSec = 0;
        const effectTokens = [];
        for (const t of tokens) {
            const tl = t.toLowerCase();
            if (tl.indexOf("time") === 0) {
                const w = parseFloat(t.substring(4)) || 0;
                if (w > timeSec)
                    timeSec = w;
            }
            else {
                effectTokens.push(t);
            }
        }
        const effects = [];
        for (const t of effectTokens) {
            // gold 特判：支持 "500gold" / "500-7500gold" / "10%gold"
            const tl0 = t.toLowerCase();
            if (tl0.endsWith("gold")) {
                // 百分比：10%gold
                if (tl0.indexOf("%gold") >= 0) {
                    const pctStr = t.substring(0, tl0.indexOf("%")).trim();
                    const pctNum = parseFloat(pctStr) || 0;
                    effects.push({ type: "gold", isPct: true, value: pctNum / 100, isLevelMult: false });
                    continue;
                }
                // 固定/范围：500gold / 500-7500gold
                const core = t.substring(0, t.length - 4).trim(); // 去掉 gold
                const dash = core.indexOf("-");
                if (dash >= 0) {
                    const a = parseFloat(core.substring(0, dash).trim()) || 0;
                    const b = parseFloat(core.substring(dash + 1).trim()) || 0;
                    const mn = a < b ? a : b;
                    const mx = a < b ? b : a;
                    effects.push({ type: "gold", isPct: false, value: 0, isLevelMult: false, min: mn, max: mx });
                }
                else {
                    const v = parseFloat(core) || 0;
                    effects.push({ type: "gold", isPct: false, value: 0, isLevelMult: false, min: v, max: v });
                }
                continue;
            }
            // (level*N)key 语法
            if (t.indexOf("(level*") === 0) {
                const closeIdx = t.indexOf(")");
                if (closeIdx < 0)
                    continue;
                const mult = parseFloat(t.substring(7, closeIdx)) || 0;
                const rawKey = t.substring(closeIdx + 1).trim();
                const kl = rawKey.toLowerCase();
                if (kl === "exp") {
                    effects.push({ type: "exp", isPct: false, value: mult, isLevelMult: true });
                }
                else if (kl === "level") {
                    effects.push({ type: "level", isPct: false, value: mult, isLevelMult: true });
                }
                else {
                    const ak = itemRelatedFns.findStatKey(rawKey);
                    if (ak !== "")
                        effects.push({ type: "stat", key: ak, isPct: false, value: mult, isLevelMult: true });
                }
                continue;
            }
            // N%key 或 Nkey
            const pctIdx = t.indexOf("%");
            const isPct = pctIdx >= 0;
            const cleaned = isPct ? t.substring(0, pctIdx) + t.substring(pctIdx + 1) : t;
            // 找数字结束位置
            let numEnd = 0;
            while (numEnd < cleaned.length) {
                const ch = cleaned.substring(numEnd, numEnd + 1);
                if ((ch >= "0" && ch <= "9") || ch === "." || (numEnd === 0 && ch === "-")) {
                    numEnd++;
                }
                else {
                    break;
                }
            }
            const num = parseFloat(cleaned.substring(0, numEnd)) || 0;
            const rawKey = cleaned.substring(numEnd).trim();
            const kl = rawKey.toLowerCase();
            if (kl === "exp") {
                effects.push({ type: "exp", isPct: false, value: num, isLevelMult: false });
            }
            else if (kl === "level") {
                effects.push({ type: "level", isPct: false, value: num, isLevelMult: false });
            }
            else if (kl === "gold") {
                // 兼容旧写法：N%gold 走百分比；Ngold 走固定（但不支持范围，这里只当固定）
                if (isPct)
                    effects.push({ type: "gold", isPct: true, value: num / 100, isLevelMult: false });
                else
                    effects.push({ type: "gold", isPct: false, value: 0, isLevelMult: false, min: num, max: num });
            }
            else {
                const ak = itemRelatedFns.findStatKey(rawKey);
                if (ak !== "")
                    effects.push({ type: "stat", key: ak, isPct, value: isPct ? num / 100 : num, isLevelMult: false });
            }
        }
        if (effects.length > 0)
            segments.push({ effects, timeSec });
    }
    return segments;
}
/** 通过 TS 装备属性应用器批量加/减属性 */
function applyStats(unit, statEffects, isAdd) {
    if (statEffects.length === 0)
        return;
    const payload = isAdd
        ? statEffects
        : statEffects.map((x) => ({ ...x, value: -x.value }));
    applyEquipStatsTS(unit, payload);
}
/** 分 10 份给经验，避免跳级触发不到 */
function addHeroXP(unit, amount) {
    if (amount <= 0)
        return;
    const chunk = jass.R2I(amount / 10);
    for (let i = 0; i < 10; i++) {
        jass.AddHeroXP(unit, chunk, true);
    }
    const remainder = amount - chunk * 10;
    if (remainder > 0) {
        jass.AddHeroXP(unit, remainder, true);
    }
}
function getHeroLevel(unit) {
    return jass.GetHeroLevel(unit);
}
/**
 * 获取单位当前属性的绝对值，用于百分比计算。
 * str/agi/int 用 GetHeroStr/Agi/Int；hp/mp 用 GetUnitState+ConvertUnitState；
 * dmg=ConvertUnitState(0x15)，armor=ConvertUnitState(0x20)（需要 japi）
 */
function getPctStatValue(unit, key) {
    if (key === "int")
        return jass.GetHeroInt(unit, true);
    if (key === "str")
        return jass.GetHeroStr(unit, true);
    if (key === "agi")
        return jass.GetHeroAgi(unit, true);
    if (key === "hp")
        return jass.GetUnitState(unit, jass.ConvertUnitState(1));
    if (key === "mp")
        return jass.GetUnitState(unit, jass.ConvertUnitState(3));
    if (key === "dmg")
        return jass.GetUnitState(unit, jass.ConvertUnitState(0x15));
    if (key === "armor")
        return jass.GetUnitState(unit, jass.ConvertUnitState(0x20));
    return 0;
}
/** 对 unit 所属玩家的金币做一次百分比加减（pct 可负） */
function applyGoldPct(unit, pct) {
    const player = jass.GetOwningPlayer(unit);
    if (!player)
        return;
    const stateGold = jass.ConvertPlayerState(1);
    const cur = jass.GetPlayerState(player, stateGold);
    const delta = round(cur * pct);
    const newVal = cur + delta < 0 ? 0 : cur + delta;
    jass.SetPlayerState(player, stateGold, newVal);
}
function executeSegment(unit, seg) {
    const statEffects = [];
    let goldPct = 0;
    const goldFixed = [];
    for (const eff of seg.effects) {
        if (eff.type === "gold") {
            if (eff.isPct)
                goldPct += eff.value;
            else {
                const mn = typeof eff.min === "number" ? eff.min : 0;
                const mx = typeof eff.max === "number" ? eff.max : mn;
                goldFixed.push({ min: mn, max: mx });
            }
        }
        else if (eff.type === "exp") {
            const amount = eff.isLevelMult
                ? jass.R2I(getHeroLevel(unit) * eff.value)
                : jass.R2I(eff.value);
            addHeroXP(unit, amount);
        }
        else if (eff.type === "level") {
            const cur = getHeroLevel(unit);
            const add = eff.isLevelMult ? jass.R2I(cur * eff.value) : jass.R2I(eff.value);
            if (add > 0) {
                jass.SetHeroLevel(unit, cur + add, true);
            }
        }
        else if (eff.type === "stat" && eff.key !== undefined && eff.key !== "") {
            const name = itemRelatedFns.KEY_TO_NAME[eff.key];
            if (name === undefined)
                continue;
            let val;
            if (eff.isPct) {
                val = getPctStatValue(unit, eff.key) * eff.value;
            }
            else if (eff.isLevelMult) {
                val = getHeroLevel(unit) * eff.value;
            }
            else {
                val = eff.value;
            }
            statEffects.push({ name, key: eff.key, value: val });
        }
    }
    // 处理金币百分比效果（每秒一次，持续 timeSec 秒；无 time 则只触发一次）
    // 使用中心计时器的 onSecond：省 timer handle，死亡/到期自动 offSecond 解绑
    if (goldPct !== 0) {
        if (seg.timeSec <= 0) {
            applyGoldPct(unit, goldPct);
        }
        else {
            const capturedUnit = unit;
            const capturedPct = goldPct;
            let remaining = jass.R2I(seg.timeSec);
            const cb = () => {
                if (capturedUnit && jass.IsUnitType(capturedUnit, jass.UNIT_TYPE_DEAD)) {
                    offSecond(cb);
                    return;
                }
                applyGoldPct(capturedUnit, capturedPct);
                remaining -= 1;
                if (remaining <= 0) {
                    offSecond(cb);
                }
            };
            onSecond(cb);
        }
    }
    // 固定/范围金币：使用封装函数（单位：漂浮字 + 1500 范围音效）
    if (goldFixed.length > 0) {
        for (let i = 0; i < goldFixed.length; i++) {
            const mn = jass.R2I(goldFixed[i].min);
            const mx = jass.R2I(goldFixed[i].max);
            let delta = mn;
            if (mx !== mn) {
                const a = mn < mx ? mn : mx;
                const b = mn < mx ? mx : mn;
                delta = jass.GetRandomInt(a, b);
            }
            if (delta !== 0)
                AddGoldWithFeedback({ delta, unit });
        }
    }
    if (statEffects.length > 0) {
        applyStats(unit, statEffects, true);
        // 临时效果：timer 到期后撤销
        if (seg.timeSec > 0) {
            const capturedStats = statEffects;
            const capturedUnit = unit;
            const dt = jass.CreateTimer();
            if (dt) {
                const t = dt;
                equipStatReverseByTimerHid[jass.GetHandleId(t)] = { unit: capturedUnit, stats: capturedStats };
                safeTimerStart(t, seg.timeSec, false, onEquipStatReverseTimerExpire);
            }
        }
    }
}
function onUseItem() {
    const unit = jass.GetManipulatingUnit();
    const item = jass.GetManipulatedItem();
    if (!unit || !item)
        return;
    if (jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED))
        return;
    if (IsUnitIllusionBJ(unit))
        return;
    const entry = itemRelatedFns.getItemDataEntry(item);
    if (!entry || !entry.PowerUP)
        return;
    const glob = globalThis;
    const idStr = fourCCToString(GetItemTypeId(item));
    const key = "__EquipPowerUP_" + tostring(unit) + "_" + idStr;
    if (glob[key])
        return;
    glob[key] = true;
    const ct = jass.CreateTimer();
    if (ct) {
        const t = ct;
        equipDebounceKeyByTimerHid[jass.GetHandleId(t)] = key;
        safeTimerStart(t, 0.5, false, onEquipDebounceTimerExpire);
    }
    const segments = parsePowerUP(entry.PowerUP);
    for (const seg of segments) {
        executeSegment(unit, seg);
    }
}
const INIT_KEY = "__EquipPowerUPInited";
const equipStatReverseByTimerHid = {};
function onEquipStatReverseTimerExpire() {
    const t = jass.GetExpiredTimer();
    if (!t)
        return;
    const hid = jass.GetHandleId(t);
    const ctx = equipStatReverseByTimerHid[hid];
    delete equipStatReverseByTimerHid[hid];
    if (ctx !== undefined) {
        applyStats(ctx.unit, ctx.stats, false);
    }
    safeDestroyTimer(t);
}
const equipDebounceKeyByTimerHid = {};
function onEquipDebounceTimerExpire() {
    const t = jass.GetExpiredTimer();
    if (!t)
        return;
    const hid = jass.GetHandleId(t);
    const key = equipDebounceKeyByTimerHid[hid];
    delete equipDebounceKeyByTimerHid[hid];
    if (key !== undefined) {
        globalThis[key] = undefined;
    }
    safeDestroyTimer(t);
}
function init() {
    if (g[INIT_KEY])
        return;
    g[INIT_KEY] = true;
    // 使用物品事件中心注册，减少触发器数量
    onItemUse((unit, item) => {
        onUseItem();
    });
}
init();
export {};
