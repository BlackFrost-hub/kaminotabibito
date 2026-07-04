/** @noSelfInFile */
/**
 * 玩家系统 - 英雄注册联动 - 玩家英雄获取桥接
 *
 * Lua 侧职责：
 * - 从传入单位中筛选玩家 1-5 操作的英雄
 * - 写入 YDUserData("player", whichPlayer, "英雄", "unit")
 * - 在拿到英雄时，把英雄注册到各个依赖它的联动模块
 *
 * 现状：
 * - 英雄选择系统已改为直接调用 `directRegisterPlayerHero`
 * - 这里不再注册旧 STES「玩家英雄注册」桥接，只保留直连能力
 */

const jass = require("jass.common") as any;
const centerTimer = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

const C = require("系统.00．核心系统.00．玩家系统.00．常量") as typeof import("../00．常量");

const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
  YDUserDataSet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string, value: any) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const moveTornado = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.01．移速龙卷特效") as {
  registerMoveSpeedTornadoHero?: (this: void, whichHero: any) => void;
};
const registerMoveSpeedTornadoHero = moveTornado.registerMoveSpeedTornadoHero;

const petItemHandoff = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.03．背包满移交宠物") as {
  注册宠物移交英雄: (this: void, whichHero: any) => void;
};

const chestSystem = require("系统.06．经济系统.00．宝箱系统.02．事件注册") as {
  registerChestSystemHero: (this: void, whichHero: any) => void;
};

const heroVoiceSystem = require("系统.09．表现系统.10．英雄语音.05．指令音效.index") as {
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => void;
};

const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};

const 英雄依赖注册队列间隔毫秒 = 150;
const 英雄依赖注册启动延迟毫秒 = 800;

interface 英雄依赖注册任务 {
  owner: any;
  hero: any;
  stage: number;
}

/**
 * 只接受玩家 1-5 当前操作的英雄，且排除电脑玩家。
 * 这里是整条"英雄注册联动"链路的第一层筛选。
 */
function isPlayableHero(whichUnit: any): boolean {
  if (whichUnit == null || whichUnit === 0) return false;
  if (jass.IsUnitType(whichUnit, jass.UNIT_TYPE_HERO) !== true) return false;

  const owner = jass.GetOwningPlayer(whichUnit);
  if (owner == null || owner === 0) return false;

  if (jass.GetPlayerController(owner) === jass.MAP_CONTROL_COMPUTER) return false;

  const playerId = (jass.GetPlayerId(owner) as number) || -1;
  return playerId >= 0 && playerId <= 4;
}

function invokeUiAttrOnPlayerHeroRegistered(whichPlayer: any, whichHero: any): void {
  const mod = require("系统.09．表现系统.03．UI属性系统.02．面板渲染") as {
    onPlayerHeroRegistered?: (this: void, w: any, h: any) => void;
  };
  const cb = mod.onPlayerHeroRegistered;
  if (typeof cb !== "function") return;
  cb(whichPlayer, whichHero);
}

const uiRegisteredPlayers = new Set<number>();
const 英雄依赖注册队列: 英雄依赖注册任务[] = [];
let 英雄依赖注册队列下一步延迟ID: number | undefined;
let 英雄依赖注册启动延迟ID: number | undefined;

const dialogSystem = require("系统.09．表现系统.02．对话框系统.00．对话框渲染核心") as {
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => void;
};

const buffUISystem = require("系统.05．Buff系统.02．BuffUI") as {
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => void;
};

const threatPanelSystem = require("系统.09．表现系统.05．仇恨面板.index") as {
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => void;
};

const selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  initPlayerSelectionCenter?: (this: void, whichPlayer: any) => void;
  seedSoleSelectedUnitForPlayer?: (this: void, whichPlayer: any, whichUnit: any) => void;
};
const initPlayerSelectionCenter = selectionCenterSystem.initPlayerSelectionCenter as
  | ((this: void, whichPlayer: any) => void)
  | undefined;
const seedSoleSelectedUnitForPlayer = selectionCenterSystem.seedSoleSelectedUnitForPlayer as
  | ((this: void, whichPlayer: any, whichUnit: any) => void)
  | undefined;

const playerCountSystem = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数") as {
  初始化玩家人数监听: (this: void) => void;
};
const 初始化玩家人数监听 = playerCountSystem.初始化玩家人数监听;

function invokeSelectionCenterInit(whichPlayer: any): void {
  if (typeof initPlayerSelectionCenter !== "function") return;
  initPlayerSelectionCenter(whichPlayer);
}

function invokeSelectionCenterSeed(whichPlayer: any, whichUnit: any): void {
  if (typeof seedSoleSelectedUnitForPlayer !== "function") return;
  seedSoleSelectedUnitForPlayer(whichPlayer, whichUnit);
}

function 停止英雄依赖注册队列(this: void): void {
  if (英雄依赖注册队列下一步延迟ID == null) return;
  centerTimer.removeDelayedCallback(英雄依赖注册队列下一步延迟ID);
  英雄依赖注册队列下一步延迟ID = undefined;
}

function 清理英雄依赖注册启动延迟(this: void): void {
  if (英雄依赖注册启动延迟ID == null) return;
  centerTimer.removeDelayedCallback(英雄依赖注册启动延迟ID);
  英雄依赖注册启动延迟ID = undefined;
}

