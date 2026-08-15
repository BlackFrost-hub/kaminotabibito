/** @noSelfInFile */

import type { Boss弱点调查结果 } from "./00．类型";
import { 更新Boss血条头像贴图 } from "./03．Boss血条UI";
import { 读取Boss血条弱点韧性运行状态 } from "./05．Boss弱点运行状态";
import { 调查Boss下一个未显现弱点 } from "./06．Boss弱点伤害结算";

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

function 创建Boss弱点调查失败结果(this: void, 原因: Boss弱点调查结果["原因"]): Boss弱点调查结果 {
  return {
    成功: false,
    原因,
    弱点索引: -1,
    弱点键: "",
    当前护盾值: 0,
    是否护盾破碎中: false,
  };
}

/**
 * 显现指定活动 Boss 的下一个未显现弱点，并削减 1 点护盾。
 * 必须从同步游戏逻辑调用；返回结果可用于决定技能是否成功结算。
 */
export function 调查Boss弱点(this: void, Boss单位: any, 来源单位?: any): Boss弱点调查结果 {
  if (Boss单位 == null || Boss单位 === 0) return 创建Boss弱点调查失败结果("单位无效");
  const bossHandleId = GetHandleId(Boss单位) || 0;
  if (bossHandleId === 0) return 创建Boss弱点调查失败结果("单位无效");
  const state = 读取Boss血条弱点韧性运行状态(bossHandleId);
  if (state == null || state.是否已结束) return 创建Boss弱点调查失败结果("Boss状态不存在");
  return 调查Boss下一个未显现弱点(state, 来源单位, 1);
}
