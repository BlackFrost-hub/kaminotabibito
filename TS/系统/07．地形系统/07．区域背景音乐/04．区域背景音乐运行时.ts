/** @noSelfInFile */

const jass = require("jass.common") as Record<string, any>;
const jglobals = require("jass.globals") as Record<string, any>;

const { SetStackedSoundBJ } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  SetStackedSoundBJ: (this: void, add: boolean, soundHandle: any, rectHandle: any) => void;
};

const Rect = jass.Rect as (this: void, minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (this: void, rectHandle: any) => void;
const CreateSound = jass.CreateSound as (
  this: void,
  fileName: string,
  looping: boolean,
  is3D: boolean,
  stopWhenOutOfRange: boolean,
  fadeInRate: number,
  fadeOutRate: number,
  eaxSetting: string,
) => any;
const StopSound = jass.StopSound as (this: void, soundHandle: any, killWhenDone: boolean, fadeOut: boolean) => void;

export interface 区域背景音乐运行时注册配置 {
  键: string;
  音乐路径: string;
  区域全局名?: string;
  左?: number;
  右?: number;
  下?: number;
  上?: number;
}

interface 区域背景音乐运行时状态 {
  矩形: any;
  音频: any;
  已挂载: boolean;
  是否自建矩形: boolean;
}

const 区域背景音乐运行时状态表: Record<string, 区域背景音乐运行时状态 | undefined> = {};

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 读取全局句柄(this: void, 变量名: string | undefined): any {
  if (变量名 == null || 变量名 === "") return null;
  return jglobals[变量名] || null;
}

/** 统一的矩形音频低层挂载入口，静态配置、剧情动作和 Boss 战都从这里调用。 */
export function 挂载区域背景音乐句柄(this: void, add: boolean, soundHandle: any, rectHandle: any): boolean {
  if (!句柄有效(soundHandle) || !句柄有效(rectHandle)) return false;
  SetStackedSoundBJ(add, soundHandle, rectHandle);
  return true;
}

export function 卸载区域背景音乐句柄(this: void, soundHandle: any, rectHandle: any): boolean {
  return 挂载区域背景音乐句柄(false, soundHandle, rectHandle);
}

export function 停止区域背景音乐句柄(this: void, soundHandle: any): boolean {
  if (!句柄有效(soundHandle)) return false;
  StopSound(soundHandle, true, false);
  return true;
}

export function 移除区域背景音乐矩形(this: void, rectHandle: any): boolean {
  if (!句柄有效(rectHandle)) return false;
  RemoveRect(rectHandle);
  return true;
}

/** 兼容剧情配置里的“gg_snd_xxx @ gg_rct_xxx; ...”表达式。 */
export function 切换区域背景音乐表达式(this: void, expr: string | undefined, add: boolean): number {
  if (expr == null || expr === "") return 0;

  let count = 0;
  const list = expr.split(";");
  for (let i = 0; i < list.length; i++) {
    const item = list[i].trim();
    if (item.length === 0) continue;
    const at = item.indexOf("@");
    if (at < 0) continue;
    const soundHandle = 读取全局句柄(item.substring(0, at).trim());
    const rectHandle = 读取全局句柄(item.substring(at + 1).trim());
    if (挂载区域背景音乐句柄(add, soundHandle, rectHandle)) count++;
  }
  return count;
}

function 运行时配置有效(this: void, 配置: 区域背景音乐运行时注册配置): boolean {
  return 配置.键 !== ""
    && 配置.音乐路径 !== ""
    && ((配置.区域全局名 != null && 配置.区域全局名 !== "")
      || (配置.左 != null && 配置.右 != null && 配置.下 != null && 配置.上 != null
        && 配置.左 < 配置.右
        && 配置.下 < 配置.上));
}

/** 注册运行时区域。注册只创建句柄，不自动播放；需要播放时显式调用启用。 */
export function 注册运行时区域背景音乐(this: void, 配置: 区域背景音乐运行时注册配置): boolean {
  if (!运行时配置有效(配置)) return false;
  if (区域背景音乐运行时状态表[配置.键] != null) return true;

  const 使用地图矩形 = 配置.区域全局名 != null && 配置.区域全局名 !== "";
  const 矩形 = 使用地图矩形
    ? 读取全局句柄(配置.区域全局名)
    : Rect(配置.左 as number, 配置.下 as number, 配置.右 as number, 配置.上 as number);
  if (!句柄有效(矩形)) return false;

  const 音频 = CreateSound(配置.音乐路径, true, true, true, 10, 10, "DefaultEAXON");
  if (!句柄有效(音频)) {
    if (!使用地图矩形) 移除区域背景音乐矩形(矩形);
    return false;
  }

  区域背景音乐运行时状态表[配置.键] = {
    矩形,
    音频,
    已挂载: false,
    是否自建矩形: !使用地图矩形,
  };
  return true;
}

export function 启用运行时区域背景音乐(this: void, 键: string): boolean {
  const 状态 = 区域背景音乐运行时状态表[键];
  if (状态 == null) return false;
  if (状态.已挂载) return true;

  if (!挂载区域背景音乐句柄(true, 状态.音频, 状态.矩形)) return false;
  状态.已挂载 = true;
  return true;
}

export function 停用运行时区域背景音乐(this: void, 键: string): boolean {
  const 状态 = 区域背景音乐运行时状态表[键];
  if (状态 == null) return false;
  if (!状态.已挂载) return true;

  卸载区域背景音乐句柄(状态.音频, 状态.矩形);
  状态.已挂载 = false;
  return true;
}

/** 停止音频并释放运行时创建的矩形；地图编辑器矩形只释放音频句柄。 */
export function 清理运行时区域背景音乐(this: void, 键: string): boolean {
  const 状态 = 区域背景音乐运行时状态表[键];
  if (状态 == null) return false;

  停用运行时区域背景音乐(键);
  停止区域背景音乐句柄(状态.音频);
  if (状态.是否自建矩形) 移除区域背景音乐矩形(状态.矩形);
  delete 区域背景音乐运行时状态表[键];
  return true;
}
