/** @noSelfInFile */
/**
 * 治疗波跳链测试
 *
 * 输入 137：测试治疗波跳链
 * 输入 138：测试治疗波跳链（带衰减）
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitName = jass.GetUnitName as (u: any) => string;
const SquareRoot = jass.SquareRoot as (x: number) => number;

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const { 发起治疗波跳链 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.index") as {
  发起治疗波跳链: (this: void, 参数: any) => any;
};

const 模块名 = "治疗波跳链测试";
const 测试命令1 = "137";
const 测试命令2 = "138";
const 搜索半径 = 900;
const 默认最大跳数 = 7;
const 默认每跳最大距离 = 600;
const 默认初始治疗量 = 100;
const 默认跳跃间隔 = 0.05;

function 查找最近友军(来源单位: any, x: number, y: number): any {
  const 候选单位 = getUnitsInRange(x, y, 搜索半径);
  let 最佳目标: any = null;
  let 最佳距离 = 0;

  for (const 单位 of 候选单位) {
    if (单位 === 来源单位) continue;
    if (!isUnitAlly(单位, 来源单位)) continue;
    const 距离 = SquareRoot((GetUnitX(单位) - x) * (GetUnitX(单位) - x) + (GetUnitY(单位) - y) * (GetUnitY(单位) - y));
    if (最佳目标 == null || 距离 < 最佳距离) {
      最佳目标 = 单位;
      最佳距离 = 距离;
    }
  }

  return 最佳目标;
}

function 治疗波每跳回调(单位: any, 治疗量: number, 当前跳数: number): void {
  debugLogForce(
    模块名,
    "治疗波命中",
    " 跳数=",
    当前跳数,
    " 治疗量=",
    治疗量,
    " 单位=",
    GetUnitName(单位),
    "#",
    GetHandleId(单位)
  );
}

function 治疗波结束回调(已完成的跳数: number): void {
  debugLogForce(模块名, "治疗波结束", " 已完成跳数=", 已完成的跳数);
}

function on聊天137测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  const x = GetUnitX(大法师);
  const y = GetUnitY(大法师);
  const 初始目标 = 查找最近友军(大法师, x, y);
  if (初始目标 == null || 初始目标 === 0) {
    debugLogForce(模块名, "搜索半径内未找到友军起始目标");
    return;
  }

  const 实例 = 发起治疗波跳链({
    起始目标: 初始目标,
    来源单位: 大法师,
    最大跳数: 默认最大跳数,
    初始治疗量: 默认初始治疗量,
    每跳最大距离: 默认每跳最大距离,
    每跳衰减系数: 0,
    跳跃间隔: 默认跳跃间隔,
    每跳回调: 治疗波每跳回调,
    结束回调: 治疗波结束回调,
  });

  if (实例 == null) {
    debugLogForce(模块名, "治疗波启动失败");
    return;
  }

  debugLogForce(
    模块名,
    "已启动治疗波测试",
    " 命令=",
    测试命令1,
    " 最大跳数=",
    默认最大跳数,
    " 每跳距离=",
    默认每跳最大距离,
    " 初始治疗量=",
    默认初始治疗量,
    " 间隔=",
    默认跳跃间隔
  );
}

function on聊天138测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  const x = GetUnitX(大法师);
  const y = GetUnitY(大法师);
  const 初始目标 = 查找最近友军(大法师, x, y);
  if (初始目标 == null || 初始目标 === 0) {
    debugLogForce(模块名, "搜索半径内未找到友军起始目标");
    return;
  }

  const 实例 = 发起治疗波跳链({
    起始目标: 初始目标,
    来源单位: 大法师,
    最大跳数: 5,
    初始治疗量: 150,
    每跳最大距离: 500,
    每跳衰减系数: 0.7,
    跳跃间隔: 0.05,
    每跳回调: 治疗波每跳回调,
    结束回调: 治疗波结束回调,
  });

  if (实例 == null) {
    debugLogForce(模块名, "治疗波启动失败");
    return;
  }

  debugLogForce(
    模块名,
    "已启动治疗波测试（带衰减）",
    " 命令=",
    测试命令2,
    " 最大跳数=",
    5,
    " 初始治疗量=",
    150,
    " 衰减=",
    0.7
  );
}

function on聊天命令回调(player: any, command: string): void {
  if (command === 测试命令1) {
    on聊天137测试();
  } else if (command === 测试命令2) {
    on聊天138测试();
  } else {
    debugLogForce(模块名, "未知命令", command);
  }
}

注册聊天命令监听(测试命令1, on聊天命令回调);
注册聊天命令监听(测试命令2, on聊天命令回调);
debugLogForce(模块名, "已注册测试：输入", 测试命令1, "或", 测试命令2, "启动治疗波跳链测试");

export {};
