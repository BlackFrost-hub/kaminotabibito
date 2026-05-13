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
  玩家面板显示状态表,
} from "./01．共享";
import { 加载仇恨面板Toc, 创建全部玩家面板 } from "./02．面板创建";
import { on仇恨面板刷新Tick } from "./04．驱动";
import { addPeriodicCallback } from "../../00．核心系统/05．中心计时器";
import { KEY } from "../../../lib/扩展函数/封装函数/04．硬件输入/01．常量定义";
import { KEY_STATE } from "../../../lib/扩展函数/封装函数/04．硬件输入/01．常量定义";

let 已初始化 = false;
let 刷新回调ID = 0;
const 已注册热键玩家表: Record<number, boolean | undefined> = {};

const CreateTrigger = jass.CreateTrigger as () => any;
const DzTriggerRegisterKeyEventByCode = japi.DzTriggerRegisterKeyEventByCode as (
  trig: any,
  keyCode: number,
  status: number,
  sync: boolean,
  action: () => void
) => void;
const DzGetTriggerKeyPlayer = japi.DzGetTriggerKeyPlayer as () => any;
const DzGetTriggerKey = japi.DzGetTriggerKey as () => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  toPlayer: any,
  x: number,
  y: number,
  duration: number,
  message: string
) => void;

const 已自动展开提示玩家表: Record<number, boolean | undefined> = {};

function 初始化玩家显示状态(): void {
  for (let playerId = 0; playerId < THREAT_PANEL_PLAYER_SLOTS; playerId++) {
    if (玩家面板显示状态表[playerId] == null) {
      玩家面板显示状态表[playerId] = false;
    }
  }
}

function on仇恨面板V键抬起(this: void, whichPlayer: any, _key: number): void {
  if (whichPlayer == null || whichPlayer === 0) return;
  const playerId = GetPlayerId(whichPlayer);
  if (playerId < 0 || playerId >= THREAT_PANEL_PLAYER_SLOTS) return;
  玩家面板显示状态表[playerId] = 玩家面板显示状态表[playerId] !== true;
  on仇恨面板刷新Tick();
}

function on仇恨面板V键本地回调(this: void): void {
  on仇恨面板V键抬起(DzGetTriggerKeyPlayer(), DzGetTriggerKey());
}

function 注册玩家V键(playerId: number): void {
  if (playerId < 0 || playerId >= THREAT_PANEL_PLAYER_SLOTS) return;
  if (已注册热键玩家表[playerId] === true) return;
  const 本地玩家 = GetLocalPlayer();
  if (本地玩家 == null || 本地玩家 === 0) return;
  if (GetPlayerId(本地玩家) !== playerId) return;
  已注册热键玩家表[playerId] = true;
  const trig = CreateTrigger();
  if (trig == null || trig === 0) return;
  DzTriggerRegisterKeyEventByCode(trig, KEY.V, KEY_STATE.UP, false, on仇恨面板V键本地回调);
}

export function initThreatPanel(): void {
  if (已初始化) return;
  已初始化 = true;

  const gameUI = DzGetGameUI();
  if (gameUI === 0) return;
  加载仇恨面板Toc();
  初始化玩家显示状态();
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
  玩家面板显示状态表[playerId] = true;
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
