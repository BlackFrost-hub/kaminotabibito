/**
 * 玩家单位管理器 — 功能：移速 > 阈值时挂龙卷提示特效
 */

const jass = require("jass.common") as any;

const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
};

const { ForGroupBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ForGroupBJ: (whichGroup: any, callback: any) => void;
};

const { DzUnbindEffect } = require("lib.扩展函数.KK扩展API.index") as { DzUnbindEffect: (whichEffect: any) => boolean };

const C = require("系统.00．核心系统.00．玩家系统.00．常量") as typeof import("./00．常量");

/** unitHandleId -> effectHandle */
const tornadoEffMap: Map<number, any> = new Map();

function getUnitHandleId(u: any): number {
  return typeof jass.GetHandleId === "function" ? (jass.GetHandleId(u) as number) || 0 : 0;
}

function createTornadoEffect(u: any): any {
  if (typeof jass.AddSpecialEffectTarget !== "function") return null;
  return jass.AddSpecialEffectTarget(C.TORNADO_EFFECT_MODEL, u, C.TORNADO_ATTACH_POINT);
}

function destroyTornadoEffect(eff: any): void {
  if (!eff) return;
  if (typeof DzUnbindEffect === "function") DzUnbindEffect(eff);
  if (typeof jass.DestroyEffect === "function") jass.DestroyEffect(eff);
}

/**
 * 一轮同步：读 YD 玩家英雄组，按移速增删龙卷特效；清理已不在组内但 Map 仍存的条目。
 */
export function syncTornadoSpeedEffectsByHeroGroup(): void {
  const heroGroup = YDUserDataGet(
    C.YD_TABLE_TYPE_PLAYER_HERO,
    C.YD_TABLE_KEY_PLAYER_HERO,
    C.YD_ATTR_HERO_GROUP,
    C.YD_VALUE_TYPE_GROUP
  );
  if (!heroGroup) return;
  if (typeof jass.GetUnitMoveSpeed !== "function" || typeof jass.GetEnumUnit !== "function") return;

  const seen: Set<number> = new Set();

  ForGroupBJ(heroGroup, () => {
    const u = jass.GetEnumUnit();
    if (u == null || u === 0) return;

    const uid = getUnitHandleId(u);
    if (!uid) return;
    seen.add(uid);

    const sp = jass.GetUnitMoveSpeed(u) as number;
    const shouldHave = sp > C.MOVE_SPEED_THRESHOLD;

    if (shouldHave) {
      if (!tornadoEffMap.has(uid)) {
        const eff = createTornadoEffect(u);
        if (eff) tornadoEffMap.set(uid, eff);
      }
    } else {
      const eff = tornadoEffMap.get(uid);
      if (eff) {
        destroyTornadoEffect(eff);
        tornadoEffMap.delete(uid);
      }
    }
  });

  for (const [uid, eff] of tornadoEffMap) {
    if (!seen.has(uid)) {
      destroyTornadoEffect(eff);
      tornadoEffMap.delete(uid);
    }
  }
}

export {};
