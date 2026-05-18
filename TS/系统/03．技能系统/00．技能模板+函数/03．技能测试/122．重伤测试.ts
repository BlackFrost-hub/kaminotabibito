/** @noSelfInFile */
/**
 * 重伤系统 测试
 *
 * 输入 "1022"：给大法师施加50%重伤，然后治疗100，验证治疗量减少
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

const {
  获取单位重伤,
  施加重伤,
  移除单位重伤,
} = require("系统.04．伤害系统.03．重伤系统.01．核心功能") as {
  获取单位重伤: (this: void, unit: any) => number;
  施加重伤: (this: void, unit: any, 重伤值: number, 持续时间?: number) => void;
  移除单位重伤: (this: void, unit: any) => void;
};

const { spellHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  spellHeal: (this: void, source: any, target: any, amount: number, showEffect?: boolean) => number;
};

const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;

const 模块名 = "重伤测试";
const 测试命令 = "1022";

function on聊天测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  debugLogForce(模块名, "===== 重伤测试 =====");

  // 给大法师施加30%重伤（3秒）
  施加重伤(大法师, 0.3, 3);
  debugLogForce(模块名, "重伤值：", 获取单位重伤(大法师));
  debugLogForce(模块名, "治疗前血量：", GetUnitState(大法师, UNIT_STATE_LIFE));

  // 重伤下治疗100
  const heal = spellHeal(null, 大法师, 150, false);
  debugLogForce(模块名, "治疗量：", heal, "治疗后血量：", GetUnitState(大法师, UNIT_STATE_LIFE));

  if (heal < 100) {
    debugLogForce(模块名, "[PASS] 重伤减少治疗：", heal, "< 100");
  } else {
    debugLogForce(模块名, "[FAIL] 重伤未减少治疗：", heal, ">= 100");
  }
}

注册聊天命令监听(测试命令, on聊天测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "测试重伤对治疗的影响");

export {};
