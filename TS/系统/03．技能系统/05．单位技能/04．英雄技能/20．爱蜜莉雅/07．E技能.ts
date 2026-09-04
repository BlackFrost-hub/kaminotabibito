/** @noSelfInFile */
/**
 * 爱蜜莉雅 - E：冰晶护身（A6）
 *
 * - 点目标技能：护盾 + 短距离冰面位移 + 落点冰晶 + 提前结束。
 * - 护盾：护盾系统接管（开始护盾，血条自动显示；护盾值 = 攻击力 × 倍率），破盾由 破碎回调 触发破盾冰爆与裂纹。
 * - 位移：项目冲锋封装（检查地形；不可达点触发撞墙回调 → 短惩罚冷却，不进完整失败冷却）。
 * - 位移拖尾：起点冰面路径单元（分段表现），落点冰爆 + 落点冰晶节点。
 * - 护盾期间再次按[E]：提前结束并触发主动引爆收尾。
 * - 目标失效不跳过自身位移收尾（位移不依赖目标存在）。
 */

import { 爱蜜莉雅技能配置, 爱蜜莉雅E配置, 爱蜜莉雅表现配置, 爱蜜莉雅音效配置 } from "./00．配置";
import { 爱蜜莉雅BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/20．爱蜜莉雅";
import { 创建战斗技能实例, 查询战斗技能实例 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";
import { 播放爱蜜莉雅动作 } from "./02．公共状态与冰晶";
import { 爱蜜莉雅动作槽 } from "./00．配置";
import { 创建爱蜜莉雅场上冰晶 } from "./03．被动效果";

const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string, 伊蕾娜变式?: string) => boolean;
};

const jass = require("jass.common") as any;
const { stringToFourCCSafe, fourCCToStringSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
  fourCCToStringSafe: (this: void, fourcc: number) => string;
};
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 开始护盾, 移除护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.index") as {
  开始护盾: (this: void, 单位: any, 参数: { 数值: number; 持续时间?: number; 来源单位?: any; 显示护盾条?: boolean; 可驱散?: boolean; 标签?: string; 破碎回调?: (this: void, 单位: any, 护盾ID: number, 吸收伤害: number) => void; 结束回调?: (this: void, 单位: any, 护盾ID: number, 原因: string) => void }) => number;
  移除护盾: (this: void, 护盾ID: number) => boolean;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 开始冲锋, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, 单位: any, 参数: any) => number;
  停止位移: (this: void, 位移ID: number, 原因?: string) => boolean;
};
const { 创建点特效, createUnitEffect, destroyUnitEffect, 设置特效缩放 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
  设置特效缩放: (this: void, effect: any, scale: number) => void;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 读取单位攻击力, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 创建限时二段技能壳, 确认限时二段技能壳, 清理限时二段技能壳 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.25．限时二段技能壳") as {
  创建限时二段技能壳: (this: void, 参数: any) => any;
  确认限时二段技能壳: (this: void, 控制器: any) => boolean;
  清理限时二段技能壳: (this: void, 控制器: any) => boolean;
};
const { 消费爱蜜莉雅D强化 } = require("./02．公共状态与冰晶") as {
  消费爱蜜莉雅D强化: (this: void, 英雄: any) => boolean;
};
const platformAbilityApi = require("平台扩展API取值") as {
  技能_获取技能最大冷却时间: (this: void, 单位: any, 技能代码: number) => number;
};
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(爱蜜莉雅技能配置.单位类型ID);
const E技能类型ID = stringToFourCCSafe(爱蜜莉雅技能配置.E.技能ID);
const 护盾特效键 = "爱蜜莉雅E护盾";

interface E护盾数据 {
  /** 护盾系统实例 ID（0=未建立）；血条由护盾系统自动显示 */
  护盾ID: number;
  位移ID: number;
  已结束: boolean;
  /** 二段输入壳控制器（ASE2；护盾期间切换 E 按钮为提前结束） */
  二段壳: any;
}

