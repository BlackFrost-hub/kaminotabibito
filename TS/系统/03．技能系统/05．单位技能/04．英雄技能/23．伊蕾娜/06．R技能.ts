/** @noSelfInFile */
/**
 * 伊蕾娜 - R：灰之魔女·万法回廊（A7）
 *
 * - t0 快照目标点/方向/最多 3 条见闻/当前变式；所有伤害归同一个 R 技能实例。
 * - 充能走通用 开始充能：指令中断 true、内置硬控与死亡中断；不传关闭指令中断的强制硬直；
 *   世界坐标进度 UI 跟随施法者（Z 偏移读条配置），模型进度条按读条配置关闭。
 * - 中断/死亡路径：清理预警视觉、还原未消费的变式锁定，不创建领域、不消费见闻/变式。
 * - 完成回调内才执行主范围结算并创建持续领域（自然到期触发收束视觉与实例完成）；
 *   打断/死亡/场景清理手动销毁领域时置标志，禁止误触最终收束。
 * - 见闻快照按记录顺序最多读取 3 条：风行→贯穿魔弹；镜界→中心回响冲击+自身护盾；远行→
 *   领域边缘延迟冲击。同类型只强化一次，变式灰烬快照在主效果后追加一次阵心小爆发。
 */

import {
  伊蕾娜技能配置,
  伊蕾娜R配置,
  伊蕾娜读条配置,
  伊蕾娜表现配置,
  伊蕾娜模型动作配置,
  伊蕾娜音效配置,
} from "./00．配置";
import { 播放伊蕾娜阶段动作 } from "./01A．动作表现";
import type { 伊蕾娜见闻 } from "./02．被动效果";
import type { 伊蕾娜变式类型 } from "./02．被动效果";
import {
  查询伊蕾娜见闻,
  锁定伊蕾娜R变式,
  消费伊蕾娜R锁定变式,
  还原伊蕾娜R锁定变式,
  登记伊蕾娜技能清理,
} from "./02．被动效果";
import type { 战斗技能实例控制器 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";

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
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例, 查询战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => 战斗技能实例控制器;
  查询战斗技能实例: (this: void, 单位: any, 技能键?: string) => 战斗技能实例控制器[];
};
const { 开始充能, 停止充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
  停止充能: (this: void, 充能ID: number) => boolean;
};
const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const {
  读取单位攻击力,
  两点角度,
  单位存活,
  极坐标X,
  极坐标Y,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  单位存活: (this: void, unit: any) => boolean;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { 获取坐标范围敌人 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  /** 注意：公共实现为 (中心来源单位, X, Y, 半径) */
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (this: void, sourceUnit: any, u: any, attackSlow: number, moveSlow: number, time: number, effectSourceName?: string, effectSourceType?: string) => void;
};
const { 开始护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统") as {
  开始护盾: (this: void, 单位: any, 参数: any) => number;
};
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = 伊蕾娜技能配置.单位类型ID;
const R技能类型ID = stringToFourCCSafe(伊蕾娜技能配置.R.技能ID) as number;
const R技能键 = "R万法回廊";

/** R 实例数据（t0 快照 + 领域收束状态）。必须用真实类型：any 上的 .length 会编译成原始字段访问。 */
interface R领域数据 {
  技能实例ID: number | undefined;
  中心X: number;
  中心Y: number;
  方向角: number;
  见闻快照: 伊蕾娜见闻[];
  变式快照: 伊蕾娜变式类型 | null;
  领域已手动销毁: boolean;
}

function 计算范围表现缩放(this: void, 半径: number, 表现: { readonly 基准半径: number; readonly 基准缩放: number }): number {
  return 半径 / 表现.基准半径 * 表现.基准缩放;
}

//=============================================================================
// 结算辅助
//=============================================================================

function R技能伤害(
  this: void,
  施法者: any,
  目标: any,
  伤害值: number,
  数据: R领域数据,
  标签: string,
): boolean {
  return 造成技能伤害({
    来源: 施法者,
    目标,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: R技能类型ID,
    技能实例ID: 数据.技能实例ID,
    标签,
    伤害形态: "AOE",
    参与技能伤害加成: true,
  });
}

function 范围爆发(
  this: void,
  施法者: any,
  X: number,
  Y: number,
  半径: number,
  倍率: number,
  数据: R领域数据,
  标签: string,
): void {
  const 敌人列表 = 获取坐标范围敌人(施法者, X, Y, 半径);
  const 伤害 = 读取单位攻击力(施法者) * 倍率;
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!单位存活(敌人)) {
      debugLogForce("伊蕾娜-R", "命中失败", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "原因", "目标无效", "目标", GetUnitName(敌人), "handle", 敌人);
      continue;
    }
    debugLogForce("伊蕾娜-R", "命中", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(R技能类型ID), "目标", GetUnitName(敌人), "handle", 敌人, "X", Math.floor(GetUnitX(敌人)), "Y", Math.floor(GetUnitY(敌人)), "伤害", Math.floor(伤害), "标签", 标签);
    R技能伤害(施法者, 敌人, 伤害, 数据, 标签);
  }
}

