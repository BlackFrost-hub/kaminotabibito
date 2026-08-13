/** @noSelfInFile */

import type { 环境互动触发点 } from "../../../../03．技能系统/04．快捷键技能/04．环境互动/00．通用/00．环境互动配置";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void) => void) => number;
  addPeriodicCallback: (this: void, 间隔毫秒: number, 回调: (this: void) => void) => number;
  removePeriodicCallback: (this: void, 回调ID: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
};
const { 注册环境互动调查点, 注销环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: 环境互动触发点) => boolean;
  注销环境互动调查点: (this: void, 调查点ID: string) => boolean;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, 玩家: any, 单位类型ID: number, X: number, Y: number, 朝向: number) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, 原始ID: string | undefined | null) => number;
};
const { ConsumeItemTypeCountByChargesBJ, UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  ConsumeItemTypeCountByChargesBJ: (this: void, 单位: any, 物品类型ID: number, 数量: number) => boolean;
  UnitHasItemOfTypeBJ: (this: void, 单位: any, 物品类型ID: number) => boolean;
};
const { 发放任务物品 } = require("系统.09．表现系统.02．对话框系统.14．任务物品发放") as {
  发放任务物品: (this: void, 单位: any, 物品配置: string | undefined) => number;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, 玩家: any) => any;
};
const { 按任务ID创建NPC, 按任务ID查找已创建NPC } = require("系统.08．任务系统.00．配置表.04．NPC生成器") as {
  按任务ID创建NPC: (this: void, 任务ID: number) => any;
  按任务ID查找已创建NPC: (this: void, 任务ID: number) => any;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { questDB } = require("系统.08．任务系统.01．任务数据") as {
  questDB: {
    getPlayerActiveQuests: (this: void, 玩家ID: number) => Array<{ id: string; objectives: Array<{ id: string; current: number; required: number }> }>;
    updateObjective: (this: void, 玩家ID: number, 任务ID: string, 目标ID: string, 进度: number) => boolean;
  };
};
const { 触发任务UI刷新 } = require("系统.08．任务系统.02．任务管理器") as {
  触发任务UI刷新: (this: void, 玩家ID: number, 任务ID?: string) => void;
};
const { 设单位名字 } = require("平台扩展API动作") as {
  设单位名字: (this: void, 单位: any, 名称: string) => void;
};

const Player = jass.Player as (this: void, 玩家ID: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, 单位: any) => void;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, 单位: any) => number;
const GetUnitName = jass.GetUnitName as (this: void, 单位: any) => string;
const GetUnitState = jass.GetUnitState as (this: void, 单位: any, 状态: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, 单位: any, 状态: any, 数值: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, 单位: any, 动画: string) => void;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, 单位: any, 命令: string) => boolean;
const UnitAddAbility = jass.UnitAddAbility as (this: void, 单位: any, 技能ID: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, 单位: any, 技能ID: number) => boolean;
const ConvertUnitState = jass.ConvertUnitState as (this: void, 状态ID: number) => any;
const GetRandomReal = jass.GetRandomReal as (this: void, 最小值: number, 最大值: number) => number;
const SetUnitStateJapi = japi.SetUnitState as (this: void, 单位: any, 状态: any, 数值: number) => void;

export const 熔火酒任务ID = 10102;
export const 迷宫缺灯任务ID = 10103;
export const 遗失角饰任务ID = 10104;
export const 墓门旧誓任务ID = 10105;
export const 熔核余温任务ID = 10106;
export const 合法决斗任务ID = 10107;
export const 城外恶魔守卫登记ID = 10901;

