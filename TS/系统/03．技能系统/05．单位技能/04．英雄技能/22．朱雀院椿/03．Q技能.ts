/** @noSelfInFile */

import {
  朱雀院椿技能配置,
  朱雀院椿表现配置,
  朱雀院椿动作配置,
  朱雀院椿动作槽,
  朱雀院椿Q配置,
  朱雀院椿音效配置,
} from "./00．配置";

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
const { 创建战斗技能实例, 查询战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => any;
  查询战斗技能实例: (this: void, 施法者: any, 技能键: string) => any[];
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
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
// E 精确回锋方向（运行时 require 防循环依赖；E 模块导出读取即消费）
const E联动 = require("./05．E技能") as {
  获取椿回锋方向?: (this: void, 英雄: any) => number | null;
};
const {
  是朱雀院椿,
  消费反击准备,
  恢复VF,
  获取姿态,
  登记椿清理,
  播放椿动作,
} = require("./02．被动效果") as {
  是朱雀院椿: (this: void, unit: any) => boolean;
  消费反击准备: (this: void, 英雄: any) => { 方向: number; 来源: any } | null;
  恢复VF: (this: void, 英雄: any, 量: number) => boolean;
  获取姿态: (this: void, 英雄: any) => string;
  登记椿清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
  播放椿动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院椿技能配置.单位类型ID);
const Q技能ID = stringToFourCCSafe(朱雀院椿技能配置.Q.技能ID);
const Q配置 = 朱雀院椿Q配置;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;

interface Q数据 {
  输入方向: number;
  反击方向: number;
  已消费反击: boolean;
  段回调ID: number[];
}

function 结算Q斩(this: void, 施法者: any, 技能实例ID: number | undefined, 方向角: number, 伤害倍率: number, 标签: string): void {
  const X = GetUnitX(施法者);
  const Y = GetUnitY(施法者);
  // 居合/返刃斩击表现（正式主版本；备份版本按候选规则切换；按斩击方向旋转，时长覆盖 Stand 1000-1755ms）
  创建点特效({
    模型路径: 朱雀院椿表现配置.Q主斩.模型路径,
    RGB: 朱雀院椿表现配置.Q主斩.RGB,
    X,
    Y,
    Z: 朱雀院椿表现配置.Q主斩.高度,
    面向角度: 方向角,
    动画索引: 0,
    缩放: 朱雀院椿表现配置.Q主斩.缩放,
    持续秒: 朱雀院椿表现配置.Q主斩.持续秒,
  });
  const 敌人 = 获取扇形区域单位({
    X,
    Y,
    半径: Q配置.扇形半径,
    方向角,
    扇形角度: Q配置.扇形角度,
    单位筛选: function Q筛选(this: void, 单位: any): boolean {
      return 单位 !== 施法者 && 单位存活(单位) && jass.IsUnitEnemy(单位, jass.GetOwningPlayer(施法者));
    },
  });
  for (let i = 0; i < 敌人.length; i++) {
    造成技能伤害({
      来源: 施法者,
      目标: 敌人[i],
      伤害: 读取单位攻击力(施法者) * 伤害倍率,
      伤害类型: DAMAGE_TYPE_NORMAL,
      攻击类型: ATTACK_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: Q技能ID,
      技能实例ID,
      标签,
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });
  }
}

function 执行基础居合(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined, 数据: Q数据): void {
  结算Q斩(施法者, 技能实例ID, 数据.输入方向, Q配置.基础伤害倍率, "朱雀院椿-Q居合");
  // 居合斩音（基础居合结算点；坐标=施法者位置，参数配置驱动）
  Sound3DII_CooPlayReuse(朱雀院椿音效配置.Q居合.路径, GetUnitX(施法者), GetUnitY(施法者), 朱雀院椿音效配置.Q居合.高度, 朱雀院椿音效配置.Q居合.裁断距离);
  控制器.完成();
}

function 执行返刃第一段(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined, 数据: Q数据): void {
  结算Q斩(施法者, 技能实例ID, 数据.输入方向, Q配置.返刃一段倍率, "朱雀院椿-Q返刃一段");
  // 第二段回身斩：沿防守方向（W 招架来源方向 / E 回锋方向）
  const 第二段ID = addDelayedCallback(Q配置.二段延迟毫秒, function Q返刃二段(this: void): void {
    播放椿动作(施法者, 朱雀院椿动作槽.Q返刃二段);
    // 返刃回身斩音（返刃二段结算点；坐标=施法者位置，参数配置驱动）
    Sound3DII_CooPlayReuse(朱雀院椿音效配置.Q返刃.路径, GetUnitX(施法者), GetUnitY(施法者), 朱雀院椿音效配置.Q返刃.高度, 朱雀院椿音效配置.Q返刃.裁断距离);
    const 姿态 = 获取姿态(施法者);
    if (姿态 === "一刀") {
      // 一刀守势：第二段结束后恢复少量 VF
      结算Q斩(施法者, 技能实例ID, 数据.反击方向, Q配置.返刃二段倍率, "朱雀院椿-Q返刃二段");
      恢复VF(施法者, 25);
    } else {
      // 二刀攻势：第二段改为交叉双刀斩并向前推进小段（追加一道交叉伤害）
      结算Q斩(施法者, 技能实例ID, 数据.反击方向, Q配置.返刃二段倍率, "朱雀院椿-Q返刃二段");
      结算Q斩(施法者, 技能实例ID, 数据.反击方向 + 90, Q配置.二刀交叉倍率, "朱雀院椿-Q交叉斩");
      // 二刀交错斩音（Q 二刀交叉分支成立时；坐标=施法者位置，参数配置驱动）
      Sound3DII_CooPlayReuse(朱雀院椿音效配置.二刀交错.路径, GetUnitX(施法者), GetUnitY(施法者), 朱雀院椿音效配置.二刀交错.高度, 朱雀院椿音效配置.二刀交错.裁断距离);
    }
    控制器.完成();
  });
  数据.段回调ID.push(第二段ID);
  控制器.登记延迟回调(第二段ID);
}

function 释放Q居合(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (!是朱雀院椿(施法者)) return;
  // 重复 Q：已有活跃 Q 实例时忽略
  if (查询战斗技能实例(施法者, "椿Q").length > 0) return;
  // 技能喊话：施法成功起点（全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "朱雀院椿", 朱雀院椿技能配置.Q.技能ID);
  播放椿动作(施法者, 朱雀院椿动作槽.Q居合);
  const 输入方向 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), GetSpellTargetX(), GetSpellTargetY());
  // 消费反击准备（有则返刃，无则基础居合）；反击方向优先取 E 精确回锋方向（读取即消费，每次 Q 最多一次）
  // E 提前消费反击准备后 反击 为 null，但回锋方向存在同样进入返刃分支；null=无回锋，0° 是合法方向
  const 反击 = 消费反击准备(施法者);
  const 回锋方向 = E联动.获取椿回锋方向 != null ? E联动.获取椿回锋方向(施法者) : null;
  const 数据: Q数据 = {
    输入方向,
    反击方向: 回锋方向 != null ? 回锋方向 : 反击 != null ? 反击.方向 : 输入方向,
    已消费反击: 反击 != null || 回锋方向 != null,
    段回调ID: [],
  };
  const 控制器 = 创建战斗技能实例({
    技能键: "椿Q",
    施法者,
    技能实例ID,
    数据,
    结束回调: function Q结束(this: void, _原因: string, _c: any): void {
      for (let i = 0; i < 数据.段回调ID.length; i++) {
        // 延迟回调由实例统一清理（未执行段不再结算）
      }
      数据.段回调ID = [];
    },
  });
  const 第一段ID = addDelayedCallback(Q配置.前摇毫秒, function Q第一段(this: void): void {
    if (数据.已消费反击) {
      执行返刃第一段(施法者, 控制器, 技能实例ID, 数据);
    } else {
      执行基础居合(施法者, 控制器, 技能实例ID, 数据);
    }
  });
  数据.段回调ID.push(第一段ID);
  控制器.登记延迟回调(第一段ID);
  // 死亡/场景清理兜底
  登记椿清理(施法者, "椿Q", function Q清理(this: void): void {
    if (控制器 != null) 控制器.中断();
  });
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册朱雀院椿Q(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "朱雀院椿-居合·返（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "ATQ1",
    获取或创建上下文: function Q上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放Q居合,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 1.2,
  });
}

export const 朱雀院椿Q模块 = {
  技能ID: 朱雀院椿技能配置.Q.技能ID,
  注册: 注册朱雀院椿Q,
} as const;
