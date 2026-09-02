/** @noSelfInFile */
/**
 * 伊蕾娜 - Q：旅风·追迹（A3）
 *
 * - 单位目标壳释放时同时保存合法目标与目标点；发射时校验，追踪带保持秒，
 *   目标中途失效后弹道保持最后方向直飞，不继续追无效句柄。
 * - 命中后走技能伤害系统结算（单体形态），施加短暂追迹减速，并记录一条"风行"见闻。
 * - W 折射联动：结界存活且本次 Q 未读取过 → 从结界位置追加一枚折射魔弹（伤害归本次 Q 实例）。
 * - E 路线联动：弹道穿越扫帚路线（每次 Q 最多一次）→ 追加一枚风径魔弹（伤害归本次 Q 实例）。
 * - D 变式：迅行页增加射程与追踪保持；灰烬页命中后附加小范围爆发；发射成功才消费，失败不白扣。
 * - 弹道命中、超程、死亡、打断与场景清理统一由战斗技能实例收束并销毁模型。
 */

import { 伊蕾娜技能配置, 伊蕾娜Q配置, 伊蕾娜变式效果配置, 伊蕾娜表现配置, 伊蕾娜模型动作配置, 伊蕾娜音效配置 } from "./00．配置";
import { 播放伊蕾娜阶段动作 } from "./01A．动作表现";

const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string, 伊蕾娜变式?: string) => boolean;
};
import {
  记录伊蕾娜见闻,
  获取伊蕾娜变式,
  消费伊蕾娜变式用于,
  登记伊蕾娜技能清理,
  读取伊蕾娜扫帚路线,
} from "./02．被动效果";
import { 查询伊蕾娜W折射可用, 消费伊蕾娜W折射 } from "./04．W技能";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
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
  创建战斗技能实例: (this: void, 参数: any) => any;
};
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力, 两点角度, 单位存活, 距离平方XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  单位存活: (this: void, unit: any) => boolean;
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 获取坐标范围敌人 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  /** 注意：公共实现为 (中心来源单位, X, Y, 半径) */
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (this: void, sourceUnit: any, u: any, attackSlow: number, moveSlow: number, time: number, effectSourceName?: string, effectSourceType?: string) => void;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = 伊蕾娜技能配置.单位类型ID;
const Q技能类型ID = stringToFourCCSafe(伊蕾娜技能配置.Q.技能ID) as number;

//=============================================================================
// 结算辅助
//=============================================================================

