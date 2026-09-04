/** @noSelfInFile */
/**
 * 弹道编排工厂（H-03）
 *
 * 在 TS 原生弹幕与既有轨迹之上提供配置型编排，不重新实现弹幕底层：
 * - 轨迹：直线 / 直线到点 / 追踪 / 贝塞尔（平面/XYZ） / 圆弧 / 延迟改向（组合式）。
 * - 发射前预警（点特效）与发射动作（发射特效/音效由调用方在 on发射 回调自理）。
 * - 表现：模型 / 缩放 / 飞行高度 / 附加特效透传。
 * - 回调：on命中 / on到达点 / on结束 / on发射。
 * - 命中策略：单目标去重（默认）或多段命中（每单位最大命中次数 / 最大总命中次数）。
 * - 技能实例 ID 透传（不重复建立伤害归属）。
 * - 中断：编排实例.中断() 或登记进战斗技能实例控制器 / 清理篮子。
 *
 * 底层能力保留（透传或暴露）：
 * - 不可阻挡 / 可攻击摧毁 / 弹幕生命值 / 命中半径 / 追踪转向限制 等弹幕底层标志。
 * - 弹幕单位与弹幕 ID 暴露，供击退 / 击飞等显式位移系统直接操作。
 */

import type { 原生弹幕参数, 原生弹幕实例 } from "../../01．技能函数/01．弹幕/01．TS原生弹幕/00．类型";

const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: 原生弹幕参数) => 原生弹幕实例;
};
const { 设置原生弹幕指定角度飞行 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.06．改向与反弹.00．弹幕改向") as {
  设置原生弹幕指定角度飞行: (this: void, 弹幕ID: number, 角度: number) => boolean;
};
const { 获取原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  获取原生弹幕: (this: void, 弹幕ID: number) => { 当前方向角: number; 当前X: number; 当前Y: number; 已结束: boolean } | undefined;
};
const {
  创建直线定点轨迹,
  创建二阶贝塞尔轨迹,
  创建二阶贝塞尔XYZ轨迹,
  创建圆弧轨迹,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index") as {
  创建直线定点轨迹: (this: void, 起点X: number, 起点Y: number, 终点X: number, 终点Y: number) => any;
  创建二阶贝塞尔轨迹: (this: void, 起点X: number, 起点Y: number, 控制X: number, 控制Y: number, 终点X: number, 终点Y: number) => any;
  创建二阶贝塞尔XYZ轨迹: (
    this: void,
    起点X: number,
    起点Y: number,
    起点Z: number,
    控制X: number,
    控制Y: number,
    控制Z: number,
    终点X: number,
    终点Y: number,
    终点Z: number,
  ) => any;
  创建圆弧轨迹: (this: void, 圆心X: number, 圆心Y: number, 半径: number, 起始角度: number, 结束角度: number) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: { 模型路径: string; X: number; Y: number; Z?: number; 面向角度?: number; 缩放?: number; 持续秒?: number }) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 单位存活, 距离XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  距离XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const BJ_PI = jass.bj_PI as number;

export type 弹道轨迹配置 =
  | { 类型: "直线"; 距离: number }
  | { 类型: "直线到点"; 终点X: number; 终点Y: number; 路径长度?: number }
  | { 类型: "追踪"; 目标: any; 追踪保持秒?: number; 追踪转向速度?: number }
  | {
      类型: "贝塞尔";
      控制X: number;
      控制Y: number;
      终点X: number;
      终点Y: number;
      路径长度?: number;
      /** 高到低 / 低到高：提供 Z 时使用 XYZ 轨迹 */
      起点Z?: number;
      控制Z?: number;
      终点Z?: number;
    }
  | { 类型: "圆弧"; 圆心X: number; 圆心Y: number; 半径: number; 起始角度: number; 结束角度: number }
  | { 类型: "延迟改向"; 延迟秒: number; 新方向角?: number; 保持原有轨迹?: 弹道轨迹配置 };

export interface 弹道预警配置 {
  /** 发射前延迟秒（0 = 立即发射） */
  延迟秒: number;
  /** 预警点特效模型（在发射点创建，持续到发射） */
  模型: string;
  缩放?: number;
  高度?: number;
}

export interface 弹道编排参数 {
  名称: string;
  所有者: any;
  发射X?: number;
  发射Y?: number;
  发射方向角?: number;
  速度: number;
  轨迹: 弹道轨迹配置;

