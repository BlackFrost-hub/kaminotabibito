/** @noSelfInFile */

const jass = require("jass.common") as Record<string, any>;
const jglobals = require("jass.globals") as Record<string, any>;

const { SetStackedSoundBJ } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  SetStackedSoundBJ: (this: void, add: boolean, soundHandle: any, rectHandle: any) => void;
};
const { 注册动态矩形区域, 按配置键注册动态矩形区域, 获取矩形区域, 读取动态矩形区域组子区域键, 注销动态矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  注册动态矩形区域: (this: void, 配置: { 键: string; 左: number; 右: number; 下: number; 上: number; 说明?: string }) => any;
  按配置键注册动态矩形区域: (this: void, 键: string) => any;
  获取矩形区域: (this: void, 名称: string) => any;
  读取动态矩形区域组子区域键: (this: void, 组键: string, 用途?: "全部" | "背景音乐") => string[];
  注销动态矩形区域: (this: void, 键: string) => boolean;
};

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
  矩形区域名称?: string;
  区域动态组键?: string;
  区域动态键?: string;
  区域动态键列表?: string[];
  左?: number;
  右?: number;
  下?: number;
  上?: number;
}

interface 区域背景音乐运行时状态 {
  矩形列表: any[];
  音频: any;
  已挂载: boolean;
  拥有动态矩形键列表: string[];
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

/** 兼容剧情配置里的“声音全局名 @ 矩形区域名称; ...”表达式。 */
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
    const rectName = item.substring(at + 1).trim();
    const rectHandle = 获取矩形区域(rectName);
    if (挂载区域背景音乐句柄(add, soundHandle, rectHandle)) count++;
  }
  return count;
}

function 运行时配置有效(this: void, 配置: 区域背景音乐运行时注册配置): boolean {
  return 配置.键 !== ""
    && 配置.音乐路径 !== ""
    && ((配置.矩形区域名称 != null && 配置.矩形区域名称 !== "")
      || (配置.区域动态组键 != null && 配置.区域动态组键 !== "")
      || (配置.区域动态键 != null && 配置.区域动态键 !== "")
      || (配置.区域动态键列表 != null && 配置.区域动态键列表.length > 0)
      || (配置.左 != null && 配置.右 != null && 配置.下 != null && 配置.上 != null
        && 配置.左 < 配置.右
        && 配置.下 < 配置.上));
}

/** 注册运行时区域。注册只创建句柄，不自动播放；需要播放时显式调用启用。 */
export function 注册运行时区域背景音乐(this: void, 配置: 区域背景音乐运行时注册配置): boolean {
  if (!运行时配置有效(配置)) return false;
  if (区域背景音乐运行时状态表[配置.键] != null) return true;

  const 使用地图矩形 = 配置.矩形区域名称 != null && 配置.矩形区域名称 !== "";
  const 共享动态矩形键列表: string[] = [];
  if (!使用地图矩形 && 配置.区域动态键 != null && 配置.区域动态键 !== "") {
    共享动态矩形键列表.push(配置.区域动态键);
  }
  if (!使用地图矩形 && 配置.区域动态键列表 != null) {
    for (let i = 0; i < 配置.区域动态键列表.length; i++) {
      const 键 = 配置.区域动态键列表[i];
      if (键 !== "" && 共享动态矩形键列表.indexOf(键) < 0) 共享动态矩形键列表.push(键);
    }
  }
  if (!使用地图矩形 && 配置.区域动态组键 != null && 配置.区域动态组键 !== "") {
    const 子区域键列表 = 读取动态矩形区域组子区域键(配置.区域动态组键, "背景音乐");
    for (let i = 0; i < 子区域键列表.length; i++) {
      const 键 = 子区域键列表[i];
      if (键 !== "" && 共享动态矩形键列表.indexOf(键) < 0) 共享动态矩形键列表.push(键);
    }
  }

  const 矩形列表: any[] = [];
  const 拥有动态矩形键列表: string[] = [];
  if (使用地图矩形) {
    const 矩形 = 获取矩形区域(配置.矩形区域名称 as string);
    if (句柄有效(矩形)) 矩形列表.push(矩形);
  } else if (共享动态矩形键列表.length > 0) {
    for (let i = 0; i < 共享动态矩形键列表.length; i++) {
      const 矩形 = 按配置键注册动态矩形区域(共享动态矩形键列表[i]);
      if (句柄有效(矩形)) 矩形列表.push(矩形);
    }
  } else {
    const 矩形键 = `区域背景音乐.${配置.键}`;
    const 矩形 = 注册动态矩形区域({
      键: 矩形键,
      左: 配置.左 as number,
      右: 配置.右 as number,
      下: 配置.下 as number,
      上: 配置.上 as number,
      说明: `运行时区域背景音乐:${配置.键}`,
    });
    if (句柄有效(矩形)) {
      矩形列表.push(矩形);
      拥有动态矩形键列表.push(矩形键);
    }
  }
  if (矩形列表.length === 0) return false;

  // 区域 BGM 走 RegisterStackedSound 的背景音乐堆叠，不使用 3D 距离裁剪。
  // 3D 音频的声源位于矩形中心，玩家即使在矩形内也可能因距离超过默认 cutoff 而无声。
  const 音频 = CreateSound(配置.音乐路径, true, false, false, 10, 10, "DefaultEAXON");
  if (!句柄有效(音频)) {
    for (let i = 0; i < 拥有动态矩形键列表.length; i++) {
      注销动态矩形区域(拥有动态矩形键列表[i]);
    }
    return false;
  }
  区域背景音乐运行时状态表[配置.键] = {
    矩形列表,
    音频,
    已挂载: false,
    拥有动态矩形键列表,
  };
  return true;
}

export function 启用运行时区域背景音乐(this: void, 键: string): boolean {
  const 状态 = 区域背景音乐运行时状态表[键];
  if (状态 == null) return false;
  if (状态.已挂载) return true;

  for (let i = 0; i < 状态.矩形列表.length; i++) {
    if (!挂载区域背景音乐句柄(true, 状态.音频, 状态.矩形列表[i])) return false;
  }
  状态.已挂载 = true;
  return true;
}

export function 停用运行时区域背景音乐(this: void, 键: string): boolean {
  const 状态 = 区域背景音乐运行时状态表[键];
  if (状态 == null) return false;
  if (!状态.已挂载) return true;

  for (let i = 0; i < 状态.矩形列表.length; i++) {
    卸载区域背景音乐句柄(状态.音频, 状态.矩形列表[i]);
  }
  状态.已挂载 = false;
  return true;
}

/** 停止音频并释放运行时创建的矩形；地图编辑器矩形只释放音频句柄。 */
export function 清理运行时区域背景音乐(this: void, 键: string): boolean {
  const 状态 = 区域背景音乐运行时状态表[键];
  if (状态 == null) return false;

  停用运行时区域背景音乐(键);
  停止区域背景音乐句柄(状态.音频);
  for (let i = 0; i < 状态.拥有动态矩形键列表.length; i++) {
    注销动态矩形区域(状态.拥有动态矩形键列表[i]);
  }
  delete 区域背景音乐运行时状态表[键];
  return true;
}
