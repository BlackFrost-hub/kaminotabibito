/** @noSelfInFile */

/** 任务 ID 按用途预留，每段容量为 1000。 */
export const 任务ID分区 = {
  静态支线: { 起始: 10000, 结束: 10999 },
  动态支线: { 起始: 11000, 结束: 11999 },
  主线剧情: { 起始: 12000, 结束: 12999 },
  测试任务: { 起始: 13000, 结束: 13999 },
  系统保留: { 起始: 14000, 结束: 14999 },
} as const;

export function 任务ID属于分区(this: void, id: number, 分区: keyof typeof 任务ID分区): boolean {
  const 范围 = 任务ID分区[分区];
  return id >= 范围.起始 && id <= 范围.结束;
}
