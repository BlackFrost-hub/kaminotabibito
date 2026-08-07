/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../00．封印守卫战公共/00．类型";
import { 失控英灵配置 } from "./00．配置";
import {
  命令攻击目标,
  取最近玩家英雄,
  读取封印守卫战核心,
  是封印守卫战玩家英雄,
  封印守卫战单位存活,
  播放封印守卫战单位临时特效,
} from "../00．封印守卫战公共/01．共享";

const { 施加快速减速Buff, 清除单位指定Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (
    this: void,
    source: any,
    target: any,
    attackSlow: number,
    moveSlow: number,
    duration: number,
    sourceName?: string,
    sourceType?: string,
    displayBuffID?: string,
  ) => void;
  清除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 封印守卫战BuffID } = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战") as {
  封印守卫战BuffID: { 缚魂减速: string; 暗影侵蚀减速: string };
};

export function 刷新失控英灵AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 失控英灵配置.AI刷新毫秒;
  const hero = 取最近玩家英雄(record.单位);
  const target = 封印守卫战单位存活(hero) ? hero : 读取封印守卫战核心();
  if (封印守卫战单位存活(target)) {
    record.当前目标 = target;
    命令攻击目标(record.单位, target);
  }
}

export function 处理失控英灵普攻命中(
  this: void,
  record: 封印守卫战敌人记录,
  target: any,
  applied: number,
  snapshot: any,
  当前毫秒: number,
): void {
  if (!(applied > 0) || snapshot?.isNormalAttack !== true || !是封印守卫战玩家英雄(target)) return;
  if (当前毫秒 < record.上次被动毫秒 + 失控英灵配置.被动冷却毫秒) return;
  record.上次被动毫秒 = 当前毫秒;
  清除单位指定Buff(target, 封印守卫战BuffID.暗影侵蚀减速);
  施加快速减速Buff(
    record.单位,
    target,
    0,
    失控英灵配置.减速比例,
    失控英灵配置.减速持续秒,
    "封印守卫战-失控英灵缚魂斩",
    "技能",
    封印守卫战BuffID.缚魂减速,
  );
  播放封印守卫战单位临时特效(target, 失控英灵配置.减速特效, 失控英灵配置.减速持续秒);
}
