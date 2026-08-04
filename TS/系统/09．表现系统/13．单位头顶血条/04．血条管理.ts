/** @noSelfInFile */

import {
  启用单位头顶血条,
  血条刷新间隔Tick,
  血条创建每批数量,
  血条尺寸,
  血条资源,
} from "./00．常量";
import type { 单位血条绑定, 单位血条帧组 } from "./01．类型";
import { 取单位血条帧组, 回收单位血条帧组 } from "./03．血条池";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const { onTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: (this: void) => void) => void;
};
const { 查询单位可显示护盾值, 查询单位护盾列表, 护盾类型 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.index") as {
  查询单位可显示护盾值: (this: void, unit: any) => number;
  查询单位护盾列表: (this: void, unit: any) => Array<{ 类型: number; 当前值: number; 显示护盾条: boolean }>;
  护盾类型: {
    通用: number;
    物理: number;
    魔法: number;
    强化: number;
    金: number;
    木: number;
    水: number;
    火: number;
    冰: number;
    雷: number;
    风: number;
    暗: number;
    光: number;
    毒: number;
  };
};
const { TriggerRegisterEnterRectSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterEnterRectSimple: (this: void, trig: any, rect: any) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetWorldBounds = jass.GetWorldBounds as () => any;
const GetTriggerUnit = jass.GetTriggerUnit as () => any;
const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: (this: void) => void) => void;
const CreateGroup = jass.CreateGroup as () => any;
const GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect as (group: any, rect: any, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (group: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (group: any, unit: any) => void;
const DestroyGroup = jass.DestroyGroup as (group: any) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, whichPlayer: any) => boolean;
const GetLocalPlayer = jass.GetLocalPlayer as () => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitLevel = jass.GetUnitLevel as (unit: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const R2I = jass.R2I as (value: number) => number;
const CreateTimer = jass.CreateTimer as () => any;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, handlerFunc: (this: void) => void) => void;

const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: number, point: number, relativeFrame: number, relativePoint: number, x: number, y: number) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameBindWidget = japi.DzFrameBindWidget as (
  frame: number,
  unit: any,
  worldX: number,
  worldY: number,
  worldZ: number,
  screenX: number,
  screenY: number,
  fogVisible: boolean,
  unitVisible: boolean,
  deadVisible: boolean
) => void;
const DzDisableUnitPreselectUi = japi.DzDisableUnitPreselectUi as () => void;
const DzSetUnitPreselectUIVisible = japi.DzSetUnitPreselectUIVisible as (unit: any, visible: boolean) => void;
const DzFrameGetUnitHpBar = japi.DzFrameGetUnitHpBar as (unit: any) => number;

const 生命状态 = jass.UNIT_STATE_LIFE;
const 最大生命状态 = jass.UNIT_STATE_MAX_LIFE;
const 魔法状态 = jass.UNIT_STATE_MANA;
const 最大魔法状态 = jass.UNIT_STATE_MAX_MANA;
const 单位死亡类型 = jass.UNIT_TYPE_DEAD;
const 单位英雄类型 = jass.UNIT_TYPE_HERO;
const 单位血条表 = new Map<number, 单位血条绑定>();
const 单位ID列表: number[] = [];
const 英雄死亡隐藏血条ID集合 = new Set<number>();
const 待创建单位队列: any[] = [];
const 待创建单位ID集合 = new Set<number>();
const g = globalThis as any;

let 已初始化 = false;
let tick计数 = 0;
let 待创建单位读取索引 = 0;

function 取原生血条帧(this: void, unit: any): number {
  return DzFrameGetUnitHpBar(unit);
}

function 隐藏单位原生血条(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  DzSetUnitPreselectUIVisible(unit, false);

  const hpBar = 取原生血条帧(unit);
  if (hpBar == null || hpBar === 0) return;
  DzFrameShow(hpBar, false);
}

function 限制01(this: void, value: number): number {
  if (!(value > 0)) return 0;
  if (value > 1) return 1;
  return value;
}

function 单位存活(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (GetUnitTypeId(unit) === 0) return false;
  if (IsUnitType(unit, 单位死亡类型)) return false;
  return GetUnitState(unit, 生命状态) > 0.405;
}

