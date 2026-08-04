/** @noSelfInFile */

const jass = require("jass.common") as any;

const {
  StarOther_PanCameraToTimedForPlayer,
  StarOther_PanCameraToTimedUnitForPlayer,
} = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
  StarOther_PanCameraToTimedUnitForPlayer: (this: void, whichPlayer: any, unit: any, duration: number) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};

const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const IsPlayerInForce = jass.IsPlayerInForce as (this: void, whichPlayer: any, whichForce: any) => boolean;
const ResetToGameCamera = jass.ResetToGameCamera as (this: void, duration: number) => void;
const SetCameraField = jass.SetCameraField as (this: void, whichField: any, value: number, duration: number) => void;

const CAMERA_FIELD_TARGET_DISTANCE = jass.CAMERA_FIELD_TARGET_DISTANCE as any;
const CAMERA_FIELD_FARZ = jass.CAMERA_FIELD_FARZ as any;
const CAMERA_FIELD_ROTATION = jass.CAMERA_FIELD_ROTATION as any;
const CAMERA_FIELD_ANGLE_OF_ATTACK = jass.CAMERA_FIELD_ANGLE_OF_ATTACK as any;
const CAMERA_FIELD_ROLL = jass.CAMERA_FIELD_ROLL as any;
const CAMERA_FIELD_FIELD_OF_VIEW = jass.CAMERA_FIELD_FIELD_OF_VIEW as any;
const CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET as any;

export interface 镜头预设参数 {
  X: number;
  Y: number;
  距离到目标: number;
  远景剪裁: number;
  旋转角度: number;
  攻角: number;
  滚动角度: number;
  观察区域: number;
  高度偏移: number;
}

export function 应用镜头预设给玩家(
  this: void,
  whichPlayer: any,
  预设: 镜头预设参数,
  duration: number,
): void {
  StarOther_PanCameraToTimedForPlayer(whichPlayer, 预设.X, 预设.Y, duration);
  if (GetLocalPlayer() !== whichPlayer) return;

  SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 预设.距离到目标, duration);
  SetCameraField(CAMERA_FIELD_FARZ, 预设.远景剪裁, duration);
  SetCameraField(CAMERA_FIELD_ROTATION, 预设.旋转角度, duration);
  SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 预设.攻角, duration);
  SetCameraField(CAMERA_FIELD_ROLL, 预设.滚动角度, duration);
  SetCameraField(CAMERA_FIELD_FIELD_OF_VIEW, 预设.观察区域, duration);
  SetCameraField(CAMERA_FIELD_ZOFFSET, 预设.高度偏移, duration);
}

export function 应用镜头预设给玩家组(
  this: void,
  whichForce: any,
  预设: 镜头预设参数,
  duration: number,
): void {
  const localPlayer = GetLocalPlayer();
  if (!IsPlayerInForce(localPlayer, whichForce)) return;
  应用镜头预设给玩家(localPlayer, 预设, duration);
}

export function 平移并应用镜头预设到本地(this: void, 预设: 镜头预设参数, duration: number): void {
  应用镜头预设给玩家(GetLocalPlayer(), 预设, duration);
}

export function 平移并应用镜头预设到全部玩家(this: void, 预设: 镜头预设参数, duration: number): void {
  应用镜头预设给玩家组(GetPlayersAll(), 预设, duration);
}

export function 重置玩家镜头并平移到单位(
  this: void,
  whichPlayer: any,
  unit: any,
  duration: number,
  目标距离?: number,
): void {
  if (GetLocalPlayer() !== whichPlayer) return;
  if (目标距离 != null && 目标距离 > 0) SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 目标距离, 0);
  ResetToGameCamera(0);
  if (unit == null || unit === 0) return;
  StarOther_PanCameraToTimedUnitForPlayer(whichPlayer, unit, duration);
}
