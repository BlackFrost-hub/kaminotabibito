import {
  LIST_ITEM_H,
  LIST_CONTAINER_W,
  LIST_CONTENT_LEFT_INSET,
  QUEST_ROW_ICON_HEIGHT_FACTOR,
  QUEST_ROW_ICON_PAD_LEFT,
  QUEST_ROW_TEXT_GAP_AFTER_ICON,
} from "./01．任务UI常量";
import { DZ_TEXT_ALIGN_CENTER, DZ_TEXT_ALIGN_LEFT } from "../../00．核心系统/03．UI函数";

export interface TaskListItemLayout {
  rowWidth: number;
  rowLeftRel: number;
  iconHLayout: number;
  textXRel: number;
  listTextAlign: number;
  textW: number;
}

export function calcTaskListItemLayout(showMainRowIcon: boolean): TaskListItemLayout {
  const rowWidth = LIST_CONTAINER_W * 0.9;
  const rowLeftRel = LIST_CONTENT_LEFT_INSET;
  const collapsedMainRowH = LIST_ITEM_H * 0.4;
  const iconHLayout = showMainRowIcon ? collapsedMainRowH * QUEST_ROW_ICON_HEIGHT_FACTOR : 0;
  const textXRel = showMainRowIcon
    ? rowLeftRel + QUEST_ROW_ICON_PAD_LEFT + iconHLayout + QUEST_ROW_TEXT_GAP_AFTER_ICON
    : rowLeftRel + 0.03;
  const listTextAlign = showMainRowIcon ? DZ_TEXT_ALIGN_LEFT : DZ_TEXT_ALIGN_CENTER;
  const rowTitleRightInset = 0.01;
  const textW = rowWidth - (textXRel - rowLeftRel) - rowTitleRightInset;

  return {
    rowWidth,
    rowLeftRel,
    iconHLayout,
    textXRel,
    listTextAlign,
    textW,
  };
}

export function resolveQuestRowIconPath(icon: string | undefined): string {
  if (icon && icon !== "") return icon;
  return "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp";
}
