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
  重置玩家镜头并平移到单位: (this: void, whichPlayer: any, unit: any, duration: number) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};

const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;

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

export function 进入剧情电影模式(this: void): void {
  if (剧情电影模式已开启) return;
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
}
