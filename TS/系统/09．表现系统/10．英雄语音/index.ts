/** @noSelfInFile */

export * from "./01．闪避音效";
export * from "./02．升级音效";
export * from "./03．死亡音效";
export * from "./04．使用物品音效";
export * from "./05．指令音效";
export * from "./06．击杀音效";
export * from "./07．治疗音效";
export * from "./08．状态音效";
export * from "./09．购物音效";

import { init英雄闪避音效 } from "./01．闪避音效";
import { init英雄升级音效 } from "./02．升级音效";
import { init英雄死亡音效 } from "./03．死亡音效";
import { init英雄使用物品音效 } from "./04．使用物品音效";
import { init英雄指令音效, onPlayerHeroRegistered as on英雄指令音效英雄注册 } from "./05．指令音效";
import { init英雄击杀音效 } from "./06．击杀音效";
import { init英雄治疗音效 } from "./07．治疗音效";
import { init英雄状态音效 } from "./08．状态音效";
import { init英雄购物音效 } from "./09．购物音效";

let 英雄语音系统已初始化 = false;

export function init(this: void): void {
  if (英雄语音系统已初始化) return;
  英雄语音系统已初始化 = true;
  init英雄闪避音效();
  init英雄升级音效();
  init英雄死亡音效();
  init英雄使用物品音效();
  init英雄指令音效();
  init英雄击杀音效();
  init英雄治疗音效();
  init英雄状态音效();
  init英雄购物音效();
}

export function onPlayerHeroRegistered(this: void, whichPlayer: any, whichHero: any): void {
  on英雄指令音效英雄注册(whichPlayer, whichHero);
}
