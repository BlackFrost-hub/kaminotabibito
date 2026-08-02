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

export interface 动态区域背景音乐配置 {
  键: string;
  音乐路径: string;
  区域全局名?: string;
  左?: number;
  右?: number;
  下?: number;
  上?: number;
}

interface 动态区域背景音乐状态 {
  矩形: any;
  音频: any;
  已挂载: boolean;
  是否自建矩形: boolean;
}

const 动态区域背景音乐状态表: Record<string, 动态区域背景音乐状态 | undefined> = {};

export const 封印守卫战区域音乐配置: 动态区域背景音乐配置 = {
  键: "第三章.封印守卫战",
  音乐路径: "Sound\\BGM\\Scene\\SealCore\\void_light_seal_land_80k.mp3",
  左: -928,
  右: 2848,
  下: -11648,
  上: -8160,
};

export const 第二章精灵城背景音乐配置: 动态区域背景音乐配置 = {
  键: "第二章.精灵城背景",
  音乐路径: "Sound\\BGM\\Scene\\SealCore\\Ryo Kondo - Abode of the Ancient Gods.mp3",
  区域全局名: "gg_rct__________u",
};

export const 第二章精灵城王宫背景音乐配置: 动态区域背景音乐配置 = {
  键: "第二章.精灵城王宫背景",
  音乐路径: "Sound\\BGM\\Scene\\SealCore\\Falcom Sound Team J.D.K. - Royal Castle.mp3",
  左: -12672,
  右: -3872,
  下: -12832,
  上: -10848,
};

export const 第二章精灵城区域122背景音乐配置: 动态区域背景音乐配置 = {
  键: "第二章.精灵城区域122背景",
  音乐路径: "Sound\\BGM\\Scene\\SealCore\\Falcom Sound Team J.D.K. - Guardian of the Sacred Treasure.mp3",
  区域全局名: "gg_rct______________122",
};

export const 第二章菲利斯攻城区域背景音乐配置: 动态区域背景音乐配置 = {
  键: "第二章.菲利斯攻城区域背景",
  音乐路径: "Sound\\BGM\\Scene\\SealCore\\Falcom Sound Team J.D.K. - Guardian of the Sacred Treasure.mp3",
  左: -8480,
  右: -3648,
  下: -16736,
  上: -12672,
};

/** 巴尔扎罗斯死亡后，通往亚伦柯斯前的封印墓地背景音乐区域。 */
export const 第三章亚伦柯斯前导区域背景音乐配置: 动态区域背景音乐配置 = {
  键: "第三章.亚伦柯斯前导区域",
  音乐路径: "Sound\\BGM\\Scene\\SealCore\\Falcom Sound Team J.D.K. - Seal of Time (Original).mp3",
  左: 4832,
  右: 11616,
  下: -17088,
  上: -14624,
};

const 图4区域全局名 = "gg_rct______________027";
const 图4旧背景音乐全局名 = "gg_snd_baiyihu_yueya";
let 图4旧背景音乐已清理 = false;
let 第三章亚伦柯斯前导区域背景音乐已永久清理 = false;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 配置有效(this: void, 配置: 动态区域背景音乐配置): boolean {
  return 配置.键 !== ""
    && 配置.音乐路径 !== ""
    && ((配置.区域全局名 != null && 配置.区域全局名 !== "")
      || (配置.左 != null && 配置.右 != null && 配置.下 != null && 配置.上 != null
        && 配置.左 < 配置.右
        && 配置.下 < 配置.上));
}

export function 注册动态区域背景音乐(this: void, 配置: 动态区域背景音乐配置): boolean {
  if (!配置有效(配置)) return false;
  if (动态区域背景音乐状态表[配置.键] != null) return true;

  const 使用地图矩形 = 配置.区域全局名 != null && 配置.区域全局名 !== "";
  const 矩形 = 使用地图矩形
    ? jglobals[配置.区域全局名 as string]
    : Rect(配置.左 as number, 配置.下 as number, 配置.右 as number, 配置.上 as number);
  if (!句柄有效(矩形)) return false;

  const 音频 = CreateSound(配置.音乐路径, true, true, true, 10, 10, "DefaultEAXON");
  if (!句柄有效(音频)) {
    if (!使用地图矩形) RemoveRect(矩形);
    return false;
  }

  动态区域背景音乐状态表[配置.键] = {
    矩形,
    音频,
    已挂载: false,
    是否自建矩形: !使用地图矩形,
  };
  return true;
}

