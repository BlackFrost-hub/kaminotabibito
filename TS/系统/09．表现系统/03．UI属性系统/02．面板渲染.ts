/** @noSelfInFile */
/**
 * UI属性系统 - DzFrame 创建与刷新
 */

const japi = require("jass.japi") as any;

const 常量 = require("系统.09．表现系统.03．UI属性系统.00．常量定义") as {
  PANEL_TEXTURE: string;
  ABSOLUTE_POINT_BOTTOMLEFT: number;
  FRAME_EVENT_MOUSE_ENTER: number;
  FRAME_EVENT_MOUSE_LEAVE: number;
  KEY_F: readonly number[];
  DAMAGE_LABELS: readonly string[];
  DAMAGE_COLORS: readonly string[];
  DAMAGE_PANEL_X: number;
  DAMAGE_PANEL_Y: number;
  DAMAGE_PANEL_WIDTH: number;
  DAMAGE_PANEL_HEIGHT: number;
  DAMAGE_PANEL_ALPHA: number;
  DAMAGE_TITLE_Y: number;
  DAMAGE_ICON_X: number;
  DAMAGE_ICON_Y: number;
  DAMAGE_ICON_WIDTH: number;
  DAMAGE_ICON_HEIGHT: number;
  DAMAGE_ROW_STEP: number;
  DAMAGE_VALUE_X: readonly number[];
  HERO_ICON_START_X: number;
  HERO_ICON_STEP_X: number;
  HERO_ICON_Y: number;
  HERO_ICON_WIDTH: number;
  HERO_ICON_HEIGHT: number;
  HERO_KEY_Y: number;
  HERO_BUTTON_SIZE: number;
  DETAIL_BOX_X: number;
  DETAIL_BOX_Y: number;
  DETAIL_BOX_WIDTH: number;
  DETAIL_BOX_HEIGHT: number;
  DETAIL_LINE_WIDTH: number;
  DETAIL_LINE_HEIGHT: number;
  DETAIL_FONT_SIZE: number;
  DETAIL_SEPARATOR_FONT_SIZE: number;
  DETAIL_START_Y: number;
  DETAIL_ROW_STEP: number;
  DETAIL_LEFT_X: number;
  DETAIL_MID_X: number;
  DETAIL_RIGHT_X: number;
  DETAIL_SEP1_X: number;
  DETAIL_SEP2_X: number;
  DETAIL_SEPARATOR_WIDTH: number;
  DETAIL_SEPARATOR_HEIGHT_MULT: number;
  DETAIL_SEPARATOR_Y_OFFSET: number;
  DETAIL_SEPARATOR_X_OFFSET: number;
  DETAIL_SEP_START_ROW: number;
  DETAIL_SEP_END_ROW: number;
  DETAIL_LINE_LAYOUTS: readonly { x: number; y: number }[];
};
const {
  buildDetailTexts,
  formatInteger,
  getDamageValues,
  getDisplayPlayers,
  getHeroIcon,
  getPlayerHero,
} = require("系统.09．表现系统.03．UI属性系统.01．属性工具") as {
  buildDetailTexts: (this: void, player: any) => string[];
  formatInteger: (this: void, value: number) => string;
  getDamageValues: (this: void, player: any) => number[];
  getDisplayPlayers: (this: void) => any[];
  getHeroIcon: (this: void, hero: any) => string;
  getPlayerHero: (this: void, player: any) => any;
};

let damagePanel = 0;
const damageRows: { icon: number; values: number[]; player: any }[] = [];
const detailSlots: { player: any; hero: any; functionKey: number; icon: number; box: number; lines: number[]; separators: number[] }[] = [];

function createFrame(tagName: string, name: string, parent: number): number {
  return japi.DzCreateFrameByTagName(tagName, name, parent, "template", 0);
}

function setAbsolute(frame: number, x: number, y: number): void {
  if (frame === 0) return;
  japi.DzFrameSetAbsolutePoint(frame, 常量.ABSOLUTE_POINT_BOTTOMLEFT, x, y);
}