function 造成Q技能伤害(
  this: void,
  施法者: any,
  目标: any,
  伤害值: number,
  技能实例ID: number | undefined,
  标签: string,
  形态: "单体" | "AOE",
): boolean {
  debugLogForce("伊蕾娜-Q", "伤害", "标签", 标签, "目标", 目标, "数值", 伤害值);
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

/** 命中共用：主伤害 + 追迹减速 + 风行见闻 + 灰烬爆发（按需）。 */
function 处理Q命中(this: void, 施法者: any, 目标: any, 数据: any): void {
  if (!单位存活(目标)) return; // 失效句柄不再结算
  const 伤害 = 读取单位攻击力(施法者) * 伊蕾娜Q配置.主伤害攻击力倍率;
  造成Q技能伤害(施法者, 目标, 伤害, 数据.技能实例ID, "伊蕾娜-旅风·追迹", "单体");
  SFB_setSlow(
    施法者,
    目标,
    0,
    伊蕾娜Q配置.追迹减速比例,
    伊蕾娜Q配置.追迹减速秒,
    "伊蕾娜-追迹标记",
    "技能",
  );
  // Q 命中音（坐标=目标位置；主弹命中结算一次，参数配置驱动）
  Sound3DII_CooPlayReuse(伊蕾娜音效配置.Q命中.路径, GetUnitX(目标), GetUnitY(目标), 伊蕾娜音效配置.Q命中.高度, 伊蕾娜音效配置.Q命中.裁断距离);
  // 见闻在真实命中后记录（A3）
  记录伊蕾娜见闻(施法者, "风行", 数据.技能实例ID);

  if (数据.灰烬爆发 && 伊蕾娜变式效果配置.灰烬_爆发半径 > 0) {
    const 敌人列表 = 获取坐标范围敌人(施法者, GetUnitX(目标), GetUnitY(目标), 伊蕾娜变式效果配置.灰烬_爆发半径);
    const 爆发伤害 = 读取单位攻击力(施法者) * 伊蕾娜变式效果配置.灰烬_爆发伤害攻击力倍率;
    for (let i = 0; i < 敌人列表.length; i++) {
      const 敌人 = 敌人列表[i];
      if (!单位存活(敌人)) continue;
      造成Q技能伤害(施法者, 敌人, 爆发伤害, 数据.技能实例ID, "伊蕾娜-灰烬爆发", "AOE");
    }
  }
}

//=============================================================================
// 联动读取（每枚主弹各最多一次；追加伤害归本次 Q 实例）
//=============================================================================

/** W 折射联动：从结界当前位置向快照目标点追加一枚折射魔弹。 */
function 尝试W折射联动(this: void, 施法者: any, 数据: any): void {
  if (数据.已读W折射) return;
  if (!查询伊蕾娜W折射可用(施法者)) return;
  if (!消费伊蕾娜W折射(施法者)) return; // 折射分支真正进入前不置位
  数据.已读W折射 = true;
  发射弹道({
    名称: "伊蕾娜-旅风·折射",
    所有者: 施法者,
    发射X: GetUnitX(施法者),
    发射Y: GetUnitY(施法者),
    发射方向角: 两点角度(GetUnitX(施法者), GetUnitY(施法者), 数据.目标X, 数据.目标Y),
    速度: 伊蕾娜Q配置.折射弹速度,
    轨迹: { 类型: "直线", 距离: 伊蕾娜Q配置.最大距离 },
    命中半径: 伊蕾娜Q配置.命中半径,
    影响目标: "敌方",
    碰撞消失: true,
    每单位最大命中次数: 1,
    伤害值: 读取单位攻击力(施法者) * 伊蕾娜Q配置.折射伤害攻击力倍率,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: Q技能类型ID,
    技能实例ID: 数据.技能实例ID,
    技能标签: "伊蕾娜-旅风·折射",
    伤害形态: "单体",
    参与技能伤害加成: false,
    模型: 伊蕾娜表现配置.Q联动弹道.模型路径,
   RGB: 伊蕾娜表现配置.Q联动弹道.RGB,
       缩放: 伊蕾娜表现配置.Q联动弹道.缩放,
    飞行高度: 伊蕾娜表现配置.Q联动弹道.高度,
    生命周期: 伊蕾娜Q配置.最大距离 / 伊蕾娜Q配置.折射弹速度 + 0.5,
  });
}

/** E 路线联动：穿越扫帚路线时从当前点追加一枚风径魔弹。 */
function 尝试E路线追加(this: void, 施法者: any, 数据: any, 当前X: number, 当前Y: number): void {
  if (数据.已读E路线) return;
  const 路线 = 读取伊蕾娜扫帚路线(施法者);
  if (路线 == null) return;
  // 判定当前点是否落在路线线段附近
  const 段长平方 = 距离平方XY(路线.起点X, 路线.起点Y, 路线.终点X, 路线.终点Y);
  let 在路线上 = false;
  if (段长平方 <= 1) {
    在路线上 = 距离平方XY(当前X, 当前Y, 路线.起点X, 路线.起点Y)
      <= 伊蕾娜Q配置.路线判定半径 * 伊蕾娜Q配置.路线判定半径;
  } else {
    const t = ((当前X - 路线.起点X) * (路线.终点X - 路线.起点X)
      + (当前Y - 路线.起点Y) * (路线.终点Y - 路线.起点Y)) / 段长平方;
    const 截取 = t < 0 ? 0 : t > 1 ? 1 : t;
    const 投影X = 路线.起点X + (路线.终点X - 路线.起点X) * 截取;
    const 投影Y = 路线.起点Y + (路线.终点Y - 路线.起点Y) * 截取;
    在路线上 = 距离平方XY(当前X, 当前Y, 投影X, 投影Y)
      <= 伊蕾娜Q配置.路线判定半径 * 伊蕾娜Q配置.路线判定半径;
  }
  if (!在路线上) return;
  数据.已读E路线 = true;
  发射弹道({
    名称: "伊蕾娜-旅风·风径",
    所有者: 施法者,
    发射X: 当前X,
    发射Y: 当前Y,
    发射方向角: 路线.方向角,
    速度: 伊蕾娜Q配置.弹道速度,
    轨迹: { 类型: "直线", 距离: 伊蕾娜Q配置.最大距离 },
    命中半径: 伊蕾娜Q配置.命中半径,
    影响目标: "敌方",
    碰撞消失: true,
    每单位最大命中次数: 1,
    伤害值: 读取单位攻击力(施法者) * 伊蕾娜Q配置.路线追加伤害攻击力倍率,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: Q技能类型ID,
    技能实例ID: 数据.技能实例ID,
    技能标签: "伊蕾娜-旅风·风径",
    伤害形态: "单体",
    参与技能伤害加成: false,
    模型: 伊蕾娜表现配置.Q联动弹道.模型路径,
   RGB: 伊蕾娜表现配置.Q联动弹道.RGB,
       缩放: 伊蕾娜表现配置.Q联动弹道.缩放,
    飞行高度: 伊蕾娜表现配置.Q联动弹道.高度,
    生命周期: 伊蕾娜Q配置.最大距离 / 伊蕾娜Q配置.弹道速度 + 0.5,
  });
}

//=============================================================================
// 施放流程
//=============================================================================

function 释放Q旅风追迹(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;
  播放英雄技能喊话(施法者, "伊蕾娜", 伊蕾娜技能配置.Q.技能ID);

  // t0 快照：合法目标与目标点同时保存，后续异步只使用快照
  const 目标单位 = GetSpellTargetUnit();
  let 目标X = GetSpellTargetX();
  let 目标Y = GetSpellTargetY();
  const 有目标 = 目标单位 != null && 目标单位 !== 0 && 单位存活(目标单位);
  if (有目标 && 目标X === 0 && 目标Y === 0) {
    目标X = GetUnitX(目标单位);
    目标Y = GetUnitY(目标单位);
  }

  // 战斗技能实例：收敛打断/死亡/清理路径
  const 硬直来源 = "伊蕾娜-Q硬直";
  const 数据: any = {
    技能实例ID,
    目标X,
    目标Y,
    已读W折射: false,
    已读E路线: false,
    灰烬爆发: false,
  };
  let 注销统一清理: (this: void) => void = function Q空注销(this: void): void {};
  const 实例 = 创建战斗技能实例({
    技能键: "Q旅风追迹",
    施法者,
    目标: 有目标 ? 目标单位 : undefined,
    技能实例ID,
    数据,
    结束回调: function Q实例结束(this: void, _原因: string, _控制器: any): void {
      移除单位暂停(施法者, 硬直来源);
      注销统一清理();
    },
  });
  注销统一清理 = 登记伊蕾娜技能清理(施法者, "Q弹道-" + 实例.实例ID, function Q统一清理(this: void): void {
    if (!实例.已结束()) 实例.结束("中断");
  });

  // D 变式预读（只读取不消费）：迅行=射程/追踪保持；否则灰烬=命中爆发。发射成功才消费。
  const 预读变式 = 获取伊蕾娜变式(施法者);
  const 用迅行 = 预读变式 === "迅行";
  const 最终距离 = 伊蕾娜Q配置.最大距离 + (用迅行 ? 伊蕾娜变式效果配置.迅行_Q射程增加 : 0);

  // 时序：先暂停 → 同阶段播动作 → 到达生效时点发射
  if (添加单位暂停(施法者, 硬直来源)) {
    SetUnitFacing(施法者, 两点角度(GetUnitX(施法者), GetUnitY(施法者), 目标X, 目标Y));
    播放伊蕾娜阶段动作(施法者, 伊蕾娜模型动作配置.技能动作.Q施法);
  }
  实例.登记延迟回调(addDelayedCallback(伊蕾娜Q配置.硬直秒 * 1000, function Q硬直结束(this: void): void {
    移除单位暂停(施法者, 硬直来源);
  }));

  实例.登记延迟回调(addDelayedCallback(伊蕾娜Q配置.发射延迟秒 * 1000, function Q发射(this: void): void {
    if (实例.已结束()) return;
    if (!单位存活(施法者)) return;

    // 灰烬判定放到发射时刻：保证只有真正进入本次 Q 才生效
    if (!用迅行) {
      const 灰烬加成 = 消费伊蕾娜变式用于(施法者, "Q");
      数据.灰烬爆发 = 灰烬加成 != null;
      void 灰烬加成;
    }

    const 发射时目标有效 = 有目标 && 单位存活(目标单位);
    const 追踪保持秒 = 用迅行 ? 伊蕾娜Q配置.追踪保持秒 + 0.5 : 伊蕾娜Q配置.追踪保持秒;
    // Q 发射音（坐标=施法者位置；到达发射时点且实例仍有效才播一次，参数配置驱动）
    Sound3DII_CooPlayReuse(伊蕾娜音效配置.Q发射.路径, GetUnitX(施法者), GetUnitY(施法者), 伊蕾娜音效配置.Q发射.高度, 伊蕾娜音效配置.Q发射.裁断距离);
    const 弹道 = 发射弹道({
      名称: "伊蕾娜-旅风·追迹",
      所有者: 施法者,
      发射X: GetUnitX(施法者),
      发射Y: GetUnitY(施法者),
      发射方向角: 两点角度(GetUnitX(施法者), GetUnitY(施法者), 目标X, 目标Y),
      速度: 伊蕾娜Q配置.弹道速度,
      轨迹: 发射时目标有效
        ? {
            类型: "追踪",
            目标: 目标单位,
            追踪转向速度: 伊蕾娜Q配置.追踪转向速度,
            追踪保持秒,
          }
        : { 类型: "直线", 距离: 最终距离 },
      命中半径: 伊蕾娜Q配置.命中半径,
      影响目标: "敌方",
      碰撞消失: true,
      每单位最大命中次数: 1,
      // 主弹不带伤害值：由 on命中 统一结算，避免弹道工厂重复扣血
      伤害类型: DAMAGE_TYPE_MAGIC,
      来源类型: "单位技能",
      技能ID: Q技能类型ID,
      技能实例ID,
      技能标签: "伊蕾娜-旅风·追迹",
      伤害形态: "单体",
      参与技能伤害加成: true,
      模型: 伊蕾娜表现配置.Q主弹道.模型路径,
     RGB: 伊蕾娜表现配置.Q主弹道.RGB,
         缩放: 伊蕾娜表现配置.Q主弹道.缩放,
      飞行高度: 伊蕾娜表现配置.Q主弹道.高度,
      生命周期: 最终距离 / 伊蕾娜Q配置.弹道速度 + 1,
      实例控制器: 实例,
      on命中: function Q命中(this: void, 命中目标: any, _弹幕ID: number): void {
        if (!实例.仍有效()) return;
        处理Q命中(施法者, 命中目标, 数据);
      },
      onTick: function Qtick(this: void, 弹幕实例: any, _delta: number): void {
        if (!实例.仍有效() || 弹幕实例 == null) return;
        尝试W折射联动(施法者, 数据);
        尝试E路线追加(施法者, 数据, 弹幕实例.当前X, 弹幕实例.当前Y);
      },
      on结束: function Q弹道结束(this: void, _原因: string, _弹幕ID: number): void {
        if (!实例.已结束()) 实例.完成();
      },
    });
    void 弹道;

    // 迅行分支真正进入（弹道已按增强参数飞行）后才消费
    if (用迅行) {
      const 已消费 = 消费伊蕾娜变式用于(施法者, "Q");
      void 已消费;
    }

  }));
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册伊蕾娜Q(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "伊蕾娜-旅风·追迹（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 伊蕾娜技能配置.Q.技能ID,
    获取或创建上下文: function Q上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放Q旅风追迹,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 6,
  });
}

export {};
