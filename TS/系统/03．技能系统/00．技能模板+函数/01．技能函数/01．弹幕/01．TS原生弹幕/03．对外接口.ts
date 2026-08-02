/** @noSelfInFile */
/**
 * TS 原生弹幕 - 对外接口
 */

import type { 原生弹幕参数, 原生弹幕实例, 原生弹幕结束原因, 原生弹幕内部实例, 原生弹幕附加特效参数 } from "./00．类型";
import {
  CreateUnit,
  默认弹幕单位类型,
  DzGetColor,
  DzSetEffectAnimation,
  DzPlayEffectAnimation,
  DzSetEffectVertexColor,
  DzSetEffectPos,
  EXEffectMatScale,
  DzSetUnitModel,
  EC_CreateEffect,
  GetOwningPlayer,
  GetUnitFacing,
  GetUnitX,
  GetUnitY,
  Player,
  SetUnitFlyHeight,
  SetUnitPathing,
  SetUnitPosition,
  SetUnitScale,
  UNIT_TYPE_ANCIENT,
  UNIT_TYPE_MECHANICAL,
  UNIT_TYPE_TAUREN,
  UnitAddAbility,
  UnitAddType,
  UnitRemoveAbility,
  UnitRemoveType,
  蝗虫技能ID,
  CosBJ,
  SinBJ,
  取句柄ID,
} from "./01．共享";
import { 分配原生弹幕ID, 获取原生弹幕实例, 注册原生弹幕实例, 单位到原生弹幕ID } from "./02．注册表";
import { 触发原生弹幕STES事件 } from "./02．事件/index";
import { 创建弹幕命中规则状态, 重置弹幕命中规则状态 } from "./03．命中/index";
import { 结束原生弹幕实例, 确保原生弹幕驱动 } from "./04．驱动/index";
import { 确保弹幕死亡事件监听 } from "./05．死亡事件/index";

const { 按英雄技能距离修正上下文修正距离 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index") as {
  按英雄技能距离修正上下文修正距离: (this: void, 基础距离: number, 上下文: any, 默认用途?: string) => number;
};
function 解析弹幕玩家(this: void, 参数: 原生弹幕参数): any {
  if (参数.所属玩家 != null && 参数.所属玩家 !== 0) return 参数.所属玩家;
  if (参数.所有者 != null && 参数.所有者 !== 0) return GetOwningPlayer(参数.所有者);
  return Player(15);
}

function 解析弹幕X(this: void, 参数: 原生弹幕参数): number {
  if (参数.X != null) return 参数.X;
  if (参数.所有者 != null && 参数.所有者 !== 0) return GetUnitX(参数.所有者);
  return 0;
}

function 解析弹幕Y(this: void, 参数: 原生弹幕参数): number {
  if (参数.Y != null) return 参数.Y;
  if (参数.所有者 != null && 参数.所有者 !== 0) return GetUnitY(参数.所有者);
  return 0;
}

function 解析弹幕方向(this: void, 参数: 原生弹幕参数): number {
  if (参数.方向角 != null) return 参数.方向角;
  if (参数.所有者 != null && 参数.所有者 !== 0) return GetUnitFacing(参数.所有者);
  return 0;
}

function 创建或取得弹幕单位(this: void, 参数: 原生弹幕参数, x: number, y: number, face: number): any {
  if (参数.载体模式 === "特效") return null;
  if (参数.弹幕单位 != null && 参数.弹幕单位 !== 0) return 参数.弹幕单位;
  return CreateUnit(解析弹幕玩家(参数), 参数.弹幕单位类型 ?? 默认弹幕单位类型, x, y, face);
}

function 激活非牛头人弹幕可选取(this: void, 实例: 原生弹幕内部实例): void {
  if (实例.弹幕单位 == null || 实例.弹幕单位 === 0) return;
  if (实例.参数.不可阻挡 === true) return;
  const face = 实例.当前方向角;
  const x = 实例.当前X + CosBJ(face);
  const y = 实例.当前Y + SinBJ(face);
  // 非牛头人弹幕创建后 SetUnitPosition 一次，让蝗虫马甲进入可被代码选取状态；后续移动仍用 SetUnitX/Y。
  SetUnitPosition(实例.弹幕单位, x, y);
  实例.当前X = x;
  实例.当前Y = y;
}

function 弹幕可被攻击摧毁(this: void, 参数: 原生弹幕参数): boolean {
  return 参数.可被攻击摧毁 === true || 参数.可被摧毁 === true;
}

function 限制弹幕特效颜色字节(this: void, value: number): number {
  if (value < 0) return 0;
  if (value > 255) return 255;
  return value;
}