function 施加落点冰爆(this: void, 施法者: any, X: number, Y: number, 技能实例ID: number | undefined, 伤害值: number): void {
  创建点特效({
    模型路径: 爱蜜莉雅表现配置.落点冰爆.模型路径,
   RGB: 爱蜜莉雅表现配置.落点冰爆.RGB,
       X,
    Y,
    Z: 爱蜜莉雅表现配置.落点冰爆.高度,
    缩放: 爱蜜莉雅表现配置.落点冰爆.缩放,
    持续秒: 爱蜜莉雅表现配置.落点冰爆.持续秒,
  });
  const 目标组 = jass.CreateGroup() as any;
  jass.GroupEnumUnitsInRange(目标组, X, Y, 爱蜜莉雅E配置.落点冰爆半径, null);
  while (true) {
    const u = jass.FirstOfGroup(目标组) as any;
    if (u == null || u === 0) break;
    jass.GroupRemoveUnit(目标组, u);
    if (u === 施法者 || !单位存活(u)) continue;
    if (!jass.IsUnitEnemy(u, jass.GetOwningPlayer(施法者))) continue;
    debugLogForce("爱蜜莉雅-E", "伤害", "标签", "爱蜜莉雅-E冰爆", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(E技能类型ID), "实例", 技能实例ID ?? "-", "目标", GetUnitName(u), "handle", u, "X", Math.floor(GetUnitX(u)), "Y", Math.floor(GetUnitY(u)), "数值", 伤害值);
    造成技能伤害({
      来源: 施法者,
      目标: u,
      伤害: 伤害值,
      伤害类型: DAMAGE_TYPE_COLD,
      攻击类型: ATTACK_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: E技能类型ID,
      技能实例ID,
      标签: "爱蜜莉雅-E冰爆",
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });
  }
  jass.DestroyGroup(目标组);
}

function 结束E护盾分支(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined, 分支: "自然" | "提前" | "破盾"): void {
  const 数据 = 控制器.数据 as E护盾数据;
  if (数据 == null || 数据.已结束) return;
  debugLogForce("爱蜜莉雅-E", "结束", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(E技能类型ID), "实例", 技能实例ID ?? "-", "原因", 分支, "X", Math.floor(GetUnitX(施法者)), "Y", Math.floor(GetUnitY(施法者)));
  // 先置 已结束 再停止位移：停止位移同步触发位移结束回调，此时必须已标记结束（否则落点冰爆/冰晶/D强化被重复执行）
  数据.已结束 = true;
  // 提前结束：停止位移
  if (分支 === "提前" && 数据.位移ID !== 0) 停止位移(数据.位移ID, "中断");
  if (数据.护盾ID !== 0) {
    移除护盾(数据.护盾ID);
    数据.护盾ID = 0;
  }
  if (数据.二段壳 != null) 清理限时二段技能壳(数据.二段壳);
  移除单位指定Buff(施法者, 爱蜜莉雅BuffID.冰晶护身);
  destroyUnitEffect(施法者, 护盾特效键);
  if (分支 === "破盾") {
    创建点特效({
      模型路径: 爱蜜莉雅表现配置.破盾裂纹.模型路径,
     RGB: 爱蜜莉雅表现配置.破盾裂纹.RGB,
         X: GetUnitX(施法者),
      Y: GetUnitY(施法者),
      Z: 爱蜜莉雅表现配置.破盾裂纹.高度,
      缩放: 爱蜜莉雅表现配置.破盾裂纹.缩放,
      持续秒: 爱蜜莉雅表现配置.破盾裂纹.持续秒,
    });
    // 破盾提示音：仅真实破盾分支一次（自然结束/提前结束不播；单位=施法者，参数配置驱动）
    Sound3DII_UnitPlayReuse(爱蜜莉雅音效配置.E破盾.路径, 施法者, 爱蜜莉雅音效配置.E破盾.裁断距离);
  }
  // 冰爆结算（自然/提前/破盾均触发；数值按分支统一用配置）
  施加落点冰爆(施法者, GetUnitX(施法者), GetUnitY(施法者), 技能实例ID, 读取单位攻击力(施法者) * 爱蜜莉雅E配置.破盾伤害攻击力倍率);
  控制器.完成();
}