const 熔火酒物品ID = "I0JX";
const 遗失角饰物品ID = "I0JY";
const 王族旧誓印物品ID = "I0JZ";
const 余焰采样器物品ID = "I0K0";
const 稳定余焰样本物品ID = "I0K1";
const 环境互动范围 = 300;
const 城外守卫X = 23462.5;
const 城外守卫Y = -14789.7;
const 城外守卫触发范围 = 300;
const 决斗北侧X = 14488.3;
const 决斗北侧Y = -16492.5;
const 决斗南侧X = 14488.3;
const 决斗南侧Y = -16992.5;
const 决斗统一最大生命 = 10000;
const 决斗统一攻击力 = 900;
const 决斗统一护甲 = 15;
const 决斗统一攻击间隔 = 1.0;
const 决斗裁定生命比例 = 0.15;
const 决斗攻击力状态 = ConvertUnitState(0x15);
const 决斗护甲状态 = ConvertUnitState(0x20);
const 决斗攻击间隔状态 = ConvertUnitState(0x25);
const 最大生命状态 = jass.UNIT_STATE_MAX_LIFE as any;
const 当前生命状态 = jass.UNIT_STATE_LIFE as any;

interface 恶魔城调查点配置 {
  ID: string;
  任务ID: number;
  X: number;
  Y: number;
  发现文本: string;
}

const 恶魔城调查点配置表: 恶魔城调查点配置[] = [
  { ID: "恶魔迷宫外_遗落纸张", 任务ID: 迷宫缺灯任务ID, X: 22749.2, Y: -9325.4, 发现文本: "|cffffff00『调查发现』：|r烧焦的测绘纸上还留着半条路线，最后一笔停在迷宫入口附近。" },
  { ID: "恶魔迷宫外_引路灯", 任务ID: 迷宫缺灯任务ID, X: 21958.2, Y: -7467.6, 发现文本: "|cffffff00『调查发现』：|r引路灯被人从固定架上硬生生拆走，只剩一小片带爪痕的金属底座。" },
  { ID: "恶魔迷宫外_岔路痕迹", 任务ID: 迷宫缺灯任务ID, X: 21298.3, Y: -9142.1, 发现文本: "|cffffff00『调查发现』：|r岔路的碎石上留着拖行痕迹，方向正通往双翼恶魔盘旋的高地。" },
  { ID: "王墓_旧誓标志", 任务ID: 墓门旧誓任务ID, X: 5216.9, Y: -14796.0, 发现文本: "|cffffff00『调查发现』：|r墓门下的旧徽记仍在回应守陵人的誓言，一枚王族旧誓印从裂缝中显露出来。" },
  { ID: "熔核_余焰一", 任务ID: 熔核余温任务ID, X: 10631.2, Y: -9219.5, 发现文本: "|cffffff00『采样进度』：|r第一处余焰温度稳定，采样器已经记下它的焰流。" },
  { ID: "熔核_余焰二", 任务ID: 熔核余温任务ID, X: 7485.5, Y: -9306.0, 发现文本: "|cffffff00『采样进度』：|r第二处余焰混着熔岩杂质，经过过滤后仍可作为样本的一部分。" },
  { ID: "熔核_余焰三", 任务ID: 熔核余温任务ID, X: 9169.0, Y: -10578.0, 发现文本: "|cffffff00『采样进度』：|r第三处余焰的脉动最强，采样器的封口已经开始发烫。" },
  { ID: "熔核_余焰四", 任务ID: 熔核余温任务ID, X: 6864.6, Y: -10487.3, 发现文本: "|cffffff00『采样完成』：|r四处余焰已经完成比对，采样器将它们压成了一份稳定余焰样本。" },
];

const 已调查点: Record<string, boolean> = {};
let 熔火酒接取玩家ID = -1;
let 熔火酒扫描回调ID = 0;
let 遗失角饰接取玩家ID = -1;
let 遗失角饰恶魔犬: any = null;
let 合法决斗接取玩家ID = -1;
let 合法决斗北侧单位: any = null;
let 合法决斗南侧单位: any = null;
let 合法决斗回调ID = 0;
let 合法决斗已结束 = false;

function 查找活动任务(this: void, 玩家ID: number, 任务ID: number): { id: string; objectives: Array<{ id: string; current: number; required: number }> } | null {
  const 任务键 = tostring(任务ID);
  const 活动任务列表 = questDB.getPlayerActiveQuests(玩家ID);
  for (let i = 0; i < 活动任务列表.length; i++) {
    const 任务 = 活动任务列表[i];
    if (任务 != null && 任务.id === 任务键) return 任务;
  }
  return null;
}

