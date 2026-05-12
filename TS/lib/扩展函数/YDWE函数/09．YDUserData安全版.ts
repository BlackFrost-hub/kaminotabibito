/** @noSelfInFile */
/**
 * YDUserData 安全封装
 *
 * 用途：
 * - 专门给 `@noSelfInFile` 文件使用
 * - 避免直接调用 `01．YDUserData兼容.ts` 导出的 `YDUserDataGet/Set`
 *   时因为 TSTL / Lua 的 self 形态导致参数错位
 *
 * 规则：
 * - 在普通文件里，仍可直接用原版 `YDUserDataGet/Set`
 * - 在 `@noSelfInFile` 文件里，优先用这里的安全版
 */

const ydweCompat = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

const YDUserDataGetUnsafe = ydweCompat.YDUserDataGet as any;
const YDUserDataSetUnsafe = ydweCompat.YDUserDataSet as any;

export function YDUserDataGetSafe(this: void, tableType: string, tableKey: any, attr: string, valueType: string): any {
  return YDUserDataGetUnsafe(undefined, tableType, tableKey, attr, valueType);
}

export function YDUserDataSetSafe(this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any): void {
  YDUserDataSetUnsafe(undefined, tableType, tableKey, attr, valueType, value);
}

export const 安全YDUserDataGet = YDUserDataGetSafe;
export const 安全YDUserDataSet = YDUserDataSetSafe;
