/** @noSelfInFile */
/**
 * 仇恨面板 - 视图模型
 *
 * 包含目标单位获取、仇恨排序、视图模型构建。
 */
import {
  THREAT_PANEL_PLAYER_SLOTS,
  THREAT_PANEL_ROW_COUNT,
} from "./00．常量定义";
import {
  EMPTY_ROW,
  ThreatPanelViewModel,
  获取用于显示的目标单位,
  单位是有效怪物单位,
  截断名称,
  十倍精度文本,
  百分比文本,
  按仇恨降序排序,
  玩家视图模型表,
} from "./01．共享";
import { getEnemyThreatCount, getEnemyThreats, ThreatEntry } from "../../01．单位系统/06．仇恨系统/00．仇恨存储";
import { GetUnitName, GetUnitTypeId, IsUnitType, UNIT_TYPE_DEAD } from "./01．共享";

function 构建空面板模型(提示: string): ThreatPanelViewModel {
  const rowNames: string[] = [];
  const rowPercents: string[] = [];
  const rowThreats: string[] = [];
  for (let i = 0; i < THREAT_PANEL_ROW_COUNT; i++) {
    rowNames.push(EMPTY_ROW);
    rowPercents.push(EMPTY_ROW);
    rowThreats.push(EMPTY_ROW);
  }
  return {
    selectedText: `|cffd8d8d8${提示}|r`,
    summaryText: "|cff8f8f8f这里会显示当前所选敌人的仇恨池摘要|r",
    headerNameText: "|cffc8c8c8目标|r",
    headerPercentText: "|cffc8c8c8占比|r",
    headerThreatText: "|cffc8c8c8仇恨|r",
    rowNameTexts: rowNames,
    rowPercentTexts: rowPercents,
    rowThreatTexts: rowThreats,
  };
}

function 构建玩家仇恨面板模型(playerId: number): ThreatPanelViewModel {
  const 选中单位 = 获取用于显示的目标单位(playerId);
  if (选中单位 == null || 选中单位 === 0) {
    return 构建空面板模型("请选择 1 个敌方单位");
  }
  if (!单位是有效怪物单位(选中单位)) {
    return 构建空面板模型("请选择 1 个敌方单位");
  }

  const 原始列表 = getEnemyThreats(选中单位);
  if (原始列表.length === 0 || getEnemyThreatCount(选中单位) <= 0) {
    return {
      selectedText: `|cffffe6a0目标：${GetUnitName(选中单位)}|r`,
      summaryText: "|cff8f8f8f当前还没有仇恨数据|r",
      headerNameText: "|cffc8c8c8目标|r",
      headerPercentText: "|cffc8c8c8占比|r",
      headerThreatText: "|cffc8c8c8仇恨|r",
      rowNameTexts: [EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW],
      rowPercentTexts: [EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW],
      rowThreatTexts: [EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW],
    };
  }

  const 有效列表: ThreatEntry[] = [];
  for (let i = 0; i < 原始列表.length; i++) {
    const entry = 原始列表[i];
    if (entry == null || entry.targetRef == null || entry.targetRef === 0) continue;
    if (GetUnitTypeId(entry.targetRef) === 0) continue;
    if (IsUnitType(entry.targetRef, UNIT_TYPE_DEAD)) continue;
    有效列表.push(entry);
  }
  if (有效列表.length === 0) {
    return {
      selectedText: `|cffffe6a0目标：${GetUnitName(选中单位)}|r`,
      summaryText: "|cff8f8f8f仇恨表存在，但当前没有有效目标|r",
      headerNameText: "|cffc8c8c8目标|r",
      headerPercentText: "|cffc8c8c8占比|r",
      headerThreatText: "|cffc8c8c8仇恨|r",
      rowNameTexts: [EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW],
      rowPercentTexts: [EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW],
      rowThreatTexts: [EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW, EMPTY_ROW],
    };
  }

  const 排序后列表 = 按仇恨降序排序(有效列表);
  let 总仇恨 = 0;
  for (let i = 0; i < 排序后列表.length; i++) {
    总仇恨 += 排序后列表[i].threat;
  }

  const rowNames: string[] = [];
  const rowPercents: string[] = [];
  const rowThreats: string[] = [];
  for (let i = 0; i < THREAT_PANEL_ROW_COUNT; i++) {
    if (i >= 排序后列表.length) {
      rowNames.push(EMPTY_ROW);
      rowPercents.push(EMPTY_ROW);
      rowThreats.push(EMPTY_ROW);
      continue;
    }
    const entry = 排序后列表[i];
    const 单位名 = `${i + 1}. ${截断名称(GetUnitName(entry.targetRef), 12)}`;
    const 占比文本 = 百分比文本(entry.threat);
    const 仇恨文本 = 十倍精度文本(entry.threat);
    if (i === 0) {
      rowNames.push(`|cffffcc33${单位名}|r`);
      rowPercents.push(`|cffffcc33${占比文本}|r`);
      rowThreats.push(`|cffffcc33${仇恨文本}|r`);
    } else {
      rowNames.push(`|cffd8d8d8${单位名}|r`);
      rowPercents.push(`|cffd8d8d8${占比文本}|r`);
      rowThreats.push(`|cffd8d8d8${仇恨文本}|r`);
    }
  }

  return {
    selectedText: `|cffffe6a0目标：${GetUnitName(选中单位)}|r`,
    summaryText: `|cffb8b8b8总仇恨 ${十倍精度文本(总仇恨)}/1000  目标数 ${排序后列表.length}|r`,
    headerNameText: "|cffc8c8c8目标|r",
    headerPercentText: "|cffc8c8c8占比|r",
    headerThreatText: "|cffc8c8c8仇恨|r",
    rowNameTexts: rowNames,
    rowPercentTexts: rowPercents,
    rowThreatTexts: rowThreats,
  };
}

export function 重建全部视图模型(): void {
  for (let playerId = 0; playerId < THREAT_PANEL_PLAYER_SLOTS; playerId++) {
    玩家视图模型表[playerId] = 构建玩家仇恨面板模型(playerId);
  }
}
