/** @noSelfInFile */
/**
 * 召唤物系统 测试
 *
 * 输入 "1093"：
 * - 测试 `创建召唤物`
 * - 测试 `快捷创建召唤物`
 * - 测试 `SUO_CreateUnit_Loc`
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};
const { 创建召唤物, 快捷创建召唤物, SUO_CreateUnit_Loc } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.index") as {
  创建召唤物: (this: void, 参数: any) => any;
  快捷创建召唤物: (this: void, 主人单位: any, 单位类型: string | number, X: number, Y: number, 持续时间: number, 额外参数?: any) => any;
  SUO_CreateUnit_Loc: (
    this: void,
    所属玩家: any,
    uid: string | number,
    loc: any,
    z: number,
    fac: number,
    alpha: number,
    red: number,
    green: number,
    blue: number,
    time: number,
    b: boolean
  ) => any;
};

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const Location = jass.Location as (x: number, y: number) => any;

const 模块名 = "召唤物测试";
const 测试命令 = "1093";

function 打印结果(this: void, 标签: string, 召唤物: any): void {
  if (召唤物 != null && 召唤物 !== 0) {
    debugLogForce(模块名, "[PASS]", 标签, "创建成功");
    return;
  }
  debugLogForce(模块名, "[FAIL]", 标签, "创建失败");
}

function on聊天测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const x = GetUnitX(大法师);
  const y = GetUnitY(大法师);
  const 所属玩家 = GetOwningPlayer(大法师);

  debugLogForce(模块名, "===== 开始测试 =====");

  const 直接创建 = 创建召唤物({
    主人单位: 大法师,
    单位类型: "hfoo",
    X: x + 200,
    Y: y,
    持续时间: 10,
    飞行高度: 50,
    生命值: 300,
    攻击力: 25,
    护甲: 5,
    缩放: 1.2,
  });
  打印结果("创建召唤物", 直接创建);

  const 快捷创建 = 快捷创建召唤物(大法师, "hrif", x + 300, y, 10, {
    飞行高度: 50,
    攻击力: 40,
    攻击间隔: 1.5,
    缩放: 1.1,
  });
  打印结果("快捷创建召唤物", 快捷创建);

  const loc = Location(x + 400, y);
  const SUO创建 = SUO_CreateUnit_Loc(所属玩家, "hmpr", loc, 50, 270, 255, 255, 255, 255, 10, true);
  打印结果("SUO_CreateUnit_Loc", SUO创建);
}

注册聊天命令监听(测试命令, on聊天测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "测试召唤物统一入口");

export {};