function 更新任务目标(this: void, 玩家ID: number, 任务ID: number, 新进度: number): boolean {
  const 任务 = 查找活动任务(玩家ID, 任务ID);
  if (任务 == null || 任务.objectives == null || 任务.objectives.length === 0) return false;
  const 目标 = 任务.objectives[0];
  if (目标 == null || 新进度 <= 目标.current) return false;
  if (!questDB.updateObjective(玩家ID, 任务.id, 目标.id, 新进度)) return false;
  触发任务UI刷新(玩家ID, 任务.id);
  return true;
}

function 读取任务进度(this: void, 玩家ID: number, 任务ID: number): { 当前: number; 需求: number } | null {
  const 任务 = 查找活动任务(玩家ID, 任务ID);
  if (任务 == null || 任务.objectives == null || 任务.objectives.length === 0) return null;
  const 目标 = 任务.objectives[0];
  return 目标 == null ? null : { 当前: 目标.current, 需求: 目标.required };
}

function 查找调查点配置(this: void, 调查点ID: string): 恶魔城调查点配置 | null {
  for (let i = 0; i < 恶魔城调查点配置表.length; i++) {
    if (恶魔城调查点配置表[i].ID === 调查点ID) return 恶魔城调查点配置表[i];
  }
  return null;
}

function 清理任务调查点(this: void, 任务ID: number): void {
  for (let i = 0; i < 恶魔城调查点配置表.length; i++) {
    const 配置 = 恶魔城调查点配置表[i];
    if (配置.任务ID !== 任务ID) continue;
    注销环境互动调查点(配置.ID);
    已调查点[配置.ID] = false;
  }
}

function 处理恶魔城环境互动(this: void, 玩家ID: number, 施法单位: any, 调查点: 环境互动触发点): boolean {
  const 配置 = 查找调查点配置(调查点.ID);
  if (配置 == null || 已调查点[配置.ID] === true) return false;
  const 进度 = 读取任务进度(玩家ID, 配置.任务ID);
  if (进度 == null || 进度.当前 >= 进度.需求) return false;

  if (配置.任务ID === 熔核余温任务ID) {
    const 采样器ID = stringToFourCCSafe(余焰采样器物品ID);
    if (!UnitHasItemOfTypeBJ(施法单位, 采样器ID)) {
      广播单位提示(施法单位, "|cffffff00『任务提示』：|r没有余焰采样器，无法封存这里的火焰。", 4200);
      return false;
    }
  }

  const 新进度 = 进度.当前 + 1;
  if (!更新任务目标(玩家ID, 配置.任务ID, 新进度)) return false;
  已调查点[配置.ID] = true;
  广播单位提示(施法单位, 配置.发现文本, 5000);

  if (配置.任务ID === 迷宫缺灯任务ID && 新进度 === 3) {
    广播单位提示(施法单位, "|cffffff00『调查结果』：|r三处痕迹都指向双翼究极恶魔。击败它，才能把迷宫外围的威胁彻底清除。", 5200);
  } else if (配置.任务ID === 墓门旧誓任务ID) {
    发放任务物品(施法单位, 王族旧誓印物品ID);
  } else if (配置.任务ID === 熔核余温任务ID && 新进度 >= 进度.需求) {
    const 采样器ID = stringToFourCCSafe(余焰采样器物品ID);
    if (ConsumeItemTypeCountByChargesBJ(施法单位, 采样器ID, 1)) {
      发放任务物品(施法单位, 稳定余焰样本物品ID);
    }
  }
  return true;
}

function 注册任务调查点(this: void, 任务ID: number): void {
  清理任务调查点(任务ID);
  for (let i = 0; i < 恶魔城调查点配置表.length; i++) {
    const 配置 = 恶魔城调查点配置表[i];
    if (配置.任务ID !== 任务ID) continue;
    注册环境互动调查点({
      ID: 配置.ID,
      X: 配置.X,
      Y: 配置.Y,
      触发范围: 环境互动范围,
      触发回调: 处理恶魔城环境互动,
    });
  }
}

