/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { registerPlayerUnitEventForPlayerIds } = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (
    this: void,
    trigger: any,
    playerIds: readonly number[],
    eventId: any,
    filter?: any,
  ) => void;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
  unregisterDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { safeTriggerAddAction, safeTriggerRemoveAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, trigger: any, callback: (this: void) => void) => { readonly id: number } | null;
  safeTriggerRemoveAction: (this: void, trigger: any, action: { readonly id: number } | null | undefined) => void;
  safeDestroyTrigger: (this: void, trigger: any) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 广播单位提示, 播放广播对白序列 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, duration?: number) => void;
  播放广播对白序列: (this: void, 配置: any) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, source: string) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: { 模型路径: string; X: number; Y: number; 持续秒?: number }) => any;
};
const { 创建单位绑定闪电, 销毁单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, params: {
    效果代码: string;
    起点单位: any;
    终点单位: any;
    持续时间: number;
    起点高度偏移?: number;
    终点高度偏移?: number;
  }) => any;
  销毁单位绑定闪电: (this: void, lightning: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, force: any, messageType: number, message: string) => void;
};
const {
  动态矩形区域配置表,
  按配置键注册动态矩形区域,
  注销动态矩形区域,
} = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  动态矩形区域配置表: Record<string, { 键: string; 左: number; 右: number; 下: number; 上: number }>;
  按配置键注册动态矩形区域: (this: void, 键: string) => any;
  注销动态矩形区域: (this: void, 键: string) => boolean;
};

import { 创建剧情NPC单位 } from "../../00．公共/02．剧情NPC创建";
import { 启动剧情Boss战 } from "../../01．主线任务/00．剧情系统核心工具/11．剧情Boss战启动桥接";

const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, modelName: string, target: any, attachPoint: string) => any;
const Cos = jass.Cos as (this: void, radians: number) => number;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const DestroyGroup = jass.DestroyGroup as (this: void, group: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, group: any) => any;
const GetAttacker = jass.GetAttacker as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerController = jass.GetPlayerController as (this: void, player: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const GetPlayerSlotState = jass.GetPlayerSlotState as (this: void, player: any) => any;
const GetPlayerState = jass.GetPlayerState as (this: void, player: any, state: any) => number;
const GetRandomReal = jass.GetRandomReal as (this: void, low: number, high: number) => number;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetWidgetLife = jass.GetWidgetLife as (this: void, widget: any) => number;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (this: void, group: any, x: number, y: number, radius: number, filter: any) => void;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, group: any, unit: any) => void;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const SetPlayerState = jass.SetPlayerState as (this: void, player: any, state: any, value: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, animationIndex: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const Sin = jass.Sin as (this: void, radians: number) => number;

const 精灵城执法监听矩形键 = "支线.瑟兰迪尔精灵城执法监听";
const 精灵城执法监听配置 = 动态矩形区域配置表[精灵城执法监听矩形键];
const 执法单位检查范围 = 500;
const 瑟兰迪尔出生前方距离 = 250;
const 概率检查冷却毫秒 = 1000;
const 演出暂停来源 = "支线.瑟兰迪尔执法演出";
const 可游玩玩家ID = [0, 1, 2, 3, 4] as const;
const 角度转弧度 = 0.017453292519943295;

const 执法队男单位ID = stringToFourCCSafe("h00L");
const 执法队女单位ID = stringToFourCCSafe("h00K");
const 执法队长单位ID = stringToFourCCSafe("h00Z");

const 圣光特效 = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl";
const 空中锁链特效 = "Abilities\\Spells\\Human\\AerialShackles\\AerialShacklesTarget.mdl";

interface 瑟兰迪尔执法状态 {
  Boss单位: any;
  触发英雄: any;
  受害NPC: any;
  枷锁特效: any;
  枷锁闪电: any;
  已启动战斗: boolean;
  已执行罚款: boolean;
}

let 精灵城监听矩形: any = null;
let 攻击监听触发器: any = null;
let 攻击监听动作: { readonly id: number } | null = null;
let 入口已触发 = false;
let 上次概率检查时间 = -概率检查冷却毫秒;
let 当前执法状态: 瑟兰迪尔执法状态 | undefined;
let 死亡监听已注册 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetWidgetLife(unit) > 0.405;
}

function 单位位于精灵城(this: void, unit: any): boolean {
  if (!单位有效(unit)) return false;
  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  return x >= 精灵城执法监听配置.左
    && x <= 精灵城执法监听配置.右
    && y >= 精灵城执法监听配置.下
    && y <= 精灵城执法监听配置.上;
}

function 是可游玩英雄(this: void, unit: any): boolean {
  if (!单位有效(unit) || !是玩家英雄组单位(unit)) return false;
  const playerId = GetPlayerId(GetOwningPlayer(unit));
  return playerId >= 0 && playerId <= 4;
}