export function 添加动态区域背景音乐(this: void, 键: string): boolean {
  const 状态 = 动态区域背景音乐状态表[键];
  if (状态 == null) return false;
  if (状态.已挂载) return true;

  SetStackedSoundBJ(true, 状态.音频, 状态.矩形);
  状态.已挂载 = true;
  return true;
}

export function 移除动态区域背景音乐(this: void, 键: string): boolean {
  const 状态 = 动态区域背景音乐状态表[键];
  if (状态 == null) return false;
  if (!状态.已挂载) return true;

  SetStackedSoundBJ(false, 状态.音频, 状态.矩形);
  状态.已挂载 = false;
  return true;
}

export function 清理动态区域背景音乐(this: void, 键: string): boolean {
  const 状态 = 动态区域背景音乐状态表[键];
  if (状态 == null) return false;

  移除动态区域背景音乐(键);
  if (句柄有效(状态.音频)) {
    StopSound(状态.音频, true, false);
  }
  if (状态.是否自建矩形 && 句柄有效(状态.矩形)) RemoveRect(状态.矩形);
  delete 动态区域背景音乐状态表[键];
  return true;
}

/** 移除编辑器图4区域原有的环境音效并释放该矩形；清理后不再恢复。 */
function 清理图4旧背景音乐(this: void): boolean {
  if (图4旧背景音乐已清理) return true;

  const 矩形 = jglobals[图4区域全局名];
  const 音频 = jglobals[图4旧背景音乐全局名];
  if (句柄有效(矩形) && 句柄有效(音频)) {
    SetStackedSoundBJ(false, 音频, 矩形);
  }
  if (句柄有效(音频)) {
    StopSound(音频, true, false);
  }
  if (句柄有效(矩形)) RemoveRect(矩形);
  图4旧背景音乐已清理 = true;
  return true;
}

export function 注册封印守卫战区域音乐(this: void): boolean {
  return 注册动态区域背景音乐(封印守卫战区域音乐配置);
}

export function 启用封印守卫战区域音乐(this: void): boolean {
  if (!注册封印守卫战区域音乐()) return false;
  return 添加动态区域背景音乐(封印守卫战区域音乐配置.键);
}

export function 停用封印守卫战区域音乐(this: void): boolean {
  return 移除动态区域背景音乐(封印守卫战区域音乐配置.键);
}

export function 清理封印守卫战区域音乐(this: void): boolean {
  return 清理动态区域背景音乐(封印守卫战区域音乐配置.键);
}

export function 注册第二章精灵城背景音乐(this: void): boolean {
  return 注册动态区域背景音乐(第二章精灵城背景音乐配置);
}

export function 启用第二章精灵城背景音乐(this: void): boolean {
  if (!注册第二章精灵城背景音乐()) return false;
  return 添加动态区域背景音乐(第二章精灵城背景音乐配置.键);
}

export function 停用第二章精灵城背景音乐(this: void): boolean {
  return 移除动态区域背景音乐(第二章精灵城背景音乐配置.键);
}

export function 清理第二章精灵城背景音乐(this: void): boolean {
  return 清理动态区域背景音乐(第二章精灵城背景音乐配置.键);
}

export function 注册第二章精灵城王宫背景音乐(this: void): boolean {
  return 注册动态区域背景音乐(第二章精灵城王宫背景音乐配置);
}

export function 启用第二章精灵城王宫背景音乐(this: void): boolean {
  if (!注册第二章精灵城王宫背景音乐()) return false;
  return 添加动态区域背景音乐(第二章精灵城王宫背景音乐配置.键);
}

export function 停用第二章精灵城王宫背景音乐(this: void): boolean {
  return 移除动态区域背景音乐(第二章精灵城王宫背景音乐配置.键);
}

export function 清理第二章精灵城王宫背景音乐(this: void): boolean {
  return 清理动态区域背景音乐(第二章精灵城王宫背景音乐配置.键);
}

export function 注册第二章精灵城区域122背景音乐(this: void): boolean {
  return 注册动态区域背景音乐(第二章精灵城区域122背景音乐配置);
}

