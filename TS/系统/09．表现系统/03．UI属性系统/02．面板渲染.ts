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
const detailSlots: { player: any; hero: any; functionKey: number; icon: number; box: number; lines: number[] }[] = [];

function createFrame(tagName: string, name: string, parent: number): number {
  if (typeof japi.DzCreateFrameByTagName !== "function") return 0;
  return japi.DzCreateFrameByTagName(tagName, name, parent, "template", 0);
}

function setAbsolute(frame: number, x: number, y: number): void {
  if (frame === 0) return;
  japi.DzFrameSetAbsolutePoint(frame, 常量.ABSOLUTE_POINT_BOTTOMLEFT, x, y);
}

function show(frame: number, visible: boolean): void {
  if (frame === 0 || typeof japi.DzFrameShow !== "function") return;
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
    if (box !== 0) {
      setAbsolute(box, 常量.DETAIL_BOX_X, 常量.DETAIL_BOX_Y);
      japi.DzFrameSetTexture(box, 常量.PANEL_TEXTURE, 0);
      japi.DzFrameSetSize(box, 常量.DETAIL_BOX_WIDTH, 常量.DETAIL_BOX_HEIGHT);
      show(box, false);
    }

    const lines: number[] = [];
    for (let lineIndex = 0; lineIndex < 常量.DETAIL_LINE_LAYOUTS.length; lineIndex++) {
      const pos = 常量.DETAIL_LINE_LAYOUTS[lineIndex];
      const line = createText(box, `UI属性系统属性行${i}_${lineIndex}`, pos.x, pos.y, 常量.DETAIL_FONT_SIZE, "");
      if (line !== 0) {
        japi.DzFrameSetSize(line, 常量.DETAIL_LINE_WIDTH, 常量.DETAIL_LINE_HEIGHT);
        show(line, false);
      }
      lines.push(line);
    }

    const button = createFrame("GLUETEXTBUTTON", "UI属性系统按钮" + i, icon);
    if (button !== 0) {
      japi.DzFrameSetPoint(button, 常量.ABSOLUTE_POINT_BOTTOMLEFT, icon, 常量.ABSOLUTE_POINT_BOTTOMLEFT, 0, 0);
      japi.DzFrameSetSize(button, 常量.HERO_BUTTON_SIZE, 常量.HERO_BUTTON_SIZE);
      japi.DzFrameSetScriptByCode(button, 常量.FRAME_EVENT_MOUSE_ENTER, createDetailHoverAction(i, true), false);
      japi.DzFrameSetScriptByCode(button, 常量.FRAME_EVENT_MOUSE_LEAVE, createDetailHoverAction(i, false), false);
    }

    detailSlots.push({ player, hero, functionKey: 常量.KEY_F[i], icon, box, lines });
  }
}

/**
 * 一次性创建整套 UI 框体。
 * 这里只负责“搭骨架”，具体数值文本由后续刷新函数填充。
 */
export function createUiFrames(): void {
  if (typeof japi.DzGetGameUI !== "function") return;
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
    return detailSlots[i].hero;
  }
  return null;
}

/**
 * 刷新伤害统计面板。
 * 这里既更新伤害数字，也顺手刷新头像，避免玩家英雄替换后 UI 继续显示旧图标。
 */
export function updateDamagePanel(): void {
  for (let i = 0; i < damageRows.length; i++) {
    const row = damageRows[i];
    const hero = getPlayerHero(row.player);
    if (row.icon !== 0) japi.DzFrameSetTexture(row.icon, getHeroIcon(hero), 0);
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
    slot.hero = getPlayerHero(slot.player);
    if (slot.icon !== 0) japi.DzFrameSetTexture(slot.icon, getHeroIcon(slot.hero), 0);
    const texts = buildDetailTexts(slot.player);
    for (let lineIndex = 0; lineIndex < slot.lines.length; lineIndex++) {
      const frame = slot.lines[lineIndex];
      if (frame === 0) continue;
      japi.DzFrameSetText(frame, texts[lineIndex] || "");
    }
  }
}