function 读取附近执法触发概率(this: void, victim: any): number {
  const group = CreateGroup();
  if (group == null || group === 0) return 0;

  GroupEnumUnitsInRange(group, GetUnitX(victim), GetUnitY(victim), 执法单位检查范围, null);
  let 有普通队员 = false;
  let 有执法队长 = false;
  while (true) {
    const unit = FirstOfGroup(group);
    if (unit == null || unit === 0) break;
    GroupRemoveUnit(group, unit);
    if (!单位有效(unit)) continue;

    const unitTypeId = GetUnitTypeId(unit);
    if (unitTypeId === 执法队长单位ID) {
      有执法队长 = true;
      break;
    }
    if (unitTypeId === 执法队男单位ID || unitTypeId === 执法队女单位ID) {
      有普通队员 = true;
    }
  }
  DestroyGroup(group);
  return 有执法队长 ? 10 : (有普通队员 ? 5 : 0);
}

function 清理逮捕表现(this: void): void {
  const state = 当前执法状态;
  if (state == null) return;
  if (state.枷锁闪电 != null && state.枷锁闪电 !== 0) {
    销毁单位绑定闪电(state.枷锁闪电);
    state.枷锁闪电 = null;
  }
  if (state.枷锁特效 != null && state.枷锁特效 !== 0) {
    DestroyEffect(state.枷锁特效);
    state.枷锁特效 = null;
  }
}

function 释放演出暂停(this: void): void {
  const state = 当前执法状态;
  if (state == null) return;
  if (state.触发英雄 != null && state.触发英雄 !== 0) {
    移除单位暂停(state.触发英雄, 演出暂停来源);
  }
  if (state.Boss单位 != null && state.Boss单位 !== 0) {
    if (!解除暂停并取消无敌安全(state.Boss单位, 演出暂停来源)) {
      移除单位暂停(state.Boss单位, 演出暂停来源);
    }
  }
}

function 校验执法对白状态(this: void): boolean {
  const state = 当前执法状态;
  return state != null && 单位有效(state.Boss单位);
}

function 读取执法对白单位(this: void, 说话者键: string): any {
  const state = 当前执法状态;
  if (state == null) return null;
  return 说话者键 === "Boss" ? state.Boss单位 : state.触发英雄;
}

function on执法单句播放前(this: void, 序号: number): void {
  if (序号 === 4) 清理逮捕表现();
}

function 播放执法对白(this: void): void {
  播放广播对白序列({
    对白列表: [
      { 说话者键: "Boss", 文本: "住手。这里是精灵王城，不是任由外来者撒野的地方。", 停留毫秒: 3500 },
      { 说话者键: "玩家", 文本: "误会，我们只是……一时没控制好手。", 停留毫秒: 3000 },
      { 说话者键: "Boss", 文本: "武器已经落在无辜者身上，这不叫误会。放下武器，跟我回执法厅。", 停留毫秒: 4200 },
      { 说话者键: "玩家", 文本: "等等，事情还没弄清楚，不能就这么把我们带走！", 停留毫秒: 3400 },
      { 说话者键: "Boss", 文本: "拒捕、袭击城民，还企图以武力抗法。很好，那就由我亲自执行裁决。", 停留毫秒: 4200 },
      { 说话者键: "玩家", 文本: "看来这次解释不清了。大家小心，先挡住他！", 停留毫秒: 3200 },
    ],
    读取说话单位: 读取执法对白单位,
    播放单句: 广播单位提示,
    播放前校验: 校验执法对白状态,
    单句播放前: on执法单句播放前,
    播放完成: on执法对白结束,
  });
}

function on执法对白结束(this: void): void {
  const state = 当前执法状态;
  if (state == null || state.已启动战斗 || !单位有效(state.Boss单位)) {
    清理逮捕表现();
    释放演出暂停();
    return;
  }

  state.已启动战斗 = true;
  清理逮捕表现();
  const 已启动 = 启动剧情Boss战(state.Boss单位, { 触发单位: state.触发英雄, 暂停来源: 演出暂停来源 });
  释放演出暂停();
  if (!已启动) {
    state.已启动战斗 = false;
  }
}

function 注销执法入口(this: void): void {
  if (攻击监听触发器 != null && 攻击监听动作 != null) {
    safeTriggerRemoveAction(攻击监听触发器, 攻击监听动作);
  }
  攻击监听触发器 = null;
  攻击监听动作 = null;
  注销动态矩形区域(精灵城执法监听矩形键);
  精灵城监听矩形 = null;
}

function 创建并播放圣光特效(this: void, victim: any): void {
  创建点特效({
    模型路径: 圣光特效,
    X: GetUnitX(victim),
    Y: GetUnitY(victim),
    持续秒: 1,
  });
}

