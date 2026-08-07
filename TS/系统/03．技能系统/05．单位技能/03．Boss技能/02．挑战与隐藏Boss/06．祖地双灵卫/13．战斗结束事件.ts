/** @noSelfInFile */

export type 祖地双灵卫战斗结束监听器 = (this: void, 赤誓灵卫: any, 苍影灵卫: any) => void;

const 战斗结束监听器列表: 祖地双灵卫战斗结束监听器[] = [];

export function register祖地双灵卫战斗结束Listener(this: void, listener: 祖地双灵卫战斗结束监听器): void {
  if (typeof listener !== "function") return;
  for (let i = 0; i < 战斗结束监听器列表.length; i++) {
    if (战斗结束监听器列表[i] === listener) return;
  }
  战斗结束监听器列表.push(listener);
}

export function 派发祖地双灵卫战斗结束(this: void, 赤誓灵卫: any, 苍影灵卫: any): void {
  for (let i = 0; i < 战斗结束监听器列表.length; i++) {
    战斗结束监听器列表[i](赤誓灵卫, 苍影灵卫);
  }
}

