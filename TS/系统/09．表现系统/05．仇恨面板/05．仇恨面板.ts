/** @noSelfInFile */
/**
 * 仇恨面板 - 入口
 *
 * 包含初始化入口函数。
 */
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import {
  THREAT_PANEL_PLAYER_UNIT_MAX_PID,
  THREAT_PANEL_PLAYER_SLOTS,
  THREAT_PANEL_REFRESH_MS,
} from "./00．常量定义";
import {
  DzGetGameUI,
  GetLocalPlayer,
  GetPlayerId,
  Player,
} from "./01．共享";
import { 加载仇恨面板Toc, 创建全部玩家面板 } from "./02．面板创建";
import {
  on仇恨面板刷新Tick,
  initLocalThreatPanelVisibilityState,
  toggleLocalThreatPanelVisibility,
  showLocalThreatPanel,
} from "./04．驱动";
import { addPeriodicCallback } from "../../00．核心系统/05．中心计时器";
import { KEY, KEY_STATE, registerKeyEventByCode } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";

let 已初始化 = false;
let 刷新回调ID = 0;
let 已注册V键 = false;

const DzGetTriggerKey = japi.DzGetTriggerKey as () => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  toPlayer: any,
  x: number,
  y: number,
  duration: number,
  message: string
) => void;

const 已自动展开提示玩家表: Record<number, boolean | undefined> = {};

function on仇恨面板V键抬起(this: void, whichPlayer: any, _key: number): void {
  if (whichPlayer == null || whichPlayer === 0) return;
  const playerId = GetPlayerId(whichPlayer);
  if (playerId < 0 || playerId >= THREAT_PANEL_PLAYER_SLOTS) return;
  toggleLocalThreatPanelVisibility(playerId);
  on仇恨面板刷新Tick();
}

function on仇恨面板V键本地回调(this: void): void {
  on仇恨面板V键抬起(GetLocalPlayer(), DzGetTriggerKey());
}

function 注册玩家V键(playerId: number): void {
  if (playerId < 0 || playerId >= THREAT_PANEL_PLAYER_SLOTS) return;
  if (已注册V键) return;
  已注册V键 = true;
  registerKeyEventByCode(KEY.V, KEY_STATE.UP, false, on仇恨面板V键本地回调 as any);
}

export function initThreatPanel(): void {
  if (已初始化) return;
  已初始化 = true;

  const gameUI = DzGetGameUI();
  if (gameUI === 0) return;
  加载仇恨面板Toc();
  initLocalThreatPanelVisibilityState();
  创建全部玩家面板(gameUI);
  on仇恨面板刷新Tick();
  if (刷新回调ID === 0) {
    刷新回调ID = addPeriodicCallback(THREAT_PANEL_REFRESH_MS, on仇恨面板刷新Tick);
  }
}

export function 自动展开仇恨面板一次(this: void, playerId: number): void {
  if (playerId < 0 || playerId >= THREAT_PANEL_PLAYER_SLOTS) return;
  if (已自动展开提示玩家表[playerId] === true) return;

  已自动展开提示玩家表[playerId] = true;
  showLocalThreatPanel(playerId);
  on仇恨面板刷新Tick();

  const 本地玩家 = GetLocalPlayer();
  if (本地玩家 == null || 本地玩家 === 0) return;
  if (GetPlayerId(本地玩家) !== playerId) return;

  DisplayTimedTextToPlayer(
    Player(playerId),
    0,
    0,
    8,
    "|cffffcc33首次进入战斗时会自动打开仇恨面板，之后不再自动展开，按 V 可随时开关。|r"
  );
}

export function onPlayerHeroRegistered(this: void, whichPlayer: any, whichHero: any): void {
  if (whichPlayer == null || whichPlayer === 0) return;
  if (whichHero == null || whichHero === 0) return;

  const playerId = GetPlayerId(whichPlayer);
  if (playerId < 0 || playerId > THREAT_PANEL_PLAYER_UNIT_MAX_PID) return;

  initThreatPanel();
  注册玩家V键(playerId);
  on仇恨面板刷新Tick();
}
