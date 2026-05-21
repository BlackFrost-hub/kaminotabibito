/** @noSelfInFile */
/**
 * 04．伤害映射
 *
 * 将玩家 0-4 所有单位（英雄 + 宠物 + 召唤物 + 马甲）造成的伤害，
 * 映射为当前玩家唯一英雄造成的伤害。
 *
 * 使用方式：仇恨计算系统在收到伤害回调后，调用 获取映射攻击者(attacker, target)
 * 将非英雄的攻击者替换为玩家英雄。
 */
const jass = require("jass.common");
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容");
const 玩家常量 = require("系统.00．核心系统.00．玩家系统.00．常量");
const GetOwningPlayer = jass.GetOwningPlayer;
const GetPlayerId = jass.GetPlayerId;
const IsUnitType = jass.IsUnitType;
/** 玩家 ID → 该玩家的英雄引用缓存 */
const 玩家英雄缓存 = {};
/** 获取玩家 0-4 的英雄（带缓存，首次通过 YDUserData 查询） */
function 取玩家英雄(playerId) {
    if (playerId < 0 || playerId > 4)
        return null;
    if (玩家英雄缓存[playerId] != null)
        return 玩家英雄缓存[playerId];
    const player = jass.Player(playerId);
    const hero = YDUserDataGet("player", player, 玩家常量.YD_ATTR_PLAYER_HERO_UNIT, "unit");
    if (hero != null && hero !== 0) {
        玩家英雄缓存[playerId] = hero;
        return hero;
    }
    return null;
}
/**
 * 获取映射后的攻击者。
 * 若 attacker 是玩家 0-4 的非英雄单位（非自伤），返回对应的玩家英雄；
 * 否则返回原 attacker。
 */
export function 获取映射攻击者(attacker, target) {
    if (attacker == null || attacker === 0)
        return attacker;
    if (target == null || target === 0)
        return attacker;
    if (attacker === target)
        return attacker;
    if (IsUnitType(attacker, jass.UNIT_TYPE_HERO))
        return attacker;
    const owner = GetOwningPlayer(attacker);
    if (owner == null || owner === 0)
        return attacker;
    const pid = GetPlayerId(owner);
    if (pid < 0 || pid > 4)
        return attacker;
    const hero = 取玩家英雄(pid);
    return hero != null && hero !== 0 ? hero : attacker;
}
