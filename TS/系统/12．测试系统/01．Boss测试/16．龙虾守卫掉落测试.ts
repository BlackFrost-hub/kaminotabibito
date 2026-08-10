/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, player: any) => boolean;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 获取Boss死亡结算配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑") as {
  获取Boss死亡结算配置: (this: void, Boss单位: any) => any;
};

const CreateUnit = jass.CreateUnit as (whichPlayer: any, unitId: number, x: number, y: number, facing: number) => any;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: number) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (whichPlayer: any, x: number, y: number, duration: number, message: string) => void;
const Player = jass.Player as (playerId: number) => any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as number;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

const 模块名 = "龙虾守卫掉落测试";
const 测试命令 = "龙虾";
const 龙虾守卫原始ID = "n02U";
const 龙虾守卫单位ID = stringToFourCCSafe(龙虾守卫原始ID);
const 测试坐标X = -540.6;
const 测试坐标Y = -2495.2;
const 测试面向 = 270;
let 当前测试龙虾守卫: any = null;

function 测试龙虾守卫存活(this: void): boolean {
  return 当前测试龙虾守卫 != null && 当前测试龙虾守卫 !== 0 && GetUnitState(当前测试龙虾守卫, UNIT_STATE_LIFE) > 0.405;
}

function 读取直接掉落物品文本(this: void, 配置: any): string {
  if (配置 == null || 配置.直接掉落物品名列表 == null) return "nil";
  return 配置.直接掉落物品名列表.join("、");
}

function on龙虾守卫掉落测试命令(this: void, player: any, _command: string): void {
  if (!是允许测试玩家(player)) return;

  if (龙虾守卫单位ID <= 0) {
    DisplayTimedTextToPlayer(player, 0, 0, 8, "[龙虾守卫掉落测试] n02U 内部 ID 无效。 ");
    debugLogForce(模块名, "单位内部ID无效", "rawId", 龙虾守卫原始ID);
    return;
  }
  if (测试龙虾守卫存活()) {
    DisplayTimedTextToPlayer(player, 0, 0, 8, "[龙虾守卫掉落测试] 测试龙虾守卫仍存活，请先击杀。 ");
    debugLogForce(模块名, "复用现有测试单位", "handle", GetHandleId(当前测试龙虾守卫), "unitTypeId", GetUnitTypeId(当前测试龙虾守卫));
    return;
  }

  当前测试龙虾守卫 = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 龙虾守卫单位ID, 测试坐标X, 测试坐标Y, 测试面向);
  if (当前测试龙虾守卫 == null || 当前测试龙虾守卫 === 0) {
    DisplayTimedTextToPlayer(player, 0, 0, 8, "[龙虾守卫掉落测试] 创建 n02U 失败。 ");
    debugLogForce(模块名, "创建测试单位失败", "rawId", 龙虾守卫原始ID, "unitTypeId", 龙虾守卫单位ID);
    return;
  }

  DisplayTimedTextToPlayer(player, 0, 0, 8, "[龙虾守卫掉落测试] 已在测试空地创建 n02U；击杀后检查掉落和日志。 ");
  debugLogForce(模块名, "创建测试单位", "handle", GetHandleId(当前测试龙虾守卫), "rawId", 龙虾守卫原始ID, "unitTypeId", GetUnitTypeId(当前测试龙虾守卫), "x", 测试坐标X, "y", 测试坐标Y);
}

function on龙虾守卫测试死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit !== 当前测试龙虾守卫) return;
  const 配置 = 获取Boss死亡结算配置(dyingUnit);
  debugLogForce(模块名, "测试单位死亡", "handle", GetHandleId(dyingUnit), "unitTypeId", GetUnitTypeId(dyingUnit), "结算键", 配置 != null ? 配置.键 : "nil", "直接掉落", 读取直接掉落物品文本(配置));
}

注册聊天命令监听(测试命令, on龙虾守卫掉落测试命令);
registerDeathListener(on龙虾守卫测试死亡);

export {};
