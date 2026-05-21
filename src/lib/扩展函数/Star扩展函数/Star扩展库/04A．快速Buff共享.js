/** @noSelfInFile */
/**
 * Star扩展库 - 快速Buff系统共享层
 *
 * 放这里的内容：
 * - 共享状态
 * - 常量与 Buff 映射
 * - 来源显示解析
 * - 马甲初始化与底层施加逻辑
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const jglobals = require("jass.globals");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
import { YDWESetUnitAbilityDataReal, EXSetUnitFacing } from "../../YDWE函数/00．YDWE函数";
import { GS_Suspend } from "./03．硬直暂停系统";
import { SUC_IsUnitStructure, SUC_IsValidUnit } from "./08．单位判定与筛选函数";
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统");
const ydweObject = require("lib.扩展函数.YDWE函数.index");
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const miscBj = require("lib.扩展函数.BJ函数.07．杂项");
const fourCcUtil = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换");
const { calcReducedControlDuration } = require("系统.05．Buff系统.01．控制抗性.02．控制时间计算");
const unitRelated = require("lib.扩展函数.自定义扩展函数.00．单位相关");
const 获取对象属性 = ydweObject.getObjectProperty;
const 物体类型 = ydweObject.ObjectType;
const 字符串转命令ID = miscBj.String2OrderIdBJ;
const 四色码转字符串 = fourCcUtil.fourCCToString;
const 获取玩家首个英雄 = unitRelated.getPlayerFirstHero;
const YDUserDataGet = YDUserDataGetSafe;
const YDUserDataSet = YDUserDataSetSafe;
function sym(name) {
    return globalThis[name]
        ?? (jglobals ? jglobals[name] : null)
        ?? (jass ? jass[name] : null);
}
function getYDHT() {
    return sym("StarBaseHT")
        ?? sym("YDHASH_HANDLE")
        ?? sym("YDHT")
        ?? sym("udg_YDHASH_HANDLE")
        ?? sym("udg_YDHT");
}
export const YDHT = getYDHT();
export let SFB_Unit = null;
const SFB_UNIT_ID = 0x6248756E;
const UnitAddAbility = jass["UnitAddAbility"];
const GetHandleId = jass["GetHandleId"];
export const IssueTargetOrder = jass["IssueTargetOrder"];
export const IssueTargetOrderById = jass["IssueTargetOrderById"];
const GetUnitX = jass["GetUnitX"];
const GetUnitY = jass["GetUnitY"];
const SetUnitX = jass["SetUnitX"];
const SetUnitY = jass["SetUnitY"];
const GetUnitName = jass["GetUnitName"];
const GetOwningPlayer = jass["GetOwningPlayer"];
const GetPlayerId = jass["GetPlayerId"];
const SFB_已添加技能 = {};
export const ABILITY = {
    STUN: 0x41534230,
    FREEZE: 0x41534234,
    SILENCE: 0x41534238,
    POLYMORPH: 0x41534279,
    INVIS: 0x41534258,
    SLOW: 0x41534239,
    ITEM_ILLUSION: 0x4153494C,
    INNER_FIRE: 0x41534249,
    BLOODLUST: 0x4153424C,
    CRIPPLE: 0x41534243,
    FAERIE_FIRE: 0x41534246,
    CURSE: 0x41534252,
    SLEEP: 0x41534253,
    ENTANGLING_ROOTS: 0x41534254,
    CYCLONE: 0x41534248,
    PARASITE: 0x41534250,
};
export const ORDER = {
    STUN: "thunderbolt",
    FREEZE: "creepthunderbolt",
    SILENCE: "silence",
    POLYMORPH: "polymorph",
    INVIS: "invisibility",
    ITEM_ILLUSION: 852274,
    SLOW: 852075,
    INNER_FIRE: "innerfire",
    BLOODLUST: "bloodlust",
    CRIPPLE: "cripple",
    FAERIE_FIRE: "faeriefire",
    CURSE: "curse",
    SLEEP: "sleep",
    ENTANGLING_ROOTS: "entanglingroots",
    CYCLONE: "cyclone",
    PARASITE: "parasite",
};
export const SFB_增益BUFF = {
    心灵之火: 31,
    嗜血术: 32,
};
export const SFB_负面BUFF = {
    残废: 41,
    精灵之火: 42,
    诅咒: 43,
    睡眠: 44,
    纠缠根须: 45,
    飓风: 46,
    寄生: 47,
};
const SFB_BUFF_ID = {
    0: "C001",
    1: "C002",
    2: "C003",
    3: "C004",
    4: "C005",
    5: "C006",
    7: "C007",
    21: "C008",
    22: "C009",
    23: "C010",
    31: "C011",
    32: "C012",
    41: "C013",
    42: "C014",
    43: "C015",
    44: "C016",
    45: "C017",
    46: "C018",
    47: "C024",
};
const NATIVE_BUFF = {
    STUN: 1112560453,
    FREEZE: 1114010234,
    SILENCE: 1112437609,
    POLYMORPH: 1114664057,
    INVIS: 1114205814,
    SLOW: 1114860655,
    INNER_FIRE: 1114205798,
    BLOODLUST: 1113746543,
    CRIPPLE: 1113813609,
    FAERIE_FIRE: 1114005861,
    CURSE: 1113813619,
    SLEEP_MAIN: 1112896364,
    SLEEP_PAUSE: 1112896368,
    SLEEP_STUN: 1114993524,
    ENTANGLING_ROOTS: 1111844210,
    CYCLONE_MAIN: 1113815395,
    CYCLONE_EXTRA: 1113815346,
    PARASITE: 0x424E7061,
    ITEM_ILLUSION: 0x4249696c,
};
const abilityOrderIdCache = {};
const SFB_NATIVE_BUFF_IDS = {
    0: [NATIVE_BUFF.STUN],
    1: [NATIVE_BUFF.FREEZE],
    2: [NATIVE_BUFF.SILENCE],
    3: [NATIVE_BUFF.POLYMORPH],
    4: [NATIVE_BUFF.INVIS],
    5: [NATIVE_BUFF.SILENCE],
    7: [NATIVE_BUFF.SLOW],
    31: [NATIVE_BUFF.INNER_FIRE],
    32: [NATIVE_BUFF.BLOODLUST],
    41: [NATIVE_BUFF.CRIPPLE],
    42: [NATIVE_BUFF.FAERIE_FIRE],
    43: [NATIVE_BUFF.CURSE],
    44: [NATIVE_BUFF.SLEEP_MAIN, NATIVE_BUFF.SLEEP_PAUSE, NATIVE_BUFF.SLEEP_STUN],
    45: [NATIVE_BUFF.ENTANGLING_ROOTS],
    46: [NATIVE_BUFF.CYCLONE_MAIN, NATIVE_BUFF.CYCLONE_EXTRA],
    47: [NATIVE_BUFF.PARASITE],
};
function getBuffDisplaySourceUnit(sourceUnit) {
    if (sourceUnit == null || sourceUnit === 0)
        return "";
    const owner = GetOwningPlayer(sourceUnit);
    if (owner != null && owner !== 0) {
        const playerId = GetPlayerId(owner);
        if (playerId >= 0 && playerId <= 5) {
            const hero = 获取玩家首个英雄(owner);
            if (hero != null && hero !== 0)
                return hero;
        }
    }
    return sourceUnit;
}
export function getUnitSourceName(sourceUnit, fallbackUnit) {
    let displayUnit = getBuffDisplaySourceUnit(sourceUnit);
    if (displayUnit == null || displayUnit === 0 || displayUnit === "") {
        displayUnit = getBuffDisplaySourceUnit(fallbackUnit);
    }
    if (displayUnit == null || displayUnit === 0)
        return "";
    const n = GetUnitName(displayUnit);
    return typeof n === "string" && n !== "" ? n : "";
}
export function normalizeRealValue(value) {
    if (value == null || value === false || value === "")
        return 0;
    const n = typeof value === "number" ? value : Number(value);
    return n !== n ? 0 : n;
}
export function shouldApplyControlReduction(id) {
    return id === 0 || id === 1 || id === 2 || id === 5
        || id === SFB_负面BUFF.睡眠
        || id === SFB_负面BUFF.纠缠根须
        || id === SFB_负面BUFF.飓风;
}
export function registerSfbManualBuff(sourceUnit, u, id, time, effectValue) {
    const buffID = SFB_BUFF_ID[id];
    if (buffID == null || buffID === "")
        return;
    registerManualBuff(u, buffID, time, effectValue, {
        sourceName: getUnitSourceName(sourceUnit, u),
        nativeBuffAbilityIds: SFB_NATIVE_BUFF_IDS[id],
    });
}
export function getSfbBuffId(id) {
    return SFB_BUFF_ID[id];
}
export function getAngleBetweenUnits(u, tu) {
    return jass.Atan2(jass.GetUnitY(tu) - jass.GetUnitY(u), jass.GetUnitX(tu) - jass.GetUnitX(u));
}
function getAbilityOrderId(abilityId, fallbackOrderStr) {
    const cached = abilityOrderIdCache[abilityId];
    if (cached != null && cached !== 0)
        return cached;
    if (typeof fallbackOrderStr === "number" && fallbackOrderStr !== 0) {
        abilityOrderIdCache[abilityId] = fallbackOrderStr;
        return fallbackOrderStr;
    }
    const abilityIdStr = 四色码转字符串(abilityId);
    let orderStr = abilityIdStr !== "" ? 获取对象属性(物体类型.ABILITY, abilityIdStr, "Order") : "";
    if (orderStr == null || orderStr === "")
        orderStr = fallbackOrderStr;
    if (orderStr == null || orderStr === "")
        return 0;
    if (typeof orderStr !== "string")
        return 0;
    const orderId = 字符串转命令ID(orderStr);
    if (orderId !== 0)
        abilityOrderIdCache[abilityId] = orderId;
    return orderId;
}
export function SFB_Init() {
    if (SFB_Unit != null && SFB_Unit !== 0)
        return;
    SFB_Unit = jass.CreateUnit(jass.Player(15), SFB_UNIT_ID, 0, 0, 0);
    UnitAddAbility(SFB_Unit, ABILITY.POLYMORPH);
    UnitAddAbility(SFB_Unit, ABILITY.STUN);
    UnitAddAbility(SFB_Unit, ABILITY.SLOW);
    UnitAddAbility(SFB_Unit, ABILITY.SILENCE);
    UnitAddAbility(SFB_Unit, ABILITY.INVIS);
    UnitAddAbility(SFB_Unit, ABILITY.FREEZE);
    UnitAddAbility(SFB_Unit, ABILITY.ITEM_ILLUSION);
    UnitAddAbility(SFB_Unit, ABILITY.PARASITE);
    SFB_已添加技能[ABILITY.POLYMORPH] = true;
    SFB_已添加技能[ABILITY.STUN] = true;
    SFB_已添加技能[ABILITY.SLOW] = true;
    SFB_已添加技能[ABILITY.SILENCE] = true;
    SFB_已添加技能[ABILITY.INVIS] = true;
    SFB_已添加技能[ABILITY.FREEZE] = true;
    SFB_已添加技能[ABILITY.ITEM_ILLUSION] = true;
    SFB_已添加技能[ABILITY.PARASITE] = true;
    globalThis.SFB_Unit = SFB_Unit;
}
function SFB_确保马甲技能(abilityId) {
    if (SFB_已添加技能[abilityId])
        return true;
    const caster = SFB_Unit;
    if (caster == null || caster === 0)
        return false;
    if (!UnitAddAbility(caster, abilityId))
        return false;
    SFB_已添加技能[abilityId] = true;
    return true;
}
function onSfbPauseTimerExpire() {
    const t = jass.GetExpiredTimer();
    jass.PauseUnit(jass.LoadUnitHandle(YDHT, jass.GetHandleId(t), jass.StringHash("单位")), false);
    jass.RemoveSavedHandle(YDHT, jass.GetHandleId(t), jass.StringHash("单位"));
    safeDestroyTimer(t);
}
function onSfbExpauseTimerExpire() {
    const t = jass.GetExpiredTimer();
    japi.EXPauseUnit(jass.LoadUnitHandle(YDHT, jass.GetHandleId(t), jass.StringHash("单位")), false);
    jass.RemoveSavedHandle(YDHT, jass.GetHandleId(t), jass.StringHash("单位"));
    safeDestroyTimer(t);
}
export function SFB_施加原生目标Buff(sourceUnit, u, id, time, abilityId, orderStr) {
    if (!SUC_IsValidUnit(u) || time <= 0)
        return;
    if (SUC_IsUnitStructure(u))
        return;
    if (u === SFB_Unit)
        return;
    const caster = SFB_Unit;
    if (caster == null || caster === 0)
        return;
    if (!SFB_确保马甲技能(abilityId))
        return;
    const fac = getAngleBetweenUnits(caster, u);
    EXSetUnitFacing(caster, fac);
    jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac);
    SetUnitX(caster, GetUnitX(u));
    SetUnitY(caster, GetUnitY(u));
    YDWESetUnitAbilityDataReal(caster, abilityId, 1, 102, time);
    YDWESetUnitAbilityDataReal(caster, abilityId, 1, 103, time);
    if (abilityId === ABILITY.PARASITE) {
        YDWESetUnitAbilityDataReal(caster, abilityId, 1, 105, 0);
        YDWESetUnitAbilityDataReal(caster, abilityId, 1, 107, 999999);
    }
    registerSfbManualBuff(sourceUnit, u, id, time, 0);
    IssueTargetOrder(caster, orderStr, u);
}
export function SFB_施加原生目标技能(u, abilityId, orderStr, 持续时间 = 0) {
    if (!SUC_IsValidUnit(u))
        return false;
    if (SUC_IsUnitStructure(u))
        return false;
    if (u === SFB_Unit)
        return false;
    const caster = SFB_Unit;
    if (caster == null || caster === 0)
        return false;
    if (!SFB_确保马甲技能(abilityId))
        return false;
    const fac = getAngleBetweenUnits(caster, u);
    EXSetUnitFacing(caster, fac);
    jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac);
    if (持续时间 > 0) {
        YDWESetUnitAbilityDataReal(caster, abilityId, 1, 102, 持续时间);
        YDWESetUnitAbilityDataReal(caster, abilityId, 1, 103, 持续时间);
    }
    const orderId = getAbilityOrderId(abilityId, orderStr);
    if (orderId !== 0)
        return IssueTargetOrderById(caster, orderId, u) === true;
    return typeof orderStr === "string" ? IssueTargetOrder(caster, orderStr, u) === true : false;
}
export function SFB_施加暂停类Buff(sourceUnit, u, id, time) {
    registerSfbManualBuff(sourceUnit, u, id, time, 0);
    if (id === 21) {
        GS_Suspend(u, time);
    }
    else if (id === 22) {
        const tempTimer = jass.CreateTimer();
        jass.SaveUnitHandle(YDHT, jass.GetHandleId(tempTimer), jass.StringHash("单位"), u);
        jass.PauseUnit(u, true);
        safeTimerStart(tempTimer, time, false, onSfbPauseTimerExpire);
    }
    else if (id === 23) {
        const tempTimer = jass.CreateTimer();
        jass.SaveUnitHandle(YDHT, jass.GetHandleId(tempTimer), jass.StringHash("单位"), u);
        japi.EXPauseUnit(u, true);
        safeTimerStart(tempTimer, time, false, onSfbExpauseTimerExpire);
    }
}
SFB_Init();
export { EXSetUnitFacing, GetPlayerId, GetOwningPlayer, GS_Suspend, SUC_IsUnitStructure, SUC_IsValidUnit, YDWESetUnitAbilityDataReal, calcReducedControlDuration, japi, jass, jglobals, registerManualBuff, safeDestroyTimer, safeTimerStart, };
