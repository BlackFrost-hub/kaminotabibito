/**
 * 通用 JASS 封装工具箱（会逐步堆很多“小而散”的 helper）。
 *
 * 约定：
 * - 这里放“跨模块通用、但又不值得单独建系统文件”的封装函数（例如：资源调整、常用 JASS 小工具等）
 * - 若某类功能已经演化成完整系统（例如 音效函数/漂浮文字/泄露审计），应放到对应模块，不要继续堆在这里
 * - 这里的函数尽量保持：无复杂状态、易复用、参数清晰
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav";
/**
 * 调整玩家状态（如金币、木材），在原有基础上增加 delta。
 */
export function AdjustPlayerStateBJ(delta, whichPlayer, whichPlayerState) {
    const current = jass.GetPlayerState(whichPlayer, whichPlayerState);
    jass.SetPlayerState(whichPlayer, whichPlayerState, current + delta);
}
/**
 * 增减金币，并自动反馈：
 * - 传 player：只对该玩家播放“收金币”音效，不创建漂浮字
 * - 传 unit：在该单位头顶创建漂浮字（+/-数值），并在单位附近播放 3D 音效（cutoff=1500）
 */
export function AddGoldWithFeedback(params) {
    const { delta, player, unit } = params;
    if (delta === 0)
        return;
    const p = player != null
        ? player
        : unit != null && typeof jass.GetOwningPlayer === "function"
            ? jass.GetOwningPlayer(unit)
            : null;
    if (!p)
        return;
    AdjustPlayerStateBJ(delta, p, jass.PLAYER_STATE_RESOURCE_GOLD);
    const { Sound3DII_Mp3Play, Sound3DII_UnitPlay } = require("系统.00．核心系统.02．音效函数");
    const { CreateFloatTextOnUnit } = require("系统.00．核心系统.03．漂浮文字函数");
    if (unit != null) {
        // 漂浮字：金色，显示 +N / -N
        const txt = delta > 0 ? "+" + tostring(delta) : tostring(delta);
        CreateFloatTextOnUnit(unit, txt, { red: 255, green: 215, blue: 0, alpha: 0 });
        // 3D 音效：在单位附近，1500 裁断距离
        Sound3DII_UnitPlay(SOUND_GOLD, unit, 1500);
    }
    else {
        // 玩家专属 UI 音效
        Sound3DII_Mp3Play(SOUND_GOLD, p);
    }
}
/**
 * 将 4 字符字符串转换为 FourCC 数字（用于物品/单位 ID）
 */
export function stringToFourCC(s) {
    const b1 = string.byte(s, 1);
    const b2 = string.byte(s, 2);
    const b3 = string.byte(s, 3);
    const b4 = string.byte(s, 4);
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
}
/**
 * 将 FourCC 数字转换为 4 字符字符串
 */
export function fourCCToString(fourcc) {
    const c1 = string.char(fourcc % 256);
    const c2 = string.char(Math.floor(fourcc / 256) % 256);
    const c3 = string.char(Math.floor(fourcc / 65536) % 256);
    const c4 = string.char(Math.floor(fourcc / 16777216) % 256);
    return c4 + c3 + c2 + c1;
}
/**
 * 获取单位的攻击类型（Attack Type）
 * 单位状态0x23对应攻击类型，使用ConvertUnitState转换
 */
export function Ir_GetUnitAttackType(u) {
    return jass.R2I(japi.GetUnitState(u, jass.ConvertUnitState(0x23)));
}
export function Ir_SetUnitAttackType(u, atp) {
    japi.SetUnitState(u, jass.ConvertUnitState(0x23), atp);
}
/**
 * 向指定玩家显示屏幕消息（仅该玩家可见）
 * @param player 玩家句柄（可用 jass.Player(index) 获取）
 * @param msg 消息内容
 * @param duration 显示时长（秒），默认6秒
 */
export function printToPlayer(player, msg, duration = 6) {
    if (!player)
        return;
    if (typeof jass.DisplayTimedTextToPlayer !== "function")
        return;
    jass.DisplayTimedTextToPlayer(player, 0, 0, duration, msg);
}
/**
 * 向多个玩家显示屏幕消息
 * @param players 玩家数组
 * @param msg 消息内容
 * @param duration 显示时长（秒），默认6秒
 */
export function printToPlayers(players, msg, duration = 6) {
    for (const p of players) {
        printToPlayer(p, msg, duration);
    }
}
/**
 * 判断单位是否为"特殊单位"（召唤物/幻象），这些单位通常不触发装备等功能
 */
export function isSpecialUnit(unit) {
    if (!unit)
        return true;
    if (jass.UNIT_TYPE_SUMMONED != null && jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED))
        return true;
    if (typeof jass.IsUnitIllusionBJ === "function" && jass.IsUnitIllusionBJ(unit))
        return true;
    if (typeof jass.IsUnitIllusion === "function" && jass.IsUnitIllusion(unit))
        return true;
    return false;
}
const g = require("jass.globals");
/**
 * 判断单位是否为英雄单位
 */
