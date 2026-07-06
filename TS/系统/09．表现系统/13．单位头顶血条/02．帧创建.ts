/** @noSelfInFile */

import { 血条尺寸, 血条层级, 血条资源 } from "./00．常量";
import type { 单位血条帧组 } from "./01．类型";

const japi = require("jass.japi") as any;

const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (type: string, name: string, parent: number, template: string, id: number) => number;
const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzFrameGetLowerLevelFrame = japi.DzFrameGetLowerLevelFrame as () => number;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: number, point: number, relativeFrame: number, relativePoint: number, x: number, y: number) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment as (frame: number, align: number) => void;
const DzFrameSetTextColor = japi.DzFrameSetTextColor as (frame: number, r: number, g: number, b: number, a: number) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, path: string, size: number, flag: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const DzFrameSetIgnoreTrackEvents = japi.DzFrameSetIgnoreTrackEvents as (frame: number, ignore: boolean) => void;

const 点中 = 4;
let 血条底层帧 = 0;
let 控制台遮罩帧 = 0;

function 取血条父帧(this: void): number {
  if (血条底层帧 !== 0) return 血条底层帧;
  const lower = DzFrameGetLowerLevelFrame();
  if (lower != null && lower !== 0) {
    血条底层帧 = DzCreateFrameByTagName("FRAME", "UnitHeadHealthBarLayer", lower, "", 0);
    if (血条底层帧 !== 0) {
      创建控制台遮罩(血条底层帧);
      return 血条底层帧;
    }
    return lower;
  }
  const gameUI = DzGetGameUI();
  return gameUI;
}

function 创建贴图帧(this: void, 名称: string, 父级: number, 贴图: string, 优先级: number): number {
  const frame = DzCreateFrameByTagName("BACKDROP", 名称, 父级, "", 0);
  if (frame == null || frame === 0) return 0;
  DzFrameSetTexture(frame, 贴图, 0);
  DzFrameSetPriority(frame, 优先级);
  return frame;
}

function 创建控制台遮罩(this: void, 父级: number): void {
  if (控制台遮罩帧 !== 0) return;
  控制台遮罩帧 = DzCreateFrameByTagName("BACKDROP", "UnitHeadHealthBarConsoleMask", 父级, "", 0);
  if (控制台遮罩帧 === 0) return;
  DzFrameSetTexture(控制台遮罩帧, "Textures\\Black32.blp", 0);
  DzFrameSetSize(控制台遮罩帧, 血条尺寸.控制台遮罩宽, 血条尺寸.控制台遮罩高);
  DzFrameSetPoint(控制台遮罩帧, 6, DzGetGameUI(), 6, 0, 0);
  DzFrameSetPriority(控制台遮罩帧, 血条层级.控制台遮罩);
  DzFrameSetIgnoreTrackEvents(控制台遮罩帧, true);
  DzFrameShow(控制台遮罩帧, true);
}

export function 创建单位血条帧组(this: void, 槽位: number): 单位血条帧组 | null {
  const parent = 取血条父帧();
  const suffix = tostring(槽位);
  const root = 创建贴图帧("UnitHeadHealthBarRoot_" + suffix, parent, 血条资源.底框, 血条层级.根);
  if (root === 0) return null;
  DzFrameSetSize(root, 血条尺寸.根宽, 血条尺寸.根高);

  const lifeLag = 创建贴图帧("UnitHeadHealthBarLifeLag_" + suffix, root, 血条资源.生命缓降, 血条层级.生命缓降);
  const life = 创建贴图帧("UnitHeadHealthBarLife_" + suffix, root, 血条资源.友方生命, 血条层级.生命);
  const shields: number[] = [];
  for (let i = 0; i < 血条尺寸.最大护盾分段数; i++) {
    shields.push(创建贴图帧("UnitHeadHealthBarShield_" + suffix + "_" + tostring(i), root, 血条资源.护盾.通用, 血条层级.护盾));
  }
  const mana = 创建贴图帧("UnitHeadHealthBarMana_" + suffix, root, 血条资源.魔法, 血条层级.魔法);
  const name = DzCreateFrameByTagName("TEXT", "UnitHeadHealthBarName_" + suffix, root, "", 0);

  let shieldOk = true;
  for (let i = 0; i < shields.length; i++) {
    if (shields[i] === 0) shieldOk = false;
  }
  if (lifeLag === 0 || life === 0 || !shieldOk || mana === 0 || name == null || name === 0) {
    return null;
  }

  DzFrameSetSize(lifeLag, 0.0, 血条尺寸.生命高);
  DzFrameSetPoint(lifeLag, 0, root, 0, 血条尺寸.内条左偏移, 血条尺寸.生命Y);

  DzFrameSetSize(life, 血条尺寸.内条宽, 血条尺寸.生命高);
  DzFrameSetPoint(life, 0, root, 0, 血条尺寸.内条左偏移, 血条尺寸.生命Y);

  for (let i = 0; i < shields.length; i++) {
    DzFrameSetSize(shields[i], 0.0, 血条尺寸.生命高);
    DzFrameSetPoint(shields[i], 0, root, 0, 血条尺寸.内条左偏移, 血条尺寸.生命Y);
  }

  DzFrameSetSize(mana, 血条尺寸.内条宽, 血条尺寸.魔法高);
  DzFrameSetPoint(mana, 0, root, 0, 血条尺寸.内条左偏移, 血条尺寸.魔法Y);

  DzFrameSetSize(name, 血条尺寸.名字宽, 血条尺寸.名字高);
  DzFrameSetPoint(name, 点中, root, 点中, 0, 血条尺寸.名字Y);
  DzFrameSetText(name, "");
  DzFrameSetTextAlignment(name, -1);
  DzFrameSetTextAlignment(name, 18);
  DzFrameSetTextColor(name, 255, 238, 190, 255);
  DzFrameSetFont(name, "UI\\unit_name_zcool_qingke.ttf", 0.0115, 0);
  DzFrameSetPriority(name, 血条层级.名字);
  DzFrameSetIgnoreTrackEvents(name, true);

  DzFrameShow(root, false);
  DzFrameShow(lifeLag, false);
  DzFrameShow(life, true);
  for (let i = 0; i < shields.length; i++) DzFrameShow(shields[i], false);
  DzFrameShow(mana, false);
  DzFrameShow(name, false);

  return { 槽位, root, lifeLag, life, shields, mana, name };
}
