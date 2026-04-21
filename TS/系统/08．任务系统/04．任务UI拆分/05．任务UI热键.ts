/**
 * 任务面板键盘快捷键
 *
 * 与界面文案一致：入口显示「任务(J)」；面板打开时 1/2/3 切换分类（主线/支线/小任务）。
 * 所有回调均包在 pcall 内，避免按键线程里异常打断后续注册。
 */

import { QuestType } from "../01．任务数据";

const jass = require("jass.common") as any;

/**
 * `DzTriggerRegisterKeyEventTrg` 内部 sync=true：全客户端同一时刻都会跑回调。
 * 任务面板是纯本地 UI，仅当「按下键的玩家 === 本机操控玩家」时才处理（见 dzapi/ui-frame-types 键盘 sync 规则）。
 */
function isTriggerKeyForLocalPlayer(triggerPlayer: any): boolean {
  const lp = jass.GetLocalPlayer();
  if (triggerPlayer == null || lp == null) return false;
  const getPid = (jass as any).GetPlayerId as ((p: any) => number) | undefined;
  if (getPid == null) return false;
  return getPid(triggerPlayer) === getPid(lp);
}

export interface RegisterTaskUIHotkeysOpts {
  /** 来自硬件输入模块，需为函数才会注册 */
  registerKeyDown: any;
  KEY: any;
  KEY_NUM: any;
  onClickSound: () => void;
  /** 展开/收起任务主面板 */
  onTogglePanel: () => void;
  onSwitchCategory: (type: QuestType) => void;
  /** 主面板是否可见；数字键仅在打开时切换分类，避免误触 */
  isVisible: () => boolean;
  /** J 键会带上事件玩家，用于多玩家本地 UI 状态 */
  setCurrentPlayerId: (pid: number) => void;
}

/**
 * 注册 J、1、2、3：J 随时可开关面板；1/2/3 仅在面板可见时切换 QuestType。
 */
export function registerTaskUIHotkeys(opts: RegisterTaskUIHotkeysOpts): void {
  const { registerKeyDown, KEY, KEY_NUM, onClickSound, onTogglePanel, onSwitchCategory, isVisible, setCurrentPlayerId } = opts;
  if (typeof registerKeyDown !== "function") return;

  // J：本地玩家按下时切换面板，并尽量同步「当前操作玩家」id（供 UI 逻辑使用）
  registerKeyDown(KEY.J, (player: any) => {
    (pcall as any)(() => {
      if (!isTriggerKeyForLocalPlayer(player)) return;

      const getPid = (jass as any).GetPlayerId;
      if (getPid && player) setCurrentPlayerId(getPid(player));
      onClickSound();
      onTogglePanel();
    });
  });

  // 1 → 主线
  registerKeyDown(KEY_NUM.K1, (player: any) => {
    (pcall as any)(() => {
      if (!isTriggerKeyForLocalPlayer(player)) return;
      if (!isVisible()) return;
      onClickSound();
      onSwitchCategory(QuestType.MAIN);
    });
  });

  // 2 → 支线
  registerKeyDown(KEY_NUM.K2, (player: any) => {
    (pcall as any)(() => {
      if (!isTriggerKeyForLocalPlayer(player)) return;
      if (!isVisible()) return;
      onClickSound();
      onSwitchCategory(QuestType.SIDE);
    });
  });

  // 3 → 小任务/日常
  registerKeyDown(KEY_NUM.K3, (player: any) => {
    (pcall as any)(() => {
      if (!isTriggerKeyForLocalPlayer(player)) return;
      if (!isVisible()) return;
      onClickSound();
      onSwitchCategory(QuestType.DAILY);
    });
  });
}
