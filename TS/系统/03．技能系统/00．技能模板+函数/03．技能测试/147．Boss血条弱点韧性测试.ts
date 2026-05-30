/** @noSelfInFile */

const g = require("jass.globals") as { gg_unit_hfoo_0014?: any; [key: string]: any };
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 创建Boss战运行上下文 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.01．Boss战运行上下文") as {
  创建Boss战运行上下文: (this: void, bossUnit: any, 地点矩形: any, 战斗音乐: any, 胜利音乐: any) => any;
};
const {
  启动Boss血条弱点韧性,
  结束Boss血条弱点韧性,
} = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.07．Boss弱点事件桥接") as {
  启动Boss血条弱点韧性: (this: void, context: any) => void;
  结束Boss血条弱点韧性: (this: void, context: any) => void;
};
const { Boss弱点YD字段 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.01．常量定义") as {
  Boss弱点YD字段: { 护盾值: string; 原始护盾值: string };
};

const 模块名 = "Boss血条弱点韧性测试";
const 注册命令 = "1047";
const 清理命令 = "1048";
const 测试护盾值 = 10;

let 最近测试上下文: any = null;

function 获取测试步兵(this: void): any {
  return g.gg_unit_hfoo_0014;
}

function 写入Boss血条测试YD(this: void, bossUnit: any): void {
  YDUserDataSetSafe("string", "Boss战", "绑定单位", "unit", bossUnit);
  YDUserDataSetSafe("unit", bossUnit, Boss弱点YD字段.护盾值, "integer", 测试护盾值);
  YDUserDataSetSafe("unit", bossUnit, Boss弱点YD字段.原始护盾值, "integer", 测试护盾值);
  YDUserDataSetSafe("unit", bossUnit, "剑弱", "boolean", true);
  YDUserDataSetSafe("unit", bossUnit, "火弱", "boolean", true);
  YDUserDataSetSafe("unit", bossUnit, "暗弱", "boolean", true);
  YDUserDataSetSafe("unit", bossUnit, "弱点数量", "integer", 3);
  YDUserDataSetSafe("unit", bossUnit, "天生弱点数", "integer", 3);
}

function on注册Boss血条弱点韧性测试(this: void): void {
  const 步兵 = 获取测试步兵();
  if (步兵 == null || 步兵 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_hfoo_0014");
    return;
  }

  if (最近测试上下文 != null) {
    结束Boss血条弱点韧性(最近测试上下文);
    最近测试上下文 = null;
  }

  写入Boss血条测试YD(步兵);
  const context = 创建Boss战运行上下文(步兵, null, null, null);
  if (context == null) {
    debugLogForce(模块名, "创建测试上下文失败");
    return;
  }

  最近测试上下文 = context;
  启动Boss血条弱点韧性(context);
  debugLogForce(模块名, "已给 gg_unit_hfoo_0014 注册 Boss 血条弱点韧性测试", "护盾=", 测试护盾值, "弱点=剑/火/暗");
}

function on清理Boss血条弱点韧性测试(this: void): void {
  if (最近测试上下文 == null) {
    debugLogForce(模块名, "当前没有测试上下文");
    return;
  }

  结束Boss血条弱点韧性(最近测试上下文);
  最近测试上下文 = null;
  debugLogForce(模块名, "已清理 Boss 血条弱点韧性测试");
}

注册聊天命令监听(注册命令, on注册Boss血条弱点韧性测试);
注册聊天命令监听(清理命令, on清理Boss血条弱点韧性测试);
debugLogForce(模块名, "已注册测试：输入", 注册命令, "给 gg_unit_hfoo_0014 注册Boss血条；输入", 清理命令, "清理");

export {};