export function 启用第二章精灵城区域122背景音乐(this: void): boolean {
  if (!注册第二章精灵城区域122背景音乐()) return false;
  return 添加动态区域背景音乐(第二章精灵城区域122背景音乐配置.键);
}

export function 停用第二章精灵城区域122背景音乐(this: void): boolean {
  return 移除动态区域背景音乐(第二章精灵城区域122背景音乐配置.键);
}

export function 清理第二章精灵城区域122背景音乐(this: void): boolean {
  return 清理动态区域背景音乐(第二章精灵城区域122背景音乐配置.键);
}

export function 注册第二章菲利斯攻城区域背景音乐(this: void): boolean {
  return 注册动态区域背景音乐(第二章菲利斯攻城区域背景音乐配置);
}

export function 启用第二章菲利斯攻城区域背景音乐(this: void): boolean {
  if (!注册第二章菲利斯攻城区域背景音乐()) return false;
  return 添加动态区域背景音乐(第二章菲利斯攻城区域背景音乐配置.键);
}

export function 停用第二章菲利斯攻城区域背景音乐(this: void): boolean {
  return 移除动态区域背景音乐(第二章菲利斯攻城区域背景音乐配置.键);
}

export function 清理第二章菲利斯攻城区域背景音乐(this: void): boolean {
  return 清理动态区域背景音乐(第二章菲利斯攻城区域背景音乐配置.键);
}

export function 注册第三章亚伦柯斯前导区域背景音乐(this: void): boolean {
  if (第三章亚伦柯斯前导区域背景音乐已永久清理) return false;
  return 注册动态区域背景音乐(第三章亚伦柯斯前导区域背景音乐配置);
}

export function 启用第三章亚伦柯斯前导区域背景音乐(this: void): boolean {
  if (第三章亚伦柯斯前导区域背景音乐已永久清理) return false;
  if (!注册第三章亚伦柯斯前导区域背景音乐()) return false;
  return 添加动态区域背景音乐(第三章亚伦柯斯前导区域背景音乐配置.键);
}

export function 停用第三章亚伦柯斯前导区域背景音乐(this: void): boolean {
  return 移除动态区域背景音乐(第三章亚伦柯斯前导区域背景音乐配置.键);
}

export function 清理第三章亚伦柯斯前导区域背景音乐(this: void): boolean {
  return 清理动态区域背景音乐(第三章亚伦柯斯前导区域背景音乐配置.键);
}

/** 亚伦柯斯战斗启动后永久移除图4旧音效及本段动态音乐。 */
export function 清理第三章亚伦柯斯战斗前图4区域背景音乐(this: void): boolean {
  const 动态音乐已清理 = 清理第三章亚伦柯斯前导区域背景音乐();
  const 图4旧音乐已清理 = 清理图4旧背景音乐();
  第三章亚伦柯斯前导区域背景音乐已永久清理 = true;
  return 动态音乐已清理 || 图4旧音乐已清理;
}

/** 会议决定出发后，暂时卸载第二章原有区域音乐并切换到攻城区域音乐。 */
export function 开始第二章菲利斯攻城区域音乐(this: void): boolean {
  清理第二章精灵城背景音乐();
  清理第二章精灵城王宫背景音乐();
  清理第二章精灵城区域122背景音乐();
  return 启用第二章菲利斯攻城区域背景音乐();
}

/** 菲利斯死亡后清理攻城音乐，并恢复第二章原有区域音乐。 */
export function 结束第二章菲利斯攻城区域音乐(this: void): boolean {
  清理第二章菲利斯攻城区域背景音乐();
  const 城区音乐已恢复 = 启用第二章精灵城背景音乐();
  const 王宫音乐已恢复 = 启用第二章精灵城王宫背景音乐();
  const 区域122音乐已恢复 = 启用第二章精灵城区域122背景音乐();
  return 城区音乐已恢复 && 王宫音乐已恢复 && 区域122音乐已恢复;
}

export function 注册封印核心战后区域音乐(this: void): boolean {
  return 注册封印守卫战区域音乐();
}

export function 启用封印核心战后区域音乐(this: void): boolean {
  return 启用封印守卫战区域音乐();
}

export function 停用封印核心战后区域音乐(this: void): boolean {
  return 停用封印守卫战区域音乐();
}

export function 清理封印核心战后区域音乐(this: void): boolean {
  return 清理封印守卫战区域音乐();
}