function 释放E冰晶护身(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0) {
    debugLogForce("爱蜜莉雅-E", "释放被拒", "原因", "施法者无效", "分支", "护身");
    return;
  }
  debugLogForce(
    "爱蜜莉雅-E",
    "释放",
    "玩家",
    GetPlayerId(GetOwningPlayer(施法者)) + 1,
    "四码",
    fourCCToStringSafe(E技能类型ID),
    "实例",
    技能实例ID ?? "-",
    "目标",
    "点施放",
    "目标X",
    Math.floor(GetSpellTargetX()),
    "目标Y",
    Math.floor(GetSpellTargetY()),
  );
  播放爱蜜莉雅动作(施法者, 爱蜜莉雅动作槽.E);
  // 已有护盾：提前结束
  const 活跃列表 = 查询战斗技能实例(施法者, "E护盾");
  for (let i = 0; i < 活跃列表.length; i++) {
    结束E护盾分支(施法者, 活跃列表[i], 技能实例ID, "提前");
    return;
  }

  播放英雄技能喊话(施法者, "爱蜜莉雅", 爱蜜莉雅技能配置.E.技能ID);
  const 护盾值 = 读取单位攻击力(施法者) * 爱蜜莉雅E配置.护盾攻击力倍率;
  const 数据: E护盾数据 = { 护盾ID: 0, 位移ID: 0, 已结束: false, 二段壳: null };
  const 控制器 = 创建战斗技能实例({
    技能键: "E护盾",
    施法者,
    技能实例ID,
    数据,
    结束回调: function E结束(this: void, _原因: string, _c: any): void {
      // 死亡/中断收束：补全清理（与 结束E护盾分支 幂等）
      if (数据.已结束) return;
      // 先置 已结束 再停止位移：停止位移同步触发 位移结束回调，此时必须已标记结束（否则会执行落点冰爆/生成冰晶/消费 D 强化）
      数据.已结束 = true;
      if (数据.位移ID !== 0) 停止位移(数据.位移ID, "中断");
      if (数据.护盾ID !== 0) {
        移除护盾(数据.护盾ID);
        数据.护盾ID = 0;
      }
      if (数据.二段壳 != null) 清理限时二段技能壳(数据.二段壳);
      移除单位指定Buff(施法者, 爱蜜莉雅BuffID.冰晶护身);
      destroyUnitEffect(施法者, 护盾特效键);
    },
  });

  // 护盾系统接管吸收：血条自动显示，破盾由 破碎回调 收口
  数据.护盾ID = 开始护盾(施法者, {
    数值: 护盾值,
    持续时间: 爱蜜莉雅E配置.护盾持续秒,
    来源单位: 施法者,
    显示护盾条: true,
    可驱散: false,
    标签: "爱蜜莉雅E护盾",
    破碎回调: function E破盾(this: void, _单位: any, _护盾ID: number, _吸收伤害: number): void {
      // 破盾收口延迟到伤害结算遍历结束后执行
      addDelayedCallback(0, function E破盾延迟收口(this: void): void {
        结束E护盾分支(施法者, 控制器, 技能实例ID, "破盾");
      });
    },
    结束回调: function E护盾结束(this: void, _单位: any, _护盾ID: number, 原因: string): void {
      // 到期/死亡由护盾系统触发；护盾移除后数据.护盾ID 失效由 收口 分支统一置 0
      if (原因 === "到期" || 原因 === "单位死亡") {
        addDelayedCallback(0, function E到期收口(this: void): void {
          结束E护盾分支(施法者, 控制器, 技能实例ID, 原因 === "到期" ? "自然" : "提前");
        });
      }
    },
  });

  registerManualBuff(施法者, 爱蜜莉雅BuffID.冰晶护身, 爱蜜莉雅E配置.护盾持续秒, 护盾值);
  const 护盾特效 = createUnitEffect(施法者, "origin", 爱蜜莉雅表现配置.护盾.模型路径, 爱蜜莉雅表现配置.护盾.持续秒, 护盾特效键);
  设置特效缩放(护盾特效, 爱蜜莉雅表现配置.护盾.缩放);
  // 护盾展开音：护盾 Buff/护盾系统/护盾特效建立后一次（单位=施法者，参数配置驱动）
  Sound3DII_UnitPlayReuse(爱蜜莉雅音效配置.E护盾展开.路径, 施法者, 爱蜜莉雅音效配置.E护盾展开.裁断距离);

  // 护盾自然到期由护盾系统 结束回调("到期") 收口，这里不再另挂定时器

  // 二段输入壳：护盾期间切换 E 按钮为提前结束（ASE2），护盾结束自动恢复
  数据.二段壳 = 创建限时二段技能壳({
    名称: "冰晶护身·提前结束（E）",
    单位: 施法者,
    一段技能ID: E技能类型ID,
    二段技能ID: stringToFourCCSafe(爱蜜莉雅E配置.二段技能ID),
    持续秒: 爱蜜莉雅E配置.护盾持续秒,
    二段说明:
      "|cffffcc00技能说明：|r提前结束护盾并主动引爆收尾。|n"
      + "|cffffcc00伤害：|r落点冰爆造成攻击力|cff87ceeb80%|r的魔法伤害（与自然结束的破盾冰爆同值）。|n"
      + "|cffffcc00不做任何操作：|r护盾自然到期后同样触发冰爆，按钮自动恢复。",
  });

  // 位移：向目标点冲锋（检查地形；不可达 → 短惩罚冷却）
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 方向 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), 目标X, 目标Y);
  // 起点冰面路径单元（位移路径分段表现，位移结束时由落点层替换/自然消失）
  创建点特效({
    模型路径: 爱蜜莉雅表现配置.冰面路径.模型路径,
   RGB: 爱蜜莉雅表现配置.冰面路径.RGB,
       X: GetUnitX(施法者),
    Y: GetUnitY(施法者),
    Z: 爱蜜莉雅表现配置.冰面路径.高度,
    面向角度: 方向,
    缩放: 爱蜜莉雅表现配置.冰面路径.缩放,
    持续秒: 爱蜜莉雅表现配置.冰面路径.持续秒,
  });
  debugLogForce("爱蜜莉雅-E", "位移", "类型", "冲锋", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(E技能类型ID), "实例", 技能实例ID ?? "-", "X", Math.floor(GetUnitX(施法者)), "Y", Math.floor(GetUnitY(施法者)), "距离", 爱蜜莉雅E配置.位移距离);
  数据.位移ID = 开始冲锋(施法者, {
    距离: 爱蜜莉雅E配置.位移距离,
    每秒速度: 爱蜜莉雅E配置.位移速度,
    角度: 方向,
    检查地形: true,
    朝向跟随位移: true,
    暂停单位: false,
    撞墙回调: function E撞墙(this: void, 单位: any, _位移ID: number): void {
      // 不可达落点：短惩罚冷却（不进完整失败冷却）
      const 最大冷却 = platformAbilityApi.技能_获取技能最大冷却时间(单位, E技能类型ID);
      platformAbilityAction.技能_设置技能冷却时间(单位, E技能类型ID, 爱蜜莉雅E配置.短惩罚冷却秒, 最大冷却);
    },
    结束回调: function E位移结束(this: void, 单位: any, _原因: string, _位移ID: number): void {
      if (数据.已结束) return;
      const 落点X = GetUnitX(单位);
      const 落点Y = GetUnitY(单位);
      // 落点冰爆 + 落点冰晶节点
      施加落点冰爆(施法者, 落点X, 落点Y, 技能实例ID, 读取单位攻击力(施法者) * 爱蜜莉雅E配置.落点冰爆伤害攻击力倍率);
      if (爱蜜莉雅E配置.落点生成冰晶) {
        创建爱蜜莉雅场上冰晶(施法者, "E", 落点X, 落点Y, 爱蜜莉雅E配置.落点冰晶持续秒);
      }
      // D 强化：落点保护脉冲（为附近友军提供较弱护盾）
      if (消费爱蜜莉雅D强化(施法者)) {
        E施加保护脉冲(施法者, 落点X, 落点Y, 技能实例ID);
      }
      数据.位移ID = 0;
    },
  });
  // 冰面位移启动音：冲锋真实启动后一次（提前结束/重复施法收旧分支在上方已返回；单位=施法者，参数配置驱动）
  Sound3DII_UnitPlayReuse(爱蜜莉雅音效配置.E位移.路径, 施法者, 爱蜜莉雅音效配置.E位移.裁断距离);
}