function show(frame: number, visible: boolean): void {
  if (frame === 0) return;
  japi.DzFrameShow(frame, visible);
}

function createText(parent: number, name: string, x: number, y: number, size: number, text: string): number {
  const frame = createFrame("TEXT", name, parent);
  if (frame === 0) return 0;
  setAbsolute(frame, x, y);
  japi.DzFrameSetText(frame, text);
  japi.DzFrameSetFont(frame, "UI\\uizt.ttf", size, 0);
  return frame;
}

function showDetailSlot(index: number, visible: boolean): void {
  const slot = detailSlots[index];
  if (slot == null) return;
  show(slot.box, visible);
  for (let i = 0; i < slot.lines.length; i++) {
    show(slot.lines[i], visible);
  }
  for (let i = 0; i < slot.separators.length; i++) {
    show(slot.separators[i], visible);
  }
}

function createDetailHoverAction(index: number, visible: boolean): () => void {
  return () => {
    showDetailSlot(index, visible);
  };
}

/**
 * 创建左侧伤害统计面板。
 * 结构直接对应原 JASS：标题行 + 每名玩家一行头像和三列数值。
 */
function createDamagePanel(gameUI: number, players: any[]): void {
  damagePanel = createFrame("BACKDROP", "UI属性系统伤害统计", gameUI);
  if (damagePanel === 0) return;

  japi.DzFrameSetTexture(damagePanel, 常量.PANEL_TEXTURE, 0);
  setAbsolute(damagePanel, 常量.DAMAGE_PANEL_X, 常量.DAMAGE_PANEL_Y);
  japi.DzFrameSetSize(damagePanel, 常量.DAMAGE_PANEL_WIDTH, 常量.DAMAGE_PANEL_HEIGHT);
  japi.DzFrameSetAlpha(damagePanel, 常量.DAMAGE_PANEL_ALPHA);
  show(damagePanel, false);

  for (let i = 0; i < 常量.DAMAGE_LABELS.length; i++) {
    createText(damagePanel, "UI属性系统伤害标题" + i, 常量.DAMAGE_VALUE_X[i], 常量.DAMAGE_TITLE_Y, 0.012, 常量.DAMAGE_LABELS[i]);
  }

  for (let i = 0; i < players.length; i++) {
    const player = players[i];
    const hero = getPlayerHero(player);
    const rowY = 常量.DAMAGE_ICON_Y - 常量.DAMAGE_ROW_STEP * i;
    const icon = createFrame("BACKDROP", "UI属性系统伤害头像" + i, damagePanel);
    if (icon !== 0) {
      setAbsolute(icon, 常量.DAMAGE_ICON_X, rowY);
      japi.DzFrameSetTexture(icon, getHeroIcon(hero), 0);
      japi.DzFrameSetSize(icon, 常量.DAMAGE_ICON_WIDTH, 常量.DAMAGE_ICON_HEIGHT);
      show(icon, true);
    }

    const values: number[] = [];
    for (let col = 0; col < 常量.DAMAGE_VALUE_X.length; col++) {
      values.push(createText(damagePanel, `UI属性系统伤害值${i}_${col}`, 常量.DAMAGE_VALUE_X[col], 常量.DAMAGE_TITLE_Y - 常量.DAMAGE_ROW_STEP * (i + 1), 0.009, "0"));
    }
    damageRows.push({ icon, values, player });
  }
}

/**
 * 创建顶部英雄头像入口与悬浮属性框。
 * 每个槽位绑定一个玩家，后续刷新时只更新头像与文本，不重复建框。
 */
