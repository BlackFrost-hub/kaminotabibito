const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { PercentTo255 } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  PercentTo255: (this: void, percentage: number) => number;
};

// ===========================================================================
// 多面板全局变量（Blizzard.j）
// ===========================================================================

export let bj_lastCreatedMultiboard: any = jglobals.bj_lastCreatedMultiboard ?? null;
export let bj_lastCreatedMultiboardItem: any = jglobals.bj_lastCreatedMultiboardItem ?? null;

// ===========================================================================
// 多面板BJ函数（对齐blizzard.j）
// ===========================================================================

/** 创建多面板 - CreateMultiboardBJ */
export function CreateMultiboardBJ(cols: number, rows: number, title: string): any {
  bj_lastCreatedMultiboard = jass.CreateMultiboard();
  if (bj_lastCreatedMultiboard == null) return null;
  jass.MultiboardSetRowCount(bj_lastCreatedMultiboard, rows);
  jass.MultiboardSetColumnCount(bj_lastCreatedMultiboard, cols);
  jass.MultiboardSetTitleText(bj_lastCreatedMultiboard, title);
  jass.MultiboardDisplay(bj_lastCreatedMultiboard, true);
  return bj_lastCreatedMultiboard;
}

/** 销毁多面板 - DestroyMultiboardBJ */
export function DestroyMultiboardBJ(mb: any): void {
  if (mb == null) return;
  jass.DestroyMultiboard(mb);
}

/** 获取最后创建的多面板 - GetLastCreatedMultiboard */
export function GetLastCreatedMultiboard(): any {
  return bj_lastCreatedMultiboard;
}

/** 显示/隐藏多面板 - MultiboardDisplayBJ */
export function MultiboardDisplayBJ(show: boolean, mb: any): void {
  if (mb == null) return;
  jass.MultiboardDisplay(mb, show);
}

/** 最小化/还原多面板 - MultiboardMinimizeBJ */
export function MultiboardMinimizeBJ(minimize: boolean, mb: any): void {
  if (mb == null) return;
  jass.MultiboardMinimize(mb, minimize);
}

/** 设置多面板标题颜色 - MultiboardSetTitleTextColorBJ */
export function MultiboardSetTitleTextColorBJ(
  mb: any,
  red: number,
  green: number,
  blue: number,
  transparency: number
): void {
  if (mb == null) return;
  jass.MultiboardSetTitleTextColor(
    mb,
    PercentTo255(red),
    PercentTo255(green),
    PercentTo255(blue),
    PercentTo255(100 - transparency)
  );
}

/** 允许/禁止多面板显示 - MultiboardAllowDisplayBJ */
export function MultiboardAllowDisplayBJ(flag: boolean): void {
  jass.MultiboardSuppressDisplay(!flag);
}

/** 设置多面板项目样式 - MultiboardSetItemStyleBJ */
export function MultiboardSetItemStyleBJ(
  mb: any,
  col: number,
  row: number,
  showValue: boolean,
  showIcon: boolean
): void {
  if (mb == null) return;
  const numRows = jass.MultiboardGetRowCount(mb);
  const numCols = jass.MultiboardGetColumnCount(mb);

  for (let curRow = 1; curRow <= numRows; curRow++) {
    if (row !== 0 && row !== curRow) continue;
    for (let curCol = 1; curCol <= numCols; curCol++) {
      if (col !== 0 && col !== curCol) continue;
      const item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1);
      if (item != null) {
        jass.MultiboardSetItemStyle(item, showValue, showIcon);
        jass.MultiboardReleaseItem(item);
      }
    }
  }
}

/** 设置多面板项目值 - MultiboardSetItemValueBJ */
export function MultiboardSetItemValueBJ(mb: any, col: number, row: number, val: string): void {
  if (mb == null) return;
  const numRows = jass.MultiboardGetRowCount(mb);
  const numCols = jass.MultiboardGetColumnCount(mb);

  for (let curRow = 1; curRow <= numRows; curRow++) {
    if (row !== 0 && row !== curRow) continue;
    for (let curCol = 1; curCol <= numCols; curCol++) {
      if (col !== 0 && col !== curCol) continue;
      const item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1);
      if (item != null) {
        jass.MultiboardSetItemValue(item, val);
        jass.MultiboardReleaseItem(item);
      }
    }
  }
}

/** 设置多面板项目颜色 - MultiboardSetItemColorBJ */
export function MultiboardSetItemColorBJ(
  mb: any,
  col: number,
  row: number,
  red: number,
  green: number,
  blue: number,
  transparency: number
): void {
  if (mb == null) return;
  const numRows = jass.MultiboardGetRowCount(mb);
  const numCols = jass.MultiboardGetColumnCount(mb);

  for (let curRow = 1; curRow <= numRows; curRow++) {
    if (row !== 0 && row !== curRow) continue;
    for (let curCol = 1; curCol <= numCols; curCol++) {
      if (col !== 0 && col !== curCol) continue;
      const item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1);
      if (item != null) {
        jass.MultiboardSetItemValueColor(
          item,
          PercentTo255(red),
          PercentTo255(green),
          PercentTo255(blue),
          PercentTo255(100 - transparency)
        );
        jass.MultiboardReleaseItem(item);
      }
    }
  }
}

/** 设置多面板项目宽度 - MultiboardSetItemWidthBJ */
export function MultiboardSetItemWidthBJ(mb: any, col: number, row: number, width: number): void {
  if (mb == null) return;
  const numRows = jass.MultiboardGetRowCount(mb);
  const numCols = jass.MultiboardGetColumnCount(mb);

  for (let curRow = 1; curRow <= numRows; curRow++) {
    if (row !== 0 && row !== curRow) continue;
    for (let curCol = 1; curCol <= numCols; curCol++) {
      if (col !== 0 && col !== curCol) continue;
      const item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1);
      if (item != null) {
        jass.MultiboardSetItemWidth(item, width / 100);
        jass.MultiboardReleaseItem(item);
      }
    }
  }
}

/** 设置多面板项目图标 - MultiboardSetItemIconBJ */
export function MultiboardSetItemIconBJ(mb: any, col: number, row: number, iconFileName: string): void {
  if (mb == null) return;
  const numRows = jass.MultiboardGetRowCount(mb);
  const numCols = jass.MultiboardGetColumnCount(mb);

  for (let curRow = 1; curRow <= numRows; curRow++) {
    if (row !== 0 && row !== curRow) continue;
    for (let curCol = 1; curCol <= numCols; curCol++) {
      if (col !== 0 && col !== curCol) continue;
      const item = jass.MultiboardGetItem(mb, curRow - 1, curCol - 1);
      if (item != null) {
        jass.MultiboardSetItemIcon(item, iconFileName);
        jass.MultiboardReleaseItem(item);
      }
    }
  }
}

/** 获取最后创建的多面板项目 - GetLastCreatedMultiboardItem */
export function GetLastCreatedMultiboardItem(): any {
  return bj_lastCreatedMultiboardItem;
}

export {};
