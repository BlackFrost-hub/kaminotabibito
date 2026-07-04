/** @noSelfInFile */

const { 延后一帧执行伤害派生效果 } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  延后一帧执行伤害派生效果: (this: void, cb: (this: void) => void) => void;
};

export interface 伤害派生批处理队列<T> {
  readonly 名称: string;
  加入(this: void, 上下文: T): void;
  清空(this: void): void;
}

export interface 伤害派生批处理队列选项<T> {
  处理: (this: void, 上下文: T) => void;
}

export function 创建伤害派生批处理队列<T>(this: void, 名称: string, 选项: 伤害派生批处理队列选项<T>): 伤害派生批处理队列<T> {
  const 队列: T[] = [];
  let 已安排处理 = false;

  function 执行批处理(this: void): void {
    已安排处理 = false;
    while (队列.length > 0) {
      const 上下文 = 队列.shift();
      if (上下文 == null) continue;
      选项.处理(上下文);
    }
  }

  return {
    名称,
    加入: function 加入(this: void, 上下文: T): void {
      队列.push(上下文);
      if (已安排处理) return;
      已安排处理 = true;
      延后一帧执行伤害派生效果(执行批处理);
    },
    清空: function 清空(this: void): void {
      while (队列.length > 0) 队列.pop();
      已安排处理 = false;
    },
  };
}

export {};
