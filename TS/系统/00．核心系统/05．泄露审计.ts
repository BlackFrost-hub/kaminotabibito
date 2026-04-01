/**
 * 泄露审计工具（轻量版，TS + TSTL 友好）
 *
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

const jass = require("jass.common") as Record<string, unknown>;

// 目前只审计“理应被排泄”的资源：
// - 计时器 / 单位组 / 触发器 / 临时特效 / 临时矩形
// - 不记录长期存在的资源（例如可见度修正器 FogModifier），避免把设计上的常驻对象也当成泄露
type LeakType = "timer" | "group" | "trigger" | "effect" | "rect" | "sound" | "texttag";

interface LeakInfo {
  type: LeakType;
  tag: string;
  createdIndex: number;
}

const alive = new Map<any, LeakInfo>();
const types: LeakType[] = ["timer", "group", "trigger", "effect", "rect", "sound", "texttag"];

const stats: Record<LeakType, { created: number; destroyed: number }> = {
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
function leakKey(leakType: LeakType, handle: any): any {
  if (handle == null) return handle;
  if (typeof handle === "object" && handle !== null) {
    return handle;
  }
  if (typeof (jass as any).GetHandleId === "function") {
    return `${leakType}:${(jass as any).GetHandleId(handle)}`;
  }
  return handle;
}

function track(type: LeakType, handle: any, tag: string): void {
  if (!handle) return;
  const s = stats[type];
  s.created++;
  alive.set(leakKey(type, handle), { type, tag, createdIndex: s.created });
}

function untrack(type: LeakType, handle: any): void {
  if (!handle) return;
  const s = stats[type];
  if (alive.delete(leakKey(type, handle))) {
    s.destroyed++;
  }
}

export const LeakWatcher = {
  /** 创建计时器（记得用 destroyTimer 回收），tag 代表来源模块 */
  createTimer(tag: string): any {
    const t = (jass as any).CreateTimer();
    track("timer", t, tag);
    return t;
  },
  destroyTimer(t: any): void {
    if (!t) return;
    untrack("timer", t);
    if (typeof (jass as any).DestroyTimer === "function") {
      (jass as any).DestroyTimer(t);
    }
  },

  createGroup(tag: string): any {
    const g = (jass as any).CreateGroup();
    track("group", g, tag);
    return g;
  },
  destroyGroup(gp: any): void {
    if (!gp) return;
    untrack("group", gp);
    if (typeof (jass as any).DestroyGroup === "function") {
      (jass as any).DestroyGroup(gp);
    }
  },

  createTrigger(tag: string): any {
    const trg = (jass as any).CreateTrigger();
    track("trigger", trg, tag);
    return trg;
  },
  destroyTrigger(trg: any): void {
    if (!trg) return;
    untrack("trigger", trg);
    if (typeof (jass as any).DestroyTrigger === "function") {
      (jass as any).DestroyTrigger(trg);
    }
  },

  /** 创建特效：你可以先用原生创建好 effect，再传进来 trackEffect(tag, effect) */
  trackEffect(tag: string, eff: any): void {
    track("effect", eff, tag);
  },
  destroyEffect(eff: any): void {
    if (!eff) return;
    untrack("effect", eff);
    if (typeof (jass as any).DestroyEffect === "function") {
      (jass as any).DestroyEffect(eff);
    }
  },

  trackRect(tag: string, rect: any): void {
    track("rect", rect, tag);
  },
  removeRect(rect: any): void {
    if (!rect) return;
    untrack("rect", rect);
    if (typeof (jass as any).RemoveRect === "function") {
      (jass as any).RemoveRect(rect);
    }
  },

  /** 创建音效：建议搭配 killSoundWhenDone 或 stopSoundAndKill 使用 */
  createSound(
    tag: string,
    fileName: string,
    looping: boolean,
    is3D: boolean,
    stopwhenoutofrange: boolean,
    fadeInRate: number,
    fadeOutRate: number,
    eaxSetting: string,
  ): any {
    if (typeof (jass as any).CreateSound !== "function") return null;
    const s = (jass as any).CreateSound(
      fileName,
      looping,
      is3D,
      stopwhenoutofrange,
      fadeInRate,
      fadeOutRate,
      eaxSetting,
    );
    track("sound", s, tag);
    return s;
  },

  /** 标记音效播放完成后销毁，并在本审计中释放引用 */
  killSoundWhenDone(s: any): void {
    if (!s) return;
    if (typeof (jass as any).KillSoundWhenDone === "function") {
      (jass as any).KillSoundWhenDone(s);
    }
    // 引擎会在播放完后真正释放；审计层面在这里就算“已回收”，避免 -leak 中 sound 一直堆
    untrack("sound", s);
  },

  /**
   * 仅取消 sound 的审计计数（句柄已由 KillSoundWhenDone/DestroySound 等处理时使用）。
   * 用于 `音效函数` 中「LeakWatcher.createSound + 非 killSoundWhenDone 分支」避免漏 untrack。
   */
  releaseSound(s: any): void {
    untrack("sound", s);
  },

  /** 立刻停止并销毁（更激进，适合需要马上释放时） */
  stopSoundAndKill(s: any, killWhenDone: boolean = true, fadeOut: boolean = false): void {
    if (!s) return;
    if (typeof (jass as any).StopSound === "function") {
      (jass as any).StopSound(s, killWhenDone, fadeOut);
    } else if (typeof (jass as any).KillSoundWhenDone === "function") {
      (jass as any).KillSoundWhenDone(s);
    }
    untrack("sound", s);
  },

  /** 创建漂浮文字 texttag（建议搭配 destroyTextTag 回收） */
  createTextTag(tag: string): any {
    if (typeof (jass as any).CreateTextTag !== "function") return null;
    const tt = (jass as any).CreateTextTag();
    track("texttag", tt, tag);
    return tt;
  },
  destroyTextTag(tt: any): void {
    if (!tt) return;
    untrack("texttag", tt);
    if (typeof (jass as any).DestroyTextTag === "function") {
      (jass as any).DestroyTextTag(tt);
    }
  },

  /** 打印当前统计信息；可选 tagFilter 只查看某个来源 */
  dump(tagFilter?: string): void {
    if (typeof (jass as any).DisplayTimedTextToPlayer !== "function") return;
    const p0 = (jass as any).Player ? (jass as any).Player(0) : null;

    const printLine = (msg: string): void => {
      if (!p0) return;
      (jass as any).DisplayTimedTextToPlayer(p0, 0, 0, 15, msg);
    };

    printLine("=== LeakWatcher 记账 (非 jass.debug 句柄表) ===");
    for (const tp of types) {
      const s = stats[tp];
      const aliveCount = s.created - s.destroyed;
      printLine(
        `${tp}: alive=${aliveCount}, created=${s.created}, destroyed=${s.destroyed}`,
      );
    }

    if (tagFilter) {
      printLine(`--- 详情 tag=${tagFilter} ---`);
      for (const [handle, info] of alive) {
        if (info.tag === tagFilter) {
          printLine(
            `${info.type}#${info.createdIndex} (${info.tag}) [${tostring(
              handle,
            )}]`,
          );
        }
      }
    }
  },
};

/** 注册聊天 "-leak" 触发方式，方便临时查看 */
function initLeakWatcherTriggers(): void {
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
      LeakWatcher.dump(tag);
    });
  }
}

initLeakWatcherTriggers();
export {};

