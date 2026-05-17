/** @noSelfInFile */
/**
 * 吟唱条系统 - 核心逻辑
 */

const jass = require("jass.common") as any;

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};
const 常量 = require("./00．常量定义") as {
  模块名: string;
  吟唱条步进秒: number;
  默认颜色ID: number;
  默认标题文本: string;
  默认提示文本: string;
};

const {
  创建吟唱条UI,
  隐藏吟唱条UI,
  显示吟唱条UI,
  更新吟唱条模型,
  更新吟唱条文本,
  更新吟唱条数值,
  设置吟唱条动画进度,
} = require("./02．UI创建") as {
  创建吟唱条UI: (this: void) => any;
  隐藏吟唱条UI: (this: void) => void;
  显示吟唱条UI: (this: void) => void;
  更新吟唱条模型: (this: void, 颜色ID: number) => void;
  更新吟唱条文本: (this: void, 标题文本: string, 提示文本: string) => void;
  更新吟唱条数值: (this: void, 已过秒: string, 剩余秒: string) => void;
  设置吟唱条动画进度: (this: void, 进度: number) => void;
};

const { 格式化已过秒, 格式化一位小数 } = require("./04．数字格式化") as {
  格式化已过秒: (this: void, 已过时间: number) => string;
  格式化一位小数: (this: void, n: number) => string;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const R2I = jass.R2I as (value: number) => number;

interface 吟唱条状态 {
  活跃: boolean;
  总时长: number;
  已过时间: number;
  进度: number;
  颜色ID: number;
  标题文本: string;
  提示文本: string;
}

interface 规范化吟唱条参数 {
  总时长: number;
  颜色ID: number;
  标题文本: string;
  提示文本: string;
}

let 吟唱条状态实例: 吟唱条状态 | null = null;
let 已注册中心计时器 = false;
let 下次调试已过时间 = 1.0;

function 确保中心计时器(this: void): void {
  if (已注册中心计时器) return;
  已注册中心计时器 = true;
  onTick10ms(驱动吟唱条);
}

function 尝试关闭中心计时器(this: void): void {
  if (!已注册中心计时器) return;
  if (吟唱条状态实例 != null && 吟唱条状态实例.活跃) return;
  已注册中心计时器 = false;
  offTick10ms(驱动吟唱条);
}

function 驱动吟唱条(this: void): void {
  if (吟唱条状态实例 == null || !吟唱条状态实例.活跃) return;

  吟唱条状态实例.已过时间 += 常量.吟唱条步进秒;
  吟唱条状态实例.进度 = 吟唱条状态实例.已过时间 / 吟唱条状态实例.总时长;

  更新吟唱条数值(
    格式化已过秒(吟唱条状态实例.已过时间),
    格式化一位小数(吟唱条状态实例.总时长),
  );
  设置吟唱条动画进度(吟唱条状态实例.进度);

  if (吟唱条状态实例.已过时间 >= 下次调试已过时间) {
    debugLogForce(常量.模块名, "推进中", "已过=", 吟唱条状态实例.已过时间, "进度=", 吟唱条状态实例.进度);
    下次调试已过时间 += 1.0;
  }

  if (吟唱条状态实例.已过时间 >= 吟唱条状态实例.总时长) {
    关闭吟唱条();
  }
}

export function 启动吟唱条(this: void, 参数: 规范化吟唱条参数): void {
  if (!(参数.总时长 > 0)) {
    debugLogForce(常量.模块名, "总时长无效", 参数.总时长);
    return;
  }

  if (吟唱条状态实例 == null) {
    吟唱条状态实例 = {
      活跃: false,
      总时长: 0,
      已过时间: 0,
      进度: 0,
      颜色ID: 常量.默认颜色ID,
      标题文本: 常量.默认标题文本,
      提示文本: 常量.默认提示文本,
    };
  }

  吟唱条状态实例.活跃 = true;
  吟唱条状态实例.总时长 = 参数.总时长;
  吟唱条状态实例.已过时间 = 0;
  吟唱条状态实例.进度 = 0;
  下次调试已过时间 = 1.0;
  吟唱条状态实例.颜色ID = 参数.颜色ID;
  吟唱条状态实例.标题文本 = 参数.标题文本;
  吟唱条状态实例.提示文本 = 参数.提示文本;

  创建吟唱条UI();
  更新吟唱条模型(参数.颜色ID);
  更新吟唱条文本(参数.标题文本, 参数.提示文本);
  更新吟唱条数值("0.0", 格式化一位小数(参数.总时长));
  设置吟唱条动画进度(0);
  显示吟唱条UI();

  确保中心计时器();
  debugLogForce(常量.模块名, "启动", "总时长=", 参数.总时长, "颜色ID=", 参数.颜色ID);
}

export function 关闭吟唱条(this: void): void {
  if (吟唱条状态实例 == null) return;

  吟唱条状态实例.活跃 = false;
  隐藏吟唱条UI();
  尝试关闭中心计时器();

  debugLogForce(常量.模块名, "关闭");
}

export function 获取吟唱条状态(this: void): 吟唱条状态 | null {
  return 吟唱条状态实例;
}
