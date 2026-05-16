/** @noSelfInFile */
/**
 * 禁锢与寄生虫测试
 *
 * 输入 "1034"：对大法师施加3秒禁锢（BUFF纠缠根须+周期伤害）
 * 输入 "1035"：对大法师施加3秒寄生虫（BUFF寄生+周期伤害）
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};
const { 施加禁锢, 施加寄生 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口") as {
  施加禁锢: (this: void, 参数: any) => void;
  施加寄生: (this: void, 参数: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 模块名 = "禁锢寄生测试";
const 禁锢命令 = "1034";
const 寄生命令 = "1035";

function 获取大法师(this: void): any {
  return g.gg_unit_Hamg_0002 ?? (globalThis as any).bj_lastCreatedUnit;
}

function on禁锢测试(this: void): void {
  const 来源单位 = 获取大法师();
  if (来源单位 == null || 来源单位 === 0) {
    debugLogForce(模块名, "测试失败：找不到大法师");
    return;
  }

  施加禁锢({
    来源单位,
    目标单位: 来源单位,
    伤害: 25,
    伤害间隔: 1,
    持续时间: 3,
  });

  debugLogForce(模块名, "已对大法师施加3秒禁锢，伤害25/1s");
}

function on寄生测试(this: void): void {
  const 来源单位 = 获取大法师();
  if (来源单位 == null || 来源单位 === 0) {
    debugLogForce(模块名, "测试失败：找不到大法师");
    return;
  }

  施加寄生({
    来源单位,
    目标单位: 来源单位,
    伤害: 18,
    伤害间隔: 1,
    持续时间: 3,
  });

  debugLogForce(模块名, "已对大法师施加3秒寄生虫，伤害18/1s");
}

注册聊天命令监听(禁锢命令, on禁锢测试);
注册聊天命令监听(寄生命令, on寄生测试);
debugLogForce(模块名, "已注册测试：输入", 禁锢命令, "禁锢","", 寄生命令, "寄生虫");

export {};
