/**
 * 任务 UI 入口
 *
 * 职责已拆分至：
 * - 12．任务UI管理器.ts   — 生命周期、显示控制
 * - 13．任务UI预设构建.ts — 帧预设创建
 * - 14．任务UI内容同步.ts — 内容更新
 * - 15．任务UI本地显示.ts — 分类/展开/翻页
 * - 16．任务UI输入绑定.ts — 输入事件注册
 *
 * 本文件保留为入口，向后兼容引用。
 */

import { ENABLE_TASK_UI_CLIENT } from "./04．任务UI拆分/01．任务UI常量";
const manager = require("./04．任务UI拆分/12．任务UI管理器") as {
  taskUI: any; init: () => void; registerHotkey: () => void;
};

export const taskUI = manager.taskUI;

export function init(): void {
  if (!ENABLE_TASK_UI_CLIENT) return;
  manager.init();
}

export function registerHotkey(): void {
  if (!ENABLE_TASK_UI_CLIENT) return;
  manager.registerHotkey();
}
