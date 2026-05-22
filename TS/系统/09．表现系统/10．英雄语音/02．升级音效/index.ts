/** @noSelfInFile */

export * from "./00．配置";
export * from "./01．英雄升级音效";

import { init英雄升级音效系统 } from "./01．英雄升级音效";

let 英雄升级音效模块已初始化 = false;

export function init英雄升级音效(this: void): void {
  if (英雄升级音效模块已初始化) return;
  英雄升级音效模块已初始化 = true;
  init英雄升级音效系统();
}

