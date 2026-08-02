/** @noSelfInFile */

import { 安斯艾尔单位技能配置 } from "./00．配置";
import { 激活安斯艾尔圣光附魔 } from "./01．被动效果";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;

interface Q上下文 { unit: any; }

function 获取Q上下文(this: void, unit: any): Q上下文 {
  return { unit };
}

function 播放Q配置表现(this: void, unit: any): void {
  const cfg = 安斯艾尔单位技能配置.Q;
  if (cfg.动作编号 >= 0) {
    SetUnitTimeScale(unit, cfg.动作速度);
    SetUnitAnimationByIndex(unit, cfg.动作编号);
  }
  if (cfg.全局音效键 === "") return;
  const sound = jglobals[cfg.全局音效键];
  if (sound == null || sound === 0) return;
  jass.AttachSoundToUnit(sound, unit);
  jass.SetSoundVolume(sound, 127);
  jass.StartSound(sound);
}

function 释放圣光附魔(this: void, _context: Q上下文, unit: any): void {
  播放Q配置表现(unit);
  激活安斯艾尔圣光附魔(unit);
}

export function 注册安斯艾尔Q(this: void): void {
  注册单位技能壳监听({
    名称: "安斯艾尔-圣光附魔",
    单位类型ID: 安斯艾尔单位技能配置.单位类型ID,
    技能ID: 安斯艾尔单位技能配置.Q技能ID,
    获取或创建上下文: 获取Q上下文,
    释放技能: 释放圣光附魔,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 安斯艾尔单位技能配置.Q.持续秒,
  });
}

注册安斯艾尔Q();
