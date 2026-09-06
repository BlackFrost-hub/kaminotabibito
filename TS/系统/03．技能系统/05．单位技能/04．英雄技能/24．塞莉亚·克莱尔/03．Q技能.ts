/** @noSelfInFile */
/**
 * 塞莉亚·克莱尔 - Q：棱晶魔弹（A3）
 *
 * - 单位目标壳同时保存合法目标与目标点快照；追踪带保持秒，目标失效后按最后方向直飞。
 * - 命中结算基础伤害；真实终点（命中点或到达点）创建棱晶节点（先到先建，仅一次）。
 * - 折射：穿越自身棱晶节点触发半径时，按当前速度方向与节点径向计算镜像折射方向
 *   （纯向量运算，不依赖模型朝向），从节点位置追加一枚折射弹，每次 Q 最多一次。
 * - 棱晶+结界连接存在 → 追加一次穿透魔弹；棱晶+锚定连接存在 → 对阵内最近敌人发射短追踪追迹弹；
 *   两类追加均归本次 Q 实例且各最多一次。动作分槽未确认：本技能暂不接动作（缺口见报告）。
 */

import { 塞莉亚克莱尔技能配置, 塞莉亚克莱尔Q配置, 塞莉亚克莱尔表现配置, 塞莉亚音效配置 } from "./00．配置";
import type { 战斗技能实例控制器 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";
import {
  授予塞莉亚演算窗口,
  创建塞莉亚节点,
  登记塞莉亚技能清理,
  查询塞莉亚节点,
  查询塞莉亚有效连接,
} from "./02．被动效果";
import { 查询塞莉亚锚定区域, 取塞莉亚锚定区域内最近敌人 } from "./05．E技能";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { fourCCToStringSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  fourCCToStringSafe: (this: void, fourcc: number) => string;
};
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const SquareRoot = jass.SquareRoot as (this: void, v: number) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => 战斗技能实例控制器;
};
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const {
  读取单位攻击力,
  单位存活,
  两点角度,
  距离平方XY,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = 塞莉亚克莱尔技能配置.单位类型ID;
const Q技能类型ID = stringToFourCCSafe(塞莉亚克莱尔技能配置.Q.技能ID) as number;

//=============================================================================
// 结算与追加分支
//=============================================================================

function 造成Q伤害(
  this: void,
  施法者: any,
  目标: any,
  伤害值: number,
  技能实例ID: number | undefined,
  标签: string,
  形态: "单体" | "AOE",
): boolean {
  return 造成技能伤害({
    来源: 施法者,
    目标,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: Q技能类型ID,
    技能实例ID,
    标签,
    伤害形态: 形态,
    参与技能伤害加成: true,
  });
}

/** 真实终点创建棱晶节点：命中与到达两路径共用，只建一次。 */
function 尝试建立终点节点(this: void, 施法者: any, 数据: any, X: number, Y: number): void {
  if (数据.已建节点) return;
  数据.已建节点 = true;
  创建塞莉亚节点(施法者, "棱晶", X, Y, 数据.技能实例ID);
}

function 处理Q命中(this: void, 施法者: any, 目标: any, 数据: any): void {
  if (!单位存活(目标)) {
    debugLogForce("塞莉亚-Q", "命中失败", "目标无效", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "handle", 目标);
    return; // 失效句柄不再结算
  }
  const X = GetUnitX(目标);
  const Y = GetUnitY(目标);
  const 伤害 = 读取单位攻击力(施法者) * 塞莉亚克莱尔Q配置.主伤害攻击力倍率;
  debugLogForce("塞莉亚-Q", "命中", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(Q技能类型ID), "实例", 数据.技能实例ID ?? "-", "目标", GetUnitName(目标), "handle", 目标, "X", Math.floor(X), "Y", Math.floor(Y), "伤害", 伤害, "全程最近棱晶距", 数据.接近最小距平方 != null ? Math.floor(SquareRoot(数据.接近最小距平方)) : -1);
  造成Q伤害(施法者, 目标, 伤害, 数据.技能实例ID, "塞莉亚-棱晶魔弹", "单体");
  // 命中即视为到达真实终点
  尝试建立终点节点(施法者, 数据, X, Y);
}

/**
 * 折射：本次方向 d 与节点径向 n 的镜像反射 r = d − 2(d·n)n，
 * 从节点位置沿 r 追加一枚折射弹（每次 Q 最多一次）。
 */
function 尝试棱晶折射(this: void, 施法者: any, 数据: any, 当前X: number, 当前Y: number): void {
  if (数据.已读折射 || !数据.有方向向量) return;
  const 节点列表 = 查询塞莉亚节点(施法者);
  if (!数据.已记录折射采样) {
    // 一次性诊断：飞行首帧的节点可见性采样（定位"有节点却不折射"）
    数据.已记录折射采样 = true;
    let 棱晶数 = 0;
    for (let i = 0; i < 节点列表.length; i++) {
      if (节点列表[i].类型 === "棱晶") 棱晶数 += 1;
    }
    debugLogForce("塞莉亚-Q", "折射采样", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "节点数", 节点列表.length, "棱晶数", 棱晶数, "有方向", 数据.有方向向量, "当前X", Math.floor(当前X), "当前Y", Math.floor(当前Y));
  }
  for (let i = 0; i < 节点列表.length; i++) {
    const 节点 = 节点列表[i];
    if (节点.类型 !== "棱晶") continue;
    const 节点距离平方 = 距离平方XY(当前X, 当前Y, 节点.X, 节点.Y);
    // 接近轨迹探针：距任一棱晶创新低（<400）时输出一次，用于定位折射未触发
    if (节点距离平方 < (数据.接近最小距平方 ?? 1e18)) {
      数据.接近最小距平方 = 节点距离平方;
      if (节点距离平方 < 400 * 400) {
        debugLogForce("塞莉亚-Q", "接近棱晶", "距离", Math.floor(SquareRoot(节点距离平方)), "节点", 节点.序号, "当前X", Math.floor(当前X), "当前Y", Math.floor(当前Y));
      }
    }
    if (节点距离平方 > 塞莉亚克莱尔Q配置.折射触发半径 * 塞莉亚克莱尔Q配置.折射触发半径) continue;

    // 分支真正进入后再置位并开火
    数据.已读折射 = true;
    debugLogForce("塞莉亚-Q", "联动", "棱晶折射", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "节点", 节点.序号, "阶段", "进入分支");
    let nx = 当前X - 节点.X;
    let ny = 当前Y - 节点.Y;
    const nl = SquareRoot(nx * nx + ny * ny);
    if (nl <= 0.0001) return;
    nx /= nl;
    ny /= nl;
    const dot = 数据.dirX * nx + 数据.dirY * ny;
    let rx = 数据.dirX - 2 * dot * nx;
    let ry = 数据.dirY - 2 * dot * ny;
    const rl = SquareRoot(rx * rx + ry * ry);
    if (rl <= 0.0001) return;
    rx /= rl;
    ry /= rl;

    发射弹道({
      名称: "塞莉亚-棱晶折射",
      所有者: 施法者,
      发射X: 节点.X,
      发射Y: 节点.Y,
      发射方向角: 两点角度(0, 0, rx, ry),
      速度: 塞莉亚克莱尔Q配置.弹道速度,
      轨迹: { 类型: "直线", 距离: 塞莉亚克莱尔Q配置.最大距离 },
      命中半径: 塞莉亚克莱尔Q配置.命中半径,
      飞行高度: 塞莉亚克莱尔表现配置.Q弹道.高度,
      影响目标: "敌方",
      碰撞消失: true,
      每单位最大命中次数: 1,
      伤害值: 读取单位攻击力(施法者) * 塞莉亚克莱尔Q配置.折射伤害攻击力倍率,
      伤害类型: DAMAGE_TYPE_MAGIC,
      攻击类型: ATTACK_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: Q技能类型ID,
      技能实例ID: 数据.技能实例ID,
      技能标签: "塞莉亚-棱晶折射",
      伤害形态: "单体",
      参与技能伤害加成: false,
      模型: 塞莉亚克莱尔表现配置.Q弹道.模型路径,
      RGB: 塞莉亚克莱尔表现配置.Q弹道.RGB,
      缩放: 塞莉亚克莱尔表现配置.Q弹道.缩放,
    });
    // 折射清响（折射弹真正发出时一次；坐标=节点位置，参数配置驱动）
    Sound3DII_CooPlayReuse(塞莉亚音效配置.Q折射.路径, 节点.X, 节点.Y, 塞莉亚音效配置.Q折射.高度, 塞莉亚音效配置.Q折射.裁断距离);
    debugLogForce("塞莉亚-Q", "联动", "棱晶折射", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "节点", 节点.序号, "阶段", "发射完成");
    return;
  }
}

/** 棱晶+结界连接 → 穿透追加（每次 Q 最多一次）。 */
function 尝试穿透追加(this: void, 施法者: any, 数据: any): void {
  if (数据.已读穿透) return;
  const 连接 = 查询塞莉亚有效连接(施法者);
  if (连接 == null || !连接.可读取) return;
  const 有棱晶 = 连接.A类型 === "棱晶" || 连接.B类型 === "棱晶";
  const 有结界 = 连接.A类型 === "结界" || 连接.B类型 === "结界";
  if (!有棱晶 || !有结界) return;
  数据.已读穿透 = true;
  发射弹道({
    名称: "塞莉亚-棱晶·解析穿透",
    所有者: 施法者,
    发射X: 数据.发射X,
    发射Y: 数据.发射Y,
    发射方向角: 数据.方向角,
    速度: 塞莉亚克莱尔Q配置.弹道速度,
    轨迹: { 类型: "直线", 距离: 塞莉亚克莱尔Q配置.棱晶结界穿透距离 },
    命中半径: 塞莉亚克莱尔Q配置.命中半径,
    飞行高度: 塞莉亚克莱尔表现配置.Q弹道.高度,
    影响目标: "敌方",
    碰撞消失: false,
    每单位最大命中次数: 1,
    最大总命中次数: 塞莉亚克莱尔Q配置.棱晶结界最大命中数,
    伤害值: 读取单位攻击力(施法者) * 塞莉亚克莱尔Q配置.棱晶结界穿透倍率,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: Q技能类型ID,
    技能实例ID: 数据.技能实例ID,
    技能标签: "塞莉亚-棱晶·解析穿透",
    伤害形态: "AOE",
    参与技能伤害加成: false,
    模型: 塞莉亚克莱尔表现配置.Q弹道.模型路径,
    RGB: 塞莉亚克莱尔表现配置.Q弹道.RGB,
    缩放: 塞莉亚克莱尔表现配置.Q弹道.缩放,
  });
}

/** 棱晶+锚定连接 → 对锚定阵内最近敌人发射短追踪追迹弹（每次 Q 最多一次）。 */
function 尝试锚定追迹(this: void, 施法者: any, 数据: any): void {
  if (数据.已读追迹) return;
  const 连接 = 查询塞莉亚有效连接(施法者);
  if (连接 == null || !连接.可读取) return;
  const 有棱晶 = 连接.A类型 === "棱晶" || 连接.B类型 === "棱晶";
  const 有锚定 = 连接.A类型 === "锚定" || 连接.B类型 === "锚定";
  if (!有棱晶 || !有锚定) return;
  const 区域 = 查询塞莉亚锚定区域(施法者);
  if (区域 == null) return;
  const 最近敌人 = 取塞莉亚锚定区域内最近敌人(施法者, 区域.X, 区域.Y, 区域.半径);
  if (最近敌人 == null) return; // 阵内没有合法目标：不白扣本次联动机会
  数据.已读追迹 = true;
  发射弹道({
    名称: "塞莉亚-棱晶·锚定追迹",
    所有者: 施法者,
    发射X: 数据.最后已知X,
    发射Y: 数据.最后已知Y,
    发射方向角: 数据.方向角,
    速度: 塞莉亚克莱尔Q配置.弹道速度,
    轨迹: {
      类型: "追踪",
      目标: 最近敌人,
      追踪转向速度: 塞莉亚克莱尔Q配置.锚定追迹转向速度,
      追踪保持秒: 塞莉亚克莱尔Q配置.锚定追迹保持秒,
    },
    命中半径: 塞莉亚克莱尔Q配置.命中半径,
    飞行高度: 塞莉亚克莱尔表现配置.Q弹道.高度,
    影响目标: "敌方",
    碰撞消失: true,
    每单位最大命中次数: 1,
    伤害值: 读取单位攻击力(施法者) * 塞莉亚克莱尔Q配置.锚定追迹倍率,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: Q技能类型ID,
    技能实例ID: 数据.技能实例ID,
    技能标签: "塞莉亚-棱晶·锚定追迹",
    伤害形态: "单体",
    参与技能伤害加成: false,
    模型: 塞莉亚克莱尔表现配置.Q弹道.模型路径,
    RGB: 塞莉亚克莱尔表现配置.Q弹道.RGB,
    缩放: 塞莉亚克莱尔表现配置.Q弹道.缩放,
  });
}

//=============================================================================
// 施放流程
//=============================================================================

function 释放Q棱晶魔弹(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;

  // t0 快照
  const 目标单位 = GetSpellTargetUnit();
  let 目标X = GetSpellTargetX();
  let 目标Y = GetSpellTargetY();
  const 有目标 = 目标单位 != null && 目标单位 !== 0 && 单位存活(目标单位);
  if (有目标 && 目标X === 0 && 目标Y === 0) {
    目标X = GetUnitX(目标单位);
    目标Y = GetUnitY(目标单位);
  }

  debugLogForce("塞莉亚-Q", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(Q技能类型ID), "实例", 技能实例ID ?? "-", "目标", 有目标 ? GetUnitName(目标单位) : "点施放", "X", Math.floor(目标X), "Y", Math.floor(目标Y), "节点数", 查询塞莉亚节点(施法者).length);

  const 数据: any = {
    技能实例ID,
    已建节点: false,
    已读折射: false,
    已读穿透: false,
    已读追迹: false,
    方向角: 两点角度(GetUnitX(施法者), GetUnitY(施法者), 目标X, 目标Y),
    dirX: 0,
    dirY: 0,
    有方向向量: false,
    发射X: GetUnitX(施法者),
    发射Y: GetUnitY(施法者),
    // 主弹最新已知位置（onTick 持续刷新；锚定追迹以它为发射参考点）
    最后已知X: GetUnitX(施法者),
    最后已知Y: GetUnitY(施法者),
  };

  const 实例 = 创建战斗技能实例({
    技能键: "Q棱晶魔弹",
    施法者,
    目标: 有目标 ? 目标单位 : undefined,
    技能实例ID,
    数据,
    结束回调: function Q实例结束(this: void, _原因: string, _控制器: any): void {
      debugLogForce("塞莉亚-Q", "结束", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(Q技能类型ID), "原因", _原因);
      void _原因;
      void _控制器;
    },
  });

  // 技能喊话：施法成功起点（技能实例成功创建；全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "塞莉亚·克莱尔", 塞莉亚克莱尔技能配置.Q.技能ID);

  // 时序：暂停成功即施法进入（不播未确认动作，缺口见报告）
  const 硬直来源 = "塞莉亚-Q硬直";
  if (添加单位暂停(施法者, 硬直来源)) {
    SetUnitFacing(施法者, 数据.方向角);
  }
  实例.登记延迟回调(addDelayedCallback(塞莉亚克莱尔Q配置.硬直秒 * 1000, function Q硬直结束(this: void): void {
    移除单位暂停(施法者, 硬直来源);
  }));

  实例.登记延迟回调(addDelayedCallback(塞莉亚克莱尔Q配置.发射延迟秒 * 1000, function Q发射(this: void): void {
    if (实例.已结束()) return;
    if (!单位存活(施法者)) return;

    // 方向分量：供折射做镜像反射（归一化）
    const dx = 目标X - 数据.发射X;
    const dy = 目标Y - 数据.发射Y;
    const dl = SquareRoot(dx * dx + dy * dy);
    if (dl > 1) {
      数据.dirX = dx / dl;
      数据.dirY = dy / dl;
      数据.有方向向量 = true;
    }

    const 发射时目标有效 = 有目标 && 单位存活(目标单位);
    const 弹道 = 发射弹道({
      名称: "塞莉亚-棱晶魔弹",
      所有者: 施法者,
      发射X: 数据.发射X,
      发射Y: 数据.发射Y,
      发射方向角: 数据.方向角,
      速度: 塞莉亚克莱尔Q配置.弹道速度,
      轨迹: 发射时目标有效
        ? {
            类型: "追踪",
            目标: 目标单位,
            追踪转向速度: 塞莉亚克莱尔Q配置.追踪转向速度,
            追踪保持秒: 塞莉亚克莱尔Q配置.追踪保持秒,
          }
        : { 类型: "直线", 距离: 塞莉亚克莱尔Q配置.最大距离 },
      命中半径: 塞莉亚克莱尔Q配置.命中半径,
      飞行高度: 塞莉亚克莱尔表现配置.Q弹道.高度,
      影响目标: "敌方",
      碰撞消失: true,
      每单位最大命中次数: 1,
      伤害类型: DAMAGE_TYPE_MAGIC,
      来源类型: "单位技能",
      技能ID: Q技能类型ID,
      技能实例ID,
      技能标签: "塞莉亚-棱晶魔弹",
      伤害形态: "单体",
      参与技能伤害加成: true,
      模型: 塞莉亚克莱尔表现配置.Q弹道.模型路径,
      RGB: 塞莉亚克莱尔表现配置.Q弹道.RGB,
      缩放: 塞莉亚克莱尔表现配置.Q弹道.缩放,
      on命中: function Q命中(this: void, 命中目标: any, _弹幕ID: number): void {
        if (!实例.仍有效()) return;
        处理Q命中(施法者, 命中目标, 数据);
      },
      onTick: function Qtick(this: void, 弹幕实例: any, _delta: number): void {
        if (!实例.仍有效() || 弹幕实例 == null) return;
        数据.最后已知X = 弹幕实例.当前X;
        数据.最后已知Y = 弹幕实例.当前Y;
        尝试棱晶折射(施法者, 数据, 弹幕实例.当前X, 弹幕实例.当前Y);
        尝试穿透追加(施法者, 数据);
        尝试锚定追迹(施法者, 数据);
      },
      on到达点: function Q终点(this: void, _弹幕ID: number, _原因: string): void {
        if (!实例.仍有效()) return;
        // on到达点 触发时弹道已结束，获取弹道当前位置 会返回 (0,0) 兜底；用 onTick 记录的最后坐标
        尝试建立终点节点(施法者, 数据, 数据.最后已知X, 数据.最后已知Y);
      },
    });
    void 弹道;

    // 发射音（Q 施法成功发射时一次；坐标=施法者位置，参数配置驱动）
    Sound3DII_CooPlayReuse(塞莉亚音效配置.Q发射.路径, GetUnitX(施法者), GetUnitY(施法者), 塞莉亚音效配置.Q发射.高度, 塞莉亚音效配置.Q发射.裁断距离);

    // 施法真正成功：授予一次演算普攻窗口
    授予塞莉亚演算窗口(施法者);

    const 注销 = 登记塞莉亚技能清理(施法者, "Q弹道-" + (技能实例ID ?? 0), function Q弹道清理(this: void): void {
      if (弹道 != null && !弹道.已中断()) 弹道.中断();
    });
    void 注销;
  }));
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册塞莉亚Q(this: void): void {
  debugLogForce("塞莉亚-Q", "注册", "名称", "注册塞莉亚Q");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "塞莉亚·克莱尔-棱晶魔弹（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 塞莉亚克莱尔技能配置.Q.技能ID,
    获取或创建上下文: function Q上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放Q棱晶魔弹,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 6,
  });
}

export {};
