/**
 * 16．任务UI输入绑定
 * 职责：统一管理键盘/鼠标/滚轮的事件注册。
 * 当前作为现有输入模块的聚合入口，后续逐步接管注册逻辑。
 */

export { registerTaskUIHotkeys } from "./05．任务UI热键";
export { registerTaskUIListWheel, updateTaskUIScrollBarVisibility, isTaskUIWheelTarget } from "./10．任务UI滚动与滚轮";
