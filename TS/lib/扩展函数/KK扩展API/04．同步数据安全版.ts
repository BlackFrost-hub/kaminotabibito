/** @noSelfInFile */

const japi = require("jass.japi") as any;

/** 发送一条低频同步数据。 */
export function DzSyncDataSafe(this: void, prefix: string, data: string): void {
  if (prefix == null || prefix === "") return;
  japi.DzSyncData(prefix, data == null ? "" : data);
}

/** 为触发器注册同步数据事件。 */
export function DzTriggerRegisterSyncDataSafe(this: void, trig: any, prefix: string, server: boolean): void {
  if (trig == null || trig === 0 || prefix == null || prefix === "") return;
  japi.DzTriggerRegisterSyncData(trig, prefix, server);
}

/** 获取当前同步消息的发送玩家。 */
export function DzGetTriggerSyncPlayerSafe(this: void): any {
  return japi.DzGetTriggerSyncPlayer();
}

/** 获取当前同步消息的数据。 */
export function DzGetTriggerSyncDataSafe(this: void): string {
  return (japi.DzGetTriggerSyncData() as string) || "";
}

export {};
