/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;

export type Boss台词表 = Record<string, readonly string[]>;

export function 取Boss台词文本(this: void, 台词表: Boss台词表, 类型: string, index?: number): string | undefined {
  const lines = 台词表[类型];
  if (lines == null || lines.length <= 0) return undefined;
  const lineIndex = index ?? GetRandomInt(0, lines.length - 1);
  return (lines[lineIndex] ?? lines[0]) as string | undefined;
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
