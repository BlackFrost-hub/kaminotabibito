/** @noSelfInFile */
/**
 * 镜头高度控制
 *
 * 主键盘和数字小键盘的 +/- 每次调整本地玩家镜头高度 200。
 */

const jass = require("jass.common") as any;

import { KEY_STATE, registerKeyEventByCode } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";

const 镜头高度步长 = 200;
const 默认镜头高度偏移 = 0;
const Boss测试镜头高度偏移 = 默认镜头高度偏移 + 400;
const 主键盘加号键 = 187;
const 主键盘减号键 = 189;
const 数字小键盘加号键 = 107;
const 数字小键盘减号键 = 109;

const CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET;
const GetCameraField = jass.GetCameraField as (field: any) => number;
const SetCameraField = jass.SetCameraField as (field: any, value: number, duration: number) => void;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;

let 已初始化 = false;

export function 按步长调整本地镜头高度(this: void, 步数: number): void {
  const 当前镜头高度 = GetCameraField(CAMERA_FIELD_ZOFFSET);
  SetCameraField(CAMERA_FIELD_ZOFFSET, 当前镜头高度 + 步数 * 镜头高度步长, 0);
}

/** 只调整指定玩家的本地镜头，避免传送时影响其他玩家。 */
export function 按步长调整玩家镜头高度(this: void, 玩家: any, 步数: number): void {
  if (玩家 == null || 玩家 === 0 || GetLocalPlayer() !== 玩家) return;
  按步长调整本地镜头高度(步数);
}

function 抬高镜头(this: any): void {
  按步长调整本地镜头高度(1);
}

function 降低镜头(this: any): void {
  按步长调整本地镜头高度(-1);
}

/** Boss 测试场景使用，每次都固定设置为默认镜头高度以上 400。 */
export function 抬高Boss测试镜头(this: void): void {
  SetCameraField(CAMERA_FIELD_ZOFFSET, Boss测试镜头高度偏移, 0);
}

export function init(this: void): void {
  if (已初始化) return;
  已初始化 = true;

  registerKeyEventByCode(主键盘加号键, KEY_STATE.UP, false, 抬高镜头);
  registerKeyEventByCode(数字小键盘加号键, KEY_STATE.UP, false, 抬高镜头);
  registerKeyEventByCode(主键盘减号键, KEY_STATE.UP, false, 降低镜头);
  registerKeyEventByCode(数字小键盘减号键, KEY_STATE.UP, false, 降低镜头);
}