//=============================================================================
// 见闻追加阶段（快照顺序，每类最多一次）
//=============================================================================

function 执行见闻追加(this: void, 施法者: any, 实例: 战斗技能实例控制器, 数据: R领域数据): void {
  const 已用类型: Record<string, boolean | undefined> = {};
  for (let i = 0; i < 数据.见闻快照.length; i++) {
    const 记录: 伊蕾娜见闻 = 数据.见闻快照[i];
    if (已用类型[记录.类型]) continue; // 同类型只强化一次
    已用类型[记录.类型] = true;
    debugLogForce("伊蕾娜-R", "见闻追加", "类型", 记录.类型, "序号", 记录.序号, "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);

    if (记录.类型 === "风行") {
      // 风行追加：领域期间每 tick 从阵心向 4 方向（90° 间隔，起始角逐轮旋转）发射贯穿魔弹
      const 发射一轮风行弹幕 = function R风行弹幕(this: void, 轮次: number): void {
        // 追加弹发射音（坐标=发射点=阵心；每轮弹幕各播一次，参数配置驱动）
        Sound3DII_CooPlayReuse(伊蕾娜音效配置.R追加弹.路径, 数据.中心X, 数据.中心Y, 伊蕾娜音效配置.R追加弹.高度, 伊蕾娜音效配置.R追加弹.裁断距离);
        for (let 方向序号 = 0; 方向序号 < 4; 方向序号++) {
          发射弹道({
            名称: "伊蕾娜-万法回廊·追迹",
            所有者: 施法者,
            发射X: 数据.中心X,
            发射Y: 数据.中心Y,
            发射方向角: 数据.方向角 + 轮次 * 伊蕾娜R配置.追加弹幕旋转角步长 + 方向序号 * 90,
            速度: 伊蕾娜R配置.追加魔弹速度,
            轨迹: { 类型: "直线", 距离: 伊蕾娜R配置.追加魔弹穿透距离 },
            命中半径: 120,
            影响目标: "敌方",
            碰撞消失: false,
            每单位最大命中次数: 1,
            最大总命中次数: 伊蕾娜R配置.追加魔弹最大命中数,
            伤害值: 读取单位攻击力(施法者) * 伊蕾娜R配置.追加魔弹伤害攻击力倍率,
            伤害类型: DAMAGE_TYPE_MAGIC,
            攻击类型: ATTACK_TYPE_NORMAL,
            武器类型: WEAPON_TYPE_WHOKNOWS,
            来源类型: "单位技能",
            技能ID: R技能类型ID,
            技能实例ID: 数据.技能实例ID,
            技能标签: "伊蕾娜-万法回廊·追迹",
            伤害形态: "AOE",
            参与技能伤害加成: false,
            模型: 伊蕾娜表现配置.R追加魔弹.模型路径,
            RGB: 伊蕾娜表现配置.R追加魔弹.RGB,
            缩放: 伊蕾娜表现配置.R追加魔弹.缩放,
            飞行高度: 伊蕾娜表现配置.R追加魔弹.高度,
            生命周期: 伊蕾娜R配置.追加魔弹穿透距离 / 伊蕾娜R配置.追加魔弹速度 + 0.5,
            实例控制器: 实例,
          });
        }
      };
      发射一轮风行弹幕(0);
      let 弹幕轮次 = 1;
      // 弹幕轮次与领域同生命周期：领域持续秒内每秒一轮，实例收束时随篮子一并注销
      实例.登记周期回调(addPeriodicCallback(伊蕾娜R配置.领域脉冲间隔秒 * 1000, function R风行弹幕Tick(this: void): void {
        if (!实例.仍有效() || 弹幕轮次 >= 伊蕾娜R配置.领域持续秒) return;
        发射一轮风行弹幕(弹幕轮次);
        弹幕轮次 = 弹幕轮次 + 1;
      }));
    } else if (记录.类型 === "镜界") {
      // 回响冲击 + 自身短护盾（不叠加完整 W）
      范围爆发(施法者, 数据.中心X, 数据.中心Y, 伊蕾娜R配置.镜界回响冲击半径, 伊蕾娜R配置.镜界回响伤害攻击力倍率, 数据, "伊蕾娜-万法回廊·镜界");
      开始护盾(施法者, {
        类型: 0,
        数值: 读取单位攻击力(施法者) * 伊蕾娜R配置.镜界回响护盾攻击力倍率,
        持续时间: 伊蕾娜R配置.镜界回响护盾秒,
        来源单位: 施法者,
        标签: "伊蕾娜-万法回廊镜界",
        显示护盾条: true,
      });
    } else {
      // 远行：领域边缘延迟冲击（延迟窗口属于本实例，收束即取消）
      const 边缘X = 极坐标X(数据.中心X, 数据.方向角, 伊蕾娜R配置.领域半径);
      const 边缘Y = 极坐标Y(数据.中心Y, 数据.方向角, 伊蕾娜R配置.领域半径);
      const 预示表现 = 伊蕾娜表现配置.R远行预示;
      const 预示 = 创建点特效({
        模型路径: 预示表现.模型路径,
        RGB: 预示表现.RGB,
        X: 边缘X,
        Y: 边缘Y,
        Z: 预示表现.高度,
        缩放: 计算范围表现缩放(伊蕾娜R配置.远行边缘冲击半径, 预示表现),
        持续秒: 预示表现.持续秒,
      });
      void 预示;
      const 延迟ID = addDelayedCallback(伊蕾娜R配置.远行边缘延迟秒 * 1000, function R远行边缘爆发(this: void): void {
        if (!实例.仍有效()) return; // 收束/死亡后不再结算
        范围爆发(施法者, 边缘X, 边缘Y, 伊蕾娜R配置.远行边缘冲击半径, 伊蕾娜R配置.远行边缘伤害攻击力倍率, 数据, "伊蕾娜-万法回廊·远行");
        const 爆发表现 = 伊蕾娜表现配置.R远行爆发;
        const 星爆 = 创建点特效({
          模型路径: 爆发表现.模型路径,
          RGB: 爆发表现.RGB,
          X: 边缘X,
          Y: 边缘Y,
          Z: 爆发表现.高度,
          缩放: 计算范围表现缩放(伊蕾娜R配置.远行边缘冲击半径, 爆发表现),
          持续秒: 爆发表现.持续秒,
        });
        void 星爆;
      });
      实例.登记延迟回调(延迟ID);
    }
  }
}

//=============================================================================
// 主结算与领域
//=============================================================================

function 执行R完成结算(this: void, 施法者: any, 实例: 战斗技能实例控制器, 数据: R领域数据): void {
  debugLogForce("伊蕾娜-R", "结束", "原因", "完成", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "实例", 数据.技能实例ID ?? "-", "X", Math.floor(数据.中心X), "Y", Math.floor(数据.中心Y));
  // 主范围结算（AOE + 真实减速）
  const 敌人列表 = 获取坐标范围敌人(施法者, 数据.中心X, 数据.中心Y, 伊蕾娜R配置.领域半径);
  const 主伤害 = 读取单位攻击力(施法者) * 伊蕾娜R配置.主伤害攻击力倍率;
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!单位存活(敌人)) {
      debugLogForce("伊蕾娜-R", "命中失败", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "原因", "目标无效", "目标", GetUnitName(敌人), "handle", 敌人);
      continue;
    }
    debugLogForce("伊蕾娜-R", "命中", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(R技能类型ID), "目标", GetUnitName(敌人), "handle", 敌人, "X", Math.floor(GetUnitX(敌人)), "Y", Math.floor(GetUnitY(敌人)), "伤害", Math.floor(主伤害), "标签", "伊蕾娜-万法回廊");
    R技能伤害(施法者, 敌人, 主伤害, 数据, "伊蕾娜-万法回廊");
    SFB_setSlow(
      施法者,
      敌人,
      0,
      伊蕾娜R配置.主减速比例,
      伊蕾娜R配置.主减速秒,
      "伊蕾娜-回廊减速",
      "技能",
    );
  }

  // 阵心爆发表现
  const 阵心表现 = 伊蕾娜表现配置.R阵心爆发;
  const 阵心 = 创建点特效({
    模型路径: 阵心表现.模型路径,
    RGB: 阵心表现.RGB,
    X: 数据.中心X,
    Y: 数据.中心Y,
    Z: 阵心表现.高度,
    缩放: 计算范围表现缩放(伊蕾娜R配置.领域半径, 阵心表现),
    持续秒: 阵心表现.持续秒,
  });
  void 阵心;
  // 阵心爆发音（坐标=阵心；充能完成主结算爆发一次，参数配置驱动）
  Sound3DII_CooPlayReuse(伊蕾娜音效配置.R爆发.路径, 数据.中心X, 数据.中心Y, 伊蕾娜音效配置.R爆发.高度, 伊蕾娜音效配置.R爆发.裁断距离);

  // 变式分支：灰烬快照 → 阵心小范围额外爆发；镜界快照在下方见闻阶段已有回响时不重复
  if (数据.变式快照 === "灰烬") {
    // 灰烬余烬视觉（dustwave 尘浪；与 Q/E 灰烬爆发共用同一表现条目）
    const 余烬特效 = 创建点特效({
      模型路径: 伊蕾娜表现配置.灰烬爆发.模型路径,
      RGB: 伊蕾娜表现配置.灰烬爆发.RGB,
      X: 数据.中心X,
      Y: 数据.中心Y,
      Z: 伊蕾娜表现配置.灰烬爆发.高度,
      缩放: 伊蕾娜表现配置.灰烬爆发.缩放,
      持续秒: 伊蕾娜表现配置.灰烬爆发.持续秒,
    });
    void 余烬特效;
    范围爆发(施法者, 数据.中心X, 数据.中心Y, 伊蕾娜R配置.领域半径 * 0.4, 伊蕾娜R配置.主伤害攻击力倍率 * 0.3, 数据, "伊蕾娜-灰烬余烬");
  }
  // 只有灰烬对 R 受益并消费；迅行/镜界完成 R 后还原，避免无收益白扣。
  if (数据.变式快照 === "灰烬") 消费伊蕾娜R锁定变式(施法者);
  else 还原伊蕾娜R锁定变式(施法者);

  // 见闻追加阶段
  执行见闻追加(施法者, 实例, 数据);

  // 持续领域：自然到期触发收束；手动销毁（中断/死亡/场景）只静默移除
  const 领域表现 = 伊蕾娜表现配置.R持续领域;
  const 领域缩放 = 计算范围表现缩放(伊蕾娜R配置.领域半径, 领域表现);
  数据.领域已手动销毁 = false;
  const 领域 = 创建持续危险区域({
    X: 数据.中心X,
    Y: 数据.中心Y,
    半径: 伊蕾娜R配置.领域半径,
    持续时间: 伊蕾娜R配置.领域持续秒,
    检测间隔: 伊蕾娜R配置.领域脉冲间隔秒,
    影响目标: "敌方",
    所有者: 施法者,
    模型路径: 领域表现.模型路径,
    特效高度: 领域表现.高度,
    特效缩放: 领域缩放,
    显示提示圈: false,
    on周期: function R领域脉冲(this: void, 区域内单位: any[], _上下文?: number): void {
      if (!实例.仍有效()) return;
      const 脉冲伤害 = 读取单位攻击力(施法者) * 伊蕾娜R配置.领域脉冲伤害攻击力倍率;
      for (let i = 0; i < 区域内单位.length; i++) {
        const 目标 = 区域内单位[i];
        if (!单位存活(目标)) continue;
        R技能伤害(施法者, 目标, 脉冲伤害, 数据, "伊蕾娜-回廊脉冲");
      }
    },
    on销毁: function R领域销毁(this: void, _上下文?: number): void {
      if (!实例.仍有效()) return;
      if (数据.领域已手动销毁) return; // 打断/死亡/场景清理不得误触收束
      // 自然结束收束
      const 收束表现 = 伊蕾娜表现配置.R收束;
      const 收束 = 创建点特效({
        模型路径: 收束表现.模型路径,
        RGB: 收束表现.RGB,
        X: 数据.中心X,
        Y: 数据.中心Y,
        Z: 收束表现.高度,
        缩放: 计算范围表现缩放(伊蕾娜R配置.领域半径, 收束表现),
        持续秒: 收束表现.持续秒,
      });
      void 收束;
      实例.完成();
    },
  });

  // 手动销毁入口挂进实例篮子：先置标志再销毁
  实例.登记自定义清理("R领域", function R领域清理(this: void): void {
    数据.领域已手动销毁 = true;
    领域.销毁();
  });
}

