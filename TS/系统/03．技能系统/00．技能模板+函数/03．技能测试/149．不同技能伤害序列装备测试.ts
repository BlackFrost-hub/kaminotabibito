/** @noSelfInFile */
/**
 * 不同技能伤害序列装备测试
 * 先通过 wp177 / wp181 / wp191 获取待测装备，再输入 1052。
 * 地图预设大法师会对周围每个敌人依次造成 4 次技能伤害，
 * 四次伤害分别携带不同的技能 ID，用于验证不同技能计数与下一次技能伤害触发。
 */

const jass = require("jass.common") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { getEnemyUnitsInRangeOfUnit } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRangeOfUnit: (this: void, centerUnit: any, radius: number) => any[];
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: {
    来源: any;
    目标: any;
    伤害: number;
    伤害类型: any;
    来源类型: "单位技能";
    技能ID: number;
    标签: string;
    参与技能伤害加成: boolean;
  }) => boolean;
};

const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;

const 模块名 = "不同技能伤害序列装备测试";
const 测试命令 = "1052";
const 搜索半径 = 800;
const 单次伤害 = 10;
const 测试技能ID列表 = [
  stringToFourCCSafe("T491"),
  stringToFourCCSafe("T492"),
  stringToFourCCSafe("T493"),
  stringToFourCCSafe("T494"),
];

function 对目标造成四次不同技能伤害(this: void, 来源: any, 目标: any): number {
  let 成功次数 = 0;
  for (let i = 0; i < 测试技能ID列表.length; i++) {
    const 当前序号 = i + 1;
    const 成功 = 造成单体技能伤害({
      来源,
      目标,
      伤害: 单次伤害,
      伤害类型: DAMAGE_TYPE_MAGIC,
      来源类型: "单位技能",
      技能ID: 测试技能ID列表[i],
      标签: "不同技能序列测试-" + String(当前序号),
      参与技能伤害加成: false,
    });
    if (成功) 成功次数 = 成功次数 + 1;
  }
  return 成功次数;
}

function on聊天1052不同技能测试(this: void, _player: any, _command: string): void {
  const 大法师 = globals.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到地图预设大法师 gg_unit_Hamg_0002");
    return;
  }

  const 敌人列表 = getEnemyUnitsInRangeOfUnit(大法师, 搜索半径);
  if (敌人列表.length <= 0) {
    debugLogForce(模块名, "大法师周围没有可测试敌人", "半径=", 搜索半径);
    return;
  }

  let 总成功伤害次数 = 0;
  for (let i = 0; i < 敌人列表.length; i++) {
    总成功伤害次数 = 总成功伤害次数 + 对目标造成四次不同技能伤害(大法师, 敌人列表[i]);
  }

  debugLogForce(
    模块名,
    "测试完成",
    "敌人数=",
    敌人列表.length,
    "每个敌人不同技能数=",
    测试技能ID列表.length,
    "成功伤害次数=",
    总成功伤害次数,
    "提示=先装备wp177、wp181或wp191再观察对应效果",
  );
}

注册聊天命令监听(测试命令, on聊天1052不同技能测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "对大法师周围每个敌人造成4次不同技能伤害");

export {};
