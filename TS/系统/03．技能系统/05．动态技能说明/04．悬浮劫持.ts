/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => unknown;
};

const { frameSetScriptByCode } = require("lib.扩展函数.封装函数.04．硬件输入.index") as {
  frameSetScriptByCode: (frame: number, eventId: number, action: () => void, sync: boolean, playerId?: number) => void;
};
const {
  EXGetUnitAbility,
  EXGetAbilityDataString,
  EXSetAbilityDataString,
} = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  EXGetUnitAbility: (u: any, abilcode: number) => any;
  EXGetAbilityDataString: (abil: any, level: number, dataType: number) => string;
  EXSetAbilityDataString: (abil: any, level: number, dataType: number, value: string) => boolean;
};
const { getSoleSelectedUnitForPlayer } = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  getSoleSelectedUnitForPlayer: (playerId: number) => any | null;
};
const commandBarAbility = require("系统.03．技能系统.05．动态技能说明.07．命令卡技能槽位") as {
  读取命令卡按钮能力Id: (this: void, x: number, y: number) => number;
};

import {
  ABILITY_DATA_TIP,
  ABILITY_DATA_UBERTIP,
  getDynamicSkillTipText,
  refreshUnitSkillTips,
} from "./01．核心功能";

const FRAME_EVENT_MOUSE_ENTER = 2;
const FRAME_EVENT_MOUSE_LEAVE = 3;
const HOVER_INSTALL_RETRY_SEC = 0.10;
const HOVER_INSTALL_MAX_ATTEMPTS = 50;

type 按钮槽位 = { x: number; y: number };

type 当前劫持状态 = {
  unit: any;
  abilityId: number;
  level: number;
  原始名称: string;
  原始说明: string;
  改了名称: boolean;
  改了说明: boolean;
};

const 技能按钮槽位表: Record<number, 按钮槽位 | undefined> = {};
let 已安装技能按钮悬浮事件 = false;
let 当前状态: 当前劫持状态 | null = null;

function 获取当前触发Frame(): number {
  const frame = japi.DzGetTriggerUIEventFrame();
  if (frame && frame !== 0) return frame;
  return japi.DzGetMouseFocus();
}

function 获取本机唯一选中单位(): any | null {
  const 本机玩家 = jass.GetLocalPlayer();
  if (!本机玩家 || 本机玩家 === 0) return null;
  return getSoleSelectedUnitForPlayer(jass.GetPlayerId(本机玩家));
}

function 解析技能按钮能力Id(x: number, y: number): number {
  return commandBarAbility.读取命令卡按钮能力Id(x, y);
}

function 恢复当前劫持文本(): void {
  if (当前状态 == null) return;

  const ability = EXGetUnitAbility(当前状态.unit, 当前状态.abilityId);
  if (ability) {
    if (当前状态.改了名称) {
      EXSetAbilityDataString(ability, 当前状态.level, ABILITY_DATA_TIP, 当前状态.原始名称);
    }
    if (当前状态.改了说明) {
      EXSetAbilityDataString(ability, 当前状态.level, ABILITY_DATA_UBERTIP, 当前状态.原始说明);
    }
  }

  当前状态 = null;
}

function 应用动态技能文本劫持(unit: any, abilityId: number): void {
  const ability = EXGetUnitAbility(unit, abilityId);
  if (!ability) return;

  const level = jass.GetUnitAbilityLevel(unit, abilityId) || 1;
  EXSetAbilityDataString(ability, level, ABILITY_DATA_UBERTIP, "【悬浮劫持测试】123456");
  const 动态名称 = getDynamicSkillTipText(unit, abilityId, ABILITY_DATA_TIP);
  const 动态说明 = getDynamicSkillTipText(unit, abilityId, ABILITY_DATA_UBERTIP);
  if (动态名称 == null && 动态说明 == null) return;

  const 原始名称 = EXGetAbilityDataString(ability, level, ABILITY_DATA_TIP) || "";
  const 原始说明 = EXGetAbilityDataString(ability, level, ABILITY_DATA_UBERTIP) || "";
  const 改了名称 = 动态名称 != null && 动态名称 !== "";
  const 改了说明 = 动态说明 != null && 动态说明 !== "";

  if (改了名称) {
    EXSetAbilityDataString(ability, level, ABILITY_DATA_TIP, 动态名称!);
  }
  if (改了说明) {
    EXSetAbilityDataString(ability, level, ABILITY_DATA_UBERTIP, 动态说明!);
  }

  当前状态 = {
    unit,
    abilityId,
    level,
    原始名称,
    原始说明,
    改了名称,
    改了说明,
  };
}

function onSkillButtonHoverEnter(): void {
  恢复当前劫持文本();

  const frame = 获取当前触发Frame();
  if (!frame || frame === 0) return;

  const 槽位 = 技能按钮槽位表[frame];
  if (槽位 == null) return;

  const unit = 获取本机唯一选中单位();
  if (unit == null || unit === 0) return;

  const abilityId = 解析技能按钮能力Id(槽位.x, 槽位.y);
  if (!abilityId) return;
  jass.DisplayTextToPlayer(jass.GetLocalPlayer(), 0, 0, "HOVER_OK_" + abilityId.toString());

  应用动态技能文本劫持(unit, abilityId);
}

function onSkillButtonHoverLeave(): void {
  恢复当前劫持文本();
}

function 安装技能按钮悬浮事件(): void {
  if (已安装技能按钮悬浮事件) return;
  已安装技能按钮悬浮事件 = true;

  for (let y = 0; y <= 2; y++) {
    for (let x = 0; x <= 3; x++) {
      const frame = japi.DzFrameGetCommandBarButton(y, x);
      if (!frame || frame === 0) continue;
      if (技能按钮槽位表[frame] != null) continue;

      技能按钮槽位表[frame] = { x, y };
      frameSetScriptByCode(frame, FRAME_EVENT_MOUSE_ENTER, onSkillButtonHoverEnter, false);
      frameSetScriptByCode(frame, FRAME_EVENT_MOUSE_LEAVE, onSkillButtonHoverLeave, false);
    }
  }
}

export function onPlayerHeroRegistered(this: void, whichPlayer: any, whichHero: any): void {
  if (!whichPlayer || whichPlayer === 0 || !whichHero || whichHero === 0) return;
  refreshUnitSkillTips(whichHero);
  安装技能按钮悬浮事件();
}