function 处理英雄依赖注册任务一步(this: void, 任务: 英雄依赖注册任务): boolean {
  const owner = 任务.owner;
  const whichHero = 任务.hero;
  if (owner == null || owner === 0 || whichHero == null || whichHero === 0) return true;

  const playerId = jass.GetPlayerId(owner);
  switch (任务.stage) {
    case 0:
      if (typeof registerMoveSpeedTornadoHero === "function") {
        registerMoveSpeedTornadoHero(whichHero);
      }
      break;
    case 1:
      if (typeof petItemHandoff.注册宠物移交英雄 === "function") {
        petItemHandoff.注册宠物移交英雄(whichHero);
      }
      break;
    case 2:
      if (typeof chestSystem.registerChestSystemHero === "function") {
        chestSystem.registerChestSystemHero(whichHero);
      }
      break;
    case 3:
      break;
    case 4:
      debugLog("Bridge", "registerHeroDependents pid=" + playerId + " has=" + uiRegisteredPlayers.has(playerId));
      invokeSelectionCenterInit(owner);
      invokeSelectionCenterSeed(owner, whichHero);
      if (typeof heroVoiceSystem.onPlayerHeroRegistered === "function") {
        heroVoiceSystem.onPlayerHeroRegistered(owner, whichHero);
      }
      break;
    case 5:
      if (!uiRegisteredPlayers.has(playerId)) {
        invokeUiAttrOnPlayerHeroRegistered(owner, whichHero);
      }
      break;
    case 6:
      if (!uiRegisteredPlayers.has(playerId) && typeof dialogSystem.onPlayerHeroRegistered === "function") {
        dialogSystem.onPlayerHeroRegistered(owner, whichHero);
      }
      break;
    case 7:
      if (!uiRegisteredPlayers.has(playerId) && typeof buffUISystem.onPlayerHeroRegistered === "function") {
        buffUISystem.onPlayerHeroRegistered(owner, whichHero);
      }
      break;
    case 8:
      if (!uiRegisteredPlayers.has(playerId)) {
        if (typeof threatPanelSystem.onPlayerHeroRegistered === "function") {
          threatPanelSystem.onPlayerHeroRegistered(owner, whichHero);
        }
        uiRegisteredPlayers.add(playerId);
      }
      return true;
    default:
      return true;
  }
  任务.stage++;
  return false;
}

function on英雄依赖注册队列Tick(this: void): void {
  英雄依赖注册队列下一步延迟ID = undefined;
  if (英雄依赖注册队列.length <= 0) {
    停止英雄依赖注册队列();
    return;
  }
  const 当前任务 = 英雄依赖注册队列[0];
  const 已完成 = 处理英雄依赖注册任务一步(当前任务);
  if (已完成) {
    英雄依赖注册队列.shift();
  }
  if (英雄依赖注册队列.length <= 0) {
    停止英雄依赖注册队列();
    return;
  }
  调度英雄依赖注册队列下一步(英雄依赖注册队列间隔毫秒);
}

function 调度英雄依赖注册队列下一步(this: void, 延迟毫秒: number): void {
  if (英雄依赖注册队列下一步延迟ID != null) return;
  英雄依赖注册队列下一步延迟ID = centerTimer.addDelayedCallback(延迟毫秒, on英雄依赖注册队列Tick);
}

function on启动英雄依赖注册队列(this: void): void {
  英雄依赖注册启动延迟ID = undefined;
  if (英雄依赖注册队列.length <= 0) return;
  调度英雄依赖注册队列下一步(0);
}

function registerHeroDependents(whichHero: any): void {
  const owner = jass.GetOwningPlayer(whichHero);
  if (owner == null || owner === 0) return;
  英雄依赖注册队列.push({
    owner,
    hero: whichHero,
    stage: 0,
  });
  if (英雄依赖注册启动延迟ID == null) {
    英雄依赖注册启动延迟ID = centerTimer.addDelayedCallback(英雄依赖注册启动延迟毫秒, on启动英雄依赖注册队列);
  }
}

function registerPlayerHero(whichPlayer: any, whichHero: any): void {
  if (whichPlayer == null || whichPlayer === 0 || whichHero == null || whichHero === 0) return;
  YDUserDataSet("player", whichPlayer, C.YD_ATTR_PLAYER_HERO_UNIT, "unit", whichHero);
  registerHeroDependents(whichHero);
}

export function directRegisterPlayerHero(this: void, whichPlayer: any, whichHero: any): void {
  registerPlayerHero(whichPlayer, whichHero);
}

export function getRegisteredPlayerHero(this: void, whichPlayer: any): any {
  if (whichPlayer == null || whichPlayer === 0) return null;
  return YDUserDataGet("player", whichPlayer, C.YD_ATTR_PLAYER_HERO_UNIT, "unit");
}

export function 获取玩家英雄单位组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

export function 是玩家英雄组单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;

  const 玩家英雄单位组 = 获取玩家英雄单位组();
  if (玩家英雄单位组 != null && 玩家英雄单位组 !== 0) {
    return jass.IsUnitInGroup(unit, 玩家英雄单位组) === true;
  }

  const owner = jass.GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  return getRegisteredPlayerHero(owner) === unit;
}

function registerSingleHero(whichHero: any): void {
  if (!isPlayableHero(whichHero)) return;

  const owner = jass.GetOwningPlayer(whichHero);
  if (owner == null || owner === 0) return;
  registerPlayerHero(owner, whichHero);
}

export function directRegisterPlayableHero(this: void, whichHero: any): void {
  registerSingleHero(whichHero);
}

function initOutOfCombatSystem(this: void): void {
  const outOfCombat = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.02．脱战计时") as {
    初始化脱战系统?: (this: void) => void;
  };
  const init = outOfCombat.初始化脱战系统;
  if (typeof init === "function") {
    init();
  }
}

export function initPlayerHeroGetBridge(): void {
  清理英雄依赖注册启动延迟();
  初始化玩家人数监听();
  initOutOfCombatSystem();
}

export {};
