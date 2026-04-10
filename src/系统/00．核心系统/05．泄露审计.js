/**
 * 泄露审计工具（轻量版，TS + TSTL 友好）
 *2026年4月3日20:45:31这个功能暂时停用
 * 功能：
 * - 通过包装常见“容易泄露”的 API（计时器 / 单位组 / 触发器 / 特效 / 矩形 / 雾修正器）
 * - 记录：创建次数、销毁次数、当前存活数量
 * - 每个资源可以带一个 tag（来源标记，例如 "dot伤害" / "装备系统"）
 * - 玩家 0 输入 "-leak" 打印当前统计信息（见 initLeakWatcherTriggers）
 *
 * 注意：
 * - 只能统计“通过本工具包装创建 / 销毁”的资源，旧代码直接调用 JASS 原生的不会被统计到。
 * - 与「jass.debug 遍历句柄 / 火凌之凤 泄露检测」不是同一套数据：那边是引擎里**所有** +snd/+tmr 等；
 *   这里是**仅**走 LeakWatcher 的创建/销毁记账，数值不应与 debug 脚本逐条对比。
 */
const jass = require("jass.common");
const alive = new Map();
const types = ["timer", "group", "trigger", "effect", "rect", "sound", "texttag"];
const stats = {
    timer: { created: 0, destroyed: 0 },
    group: { created: 0, destroyed: 0 },
    trigger: { created: 0, destroyed: 0 },
    effect: { created: 0, destroyed: 0 },
    rect: { created: 0, destroyed: 0 },
    sound: { created: 0, destroyed: 0 },
    texttag: { created: 0, destroyed: 0 },
};
/**
 * Lua 里同一句柄可能以不同引用传入；用 leakType+GetHandleId 作键，避免 delete 对不上导致假 alive。
 * 禁止 `local j=jass; j.GetHandleId(h)`：TSTL 会编成 `j:GetHandleId(h)`，self 传成 jass 表会崩 → 只用 `(jass as any).GetHandleId(h)`。
 * CreateSound 等若返回 table 包装，GetHandleId 会报错 → 用 table 引用当 key（track/untrack 同一对象即可）。
 * 用 TS 的 typeof：Lua 里 table→__TS__TypeOf 为 "object"，userdata 为 "userdata"，不会误判。
 */
