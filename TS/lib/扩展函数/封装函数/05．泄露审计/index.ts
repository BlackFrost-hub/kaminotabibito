/**
 * 泄露审计工具（轻量版，TS + TSTL 友好）
 * 2026年4月3日20:45:31这个功能暂时停用
 *
 * 功能：
 * - 通过包装常见"容易泄露"的 API（计时器 / 单位组 / 触发器 / 特效 / 矩形 / 雾修正器）
 * - 记录：创建次数、销毁次数、当前存活数量
 * - 每个资源可以带一个 tag（来源标记，例如 "dot伤害" / "装备系统"）
 * - 玩家 0 输入 "-leak" 打印当前统计信息（见 initLeakWatcherTriggers）
 *
 * 注意：
 * - 只能统计"通过本工具包装创建 / 销毁"的资源，旧代码直接调用 JASS 原生的不会被统计到。
 * - 与「jass.debug 遍历句柄 / 火凌之凤 泄露检测」不是同一套数据：那边是引擎里**所有** +snd/+tmr 等；
 *   这里是**仅**走 LeakWatcher 的创建/销毁记账，数值不应与 debug 脚本逐条对比。
 */

// ========== 核心统计 ==========
export * from "./01．核心统计";

// ========== 资源审计 ==========
export * from "./02．计时器审计";
export * from "./03．单位组审计";
export * from "./04．触发器审计";
export * from "./05．特效审计";
export * from "./06．矩形审计";
export * from "./07．音效审计";
export * from "./08．漂浮文字审计";

// ========== 统计与命令 ==========
export * from "./09．打印统计";
export * from "./10．聊天命令";

// 为了保持向后兼容，提供 LeakWatcher 对象
import * as core from "./01．核心统计";
import * as timer from "./02．计时器审计";
import * as group from "./03．单位组审计";
import * as trigger from "./04．触发器审计";
import * as effect from "./05．特效审计";
import * as rect from "./06．矩形审计";
import * as sound from "./07．音效审计";
import * as texttag from "./08．漂浮文字审计";
import { dump } from "./09．打印统计";

export const LeakWatcher = {
  createTimer: timer.createTimer,
  destroyTimer: timer.destroyTimer,
  createGroup: group.createGroup,
  destroyGroup: group.destroyGroup,
  createTrigger: trigger.createTrigger,
  destroyTrigger: trigger.destroyTrigger,
  trackEffect: effect.trackEffect,
  destroyEffect: effect.destroyEffect,
  trackRect: rect.trackRect,
  removeRect: rect.removeRect,
  createSound: sound.createSound,
  killSoundWhenDone: sound.killSoundWhenDone,
  releaseSound: sound.releaseSound,
  stopSoundAndKill: sound.stopSoundAndKill,
  createTextTag: texttag.createTextTag,
  destroyTextTag: texttag.destroyTextTag,
  dump: dump,
};