function 设置弹幕附加特效颜色(this: void, effect: any, 参数: 原生弹幕附加特效参数): void {
  if (参数.红 == null || 参数.绿 == null || 参数.蓝 == null) return;
  DzSetEffectVertexColor(effect, DzGetColor(
    限制弹幕特效颜色字节(参数.透明度 ?? 255),
    限制弹幕特效颜色字节(参数.红),
    限制弹幕特效颜色字节(参数.绿),
    限制弹幕特效颜色字节(参数.蓝),
  ));
}

function 初始化弹幕单位类别(this: void, 参数: 原生弹幕参数, 弹幕单位: any): void {
  // 物编默认已设置 ancient,mechanical,ward；这里为外部传入的弹幕单位补齐运行时分类。
  UnitAddType(弹幕单位, UNIT_TYPE_ANCIENT);
  UnitAddType(弹幕单位, UNIT_TYPE_MECHANICAL);

  if (参数.不可阻挡 === true) {
    UnitAddType(弹幕单位, UNIT_TYPE_TAUREN);
  } else {
    UnitRemoveType(弹幕单位, UNIT_TYPE_TAUREN);
  }

  if (弹幕可被攻击摧毁(参数)) {
    UnitRemoveAbility(弹幕单位, 蝗虫技能ID);
  } else {
    UnitAddAbility(弹幕单位, 蝗虫技能ID);
  }
}

function 创建弹幕附加特效(
  this: void,
  参数: 原生弹幕参数,
  x: number,
  y: number,
  z: number,
  face: number,
  特效参数?: 原生弹幕附加特效参数,
): any {
  if (特效参数 == null || 特效参数.模型 === "") return null;
  const scale = 特效参数.缩放 ?? (特效参数.跟随主弹幕参数 === true ? (参数.缩放 ?? 1) : 1);
  const effect = EC_CreateEffect(
    特效参数.模型,
    x,
    y,
    z,
    face + (特效参数.朝向角偏移 ?? 0),
    scale,
    特效参数.动画速度 ?? 1,
    -1,
  );
  if (effect == null || effect === 0) return null;
  DzSetEffectPos(effect, x, y, z);
  if (特效参数.动画索引 != null) {
    DzSetEffectAnimation?.(effect, 特效参数.动画索引, 0);
  }
  if (特效参数.动画名称 != null && DzPlayEffectAnimation != null) {
    DzPlayEffectAnimation(effect, 特效参数.动画名称, 特效参数.动画链接 ?? "");
  }
  if (特效参数.缩放X != null || 特效参数.缩放Y != null || 特效参数.缩放Z != null) {
    const 统一缩放 = scale;
    EXEffectMatScale(
      effect,
      特效参数.缩放X ?? 统一缩放,
      特效参数.缩放Y ?? 统一缩放,
      特效参数.缩放Z ?? 统一缩放,
    );
  }
  设置弹幕附加特效颜色(effect, 特效参数);
  return effect;
}

function 初始化弹幕表现(this: void, 参数: 原生弹幕参数, 弹幕单位: any, x: number, y: number, z: number, face: number): [any, any] {
  if (弹幕单位 != null && 弹幕单位 !== 0) {
    初始化弹幕单位类别(参数, 弹幕单位);

    if (参数.模型 != null && 参数.模型 !== "" && DzSetUnitModel != null) {
      DzSetUnitModel(弹幕单位, 参数.模型);
    }

    const 缩放 = 参数.缩放 ?? 1;
    if (缩放 > 0) {
      SetUnitScale(弹幕单位, 缩放, 缩放, 缩放);
    }
    if (参数.飞行高度 != null) {
      SetUnitFlyHeight(弹幕单位, 参数.飞行高度, 0);
    }
    if (参数.禁用碰撞 !== false) {
      SetUnitPathing(弹幕单位, false);
    }
  }
  const legacyEffect = 参数.附着特效模型 != null && 参数.附着特效模型 !== ""
    ? { 模型: 参数.附着特效模型, 附着点: 参数.附着点 }
    : undefined;
  return [
    创建弹幕附加特效(参数, x, y, z, face, 参数.附加特效1 ?? legacyEffect),
    创建弹幕附加特效(参数, x, y, z, face, 参数.附加特效2),
  ];
}

function 归一化弹幕距离参数(this: void, 参数: 原生弹幕参数): 原生弹幕参数 {
  if (参数.最大距离 == null || 参数.最大距离 <= 0) return 参数;
  return {
    ...参数,
    最大距离: 按英雄技能距离修正上下文修正距离(参数.最大距离, 参数.英雄技能距离修正, "弹幕飞行距离"),
  };
}

