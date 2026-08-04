/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 同步硬件输入中心
 *
 * 统一收口 `*Trg` 同步入口。回调会在全端对称触发，业务侧用 player 判断输入所属玩家。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const DzTriggerRegisterKeyEvent = japi.DzTriggerRegisterKeyEvent as (
  this: void,
  trigger: any,
  key: number | string,
  status: number,
  sync: boolean,
  callbackName: any,
) => void;
const DzTriggerRegisterMouseEvent = japi.DzTriggerRegisterMouseEvent as (
  this: void,
  trigger: any,
  button: number,
  status: number,
  sync: boolean,
  callbackName: any,
) => void;
const DzTriggerRegisterMouseMoveEvent = japi.DzTriggerRegisterMouseMoveEvent as (
  this: void,
  trigger: any,
  sync: boolean,
  callbackName: any,
) => void;
const DzTriggerRegisterMouseWheelEvent = japi.DzTriggerRegisterMouseWheelEvent as (
  this: void,
  trigger: any,
  sync: boolean,
  callbackName: any,
) => void;

import { MOUSE_BUTTON, MOUSE_STATE } from "./01．常量定义";
import { createTriggerOrNull } from "./02．内部工具";

export interface 同步键盘事件 {
  player: any;
  key: number;
  status: number;
}

export interface 同步鼠标事件 {
  player: any;
  button: number;
  status: number;
  terrainX: number;
  terrainY: number;
  terrainZ: number;
  screenX: number;
  screenY: number;
  isOverUI: boolean;
}

export interface 同步鼠标移动事件 {
  player: any;
  terrainX: number;
  terrainY: number;
  terrainZ: number;
  screenX: number;
  screenY: number;
  isOverUI: boolean;
}

export interface 同步鼠标滚轮事件 extends 同步鼠标移动事件 {
  delta: number;
}

export type 同步键盘回调 = (this: void, event: 同步键盘事件) => void;
export type 同步鼠标回调 = (this: void, event: 同步鼠标事件) => void;
export type 同步鼠标移动回调 = (this: void, event: 同步鼠标移动事件) => void;
export type 同步鼠标滚轮回调 = (this: void, event: 同步鼠标滚轮事件) => void;

const keyCallbacksByKeyAndStatus: Record<string, 同步键盘回调[] | undefined> = {};
const mouseCallbacksByButtonAndStatus: Record<string, 同步鼠标回调[] | undefined> = {};
const moveCallbacks: 同步鼠标移动回调[] = [];
const wheelCallbacks: 同步鼠标滚轮回调[] = [];

const keyTriggerContextByHandle: Record<number, { key: number | string; status: number } | undefined> = {};
const mouseTriggerContextByHandle: Record<number, { button: number; status: number } | undefined> = {};

let mouseMoveTrigger: any = null;
let mouseWheelTrigger: any = null;

function getDispatchKey(this: void, a: number | string, b: number): string {
  return tostring(a) + ":" + tostring(b);
}

function registerSyncKeyToTrigger(this: void, trigger: any, status: number, key: number | string): void {
  DzTriggerRegisterKeyEvent(trigger, key, status, true, null);
}

function registerSyncMouseButtonToTrigger(this: void, trigger: any, status: number, button: number): void {
  DzTriggerRegisterMouseEvent(trigger, button, status, true, null);
}

function registerSyncMouseMoveToTrigger(this: void, trigger: any): void {
  DzTriggerRegisterMouseMoveEvent(trigger, true, null);
}

function registerSyncMouseWheelToTrigger(this: void, trigger: any): void {
  DzTriggerRegisterMouseWheelEvent(trigger, true, null);
}

function getTriggerInputPlayer(this: void): any {
  const player = japi.DzGetTriggerKeyPlayer();
  if (player != null && player !== 0) return player;
  return null;
}

function getMouseMoveEvent(this: void): 同步鼠标移动事件 {
  return {
    player: getTriggerInputPlayer(),
    terrainX: japi.DzGetMouseTerrainX(),
    terrainY: japi.DzGetMouseTerrainY(),
    terrainZ: japi.DzGetMouseTerrainZ(),
    screenX: japi.DzGetMouseX(),
    screenY: japi.DzGetMouseY(),
    isOverUI: !!japi.DzIsMouseOverUI(),
  };
}

function getMouseButtonEvent(this: void, button: number, status: number): 同步鼠标事件 {
  const moveEvent = getMouseMoveEvent();
  return {
    player: moveEvent.player,
    button,
    status,
    terrainX: moveEvent.terrainX,
    terrainY: moveEvent.terrainY,
    terrainZ: moveEvent.terrainZ,
    screenX: moveEvent.screenX,
    screenY: moveEvent.screenY,
    isOverUI: moveEvent.isOverUI,
  };
}

function getMouseWheelEvent(this: void): 同步鼠标滚轮事件 {
  const moveEvent = getMouseMoveEvent();
  return {
    player: moveEvent.player,
    terrainX: moveEvent.terrainX,
    terrainY: moveEvent.terrainY,
    terrainZ: moveEvent.terrainZ,
    screenX: moveEvent.screenX,
    screenY: moveEvent.screenY,
    isOverUI: moveEvent.isOverUI,
    delta: japi.DzGetWheelDelta(),
  };
}

