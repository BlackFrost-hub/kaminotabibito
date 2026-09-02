/** @noSelfInFile */
/**
 * 芙莉莲 Q：普通攻击魔法·Zoltraak（B2：A3）
 *
 * 点目标方向施法时快照；真实窄直线弹道判定（模型宽度不扩大伤害范围）；
 * 隐匿快照提升射程/首击；命中主目标施加攻击解析；
 * 解析完成→破防（原子消费）/防御解析→穿透 各一次；打断发生在发射点前不生成弹道不消费解析。
 */

import {
  芙莉莲技能配置,
  芙莉莲Q配置,
  芙莉莲被动配置,
  芙莉莲表现配置,
  芙莉莲音效配置,
} from "./00．配置";
const { 播放限时动作, 芙莉莲动作槽 } = require("./01A．动作表现") as {
  播放限时动作: (this: void, 英雄: any, 槽: any, 登记名: string) => void;
  芙莉莲动作槽: { Q发射: any };
};

/** 本文件内使用简写；与上方导入的完整配置同源（仅别名，无重复定义）。 */
const 被动配置 = 芙莉莲被动配置;

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => any;
};
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
const {
  是芙莉莲,
  记录芙莉莲活动,
  快照隐匿,
  施加解析,
  有解析,
  目标解析完成,
  尝试消费解析完成,
  提供演算普攻,
} = require("./02．被动效果") as {
  是芙莉莲: (this: void, unit: any) => boolean;
  记录芙莉莲活动: (this: void, 英雄: any) => void;
  快照隐匿: (this: void, 英雄: any) => boolean;
  施加解析: (this: void, 芙莉莲: any, 目标: any, 类型: "攻击" | "防御" | "位置") => void;
  有解析: (this: void, 芙莉莲: any, 目标: any, 类型: "攻击" | "防御" | "位置") => boolean;
  目标解析完成: (this: void, 芙莉莲: any, 目标: any) => boolean;
  尝试消费解析完成: (this: void, 芙莉莲: any, 目标: any) => boolean;
  提供演算普攻: (this: void, 芙莉莲: any) => void;
};
// 花田联动（D 模块运行时 require 防循环依赖；接口可缺省）
const 花田联动 = require("./07．D技能") as {
  尝试消费花田修正?: (this: void, 芙莉莲: any) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(芙莉莲技能配置.单位类型ID);
const Q技能ID = stringToFourCCSafe(芙莉莲技能配置.Q.技能ID);
const Q配置 = 芙莉莲Q配置;
const Q音效 = 芙莉莲音效配置.Q发射;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;

//=============================================================================
// Q 命中结算：基础伤害 + 攻击解析 + 穿透/破防分支（伤害全部归属本次 Q 实例）
//=============================================================================

function 结算Q命中(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined, 隐匿强化: boolean): void {
  const 攻击力 = 读取单位攻击力(施法者);
  const 基础倍率 = Q配置.伤害倍率 + (隐匿强化 ? 被动配置.隐匿首击加成倍率 : 0);
  let 倍率 = 基础倍率;
  let 标签 = "芙莉莲-QZoltraak";

  // 解析完成分支：原子消费一次（消费成功才执行破防强化；否则不清除解析）
  if (目标解析完成(施法者, 目标)) {
    if (尝试消费解析完成(施法者, 目标)) {
      倍率 += Q配置.破防追加倍率;
      标签 = "芙莉莲-Q破防";
      // 破防表现：目标防护表面短裂纹后消散（复用解析完成模型短播；参数配置驱动）
      创建点特效({
        模型路径: 芙莉莲表现配置.解析完成.模型路径,
            X: GetUnitX(目标),
        Y: GetUnitY(目标),
        Z: 芙莉莲表现配置.解析完成.高度,
        面向角度: 芙莉莲表现配置.解析完成.面向角度,
        动画索引: 芙莉莲表现配置.解析完成.动画索引,
        缩放: 芙莉莲表现配置.解析完成.缩放,
        持续秒: 芙莉莲表现配置.解析完成.持续秒,
        RGB: 芙莉莲表现配置.解析完成.RGB,
      });
      // 破防命中反馈（R/Q 解析完成破防共用；坐标=目标位置，参数配置驱动）
      Sound3DII_CooPlayReuse(芙莉莲音效配置.R破防.路径, GetUnitX(目标), GetUnitY(目标), 芙莉莲音效配置.R破防.高度, 芙莉莲音效配置.R破防.裁断距离);
    }
  } else if (有解析(施法者, 目标, "防御")) {
    // 穿透分支：目标已有防御解析 → 魔法护盾/结界穿透强化
    倍率 += Q配置.穿透追加倍率;
    标签 = "芙莉莲-Q穿透";
  }

  debugLogForce("芙莉莲-Q", "伤害", "标签", 标签, "数值", 攻击力 * 倍率);
  造成技能伤害({
    来源: 施法者,
    目标,
    伤害: 攻击力 * 倍率,
    伤害类型: DAMAGE_TYPE_NORMAL,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: Q技能ID,
    技能实例ID,
    标签,
    伤害形态: "单体",
    参与技能伤害加成: true,
  });

  // 命中反馈：小型穿透闪光（不使用大爆炸；参数配置驱动）
  创建点特效({
    模型路径: 芙莉莲表现配置.Q命中反馈.模型路径,
        X: GetUnitX(目标),
    Y: GetUnitY(目标),
    Z: 芙莉莲表现配置.Q命中反馈.高度,
    面向角度: 芙莉莲表现配置.Q命中反馈.面向角度,
    动画索引: 芙莉莲表现配置.Q命中反馈.动画索引,
    缩放: 芙莉莲表现配置.Q命中反馈.缩放,
    持续秒: 芙莉莲表现配置.Q命中反馈.持续秒,
    RGB: 芙莉莲表现配置.Q命中反馈.RGB,
  });
  // 命中音（坐标=目标位置，参数配置驱动）
  Sound3DII_CooPlayReuse(芙莉莲音效配置.Q命中.路径, GetUnitX(目标), GetUnitY(目标), 芙莉莲音效配置.Q命中.高度, 芙莉莲音效配置.Q命中.裁断距离);

  // 主要命中目标施加攻击解析
  施加解析(施法者, 目标, "攻击");
  // Q 成功 → 提供一次演算普攻
  提供演算普攻(施法者);
}

//=============================================================================
// Q 释放
//=============================================================================

function 释放Q(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  debugLogForce("芙莉莲-Q", "释放", "技能实例ID", 技能实例ID || "-");
  if (!是芙莉莲(施法者)) return;
  // 重复 Q：已有活跃 Q 实例时忽略
  // 施法时点：先快照隐匿（消费判定用），再记录活动（解除隐匿并重置静默计时）
  const 隐匿强化 = 快照隐匿(施法者);
  记录芙莉莲活动(施法者);
  // 技能喊话：施法成功起点（全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "芙莉莲", 芙莉莲技能配置.Q.技能ID);
  // 施法动作（Q 发射候选）
  播放限时动作(施法者, 芙莉莲动作槽.Q发射, "芙莉莲Q动作");
  // 分层音效在施法时点启动；内层发射声与 Q 的 150ms 发射延迟对齐，且全局按单位位置播放。
  Sound3DII_UnitPlayReuse(Q音效.路径, 施法者, Q音效.裁断距离);
  // 方向快照（施法时点）
  const 方向角 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), GetSpellTargetX(), GetSpellTargetY());

  // 花田修正：花田内释放 Q 获得一次射程修正（单次消费锁）
  let 射程 = Q配置.射程 + (隐匿强化 ? 被动配置.隐匿射程加成 : 0);
  if (花田联动.尝试消费花田修正 != null && 花田联动.尝试消费花田修正(施法者)) {
    射程 += 芙莉莲D数值引用.修正Q射程加成;
  }

  const 控制器 = 创建战斗技能实例({
    技能键: "芙莉莲Q",
    施法者,
    技能实例ID,
    数据: { 已发射: false },
    结束回调: function Q结束(this: void, _原因: string, _c: any): void {
      debugLogForce("芙莉莲-Q", "结束", "原因", _原因 || "-");
      // 打断发生在发射点前：延迟回调已由实例统一清理 → 不生成弹道、不命中、不消费解析
    },
  });

  // 发射点（打断发生在发射点前时延迟回调被实例清理，不执行发射）
  const 发射ID = addDelayedCallback(Q配置.发射延迟毫秒, function Q发射(this: void): void {
    if (!单位存活(施法者)) return;
    发射弹道({
      名称: "芙莉莲-QZoltraak",
      所有者: 施法者,
      发射方向角: 方向角,
      速度: Q配置.弹道速度,
      轨迹: { 类型: "直线", 距离: 射程 },
      命中半径: Q配置.命中半径,
      影响目标: "敌方",
      碰撞消失: true,
      每单位最大命中次数: 1,
      最大总命中次数: 1,
      来源类型: "单位技能",
      技能ID: Q技能ID,
      技能实例ID,
      技能标签: "芙莉莲-QZoltraak",
      模型: 芙莉莲表现配置.Q弹道.模型路径,
      RGB: 芙莉莲表现配置.Q弹道.RGB,
      缩放: 芙莉莲表现配置.Q弹道.缩放,
      飞行高度: 芙莉莲表现配置.Q弹道.高度,
      附加特效1: {
        模型: 芙莉莲表现配置.Q弹道附加特效.模型路径,
        跟随主弹幕参数: 芙莉莲表现配置.Q弹道附加特效.跟随主弹幕参数,
        跟随轨迹俯仰: 芙莉莲表现配置.Q弹道附加特效.跟随轨迹俯仰,
        动画索引: 芙莉莲表现配置.Q弹道附加特效.动画索引,
        缩放: 芙莉莲表现配置.Q弹道附加特效.缩放,
        红: 芙莉莲表现配置.Q弹道附加特效.RGB.红,
        绿: 芙莉莲表现配置.Q弹道附加特效.RGB.绿,
        蓝: 芙莉莲表现配置.Q弹道附加特效.RGB.蓝,
        透明度: 芙莉莲表现配置.Q弹道附加特效.RGB.透明度,
      },
      on命中: function Q命中(this: void, 目标: any, _弹道: any): void {
        结算Q命中(施法者, 目标, 技能实例ID, 隐匿强化);
      },
    });
    控制器.完成();
  });
  控制器.登记延迟回调(发射ID);
}

// 花田修正数值引用（避免直接 import D 配置造成编译期循环；数值以 00．配置 为准）
const { 芙莉莲D配置: 芙莉莲D数值引用 } = require("./00．配置") as {
  芙莉莲D配置: { 修正Q射程加成: number; 修正W持续加成秒: number; 半径: number; 持续秒: number; 静止判定半径: number };
};

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册芙莉莲Q(this: void): void {
  debugLogForce("芙莉莲-Q", "注册", "名称", "注册芙莉莲Q");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "芙莉莲-普通攻击魔法·Zoltraak（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 芙莉莲技能配置.Q.技能ID,
    获取或创建上下文: function Q上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放Q,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 3,
  });
}
