/** @noSelfInFile */
/**
 * 04．伤害映射
 *
 * 将召唤物、马甲等代理单位造成的伤害，
 * 映射为主人单位造成的伤害。
 *
 * 默认规则：玩家 0-4 的非英雄单位归属到该玩家英雄。
 * 可选规则：业务可以显式调用 登记伤害来源主人(source, owner)，
 * 让非玩家代理单位也归属到指定主人。
 */

const jass = require("jass.common") as any;

const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
};

const 玩家常量 = require("系统.00．核心系统.00．玩家系统.00．常量") as {
  YD_ATTR_PLAYER_HERO_UNIT: string;
};

const GetOwningPlayer = jass.GetOwningPlayer as (u: any) => any;
const GetPlayerId = jass.GetPlayerId as (p: any) => number;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const Player = jass.Player as (id: number) => any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO;

/** 玩家 ID → 该玩家的英雄引用缓存 */
const 玩家英雄缓存: Record<number, any | undefined> = {};
/** 代理单位 handleId → 伤害主人单位 */
const 显式伤害主人表: Record<number, any | undefined> = {};

/** 获取玩家 0-4 的英雄（带缓存，首次通过 YDUserData 查询） */
function 取玩家英雄(playerId: number): any | null {
  if (playerId < 0 || playerId > 4) return null;

  if (玩家英雄缓存[playerId] != null) return 玩家英雄缓存[playerId];

  const player = Player(playerId);
  const hero = YDUserDataGet("player", player, 玩家常量.YD_ATTR_PLAYER_HERO_UNIT, "unit");
  if (hero != null && hero !== 0) {
    玩家英雄缓存[playerId] = hero;
    return hero;
  }

  return null;
}

/**
 * 显式登记代理单位的伤害主人。
 * 适合 Boss/特殊召唤物这类无法只靠所属玩家推导主人单位的场景。
 */
export function 登记伤害来源主人(source: any, owner: any): void {
  if (source == null || source === 0) return;
  if (owner == null || owner === 0) return;
  if (source === owner) return;
  显式伤害主人表[GetHandleId(source)] = owner;
}

/** 清除代理单位的显式伤害主人登记。 */
export function 清除伤害来源主人(source: any): void {
  if (source == null || source === 0) return;
  显式伤害主人表[GetHandleId(source)] = undefined;
}

function 取显式伤害主人(source: any, target: any): any | null {
  const owner = 显式伤害主人表[GetHandleId(source)];
  if (owner == null || owner === 0) return null;
  if (owner === source) return null;
  if (target != null && target !== 0 && owner === target) return null;
  return owner;
}

function 取玩家代理伤害主人(source: any): any | null {
  const owner = GetOwningPlayer(source);
  if (owner == null || owner === 0) return null;
  const pid = GetPlayerId(owner);
  if (pid < 0 || pid > 4) return null;

  const hero = 取玩家英雄(pid);
  return hero != null && hero !== 0 && hero !== source ? hero : null;
}

/**
 * 获取归属后的伤害来源。
 * 若 attacker 是玩家 0-4 的非英雄代理单位，或显式登记过主人，返回主人单位；
 * 否则返回原 attacker。
 */
export function 获取伤害归属单位(attacker: any, target: any): any {
  if (attacker == null || attacker === 0) return attacker;
  if (target == null || target === 0) return attacker;
  if (attacker === target) return attacker;
  if (IsUnitType(attacker, UNIT_TYPE_HERO)) return attacker;

  const explicitOwner = 取显式伤害主人(attacker, target);
  if (explicitOwner != null && explicitOwner !== 0) return explicitOwner;

  const playerOwner = 取玩家代理伤害主人(attacker);
  return playerOwner != null && playerOwner !== 0 ? playerOwner : attacker;
}

/** 兼容旧调用名。 */
export function 获取映射攻击者(attacker: any, target: any): any {
  return 获取伤害归属单位(attacker, target);
}

export {};