function 单位可注册血条(this: void, unit: any): boolean {
  return 单位存活(unit);
}

function 加入待创建单位(this: void, unit: any): void {
  if (!单位可注册血条(unit)) return;
  const unitId = GetHandleId(unit);
  if (unitId === 0 || 单位血条表.has(unitId) || 待创建单位ID集合.has(unitId)) return;
  隐藏单位原生血条(unit);
  待创建单位ID集合.add(unitId);
  待创建单位队列.push(unit);
}

function 取头顶高度(this: void, unit: any, isHero: boolean): number {
  if (isHero) return 血条尺寸.英雄头顶高度;
  const level = GetUnitLevel(unit);
  if (level >= 30) return 血条尺寸.Boss头顶高度;
  return 血条尺寸.默认头顶高度;
}

function 应显示名字(this: void, isHero: boolean, unit: any): boolean {
  if (isHero) return true;
  return GetUnitLevel(unit) >= 30;
}

function 去除魔兽颜色码(this: void, text: string): string {
  let result = "";
  for (let i = 0; i < text.length; i++) {
    const ch = text.charAt(i);
    if (ch === "|" && i + 1 < text.length) {
      const next = text.charAt(i + 1);
      if (next === "r" || next === "R") {
        i++;
        continue;
      }
      if (next === "c" || next === "C") {
        i += 9;
        continue;
      }
    }
    result += ch;
  }
  return result;
}

function 取血条名字文本(this: void, unit: any): string {
  return "|cffffe6a8" + 去除魔兽颜色码(GetUnitName(unit)) + "|r";
}

function 自动注册单位头顶血条(this: void, unit: any): void {
  if (!单位可注册血条(unit)) return;
  加入待创建单位(unit);
}

function 取生命贴图(this: void, unit: any, lifePct: number): string {
  const localPlayer = GetLocalPlayer();
  if (IsUnitEnemy(unit, localPlayer)) return 血条资源.敌方生命;
  if (lifePct <= 0.60) {
    const index = R2I(lifePct * 20);
    return 血条资源.生命低血渐变[index < 0 ? 0 : index > 12 ? 12 : index];
  }
  return 血条资源.友方生命;
}

function 更新生命贴图(this: void, binding: 单位血条绑定, lifePct: number): void {
  const texture = 取生命贴图(binding.单位, lifePct);
  if (binding.生命贴图缓存 === texture) return;
  binding.生命贴图缓存 = texture;
  DzFrameSetTexture(binding.帧.life, texture, 0);
}

function 更新生命缓降(this: void, binding: 单位血条绑定, lifePct: number): void {
  if (lifePct >= binding.生命缓降比例) {
    binding.生命缓降比例 = lifePct;
  } else {
    const nextPct = binding.生命缓降比例 - 血条尺寸.生命缓降追赶比例;
    binding.生命缓降比例 = nextPct > lifePct ? nextPct : lifePct;
  }

  const lagPct = binding.生命缓降比例 - lifePct;
  if (lagPct > 0.003) {
    DzFrameSetPoint(binding.帧.lifeLag, 0, binding.帧.root, 0, 血条尺寸.内条左偏移 + 血条尺寸.内条宽 * lifePct, 血条尺寸.生命Y);
    DzFrameSetSize(binding.帧.lifeLag, 血条尺寸.内条宽 * lagPct, 血条尺寸.生命高);
    DzFrameShow(binding.帧.lifeLag, true);
  } else {
    DzFrameShow(binding.帧.lifeLag, false);
  }
}

function 取护盾贴图(this: void, shieldType: number): string {
  if (shieldType === 护盾类型.物理) return 血条资源.护盾.物理;
  if (shieldType === 护盾类型.魔法) return 血条资源.护盾.魔法;
  if (shieldType === 护盾类型.强化) return 血条资源.护盾.强化;
  if (shieldType === 护盾类型.火) return 血条资源.护盾.火;
  if (shieldType === 护盾类型.水 || shieldType === 护盾类型.冰) return 血条资源.护盾.水冰;
  if (shieldType === 护盾类型.雷) return 血条资源.护盾.雷;
  if (shieldType === 护盾类型.金 || shieldType === 护盾类型.毒) return 血条资源.护盾.金毒;
  if (shieldType === 护盾类型.木 || shieldType === 护盾类型.风) return 血条资源.护盾.木风;
  if (shieldType === 护盾类型.光) return 血条资源.护盾.光;
  if (shieldType === 护盾类型.暗) return 血条资源.护盾.暗;
  return 血条资源.护盾.通用;
}

