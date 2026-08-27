/** @noSelfInFile */

import {
  朱雀院椿技能配置,
  朱雀院椿表现配置,
  朱雀院椿动作配置,
  朱雀院椿动作槽,
  朱雀院椿E配置,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例, 查询战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => any;
  查询战斗技能实例: (this: void, 施法者: any, 技能键: string) => any[];
};
const { 开始冲锋, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, 单位: any, 参数: any) => number;
  停止位移: (this: void, 位移ID: number, 原因?: string) => boolean;
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
const {
  是朱雀院椿,
  消费反击准备,
  恢复VF,
  扣除VF,
  获取姿态,
  设置决斗距离,
  登记椿清理,
  播放椿动作,
} = require("./02．被动效果") as {
  是朱雀院椿: (this: void, unit: any) => boolean;
  消费反击准备: (this: void, 英雄: any) => { 方向: number; 来源: any } | null;
  恢复VF: (this: void, 英雄: any, 量: number) => boolean;
  扣除VF: (this: void, 英雄: any, 量: number) => number;
  获取姿态: (this: void, 英雄: any) => string;
  设置决斗距离: (this: void, 英雄: any, 方向: number, 持续秒: number) => void;
  登记椿清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
  播放椿动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院椿技能配置.单位类型ID);
const E技能ID = stringToFourCCSafe(朱雀院椿技能配置.E.技能ID);
const E配置 = 朱雀院椿E配置;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;

//=============================================================================
// 精确回锋：E 消费反击准备后为 Q 提供的回锋方向（E 模块私有，Q 每次最多读取一次）
//=============================================================================

interface 回锋状态 {
  到期: number;
  方向: number;
}
const 回锋表: Record<number, 回锋状态 | undefined> = {};

export function 获取椿回锋方向(this: void, 英雄: any): number | null {
  if (英雄 == null || 英雄 === 0) return null;
  const id = jass.GetHandleId(英雄);
  const 状态 = 回锋表[id];
  if (状态 == null || getGameTime() > 状态.到期) return null;
  // 读取即消费：每次 Q 最多用一次回锋方向（避免同一回锋被多次 Q 复用）；null=无值，0° 是合法方向
  delete 回锋表[id];
  return 状态.方向;
}

function 设置回锋方向(this: void, 英雄: any, 方向: number): void {
  if (英雄 == null || 英雄 === 0) return;
  回锋表[jass.GetHandleId(英雄)] = { 到期: getGameTime() + E配置.回锋方向有效秒, 方向 };
}

//=============================================================================
// E：间合位移
//=============================================================================

interface E数据 {
  位移ID: number;
  已结束: boolean;
  已结算: boolean;
  终点X: number;
  终点Y: number;
  方向角: number;
  精确回锋: boolean;
}

function 结算E终点横斩(this: void, 施法者: any, 技能实例ID: number | undefined, 数据: E数据): void {
  播放椿动作(施法者, 朱雀院椿动作槽.E终点横斩);
  if (数据.已结算) return;
  数据.已结算 = true;
  // 终点横斩表现（正式主版本；备份版本按候选规则切换；按位移方向旋转 + 显式播放 Death 序列，时长覆盖 Death 233-667ms）
  创建点特效({
    模型路径: 朱雀院椿表现配置.E终点主斩,
    X: 数据.终点X,
    Y: 数据.终点Y,
    Z: 朱雀院椿表现配置.参数.E终点主斩.高度,
    面向角度: 数据.方向角,
    动画索引: 0,
    缩放: 朱雀院椿表现配置.参数.E终点主斩.缩放,
    持续秒: 朱雀院椿表现配置.参数.E终点主斩.持续秒,
  });
  const 敌人 = 获取扇形区域单位({
    X: 数据.终点X,
    Y: 数据.终点Y,
    半径: E配置.横斩半径,
    方向角: 数据.方向角,
    扇形角度: E配置.横斩扇形角度,
    单位筛选: function E横斩筛选(this: void, 单位: any): boolean {
      return 单位 !== 施法者 && 单位存活(单位) && jass.IsUnitEnemy(单位, jass.GetOwningPlayer(施法者));
    },
  });
  for (let i = 0; i < 敌人.length; i++) {
    造成技能伤害({
      来源: 施法者,
      目标: 敌人[i],
      伤害: 读取单位攻击力(施法者) * E配置.横斩倍率,
      伤害类型: DAMAGE_TYPE_NORMAL,
      攻击类型: ATTACK_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: E技能ID,
      技能实例ID,
      标签: "朱雀院椿-E横斩",
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });
  }
  // 精确回锋：为 Q 提供回锋方向（每次 E 最多一次）
  if (数据.精确回锋) {
    设置回锋方向(施法者, 数据.方向角);
  }
  // 姿态收益：一刀恢复 VF；二刀追加第二道横斩并扣 VF 代价
  if (获取姿态(施法者) === "一刀") {
    恢复VF(施法者, E配置.一刀VF恢复);
  } else {
    扣除VF(施法者, E配置.二刀VF代价);
    for (let i = 0; i < 敌人.length; i++) {
      造成技能伤害({
        来源: 施法者,
        目标: 敌人[i],
        伤害: 读取单位攻击力(施法者) * E配置.二刀追加倍率,
        伤害类型: DAMAGE_TYPE_NORMAL,
        攻击类型: ATTACK_TYPE_NORMAL,
        武器类型: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: E技能ID,
        技能实例ID,
        标签: "朱雀院椿-E二刀横斩",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });
    }
  }
  // 建立决斗距离（供 R 读取）
  设置决斗距离(施法者, 数据.方向角, E配置.决斗距离持续秒);
}

