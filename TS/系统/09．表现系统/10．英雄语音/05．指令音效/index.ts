/** @noSelfInFile */

export * from "./00．配置";
export * from "./01．英雄指令音效";

import { init英雄指令音效系统, onPlayerHeroRegistered as on英雄指令音效英雄注册 } from "./01．英雄指令音效";

let 英雄指令音效模块已初始化 = false;

export function init英雄指令音效(this: void): void {
  if (英雄指令音效模块已初始化) return;
  英雄指令音效模块已初始化 = true;
  init英雄指令音效系统();
}

export function onPlayerHeroRegistered(this: void, whichPlayer: any, whichHero: any): void {
  on英雄指令音效英雄注册(whichPlayer, whichHero);
}

