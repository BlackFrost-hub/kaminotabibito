/** @noSelfInFile */

type 剧情片段清理函数 = (this: void) => void;

const 剧情片段清理表: Record<string, 剧情片段清理函数 | undefined> = {};

/**
 * 注册片段级清理回调。播放器在正常结束和 ESC 跳过时都会调用，回调必须幂等。
 */
export function 注册剧情片段清理(this: void, 片段ID: string, 清理函数: 剧情片段清理函数): void {
  if (片段ID === "" || 清理函数 == null) return;
  剧情片段清理表[片段ID] = 清理函数;
}

export function 执行剧情片段清理(this: void, 片段ID: string): void {
  if (片段ID === "") return;
  const 清理函数 = 剧情片段清理表[片段ID];
  if (清理函数 == null) return;
  清理函数();
}

