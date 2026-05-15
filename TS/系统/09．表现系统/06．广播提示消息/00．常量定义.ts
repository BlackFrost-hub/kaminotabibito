/** @noSelfInFile */

export const 广播提示玩家槽数 = 4;
export const 每玩家广播提示槽数 = 7;

export const 广播提示背景贴图 = "UI\\xiaoxi\\UInoticebackdrop.tga";
export const 广播提示默认头像 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp";
export const 广播提示字体 = "UI\\uizt.ttf";

export const 广播提示宽度 = 0.235;
export const 广播提示高度 = 0.034;
export const 广播提示头像大小 = 0.026;
export const 广播提示文字宽度 = 0.185;
export const 广播提示文字高度 = 0.018;

export const 广播提示起始X = 0.22;
export const 广播提示停留X = 0.105;
export const 广播提示基准Y = 0.2;
export const 广播提示槽间距Y = 0.038;

export const 广播提示滑入毫秒 = 300;
export const 广播提示默认停留毫秒 = 3000;
export const 广播提示淡出毫秒 = 450;
export const 广播提示刷新毫秒 = 50;

export const 广播提示最大透明度 = 255;
export const 广播提示优先级 = 650;

export const 帧点左 = 3;
export const 帧点中 = 4;
export const 帧点右 = 5;
export const 文本左对齐 = 2;

export const 广播提示状态_隐藏 = 0;
export const 广播提示状态_滑入 = 1;
export const 广播提示状态_停留 = 2;
export const 广播提示状态_淡出 = 3;

export function 取广播提示槽索引(this: void, 玩家ID: number, 槽位ID: number): number {
  return 玩家ID * 每玩家广播提示槽数 + 槽位ID;
}

export function 取广播提示槽位Y(this: void, 槽位ID: number): number {
  return 广播提示基准Y + 槽位ID * 广播提示槽间距Y;
}