export function isHeroUnit(unit) {
    if (!unit)
        return false;
    const utHero = jass.UNIT_TYPE_HERO ?? g.UNIT_TYPE_HERO;
    if (utHero != null && typeof jass.IsUnitType === "function") {
        return jass.IsUnitType(unit, utHero) === true;
    }
    if (typeof jass.GetHeroLevel === "function") {
        return jass.GetHeroLevel(unit) > 0;
    }
    return false;
}
/**
 * 延迟执行回调（自动创建/销毁计时器）
 * @param delaySec 延迟秒数
 * @param callback 回调函数
 * @param periodic 是否重复执行（默认 false）
 * @param name 调试用名称（可选）
 * @returns 计时器句柄（periodic=true 时可用，用于停止），不需要可忽略
 */
export function withTimer(delaySec, callback, periodic = false, name) {
    const t = jass.CreateTimer?.();
    if (!t) {
        callback();
        return null;
    }
    if (typeof jass.TimerStart !== "function") {
        callback();
        return null;
    }
    if (periodic) {
        jass.TimerStart(t, delaySec, true, () => {
            callback();
        });
    }
    else {
        jass.TimerStart(t, delaySec, false, () => {
            callback();
            if (typeof jass.DestroyTimer === "function")
                jass.DestroyTimer(t);
        });
    }
    return t;
}
/**
 * 停止并销毁指定的周期性计时器
 * @param t 计时器句柄（withTimer 返回的）
 */
export function stopTimer(t) {
    if (!t)
        return;
    if (typeof jass.PauseTimer === "function")
        jass.PauseTimer(t);
    if (typeof jass.DestroyTimer === "function")
        jass.DestroyTimer(t);
}
/**
 * 创建特效并在指定时间后自动销毁（自动处理 1.27 兼容）
 * @param modelPath 特效模型路径
 * @param x x坐标
 * @param y y坐标
 * @param z z坐标（可选，默认0）
 * @param duration 持续时间秒数（默认2秒）
 * @returns 特效句柄
 */
export function createTimedEffect(modelPath, x, y, z = 0, duration = 2) {
    let eff;
    if (typeof jass.AddSpecialEffectZ === "function") {
        eff = jass.AddSpecialEffectZ(modelPath, x, y, z);
    }
    else if (typeof jass.AddSpecialEffect === "function") {
        eff = jass.AddSpecialEffect(modelPath, x, y);
    }
    if (!eff)
        return null;
    withTimer(duration, () => {
        if (typeof jass.DestroyEffect === "function") {
            jass.DestroyEffect(eff);
        }
    });
    return eff;
}
/**
 * 查找指定玩家的英雄单位
 * @param playerId 玩家索引（0-15）
 * @returns 英雄单位，如果没有找到返回 null
 */
export function findHeroOfPlayer(playerId) {
    if (typeof jass.CreateGroup !== "function" || typeof jass.GroupEnumUnitsOfPlayer !== "function")
        return null;
    const group = jass.CreateGroup();
    jass.GroupEnumUnitsOfPlayer(group, jass.Player(playerId), null);
    const unit = jass.FirstOfGroup(group);
    jass.DestroyGroup(group);
    if (unit && isHeroUnit(unit))
        return unit;
    return null;
}
// ─────────────────────────────────────────────────────────────────────────────
// 单位绑定特效管理
// ─────────────────────────────────────────────────────────────────────────────
/** 存储单位绑定的特效（key: 单位句柄ID, value: 特效句柄） */
const unitEffectMap = new Map();
/**
 * 在单位上创建绑定特效
 * @param unit 目标单位
 * @param attachPoint 绑定点（如 "overhead", "origin", "chest" 等）
 * @param modelPath 特效模型路径
 * @param duration 持续时间（秒），不传则永久存在直到手动销毁
 * @returns 是否创建成功
 */
export function createUnitEffect(unit, attachPoint, modelPath, duration) {
    if (!unit)
        return false;
    const handleId = japi.DzGetUnitObjectId ? japi.DzGetUnitObjectId(unit) : 0;
    if (!handleId)
        return false;
    // 如果已有特效，先销毁
    const existingEffect = unitEffectMap.get(handleId);
    if (existingEffect && typeof jass.DestroyEffect === "function") {
        jass.DestroyEffect(existingEffect);
    }
    // 创建新特效
    const effect = jass.AddSpecialEffectTarget(modelPath, unit, attachPoint);
    if (!effect)
        return false;
    unitEffectMap.set(handleId, effect);
    // 如果指定了持续时间，定时销毁
    if (duration != null && duration > 0) {
        withTimer(duration, () => {
            const currentEffect = unitEffectMap.get(handleId);
            if (currentEffect === effect && typeof jass.DestroyEffect === "function") {
                jass.DestroyEffect(effect);
                unitEffectMap.delete(handleId);
            }
        });
    }
    return true;
}
/**
 * 销毁单位上的绑定特效
 * @param unit 目标单位
 */
export function destroyUnitEffect(unit) {
    if (!unit)
        return;
    const handleId = japi.DzGetUnitObjectId ? japi.DzGetUnitObjectId(unit) : 0;
    if (!handleId)
        return;
    const effect = unitEffectMap.get(handleId);
    if (effect && typeof jass.DestroyEffect === "function") {
        jass.DestroyEffect(effect);
    }
    unitEffectMap.delete(handleId);
}