function 释放E间合(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (!是朱雀院椿(施法者)) return;
  // 重复 E：已有活跃位移时忽略
  if (查询战斗技能实例(施法者, "椿E").length > 0) return;
  播放椿动作(施法者, 朱雀院椿动作槽.E冲刺);
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  // 消费反击准备：有则精确回锋（位移方向取攻击来源方向，向来源侧间合）
  const 反击 = 消费反击准备(施法者);
  const 精确回锋 = 反击 != null;
  let 方向 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), 目标X, 目标Y);
  if (精确回锋 && 反击 != null && 反击.来源 != null && 反击.来源 !== 0 && 单位存活(反击.来源)) {
    // W 招架后使用 E：位移起点取攻击来源方向（冲向来源侧）
    方向 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(反击.来源), GetUnitY(反击.来源));
  }
  const 终点X = GetUnitX(施法者) + (目标X - GetUnitX(施法者));
  const 终点Y = GetUnitY(施法者) + (目标Y - GetUnitY(施法者));
  const 数据: E数据 = {
    位移ID: 0,
    已结束: false,
    已结算: false,
    终点X,
    终点Y,
    方向角: 方向,
    精确回锋,
  };
  const 控制器 = 创建战斗技能实例({
    技能键: "椿E",
    施法者,
    技能实例ID,
    数据,
    结束回调: function E结束(this: void, _原因: string, _c: any): void {
      // 中断/死亡：先标记结束，再停止位移（防止位移结束回调误触发落点结算）
      if (数据.已结束) return;
      数据.已结束 = true;
      if (数据.位移ID !== 0) {
        停止位移(数据.位移ID, "中断");
        数据.位移ID = 0;
      }
    },
  });
  数据.位移ID = 开始冲锋(施法者, {
    距离: E配置.位移距离,
    每秒速度: E配置.位移速度,
    检查地形: true,
    朝向跟随位移: true,
    暂停单位: true,
    位移特效: 朱雀院椿表现配置.E冲锋主层[0],
    附加位移特效: 朱雀院椿表现配置.E冲锋主层[1],
    位移特效缩放: 朱雀院椿表现配置.参数.E冲锋主层.缩放,
    位移特效高度: 朱雀院椿表现配置.参数.E冲锋主层.高度,
    位移特效持续秒: 朱雀院椿表现配置.参数.E冲锋主层.持续秒,
    附加位移特效缩放: 朱雀院椿表现配置.参数.E冲锋主层.缩放,
    附加位移特效高度: 朱雀院椿表现配置.参数.E冲锋主层.高度,
    附加位移特效持续秒: 朱雀院椿表现配置.参数.E冲锋主层.持续秒,
    撞墙回调: function E撞墙(this: void, 移动单位: any, _位移ID: number): void {
      // 撞墙：终点更新为英雄实际停靠位置（否则横斩在未达的目标点结算）
      数据.终点X = GetUnitX(移动单位);
      数据.终点Y = GetUnitY(移动单位);
      结算E终点横斩(施法者, 技能实例ID, 数据);
      控制器.完成();
    },
    结束回调: function E位移结束(this: void, 单位: any, 原因: string, _位移ID: number): void {
      if (数据.已结束) return;
      const 落点X = GetUnitX(单位);
      const 落点Y = GetUnitY(单位);
      数据.终点X = 落点X;
      数据.终点Y = 落点Y;
      结算E终点横斩(施法者, 技能实例ID, 数据);
      控制器.完成();
      void 原因;
    },
  });
  登记椿清理(施法者, "椿E", function E清理(this: void): void {
    if (数据.位移ID !== 0) {
      停止位移(数据.位移ID, "中断");
      数据.位移ID = 0;
    }
  });
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册朱雀院椿E(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "朱雀院椿-刃道·间合（E）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "ATE1",
    获取或创建上下文: function E上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放E间合,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 1.5,
  });
}

export const 朱雀院椿E模块 = {
  技能ID: 朱雀院椿技能配置.E.技能ID,
  注册: 注册朱雀院椿E,
} as const;
