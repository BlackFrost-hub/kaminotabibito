/** @noSelfInFile */
/**
 * 芙莉莲 R：解析魔法·贯穿射杀（B4：A7）
 *
 * t0 快照方向/解析目标/类型/完成状态/隐匿/花田联动；通用充能（指令中断+硬控/死亡中断）；
 * 世界坐标进度 UI 单套跟随；主炮/解析消费/花田盛开只在充能完成回调发生；
 * 真实窄线判定 + 实时快照过滤友军 + 每目标一次主结算；所有伤害归同一 R 实例。
 */

import {
  芙莉莲技能配置,
  芙莉莲R配置,
  芙莉莲被动配置,
  芙莉莲表现配置,
  芙莉莲读条配置,
  芙莉莲音效配置,
} from "./00．配置";
import type { 战斗技能实例控制器 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";
const { Sound3DII_UnitPlayReuse, Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
const { 播放限时动作, 开始循环守护, 停止循环守护, 芙莉莲动作槽 } = require("./01A．动作表现") as {
  播放限时动作: (this: void, 英雄: any, 槽: any, 登记名: string) => void;
  开始循环守护: (this: void, 英雄: any, 槽: any, 登记名: string) => any;
  停止循环守护: (this: void, 句柄: any) => void;
  芙莉莲动作槽: { R蓄力保持: any; R发射: any };
};

const jass = require("jass.common") as any;
const { stringToFourCCSafe, fourCCToStringSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
  fourCCToStringSafe: (this: void, fourcc: number) => string;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例, 查询战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => 战斗技能实例控制器;
  查询战斗技能实例: (this: void, 施法者: any, 技能键: string) => 战斗技能实例控制器[];
};
const { 开始充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力, 单位存活, 两点角度, 角度差绝对值, 距离平方XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  角度差绝对值: (this: void, a: number, b: number) => number;
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const {
  是芙莉莲,
  记录芙莉莲活动,
  快照隐匿,
  有解析,
  目标解析完成,
  尝试消费解析完成,
} = require("./02．被动效果") as {
  是芙莉莲: (this: void, unit: any) => boolean;
  记录芙莉莲活动: (this: void, 英雄: any) => void;
  快照隐匿: (this: void, 英雄: any) => boolean;
  有解析: (this: void, 芙莉莲: any, 目标: any, 类型: "攻击" | "防御" | "位置") => boolean;
  目标解析完成: (this: void, 芙莉莲: any, 目标: any) => boolean;
  尝试消费解析完成: (this: void, 芙莉莲: any, 目标: any) => boolean;
};
// 花田联动（D 模块运行时 require 防循环依赖）
const 花田联动 = require("./07．D技能") as {
  尝试消费花田盛开?: (this: void, 芙莉莲: any) => boolean;
  在花田内?: (this: void, 芙莉莲: any) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(芙莉莲技能配置.单位类型ID);
const R技能ID = stringToFourCCSafe(芙莉莲技能配置.R.技能ID);
const R配置 = 芙莉莲R配置;
const 被动配置 = 芙莉莲被动配置;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;

//=============================================================================
// R 终式（只在充能完成回调创建；中断/死亡不伤害、不消费解析、不触发花田）
//=============================================================================

function R结算主炮(this: void, 施法者: any, 技能实例ID: number | undefined, 快照: R快照): void {
  if (!单位存活(施法者)) return;
  const 攻击力 = 读取单位攻击力(施法者);
  // 位置解析分支：扩大命中宽度（固定半宽 × 倍率；不随距离扩宽——窄矩形/直线语义）
  let 半宽 = R配置.命中半宽;
  if (快照.解析类型 === "位置") 半宽 = R配置.命中半宽 * R配置.位置解析宽度倍率;
  // 单解析分支轻量修正（攻击→穿透强化、防御→防护削减；静态实现为伤害修正）
  let 分支加成 = 0;
  if (快照.解析类型 === "攻击") 分支加成 = R配置.攻击解析加成倍率;
  if (快照.解析类型 === "防御") 分支加成 = R配置.防御解析加成倍率;
  // 隐匿强化（首击加成，只给第一个命中目标）
  const 隐匿加成 = 快照.隐匿 ? 被动配置.隐匿首击加成倍率 : 0;

  // 真实窄矩形判定：半径内敌人枚举 + 沿方向投影/垂距过滤（固定半宽，模型宽度不扩大范围）
  const 施法者X = GetUnitX(施法者);
  const 施法者Y = GetUnitY(施法者);
  const 命中列表: { 目标: any; 投影: number }[] = [];
  const 组 = jass.CreateGroup() as any;
  jass.GroupEnumUnitsInRange(组, 施法者X, 施法者Y, R配置.距离, null);
  while (true) {
    const u = jass.FirstOfGroup(组) as any;
    if (u == null || u === 0) break;
    jass.GroupRemoveUnit(组, u);
    if (u === 施法者 || !单位存活(u)) continue;
    if (!IsUnitEnemy(u, GetOwningPlayer(施法者))) continue;
    const 目标X = GetUnitX(u);
    const 目标Y = GetUnitY(u);
    const 目标距离 = Math.sqrt(距离平方XY(施法者X, 施法者Y, 目标X, 目标Y));
    if (目标距离 <= 0 || 目标距离 > R配置.距离) continue;
    const 夹角 = 角度差绝对值(快照.方向角, 两点角度(施法者X, 施法者Y, 目标X, 目标Y));
    const 夹角弧度 = 夹角 * 0.01745329252;
    const 投影 = Math.cos(夹角弧度) * 目标距离;
    const 垂距 = Math.sin(夹角弧度) * 目标距离;
    if (投影 <= 0 || 垂距 > 半宽) continue;
    命中列表.push({ 目标: u, 投影 });
  }
  jass.DestroyGroup(组);
  // 按投影距离排序（最近的先结算；隐匿首击只给第一个）
  命中列表.sort(function 按投影排序(this: void, a: { 投影: number }, b: { 投影: number }): number {
    return a.投影 - b.投影;
  });

  // 主炮表现（窄幅贯穿；按快照方向旋转；参数配置驱动）
  创建点特效({
    模型路径: 芙莉莲表现配置.R主炮.模型路径,
        X: 施法者X,
    Y: 施法者Y,
    Z: 芙莉莲表现配置.R主炮.高度,
    面向角度: 快照.方向角,
    动画索引: 芙莉莲表现配置.R主炮.动画索引,
    缩放: 芙莉莲表现配置.R主炮.缩放,
    持续秒: 芙莉莲表现配置.R主炮.持续秒,
    RGB: 芙莉莲表现配置.R主炮.RGB,
  });

  // 每目标一次主结算（全部归属本次 R 实例；隐匿首击只加给第一个命中目标）
  for (let i = 0; i < 命中列表.length; i++) {
    const 目标 = 命中列表[i].目标;
    let 倍率 = R配置.主炮倍率 + 分支加成 + (i === 0 ? 隐匿加成 : 0);
    let 标签 = "芙莉莲-R贯穿射杀";

    // 解析完成分支：原子消费一次（消费成功才破防强化）
    if (快照.解析完成 && 快照.解析目标 === 目标) {
      if (尝试消费解析完成(施法者, 目标)) {
        倍率 += R配置.完成破防追加倍率;
        标签 = "芙莉莲-R破防贯穿";
        // 破防爆发表现（参数配置驱动）
        创建点特效({
          模型路径: 芙莉莲表现配置.R破防爆发.模型路径,
              X: GetUnitX(目标),
          Y: GetUnitY(目标),
          Z: 芙莉莲表现配置.R破防爆发.高度,
          面向角度: 芙莉莲表现配置.R破防爆发.面向角度,
          动画索引: 芙莉莲表现配置.R破防爆发.动画索引,
          缩放: 芙莉莲表现配置.R破防爆发.缩放,
          持续秒: 芙莉莲表现配置.R破防爆发.持续秒,
          RGB: 芙莉莲表现配置.R破防爆发.RGB,
        });
        // 破防命中音（R/Q 解析完成破防共用；坐标=目标位置，参数配置驱动）
        Sound3DII_CooPlayReuse(芙莉莲音效配置.R破防.路径, GetUnitX(目标), GetUnitY(目标), 芙莉莲音效配置.R破防.高度, 芙莉莲音效配置.R破防.裁断距离);
        // 完成爆发追加一次小伤害（同实例）
        造成技能伤害({
          来源: 施法者,
          目标,
          伤害: 攻击力 * R配置.完成爆发倍率,
          伤害类型: DAMAGE_TYPE_MAGIC,
          攻击类型: ATTACK_TYPE_NORMAL,
          武器类型: WEAPON_TYPE_WHOKNOWS,
          来源类型: "单位技能",
          技能ID: R技能ID,
          技能实例ID,
          标签: "芙莉莲-R完成爆发",
          伤害形态: "单体",
          参与技能伤害加成: true,
        });
      }
    }

    debugLogForce("芙莉莲-R", "命中", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(R技能ID), "实例", 技能实例ID ?? "-", "目标", GetUnitName(目标), "handle", 目标, "X", Math.floor(GetUnitX(目标)), "Y", Math.floor(GetUnitY(目标)), "伤害", 攻击力 * 倍率, "标签", 标签);
    造成技能伤害({
      来源: 施法者,
      目标,
      伤害: 攻击力 * 倍率,
      伤害类型: DAMAGE_TYPE_MAGIC,
      攻击类型: ATTACK_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: R技能ID,
      技能实例ID,
      标签,
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });

    // 命中反馈（每目标一次；参数配置驱动）
    创建点特效({
      模型路径: 芙莉莲表现配置.R命中反馈.模型路径,
          X: GetUnitX(目标),
      Y: GetUnitY(目标),
      Z: 芙莉莲表现配置.R命中反馈.高度,
      面向角度: 芙莉莲表现配置.R命中反馈.面向角度,
      动画索引: 芙莉莲表现配置.R命中反馈.动画索引,
      缩放: 芙莉莲表现配置.R命中反馈.缩放,
      持续秒: 芙莉莲表现配置.R命中反馈.持续秒,
      RGB: 芙莉莲表现配置.R命中反馈.RGB,
    });
  }

  // 花田盛开（一次表现/效率；只在命中瞬间；不追加连续伤害）
  if (快照.花田内释放 && 花田联动.尝试消费花田盛开 != null) {
    花田联动.尝试消费花田盛开(施法者);
  }
}

interface R快照 {
  方向角: number;
  隐匿: boolean;
  解析目标: any;
  解析类型: "攻击" | "防御" | "位置" | null;
  解析完成: boolean;
  花田内释放: boolean;
}

//=============================================================================
// R 释放（充能）
//=============================================================================

function 释放R(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (!是芙莉莲(施法者)) {
    debugLogForce("芙莉莲-R", "释放被拒", "原因", "非芙莉莲施法者", "施法者", 施法者, "handle", 施法者, "实例", 技能实例ID ?? "-");
    return;
  }
  debugLogForce("芙莉莲-R", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(R技能ID), "实例", 技能实例ID ?? "-", "英雄", 施法者, "handle", 施法者, "目标", "点施放", "X", Math.floor(GetSpellTargetX()), "Y", Math.floor(GetSpellTargetY()));
  // 重复 R：已有活跃 R 实例时忽略
  if (查询战斗技能实例(施法者, "芙莉莲R").length > 0) return;
  // t0 快照：先取隐匿快照，再记录活动（解除隐匿）
  const 隐匿 = 快照隐匿(施法者);
  记录芙莉莲活动(施法者);
  // 蓄力保持动作（施法姿势建立保持候选；完成/指令/硬控/死亡统一停止）
  let 蓄力守护: any = 开始循环守护(施法者, 芙莉莲动作槽.R蓄力保持, "芙莉莲R蓄力");
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();

  // 解析快照：重点目标的类型/完成状态（t0 时点）
  const 解析快照 = 花田联动取解析快照(施法者);
  // 花田联动快照：R 是否从花田范围内释放
  const 花田内释放 = 花田联动.在花田内 != null ? 花田联动.在花田内(施法者) : false;

  const 快照: R快照 = {
    方向角: 两点角度(GetUnitX(施法者), GetUnitY(施法者), 目标X, 目标Y),
    隐匿,
    解析目标: 解析快照.目标,
    解析类型: 解析快照.类型,
    解析完成: 解析快照.完成,
    花田内释放,
  };

  const 控制器 = 创建战斗技能实例({
    技能键: "芙莉莲R",
    施法者,
    技能实例ID,
    数据: 快照,
    结束回调: function R结束(this: void, _原因: string, _c: any): void {
      // 中断/死亡收束（预警/读条由充能结束回调销毁；此处仅兜底）
    },
  });

  // 蓄力预警（常驻句柄；充能结束回调统一销毁，无自带计时双销毁）
  let 预警句柄: any = null;
  const 充能ID = 开始充能(施法者, {
    持续时间: R配置.蓄力秒,
    指令中断: true,
    世界坐标进度UI: true,
    世界坐标进度UI类型: 芙莉莲读条配置.UI类型,
    世界坐标进度UI标题: "贯穿射杀",
    世界坐标进度UI数值后缀: "",
    世界坐标进度UI高度偏移: 芙莉莲读条配置.跟随Z偏移,
    显示进度条特效: false,
    开始回调: function R蓄力开始(this: void, _单位: any, _充能ID: number): void {
      // 蓄力建立音（充能真正建立时一次；单位绑定，参数配置驱动）
      Sound3DII_UnitPlayReuse(芙莉莲音效配置.R蓄力.路径, 施法者, 芙莉莲音效配置.R蓄力.裁断距离);
      预警句柄 = 创建点特效({
        模型路径: 芙莉莲表现配置.R蓄力预警.模型路径,
            X: GetUnitX(施法者),
        Y: GetUnitY(施法者),
        Z: 芙莉莲表现配置.R蓄力预警.高度,
        面向角度: 快照.方向角,
        动画索引: 芙莉莲表现配置.R蓄力预警.动画索引,
        缩放: 芙莉莲表现配置.R蓄力预警.缩放,
        // 持续秒 配置驱动（默认 -1 常驻，由充能结束回调统一销毁；修改配置即生效，不再依赖公共默认）
        持续秒: 芙莉莲表现配置.R蓄力预警.持续秒,
        RGB: 芙莉莲表现配置.R蓄力预警.RGB,
      });
    },
    // 充能完成：主炮/解析消费/花田盛开只在此发生
    充能完成回调: function R蓄力完成(this: void, _单位: any, _充能ID: number): void {
      // 先停止蓄力保持守护，再播放主炮发射动作（避免守护定时恢复截断发射动作）
      if (蓄力守护 != null) {
        停止循环守护(蓄力守护);
        蓄力守护 = null;
      }
      // 主炮发射音（充能完成结算点；坐标=施法者位置，参数配置驱动）
      Sound3DII_CooPlayReuse(芙莉莲音效配置.R主炮.路径, GetUnitX(施法者), GetUnitY(施法者), 芙莉莲音效配置.R主炮.高度, 芙莉莲音效配置.R主炮.裁断距离);
      // 主炮发射动作（直线发射候选）
      播放限时动作(施法者, 芙莉莲动作槽.R发射, "芙莉莲R发射");
      R结算主炮(施法者, 技能实例ID, 快照);
      控制器.完成();
    },
    // 充能结束（完成/指令中断/硬控/死亡/单位失效统一收尾）：销毁读条与预警
    结束回调: function R蓄力结束(this: void, _单位: any, 原因: string, _充能ID: number): void {
      debugLogForce("芙莉莲-R", "结束", "原因", 原因 || "-", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(R技能ID), "实例", 技能实例ID ?? "-", "英雄", 施法者, "handle", 施法者);
      // 蓄力保持守护停止（指令/硬控/死亡打断后不继续举杖姿势）
      if (蓄力守护 != null) {
        停止循环守护(蓄力守护);
        蓄力守护 = null;
      }
      if (预警句柄 != null && 预警句柄 !== 0) {
        jass.DestroyEffect(预警句柄);
        预警句柄 = null;
      }
      // 充能未完成（指令/硬控/死亡中断）：结束战斗技能实例，避免残留到实例超时
      if (原因 !== "完成") {
        控制器.中断();
      }
      void 充能ID;
    },
  });
  // 技能喊话在充能真正建立后播放（蓄力被拒/中断不播）
  if (充能ID > 0) 播放英雄技能喊话(施法者, "芙莉莲", 芙莉莲技能配置.R.技能ID);
}

// 解析快照辅助（运行时读取 02 的当前重点目标状态作为 t0 快照）
const 解析快照源 = require("./02．被动效果") as {
  有解析: (this: void, 芙莉莲: any, 目标: any, 类型: "攻击" | "防御" | "位置") => boolean;
  目标解析完成: (this: void, 芙莉莲: any, 目标: any) => boolean;
  取芙莉莲重点目标?: (this: void, 芙莉莲: any) => any;
};

function 花田联动取解析快照(this: void, 施法者: any): { 目标: any; 类型: "攻击" | "防御" | "位置" | null; 完成: boolean } {
  const 取目标 = 解析快照源.取芙莉莲重点目标;
  const 目标 = 取目标 != null ? 取目标(施法者) : null;
  if (目标 == null || 目标 === 0 || !单位存活(目标)) {
    return { 目标: null, 类型: null, 完成: false };
  }
  let 类型: "攻击" | "防御" | "位置" | null = null;
  if (解析快照源.有解析(施法者, 目标, "攻击")) 类型 = "攻击";
  else if (解析快照源.有解析(施法者, 目标, "防御")) 类型 = "防御";
  else if (解析快照源.有解析(施法者, 目标, "位置")) 类型 = "位置";
  return { 目标, 类型, 完成: 解析快照源.目标解析完成(施法者, 目标) };
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册芙莉莲R(this: void): void {
  debugLogForce("芙莉莲-R", "注册", "名称", "注册芙莉莲R");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "芙莉莲-解析魔法·贯穿射杀（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 芙莉莲技能配置.R.技能ID,
    获取或创建上下文: function R上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放R,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: R配置.蓄力秒 + 3,
  });
}