//=============================================================================
// 施放流程
//=============================================================================

function 释放R万法回廊(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    debugLogForce("伊蕾娜-R", "释放被拒", "原因", "施法者无效", "handle", 施法者);
    return;
  }
  // 禁止并行两个领域
  if (查询战斗技能实例(施法者, R技能键).length > 0) {
    debugLogForce("伊蕾娜-R", "释放被拒", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "原因", "已存在领域");
    return;
  }

  // t0 快照
  const 中心X = GetSpellTargetX();
  const 中心Y = GetSpellTargetY();
  const 方向角 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), 中心X, 中心Y);
  const 见闻快照 = 查询伊蕾娜见闻(施法者).slice(0, 3);
  const 变式快照 = 锁定伊蕾娜R变式(施法者);
  debugLogForce("伊蕾娜-R", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(R技能类型ID), "实例", 技能实例ID ?? "-", "目标", "点施放", "X", Math.floor(中心X), "Y", Math.floor(中心Y), "见闻", 见闻快照.length, "变式", 变式快照 ?? "无");

  const 数据: R领域数据 = {
    技能实例ID,
    中心X,
    中心Y,
    方向角,
    见闻快照,
    变式快照,
    领域已手动销毁: false,
  };

  let 注销统一清理: (this: void) => void = function R空注销(this: void): void {};
  let 充能ID = 0;
  const 实例 = 创建战斗技能实例({
    技能键: R技能键,
    施法者,
    技能实例ID,
    数据,
    结束回调: function R实例结束(this: void, 原因: string, _控制器: any): void {
      // 除自然完成外（完成在领域 on销毁 内部触发），这里处理死亡/中断遗留的锁定还原
      if (原因 !== "完成") {
        还原伊蕾娜R锁定变式(施法者);
      }
      注销统一清理();
    },
  });
  实例.登记自定义清理("R充能", function R充能清理(this: void): void {
    if (充能ID > 0) {
      停止充能(充能ID);
      充能ID = 0;
    }
  });

  // 场景清理兜底：清预警/领域由自定义清理承担
  注销统一清理 = 登记伊蕾娜技能清理(施法者, "R回廊-" + 实例.实例ID, function R统一清理(this: void): void {
    if (!实例.已结束()) 实例.结束("中断");
  });

  // R 必须允许指令中断，不添加暂停来源；动作由限时动画封装管理。
  SetUnitFacing(施法者, 方向角);
  播放伊蕾娜阶段动作(施法者, 伊蕾娜模型动作配置.技能动作.R蓄力起手);
  实例.登记延迟回调(addDelayedCallback(伊蕾娜模型动作配置.技能动作.R蓄力起手.持续秒 * 1000, function R切换保持动作(this: void): void {
    if (实例.仍有效()) 播放伊蕾娜阶段动作(施法者, 伊蕾娜模型动作配置.技能动作.R蓄力保持);
  }));

  // 蓄力预警（展开层 + 星阵），常驻句柄由充能结束回调统一销毁
  let 展开特效: any = null;
  let 星阵特效: any = null;
  const 展开表现 = 伊蕾娜表现配置.R展开;
  const 星阵表现 = 伊蕾娜表现配置.R星阵;
  展开特效 = 创建点特效({
    模型路径: 展开表现.模型路径,
    RGB: 展开表现.RGB,
    X: 中心X,
    Y: 中心Y,
    Z: 展开表现.高度,
    缩放: 计算范围表现缩放(伊蕾娜R配置.领域半径, 展开表现),
    持续秒: 展开表现.持续秒,
  });
  星阵特效 = 创建点特效({
    模型路径: 星阵表现.模型路径,
    RGB: 星阵表现.RGB,
    X: 中心X,
    Y: 中心Y,
    Z: 星阵表现.高度,
    缩放: 计算范围表现缩放(伊蕾娜R配置.领域半径, 星阵表现),
    持续秒: 星阵表现.持续秒,
  });

  充能ID = 开始充能(施法者, {
    持续时间: 伊蕾娜R配置.蓄力秒,
    指令中断: true,
    世界坐标进度UI: true,
    世界坐标进度UI类型: 伊蕾娜读条配置.UI类型 as any,
    世界坐标进度UI标题: "灰之魔女·万法回廊",
    世界坐标进度UI数值后缀: "",
    世界坐标进度UI高度偏移: 伊蕾娜读条配置.跟随Z偏移,
    显示进度条特效: 伊蕾娜读条配置.显示模型进度条,
    充能完成回调: function R充能完成(this: void, _单位: any, _充能ID: number): void {
      if (!实例.仍有效() || !单位存活(施法者)) return;
      执行R完成结算(施法者, 实例, 数据);
    },
    结束回调: function R蓄力结束(this: void, _单位: any, 原因: string, _充能ID: number): void {
      充能ID = 0;
      // 预警视觉任何结束路径都立即清理
      if (展开特效 != null && 展开特效 !== 0) {
        DestroyEffect(展开特效);
        展开特效 = null;
      }
      if (星阵特效 != null && 星阵特效 !== 0) {
        DestroyEffect(星阵特效);
        星阵特效 = null;
      }
      if (单位存活(施法者)) 播放伊蕾娜阶段动作(施法者, 伊蕾娜模型动作配置.技能动作.R释放收势);
      if (原因 !== "完成" && !实例.已结束()) {
        // 中断/死亡/主单位失效：不创建领域、不消费见闻与变式
        实例.结束("中断");
      }
    },
  });
  if (充能ID > 0) {
    播放英雄技能喊话(施法者, "伊蕾娜", 伊蕾娜技能配置.R.技能ID);
    // 万法回廊展开音（坐标=阵心，即 R展开/星阵法阵建立位置；充能建立后一次，参数配置驱动）
    Sound3DII_CooPlayReuse(伊蕾娜音效配置.R展开.路径, 中心X, 中心Y, 伊蕾娜音效配置.R展开.高度, 伊蕾娜音效配置.R展开.裁断距离);
  }
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册伊蕾娜R(this: void): void {
  debugLogForce("伊蕾娜-R", "注册", "名称", "注册伊蕾娜R");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "伊蕾娜-灰之魔女·万法回廊（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 伊蕾娜技能配置.R.技能ID,
    获取或创建上下文: function R上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放R万法回廊,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 12,
  });
}

export {};
