/** @noSelfInFile */

export * from "./00．配置";
export * from "./01．英雄闪避音效";

import { init英雄闪避音效系统 } from "./01．英雄闪避音效";

let 英雄闪避音效已初始化 = false;

export function init英雄闪避音效(this: void): void {
  if (英雄闪避音效已初始化) return;
  英雄闪避音效已初始化 = true;
  init英雄闪避音效系统();
}