function 创建弹幕实例对象(this: void, 实例: 原生弹幕内部实例): 原生弹幕实例 {
  return {
    弹幕ID: 实例.id,
    弹幕单位: 实例.弹幕单位,
    弹幕特效1: 实例.附加特效1,
    弹幕特效2: 实例.附加特效2,
    获取剩余生命: function 获取剩余生命(this: void): number {
      const 当前 = 获取原生弹幕实例(实例.id);
      return 当前 != null ? 当前.剩余生命 : 0;
    },
    造成阻挡伤害: function 造成阻挡伤害(this: void, 伤害值: number, 来源单位?: any): boolean {
      return 造成原生弹幕阻挡伤害(实例.id, 伤害值, 来源单位);
    },
    销毁: function 销毁(this: void, 原因?: 原生弹幕结束原因): void {
      销毁原生弹幕(实例.id, 原因 ?? "手动销毁");
    },
  };
}

export function 创建原生弹幕(this: void, 参数: 原生弹幕参数): 原生弹幕实例 {
  参数 = 归一化弹幕距离参数(参数);
  const x = 解析弹幕X(参数);
  const y = 解析弹幕Y(参数);
  const face = 解析弹幕方向(参数);
  const z = 参数.飞行高度 ?? 0;
  const 弹幕单位 = 创建或取得弹幕单位(参数, x, y, face);
  const id = 分配原生弹幕ID();

  const 实例: 原生弹幕内部实例 = {
    id,
    参数,
    弹幕单位,
    当前X: x,
    当前Y: y,
    当前Z: z,
    当前方向角: face,
    当前速度: 参数.速度,
    当前伤害值: 参数.伤害值 ?? 0,
    已飞行距离: 0,
    已运行时间: 0,
    剩余生命: 参数.弹幕生命值 ?? 0,
    弹射次数: 0,
    已结束: false,
    附加特效1: null,
    附加特效2: null,
    命中规则状态: null,
  };

  const 附加特效 = 初始化弹幕表现(参数, 弹幕单位, x, y, z, face);
  实例.附加特效1 = 附加特效[0];
  实例.附加特效2 = 附加特效[1];
  激活非牛头人弹幕可选取(实例);
  实例.命中规则状态 = 创建弹幕命中规则状态(实例);
  注册原生弹幕实例(实例, 取句柄ID(弹幕单位));
  if (弹幕单位 != null && 弹幕单位 !== 0) {
    确保弹幕死亡事件监听();
  }
  确保原生弹幕驱动();
  return 创建弹幕实例对象(实例);
}

export function 销毁原生弹幕(this: void, 弹幕ID: number, 原因: 原生弹幕结束原因 = "手动销毁"): void {
  const 实例 = 获取原生弹幕实例(弹幕ID);
  if (实例 == null) return;
  结束原生弹幕实例(实例, 原因);
}

export function 获取原生弹幕(this: void, 弹幕ID: number): 原生弹幕内部实例 | undefined {
  return 获取原生弹幕实例(弹幕ID);
}

export function 获取单位原生弹幕ID(this: void, 单位: any): number {
  const id = 单位到原生弹幕ID[取句柄ID(单位)];
  return id ?? 0;
}

export function 重置原生弹幕命中记录(this: void, 弹幕ID: number): boolean {
  const 实例 = 获取原生弹幕实例(弹幕ID);
  if (实例 == null || 实例.已结束) return false;
  重置弹幕命中规则状态(实例);
  return true;
}

export function 造成原生弹幕阻挡伤害(this: void, 弹幕ID: number, 伤害值: number, 来源单位?: any): boolean {
  const 实例 = 获取原生弹幕实例(弹幕ID);
  if (实例 == null || 实例.已结束) return false;
  if (实例.弹幕单位 == null || 实例.弹幕单位 === 0) return false;
  if (伤害值 <= 0) return false;
  if (实例.参数.不可阻挡 === true) return false;

  实例.剩余生命 -= 伤害值;
  const 回调 = 实例.参数.on阻挡;
  if (回调 != null) {
    回调(来源单位 ?? null, 伤害值, 弹幕ID);
  }
  触发原生弹幕STES事件(实例.参数.STES?.阻挡事件名, 实例, {
    来源单位,
    伤害值,
  });

  if (实例.参数.被阻挡时销毁 === true || (实例.参数.弹幕生命值 != null && 实例.剩余生命 <= 0)) {
    结束原生弹幕实例(实例, "被阻挡");
    return true;
  }
  return false;
}

export function 按单位造成原生弹幕阻挡伤害(this: void, 弹幕单位: any, 伤害值: number, 来源单位?: any): boolean {
  const id = 获取单位原生弹幕ID(弹幕单位);
  if (id <= 0) return false;
  return 造成原生弹幕阻挡伤害(id, 伤害值, 来源单位);
}
