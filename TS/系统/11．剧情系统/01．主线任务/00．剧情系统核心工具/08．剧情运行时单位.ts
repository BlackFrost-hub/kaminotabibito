/** @noSelfInFile */

const 剧情运行时单位表: Record<string, any> = {};

export function 注册剧情运行时单位(this: void, 语义名: string, unit: any): void {
  if (语义名 === "" || unit == null || unit === 0) return;
  剧情运行时单位表[语义名] = unit;
}

export function 读取剧情运行时单位(this: void, 语义名: string): any {
  if (语义名 === "") return null;
  return 剧情运行时单位表[语义名] ?? null;
}

export function 清理剧情运行时单位(this: void, 语义名: string): void {
  if (语义名 === "") return;
  剧情运行时单位表[语义名] = undefined;
  delete 剧情运行时单位表[语义名];
}