interface 护盾显示分段 {
  类型: number;
  数值: number;
}

interface 有效生命显示参数 {
  实际生命比例: number;
  生命显示比例: number;
  护盾值: number;
  显示容量: number;
}

function 计算有效生命显示参数(this: void, life: number, maxLife: number, shield: number): 有效生命显示参数 {
  const safeMaxLife = maxLife > 1 ? maxLife : 1;
  const safeLife = life > 0 ? life : 0;
  const safeShield = shield > 0 ? shield : 0;
  const effectiveLife = safeLife + safeShield;
  const displayCapacity = effectiveLife > safeMaxLife ? effectiveLife : safeMaxLife;
  return {
    实际生命比例: 限制01(safeLife / safeMaxLife),
    生命显示比例: 限制01(safeLife / displayCapacity),
    护盾值: safeShield,
    显示容量: displayCapacity,
  };
}

function 合并护盾显示分段(this: void, unit: any): 护盾显示分段[] {
  const list = 查询单位护盾列表(unit);
  const result: 护盾显示分段[] = [];
  for (let i = 0; i < list.length; i++) {
    const shield = list[i];
    if (shield == null || !shield.显示护盾条 || !(shield.当前值 > 0)) continue;
    let found = false;
    for (let j = 0; j < result.length; j++) {
      if (result[j].类型 === shield.类型) {
        result[j].数值 += shield.当前值;
        found = true;
        break;
      }
    }
    if (!found) result.push({ 类型: shield.类型, 数值: shield.当前值 });
  }
  return result;
}

function 更新护盾分段贴图(this: void, binding: 单位血条绑定, index: number, shieldType: number): void {
  const texture = 取护盾贴图(shieldType);
  if (binding.护盾贴图缓存[index] === texture) return;
  binding.护盾贴图缓存[index] = texture;
  DzFrameSetTexture(binding.帧.shields[index], texture, 0);
}

function 隐藏护盾分段(this: void, binding: 单位血条绑定, startIndex: number): void {
  for (let i = startIndex; i < binding.帧.shields.length; i++) {
    DzFrameShow(binding.帧.shields[i], false);
  }
}

function 刷新护盾分段(this: void, binding: 单位血条绑定, lifeDisplayPct: number, displayCapacity: number, shield: number): void {
  if (!(shield > 0)) {
    隐藏护盾分段(binding, 0);
    return;
  }

  const segments = 合并护盾显示分段(binding.单位);
  if (segments.length <= 0) {
    隐藏护盾分段(binding, 0);
    return;
  }

  const totalVisiblePct = 限制01(shield / displayCapacity);
  const startPct = lifeDisplayPct;
  let usedPct = 0;
  let frameIndex = 0;

  for (let i = 0; i < segments.length && frameIndex < binding.帧.shields.length; i++) {
    let segmentPct = 限制01(segments[i].数值 / displayCapacity);
    if (frameIndex === binding.帧.shields.length - 1) {
      segmentPct = totalVisiblePct - usedPct;
    } else if (usedPct + segmentPct > totalVisiblePct) {
      segmentPct = totalVisiblePct - usedPct;
    }
    if (!(segmentPct > 0)) break;

    const frame = binding.帧.shields[frameIndex];
    更新护盾分段贴图(binding, frameIndex, segments[i].类型);
    DzFrameSetPoint(frame, 0, binding.帧.root, 0, 血条尺寸.内条左偏移 + 血条尺寸.内条宽 * (startPct + usedPct), 血条尺寸.生命Y);
    DzFrameSetSize(frame, 血条尺寸.内条宽 * segmentPct, 血条尺寸.生命高);
    DzFrameShow(frame, true);
    usedPct += segmentPct;
    frameIndex++;
    if (usedPct >= totalVisiblePct) break;
  }

  隐藏护盾分段(binding, frameIndex);
}

function 绑定帧到单位(this: void, 帧: 单位血条帧组, unit: any, height: number): void {
  DzFrameBindWidget(帧.root, unit, 0, 0, height, 0, 0, false, true, false);
}