function 停止熔火酒送达扫描(this: void): void {
  if (熔火酒扫描回调ID !== 0) removePeriodicCallback(熔火酒扫描回调ID);
  熔火酒扫描回调ID = 0;
}

function on熔火酒送达扫描(this: void): void {
  if (熔火酒接取玩家ID < 0 || 查找活动任务(熔火酒接取玩家ID, 熔火酒任务ID) == null) {
    停止熔火酒送达扫描();
    return;
  }
  const 玩家 = jass.Player(熔火酒接取玩家ID);
  const 英雄 = getRegisteredPlayerHero(玩家);
  if (英雄 == null || 英雄 === 0) return;
  const X差 = jass.GetUnitX(英雄) - 城外守卫X;
  const Y差 = jass.GetUnitY(英雄) - 城外守卫Y;
  if (X差 * X差 + Y差 * Y差 > 城外守卫触发范围 * 城外守卫触发范围) return;

  const 酒物品类型ID = stringToFourCCSafe(熔火酒物品ID);
  if (!ConsumeItemTypeCountByChargesBJ(英雄, 酒物品类型ID, 1)) {
    广播单位提示(英雄, "|cffffff00『任务提示』：|r熔火酒不在身上，无法交给城外巡卫。", 4200);
    return;
  }
  if (!更新任务目标(熔火酒接取玩家ID, 熔火酒任务ID, 1)) return;
  const 守卫 = 按任务ID查找已创建NPC(城外恶魔守卫登记ID);
  广播单位提示(守卫 || 英雄, "总算送到了。城外的夜风可比酒窖冷得多，回去替我向管事道声谢。", 4800);
  停止熔火酒送达扫描();
}

function on恶魔城任务单位死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (死亡单位 == null || 死亡单位 === 0) return;

  if (遗失角饰恶魔犬 != null && 遗失角饰恶魔犬 !== 0 && jass.GetHandleId(死亡单位) === jass.GetHandleId(遗失角饰恶魔犬)) {
    const 玩家ID = 遗失角饰接取玩家ID;
    遗失角饰恶魔犬 = null;
    const 英雄 = 玩家ID >= 0 ? getRegisteredPlayerHero(jass.Player(玩家ID)) : null;
    if (英雄 != null && 英雄 !== 0 && 更新任务目标(玩家ID, 遗失角饰任务ID, 1)) {
      发放任务物品(英雄, 遗失角饰物品ID);
      广播单位提示(英雄, "|cffffff00『任务进度』：|r从恶魔犬的项圈下找到了遗失的仪式角饰。把它带回给年轻恶魔。", 5000);
    }
  }

  if (jass.GetUnitTypeId(死亡单位) === stringToFourCCSafe("u004")) {
    for (let 玩家ID = 0; 玩家ID < 4; 玩家ID++) {
      const 进度 = 读取任务进度(玩家ID, 迷宫缺灯任务ID);
      if (进度 == null || 进度.当前 < 3 || 进度.当前 >= 进度.需求) continue;
      if (更新任务目标(玩家ID, 迷宫缺灯任务ID, 进度.需求)) {
        广播单位提示(死亡单位, "|cffffff00『调查完成』：|r双翼究极恶魔已经倒下，迷宫外围的路线重新恢复安全。回去找测绘师复命吧。", 5200);
      }
      break;
    }
  }
}

function 单位仍然有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && GetUnitTypeId(单位) !== 0;
}

function 清理合法决斗单位(this: void): void {
  if (单位仍然有效(合法决斗北侧单位)) RemoveUnit(合法决斗北侧单位);
  if (单位仍然有效(合法决斗南侧单位)) RemoveUnit(合法决斗南侧单位);
  合法决斗北侧单位 = null;
  合法决斗南侧单位 = null;
}

function 停止合法决斗(this: void): void {
  if (合法决斗回调ID !== 0) removePeriodicCallback(合法决斗回调ID);
  合法决斗回调ID = 0;
  if (单位仍然有效(合法决斗北侧单位)) IssueImmediateOrder(合法决斗北侧单位, "stop");
  if (单位仍然有效(合法决斗南侧单位)) IssueImmediateOrder(合法决斗南侧单位, "stop");
}

