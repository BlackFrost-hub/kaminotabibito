/** @noSelfInFile */

import { 血条尺寸 } from "./00．常量";
import { 创建单位血条帧组 } from "./02．帧创建";
import type { 单位血条帧组 } from "./01．类型";

const japi = require("jass.japi") as any;

const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const DzFrameUnBind = japi.DzFrameUnBind as (frame: number) => void;

const 空闲帧组: 单位血条帧组[] = [];
let 已创建数量 = 0;
let 当前容量: number = 血条尺寸.初始血条容量;

function 隐藏帧组(this: void, 帧: 单位血条帧组): void {
  DzFrameShow(帧.root, false);
}

export function 取单位血条帧组(this: void): 单位血条帧组 | null {
  const reused = 空闲帧组.pop();
  if (reused != null) return reused;
  if (已创建数量 >= 当前容量) {
    当前容量 += 血条尺寸.血条容量扩展步长;
  }
  已创建数量++;
  return 创建单位血条帧组(已创建数量);
}

export function 回收单位血条帧组(this: void, 帧: 单位血条帧组): void {
  if (帧 == null || 帧.root === 0) return;
  DzFrameUnBind(帧.root);
  隐藏帧组(帧);
  空闲帧组.push(帧);
}
