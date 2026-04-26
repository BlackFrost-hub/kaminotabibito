/**
 * 任务 UI 本地显示控制（阶段4）
 *
 * 职责：只做已预设帧的 show/hide，不创建帧、不写 bookkeeping、不触发重建。
 */

import { QuestType } from "../01．任务数据";
import { TaskUIPrecreatedListPool, setVisible } from "./09．任务UI列表控制";

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