/** D 强化保护脉冲：为落点附近友军施加短时较弱护盾（护盾系统托管，带护盾条） */
function E施加保护脉冲(this: void, 施法者: any, X: number, Y: number, 技能实例ID: number | undefined): void {
  const 护盾值 = 读取单位攻击力(施法者) * 爱蜜莉雅E配置.保护脉冲护盾攻击力倍率;
  const 持续秒 = 爱蜜莉雅E配置.保护脉冲持续秒;
  const 组 = jass.CreateGroup() as any;
  jass.GroupEnumUnitsInRange(组, X, Y, 260, null);
  while (true) {
    const u = jass.FirstOfGroup(组) as any;
    if (u == null || u === 0) break;
    jass.GroupRemoveUnit(组, u);
    if (!单位存活(u)) continue;
    if (!jass.IsUnitAlly(u, jass.GetOwningPlayer(施法者))) continue;
    if (u === 施法者) continue;
    // 每友军一个短时护盾（吸收/到期由护盾系统统一结算）
    开始护盾(u, {
      数值: 护盾值,
      持续时间: 持续秒,
      来源单位: 施法者,
      显示护盾条: true,
      可驱散: false,
      标签: "爱蜜莉雅E保护脉冲",
    });
    registerManualBuff(u, 爱蜜莉雅BuffID.冰晶护身, 持续秒, 护盾值);
  }
  jass.DestroyGroup(组);
  void 技能实例ID;
}

