/** @noSelfInFile */

import {
  朱雀院红叶技能配置,
  朱雀院红叶表现配置,
  朱雀院红叶音效配置,
  朱雀院红叶动作配置,
  朱雀院红叶动作槽,
  朱雀院红叶待平衡数值,
  朱雀院红叶读条配置,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe, fourCCToStringSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
  fourCCToStringSafe: (this: void, fourcc: number) => string;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 开始充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
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
  施加朱雀院破绽,
  消费全部刀势,
  是朱雀院红叶,
  播放红叶动作,
} = require("./02．被动效果") as {
  施加朱雀院破绽: (this: void, 红叶: any, 目标: any) => void;
  消费全部刀势: (this: void, 英雄: any) => number;
  是朱雀院红叶: (this: void, unit: any) => boolean;
  播放红叶动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
};
const { 读取最近剑痕并锁定 } = require("./05．E技能") as {
  读取最近剑痕并锁定: (this: void, 英雄: any) => any;
};
const {
  消费全部D强化,
  结束D秘传,
} = require("./07．D技能") as {
  消费全部D强化: (this: void, 英雄: any) => number;
  结束D秘传: (this: void, 英雄: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院红叶技能配置.单位类型ID);
const R技能ID = stringToFourCCSafe(朱雀院红叶技能配置.R.技能ID);
const R配置 = 朱雀院红叶待平衡数值.R;
const R蓄势音效 = 朱雀院红叶音效配置.R蓄势;
const R红叶一闪音效 = 朱雀院红叶音效配置.R红叶一闪;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;

//=============================================================================
// 终式（仅充能完成回调创建；中断/死亡不会走到这里，资源不白扣）
//=============================================================================

function 取窄线敌人(this: void, 施法者: any, 方向角: number): any[] {
  return 获取扇形区域单位({
    X: GetUnitX(施法者),
    Y: GetUnitY(施法者),
    半径: R配置.距离,
    方向角,
    扇形角度: R配置.窄线角度,
    单位筛选: function R窄线筛选(this: void, 单位: any): boolean {
      return 单位 !== 施法者 && 单位存活(单位) && jass.IsUnitEnemy(单位, jass.GetOwningPlayer(施法者));
    },
  });
}

function 结算R伤害(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined, 伤害值: number, 标签: string): void {
  debugLogForce("红叶-R", "伤害", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "目标", GetUnitName(目标), "handle", 目标, "X", Math.floor(GetUnitX(目标)), "Y", Math.floor(GetUnitY(目标)), "伤害", Math.floor(伤害值), "标签", 标签, "实例", 技能实例ID ?? "-");
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
    伤害形态: "单体",
    参与技能伤害加成: true,
  });
}

function R创建终式(this: void, 施法者: any, 技能实例ID: number | undefined, _目标X: number, 目标Y: number, 方向角: number): void {
  if (!单位存活(施法者)) {
    debugLogForce("红叶-R", "命中失败", "目标无效", "施法者已死亡");
    return;
  }
  debugLogForce("红叶-R", "状态", "创建终式", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(R技能ID), "实例", 技能实例ID ?? "-", "施法者X", Math.floor(GetUnitX(施法者)), "施法者Y", Math.floor(GetUnitY(施法者)), "方向角", 方向角);
  播放红叶动作(施法者, 朱雀院红叶动作槽.R释放);
  // 资源消费只在真正进入终式时（蓄力完成）：刀势全消费、D 全消费（失败/中断不白扣）
  const 刀势层数 = 消费全部刀势(施法者);
  const D次数 = 消费全部D强化(施法者);
  if (D次数 > 0) 结束D秘传(施法者);
  const 攻击力 = 读取单位攻击力(施法者);
  // 主斩伤害：D 强化按剩余次数加成
  const 主斩伤害 = 攻击力 * (R配置.主斩攻击力倍率 + D次数 * R配置.D强化每次加成);
  const 敌人 = 取窄线敌人(施法者, 方向角);
  for (let i = 0; i < 敌人.length; i++) {
    结算R伤害(施法者, 敌人[i], 技能实例ID, 主斩伤害, "朱雀院红叶-R主斩");
    施加朱雀院破绽(施法者, 敌人[i]);
  }
  // 主斩表现（模型路径/缩放/高度/持续秒/RGB 全由表现配置驱动）
  if ((朱雀院红叶表现配置.R主斩.模型路径 as string) !== "") {
    debugLogForce("红叶-R", "特效", "路径", 朱雀院红叶表现配置.R主斩.模型路径 as string);
    创建点特效({
      模型路径: 朱雀院红叶表现配置.R主斩.模型路径,
      RGB: 朱雀院红叶表现配置.R主斩.RGB,
      X: GetUnitX(施法者),
      Y: GetUnitY(施法者),
      Z: 朱雀院红叶表现配置.R主斩.高度,
      面向角度: 方向角,
      缩放: 朱雀院红叶表现配置.R主斩.缩放,
      持续秒: 朱雀院红叶表现配置.R主斩.持续秒,
    });
  }
  // 刀势回响：层数与回响数量一一对应（最多 3 道；全部归属本次 R 实例）
  for (let 层 = 0; 层 < 刀势层数 && 层 < 3; 层++) {
    for (let i = 0; i < 敌人.length; i++) {
      结算R伤害(施法者, 敌人[i], 技能实例ID, 攻击力 * R配置.刀势回响攻击力倍率, "朱雀院红叶-R刀势回响");
    }
  }
  // 剑痕回响：读取最近一条有效 E 剑痕并立即锁定，沿剑痕方向追加一道回响
  const 剑痕 = 读取最近剑痕并锁定(施法者);
  if (剑痕 != null) {
    for (let i = 0; i < 敌人.length; i++) {
      结算R伤害(施法者, 敌人[i], 技能实例ID, 攻击力 * R配置.剑痕回响攻击力倍率, "朱雀院红叶-R剑痕回响");
    }
    void 剑痕;
  }
}

