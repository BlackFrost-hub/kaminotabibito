/** @noSelfInFile */

import {
  朱雀院椿技能配置,
  朱雀院椿表现配置,
  朱雀院椿动作配置,
  朱雀院椿动作槽,
  朱雀院椿R配置,
  朱雀院椿读条配置,
  朱雀院椿音效配置,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 开始充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
};
const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 获取扇形区域单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域") as {
  获取扇形区域单位: (this: void, 参数: any) => any[];
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { Sound3DII_UnitPlayReuse, Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
const {
  是朱雀院椿,
  获取姿态,
  锁定姿态,
  恢复VF,
  扣除VF,
  播放椿动作,
  有决斗距离,
  获取决斗距离方向,
  清除决斗距离,
} = require("./02．被动效果") as {
  是朱雀院椿: (this: void, unit: any) => boolean;
  获取姿态: (this: void, 英雄: any) => string;
  锁定姿态: (this: void, 英雄: any, 锁定: boolean) => void;
  恢复VF: (this: void, 英雄: any, 量: number) => boolean;
  扣除VF: (this: void, 英雄: any, 量: number) => number;
  播放椿动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
  有决斗距离: (this: void, 英雄: any) => boolean;
  获取决斗距离方向: (this: void, 英雄: any) => number;
  清除决斗距离: (this: void, 英雄: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院椿技能配置.单位类型ID);
const R技能ID = stringToFourCCSafe(朱雀院椿技能配置.R.技能ID);
const R配置 = 朱雀院椿R配置;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;

//=============================================================================
// R 蓄力状态（W 禁止重复开启；D 姿态锁）
//=============================================================================

const 蓄力中表: Record<number, boolean | undefined> = {};

/** W 检查：R 蓄力期间禁止开启 W */
export function 椿R蓄力中(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  return 蓄力中表[jass.GetHandleId(英雄)] === true;
}

//=============================================================================
// 终式（仅充能完成回调创建；中断/死亡不结算，资源不白扣）
//=============================================================================

function 结算R伤害(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined, 伤害值: number, 标签: string): void {
  造成技能伤害({
    来源: 施法者,
    目标,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_NORMAL,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: R技能ID,
    技能实例ID,
    标签,
    伤害形态: "AOE",
    参与技能伤害加成: true,
  });
}

function R创建终式(
  this: void,
  施法者: any,
  技能实例ID: number | undefined,
  方向角: number,
  受击记录: boolean,
): void {
  if (!单位存活(施法者)) return;
  debugLogForce("椿-R", "伤害", "标签", "朱雀院椿-R终式", "数值", 读取单位攻击力(施法者) * R配置.主斩倍率);
  const 攻击力 = 读取单位攻击力(施法者);
  const 姿态 = 获取姿态(施法者);
  播放椿动作(施法者, 姿态 === "二刀" ? 朱雀院椿动作槽.R二刀释放 : 朱雀院椿动作槽.R一刀释放);
  const 敌人 = 获取扇形区域单位({
    X: GetUnitX(施法者),
    Y: GetUnitY(施法者),
    半径: R配置.距离,
    方向角,
    扇形角度: 姿态 === "二刀" ? R配置.二刀扇形角度 : R配置.一刀窄线角度,
    单位筛选: function R扇形筛选(this: void, 单位: any): boolean {
      return 单位 !== 施法者 && 单位存活(单位) && jass.IsUnitEnemy(单位, jass.GetOwningPlayer(施法者));
    },
  });
  // 主斩
  for (let i = 0; i < 敌人.length; i++) {
    结算R伤害(施法者, 敌人[i], 技能实例ID, 攻击力 * R配置.主斩倍率, "朱雀院椿-R主斩");
  }
  if ((朱雀院椿表现配置.R主斩.模型路径 as string) !== "") {
    创建点特效({
      模型路径: 朱雀院椿表现配置.R主斩.模型路径,
      RGB: 朱雀院椿表现配置.R主斩.RGB,
      X: GetUnitX(施法者),
      Y: GetUnitY(施法者),
      Z: 朱雀院椿表现配置.R主斩.高度,
      面向角度: 方向角,
      动画索引: 0,
      缩放: 朱雀院椿表现配置.R主斩.缩放,
      // death 1000-3000（2s）：必须覆盖完整 Death，否则严重截断
      持续秒: 朱雀院椿表现配置.R主斩.持续秒,
    });
  }
  // 一刀守势受击分支：主斩前/同时追加反击斩并恢复 VF（蓄势期间承受过一次攻击）
  if (姿态 === "一刀" && 受击记录) {
    for (let i = 0; i < 敌人.length; i++) {
      结算R伤害(施法者, 敌人[i], 技能实例ID, 攻击力 * R配置.反击斩倍率, "朱雀院椿-R后之先反击");
    }
    恢复VF(施法者, R配置.一刀受击恢复VF);
  }
  // 二刀攻势分支：交错斩追加 + VF 代价
  if (姿态 === "二刀") {
    扣除VF(施法者, R配置.二刀VF代价);
    for (let i = 0; i < 敌人.length; i++) {
      结算R伤害(施法者, 敌人[i], 技能实例ID, 攻击力 * R配置.二刀交错倍率, "朱雀院椿-R交错斩");
    }
    if ((朱雀院椿表现配置.R交错斩.模型路径 as string) !== "") {
      创建点特效({
        模型路径: 朱雀院椿表现配置.R交错斩.模型路径,
        RGB: 朱雀院椿表现配置.R交错斩.RGB,
        X: GetUnitX(施法者),
        Y: GetUnitY(施法者),
        Z: 朱雀院椿表现配置.R交错斩.高度,
        面向角度: 方向角,
        动画索引: 0,
        缩放: 朱雀院椿表现配置.R交错斩.缩放,
        // death 0-333ms，短促播放
        持续秒: 朱雀院椿表现配置.R交错斩.持续秒,
      });
    }
    // 二刀交错斩音（R 二刀交错分支成立时；坐标=施法者位置，参数配置驱动）
    Sound3DII_CooPlayReuse(朱雀院椿音效配置.二刀交错.路径, GetUnitX(施法者), GetUnitY(施法者), 朱雀院椿音效配置.二刀交错.高度, 朱雀院椿音效配置.二刀交错.裁断距离);
  }
}

//=============================================================================
// R 施法：炎姬蓄势（通用充能）
//=============================================================================

function 释放R炎姬(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  debugLogForce("椿-R", "释放", "技能实例ID", 技能实例ID ?? "-");
  if (!是朱雀院椿(施法者)) return;
  // 禁止并行两个终式
  if (蓄力中表[jass.GetHandleId(施法者)] === true) return;
  播放椿动作(施法者, 朱雀院椿动作槽.R蓄力);
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 方向角 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), 目标X, 目标Y);
  // R 蓄力期间锁定姿态（D 不得中途改写本次 R 分支）
  锁定姿态(施法者, true);
  蓄力中表[jass.GetHandleId(施法者)] = true;
  debugLogForce("椿-R", "状态", "蓄力开始", 技能实例ID ?? "-");
  // 释放前快照决斗距离（蓄力 0.7s 期间可能过期，联动按释放时快照消费，不依赖完成时再查）
  const 决斗距离快照 = { 有效: 有决斗距离(施法者), 方向: 获取决斗距离方向(施法者) };
  // 一刀守势受击记录：蓄势期间承受一次符合条件攻击 → 后之先·炎姬分支
  let 受击记录 = false;
  let 受击修改器ID = 0;
  if (获取姿态(施法者) === "一刀") {
    受击修改器ID = registerDamageModifier(function R受击记录(this: void, context: any): number {
      // 只记录有效攻击：正伤害 + 非自身敌对来源（环境/友军伤害不计入后之先）
      if (context.target !== 施法者) return context.currentDamage;
      if (context.currentDamage <= 0) return context.currentDamage;
      if (context.attacker == null || context.attacker === 0 || context.attacker === 施法者) return context.currentDamage;
      if (!jass.IsUnitEnemy(context.attacker, jass.GetOwningPlayer(施法者))) return context.currentDamage;
      if (受击记录) return context.currentDamage;
      受击记录 = true;
      return context.currentDamage; // 只记录，不化解（VF 正常吸收）
    }, 50);
  }
    // 蓄力预警（候选未迁入则留空；常驻句柄由充能结束回调统一销毁）
    let 预警特效: any = null;
    const 充能ID = 开始充能(施法者, {
      持续时间: R配置.蓄力秒,
      指令中断: true,
      世界坐标进度UI: true,
      世界坐标进度UI类型: 朱雀院椿读条配置.UI类型,
      世界坐标进度UI标题: "炎姬·黄泉凤凰",
      世界坐标进度UI数值后缀: "",
      世界坐标进度UI高度偏移: 朱雀院椿读条配置.跟随Z偏移,
      显示进度条特效: false,
      开始回调: function R蓄力开始(this: void, _单位: any, _充能ID: number): void {
        // 蓄力建立音（充能真正建立时一次；单位绑定，参数配置驱动）
        Sound3DII_UnitPlayReuse(朱雀院椿音效配置.R蓄力.路径, 施法者, 朱雀院椿音效配置.R蓄力.裁断距离);
        if (朱雀院椿表现配置.R蓄力提示.模型路径 != null && 朱雀院椿表现配置.R蓄力提示.模型路径 !== "") {
          预警特效 = 创建点特效({
            模型路径: 朱雀院椿表现配置.R蓄力提示.模型路径,
            RGB: 朱雀院椿表现配置.R蓄力提示.RGB,
            X: 目标X,
            Y: 目标Y,
            Z: 朱雀院椿表现配置.R蓄力提示.高度,
            缩放: 朱雀院椿表现配置.R蓄力提示.缩放,
            持续秒: 朱雀院椿表现配置.R蓄力提示.持续秒,
          });
        }
      },
    // 蓄力完成：创建终式（被打断/死亡不会走到这里）
    充能完成回调: function R蓄力完成(this: void, _单位: any, _充能ID: number): void {
      // 黄泉凤凰终式释放音（充能完成结算点；坐标=施法者位置，参数配置驱动）
      Sound3DII_CooPlayReuse(朱雀院椿音效配置.R终式.路径, GetUnitX(施法者), GetUnitY(施法者), 朱雀院椿音效配置.R终式.高度, 朱雀院椿音效配置.R终式.裁断距离);
      // 决斗距离优先：E 建立的短时距离窗口提供精确方向（按释放前快照消费）
      const 终式方向 = 决斗距离快照.有效 ? 决斗距离快照.方向 : 方向角;
      if (决斗距离快照.有效) 清除决斗距离(施法者);
      R创建终式(施法者, 技能实例ID, 终式方向, 受击记录);
    },
    // 蓄力结束（完成/指令中断/硬控/死亡/单位失效统一收尾）
    结束回调: function R蓄力结束(this: void, _单位: any, _原因: string, _充能ID: number): void {
      debugLogForce("椿-R", "结束", "原因", _原因 ?? "-");
      if (预警特效 != null && 预警特效 !== 0) {
        jass.DestroyEffect(预警特效);
        预警特效 = null;
      }
      if (受击修改器ID !== 0) {
        unregisterDamageModifier(受击修改器ID);
        受击修改器ID = 0;
      }
      蓄力中表[jass.GetHandleId(施法者)] = false;
      锁定姿态(施法者, false);
    },
  });
  // 技能喊话在充能真正建立后播放（蓄力被拒/中断不播）
  if (充能ID > 0) 播放英雄技能喊话(施法者, "朱雀院椿", 朱雀院椿技能配置.R.技能ID);
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册朱雀院椿R(this: void): void {
  debugLogForce("椿-R", "注册", "名称", "注册朱雀院椿R");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "朱雀院椿-炎姬·黄泉凤凰（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "ATR1",
    获取或创建上下文: function R上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放R炎姬,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: R配置.蓄力秒 + 1,
  });
}

export const 朱雀院椿R模块 = {
  技能ID: 朱雀院椿技能配置.R.技能ID,
  蓄力秒: R配置.蓄力秒,
  世界坐标读条: 朱雀院椿读条配置,
  注册: 注册朱雀院椿R,
} as const;
