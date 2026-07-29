/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const StartSound = jass.StartSound as (this: void, soundHandle: any) => void;

/** 对应 GUI“任务消息”列表；相同原生声音的消息类型仍保留独立语义名。 */
export type 原生任务音效类型 =
  | "发现任务"
  | "任务更新"
  | "任务完成"
  | "任务失败"
  | "任务要求"
  | "关卡失败"
  | "提示"
  | "简单提示"
  | "秘密"
  | "警告"
  | "获得新单位"
  | "新单位可用"
  | "收到新物品";

function 获取原生任务音效句柄(this: void, 类型: 原生任务音效类型): any {
  switch (类型) {
    case "发现任务": return jglobals.bj_questDiscoveredSound;
    case "任务更新": return jglobals.bj_questUpdatedSound;
    case "任务完成": return jglobals.bj_questCompletedSound;
    case "任务失败":
    case "关卡失败": return jglobals.bj_questFailedSound;
    case "提示":
    case "简单提示":
    case "获得新单位":
    case "新单位可用": return jglobals.bj_questHintSound;
    case "秘密": return jglobals.bj_questSecretSound;
    case "警告": return jglobals.bj_questWarningSound;
    case "收到新物品": return jglobals.bj_questItemAcquiredSound;
    // Blizzard.j 的“任务要求”消息只显示文本，没有配套 StartSound。
    case "任务要求": return null;
  }
}

/**
 * 只播放任务消息所对应的魔兽原生音效，不显示任务文本。
 * whichPlayer 为空时全体客户端播放；传玩家时只在该玩家本机播放。
 */
export function 播放原生任务音效(this: void, 类型: 原生任务音效类型, whichPlayer?: any): void {
  if (whichPlayer != null && whichPlayer !== 0 && GetLocalPlayer() !== whichPlayer) return;
  const soundHandle = 获取原生任务音效句柄(类型);
  if (soundHandle == null || soundHandle === 0) return;
  StartSound(soundHandle);
}

export {};