//=============================================================================
// R 施法：蓄力（通用充能）
//=============================================================================

function 释放R奥义(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  debugLogForce("红叶-R", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(R技能ID), "实例", 技能实例ID ?? "-", "目标", "点施放", "施法者X", Math.floor(GetUnitX(施法者)), "施法者Y", Math.floor(GetUnitY(施法者)), "目标X", Math.floor(GetSpellTargetX()), "目标Y", Math.floor(GetSpellTargetY()));
  if (!是朱雀院红叶(施法者)) {
    debugLogForce("红叶-R", "释放被拒", "原因", "非红叶单位", "施法者", 施法者);
    return;
  }
  播放红叶动作(施法者, 朱雀院红叶动作槽.R蓄力);
  const 中心X = GetSpellTargetX();
  const 中心Y = GetSpellTargetY();
  const 方向角 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), 中心X, 中心Y);
    // 蓄力预警法阵（候选未迁入则留空不播；常驻句柄由充能结束回调统一销毁，避免与自带计时器双销毁）
    let 预警特效: any = null;
    const 充能ID = 开始充能(施法者, {
      持续时间: R配置.蓄力秒,
      指令中断: true,
      世界坐标进度UI: true,
      世界坐标进度UI类型: 朱雀院红叶读条配置.UI类型,
      世界坐标进度UI标题: "奥义·红叶一闪",
      世界坐标进度UI数值后缀: 朱雀院红叶读条配置.数值后缀,
      世界坐标进度UI高度偏移: 朱雀院红叶读条配置.跟随Z偏移,
      显示进度条特效: false,
      开始回调: function R蓄力开始(this: void, _单位: any, _充能ID: number): void {
        // 蓄势音（充能真正建立时一次；单位绑定，参数配置驱动）
        Sound3DII_UnitPlayReuse(R蓄势音效.路径, 施法者, R蓄势音效.裁断距离);
        if (朱雀院红叶表现配置.R蓄力提示.模型路径 != null && 朱雀院红叶表现配置.R蓄力提示.模型路径 !== "") {
          预警特效 = 创建点特效({
            模型路径: 朱雀院红叶表现配置.R蓄力提示.模型路径,
            RGB: 朱雀院红叶表现配置.R蓄力提示.RGB,
            X: 中心X,
            Y: 中心Y,
            Z: 朱雀院红叶表现配置.R蓄力提示.高度,
            缩放: 朱雀院红叶表现配置.R蓄力提示.缩放,
            持续秒: 朱雀院红叶表现配置.R蓄力提示.持续秒,
          });
        }
      },
    // 蓄力完成：创建终式（被打断/死亡不会走到这里）
    充能完成回调: function R蓄力完成(this: void, _单位: any, _充能ID: number): void {
      debugLogForce("红叶-R", "状态", "蓄力完成", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
      // 红叶一闪释放音（蓄力完成释放结算点；坐标=施法者/直线起点，参数配置驱动）
      Sound3DII_CooPlayReuse(R红叶一闪音效.路径, GetUnitX(施法者), GetUnitY(施法者), R红叶一闪音效.高度, R红叶一闪音效.裁断距离);
      R创建终式(施法者, 技能实例ID, 中心X, 中心Y, 方向角);
    },
    // 蓄力结束（完成/被打断/死亡统一销毁常驻预警特效）
    结束回调: function R蓄力结束(this: void, _单位: any, _原因: string, _充能ID: number): void {
      debugLogForce("红叶-R", "结束", "原因", "-", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
      if (预警特效 != null && 预警特效 !== 0) {
        jass.DestroyEffect(预警特效);
        预警特效 = null;
      }
    },
  });
  // 技能喊话在充能真正建立后播放（蓄力被拒/中断不播；随机二选一由喊话系统驱动）
  if (充能ID > 0) 播放英雄技能喊话(施法者, "朱雀院红叶", 朱雀院红叶技能配置.R.技能ID);
  else debugLogForce("红叶-R", "释放被拒", "原因", "蓄力未建立", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册朱雀院红叶R(this: void): void {
  debugLogForce("红叶-R", "注册", "名称", "R", "函数", "注册朱雀院红叶R");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "朱雀院红叶-奥义·红叶一闪（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "AMR1",
    获取或创建上下文: function R上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放R奥义,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: R配置.蓄力秒 + 1,
  });
}

export const 朱雀院红叶R模块 = {
  技能ID: 朱雀院红叶技能配置.R.技能ID,
  蓄力秒: R配置.蓄力秒,
  世界坐标读条: 朱雀院红叶读条配置,
  注册: 注册朱雀院红叶R,
} as const;
