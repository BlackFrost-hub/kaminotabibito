/**
 * 任务 UI 本地显示控制（阶段4）
 *
 * 职责：只做已预设帧的 show/hide，不创建帧、不写 bookkeeping、不触发重建。
 */

import { QuestType } from "../01．任务数据";
import { TaskUIPrecreatedListPool, setVisible } from "./09．任务UI列表控制";
import { MAX_PAGES_PER_CATEGORY } from "./01．任务UI常量";

/**
 * 切换展开/收起：隐藏当前页所有 variant，只显示目标 variant。
 * 收起 → variant 0（默认折叠态）
 * 展开 → variant rowIndex + 1
 */
export function toggleExpandLocal(
  pool: TaskUIPrecreatedListPool | null,
  category: QuestType,
  pageIndex: number,
  expandedQuestId: string | null,
  questId: string
): void {
  if (!pool) return;
  const cv = pool.categories[category];
  if (!cv) return;
  const page = cv.pages[pageIndex];
  if (!page) return;

  // 计算目标 variant 索引
  let targetVariant = 0;
  if (expandedQuestId !== questId) {
    const rowIndex = page.questIds.indexOf(questId);
    if (rowIndex >= 0) targetVariant = rowIndex + 1;
  }

  // 隐藏所有 variant，只显示目标 variant
  for (let i = 0; i < page.variants.length; i++) {
    setVisible(page.variants[i].root, i === targetVariant);
  }
}

/**
 * 滚轮翻页：隐藏旧页 root + 所有 variant → 显示新页 root + variant 0。
 */
export function switchPageLocal(
  pool: TaskUIPrecreatedListPool | null,
  category: QuestType,
  prevPageIndex: number,
  nextPageIndex: number
): void {
  if (!pool) return;
  const cv = pool.categories[category];
  if (!cv) return;

  const prev = cv.pages[prevPageIndex];
  if (prev != null) {
    setVisible(prev.root, false);
    for (let i = 0; i < prev.variants.length; i++) {
      setVisible(prev.variants[i].root, false);
    }
  }

  const next = cv.pages[nextPageIndex];
  if (next != null) {
    for (let i = 0; i < next.variants.length; i++) {
      setVisible(next.variants[i].root, i === 0);
    }
    setVisible(next.root, true);
  }
}

/**
 * 切换分类：隐藏旧分类 root + 当前分类所有页 → 显示新分类 page 0 + variant 0。
 * 用 MAX_PAGES_PER_CATEGORY 固定次数遍历，不依赖 pages.length。
 */
export function switchCategoryLocal(
  pool: TaskUIPrecreatedListPool | null,
  previousCategory: QuestType,
  currentCategory: QuestType
): void {
  if (!pool) return;

  const prev = pool.categories[previousCategory];
  if (prev != null) {
    setVisible(prev.root, false);
  }

  const cv = pool.categories[currentCategory];
  if (!cv) return;

  // 先隐藏当前分类所有页（固定 MAX_PAGES_PER_CATEGORY 次，跨端一致）
  for (let i = 0; i < MAX_PAGES_PER_CATEGORY; i++) {
    const page = cv.pages[i];
    if (!page) continue;
    setVisible(page.root, false);
    for (let j = 0; j < page.variants.length; j++) {
      setVisible(page.variants[j].root, false);
    }
  }

  // 再显示 root 和 page 0 + variant 0
  setVisible(cv.root, true);
  setVisible(cv.emptyText, cv.pageCount <= 0);

  const page0 = cv.pages[0];
  if (page0 != null) {
    for (let i = 0; i < page0.variants.length; i++) {
      setVisible(page0.variants[i].root, i === 0);
    }
    setVisible(page0.root, true);
  }
}