function 隐藏绑定(this: void, binding: 单位血条绑定): void {
  DzFrameShow(binding.帧.root, false);
}

function 激活绑定显示(this: void, binding: 单位血条绑定): void {
  DzFrameShow(binding.帧.root, true);
  DzFrameShow(binding.帧.name, 应显示名字(binding.是否英雄, binding.单位));
}

function 调整根框尺寸(this: void, binding: 单位血条绑定): void {
  DzFrameSetSize(
    binding.帧.root,
    血条尺寸.根宽,
    binding.最大魔法缓存 > 0 ? 血条尺寸.根高 : 血条尺寸.仅生命根高
  );
}

function 初始化帧内容(this: void, binding: 单位血条绑定): void {
  const 帧 = binding.帧;
  const unit = binding.单位;
  const display = 计算有效生命显示参数(
    GetUnitState(unit, 生命状态),
    binding.最大生命缓存,
    查询单位可显示护盾值(unit)
  );
  binding.生命缓降比例 = display.生命显示比例;
  更新生命贴图(binding, display.实际生命比例);
  DzFrameSetSize(帧.life, 血条尺寸.内条宽 * display.生命显示比例, 血条尺寸.生命高);
  DzFrameSetSize(帧.lifeLag, 0, 血条尺寸.生命高);
  DzFrameSetText(帧.name, 取血条名字文本(unit));
  调整根框尺寸(binding);
  DzFrameShow(帧.mana, binding.最大魔法缓存 > 0);
  DzFrameShow(帧.lifeLag, false);
  刷新护盾分段(binding, display.生命显示比例, display.显示容量, display.护盾值);
  绑定帧到单位(帧, unit, 取头顶高度(unit, binding.是否英雄));
  隐藏单位原生血条(unit);
}

export function 注册单位头顶血条(this: void, unit: any): void {
  if (!启用单位头顶血条) {
    return;
  }
  if (!单位可注册血条(unit)) {
    return;
  }

  const unitId = GetHandleId(unit);
  if (unitId === 0) {
    return;
  }
  if (单位血条表.has(unitId)) {
    return;
  }

  const 帧 = 取单位血条帧组();
  if (帧 == null) {
    return;
  }

  const maxLife = GetUnitStateJapi(unit, 最大生命状态);
  const maxMana = GetUnitStateJapi(unit, 最大魔法状态);
  const isHero = IsUnitType(unit, 单位英雄类型);
  const binding: 单位血条绑定 = {
    单位: unit,
    单位ID: unitId,
    帧,
    最大生命缓存: maxLife > 1 ? maxLife : 1,
    最大魔法缓存: maxMana > 0 ? maxMana : 0,
    是否英雄: isHero,
    生命贴图缓存: "",
    生命缓降比例: 1,
    护盾贴图缓存: [],
  };

  单位血条表.set(unitId, binding);
  单位ID列表.push(unitId);
  隐藏单位原生血条(unit);
  初始化帧内容(binding);
  激活绑定显示(binding);
}

function 注销单位头顶血条(this: void, unitId: number): void {
  const binding = 单位血条表.get(unitId);
  if (binding == null) return;
  英雄死亡隐藏血条ID集合.delete(unitId);
  隐藏绑定(binding);
  回收单位血条帧组(binding.帧);
  单位血条表.delete(unitId);
}

function 刷新生命魔法(this: void, binding: 单位血条绑定): void {
  const unit = binding.单位;
  const life = GetUnitState(unit, 生命状态);
  const maxLifeNow = GetUnitStateJapi(unit, 最大生命状态);
  if (maxLifeNow > 1) binding.最大生命缓存 = maxLifeNow;
  const maxLife = binding.最大生命缓存 > 1 ? binding.最大生命缓存 : 1;
  const display = 计算有效生命显示参数(life, maxLife, 查询单位可显示护盾值(unit));
  const lifeWidth = 血条尺寸.内条宽 * display.生命显示比例;
  更新生命贴图(binding, display.实际生命比例);
  DzFrameSetSize(binding.帧.life, lifeWidth, 血条尺寸.生命高);
  更新生命缓降(binding, display.生命显示比例);

  刷新护盾分段(binding, display.生命显示比例, display.显示容量, display.护盾值);

  const maxManaNow = GetUnitStateJapi(unit, 最大魔法状态);
  if (maxManaNow > 0) binding.最大魔法缓存 = maxManaNow;
  调整根框尺寸(binding);
  if (binding.最大魔法缓存 > 0) {
    const manaPct = 限制01(GetUnitState(unit, 魔法状态) / binding.最大魔法缓存);
    DzFrameSetSize(binding.帧.mana, 血条尺寸.内条宽 * manaPct, 血条尺寸.魔法高);
    DzFrameShow(binding.帧.mana, true);
  } else {
    DzFrameShow(binding.帧.mana, false);
  }
}