function 释放E二段输入(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0) {
    debugLogForce("爱蜜莉雅-E", "释放被拒", "原因", "施法者无效", "分支", "二段输入");
    return;
  }
  debugLogForce(
    "爱蜜莉雅-E",
    "释放",
    "玩家",
    GetPlayerId(GetOwningPlayer(施法者)) + 1,
    "四码",
    fourCCToStringSafe(E技能类型ID),
    "实例",
    技能实例ID ?? "-",
    "目标",
    "无",
    "分支",
    "二段输入",
  );
  const 活跃列表 = 查询战斗技能实例(施法者, "E护盾");
  for (let i = 0; i < 活跃列表.length; i++) {
    结束E护盾分支(施法者, 活跃列表[i], 技能实例ID, "提前");
    return;
  }
}

export function 注册爱蜜莉雅E(this: void): void {
  debugLogForce("爱蜜莉雅-E", "注册", "名称", "注册爱蜜莉雅E");
  注册单位技能壳监听({
    名称: "爱蜜莉雅-冰晶护身（E）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 爱蜜莉雅技能配置.E.技能ID,
    获取或创建上下文: function E上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放E冰晶护身,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 爱蜜莉雅E配置.护盾持续秒 + 2,
  });
  注册单位技能壳监听({
    名称: "爱蜜莉雅-E二段输入（ASE2）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 爱蜜莉雅E配置.二段技能ID,
    获取或创建上下文: function E二段上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放E二段输入,
    创建独立技能实例: false,
  });
}

export {};
