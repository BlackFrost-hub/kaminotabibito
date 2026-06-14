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
  吟唱条通道_常规技能: string;
  吟唱条通道_大招: string;
  吟唱条通道_场地常驻AOE: string;
  吟唱条通道_致命惩罚: string;
  吟唱条通道_场地AOE: string;
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
  创建吟唱条UI: (this: void, 通道: string) => any;
  隐藏吟唱条UI: (this: void, 通道: string) => void;
  显示吟唱条UI: (this: void, 通道: string) => void;
  更新吟唱条模型: (this: void, 通道: string, 颜色ID: number) => void;
  更新吟唱条文本: (this: void, 通道: string, 标题文本: string, 提示文本: string) => void;
  更新吟唱条数值: (this: void, 通道: string, 已过秒: string, 剩余秒: string) => void;
  设置吟唱条动画进度: (this: void, 通道: string, 进度: number) => void;
};

const { 格式化已过秒, 格式化一位小数 } = require("./04．数字格式化") as {
  格式化已过秒: (this: void, 已过时间: number) => string;
  格式化一位小数: (this: void, n: number) => string;
};

const R2I = jass.R2I as (value: number) => number;

interface 吟唱条状态 {
  通道: string;
  活跃: boolean;
  总时长: number;
  已过时间: number;
  进度: number;
  颜色ID: number;
  标题文本: string;
  提示文本: string;
}

interface 规范化吟唱条参数 {
  通道: string;
  总时长: number;
  颜色ID: number;
  标题文本: string;
  提示文本: string;
}

let 常规技能吟唱条状态实例: 吟唱条状态 | null = null;
let 大招吟唱条状态实例: 吟唱条状态 | null = null;
let 场地常驻AOE吟唱条状态实例: 吟唱条状态 | null = null;
let 致命惩罚吟唱条状态实例: 吟唱条状态 | null = null;
let 已注册中心计时器 = false;

function 创建空状态(this: void, 通道: string): 吟唱条状态 {
  return {
    通道,
    活跃: false,
    总时长: 0,
    已过时间: 0,
    进度: 0,
    颜色ID: 常量.默认颜色ID,
    标题文本: 常量.默认标题文本,
    提示文本: 常量.默认提示文本,
  };
}

function 获取状态实例(this: void, 通道: string): 吟唱条状态 | null {
  if (通道 === 常量.吟唱条通道_致命惩罚) return 致命惩罚吟唱条状态实例;
  if (通道 === 常量.吟唱条通道_场地常驻AOE) return 场地常驻AOE吟唱条状态实例;
  if (通道 === 常量.吟唱条通道_大招 || 通道 === 常量.吟唱条通道_场地AOE) return 大招吟唱条状态实例;
  return 常规技能吟唱条状态实例;
}

function 获取或创建状态实例(this: void, 通道: string): 吟唱条状态 {
  let 状态 = 获取状态实例(通道);
  if (状态 != null) return 状态;
  状态 = 创建空状态(通道);
  if (通道 === 常量.吟唱条通道_致命惩罚) {
    致命惩罚吟唱条状态实例 = 状态;
  } else if (通道 === 常量.吟唱条通道_场地常驻AOE) {
    场地常驻AOE吟唱条状态实例 = 状态;
  } else if (通道 === 常量.吟唱条通道_大招 || 通道 === 常量.吟唱条通道_场地AOE) {
    大招吟唱条状态实例 = 状态;
  } else {
    常规技能吟唱条状态实例 = 状态;
  }
  return 状态;
}

function 是否有活跃吟唱条(this: void): boolean {
  if (常规技能吟唱条状态实例 != null && 常规技能吟唱条状态实例.活跃) return true;
  if (大招吟唱条状态实例 != null && 大招吟唱条状态实例.活跃) return true;
  if (场地常驻AOE吟唱条状态实例 != null && 场地常驻AOE吟唱条状态实例.活跃) return true;
  if (致命惩罚吟唱条状态实例 != null && 致命惩罚吟唱条状态实例.活跃) return true;
  return false;
}

function 确保中心计时器(this: void): void {
  if (已注册中心计时器) return;
  已注册中心计时器 = true;
  onTick10ms(驱动吟唱条);
}

function 尝试关闭中心计时器(this: void): void {
  if (!已注册中心计时器) return;
  if (是否有活跃吟唱条()) return;
  已注册中心计时器 = false;
  offTick10ms(驱动吟唱条);
}

function 驱动单个吟唱条(this: void, 状态: 吟唱条状态): void {
  if (!状态.活跃) return;

  状态.已过时间 += 常量.吟唱条步进秒;
  状态.进度 = 状态.已过时间 / 状态.总时长;

  更新吟唱条数值(
    状态.通道,
    格式化已过秒(状态.已过时间),
    格式化一位小数(状态.总时长),
  );
  设置吟唱条动画进度(状态.通道, 状态.进度);

  if (状态.已过时间 >= 状态.总时长) {
    关闭吟唱条(状态.通道);
  }
}

function 驱动吟唱条(this: void): void {
  if (常规技能吟唱条状态实例 != null) 驱动单个吟唱条(常规技能吟唱条状态实例);
  if (大招吟唱条状态实例 != null) 驱动单个吟唱条(大招吟唱条状态实例);
  if (场地常驻AOE吟唱条状态实例 != null) 驱动单个吟唱条(场地常驻AOE吟唱条状态实例);
  if (致命惩罚吟唱条状态实例 != null) 驱动单个吟唱条(致命惩罚吟唱条状态实例);
}

export function 启动吟唱条(this: void, 参数: 规范化吟唱条参数): void {
  if (!(参数.总时长 > 0)) {
    return;
  }

  let 通道 = 常量.吟唱条通道_常规技能;
  if (参数.通道 === 常量.吟唱条通道_致命惩罚) {
    通道 = 常量.吟唱条通道_致命惩罚;
  } else if (参数.通道 === 常量.吟唱条通道_场地常驻AOE) {
    通道 = 常量.吟唱条通道_场地常驻AOE;
  } else if (参数.通道 === 常量.吟唱条通道_大招 || 参数.通道 === 常量.吟唱条通道_场地AOE) {
    通道 = 常量.吟唱条通道_大招;
  }
  const 状态 = 获取或创建状态实例(通道);

  状态.活跃 = true;
  状态.总时长 = 参数.总时长;
  状态.已过时间 = 0;
  状态.进度 = 0;
  状态.颜色ID = 参数.颜色ID;
  状态.标题文本 = 参数.标题文本;
  状态.提示文本 = 参数.提示文本;

  创建吟唱条UI(通道);
  更新吟唱条模型(通道, 参数.颜色ID);
  更新吟唱条文本(通道, 参数.标题文本, 参数.提示文本);
  更新吟唱条数值(通道, "0.0", 格式化一位小数(参数.总时长));
  设置吟唱条动画进度(通道, 0);
  显示吟唱条UI(通道);

  确保中心计时器();
}

export function 关闭吟唱条(this: void, 通道 = 常量.吟唱条通道_常规技能): void {
  const 状态 = 获取状态实例(通道);
  if (状态 == null) return;

  状态.活跃 = false;
  隐藏吟唱条UI(通道);
  尝试关闭中心计时器();
}

export function 获取吟唱条状态(this: void, 通道 = 常量.吟唱条通道_常规技能): 吟唱条状态 | null {
  return 获取状态实例(通道);
}