  /** 发射前预警（延迟发射 + 预警特效） */
  预警?: 弹道预警配置;
  /** 发射时回调（发射瞬间触发，可用于发射特效 / 音效 / 动作） */
  on发射?: (this: void, 编排: 弹道编排实例) => void;

  // ---- 表现（透传原生弹幕） ----
  模型?: string;
  缩放?: number;
  飞行高度?: number;
  /** 不传 飞行高度 时可用：弹幕继承发射者当前飞行高度（直线轨迹保持该 Z 飞行；贝塞尔自行传起点Z） */
  发射高度来源?: "发射者";
  /** 主弹道模型着色（配置驱动；原生弹幕 DzSetUnitVertexColor） */
  RGB?: { 红: number; 绿: number; 蓝: number; 透明度?: number };
  附加特效1?: 原生弹幕参数["附加特效1"];
  附加特效2?: 原生弹幕参数["附加特效2"];

  // ---- 底层标志（透传，保留原生能力） ----
  不可阻挡?: boolean;
  可攻击摧毁?: boolean;
  弹幕生命值?: number;
  命中半径?: number;
  生命周期?: number;
  影响目标?: 原生弹幕参数["影响目标"];
  允许命中所有者?: boolean;
  伤害值?: number;
  attack?: boolean;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
  来源类型?: 原生弹幕参数["来源类型"];
  技能ID?: number;
  /** 技能实例 ID 透传（伤害归属，不重复建立） */
  技能实例ID?: number;
  技能标签?: string;
  伤害形态?: 原生弹幕参数["伤害形态"];
  参与技能伤害加成?: boolean;

  // ---- 命中策略 ----
  /** 默认 1（单目标去重）；>1 = 多段命中 */
  每单位最大命中次数?: number;
  最大总命中次数?: number;
  /** 命中即消失（默认 true）；false = 穿透 */
  碰撞消失?: boolean;
  on命中?: (this: void, 目标: any, 弹幕ID: number) => void;
  /** 到达轨迹终点 / 最大距离终点 */
  on到达点?: (this: void, 弹幕ID: number, 原因: "完成" | "距离结束") => void;
  /** 原生弹幕每个驱动 Tick 的回调，透传内部实例与 delta。 */
  onTick?: 原生弹幕参数["onTick"];
  on结束?: (this: void, 原因: string, 弹幕ID: number) => void;

  // ---- 生命周期接入 ----
  /** 战斗技能实例控制器（可选）：登记弹幕销毁，随实例收束 */
  实例控制器?: {
    登记自定义清理(this: void, 名称: string, 清理: (this: void) => void): void;
    登记延迟回调(this: void, id: number): void;
    登记特效?(this: void, 特效: any): void;
    登记限时特效?(this: void, 特效: any, 持续毫秒: number): void;
  };
}

export interface 弹道编排实例 {
  弹幕ID: number;
  /** 弹幕单位（特效载体模式为 null）；供击退 / 击飞等位移系统直接操作 */
  readonly 弹幕单位: any;
  原生弹幕: 原生弹幕实例;
  /** 中断：销毁弹幕并取消未发射的预警（幂等） */
  中断(this: void): void;
  已中断(this: void): boolean;
  已发射(this: void): boolean;
}

function 取绝对值(this: void, v: number): number {
  return v >= 0 ? v : -v;
}

interface 改向配置 {
  延迟秒: number;
  新方向角?: number;
}

