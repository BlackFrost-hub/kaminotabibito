/** @noSelfInFile */

const jass = require("jass.common") as any;

const { CinematicModeBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  CinematicModeBJ: (this: void, cineMode: boolean, forForce: any) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const {
  平移并应用镜头预设到全部玩家,
  重置玩家镜头并平移到单位,
} = require("lib.扩展函数.封装函数.07．镜头函数.03．镜头预设") as {
  平移并应用镜头预设到全部玩家: (this: void, 预设: 剧情镜头预设参数, duration: number) => void;
  重置玩家镜头并平移到单位: (this: void, whichPlayer: any, unit: any, duration: number, 目标距离?: number) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};

const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, whichPlayer: any) => number;
const GetCameraField = jass.GetCameraField as (this: void, whichField: any) => number;
const SetCameraField = jass.SetCameraField as (this: void, whichField: any, value: number, duration: number) => void;

const CAMERA_FIELD_TARGET_DISTANCE = jass.CAMERA_FIELD_TARGET_DISTANCE as any;
const CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET as any;

export interface 剧情镜头预设参数 {
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

let 剧情电影模式已开启 = false;
interface 剧情电影模式前镜头状态 {
  目标距离: number;
  高度偏移: number;
}

const 剧情电影模式前镜头状态表: Record<number, 剧情电影模式前镜头状态> = {};

function 记录本地玩家镜头状态(this: void): void {
  const localPlayer = GetLocalPlayer();
  const playerId = GetPlayerId(localPlayer);
  剧情电影模式前镜头状态表[playerId] = {
    目标距离: GetCameraField(CAMERA_FIELD_TARGET_DISTANCE),
    高度偏移: GetCameraField(CAMERA_FIELD_ZOFFSET),
  };
}

function 恢复本地玩家镜头状态(this: void): void {
  const localPlayer = GetLocalPlayer();
  const playerId = GetPlayerId(localPlayer);
  const 状态 = 剧情电影模式前镜头状态表[playerId];
  if (状态 == null) return;

  SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 状态.目标距离, 0);
  SetCameraField(CAMERA_FIELD_ZOFFSET, 状态.高度偏移, 0);
  delete 剧情电影模式前镜头状态表[playerId];
}

export function 进入剧情电影模式(this: void): void {
  if (剧情电影模式已开启) return;
  记录本地玩家镜头状态();
  剧情电影模式已开启 = true;
  CinematicModeBJ(true, GetPlayersAll());
}

export function 应用剧情电影镜头(this: void, 预设: 剧情镜头预设参数, duration: number): void {
  平移并应用镜头预设到全部玩家(预设, duration);
}

export function 退出剧情电影模式并恢复镜头(this: void): void {
  if (!剧情电影模式已开启) return;
  剧情电影模式已开启 = false;
  CinematicModeBJ(false, GetPlayersAll());

  const localPlayer = GetLocalPlayer();
  const hero = getRegisteredPlayerHero(localPlayer);
  重置玩家镜头并平移到单位(localPlayer, hero, 0);
  恢复本地玩家镜头状态();
}
