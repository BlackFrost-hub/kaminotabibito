/** @noSelfInFile */

export * from "./00．配置";
export * from "./01．英雄死亡音效";

import { init英雄死亡音效系统 } from "./01．英雄死亡音效";

let 英雄死亡音效模块已初始化 = false;

export function init英雄死亡音效(this: void): void {
  if (英雄死亡音效模块已初始化) return;
  英雄死亡音效模块已初始化 = true;
  init英雄死亡音效系统();
}

