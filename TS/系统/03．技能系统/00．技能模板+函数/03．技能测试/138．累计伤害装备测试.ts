/** @noSelfInFile */
/**
 * 累计伤害装备测试
 *
 * 输入 "1040" 后，给大法师发放：
 * - 回沙之书
 * - 女妖头饰
 * 用来测试累计伤害相关的装备触发链。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string | undefined | null) => number;
};

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const CreateItem = jass.CreateItem as (id: number, x: number, y: number) => any;
const UnitAddItem = jass.UnitAddItem as (unit: any, item: any) => boolean;

const 模块名 = "累计伤害装备测试";
const 测试命令 = "1040";
const 测试装备列表 = ["回沙之书", "女妖头饰"] as const;

function 获取测试单位(this: void): any {
  return g.gg_unit_Hamg_0002 ?? (globalThis as any).bj_lastCreatedUnit;
}

function 给单位发装备(this: void, unit: any, 装备名: string): void {
  const 物品ID = 按名字反查物品ID(装备名);
  if (物品ID == null || 物品ID === "") {
    debugLogForce(模块名, "未找到装备ID", 装备名);
    return;
  }

  const item = CreateItem(stringToFourCC(物品ID), GetUnitX(unit), GetUnitY(unit));
  if (item == null || item === 0) {
    debugLogForce(模块名, "创建装备失败", 装备名, 物品ID);
    return;
  }

  UnitAddItem(unit, item);
  debugLogForce(模块名, "已发放装备", 装备名, 物品ID);
}

function on聊天1040测试(this: void): void {
  const 大法师 = 获取测试单位();
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002，无法发放累计伤害装备");
    return;
  }

  for (const 装备名 of 测试装备列表) {
    给单位发装备(大法师, 装备名);
  }
  debugLogForce(模块名, "已给大法师发放累计伤害装备测试包");
}

注册聊天命令监听(测试命令, on聊天1040测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "给大法师发放累计伤害装备");

export {};
