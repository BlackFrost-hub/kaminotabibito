/** @noSelfInFile */
/**
 * 数值漂浮文字测试
 *
 * 输入 1032：在大法师身上和附近坐标一次性显示多种数值漂浮文字。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};
const {
  显示单位数值漂浮文字,
  显示坐标数值漂浮文字,
} = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字") as {
  显示单位数值漂浮文字: (this: void, unit: any, value: number, options?: any) => any;
  显示坐标数值漂浮文字: (this: void, x: number, y: number, value: number, options?: any) => any;
};
const { STES_FireWithParams } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_FireWithParams: (this: void, name: string, params: Array<{ type: string; name: string; value: any }>) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

const 模块名 = "数值漂浮文字测试";
const 测试命令 = "1032";

function 获取测试大法师(this: void): any {
  return g.gg_unit_Hamg_0002 ?? (globalThis as any).bj_lastCreatedUnit;
}

function 执行数值漂浮文字测试(this: void): void {
  const unit = 获取测试大法师();
  if (unit == null || unit === 0) {
    debugLogForce(模块名, "测试失败：找不到大法师 gg_unit_Hamg_0002");
    return;
  }

  const x = GetUnitX(unit);
  const y = GetUnitY(unit);

  显示单位数值漂浮文字(unit, 1234, {
    后缀: "金币",
    红: 255,
    绿: 215,
    蓝: 0,
    大小: 12,
  });

  显示坐标数值漂浮文字(x + 90, y, -88, {
    后缀: "伤害",
    红: 255,
    绿: 60,
    蓝: 60,
  });

  显示坐标数值漂浮文字(x - 90, y, 12.345, {
    后缀: "s",
    小数位数: 2,
    红: 80,
    绿: 180,
    蓝: 255,
  });

  显示坐标数值漂浮文字(x, y + 90, 66, {
    后缀: "无正号",
    显示正号: false,
    红: 180,
    绿: 255,
    蓝: 180,
  });

  显示坐标数值漂浮文字(x, y - 90, 0, {
    后缀: "显示0",
    零值隐藏: false,
    红: 255,
    绿: 255,
    蓝: 255,
  });

  显示单位数值漂浮文字(unit, 0, {
    后缀: "隐藏0",
    零值隐藏: true,
  });

  STES_FireWithParams("数值显示", [
    { type: "unit", name: "单位", value: unit },
    { type: "real", name: "数值", value: 77 },
    { type: "string", name: "后缀", value: "STES中文参数" },
    { type: "real", name: "红", value: 255 },
    { type: "real", name: "绿", value: 180 },
    { type: "real", name: "蓝", value: 40 },
    { type: "real", name: "大小", value: 11 },
    { type: "real", name: "小数位数", value: 0 },
    { type: "boolean", name: "显示正号", value: true },
  ]);

  debugLogForce(模块名, "已执行：正数、负数、小数、无正号、零值显示/隐藏、中文 STES");
}

function on数值漂浮文字测试命令(this: void): void {
  执行数值漂浮文字测试();
}

注册聊天命令监听(测试命令, on数值漂浮文字测试命令);
debugLogForce(模块名, "已注册：" + 测试命令 + " 数值漂浮文字测试");

export {};