function leakKey(leakType, handle) {
    if (handle == null)
        return handle;
    if (typeof handle === "object" && handle !== null) {
        return handle;
    }
    if (typeof jass.GetHandleId === "function") {
        return `${leakType}:${jass.GetHandleId(handle)}`;
    }
    return handle;
}
function track(type, handle, tag) {
    if (!handle)
        return;
    const s = stats[type];
    s.created++;
    alive.set(leakKey(type, handle), { type, tag, createdIndex: s.created });
}
function untrack(type, handle) {
    if (!handle)
        return;
    const s = stats[type];
    if (alive.delete(leakKey(type, handle))) {
        s.destroyed++;
    }
}
export const LeakWatcher = {
    /** 创建计时器（记得用 destroyTimer 回收），tag 代表来源模块 */
    createTimer(tag) {
        const t = jass.CreateTimer();
        track("timer", t, tag);
        return t;
    },
    destroyTimer(t) {
        if (!t)
            return;
        untrack("timer", t);
        if (typeof jass.DestroyTimer === "function") {
            jass.DestroyTimer(t);
        }
    },
    createGroup(tag) {
        const g = jass.CreateGroup();
        track("group", g, tag);
        return g;
    },
    destroyGroup(gp) {
        if (!gp)
            return;
        untrack("group", gp);
        if (typeof jass.DestroyGroup === "function") {
            jass.DestroyGroup(gp);
        }
    },
    createTrigger(tag) {
        const trg = jass.CreateTrigger();
        track("trigger", trg, tag);
        return trg;
    },
    destroyTrigger(trg) {
        if (!trg)
            return;
        untrack("trigger", trg);
        if (typeof jass.DestroyTrigger === "function") {
            jass.DestroyTrigger(trg);
        }
    },
    /** 创建特效：你可以先用原生创建好 effect，再传进来 trackEffect(tag, effect) */
    trackEffect(tag, eff) {
        track("effect", eff, tag);
    },
    destroyEffect(eff) {
        if (!eff)
            return;
        untrack("effect", eff);
        if (typeof jass.DestroyEffect === "function") {
            jass.DestroyEffect(eff);
        }
    },
    trackRect(tag, rect) {
        track("rect", rect, tag);
    },
    removeRect(rect) {
        if (!rect)
            return;
        untrack("rect", rect);
        if (typeof jass.RemoveRect === "function") {
            jass.RemoveRect(rect);
        }
    },
    /** 创建音效：建议搭配 killSoundWhenDone 或 stopSoundAndKill 使用 */
    createSound(tag, fileName, looping, is3D, stopwhenoutofrange, fadeInRate, fadeOutRate, eaxSetting) {
        if (typeof jass.CreateSound !== "function")
            return null;
        const s = jass.CreateSound(fileName, looping, is3D, stopwhenoutofrange, fadeInRate, fadeOutRate, eaxSetting);
        track("sound", s, tag);
        return s;
    },
    /** 标记音效播放完成后销毁，并在本审计中释放引用 */
    killSoundWhenDone(s) {
        if (!s)
            return;
        if (typeof jass.KillSoundWhenDone === "function") {
            jass.KillSoundWhenDone(s);
        }
        // 引擎会在播放完后真正释放；审计层面在这里就算“已回收”，避免 -leak 中 sound 一直堆
        untrack("sound", s);
    },
    /**
     * 仅取消 sound 的审计计数（句柄已由 KillSoundWhenDone/DestroySound 等处理时使用）。
     * 用于 `音效函数` 中「LeakWatcher.createSound + 非 killSoundWhenDone 分支」避免漏 untrack。
     */
    releaseSound(s) {
        untrack("sound", s);
    },
    /** 立刻停止并销毁（更激进，适合需要马上释放时） */
    stopSoundAndKill(s, killWhenDone = true, fadeOut = false) {
        if (!s)
            return;
        if (typeof jass.StopSound === "function") {
            jass.StopSound(s, killWhenDone, fadeOut);
        }
        else if (typeof jass.KillSoundWhenDone === "function") {
            jass.KillSoundWhenDone(s);
        }
        untrack("sound", s);
    },
    /** 创建漂浮文字 texttag（建议搭配 destroyTextTag 回收） */
    createTextTag(tag) {
        if (typeof jass.CreateTextTag !== "function")
            return null;
        const tt = jass.CreateTextTag();
        track("texttag", tt, tag);
        return tt;
    },
    destroyTextTag(tt) {
        if (!tt)
            return;
        untrack("texttag", tt);
        if (typeof jass.DestroyTextTag === "function") {
            jass.DestroyTextTag(tt);
        }
    },
    /** 打印当前统计信息；可选 tagFilter 只查看某个来源 */
    dump(tagFilter) {
        if (typeof jass.DisplayTimedTextToPlayer !== "function")
            return;
        const p0 = jass.Player ? jass.Player(0) : null;
        const printLine = (msg) => {
            if (!p0)
                return;
            jass.DisplayTimedTextToPlayer(p0, 0, 0, 15, msg);
        };
        printLine("=== LeakWatcher 记账 (非 jass.debug 句柄表) ===");
        for (const tp of types) {
            const s = stats[tp];
            const aliveCount = s.created - s.destroyed;
            printLine(`${tp}: alive=${aliveCount}, created=${s.created}, destroyed=${s.destroyed}`);
        }
        if (tagFilter) {
            printLine(`--- 详情 tag=${tagFilter} ---`);
            for (const [handle, info] of alive) {
                if (info.tag === tagFilter) {
                    printLine(`${info.type}#${info.createdIndex} (${info.tag}) [${tostring(handle)}]`);
                }
            }
        }
    },
};
/** 注册聊天 "-leak" 触发方式，方便临时查看 */
function initLeakWatcherTriggers() {
    if (typeof jass.CreateTrigger !== "function" ||
        typeof jass.TriggerAddAction !== "function" ||
        typeof jass.Player !== "function") {
        return;
    }
    // 聊天命令：玩家 0 输入 "-leak" 或 "-leak tag" 查看
    if (typeof jass.TriggerRegisterPlayerChatEvent === "function") {
        const trChat = jass.CreateTrigger();
        jass.TriggerRegisterPlayerChatEvent(trChat, jass.Player(0), "-leak", false);
        jass.TriggerAddAction(trChat, () => {
            let tag;
            if (typeof jass.GetEventPlayerChatString === "function") {
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
            }
            LeakWatcher.dump(tag);
        });
    }
}
initLeakWatcherTriggers();