function dispatchKeyCallbacks(this: void, callbacks: 同步键盘回调[] | undefined, event: 同步键盘事件): void {
  if (callbacks == null) return;
  for (let i = 0; i < callbacks.length; i++) {
    const callback = callbacks[i];
    if (callback != null) callback(event);
  }
}

function dispatchMouseCallbacks(this: void, callbacks: 同步鼠标回调[] | undefined, event: 同步鼠标事件): void {
  if (callbacks == null) return;
  for (let i = 0; i < callbacks.length; i++) {
    const callback = callbacks[i];
    if (callback != null) callback(event);
  }
}

function onSyncHardwareKey(this: void): void {
  const trigger = jass.GetTriggeringTrigger();
  if (trigger == null || trigger === 0) return;
  const handleId = jass.GetHandleId(trigger) as number;
  const context = keyTriggerContextByHandle[handleId];
  if (context == null) return;
  const key = japi.DzGetTriggerKey();
  const player = getTriggerInputPlayer();
  const callbacks = keyCallbacksByKeyAndStatus[getDispatchKey(context.key, context.status)];
  dispatchKeyCallbacks(callbacks, {
    player,
    key,
    status: context.status,
  });
}

function onSyncHardwareMouseButton(this: void): void {
  const trigger = jass.GetTriggeringTrigger();
  if (trigger == null || trigger === 0) return;
  const context = mouseTriggerContextByHandle[jass.GetHandleId(trigger) as number];
  if (context == null) return;
  dispatchMouseCallbacks(
    mouseCallbacksByButtonAndStatus[getDispatchKey(context.button, context.status)],
    getMouseButtonEvent(context.button, context.status)
  );
}

function onSyncHardwareMouseMove(this: void): void {
  const event = getMouseMoveEvent();
  for (let i = 0; i < moveCallbacks.length; i++) {
    const callback = moveCallbacks[i];
    if (callback != null) callback(event);
  }
}

function onSyncHardwareMouseWheel(this: void): void {
  const event = getMouseWheelEvent();
  for (let i = 0; i < wheelCallbacks.length; i++) {
    const callback = wheelCallbacks[i];
    if (callback != null) callback(event);
  }
}

export function registerSyncHardwareKey(
  this: void,
  key: number | string,
  status: number,
  callback: 同步键盘回调
): any {
  const dispatchKey = getDispatchKey(key, status);
  let callbacks = keyCallbacksByKeyAndStatus[dispatchKey];
  if (callbacks == null) {
    callbacks = [];
    keyCallbacksByKeyAndStatus[dispatchKey] = callbacks;
    const trigger = createTriggerOrNull();
    if (trigger == null || trigger === 0) return null;
    const handleId = jass.GetHandleId(trigger) as number;
    keyTriggerContextByHandle[handleId] = { key, status };
    registerSyncKeyToTrigger(trigger, status, key);
    jass.TriggerAddAction(trigger, onSyncHardwareKey);
  }
  callbacks.push(callback);
  return true;
}

export function registerSyncHardwareMouseButton(
  this: void,
  button: number,
  status: number,
  callback: 同步鼠标回调
): any {
  const dispatchKey = getDispatchKey(button, status);
  let callbacks = mouseCallbacksByButtonAndStatus[dispatchKey];
  if (callbacks == null) {
    callbacks = [];
    mouseCallbacksByButtonAndStatus[dispatchKey] = callbacks;
    const trigger = createTriggerOrNull();
    if (trigger == null || trigger === 0) return null;
    mouseTriggerContextByHandle[jass.GetHandleId(trigger) as number] = { button, status };
    registerSyncMouseButtonToTrigger(trigger, status, button);
    jass.TriggerAddAction(trigger, onSyncHardwareMouseButton);
  }
  callbacks.push(callback);
  return true;
}

export function registerSyncHardwareMouseMove(this: void, callback: 同步鼠标移动回调): any {
  if (mouseMoveTrigger == null || mouseMoveTrigger === 0) {
    mouseMoveTrigger = createTriggerOrNull();
    if (mouseMoveTrigger == null || mouseMoveTrigger === 0) return null;
    registerSyncMouseMoveToTrigger(mouseMoveTrigger);
    jass.TriggerAddAction(mouseMoveTrigger, onSyncHardwareMouseMove);
  }
  moveCallbacks.push(callback);
  return true;
}

export function registerSyncHardwareMouseWheel(this: void, callback: 同步鼠标滚轮回调): any {
  if (mouseWheelTrigger == null || mouseWheelTrigger === 0) {
    mouseWheelTrigger = createTriggerOrNull();
    if (mouseWheelTrigger == null || mouseWheelTrigger === 0) return null;
    registerSyncMouseWheelToTrigger(mouseWheelTrigger);
    jass.TriggerAddAction(mouseWheelTrigger, onSyncHardwareMouseWheel);
  }
  wheelCallbacks.push(callback);
  return true;
}

export function registerSyncHardwareRightMouseDown(this: void, callback: 同步鼠标回调): any {
  return registerSyncHardwareMouseButton(MOUSE_BUTTON.RIGHT, MOUSE_STATE.DOWN, callback);
}

export function registerSyncHardwareRightMouseUp(this: void, callback: 同步鼠标回调): any {
  return registerSyncHardwareMouseButton(MOUSE_BUTTON.RIGHT, MOUSE_STATE.UP, callback);
}
