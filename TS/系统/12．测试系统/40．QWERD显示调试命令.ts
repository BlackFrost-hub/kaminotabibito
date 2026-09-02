/** @noSelfInFile */
/**
 * QWERD 显示排查聊天命令（临时调试）：
 * 输入 -dc 转储命令卡槽位探测过程与本地选中技能快照，日志走 debugLog("QWERD调试")。
 * 排查爱蜜莉雅等 20-25 英雄 D 技能无冷却/蓝耗显示的问题。
 */

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照") as {
  获取本地选中技能快照: (this: void) => {
    hero: any | null;
    skills: Record<"Q" | "W" | "E" | "R" | "D", number>;
    slots: Record<"Q" | "W" | "E" | "R" | "D", { x: number; y: number }>;
  };
};
const commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位") as {
  调试转储命令卡槽位: (this: void, whichHero: any) => void;
};
const { debugLog } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLog: (this: void, module: string, ...args: any[]) => void;
};

const fourCCConverter = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  fourCCToStringSafe: (this: void, fourcc: number) => string;
};

function onDebugCommand(this: void, _player: any, _command: string): void {
  const snapshot = selectionSnapshotSystem.获取本地选中技能快照();
  const hero = snapshot.hero;
  debugLog("QWERD调试", "===== -dc 快照转储 =====");
  debugLog("QWERD调试", "快照 hero = " + tostring(hero));
  if (hero != null && hero !== 0) {
    debugLog(
      "QWERD调试",
      `快照技能 Q=${tostring(snapshot.skills.Q)} W=${tostring(snapshot.skills.W)} E=${tostring(snapshot.skills.E)} R=${tostring(snapshot.skills.R)} D=${tostring(snapshot.skills.D)}`,
    );
    debugLog(
      "QWERD调试",
      `快照技能ID文本 Q=${fourCCConverter.fourCCToStringSafe(snapshot.skills.Q)} W=${fourCCConverter.fourCCToStringSafe(snapshot.skills.W)} E=${fourCCConverter.fourCCToStringSafe(snapshot.skills.E)} R=${fourCCConverter.fourCCToStringSafe(snapshot.skills.R)} D=${fourCCConverter.fourCCToStringSafe(snapshot.skills.D)}`,
    );
    debugLog(
      "QWERD调试",
      `快照槽位 D=(${snapshot.slots.D.x},${snapshot.slots.D.y})`,
    );
    commandBarAbility.调试转储命令卡槽位(hero);
  } else {
    debugLog("QWERD调试", "本地未选中英雄，快照为空；请先选中英雄再输入 -dc");
  }
  debugLog("QWERD调试", "===== -dc 转储完成 =====");
}

export function 初始化QWERD调试命令(this: void): void {
  注册聊天命令监听("-dc", onDebugCommand);
  debugLog("QWERD调试", "调试命令 -dc 已注册");
}

// 自动初始化（与泄露审计命令同风格，模块被引用即生效）
初始化QWERD调试命令();
