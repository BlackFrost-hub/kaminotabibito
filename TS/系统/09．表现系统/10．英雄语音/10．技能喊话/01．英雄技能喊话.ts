/** @noSelfInFile */

import {
  英雄技能喊话配置,
  英雄技能喊话配置列表,
  伊蕾娜D变式喊话配置,
  伊蕾娜变式喊话键,
} from "./00．配置";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;

const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const 技能喊话冷却表: Record<string, number> = {};

function 取普通配置(this: void, 英雄名: string, 技能ID: string): 英雄技能喊话配置 | null {
  for (let i = 0; i < 英雄技能喊话配置列表.length; i++) {
    const 配置 = 英雄技能喊话配置列表[i];
    if (配置.英雄名 === 英雄名 && 配置.技能ID === 技能ID) return 配置;
  }
  return null;
}

function 取D变式配置(this: void, 变式: string | undefined): 英雄技能喊话配置 | null {
  if (变式 !== "迅行" && 变式 !== "镜界" && 变式 !== "灰烬") return null;
  return 伊蕾娜D变式喊话配置[变式 as 伊蕾娜变式喊话键];
}

function 取候选语音(this: void, 配置: 英雄技能喊话配置): string {
  const 列表 = 配置.候选语音列表;
  if (列表.length <= 1 || 配置.随机播放 !== true) return 列表[0] ?? "";
  const 索引 = GetRandomInt(1, 列表.length) - 1;
  return 列表[索引] ?? 列表[0];
}

/**
 * 全局播放一次英雄技能喊话。
 * 不做 GetLocalPlayer 或玩家归属过滤；Sound3DII 的单位位置决定听到的距离。
 * 返回 true 仅表示本次已取得并启动声音句柄。
 */
export function 播放英雄技能喊话(
  this: void,
  施法者: any,
  英雄名: string,
  技能ID: string,
  伊蕾娜变式?: string,
): boolean {
  if (施法者 == null || 施法者 === 0) return false;

  let 配置 = 取普通配置(英雄名, 技能ID);
  if (英雄名 === "伊蕾娜" && 技能ID === "AID1") {
    配置 = 取D变式配置(伊蕾娜变式) ?? 配置;
  }
  if (配置 == null) return false;

  const 冷却键 = GetHandleId(施法者) + ":" + 英雄名 + ":" + 技能ID;
  const 当前时间 = getServerTime();
  const 冷却结束时间 = 技能喊话冷却表[冷却键] ?? 0;
  if (冷却结束时间 > 当前时间) return false;

  const 声音路径 = 取候选语音(配置);
  if (声音路径 === "") return false;
  const 声音句柄 = Sound3DII_UnitPlayReuse(声音路径, 施法者, 配置.三D裁断距离);
  if (声音句柄 == null || 声音句柄 === 0) return false;

  技能喊话冷却表[冷却键] = 当前时间 + 配置.语音冷却秒 * 1000;
  return true;
}

export {};