function 开始瑟兰迪尔执法演出(this: void, hero: any, victim: any): boolean {
  const facing = GetUnitFacing(hero);
  const radians = facing * 角度转弧度;
  const bossX = GetUnitX(hero) + Cos(radians) * 瑟兰迪尔出生前方距离;
  const bossY = GetUnitY(hero) + Sin(radians) * 瑟兰迪尔出生前方距离;
  const boss = 创建剧情NPC单位({
    单位ID: "N057",
    X: bossX,
    Y: bossY,
    朝向: (facing + 180) % 360,
    玩家ID: 15,
    登记死亡排泄: true,
  });
  if (boss == null || boss === 0) return false;

  当前执法状态 = {
    Boss单位: boss,
    触发英雄: hero,
    受害NPC: victim,
    枷锁特效: null,
    枷锁闪电: null,
    已启动战斗: false,
    已执行罚款: false,
  };
  入口已触发 = true;
  注销执法入口();

  IssueImmediateOrder(hero, "stop");
  IssueImmediateOrder(boss, "stop");
  SetUnitFacing(boss, (facing + 180) % 360);
  添加单位暂停(hero, 演出暂停来源);
  暂停并设置无敌安全(boss, 演出暂停来源);
  SetUnitAnimationByIndex(boss, 9);

  创建并播放圣光特效(victim);
  当前执法状态.枷锁特效 = AddSpecialEffectTarget(空中锁链特效, hero, "origin");
  当前执法状态.枷锁闪电 = 创建单位绑定闪电({
    效果代码: "LEAS",
    起点单位: boss,
    终点单位: hero,
    持续时间: 60,
    起点高度偏移: 120,
    终点高度偏移: 80,
  });
  播放执法对白();
  return true;
}

function on玩家攻击中立NPC(this: void): void {
  if (入口已触发 || 精灵城监听矩形 == null || 精灵城监听矩形 === 0) return;

  const victim = GetTriggerUnit();
  const attacker = GetAttacker();
  if (!是可游玩英雄(attacker) || !单位位于精灵城(attacker) || !单位位于精灵城(victim)) return;
  if (GetOwningPlayer(victim) !== Player(jass.PLAYER_NEUTRAL_PASSIVE as number)) return;

  const probability = 读取附近执法触发概率(victim);
  if (probability <= 0) return;

  const currentTime = getServerTime();
  if (currentTime - 上次概率检查时间 < 概率检查冷却毫秒) return;
  上次概率检查时间 = currentTime;
  if (GetRandomReal(0, 100) >= probability) return;

  开始瑟兰迪尔执法演出(attacker, victim);
}

function 是有效在线玩家(this: void, player: any): boolean {
  return player != null
    && player !== 0
    && GetPlayerController(player) === jass.MAP_CONTROL_USER
    && GetPlayerSlotState(player) === jass.PLAYER_SLOT_STATE_PLAYING;
}

function 执行全员治安罚款(this: void): void {
  for (let playerId = 0; playerId <= 4; playerId++) {
    const player = Player(playerId);
    if (!是有效在线玩家(player)) continue;
    const currentGold = GetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD);
    const remainingGold = currentGold > 10000 ? currentGold - 10000 : 0;
    SetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD, remainingGold);
  }
  QuestMessageBJ(
    GetPlayersAll(),
    jglobals.bj_QUESTMESSAGE_WARNING,
    "|cffffff00『系统消息』：|r因扰乱精灵王城治安，所有玩家被处以|cffff000010000金币|r罚款。",
  );
}

function on瑟兰迪尔死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const state = 当前执法状态;
  if (state == null || dyingUnit !== state.Boss单位 || state.已执行罚款) return;

  state.已执行罚款 = true;
  清理逮捕表现();
  释放演出暂停();
  执行全员治安罚款();
  if (死亡监听已注册) {
    unregisterDeathListener(on瑟兰迪尔死亡);
    死亡监听已注册 = false;
  }
  当前执法状态 = undefined;
}

export function 初始化瑟兰迪尔执法事件(this: void): void {
  if (攻击监听触发器 != null || 入口已触发) return;

  精灵城监听矩形 = 按配置键注册动态矩形区域(精灵城执法监听矩形键);
  const trigger = CreateTrigger();
  if (trigger == null || trigger === 0) {
    注销动态矩形区域(精灵城执法监听矩形键);
    精灵城监听矩形 = null;
    return;
  }

  const action = safeTriggerAddAction(trigger, on玩家攻击中立NPC);
  if (action == null) {
    safeDestroyTrigger(trigger);
    注销动态矩形区域(精灵城执法监听矩形键);
    精灵城监听矩形 = null;
    return;
  }

  攻击监听触发器 = trigger;
  攻击监听动作 = action;
  registerPlayerUnitEventForPlayerIds(trigger, 可游玩玩家ID, jass.EVENT_PLAYER_UNIT_ATTACKED);
  registerDeathListener(on瑟兰迪尔死亡);
  死亡监听已注册 = true;
}

export function 读取当前瑟兰迪尔执法Boss(this: void): any {
  return 当前执法状态?.Boss单位;
}
