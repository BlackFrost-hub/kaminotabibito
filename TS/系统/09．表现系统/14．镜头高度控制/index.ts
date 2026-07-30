/** @noSelfInFile */
/**
 * 镜头高度控制
 *
 * 主键盘和数字小键盘的 +/- 每次调整本地玩家镜头高度 200。
 */

const jass = require("jass.common") as any;

import { KEY_STATE, registerKeyEventByCode } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";

const 镜头高度步长 = 200;
const Boss测试镜头高度偏移 = 镜头高度步长 * 2;
const 主键盘加号键 = 187;
const 主键盘减号键 = 189;
const 数字小键盘加号键 = 107;
const 数字小键盘减号键 = 109;

const CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET;
const AdjustCameraField = jass.AdjustCameraField as (field: any, offset: number, duration: number) => void;

let 已初始化 = false;

function 抬高镜头(this: any): void {
  AdjustCameraField(CAMERA_FIELD_ZOFFSET, 镜头高度步长, 0);
}

function 降低镜头(this: any): void {
  AdjustCameraField(CAMERA_FIELD_ZOFFSET, -镜头高度步长, 0);
}

/** Boss 测试场景使用，等同于连续按两次 +。 */
export function 抬高Boss测试镜头(this: void): void {
  AdjustCameraField(CAMERA_FIELD_ZOFFSET, Boss测试镜头高度偏移, 0);
}

export function init(this: void): void {
  if (已初始化) return;
  已初始化 = true;

  registerKeyEventByCode(主键盘加号键, KEY_STATE.UP, false, 抬高镜头);
  registerKeyEventByCode(数字小键盘加号键, KEY_STATE.UP, false, 抬高镜头);
  registerKeyEventByCode(主键盘减号键, KEY_STATE.UP, false, 降低镜头);
  registerKeyEventByCode(数字小键盘减号键, KEY_STATE.UP, false, 降低镜头);
}
