/**
 * 吟唱条系统 - 对外接口
 */

interface 吟唱条输入参数 {
  通道?: string;
  类型?: string;
  总时长?: number;
  sj?: number;
  // 旧兼容字段，测试完成后不再建议新增调用使用
  time?: number;
  颜色ID?: number;
  颜色?: number;
  标题文本?: string;
  标题?: string;
  提示文本?: string;
  文本?: string;
  // 旧 STES/YDLocal 兼容字段
  string?: string;
}

interface 规范化吟唱条参数 {
  通道: string;
  总时长: number;
  颜色ID: number;
  标题文本: string;
  提示文本: string;
}

const { 启动吟唱条: 核心启动吟唱条, 关闭吟唱条: 核心关闭吟唱条 } = require("./03．吟唱条核心") as {
  启动吟唱条: (this: void, 参数: 规范化吟唱条参数) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};

const 常量 = require("./00．常量定义") as {
  默认颜色ID: number;
  默认标题文本: string;
  默认提示文本: string;
  吟唱条通道_常规技能: string;
  吟唱条通道_大招: string;
  吟唱条通道_场地常驻AOE: string;
  吟唱条通道_致命惩罚: string;
  吟唱条通道_场地AOE: string;
};

function 规范化通道(this: void, 输入?: string): string {
  if (输入 === 常量.吟唱条通道_致命惩罚 || 输入 === "秒杀惩罚" || 输入 === "惩罚" || 输入 === "wipe" || 输入 === "Wipe") {
    return 常量.吟唱条通道_致命惩罚;
  }
  if (输入 === 常量.吟唱条通道_场地常驻AOE || 输入 === "场地常驻AOE" || 输入 === "常驻AOE" || 输入 === "场地常驻") {
    return 常量.吟唱条通道_场地常驻AOE;
  }
  if (输入 === 常量.吟唱条通道_大招 || 输入 === 常量.吟唱条通道_场地AOE || 输入 === "场地" || 输入 === "AOE" || 输入 === "大型AOE") {
    return 常量.吟唱条通道_大招;
  }
  return 常量.吟唱条通道_常规技能;
}

function 规范化参数(输入: 吟唱条输入参数): 规范化吟唱条参数 {
  if (输入 == null) {
    输入 = {} as 吟唱条输入参数;
  }
  let 总时长 = 输入.总时长;
  if (总时长 == null || 总时长 === 0) {
    总时长 = 输入.sj;
  }
  if (总时长 == null || 总时长 === 0) {
    总时长 = 输入.time;
  }

  let 颜色ID = 输入.颜色ID;
  if (颜色ID == null || 颜色ID === 0) {
    颜色ID = 输入.颜色;
  }
  if (颜色ID == null || 颜色ID === 0) {
    颜色ID = 常量.默认颜色ID;
  }

  let 标题文本 = 输入.标题文本;
  if (标题文本 == null || 标题文本 === "") {
    标题文本 = 输入.标题;
  }
  if (标题文本 == null || 标题文本 === "") {
    标题文本 = 常量.默认标题文本;
  }

  let 提示文本 = 输入.提示文本;
  if (提示文本 == null || 提示文本 === "") {
    提示文本 = 输入.文本;
  }
  if (提示文本 == null || 提示文本 === "") {
    提示文本 = 输入.string;
  }
  if (提示文本 == null || 提示文本 === "") {
    提示文本 = 常量.默认提示文本;
  }

  return {
    通道: 规范化通道(输入.通道 || 输入.类型),
    总时长: 总时长 || 0,
    颜色ID,
    标题文本,
    提示文本,
  };
}

export function 显示吟唱条(this: any, 第一参数?: any, 第二参数?: 吟唱条输入参数): void {
  let 输入 = 第二参数 as 吟唱条输入参数 | undefined;
  if (输入 == null) {
    输入 = 第一参数 as 吟唱条输入参数 | undefined;
  }
  if (输入 == null) {
    输入 = this as 吟唱条输入参数 | undefined;
  }
  if (输入 == null) {
    输入 = {} as 吟唱条输入参数;
  }
  const 参数 = 规范化参数(输入);
  核心启动吟唱条(参数);
}

export function 关闭吟唱条(this: any, 第一参数?: any): void {
  let 通道 = 第一参数 as string | undefined;
  if (通道 == null) {
    if (typeof this === "string") {
      通道 = this;
    } else if (this != null && typeof this === "object") {
      通道 = (this as 吟唱条输入参数).通道 || (this as 吟唱条输入参数).类型;
    }
  }
  核心关闭吟唱条(规范化通道(通道));
}

export function 显示常规技能吟唱条(this: void, 参数: 吟唱条输入参数): void {
  参数.通道 = 常量.吟唱条通道_常规技能;
  显示吟唱条(参数);
}

export function 显示大招吟唱条(this: void, 参数: 吟唱条输入参数): void {
  参数.通道 = 常量.吟唱条通道_大招;
  显示吟唱条(参数);
}

export function 显示场地常驻AOE吟唱条(this: void, 参数: 吟唱条输入参数): void {
  参数.通道 = 常量.吟唱条通道_场地常驻AOE;
  显示吟唱条(参数);
}

export function 显示致命惩罚吟唱条(this: void, 参数: 吟唱条输入参数): void {
  参数.通道 = 常量.吟唱条通道_致命惩罚;
  显示吟唱条(参数);
}

export function 显示场地AOE吟唱条(this: void, 参数: 吟唱条输入参数): void {
  显示大招吟唱条(参数);
}
