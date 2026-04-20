const japi = require("jass.japi") as any;

/**
 * KK扩展API - 事件注册函数
 *
 * 这些是对底层 DzAPI 的封装，简化事件注册流程
 */

/**
 * 注册鼠标事件触发器
 *
 * @param trg 触发器
 * @param status 状态（0=按下，1=释放，2=点击）
 * @param btn 鼠标按钮
 */
export function DzTriggerRegisterMouseEventTrg(trg: any, status: number, btn: number): void {
  if (trg == null) return;
  japi.DzTriggerRegisterMouseEvent(trg, btn, status, true, null);
}

/**
 * 注册键盘事件触发器
 *
 * @param trg 触发器
 * @param status 状态（0=按下，1=释放）
 * @param btn 键盘按键（键码或字符）
 */
export function DzTriggerRegisterKeyEventTrg(trg: any, status: number, btn: number | string): void {
  if (trg == null) return;
  japi.DzTriggerRegisterKeyEvent(trg, btn, status, true, null);
}

/**
 * 注册鼠标移动事件触发器
 *
 * @param trg 触发器
 */
export function DzTriggerRegisterMouseMoveEventTrg(trg: any): void {
  if (trg == null) return;
  japi.DzTriggerRegisterMouseMoveEvent(trg, true, null);
}

/**
 * 注册鼠标滚轮事件触发器
 *
 * @param trg 触发器
 */
export function DzTriggerRegisterMouseWheelEventTrg(trg: any): void {
  if (trg == null) return;
  japi.DzTriggerRegisterMouseWheelEvent(trg, true, null);
}

/**
 * 注册窗口大小改变事件触发器
 *
 * @param trg 触发器
 */
export function DzTriggerRegisterWindowResizeEventTrg(trg: any): void {
  if (trg == null) return;
  japi.DzTriggerRegisterWindowResizeEvent(trg, true, null);
}

/**
 * 浮点数转整数（类型转换）
 */
export function DzF2I(i: number): number {
  return i;
}

/**
 * 整数转浮点数（类型转换）
 */
export function DzI2F(i: number): number {
  return i;
}

/**
 * 按键码转整数（类型转换）
 */
export function DzK2I(i: number): number {
  return i;
}

/**
 * 整数转按键码（类型转换）
 */
export function DzI2K(i: number): number {
  return i;
}

/**
 * 注册商城物品同步数据事件
 *
 * @param trig 触发器
 */
export function DzTriggerRegisterMallItemSyncData(trig: any): void {
  japi.DzTriggerRegisterSyncData(trig, "DZMIA", true);
}

/**
 * 获取触发商城物品的玩家
 */
export function DzGetTriggerMallItemPlayer(): any {
  return japi.DzGetTriggerSyncPlayer();
}

/**
 * 获取触发的商城物品
 */
export function DzGetTriggerMallItem(): string {
  return (japi.DzGetTriggerSyncData() as string) || "";
}

export {};
