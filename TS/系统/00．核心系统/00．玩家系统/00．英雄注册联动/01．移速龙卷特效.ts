/**
 * 玩家系统 - 英雄注册联动 - 移速龙卷特效
 * 职责：
 * - 移速>阈值时挂载龙卷提示特效，<=阈值时移除
 * - 使用Map(unitHandleId -> effectHandle)避免重复创建/销毁
 * - 单位离开英雄组时自动清理特效
 * 接入：由"玩家英雄获取桥接"在获得英雄时注册，周期同步只处理已注册英雄
 * 这里的安全检查是必须的，无视全局规则，2026年4月21日21:29:21
 */


const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const C = require("系统.00．核心系统.00．玩家系统.00．常量") as typeof import("../00．常量");

const trackedHeroes: Map<number, any> = new Map();
const tornadoEffects: Map<number, any> = new Map();

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

function getHandleId(handle: any): number {
  if (!isValidHandle(handle)) return 0;
  return (jass.GetHandleId(handle) as number) || 0;
}

function createTornadoEffect(whichUnit: any): any {
  return jass.AddSpecialEffectTarget(C.TORNADO_EFFECT_MODEL, whichUnit, C.TORNADO_ATTACH_POINT);
}

function destroyTornadoEffect(effect: any): void {
  if (!isValidHandle(effect)) return;
  if (typeof japi.DzUnbindEffect === "function") {
    japi.DzUnbindEffect(effect);
  }
  jass.DestroyEffect(effect);
}

function removeTrackedHero(heroId: number): void {
  trackedHeroes.delete(heroId);
  const effect = tornadoEffects.get(heroId);
  if (effect != null) {
    destroyTornadoEffect(effect);
    tornadoEffects.delete(heroId);
  }
}

/**
 * 由英雄注册桥接调用。
 * 当某个玩家英雄被确认后，把它加入龙卷特效跟踪表。
 */
export function registerMoveSpeedTornadoHero(whichHero: any): void {
  if (!isValidHandle(whichHero)) return;
  const heroId = getHandleId(whichHero);
  if (heroId === 0) return;
  trackedHeroes.set(heroId, whichHero);
}

/**
 * 周期同步已注册英雄的移速特效状态。
 * 这里只处理“已被桥接模块确认过”的英雄，不再自己扫描全局英雄组。
 */
export function syncTornadoSpeedEffectsByRegisteredHeroes(): void {
  for (const [heroId, hero] of trackedHeroes) {
    if (!isValidHandle(hero) || jass.IsUnitType(hero, jass.UNIT_TYPE_DEAD) === true) {
      removeTrackedHero(heroId);
      continue;
    }

    const moveSpeed = (jass.GetUnitMoveSpeed(hero) as number) || 0;
    const shouldHaveEffect = moveSpeed > C.MOVE_SPEED_THRESHOLD;
    const currentEffect = tornadoEffects.get(heroId);

    if (shouldHaveEffect) {
      if (currentEffect == null) {
        const effect = createTornadoEffect(hero);
        if (effect != null) tornadoEffects.set(heroId, effect);
      }
      continue;
    }

    if (currentEffect != null) {
      destroyTornadoEffect(currentEffect);
      tornadoEffects.delete(heroId);
    }
  }
}

export {};
