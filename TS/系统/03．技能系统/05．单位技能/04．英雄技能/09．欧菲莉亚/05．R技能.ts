/** @noSelfInFile */

import { 欧菲莉亚单位技能配置 } from "./00．配置";
import { 播放欧菲莉亚单位音效 } from "./00A．表现工具";
import { 单位存活, 极坐标X, 极坐标Y } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { 沿角度步进直到地形阻挡 } = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进") as {
  沿角度步进直到地形阻挡: (this: void, 参数: any) => { 最终X: number; 最终Y: number; 是否提前停止: boolean };
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, caster: any, abilityId: number) => void) => void;
};
const { 直接复活玩家英雄 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.04．英雄复活系统") as {
  直接复活玩家英雄: (this: void, dyingUnit: any) => boolean;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 读取当前Boss战运行单位 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文") as {
  读取当前Boss战运行单位: (this: void) => any;
};

const 欧菲莉亚单位类型ID = stringToFourCCSafe(欧菲莉亚单位技能配置.单位类型ID);
const 欧菲莉亚R技能ID = stringToFourCCSafe(欧菲莉亚单位技能配置.R技能ID);
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

interface 欧菲莉亚R移动记录 {
  单位: any;
  方向: number;
  步数: number;
  回调ID: number;
}

function 当前处于Boss战(this: void): boolean {
  const tsBoss = 读取当前Boss战运行单位();
  if (tsBoss != null && tsBoss !== 0) return true;
  return YDUserDataGetSafe("string", "Boss战", "状态", "boolean") === true
    || YDUserDataGetSafe("string", "普通Boss战", "状态", "boolean") === true;
}

function 读取欧菲莉亚R战斗Boss(this: void): any {
  const tsBoss = 读取当前Boss战运行单位();
  if (tsBoss != null && tsBoss !== 0) return tsBoss;
  const boss = YDUserDataGetSafe("string", "Boss战", "单位", "unit");
  if (boss != null && boss !== 0) return boss;
  return YDUserDataGetSafe("string", "普通Boss战", "单位", "unit");
}

function 设置复活生命魔法(this: void, hero: any, lifePercent: number, manaPercent: number): void {
  const maxLife = GetUnitStateJapi(hero, jass.UNIT_STATE_MAX_LIFE) as number;
  const maxMana = GetUnitStateJapi(hero, jass.UNIT_STATE_MAX_MANA) as number;
  if (maxLife > 0) jass.SetUnitState(hero, jass.UNIT_STATE_LIFE, maxLife * lifePercent * 0.01);
  if (maxMana > 0) jass.SetUnitState(hero, jass.UNIT_STATE_MANA, maxMana * manaPercent * 0.01);
}

function 结束欧菲莉亚R移动(this: void, record: 欧菲莉亚R移动记录): void {
  if (record.回调ID > 0) removePeriodicCallback(record.回调ID);
  record.回调ID = 0;
  if (record.单位 == null || record.单位 === 0) return;
  StarOther_PanCameraToTimedForPlayer(jass.GetOwningPlayer(record.单位), GetUnitX(record.单位), GetUnitY(record.单位), 0.1);
}

function 欧菲莉亚R移动Tick(this: void, variable?: any): void {
  const record = variable as 欧菲莉亚R移动记录 | undefined;
  if (record == null || !单位存活(record.单位)) {
    if (record != null) 结束欧菲莉亚R移动(record);
    return;
  }
  if (record.步数 >= 欧菲莉亚单位技能配置.R.复活移动步数) {
    结束欧菲莉亚R移动(record);
    return;
  }

  const result = 沿角度步进直到地形阻挡({
    起点X: GetUnitX(record.单位),
    起点Y: GetUnitY(record.单位),
    角度度: record.方向,
    单步距离: 欧菲莉亚单位技能配置.R.复活移动单步距离,
    步数: 1,
    检测单位: record.单位,
  });
  const x = 极坐标X(result.最终X, record.方向, 0);
  const y = 极坐标Y(result.最终Y, record.方向, 0);
  jass.SetUnitX(record.单位, x);
  jass.SetUnitY(record.单位, y);
  record.步数 += 1;
  if (record.步数 >= 欧菲莉亚单位技能配置.R.复活移动步数 || result.是否提前停止) 结束欧菲莉亚R移动(record);
}

function 开始欧菲莉亚R移动(this: void, hero: any): void {
  const record: 欧菲莉亚R移动记录 = {
    单位: hero,
    方向: jass.GetRandomReal(0, 360),
    步数: 0,
    回调ID: 0,
  };
  record.回调ID = addPeriodicCallback(欧菲莉亚单位技能配置.R.复活移动间隔毫秒, 欧菲莉亚R移动Tick, record);
}

function 复活欧菲莉亚R目标(this: void, caster: any, target: any, level: number, bossBattle: boolean, battleBoss: any): void {
  if (target == null || target === 0 || !jass.IsUnitType(target, jass.UNIT_TYPE_DEAD)) return;
  const deadX = GetUnitX(target);
  const deadY = GetUnitY(target);
  创建点特效({
    模型路径: 欧菲莉亚单位技能配置.R.复活特效模型,
    X: deadX,
    Y: deadY,
    持续秒: 欧菲莉亚单位技能配置.R.复活特效持续秒,
  });
  if (!直接复活玩家英雄(target)) return;

  const respawnBoss = bossBattle ? battleBoss : null;
  if (respawnBoss != null && respawnBoss !== 0) {
    jass.SetUnitX(target, GetUnitX(respawnBoss));
    jass.SetUnitY(target, GetUnitY(respawnBoss));
  } else if (!bossBattle) {
    jass.SetUnitX(target, GetUnitX(caster));
    jass.SetUnitY(target, GetUnitY(caster));
  }
  jass.SetUnitFlyHeight(target, jass.GetUnitDefaultFlyHeight(target), 0);
  jass.SetUnitTimeScale(target, 1);
  jass.ShowUnit(target, true);
  jass.CameraClearNoiseForPlayer(jass.GetOwningPlayer(target));
  设置复活生命魔法(
    target,
    欧菲莉亚单位技能配置.R.主动生命基础百分比 + 欧菲莉亚单位技能配置.R.主动生命每级百分比 * level,
    欧菲莉亚单位技能配置.R.主动魔法基础百分比 + 欧菲莉亚单位技能配置.R.主动魔法每级百分比 * level,
  );
  开始欧菲莉亚R移动(target);
}

function 处理欧菲莉亚R(this: void, caster: any, abilityId: number): void {
  if (abilityId !== 欧菲莉亚R技能ID || GetUnitTypeId(caster) !== 欧菲莉亚单位类型ID) return;
  const level = GetUnitAbilityLevel(caster, 欧菲莉亚R技能ID);
  播放欧菲莉亚单位音效(caster, 欧菲莉亚单位技能配置.R.全局音效键);
  const battleBoss = 读取欧菲莉亚R战斗Boss();
  const bossBattle = 当前处于Boss战();
  for (let i = 0; i < 16; i++) {
    const hero = getRegisteredPlayerHero(jass.Player(i));
    if (hero == null || hero === 0) continue;
    复活欧菲莉亚R目标(caster, hero, level, bossBattle, battleBoss);
  }
}

registerSpellEffectListener(处理欧菲莉亚R);

export {};