function 配置合法决斗演员(this: void, 单位: any, 名称: string): void {
  if (!单位仍然有效(单位)) return;
  设单位名字(单位, 名称);
  UnitAddAbility(单位, stringToFourCCSafe("Avul"));
  UnitRemoveAbility(单位, stringToFourCCSafe("A08Q"));
  UnitRemoveAbility(单位, stringToFourCCSafe("A08T"));
  UnitRemoveAbility(单位, stringToFourCCSafe("A08K"));
  SetUnitStateJapi(单位, 最大生命状态, 决斗统一最大生命);
  SetUnitStateJapi(单位, 决斗攻击力状态, 决斗统一攻击力);
  SetUnitStateJapi(单位, 决斗护甲状态, 决斗统一护甲);
  SetUnitStateJapi(单位, 决斗攻击间隔状态, 决斗统一攻击间隔);
  SetUnitState(单位, 当前生命状态, 决斗统一最大生命);
}

export function 创建合法决斗场景单位(this: void): void {
  const 已创建仲裁员 = 按任务ID查找已创建NPC(合法决斗任务ID);
  if (!单位仍然有效(已创建仲裁员)) 按任务ID创建NPC(合法决斗任务ID);

  const 中立被动 = Player(jass.PLAYER_NEUTRAL_PASSIVE as number);
  if (!单位仍然有效(合法决斗北侧单位)) {
    合法决斗北侧单位 = 创建单位并登记排泄安全(中立被动, stringToFourCCSafe("n03L"), 决斗北侧X, 决斗北侧Y, 270);
    配置合法决斗演员(合法决斗北侧单位, "熔角战士·卡鲁");
  }
  if (!单位仍然有效(合法决斗南侧单位)) {
    合法决斗南侧单位 = 创建单位并登记排泄安全(中立被动, stringToFourCCSafe("o001"), 决斗南侧X, 决斗南侧Y, 90);
    配置合法决斗演员(合法决斗南侧单位, "赤甲步兵·维萨");
  }
}

function 完成合法决斗裁定(this: void, 胜者: any, 败者: any): void {
  if (合法决斗已结束) return;
  合法决斗已结束 = true;
  停止合法决斗();
  if (单位仍然有效(胜者)) SetUnitAnimation(胜者, "stand victory");
  if (单位仍然有效(败者)) SetUnitAnimation(败者, "stand");
  if (合法决斗接取玩家ID >= 0) 更新任务目标(合法决斗接取玩家ID, 合法决斗任务ID, 1);
  const 仲裁员 = 按任务ID查找已创建NPC(合法决斗任务ID);
  广播单位提示(仲裁员 || 胜者, `胜负已分。${GetUnitName(胜者)}取得了这场决斗的胜利，双方立即停手。`, 5200);
  addDelayedCallback(3500, 清理合法决斗单位);
}

function on合法决斗回合(this: void): void {
  if (合法决斗已结束 || !单位仍然有效(合法决斗北侧单位) || !单位仍然有效(合法决斗南侧单位)) {
    停止合法决斗();
    return;
  }
  const 北侧当前生命 = GetUnitState(合法决斗北侧单位, 当前生命状态);
  const 南侧当前生命 = GetUnitState(合法决斗南侧单位, 当前生命状态);
  const 北侧结算生命 = 北侧当前生命 - GetRandomReal(760, 1040);
  const 南侧结算生命 = 南侧当前生命 - GetRandomReal(760, 1040);
  const 裁定生命 = 决斗统一最大生命 * 决斗裁定生命比例;
  SetUnitAnimation(合法决斗北侧单位, "attack");
  SetUnitAnimation(合法决斗南侧单位, "attack");

  if (北侧结算生命 <= 裁定生命 || 南侧结算生命 <= 裁定生命) {
    SetUnitState(合法决斗北侧单位, 当前生命状态, 北侧结算生命 > 裁定生命 ? 北侧结算生命 : 裁定生命);
    SetUnitState(合法决斗南侧单位, 当前生命状态, 南侧结算生命 > 裁定生命 ? 南侧结算生命 : 裁定生命);
    if (北侧结算生命 > 南侧结算生命) 完成合法决斗裁定(合法决斗北侧单位, 合法决斗南侧单位);
    else 完成合法决斗裁定(合法决斗南侧单位, 合法决斗北侧单位);
    return;
  }
  SetUnitState(合法决斗北侧单位, 当前生命状态, 北侧结算生命);
  SetUnitState(合法决斗南侧单位, 当前生命状态, 南侧结算生命);
}

