/** @noSelfInFile */
/**
 * 周期范围效果测试
 *
 * 输入 1033：一次性测试周期 AOE、腐败层数、禁锢、寄生，以及 4 个旧 STES 兼容入口。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};
const {
  启动周期范围效果,
  施加禁锢,
  施加寄生,
  应用腐败层数,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口") as {
  启动周期范围效果: (this: void, 参数: any) => number;
  施加禁锢: (this: void, 参数: any) => void;
  施加寄生: (this: void, 参数: any) => void;
  应用腐败层数: (this: void, 参数: any) => void;
};
const { STES_FireWithParams } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_FireWithParams: (this: void, name: string, params: Array<{ type: string; name: string; value: any }>) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const Player = jass.Player as (playerId: number) => any;
const CreateUnit = jass.CreateUnit as (id: any, unitid: number, x: number, y: number, face: number) => any;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;

const 模块名 = "周期范围效果测试";
const 测试命令 = "1033";
const 中立敌对 = 12;
const 步兵ID = "hfoo";
const AOE特效 = "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl";

let 待清理测试单位: any = null;

function 获取测试大法师(this: void): any {
  return g.gg_unit_Hamg_0002 ?? (globalThis as any).bj_lastCreatedUnit;
}

function 创建测试目标(this: void, 来源单位: any): any {
  const x = GetUnitX(来源单位) + 260;
  const y = GetUnitY(来源单位);
  待清理测试单位 = CreateUnit(Player(中立敌对), stringToFourCC(步兵ID), x, y, 270);
  return 待清理测试单位;
}

function on清理周期范围效果测试单位(this: void): void {
  if (待清理测试单位 == null || 待清理测试单位 === 0) return;
  RemoveUnit(待清理测试单位);
  待清理测试单位 = null;
  debugLogForce(模块名, "已清理测试目标");
}

function 测试TS直调(this: void, 来源单位: any, 目标单位: any): void {
  启动周期范围效果({
    来源单位,
    特效模型: AOE特效,
    效果ID: 3,
    间隔: 1,
    持续时间: 4,
    半径: 650,
    X: GetUnitX(来源单位),
    Y: GetUnitY(来源单位),
  });

  应用腐败层数({
    目标单位: 来源单位,
    层数: 7,
    腐败值: true,
  });

  施加禁锢({
    来源单位,
    目标单位,
    伤害: 25,
    伤害间隔: 1,
    持续时间: 3,
  });

  施加寄生({
    来源单位,
    目标单位,
    伤害: 18,
    伤害间隔: 1,
    持续时间: 3,
  });
}

function 测试STES兼容(this: void, 来源单位: any, 目标单位: any): void {
  STES_FireWithParams("PeriodicAoe_Event", [
    { type: "string", name: "AoeEffectFileID", value: AOE特效 },
    { type: "integer", name: "EffectID", value: 3 },
    { type: "real", name: "EffectInterval", value: 1 },
    { type: "unit", name: "EffectSourceUnit", value: 来源单位 },
    { type: "real", name: "EffectTime", value: 4 },
    { type: "real", name: "r", value: 650 },
    { type: "real", name: "x", value: GetUnitX(来源单位) },
    { type: "real", name: "y", value: GetUnitY(来源单位) },
  ]);

  STES_FireWithParams("DebuffStacks", [
    { type: "unit", name: "TargetUnit", value: 来源单位 },
    { type: "real", name: "Stacks", value: 7 },
    { type: "boolean", name: "腐败值", value: true },
  ]);

  STES_FireWithParams("禁锢", [
    { type: "unit", name: "BuffSource", value: 来源单位 },
    { type: "unit", name: "BuffTarget", value: 目标单位 },
    { type: "real", name: "HitDamage", value: 20 },
    { type: "real", name: "DamageInterval", value: 1 },
    { type: "real", name: "time", value: 3 },
  ]);

  STES_FireWithParams("寄生", [
    { type: "unit", name: "BuffSource", value: 来源单位 },
    { type: "unit", name: "BuffTarget", value: 目标单位 },
    { type: "real", name: "HitDamage", value: 15 },
    { type: "real", name: "DamageInterval", value: 1 },
    { type: "real", name: "time", value: 3 },
  ]);
}

function 执行周期范围效果测试(this: void): void {
  const 来源单位 = 获取测试大法师();
  if (来源单位 == null || 来源单位 === 0) {
    debugLogForce(模块名, "测试失败：找不到大法师 gg_unit_Hamg_0002");
    return;
  }

  const 目标单位 = 创建测试目标(来源单位);
  测试TS直调(来源单位, 目标单位);
  测试STES兼容(来源单位, 目标单位);
  addDelayedCallback(8000, on清理周期范围效果测试单位);

  debugLogForce(模块名, "已执行：TS直调 + 4个STES兼容入口", "owner=", GetOwningPlayer(来源单位), "target=", 目标单位);
}

function on周期范围效果测试命令(this: void): void {
  执行周期范围效果测试();
}

注册聊天命令监听(测试命令, on周期范围效果测试命令);
debugLogForce(模块名, "已注册：" + 测试命令 + " 周期范围效果测试");

export {};
