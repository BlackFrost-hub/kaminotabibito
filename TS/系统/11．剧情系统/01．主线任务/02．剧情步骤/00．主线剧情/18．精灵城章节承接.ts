/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};
const { CreateQuestBJ, GetLastCreatedQuestBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  CreateQuestBJ: (this: void, questType: number, title: string, description: string, icon: string) => any;
  GetLastCreatedQuestBJ: (this: void) => any;
};

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import {
  读取语义单位引用,
  设置触发单位控制状态,
} from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 动态创建并注册主线剧情全局单位入口 } from "../../01．主线剧情入口/02．主线剧情入口初始化";
export { 精灵城章节承接剧情片段 } from "../01．第一章/18．精灵城章节承接";

const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const QuestSetCompleted = jass.QuestSetCompleted as (this: void, whichQuest: any, completed: boolean) => void;
const ShowDestructable = jass.ShowDestructable as (this: void, whichDestructable: any, flag: boolean) => void;

const bj_QUESTTYPE_REQ_DISCOVERED = jglobals.bj_QUESTTYPE_REQ_DISCOVERED as number;

function 确保第二幕主线任务已创建(this: void): void {
  const 主线任务数组 = jglobals.udg_ZX as any;
  if (主线任务数组 == null) return;

  const 第一幕任务 = 主线任务数组[1];
  if (第一幕任务 != null && 第一幕任务 !== 0) {
    QuestSetCompleted(第一幕任务, true);
  }

  if (主线任务数组[2] != null && 主线任务数组[2] !== 0) return;
  CreateQuestBJ(
    bj_QUESTTYPE_REQ_DISCOVERED,
    "第二幕：旧怨与战火",
    "",
    "ReplaceableTextures\\CommandButtons\\BTNRavenForm.blp",
  );
  主线任务数组[2] = GetLastCreatedQuestBJ();
}

export function 执行精灵城章节承接(this: void): void {
  设置触发单位控制状态(false, false);
}

function 执行精灵城章节承接演出(this: void, 参数: Record<string, string | number | boolean>): void {
  const 长老 = 读取语义单位引用("主线NPC.精灵村长老");
  if (长老 != null && 长老 !== 0) {
    EC_CreateEffect("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX(长老), GetUnitY(长老), 0, 270, 2, 1, 1.5);
  }

  const 阻挡名 = typeof 参数.隐藏阻挡 === "string" ? 参数.隐藏阻挡 : "gg_dest_B00X_0013";
  const 阻挡 = jglobals[阻挡名];
  if (阻挡 != null && 阻挡 !== 0) {
    ShowDestructable(阻挡, false);
  }
}

function 执行前往王城(this: void): void {
  const 通行单位 = 动态创建并注册主线剧情全局单位入口("精灵森谷传送抵达");
  确保第二幕主线任务已创建();
}

export const 精灵城章节承接剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_章节承接": 执行精灵城章节承接,
  "JLC精灵城_章节承接演出": 执行精灵城章节承接演出,
  "JLC精灵城_前往王城": 执行前往王城,
};
