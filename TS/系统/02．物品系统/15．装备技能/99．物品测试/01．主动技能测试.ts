/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.index") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
import { items as 装备数据 } from "../../01．装备数据";
import { 通用物品技能槽位配置表 } from "../03．主动技能/00．公共/02．通用物品技能槽位配置";
import { 刷新物品CD, 施加减速 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import {
  物品主动技能测试发放顺序,
  物品主动技能测试命令列表,
  物品主动技能测试命令说明文本列表,
  物品主动技能测试清理装备列表,
  精灵药水测试装备列表,
} from "./00．测试配置";

const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const CreateItem = jass.CreateItem as (itemId: number, x: number, y: number) => any;
const UnitRemoveItem = jass.UnitRemoveItem as (unit: any, item: any) => boolean;
const UnitAddItem = jass.UnitAddItem as (unit: any, item: any) => boolean;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetPlayerName = jass.GetPlayerName as (player: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (whichGroup: any) => void;
const GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer as (whichGroup: any, whichPlayer: any, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (whichGroup: any, whichUnit: any) => void;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 模块名 = "物品主动技能测试";
const 精灵药水套装测试命令 = "192";
const 物品冷却刷新命令 = "wpcd";
const 物品负面清除测试减速命令 = "wpslow";
const 打印注册命令日志 = false;
const 测试玩家名称 = "WorldEdit";
const 红色玩家ID = 0;
const 测试物品技能ID表: Record<number, number[] | undefined> = {};
const 测试物品主动最大冷却秒表: Record<number, number | undefined> = {};
const 盗贼神符远距测试距离 = 700;
let 已初始化测试物品技能ID表 = false;

function 获取测试单位(this: void): any {
  return g.gg_unit_Hamg_0002 ?? (globalThis as any).bj_lastCreatedUnit ?? null;
}

const SetItemPosition = jass.SetItemPosition as (item: any, x: number, y: number) => void;

function 丢弃测试装备(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  for (let i = 0; i < 6; i++) {
    const item = UnitItemInSlot(unit, i);
    if (item == null || item === 0) continue;
    const itemTypeId = GetItemTypeId(item);
    for (let j = 0; j < 物品主动技能测试清理装备列表.length; j++) {
      const 装备名 = 物品主动技能测试清理装备列表[j];
      const rawId = 按名字反查物品ID(装备名);
      if (rawId == null || rawId === "") continue;
      if (stringToFourCCSafe(rawId) === itemTypeId) {
        UnitRemoveItem(unit, item);
        SetItemPosition(item, x, y);
        break;
      }
    }
  }
}

function 是允许物品测试玩家(this: void, player: any): boolean {
  if (player == null || player === 0) return false;
  if (GetPlayerId(player) !== 红色玩家ID) return false;
  const playerName = GetPlayerName(player) ?? "";
  return playerName === 测试玩家名称 || playerName === 测试玩家名称 + ":";
}

function 是有效英雄(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 单位属于玩家(this: void, unit: any, player: any): boolean {
  if (!是有效英雄(unit)) return false;
  return GetPlayerId(GetOwningPlayer(unit)) === GetPlayerId(player);
}

function 收集玩家英雄(this: void, player: any): any[] {
  const result: any[] = [];
  const seen: Record<number, boolean> = {};

  function 添加英雄(this: void, hero: any): void {
    if (!单位属于玩家(hero, player)) return;
    const handleId = GetHandleId(hero);
    if (handleId > 0 && seen[handleId] === true) return;
    if (handleId > 0) seen[handleId] = true;
    result.push(hero);
  }

  添加英雄(getRegisteredPlayerHero(player));
  添加英雄(获取测试单位());

  const group = CreateGroup();
  GroupEnumUnitsOfPlayer(group, player, null);
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    添加英雄(unit);
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
  return result;
}

function 获取玩家测试单位(this: void, player: any): any {
  const heroes = 收集玩家英雄(player);
  if (heroes.length > 0) return heroes[0];
  return null;
}

function 发放装备(this: void, unit: any, 装备名: string): boolean {
  const rawId = 按名字反查物品ID(装备名);
  if (rawId == null || rawId === "") {
    debugLogForce(模块名, "未找到装备ID", 装备名);
    return false;
  }
  const itemTypeId = stringToFourCCSafe(rawId);
  if (发放盗贼神符远距测试(unit, 装备名, rawId, itemTypeId)) return true;
  const item = CreateItem(itemTypeId, GetUnitX(unit), GetUnitY(unit));
  if (item == null || item === 0) {
    debugLogForce(模块名, "创建装备失败", 装备名, rawId, itemTypeId);
    return false;
  }
  IssueTargetOrder(unit, "smart", item);
  debugLogForce(模块名, "已创建在脚下并命令拾取", 装备名, rawId);
  return true;
}

function 发放盗贼神符远距测试(this: void, unit: any, 装备名: string, rawId: string, itemTypeId: number): boolean {
  let offsetX = 0;
  if (rawId === "I0FL") offsetX = 盗贼神符远距测试距离;
  else if (rawId === "I0FK") offsetX = -盗贼神符远距测试距离;
  else return false;

  const item = CreateItem(itemTypeId, GetUnitX(unit) + offsetX, GetUnitY(unit));
  if (item == null || item === 0) {
    debugLogForce(模块名, "创建盗贼神符失败", 装备名, rawId, itemTypeId);
    return true;
  }
  const orderOk = IssueTargetOrder(unit, "smart", item);
  debugLogForce(模块名, "已创建盗贼神符远距测试并命令拾取", 装备名, rawId, "距离", 盗贼神符远距测试距离, "ownerPid", GetPlayerId(GetOwningPlayer(unit)), "orderOk", orderOk);
  return true;
}

function 添加测试物品技能ID(this: void, rawId: string | undefined, abilList: string | undefined): void {
  if (rawId == null || rawId === "" || abilList == null || abilList === "") return;
  const itemTypeId = stringToFourCCSafe(rawId);
  if (itemTypeId === 0) return;

  const abilityIds = 测试物品技能ID表[itemTypeId] ?? [];
  const rawAbilityList = abilList.split(",");
  for (let i = 0; i < rawAbilityList.length; i++) {
    const abilityRawId = rawAbilityList[i].trim();
    if (abilityRawId === "") continue;
    const abilityId = stringToFourCCSafe(abilityRawId);
    if (abilityId !== 0 && abilityIds.indexOf(abilityId) < 0) {
      abilityIds.push(abilityId);
    }
  }
  if (abilityIds.length > 0) {
    测试物品技能ID表[itemTypeId] = abilityIds;
  }
}

function 记录测试物品主动最大冷却(this: void, rawId: string | undefined, 秒数: number): void {
  if (rawId == null || rawId === "" || !(秒数 > 0)) return;
  const itemTypeId = stringToFourCCSafe(rawId);
  if (itemTypeId === 0) return;
  const old = 测试物品主动最大冷却秒表[itemTypeId] ?? 0;
  if (秒数 > old) 测试物品主动最大冷却秒表[itemTypeId] = 秒数;
}

function 初始化测试物品技能ID表(this: void): void {
  if (已初始化测试物品技能ID表) return;
  已初始化测试物品技能ID表 = true;

  const 测试物品RawID表: Record<string, boolean> = {};
  for (let i = 0; i < 物品主动技能测试清理装备列表.length; i++) {
    const 装备名 = 物品主动技能测试清理装备列表[i];
    const rawId = 按名字反查物品ID(装备名);
    if (rawId != null && rawId !== "") 测试物品RawID表[rawId] = true;
    const 装备项 = rawId != null ? 装备数据[rawId] : undefined;
    添加测试物品技能ID(rawId, 装备项?.abilList);
  }

  for (let i = 0; i < 通用物品技能槽位配置表.length; i++) {
    const 配置 = 通用物品技能槽位配置表[i];
    if (测试物品RawID表[配置.物编ID] === true) {
      const itemTypeId = stringToFourCCSafe(配置.物编ID);
      if (itemTypeId !== 0) 测试物品技能ID表[itemTypeId] = [];
      添加测试物品技能ID(配置.物编ID, 配置.技能ID);
      记录测试物品主动最大冷却(配置.物编ID, 配置.冷却时间);
    }
  }
}

function 刷新英雄装备冷却(this: void, hero: any): number {
  if (!是有效英雄(hero)) return 0;
  初始化测试物品技能ID表();

  let 刷新数量 = 0;
  for (let 槽位 = 0; 槽位 < 6; 槽位++) {
    const item = UnitItemInSlot(hero, 槽位);
    if (item == null || item === 0) continue;
    const itemTypeId = GetItemTypeId(item);
    const abilityIds = 测试物品技能ID表[itemTypeId];
    const activeMaxSec = 测试物品主动最大冷却秒表[itemTypeId];
    刷新数量 += 刷新物品CD({ unit: hero, item, 主动技能ID: abilityIds, 主动最大冷却秒数: activeMaxSec, 范围: "全部" });
  }
  return 刷新数量;
}

function on聊天刷新物品冷却(this: void, player: any, _command: string): void {
  if (!是允许物品测试玩家(player)) return;

  const heroes = 收集玩家英雄(player);
  if (heroes.length <= 0) {
    debugLogForce(模块名, "未找到红色测试玩家英雄");
    return;
  }

  let 刷新数量 = 0;
  for (let i = 0; i < heroes.length; i++) {
    刷新数量 += 刷新英雄装备冷却(heroes[i]);
  }
  debugLogForce(模块名, "已刷新测试物品冷却", "英雄数", heroes.length, "技能数", 刷新数量);
}

function on聊天挂载减速测试(this: void, player: any, _command: string): void {
  if (!是允许物品测试玩家(player)) return;

  const unit = 获取玩家测试单位(player);
  if (unit == null || unit === 0) {
    debugLogForce(模块名, "未找到红色测试玩家英雄");
    return;
  }

  施加减速(unit, unit, 0.5, 12);
  debugLogForce(模块名, "已给测试英雄施加减速Buff", "持续秒数", 12, "减速比例", 0.5);
}

function 发放单个装备(this: void, unit: any, 序号: number): void {
  丢弃测试装备(unit);
  if (序号 === 192) {
    let 创建数量 = 0;
    const x = GetUnitX(unit);
    const y = GetUnitY(unit);
    for (let i = 0; i < 精灵药水测试装备列表.length; i++) {
      const 装备名 = 精灵药水测试装备列表[i];
      const rawId = 按名字反查物品ID(装备名);
      const itemTypeId = stringToFourCCSafe(rawId);
      if (itemTypeId === 0) {
        debugLogForce(模块名, "未找到精灵药水ID", 装备名);
        continue;
      }
      const item = CreateItem(itemTypeId, x, y);
      if (item == null || item === 0) {
        debugLogForce(模块名, "创建精灵药水失败", 装备名, rawId, itemTypeId);
        continue;
      }
      UnitAddItem(unit, item);
      创建数量 += 1;
    }
    debugLogForce(模块名, "已发放全部精灵药水", "创建数量", 创建数量);
    return;
  }
  if (序号 > 0 && 序号 <= 物品主动技能测试发放顺序.length) {
    const 装备名 = 物品主动技能测试发放顺序[序号 - 1];
    if (发放装备(unit, 装备名)) {
      debugLogForce(模块名, "已发放测试装备", 序号, 装备名);
    }
  }
}

function on聊天wp测试(this: void, player: any, command: string): void {
  if (!是允许物品测试玩家(player)) return;

  const unit = 获取玩家测试单位(player);
  if (unit == null || unit === 0) {
    debugLogForce(模块名, "未找到红色测试玩家英雄");
    return;
  }

  if (command === 精灵药水套装测试命令) {
    发放单个装备(unit, 192);
    return;
  }

  for (let i = 0; i < 物品主动技能测试命令列表.length; i++) {
    if (command === 物品主动技能测试命令列表[i]) {
      发放单个装备(unit, i + 1);
      return;
    }
  }
}

for (let i = 0; i < 物品主动技能测试命令列表.length; i++) {
  注册聊天命令监听(物品主动技能测试命令列表[i], on聊天wp测试);
}
注册聊天命令监听(精灵药水套装测试命令, on聊天wp测试);
注册聊天命令监听(物品冷却刷新命令, on聊天刷新物品冷却);
注册聊天命令监听(物品负面清除测试减速命令, on聊天挂载减速测试);

if (打印注册命令日志) {
  debugLogForce(模块名, "已注册测试命令", 物品主动技能测试命令说明文本列表.join(" | "), 物品冷却刷新命令 + "=刷新当前玩家英雄装备冷却", 物品负面清除测试减速命令 + "=给当前测试英雄挂减速Buff");
}

export {};