/** 轨迹装配：填充弹幕参数的轨迹字段；返回需要发射后定时改向的配置（延迟改向 / 追踪保持） */
function 装配轨迹(this: void, 弹幕参数: 原生弹幕参数, 轨迹: 弹道轨迹配置, 发射X: number, 发射Y: number, 默认高度: number): 改向配置 | null {
  if (轨迹.类型 === "直线") {
    弹幕参数.轨迹类型 = "直线";
    弹幕参数.最大距离 = 轨迹.距离;
    return null;
  }
  if (轨迹.类型 === "直线到点") {
    弹幕参数.轨迹采样器 = 创建直线定点轨迹(发射X, 发射Y, 轨迹.终点X, 轨迹.终点Y);
    弹幕参数.最大距离 = 轨迹.路径长度 ?? 距离XY(发射X, 发射Y, 轨迹.终点X, 轨迹.终点Y);
    return null;
  }
  if (轨迹.类型 === "追踪") {
    弹幕参数.轨迹类型 = "追踪";
    弹幕参数.指定目标 = 轨迹.目标;
    弹幕参数.追踪转向速度 = 轨迹.追踪转向速度;
    if (轨迹.追踪保持秒 != null && 轨迹.追踪保持秒 > 0) {
      return { 延迟秒: 轨迹.追踪保持秒 };
    }
    return null;
  }
  if (轨迹.类型 === "贝塞尔") {
    if (轨迹.起点Z != null || 轨迹.控制Z != null || 轨迹.终点Z != null) {
      弹幕参数.轨迹采样器 = 创建二阶贝塞尔XYZ轨迹(
        发射X,
        发射Y,
        轨迹.起点Z ?? 默认高度,
        轨迹.控制X,
        轨迹.控制Y,
        轨迹.控制Z ?? 0,
        轨迹.终点X,
        轨迹.终点Y,
        轨迹.终点Z ?? 0,
      );
    } else {
      弹幕参数.轨迹采样器 = 创建二阶贝塞尔轨迹(发射X, 发射Y, 轨迹.控制X, 轨迹.控制Y, 轨迹.终点X, 轨迹.终点Y);
    }
    // 二次贝塞尔弧长介于 (控制多边形 × 0.5) 与 (控制多边形) 之间，缺省取 0.85 近似；精度要求高时显式传 路径长度
    const 控制多边形 = 距离XY(发射X, 发射Y, 轨迹.控制X, 轨迹.控制Y) + 距离XY(轨迹.控制X, 轨迹.控制Y, 轨迹.终点X, 轨迹.终点Y);
    弹幕参数.最大距离 = 轨迹.路径长度 ?? 控制多边形 * 0.85;
    return null;
  }
  if (轨迹.类型 === "圆弧") {
    弹幕参数.轨迹采样器 = 创建圆弧轨迹(轨迹.圆心X, 轨迹.圆心Y, 轨迹.半径, 轨迹.起始角度, 轨迹.结束角度);
    const 角度跨度 = 取绝对值(轨迹.结束角度 - 轨迹.起始角度);
    弹幕参数.最大距离 = (角度跨度 * BJ_PI / 180) * 轨迹.半径;
    return null;
  }
  // 延迟改向：先按内层轨迹飞行，到点后改向（外层改向生效，内层改向被覆盖）
  const 内层 = 轨迹.保持原有轨迹 ?? { 类型: "直线", 距离: 900 };
  装配轨迹(弹幕参数, 内层, 发射X, 发射Y, 默认高度);
  return { 延迟秒: 轨迹.延迟秒, 新方向角: 轨迹.新方向角 };
}

