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
const { 创建Boss战运行上下文 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文") as {
  创建Boss战运行上下文: (this: void, bossUnit: any, 地点矩形: any, 战斗音乐: any, 胜利音乐: any) => any;
};
const { 查找Boss弱点韧性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.02．Boss弱点韧性配置表") as {
  查找Boss弱点韧性配置: (this: void, bossUnit: any) => any;
};
const { 注册Boss血条UI, 注销Boss血条UI } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.03．Boss血条UI") as {
  注册Boss血条UI: (this: void, state: any) => void;
  注销Boss血条UI: (this: void, state: any) => void;
};
const { 注册Boss弱点UI, 注销Boss弱点UI } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.04．Boss弱点UI") as {
  注册Boss弱点UI: (this: void, state: any) => void;
  注销Boss弱点UI: (this: void, state: any) => void;
};
const {
  创建Boss血条弱点韧性运行状态,
  清理Boss血条弱点韧性运行状态,
} = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.05．Boss弱点运行状态") as {
  创建Boss血条弱点韧性运行状态: (this: void, context: any, config: any, unit: any, type: "主Boss" | "护卫", ownerId: number, stateKey: number, guardType: "共享" | "独立") => any;
  清理Boss血条弱点韧性运行状态: (this: void, stateKey: number) => void;
};
const { Boss弱点YD字段 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.01．常量定义") as {
  Boss弱点YD字段: { 护盾值: string; 原始护盾值: string };
};

const 模块名 = "Boss血条弱点韧性测试";
const 单Boss独立护卫命令 = "1047-1";
const 双Boss独立护卫命令 = "1047-2";
const 双Boss共享护卫命令 = "1047-n";
const 清理命令 = "1048";
const 测试护盾值 = 10;

let 最近测试状态列表: any[] = [];

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

function 清理Boss血条测试状态(this: void): void {
  for (let i = 最近测试状态列表.length - 1; i >= 0; i--) {
    const state = 最近测试状态列表[i];
    state.是否已结束 = true;
    注销Boss弱点UI(state);
    注销Boss血条UI(state);
    清理Boss血条弱点韧性运行状态(state.Boss句柄ID);
  }
  最近测试状态列表 = [];
}

function on注册Boss血条弱点韧性测试(this: void, _player: any, command: string): void {
  const bossCount = command === 单Boss独立护卫命令 ? 1 : 2;
  const guardType: "共享" | "独立" = command === 双Boss共享护卫命令 ? "共享" : "独立";

  清理Boss血条测试状态();
  const 步兵 = 获取测试步兵();
  if (步兵 == null || 步兵 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_hfoo_0014");
    return;
  }

  写入Boss血条测试YD(步兵);
  const context = 创建Boss战运行上下文(步兵, null, null, null);
  if (context == null) {
    debugLogForce(模块名, "创建测试上下文失败");
    return;
  }

  const config = 查找Boss弱点韧性配置(步兵);
  for (let bossIndex = 0; bossIndex < bossCount; bossIndex++) {
    const ownerStateKey = -104701 - bossIndex * 3;
    const mainState = 创建Boss血条弱点韧性运行状态(
      context,
      config,
      步兵,
      "主Boss",
      ownerStateKey,
      ownerStateKey,
      guardType,
    );
    最近测试状态列表.push(mainState);
    注册Boss血条UI(mainState);
    注册Boss弱点UI(mainState);

    if (guardType === "独立") {
      for (let guardIndex = 1; guardIndex <= 2; guardIndex++) {
        const state = 创建Boss血条弱点韧性运行状态(
          context,
          config,
          步兵,
          "护卫",
          ownerStateKey,
          ownerStateKey - guardIndex,
          guardType,
        );
        最近测试状态列表.push(state);
        注册Boss血条UI(state);
        注册Boss弱点UI(state);
      }
    }
  }

  if (guardType === "共享") {
    const sharedOwnerStateKey = -104701;
    for (let guardIndex = 0; guardIndex < 2; guardIndex++) {
      const state = 创建Boss血条弱点韧性运行状态(
        context,
        config,
        步兵,
        "护卫",
        sharedOwnerStateKey,
        -104707 - guardIndex,
        guardType,
      );
      最近测试状态列表.push(state);
      注册Boss血条UI(state);
      注册Boss弱点UI(state);
    }
  }
  const guardCount = guardType === "共享" ? 2 : bossCount * 2;
  debugLogForce(模块名, "已自动重置并创建", bossCount, "个主血条及", guardCount, "个", guardType, "护卫血条", "护盾=", 测试护盾值, "弱点=剑/火/暗");
}

function on清理Boss血条弱点韧性测试(this: void): void {
  if (最近测试状态列表.length === 0) {
    debugLogForce(模块名, "当前没有测试血条");
    return;
  }

  const stateCount = 最近测试状态列表.length;
  清理Boss血条测试状态();
  debugLogForce(模块名, "已清理", stateCount, "条测试血条");
}

注册聊天命令监听(单Boss独立护卫命令, on注册Boss血条弱点韧性测试);
注册聊天命令监听(双Boss独立护卫命令, on注册Boss血条弱点韧性测试);
注册聊天命令监听(双Boss共享护卫命令, on注册Boss血条弱点韧性测试);
注册聊天命令监听(清理命令, on清理Boss血条弱点韧性测试);
debugLogForce(模块名, "已注册测试：1047-1=单Boss独立护卫，1047-2=双Boss独立护卫，1047-n=双Boss共享护卫；每次自动重置；输入", 清理命令, "清理");

export {};
