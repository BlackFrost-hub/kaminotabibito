/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};

const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;
const StopSound = jass.StopSound as (soundHandle: any, killWhenDone: boolean, fadeOut: boolean) => void;

const Boss配音句柄表: Record<string, any> = {};

export type Boss台词表 = Record<string, readonly string[]>;
export type Boss配音资源表 = Record<string, readonly string[]>;

export interface Boss台词播放配置 {
  台词: Boss台词表;
  广播持续时间Ms: number;
  配音组?: string;
  配音资源?: Boss配音资源表;
  配音裁断距离?: number;
  配音允许重叠?: boolean;
}

export function 取Boss台词下标(this: void, 台词表: Boss台词表, 类型: string, index?: number): number | undefined {
  const lines = 台词表[类型];
  if (lines == null || lines.length <= 0) return undefined;
  if (index != null) return index;
  return GetRandomInt(0, lines.length - 1);
}

export function 取Boss台词文本(this: void, 台词表: Boss台词表, 类型: string, index?: number): string | undefined {
  const lines = 台词表[类型];
  if (lines == null || lines.length <= 0) return undefined;
  const lineIndex = 取Boss台词下标(台词表, 类型, index);
  if (lineIndex == null) return undefined;
  return (lines[lineIndex] ?? lines[0]) as string | undefined;
}

export function 播放Boss台词配音(
  this: void,
  来源单位: any,
  配音资源表: Boss配音资源表 | undefined,
  类型: string,
  index: number,
  裁断距离?: number,
  允许重叠?: boolean,
  配音组 = 'BossVoice'
): void {
  if (配音资源表 == null) return;
  const paths = 配音资源表[类型];
  if (paths == null || paths.length <= 0) return;
  const path = paths[index] ?? paths[0];
  if (path == null || path === "") return;
  const 上一条配音句柄 = Boss配音句柄表[配音组];
  if (!允许重叠 && 上一条配音句柄 != null && 上一条配音句柄 !== 0) {
    StopSound(上一条配音句柄, false, false);
  }
  Boss配音句柄表[配音组] = Sound3DII_UnitPlayReuse(path, 来源单位, 裁断距离 ?? 4000);
}

export function 播放Boss台词广播(
  this: void,
  来源单位: any,
  台词表: Boss台词表,
  类型: string,
  持续时间Ms: number,
  index?: number
): void {
  const text = 取Boss台词文本(台词表, 类型, index);
  if (text == null || text === "") return;
  广播单位提示(来源单位, text, 持续时间Ms);
}

export function 播放Boss台词(
  this: void,
  来源单位: any,
  配置: Boss台词播放配置,
  类型: string,
  index?: number
): void {
  const actualIndex = 取Boss台词下标(配置.台词, 类型, index);
  if (actualIndex == null) return;
  播放Boss台词广播(来源单位, 配置.台词, 类型, 配置.广播持续时间Ms, actualIndex);
  const 配音组 = 配置.配音组 ?? (配置 as any).BossKey ?? 'BossVoice';
  播放Boss台词配音(来源单位, 配置.配音资源, 类型, actualIndex, 配置.配音裁断距离, 配置.配音允许重叠, 配音组);
}
