/**
 * 泄露审计 - 聊天命令触发器
 */

const jass = require("jass.common") as Record<string, unknown>;
import { dump } from "./09．打印统计";

/** 注册聊天 "-leak" 触发方式，方便临时查看 */
export function initLeakWatcherTriggers(): void {
  if (
    typeof (jass as any).CreateTrigger !== "function" ||
    typeof (jass as any).TriggerAddAction !== "function" ||
    typeof (jass as any).Player !== "function"
  ) {
    return;
  }

  // 聊天命令：玩家 0 输入 "-leak" 或 "-leak tag" 查看
  if (typeof (jass as any).TriggerRegisterPlayerChatEvent === "function") {
    const trChat = (jass as any).CreateTrigger();
    (jass as any).TriggerRegisterPlayerChatEvent(
      trChat,
      (jass as any).Player(0),
      "-leak",
      false,
    );
    (jass as any).TriggerAddAction(trChat, () => {
      let tag: string | undefined;
      if (typeof (jass as any).GetEventPlayerChatString === "function") {
        const raw = (jass as any).GetEventPlayerChatString() as string;
        if (raw != null && raw.length > 5) {
          // 形如 "-leak xxx" -> 取空格后的部分作为 tag
          const idx = raw.indexOf(" ");
          if (idx >= 0 && idx < raw.length - 1) {
            tag = raw.substring(idx + 1).trim();
            if (tag === "") tag = undefined;
          }
        }
      }
      dump(tag);
    });
  }
}

// 自动初始化
initLeakWatcherTriggers();
