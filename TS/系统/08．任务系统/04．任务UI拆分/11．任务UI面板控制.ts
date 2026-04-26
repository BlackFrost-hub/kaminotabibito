import { questManager } from "../02．任务管理器/index";

export function registerTaskUIRefreshCallback(rebuildPages: () => void): void {
  if (!questManager || typeof questManager.registerUIRefreshCallback !== "function") return;
  questManager.registerUIRefreshCallback((_playerId: number, _questId?: string) => {
    (pcall as any)(() => rebuildPages());
  });
}