function 开始合法决斗(this: void): void {
  if (!单位仍然有效(合法决斗北侧单位) || !单位仍然有效(合法决斗南侧单位)) return;
  const 仲裁员 = 按任务ID查找已创建NPC(合法决斗任务ID);
  广播单位提示(仲裁员 || 合法决斗北侧单位, "城契为证，点到为止。决斗开始！", 3600);
  合法决斗回调ID = addPeriodicCallback(1000, on合法决斗回合);
}

export function 接受迟到的熔火酒任务(this: void, 玩家ID: number): void {
  熔火酒接取玩家ID = 玩家ID;
  停止熔火酒送达扫描();
  熔火酒扫描回调ID = addPeriodicCallback(500, on熔火酒送达扫描);
}

export function 完成迟到的熔火酒任务(this: void, _玩家ID: number): void {
  停止熔火酒送达扫描();
  熔火酒接取玩家ID = -1;
}

export function 接受迷宫缺灯任务(this: void, _玩家ID: number): void {
  注册任务调查点(迷宫缺灯任务ID);
}

export function 完成迷宫缺灯任务(this: void, _玩家ID: number): void {
  清理任务调查点(迷宫缺灯任务ID);
}

export function 接受遗失角饰任务(this: void, 玩家ID: number): void {
  遗失角饰接取玩家ID = 玩家ID;
  if (遗失角饰恶魔犬 != null && 遗失角饰恶魔犬 !== 0 && jass.GetUnitTypeId(遗失角饰恶魔犬) !== 0) {
    jass.RemoveUnit(遗失角饰恶魔犬);
  }
  遗失角饰恶魔犬 = 创建单位并登记排泄安全(
    jass.Player(12),
    stringToFourCCSafe("n037"),
    22448.7,
    -19816.9,
    180,
  );
  const 英雄 = getRegisteredPlayerHero(jass.Player(玩家ID));
  广播单位提示(英雄, "|cffffff00『任务提示』：|r恶魔犬最后出现的位置在城外熔痕地带。仪式角饰应该还挂在它身上。", 5000);
}

export function 完成遗失角饰任务(this: void, _玩家ID: number): void {
  if (遗失角饰恶魔犬 != null && 遗失角饰恶魔犬 !== 0 && jass.GetUnitTypeId(遗失角饰恶魔犬) !== 0) {
    jass.RemoveUnit(遗失角饰恶魔犬);
  }
  遗失角饰恶魔犬 = null;
  遗失角饰接取玩家ID = -1;
}

export function 接受墓门旧誓任务(this: void, _玩家ID: number): void {
  注册任务调查点(墓门旧誓任务ID);
}

export function 完成墓门旧誓任务(this: void, _玩家ID: number): void {
  清理任务调查点(墓门旧誓任务ID);
}

export function 接受熔核余温任务(this: void, _玩家ID: number): void {
  注册任务调查点(熔核余温任务ID);
}

export function 完成熔核余温任务(this: void, _玩家ID: number): void {
  清理任务调查点(熔核余温任务ID);
}

export function 接受合法决斗任务(this: void, 玩家ID: number): void {
  停止合法决斗();
  合法决斗接取玩家ID = 玩家ID;
  合法决斗已结束 = false;
  创建合法决斗场景单位();
  addDelayedCallback(1200, 开始合法决斗);
}

export function 完成合法决斗任务(this: void, _玩家ID: number): void {
  停止合法决斗();
  清理合法决斗单位();
  合法决斗接取玩家ID = -1;
  合法决斗已结束 = false;
}

registerDeathListener(on恶魔城任务单位死亡);

export {};
