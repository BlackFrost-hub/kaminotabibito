// ========== 虚拟分区：模块加载 ==========
const NPC生成器 = require("系统.08．任务系统.00．配置表.04．NPC生成器") as { init?: () => void };
if (typeof NPC生成器.init === "function") NPC生成器.init();
require("系统.09．表现系统.04．NPC对话状态池");
const 对话框UI = require("系统.09．表现系统.03．对话框系统.00．对话框UI入口") as { initDialogSystem?: () => void };
if (typeof 对话框UI.initDialogSystem === "function") 对话框UI.initDialogSystem();

// ========== 虚拟分区：导出 ==========
export * from "./index";