export function 发射弹道(this: void, 参数: 弹道编排参数): 弹道编排实例 {
  const 发射X = 参数.发射X ?? GetUnitX(参数.所有者);
  const 发射Y = 参数.发射Y ?? GetUnitY(参数.所有者);
  const 基准方向角 = 参数.发射方向角 ?? GetUnitFacing(参数.所有者);

  let 已中断 = false;
  let 已发射 = false;
  let 弹幕实例: 原生弹幕实例 | null = null;
  let 延迟回调ID = 0;
  let 改向回调ID = 0;
  const 编排 = {} as 弹道编排实例;

  function 中断处理(this: void): void {
    if (已中断) return;
    已中断 = true;
    if (延迟回调ID !== 0) {
      const { removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
        removeDelayedCallback: (this: void, id: number) => void;
      };
      removeDelayedCallback(延迟回调ID);
      延迟回调ID = 0;
    }
    if (改向回调ID !== 0) {
      const { removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
        removeDelayedCallback: (this: void, id: number) => void;
      };
      removeDelayedCallback(改向回调ID);
      改向回调ID = 0;
    }
    if (弹幕实例 != null) {
      弹幕实例.销毁("手动销毁");
      弹幕实例 = null;
    }
  }

  function 执行发射(this: void): void {
    if (已中断 || 已发射) return;
    已发射 = true;

    const 弹幕参数: 原生弹幕参数 = {
      所有者: 参数.所有者,
      X: 发射X,
      Y: 发射Y,
      方向角: 基准方向角,
      速度: 参数.速度,
      命中半径: 参数.命中半径,
      生命周期: 参数.生命周期,
      影响目标: 参数.影响目标,
      允许命中所有者: 参数.允许命中所有者,
      伤害值: 参数.伤害值,
      attack: 参数.attack,
      攻击类型: 参数.攻击类型,
      伤害类型: 参数.伤害类型,
      武器类型: 参数.武器类型,
      来源类型: 参数.来源类型,
      技能ID: 参数.技能ID,
      技能实例ID: 参数.技能实例ID,
      技能标签: 参数.技能标签,
      伤害形态: 参数.伤害形态,
      参与技能伤害加成: 参数.参与技能伤害加成,
      不可阻挡: 参数.不可阻挡,
      可攻击摧毁: 参数.可攻击摧毁,
      弹幕生命值: 参数.弹幕生命值,
      模型: 参数.模型,
      缩放: 参数.缩放,
      飞行高度: 参数.飞行高度,
      发射高度来源: 参数.发射高度来源,
      RGB: 参数.RGB,
      附加特效1: 参数.附加特效1,
      附加特效2: 参数.附加特效2,
      每单位最大命中次数: 参数.每单位最大命中次数 ?? 1,
      最大总命中次数: 参数.最大总命中次数,
      碰撞消失: 参数.碰撞消失 ?? true,
      on命中: 参数.on命中,
      on到达目标点: 参数.on到达点,
      onTick: 参数.onTick,
      on结束: 参数.on结束,
    };

    // ---- 轨迹装配 ----
    const 改向配置 = 装配轨迹(弹幕参数, 参数.轨迹, 发射X, 发射Y, 参数.飞行高度 ?? 0);

    弹幕实例 = 创建原生弹幕(弹幕参数);
    编排.弹幕ID = 弹幕实例.弹幕ID;
    编排.原生弹幕 = 弹幕实例;
    (编排 as { 弹幕单位: any }).弹幕单位 = 弹幕实例.弹幕单位;

    // 延迟改向 / 追踪保持：发射后定时锁定当前方向或改向
    if (改向配置 != null && 改向配置.延迟秒 > 0) {
      改向回调ID = addDelayedCallback((改向配置.延迟秒 * 1000 + 0.5) | 0, function 弹道延迟改向(this: void): void {
        改向回调ID = 0;
        if (已中断 || 弹幕实例 == null) return;
        const 内部 = 获取原生弹幕(编排.弹幕ID);
        if (内部 == null || 内部.已结束) return;
        const 目标角 = 改向配置.新方向角 ?? 内部.当前方向角;
        设置原生弹幕指定角度飞行(编排.弹幕ID, 目标角);
      });
      if (参数.实例控制器 != null) 参数.实例控制器.登记延迟回调(改向回调ID);
    }

    // 延迟改向的内层轨迹在改向前保持原有飞行（直线继续）
    if (参数.on发射 != null) 参数.on发射(编排);
  }

  编排.中断 = 中断处理;
  编排.已中断 = function 已中断查询(this: void): boolean {
    return 已中断;
  };
  编排.已发射 = function 已发射查询(this: void): boolean {
    return 已发射;
  };

  if (参数.实例控制器 != null) {
    参数.实例控制器.登记自定义清理(参数.名称 + "-弹道中断", 中断处理);
  }

  // ---- 预警 + 延迟发射 / 立即发射 ----
  if (参数.预警 != null && 参数.预警.延迟秒 > 0) {
    const 预警特效 = 创建点特效({
      模型路径: 参数.预警.模型,
      X: 发射X,
      Y: 发射Y,
      Z: 参数.预警.高度 ?? 0,
      缩放: 参数.预警.缩放 ?? 1,
      持续秒: 参数.实例控制器 == null ? 参数.预警.延迟秒 : undefined,
    });
    if (参数.实例控制器 != null && 预警特效 != null && 预警特效 !== 0) {
      if (参数.实例控制器.登记限时特效 != null) {
        参数.实例控制器.登记限时特效(预警特效, 参数.预警.延迟秒 * 1000);
      } else if (参数.实例控制器.登记特效 != null) {
        参数.实例控制器.登记特效(预警特效);
      }
    }
    延迟回调ID = addDelayedCallback((参数.预警.延迟秒 * 1000 + 0.5) | 0, function 弹道延迟发射(this: void): void {
      延迟回调ID = 0;
      执行发射();
    });
    if (参数.实例控制器 != null) 参数.实例控制器.登记延迟回调(延迟回调ID);
  } else {
    执行发射();
  }

  return 编排;
}

/** 读取弹道当前世界坐标（未发射/已结束返回起点兜底） */
export function 获取弹道当前位置(this: void, 弹道: any): { X: number; Y: number } {
  if (弹道 == null || 弹道.弹幕ID == null) return { X: 0, Y: 0 };
  const 内部 = 获取原生弹幕(弹道.弹幕ID);
  if (内部 == null || 内部.已结束) return { X: 0, Y: 0 };
  return { X: 内部.当前X, Y: 内部.当前Y };
}
