/** @noSelfInFile */
/**
 * TS 侧对旧 JASS 弹幕系统（DMXT）的便捷封装。
 * 这里只负责给“现成单位”写入弹幕属性、加入弹幕组、启动触发器；
 * 不负责创建弹幕单位本身。
 * 配套底层 JASS 源文件：
 * `JASS/jass复制粘贴/jass的弹幕系统参考.j`
 *
 * 后续 AI / 调用者使用约定：
 * 1. 先自己创建好弹幕单位，并设置好朝向；本文件不负责 CreateUnit。
 * 2. 再调用 `注册单位到弹幕系统` 或 `快捷注册直线弹幕` 把该单位登记进旧 JASS 弹幕系统。
 * 3. 如果想做“冲击波命中半径 200 的敌人，造成固定 300 伤害”，优先这样配：
 *    - `伤害半径: 200`
 *    - `伤害绑定: 300`
 *    - `碰撞消失: true` 表示命中后消失；`false` 表示继续飞行并扫到沿途单位
 * 4. 如果想做“智力×3”这类动态伤害，则改传 `伤害系数: 3`，让旧 JASS 弹幕系统按主人属性倍率结算。
 * 5. `注册冲击波弹幕` 支持两种写法：
 *    - `300`：按固定伤害处理，自动写入 `伤害绑定`
 *    - `{ 伤害系数: 3 }`：按动态伤害处理，自动写入 `伤害系数`
 * 6. `飞行速度` 不是“每秒真实位移”。底层 JASS 会先把它乘 `0.66`，再按 `0.04` 秒循环推进一次。
 *    - 实际每秒位移 = `飞行速度 × 0.66 ÷ 0.04 = 飞行速度 × 16.5`
 *    - 例如想做“1 秒飞 1000 码”的弹幕，`飞行速度` 应设为约 `60.6`
 *    - 实际配置可取 `60` 或 `61`
 * 7. `伤害系数` 是给主人属性倍率用的；要固定伤害时，主要看 `伤害绑定`。
 * 8. `伤害类型` 只是便捷写法，会自动回填到旧 JASS 识别的布尔字段。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as any;

import { YDUserDataGet, YDUserDataSet } from "../../../../../lib/扩展函数/YDWE函数/01．YDUserData兼容";
import { stringToFourCC } from "../../../../../lib/扩展函数/封装函数/01．通用工具/01．FourCC转换";

type 伤害类型 =
  | "普通"
  | "强化"
  | "攻击特效"
  | "金魔法"
  | "木魔法"
  | "水魔法"
  | "火魔法"
  | "土魔法"
  | "暗魔法";

export interface 弹幕系统参数 {
  主人: any;
  飞行速度: number;
  伤害半径: number;
  伤害系数: number;

  模型?: string;
  缩放?: number;
  缩放X?: number;
  缩放Y?: number;
  缩放Z?: number;
  飞行高度?: number;
  禁用碰撞?: boolean;
  生命周期?: number;
  生命周期Buff?: number | string;

  最远飞行距离?: number;
  伤害绑定?: number;
  指定敌人?: any;
  命中效果?: boolean;
  碰撞消失?: boolean;
  攻击特效?: boolean;
  强化伤害?: boolean;
  强化伤害系数?: number;

  弹射?: boolean;
  随机弹射?: boolean;
  弹射角度?: number;
  弹射次数?: number;
  弹射次数上限?: number;
  弹射衰减?: number;

  控制效果?: number;

  金魔法伤害?: boolean;
  木魔法伤害?: boolean;
  水魔法伤害?: boolean;
  火魔法伤害?: boolean;
  土魔法伤害?: boolean;
  暗魔法伤害?: boolean;

  伤害类型?: 伤害类型;
}

export type 冲击波伤害配置 =
  | number
  | {
      固定伤害?: number;
      伤害系数?: number;
    };

function 获取弹幕系统触发器(): any {
  return (jglobals as any).gg_trg_____________DMXT ?? (globalThis as any).gg_trg_____________DMXT ?? null;
}

function 获取弹幕系统单位组(): any {
  return YDUserDataGet("string", "弹幕系统", "单位组", "group");
}

function 写入布尔属性(单位: any, 属性名: string, 值: boolean | undefined): void {
  if (值 === undefined) return;
  YDUserDataSet("unit", 单位, 属性名, "boolean", 值);
}

function 写入实数属性(单位: any, 属性名: string, 值: number | undefined): void {
  if (值 === undefined) return;
  YDUserDataSet("unit", 单位, 属性名, "real", 值);
}

function 写入单位属性(单位: any, 属性名: string, 值: any): void {
  if (值 == null || 值 === 0) return;
  YDUserDataSet("unit", 单位, 属性名, "unit", 值);
}

function 归一化生命周期Buff(buff: number | string | undefined): number {
  if (typeof buff === "number") return buff;
  if (typeof buff === "string" && buff.length === 4) return stringToFourCC(buff);
  return stringToFourCC("BHwe");
}

function 按伤害类型回填布尔标记(参数: 弹幕系统参数): void {
  if (参数.伤害类型 == null) return;

  if (参数.伤害类型 === "攻击特效") {
    参数.攻击特效 = true;
    return;
  }
  if (参数.伤害类型 === "强化") {
    参数.强化伤害 = true;
    return;
  }
  if (参数.伤害类型 === "金魔法") {
    参数.金魔法伤害 = true;
    return;
  }
  if (参数.伤害类型 === "木魔法") {
    参数.木魔法伤害 = true;
    return;
  }
  if (参数.伤害类型 === "水魔法") {
    参数.水魔法伤害 = true;
    return;
  }
  if (参数.伤害类型 === "火魔法") {
    参数.火魔法伤害 = true;
    return;
  }
  if (参数.伤害类型 === "土魔法") {
    参数.土魔法伤害 = true;
    return;
  }
  if (参数.伤害类型 === "暗魔法") {
    参数.暗魔法伤害 = true;
  }
}

function 设置弹幕外观(弹幕单位: any, 参数: 弹幕系统参数): void {
  if (参数.模型 && 参数.模型 !== "") {
    japi.DzSetUnitModel(弹幕单位, 参数.模型);
  }

  const 缩放X = 参数.缩放X ?? 参数.缩放 ?? undefined;
  const 缩放Y = 参数.缩放Y ?? 参数.缩放 ?? undefined;
  const 缩放Z = 参数.缩放Z ?? 参数.缩放 ?? undefined;
  if (缩放X !== undefined || 缩放Y !== undefined || 缩放Z !== undefined) {
    jass.SetUnitScale(弹幕单位, 缩放X ?? 1.0, 缩放Y ?? 1.0, 缩放Z ?? 1.0);
  }

  if (参数.飞行高度 !== undefined) {
    jass.SetUnitFlyHeight(弹幕单位, 参数.飞行高度, 0.0);
  }

  if (参数.禁用碰撞 !== false) {
    jass.SetUnitPathing(弹幕单位, false);
  }

  if (参数.生命周期 !== undefined && 参数.生命周期 > 0) {
    jass.UnitApplyTimedLife(弹幕单位, 归一化生命周期Buff(参数.生命周期Buff), 参数.生命周期);
  }
}

function 设置弹幕系统属性(弹幕单位: any, 参数: 弹幕系统参数): void {
  按伤害类型回填布尔标记(参数);

  YDUserDataSet("unit", 弹幕单位, "主人", "unit", 参数.主人);
  YDUserDataSet("unit", 弹幕单位, "飞行速度", "real", 参数.飞行速度);
  YDUserDataSet("unit", 弹幕单位, "伤害半径", "real", 参数.伤害半径);
  YDUserDataSet("unit", 弹幕单位, "伤害系数", "real", 参数.伤害系数);

  写入实数属性(弹幕单位, "最远飞行距离", 参数.最远飞行距离);
  写入实数属性(弹幕单位, "伤害绑定", 参数.伤害绑定);
  写入实数属性(弹幕单位, "强化伤害系数", 参数.强化伤害系数);
  写入实数属性(弹幕单位, "弹射角度", 参数.弹射角度);
  写入实数属性(弹幕单位, "弹射次数", 参数.弹射次数);
  写入实数属性(弹幕单位, "弹射次数上限", 参数.弹射次数上限);
  写入实数属性(弹幕单位, "弹射衰减", 参数.弹射衰减);
  写入实数属性(弹幕单位, "控制效果", 参数.控制效果);

  写入布尔属性(弹幕单位, "命中效果", 参数.命中效果);
  写入布尔属性(弹幕单位, "碰撞消失", 参数.碰撞消失);
  写入布尔属性(弹幕单位, "攻击效果", 参数.攻击特效);
  写入布尔属性(弹幕单位, "强化伤害", 参数.强化伤害);
  写入布尔属性(弹幕单位, "弹射", 参数.弹射);
  写入布尔属性(弹幕单位, "随机弹射", 参数.随机弹射);

  写入布尔属性(弹幕单位, "金魔法伤害", 参数.金魔法伤害);
  写入布尔属性(弹幕单位, "木魔法伤害", 参数.木魔法伤害);
  写入布尔属性(弹幕单位, "水魔法伤害", 参数.水魔法伤害);
  写入布尔属性(弹幕单位, "火魔法伤害", 参数.火魔法伤害);
  写入布尔属性(弹幕单位, "土魔法伤害", 参数.土魔法伤害);
  写入布尔属性(弹幕单位, "暗魔法伤害", 参数.暗魔法伤害);

  写入单位属性(弹幕单位, "指定敌人", 参数.指定敌人);
}

function 启动弹幕系统触发器(): void {
  const trig = 获取弹幕系统触发器();
  if (trig == null) return;
  if (!jass.IsTriggerEnabled(trig)) {
    jass.EnableTrigger(trig);
  }
}

export function 注册单位到弹幕系统(弹幕单位: any, 参数: 弹幕系统参数): any {
  if (弹幕单位 == null || 弹幕单位 === 0) return null;
  if (参数 == null || 参数.主人 == null || 参数.主人 === 0) return null;

  设置弹幕外观(弹幕单位, 参数);
  设置弹幕系统属性(弹幕单位, 参数);

  const 单位组 = 获取弹幕系统单位组();
  if (单位组 != null) {
    jass.GroupAddUnit(单位组, 弹幕单位);
  }

  启动弹幕系统触发器();
  return 弹幕单位;
}

export function 快捷注册直线弹幕(
  弹幕单位: any,
  主人: any,
  飞行速度: number,
  伤害半径: number,
  伤害系数: number,
  额外参数?: Omit<弹幕系统参数, "主人" | "飞行速度" | "伤害半径" | "伤害系数">
): any {
  return 注册单位到弹幕系统(弹幕单位, {
    主人,
    飞行速度,
    伤害半径,
    伤害系数,
    ...(额外参数 ?? {}),
  });
}

function 解析冲击波伤害配置(伤害配置: 冲击波伤害配置): Partial<Pick<弹幕系统参数, "伤害绑定" | "伤害系数">> {
  if (typeof 伤害配置 === "number") {
    return { 伤害绑定: 伤害配置 };
  }
  if (伤害配置.固定伤害 !== undefined) {
    return { 伤害绑定: 伤害配置.固定伤害 };
  }
  if (伤害配置.伤害系数 !== undefined) {
    return { 伤害系数: 伤害配置.伤害系数 };
  }
  return {};
}

export function 注册冲击波弹幕(
  弹幕单位: any,
  主人: any,
  伤害配置: 冲击波伤害配置,
  半径: number,
  额外参数?: Omit<弹幕系统参数, "主人" | "伤害半径" | "伤害绑定" | "伤害系数">
): any {
  const 伤害参数 = 解析冲击波伤害配置(伤害配置);
  return 注册单位到弹幕系统(弹幕单位, {
    主人,
    飞行速度: 额外参数?.飞行速度 ?? 0,
    伤害半径: 半径,
    ...(额外参数 ?? {}),
    伤害系数: 0,
    ...伤害参数,
  });
}

export {};