function createDetailSlots(gameUI: number, players: any[]): void {
  for (let i = 0; i < players.length; i++) {
    const player = players[i];
    const hero = getPlayerHero(player);
    const iconX = 常量.HERO_ICON_START_X + 常量.HERO_ICON_STEP_X * i;

    const icon = createFrame("BACKDROP", "UI属性系统英雄头像" + i, gameUI);
    if (icon !== 0) {
      setAbsolute(icon, iconX, 常量.HERO_ICON_Y);
      japi.DzFrameSetSize(icon, 常量.HERO_ICON_WIDTH, 常量.HERO_ICON_HEIGHT);
      japi.DzFrameSetTexture(icon, getHeroIcon(hero), 0);
      show(icon, true);
    }

    // 先创建快捷键文本（在icon上，同一父节点下先创建的优先级低）
    createText(icon, "UI属性系统快捷键" + i, iconX, 常量.HERO_KEY_Y, 0.009, `|cffffff00F${i + 2}|r`);

    // 后创建文本框，优先级高于快捷键文本，会覆盖它
    const box = createFrame("BACKDROP", "UI属性系统文本框" + i, icon);
    const lines: number[] = [];
    const separators: number[] = [];

    if (box !== 0) {
      setAbsolute(box, 常量.DETAIL_BOX_X, 常量.DETAIL_BOX_Y);
      japi.DzFrameSetTexture(box, 常量.PANEL_TEXTURE, 0);
      japi.DzFrameSetSize(box, 常量.DETAIL_BOX_WIDTH, 常量.DETAIL_BOX_HEIGHT);
      show(box, false);

      // 创建普通文本行（5列：左、分隔符1、中、分隔符2、右）
      // 使用相对于box的相对坐标
      for (let lineIndex = 0; lineIndex < 常量.DETAIL_LINE_LAYOUTS.length; lineIndex++) {
        const pos = 常量.DETAIL_LINE_LAYOUTS[lineIndex];
        const isSeparatorCol = lineIndex % 5 === 1 || lineIndex % 5 === 3; // 第2列和第4列是分隔符

        if (!isSeparatorCol) {
          // 普通文本行 - 使用相对坐标（相对于box）
          const line = createFrame("TEXT", `UI属性系统属性行${i}_${lineIndex}`, box);
          if (line !== 0) {
            japi.DzFrameSetPoint(line, 常量.ABSOLUTE_POINT_BOTTOMLEFT, box, 常量.ABSOLUTE_POINT_BOTTOMLEFT, pos.x, pos.y);
            japi.DzFrameSetSize(line, 常量.DETAIL_LINE_WIDTH, 常量.DETAIL_LINE_HEIGHT);
            japi.DzFrameSetFont(line, "UI\\uizt.ttf", 常量.DETAIL_FONT_SIZE, 0);
            show(line, false);
            lines.push(line);
          }
        }
      }

      // 计算分隔符的Y坐标范围（使用常量）
      const sepStartY = 常量.DETAIL_START_Y - 常量.DETAIL_ROW_STEP * 常量.DETAIL_SEP_START_ROW;
      const sepEndY = 常量.DETAIL_START_Y - 常量.DETAIL_ROW_STEP * 常量.DETAIL_SEP_END_ROW;
      const sepTotalHeight = (sepStartY - sepEndY + 常量.DETAIL_LINE_HEIGHT) * 常量.DETAIL_SEPARATOR_HEIGHT_MULT;
      const sepWidth = 常量.DETAIL_SEPARATOR_WIDTH;
      const sepRelY = sepEndY + 常量.DETAIL_SEPARATOR_Y_OFFSET;

      // 左中分隔符 - 使用BACKDROP创建纯色竖线
      const sep1 = createFrame("BACKDROP", `UI属性系统分隔符1_${i}`, box);
      if (sep1 !== 0) {
        japi.DzFrameSetPoint(sep1, 常量.ABSOLUTE_POINT_BOTTOMLEFT, box, 常量.ABSOLUTE_POINT_BOTTOMLEFT, 常量.DETAIL_SEP1_X + 常量.DETAIL_SEPARATOR_X_OFFSET, sepRelY);
        japi.DzFrameSetSize(sep1, sepWidth, sepTotalHeight);
        japi.DzFrameSetTexture(sep1, "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0);
        // 这里实测会触发 JAPI "frame type invalid"，因此直接使用纹理本色，避免非法着色调用。
        japi.DzFrameSetPriority(sep1, 0);
        show(sep1, false);
        separators.push(sep1);
      }

      // 中右分隔符 - 使用BACKDROP创建纯色竖线
      const sep2 = createFrame("BACKDROP", `UI属性系统分隔符2_${i}`, box);
      if (sep2 !== 0) {
        japi.DzFrameSetPoint(sep2, 常量.ABSOLUTE_POINT_BOTTOMLEFT, box, 常量.ABSOLUTE_POINT_BOTTOMLEFT, 常量.DETAIL_SEP2_X + 常量.DETAIL_SEPARATOR_X_OFFSET, sepRelY);
        japi.DzFrameSetSize(sep2, sepWidth, sepTotalHeight);
        japi.DzFrameSetTexture(sep2, "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0);
        // 同上：不要对该分隔线 frame 调用 DzFrameSetVertexColor。
        japi.DzFrameSetPriority(sep2, 0);
        show(sep2, false);
        separators.push(sep2);
      }
    }

    const button = createFrame("GLUETEXTBUTTON", "UI属性系统按钮" + i, icon);
    if (button !== 0) {
      japi.DzFrameSetPoint(button, 常量.ABSOLUTE_POINT_BOTTOMLEFT, icon, 常量.ABSOLUTE_POINT_BOTTOMLEFT, 0, 0);
      japi.DzFrameSetSize(button, 常量.HERO_BUTTON_SIZE, 常量.HERO_BUTTON_SIZE);
      japi.DzFrameSetScriptByCode(button, 常量.FRAME_EVENT_MOUSE_ENTER, createDetailHoverAction(i, true), false);
      japi.DzFrameSetScriptByCode(button, 常量.FRAME_EVENT_MOUSE_LEAVE, createDetailHoverAction(i, false), false);
    }

    detailSlots.push({ player, hero, functionKey: 常量.KEY_F[i], icon, box, lines, separators });
  }
}

/**
 * 一次性创建整套 UI 框体。
 * 这里只负责“搭骨架”，具体数值文本由后续刷新函数填充。
 */
export function createUiFrames(): void {
  const gameUI = japi.DzGetGameUI();
  if (gameUI == null || gameUI === 0) return;

  const players = getDisplayPlayers();
  createDamagePanel(gameUI, players);
  createDetailSlots(gameUI, players);
  updateDamagePanel();
  updateDetailPanels();
}

export function showDamagePanel(visible: boolean): void {
  show(damagePanel, visible);
}

export function focusHeroByFunctionKey(functionKey: number): any {
  for (let i = 0; i < detailSlots.length; i++) {
    if (detailSlots[i].functionKey !== functionKey) continue;
    // 与 JASS 一致：每次按键从玩家「英雄」数据取当前单位，不用创建时缓存的 handle
    return getPlayerHero(detailSlots[i].player);
  }
  return null;
}

/**
 * 刷新伤害统计面板（仅三列数值文本）。
 * 与 `属性查看.j` 周期回调一致：头像 `DzFrameSetTexture` 只在创建时设一次，定时器里不刷头像。
 */
export function updateDamagePanel(): void {
  for (let i = 0; i < damageRows.length; i++) {
    const row = damageRows[i];
    const values = getDamageValues(row.player);
    for (let col = 0; col < row.values.length; col++) {
      const frame = row.values[col];
      if (frame === 0) continue;
      japi.DzFrameSetText(frame, 常量.DAMAGE_COLORS[col] + formatInteger(values[col]) + "|r");
    }
  }
}

/**
 * 刷新顶部头像对应的属性详情文本。
 * 文本内容完全由属性工具层统一生成，这里只负责回写到 DzFrame。
 */
export function updateDetailPanels(): void {
  for (let i = 0; i < detailSlots.length; i++) {
    const slot = detailSlots[i];
    const texts = buildDetailTexts(slot.player);
    let lineIdx = 0;
    for (let textIndex = 0; textIndex < texts.length; textIndex++) {
      const isSeparatorCol = textIndex % 5 === 1 || textIndex % 5 === 3;
      if (!isSeparatorCol) {
        const frame = slot.lines[lineIdx];
        if (frame !== 0) {
          japi.DzFrameSetText(frame, texts[textIndex] || "");
        }
        lineIdx++;
      }
    }
  }
}
