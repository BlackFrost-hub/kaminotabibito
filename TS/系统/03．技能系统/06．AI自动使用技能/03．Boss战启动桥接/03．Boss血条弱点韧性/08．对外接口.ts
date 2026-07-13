/** @noSelfInFile */

import { 更新Boss血条头像贴图 } from "./03．Boss血条UI";
import { 读取Boss血条弱点韧性运行状态 } from "./05．Boss弱点运行状态";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

/**
 * 修改指定 Boss 当前血条头像。传入空字符串时恢复单位物编 Art 头像。
 * Boss 运行状态尚未建立或已经结束时返回 false。
 */
export function 设置Boss血条头像(this: void, Boss单位: any, 头像贴图路径: string): boolean {
  if (Boss单位 == null || Boss单位 === 0 || 头像贴图路径 == null) return false;
  const state = 读取Boss血条弱点韧性运行状态(GetHandleId(Boss单位));
  if (state == null || state.是否已结束) return false;
  return 更新Boss血条头像贴图(state, 头像贴图路径);
}
