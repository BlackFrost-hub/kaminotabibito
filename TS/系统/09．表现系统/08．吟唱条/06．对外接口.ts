/**
 * 吟唱条系统 - 对外接口
 */

interface 吟唱条输入参数 {
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
  总时长: number;
  颜色ID: number;
  标题文本: string;
  提示文本: string;
}

const { 启动吟唱条: 核心启动吟唱条, 关闭吟唱条: 核心关闭吟唱条 } = require("./03．吟唱条核心") as {
  启动吟唱条: (this: void, 参数: 规范化吟唱条参数) => void;
  关闭吟唱条: (this: void) => void;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 常量 = require("./00．常量定义") as {
  默认颜色ID: number;
  默认标题文本: string;
  默认提示文本: string;
};

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
  debugLogForce("吟唱条对外接口", "收到显示请求", "self总时长=", (this as any)?.总时长, "第一参数总时长=", 第一参数?.总时长, "第一参数sj=", 第一参数?.sj, "第二参数总时长=", 第二参数?.总时长);
  const 参数 = 规范化参数(输入);
  debugLogForce("吟唱条对外接口", "规范化后", "总时长=", 参数.总时长, "颜色ID=", 参数.颜色ID, "提示=", 参数.提示文本);
  核心启动吟唱条(参数);
}

export function 关闭吟唱条(this: any, _第一参数?: any): void {
  核心关闭吟唱条();
}