function 处理待创建单位(this: void): void {
  let 本轮检查数量 = 0;
  while (
    本轮检查数量 < 血条创建每批数量
    && 待创建单位读取索引 < 待创建单位队列.length
  ) {
    const unit = 待创建单位队列[待创建单位读取索引];
    待创建单位读取索引++;
    本轮检查数量++;

    const unitId = GetHandleId(unit);
    if (unitId !== 0) 待创建单位ID集合.delete(unitId);
    if (!单位可注册血条(unit)) continue;
    if (unitId === 0 || 单位血条表.has(unitId)) continue;
    注册单位头顶血条(unit);
  }

  if (待创建单位读取索引 >= 待创建单位队列.length) {
    待创建单位队列.length = 0;
    待创建单位读取索引 = 0;
  }
}

function 刷新所有单位头顶血条(this: void): void {
  if (!启用单位头顶血条) return;
  tick计数++;
  if (tick计数 < 血条刷新间隔Tick) return;
  tick计数 = 0;

  处理待创建单位();

  let writeIndex = 0;
  for (let i = 0; i < 单位ID列表.length; i++) {
    const unitId = 单位ID列表[i];
    const binding = 单位血条表.get(unitId);
    if (binding == null) continue;
    if (!单位存活(binding.单位)) {
      if (binding.是否英雄 && GetUnitTypeId(binding.单位) !== 0) {
        if (!英雄死亡隐藏血条ID集合.has(unitId)) {
          英雄死亡隐藏血条ID集合.add(unitId);
          隐藏绑定(binding);
        }
        单位ID列表[writeIndex] = unitId;
        writeIndex++;
        continue;
      }
      注销单位头顶血条(unitId);
      continue;
    }
    单位ID列表[writeIndex] = unitId;
    writeIndex++;
    if (英雄死亡隐藏血条ID集合.has(unitId)) {
      英雄死亡隐藏血条ID集合.delete(unitId);
      初始化帧内容(binding);
      激活绑定显示(binding);
    }
    隐藏单位原生血条(binding.单位);
    刷新生命魔法(binding);
  }
  for (let i = 单位ID列表.length - 1; i >= writeIndex; i--) {
    单位ID列表.pop();
  }
}

function on单位进入地图(this: void): void {
  const unit = GetTriggerUnit();
  自动注册单位头顶血条(unit);
}

function 注册已有单位(this: void): void {
  const group = CreateGroup();
  GroupEnumUnitsInRect(group, GetWorldBounds(), null);
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    自动注册单位头顶血条(unit);
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
}

function 注册进入事件(this: void): void {
  const trig = CreateTrigger();
  TriggerRegisterEnterRectSimple(trig, GetWorldBounds());
  TriggerAddAction(trig, on单位进入地图);
}

function 延迟初始化单位头顶血条(this: void): void {
  const timer = GetExpiredTimer();
  if (timer != null && timer !== 0) DestroyTimer(timer);

  DzDisableUnitPreselectUi();
  注册已有单位();
  注册进入事件();
  onTick10ms(刷新所有单位头顶血条);
}

export function initUnitHeadHealthBar(this: void): void {
  if (已初始化) {
    return;
  }
  已初始化 = true;
  if (!启用单位头顶血条) {
    return;
  }

  const timer = CreateTimer();
  TimerStart(timer, 0.05, false, 延迟初始化单位头顶血条);
}

function 全局注册单位头顶血条入口(this: void, unit: any): void {
  注册单位头顶血条(unit);
}

g._registerUnitHeadHealthBar = 全局注册单位头顶血条入口;

export {};
