/**
 * 泄露审计 - 聊天命令触发器
 */
const jass = require("jass.common");
import { dump } from "./09．打印统计";
function onLeakWatcherChat() {
    let tag;
    const raw = jass.GetEventPlayerChatString();
    if (raw != null && raw.length > 5) {
        // 形如 "-leak xxx" -> 取空格后的部分作为 tag
        const idx = raw.indexOf(" ");
        if (idx >= 0 && idx < raw.length - 1) {
            tag = raw.substring(idx + 1).trim();
            if (tag === "")
                tag = undefined;
        }
    }
    dump(tag);
}
/** 注册聊天 "-leak" 触发方式，方便临时查看 */
export function initLeakWatcherTriggers() {
    // 聊天命令：玩家 0 输入 "-leak" 或 "-leak tag" 查看
    const trChat = jass.CreateTrigger();
    jass.TriggerRegisterPlayerChatEvent(trChat, jass.Player(0), "-leak", false);
    jass.TriggerAddAction(trChat, onLeakWatcherChat);
}
// 自动初始化
initLeakWatcherTriggers();
