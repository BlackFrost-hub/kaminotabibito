/** @noSelfInFile */
/**
 * 仇恨面板 - 驱动
 *
 * 包含刷新Tick、对称写入、本地可见性控制。
 */
import {
  THREAT_PANEL_PLAYER_SLOTS,
  THREAT_PANEL_ROW_COUNT,
} from "./00．常量定义";
import {
  DzFrameSetText,
  DzFrameShow,
  GetLocalPlayer,
  GetPlayerId,
  EMPTY_ROW,
  玩家面板表,
  玩家面板显示状态表,
  玩家视图模型表,
} from "./01．共享";
import { 重建全部视图模型 } from "./03．视图模型";

function 对称写入全部面板文本(): void {
  for (let playerId = 0; playerId < THREAT_PANEL_PLAYER_SLOTS; playerId++) {
    const panel = 玩家面板表[playerId];
    const vm = 玩家视图模型表[playerId];
    if (panel == null || vm == null) continue;
    DzFrameSetText(panel.selected, vm.selectedText);
    DzFrameSetText(panel.summary, vm.summaryText);
    DzFrameSetText(panel.headerName, vm.headerNameText);
    DzFrameSetText(panel.headerPercent, vm.headerPercentText);
    DzFrameSetText(panel.headerThreat, vm.headerThreatText);
    for (let i = 0; i < THREAT_PANEL_ROW_COUNT; i++) {
      DzFrameSetText(panel.rowNames[i], vm.rowNameTexts[i] ?? EMPTY_ROW);
      DzFrameSetText(panel.rowPercents[i], vm.rowPercentTexts[i] ?? EMPTY_ROW);
      DzFrameSetText(panel.rowThreats[i], vm.rowThreatTexts[i] ?? EMPTY_ROW);
    }
  }
}

function 应用本地可见性(): void {
  const 本机玩家 = GetLocalPlayer();
  if (本机玩家 == null || 本机玩家 === 0) return;
  const 本机玩家ID = GetPlayerId(本机玩家);
  for (let playerId = 0; playerId < THREAT_PANEL_PLAYER_SLOTS; playerId++) {
    const panel = 玩家面板表[playerId];
    if (panel == null) continue;
    const visible = playerId === 本机玩家ID && 玩家面板显示状态表[playerId] === true;
    DzFrameShow(panel.root, visible);
    if (panel.inner !== 0) DzFrameShow(panel.inner, visible);
    if (panel.title !== 0) DzFrameShow(panel.title, visible);
    if (panel.selected !== 0) DzFrameShow(panel.selected, visible);
    if (panel.summary !== 0) DzFrameShow(panel.summary, visible);
    if (panel.headerName !== 0) DzFrameShow(panel.headerName, visible);
    if (panel.headerPercent !== 0) DzFrameShow(panel.headerPercent, visible);
    if (panel.headerThreat !== 0) DzFrameShow(panel.headerThreat, visible);
    for (let i = 0; i < panel.rowNames.length; i++) {
      if (panel.rowNames[i] !== 0) DzFrameShow(panel.rowNames[i], visible);
      if (panel.rowPercents[i] !== 0) DzFrameShow(panel.rowPercents[i], visible);
      if (panel.rowThreats[i] !== 0) DzFrameShow(panel.rowThreats[i], visible);
    }
  }
}

export function on仇恨面板刷新Tick(this: void): void {
  重建全部视图模型();
  对称写入全部面板文本();
  应用本地可见性();
}
