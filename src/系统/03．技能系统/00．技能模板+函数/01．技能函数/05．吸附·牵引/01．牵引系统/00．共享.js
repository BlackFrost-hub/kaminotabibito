/** @noSelfInFile */
/**
 * 牵引系统 - 共享类型、常量与工具函数
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
export const GetHandleId = jass["GetHandleId"];
export const GetUnitX = jass["GetUnitX"];
export const GetUnitY = jass["GetUnitY"];
export const GetUnitTypeId = jass["GetUnitTypeId"];
export const GetUnitState = jass["GetUnitState"];
export const IsUnitType = jass["IsUnitType"];
export const GetRectMinX = jass["GetRectMinX"];
export const GetRectMinY = jass["GetRectMinY"];
export const GetRectMaxX = jass["GetRectMaxX"];
export const GetRectMaxY = jass["GetRectMaxY"];
export const SetUnitX = jass["SetUnitX"];
export const SetUnitY = jass["SetUnitY"];
export const SetUnitFacing = jass["SetUnitFacing"];
export const PauseUnit = jass["PauseUnit"];
export const IsUnitPaused = jass["IsUnitPaused"];
export const SetUnitPathing = jass["SetUnitPathing"];
export const SquareRoot = jass["SquareRoot"];
export const Atan2 = jass["Atan2"];
export const Cos = jass["Cos"];
export const Sin = jass["Sin"];
export const R2I = jass["R2I"];
export const bj_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;
export const bj_DEGTORAD = jglobals.bj_DEGTORAD ?? 0.017453292519943295;
export const ForGroup = jass["ForGroup"];
export const GetEnumUnit = jass["GetEnumUnit"];
export const AddLightning = jass["AddLightning"];
export const MoveLightning = jass["MoveLightning"];
export const MoveLightningEx = jass["MoveLightningEx"];
export const DestroyLightning = jass["DestroyLightning"];
export const { X_IsTerrainWalkable, X_IsUnitTerrainWalkable, X_GetAbleX, X_GetAbleY } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数");
export const TICK_INTERVAL = 0.02;
export const CENTER_TIMER_TICKS = 2;
export const MAX_SUB_STEP = 31.0;
export const WALKABLE_TOLERANCE = 8.0;
export const UNIT_ALIVE_LIFE = 0.405;
export const 闪电效果代码_闪电链主闪电 = "CLPB";
export const 闪电效果代码_闪电链次闪电 = "CLSB";
export const 闪电效果代码_生命汲取 = "DRAB";
export const 闪电效果代码_生命汲取生命 = "DRAL";
export const 闪电效果代码_魔力汲取 = "DRAM";
export const 闪电效果代码_叉状闪电 = "FORK";
export const 闪电效果代码_治疗波主闪电 = "HWPB";
export const 闪电效果代码_治疗波次闪电 = "HWSB";
export const 闪电效果代码_闪电攻击 = "CHIM";
export const 闪电效果代码_魔法束缚 = "LEAS";
export const 闪电效果代码_灵魂锁链 = "SPLK";
export const 闪电效果代码_牵引绳子 = "ROP";
export const 闪电效果代码_魔力之焰 = "MFPB";
export const 闪电效果代码_死亡之指 = "AFOD";
export const DEFAULT_LIGHTNING_CODE = 闪电效果代码_闪电链主闪电;
export let 单位组快照缓存 = [];
export const 活动牵引列表 = [];
export const 牵引映射 = {};
export const 单位当前牵引 = {};
export let 下一个牵引ID = 0;
export function 推进下一个牵引ID() {
    下一个牵引ID += 1;
    return 下一个牵引ID;
}
export function 取句柄ID(h) {
    return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
}
export function 单位存活(u) {
    if (u == null || u === 0)
        return false;
    if (GetUnitTypeId(u) === 0)
        return false;
    if (IsUnitType(u, jass.UNIT_TYPE_DEAD) === true)
        return false;
    return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}
export function 在可玩区域内(x, y) {
    return x >= GetRectMinX(jglobals.bj_mapInitialPlayableArea)
        && y >= GetRectMinY(jglobals.bj_mapInitialPlayableArea)
        && x <= GetRectMaxX(jglobals.bj_mapInitialPlayableArea)
        && y <= GetRectMaxY(jglobals.bj_mapInitialPlayableArea);
}
export function 计算坐标距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return SquareRoot(dx * dx + dy * dy);
}
export function 计算朝向角度(x1, y1, x2, y2) {
    return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG;
}
export function 收集单位组成员() {
    const 单位 = GetEnumUnit();
    if (单位 != null && 单位 !== 0) {
        单位组快照缓存.push(单位);
    }
}
export function 快照单位组(单位组) {
    if (单位组 == null || 单位组 === 0)
        return [];
    单位组快照缓存 = [];
    ForGroup(单位组, 收集单位组成员);
    const 结果 = 单位组快照缓存;
    单位组快照缓存 = [];
    return 结果;
}
export function 计算每Tick位移(参数) {
    if (参数.每Tick位移 != null && 参数.每Tick位移 > 0)
        return 参数.每Tick位移;
    if (参数.每秒速度 != null && 参数.每秒速度 > 0)
        return 参数.每秒速度 * TICK_INTERVAL;
    return 10;
}
export function 计算持续Tick数(参数) {
    if (参数.持续时间 != null && 参数.持续时间 > 0) {
        const ticks = R2I(参数.持续时间 / TICK_INTERVAL + 0.0001);
        return ticks > 0 ? ticks : 1;
    }
    return 50;
}
export function 解析中心坐标(参数) {
    if (参数.中心单位 != null && 参数.中心单位 !== 0) {
        return { x: GetUnitX(参数.中心单位), y: GetUnitY(参数.中心单位) };
    }
    if (参数.中心X != null && 参数.中心Y != null) {
        return { x: 参数.中心X, y: 参数.中心Y };
    }
    return null;
}
