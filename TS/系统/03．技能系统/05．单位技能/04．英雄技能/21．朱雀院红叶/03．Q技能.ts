/** @noSelfInFile */

import {
  朱雀院红叶技能配置,
  朱雀院红叶音效配置,
  朱雀院红叶动作配置,
  朱雀院红叶动作槽,
  朱雀院红叶待平衡数值,
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
const { 创建限时二段技能壳, 确认限时二段技能壳, 清理限时二段技能壳 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.25．限时二段技能壳") as {
  创建限时二段技能壳: (this: void, 参数: any) => any;
  确认限时二段技能壳: (this: void, 控制器: any) => boolean;
  清理限时二段技能壳: (this: void, 控制器: any) => boolean;
};
const { 开始冲锋, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, 单位: any, 参数: any) => number;
  停止位移: (this: void, 位移ID: number, 原因?: string) => boolean;
};
const platformAbilityApi = require("平台扩展API取值") as {
  技能_获取技能最大冷却时间: (this: void, 单位: any, 技能代码: number) => number;
};
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力, 两点角度, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { 获取扇形区域单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域") as {
  获取扇形区域单位: (this: void, 参数: any) => any[];
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
  尝试消费一层刀势,
  是朱雀院红叶,
  登记朱雀院清理,
  播放红叶动作,
} = require("./02．被动效果") as {
  施加朱雀院破绽: (this: void, 红叶: any, 目标: any) => void;
  尝试消费一层刀势: (this: void, 英雄: any) => boolean;
  是朱雀院红叶: (this: void, unit: any) => boolean;
  登记朱雀院清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
  播放红叶动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
};
// E/D 模块联动（B3 实现；此处运行时 require，接口未就绪时安全跳过）
const 联动E = require("./05．E技能") as {
  读取最近剑痕并锁定?: (this: void, 英雄: any) => any;
};
const 联动D = require("./07．D技能") as {
  尝试消费D强化?: (this: void, 英雄: any) => boolean;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院红叶技能配置.单位类型ID);
const Q技能ID = stringToFourCCSafe(朱雀院红叶技能配置.Q.技能ID);
const Q2技能ID = stringToFourCCSafe(朱雀院红叶技能配置.Q2技能ID);
const Q配置 = 朱雀院红叶待平衡数值.Q;
const Q冲锋音效 = 朱雀院红叶音效配置.Q冲锋;
const Q回身斩音效 = 朱雀院红叶音效配置.Q回身斩;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;

interface Q数据 {
  位移ID: number;
  已命中: boolean;
  已Q2: boolean;
  强化已消费: boolean;
  剑痕已读取: boolean;
  已延长窗口: boolean;
  Q2壳: any;
  Q2到期时间: number;
}

//=============================================================================
// 伤害结算（统一攻击/伤害/武器类型）
//=============================================================================

function 结算Q单体伤害(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined, 伤害值: number, 标签: string): void {
  造成技能伤害({
    来源: 施法者,
    目标,
    伤害: 伤害值,
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
}

//=============================================================================
// Q1：突进斩击
//=============================================================================

function 开启Q2窗口(this: void, 施法者: any, 控制器: any, 数据: Q数据, 持续秒: number = Q配置.Q2窗口秒): void {
  if (数据.Q2壳 != null) return;
  const 壳 = 创建限时二段技能壳({
    名称: "朱雀院红叶-Q2",
    单位: 施法者,
    一段技能ID: Q技能ID,
    二段技能ID: Q2技能ID,
    持续秒,
    超时回调: function Q2窗口超时(this: void, 超时壳: any): void {
      if (数据.Q2壳 !== 超时壳) return;
      数据.Q2壳 = null;
      数据.Q2到期时间 = 0;
      控制器.完成();
    },
  });
  if (壳 != null) {
    数据.Q2壳 = 壳;
    数据.Q2到期时间 = getGameTime() + 持续秒;
    登记朱雀院清理(施法者, "红叶Q2窗口", function Q2窗口清理(this: void): void {
      if (数据.Q2壳 != null) {
        清理限时二段技能壳(数据.Q2壳);
        数据.Q2壳 = null;
        数据.Q2到期时间 = 0;
      }
    });
  } else {
    数据.Q2到期时间 = 0;
    控制器.完成();
  }
}

function 释放Q飞燕穿(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (!是朱雀院红叶(施法者)) return;
  播放红叶动作(施法者, 朱雀院红叶动作槽.Q冲刺);
  // 重复 Q：已有活跃 Q 实例时忽略本次释放（Q1 位移/Q2 窗口期间不叠加）
  if (查询战斗技能实例(施法者, "红叶Q").length > 0) return;
  // 技能喊话：施法成功起点（全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "朱雀院红叶", 朱雀院红叶技能配置.Q.技能ID);
  const 起点X = GetUnitX(施法者);
  const 起点Y = GetUnitY(施法者);
  const 方向 = 两点角度(起点X, 起点Y, GetSpellTargetX(), GetSpellTargetY());
  const 数据: Q数据 = { 位移ID: 0, 已命中: false, 已Q2: false, 强化已消费: false, 剑痕已读取: false, 已延长窗口: false, Q2壳: null, Q2到期时间: 0 };
  const 控制器 = 创建战斗技能实例({
    技能键: "红叶Q",
    施法者,
    技能实例ID,
    数据,
    结束回调: function Q结束(this: void, _原因: string, _c: any): void {
      if (数据.位移ID !== 0) {
        停止位移(数据.位移ID, "中断");
        数据.位移ID = 0;
      }
      if (数据.Q2壳 != null) {
        清理限时二段技能壳(数据.Q2壳);
        数据.Q2壳 = null;
      }
      数据.Q2到期时间 = 0;
    },
  });

  const 位移ID = 开始冲锋(施法者, {
    角度: 方向,
    距离: Q配置.突进距离,
    每秒速度: Q配置.突进速度,
    检查地形: true,
    朝向跟随位移: true,
    暂停单位: true,
    命中半径: Q配置.命中半径,
    只命中敌人: true,
    命中后结束: true,
    允许重复命中: false,
    命中回调: function Q1命中(this: void, _移动单位: any, 目标: any, _位移ID: number): void {
      if (数据.已命中) return;
      数据.已命中 = true;
      播放红叶动作(施法者, 朱雀院红叶动作槽.Q命中斩);
      结算Q单体伤害(施法者, 目标, 技能实例ID, 读取单位攻击力(施法者) * Q配置.伤害攻击力倍率, "朱雀院红叶-Q1");
      施加朱雀院破绽(施法者, 目标);
      // D 强化：Q1 命中追加一次短距离朱雀刀光（进入强化分支才消费）
      if (联动D.尝试消费D强化 != null && 联动D.尝试消费D强化(施法者)) {
        结算Q单体伤害(施法者, 目标, 技能实例ID, 读取单位攻击力(施法者) * Q配置.D刀光攻击力倍率, "朱雀院红叶-Q1D刀光");
      }
      开启Q2窗口(施法者, 控制器, 数据);
    },
    撞墙回调: function Q撞墙(this: void, 移动单位: any, _位移ID: number): void {
      // 不可达：短惩罚冷却（不进完整失败冷却）
      const 最大 = platformAbilityApi.技能_获取技能最大冷却时间(移动单位, Q技能ID);
      platformAbilityAction.技能_设置技能冷却时间(移动单位, Q技能ID, Q配置.短惩罚冷却秒, 最大);
    },
    结束回调: function Q1位移结束(this: void, _移动单位: any, _原因: string, _位移ID: number): void {
      数据.位移ID = 0;
      if (!数据.已命中) 控制器.完成();
    },
  });
  数据.位移ID = 位移ID;
  // 冲锋启动音（突进真实启动后；单位绑定，参数配置驱动；启动失败不播）
  if (位移ID !== 0) Sound3DII_UnitPlayReuse(Q冲锋音效.路径, 施法者, Q冲锋音效.裁断距离);
  if (位移ID === 0) 控制器.中断();
}

//=============================================================================
// Q2：回身斩（ASQ2 输入壳）
//=============================================================================

function 执行Q2回身斩(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined, 数据: Q数据): void {
  播放红叶动作(施法者, 朱雀院红叶动作槽.Q2回身斩);
  const 方向 = GetUnitFacing(施法者); // 角度制（与扇形区域方向角一致）
  const X = GetUnitX(施法者);
  const Y = GetUnitY(施法者);
  // 回身斩音（Q2 结算点；坐标=施法者位置，参数配置驱动）
  Sound3DII_CooPlayReuse(Q回身斩音效.路径, X, Y, Q回身斩音效.高度, Q回身斩音效.裁断距离);
  const 扇形敌人 = 获取扇形区域单位({
    X,
    Y,
    半径: Q配置.Q2扇形半径,
    方向角: 方向,
    扇形角度: Q配置.Q2扇形角度,
    单位筛选: function Q2筛选(this: void, 单位: any): boolean {
      return 单位 !== 施法者 && 单位存活(单位) && jass.IsUnitEnemy(单位, jass.GetOwningPlayer(施法者));
    },
  });
  for (let i = 0; i < 扇形敌人.length; i++) {
    结算Q单体伤害(施法者, 扇形敌人[i], 技能实例ID, 读取单位攻击力(施法者) * Q配置.Q2伤害攻击力倍率, "朱雀院红叶-Q2");
    施加朱雀院破绽(施法者, 扇形敌人[i]);
  }
  // 刀势强化：Q2 追加交叉剑气（一次）
  if (!数据.强化已消费) {
    数据.强化已消费 = true;
    if (尝试消费一层刀势(施法者)) {
      for (let i = 0; i < 扇形敌人.length; i++) {
        结算Q单体伤害(施法者, 扇形敌人[i], 技能实例ID, 读取单位攻击力(施法者) * Q配置.刀势剑气攻击力倍率, "朱雀院红叶-Q2刀势剑气");
      }
    }
  }
  // 剑痕读取：每次 Q 最多读取一条 E 剑痕，沿剑痕方向追加回响（读取即锁定）
  if (!数据.剑痕已读取) {
    数据.剑痕已读取 = true;
    const 剑痕 = 联动E.读取最近剑痕并锁定 != null ? 联动E.读取最近剑痕并锁定(施法者) : null;
    if (剑痕 != null) {
      for (let i = 0; i < 扇形敌人.length; i++) {
        结算Q单体伤害(施法者, 扇形敌人[i], 技能实例ID, 读取单位攻击力(施法者) * Q配置.剑痕回响攻击力倍率, "朱雀院红叶-Q2剑痕回响");
      }
    }
  }
  // 关闭 Q2 输入壳（按钮恢复原 Q）
  if (数据.Q2壳 != null) {
    确认限时二段技能壳(数据.Q2壳);
    数据.Q2壳 = null;
    数据.Q2到期时间 = 0;
  }
  控制器.完成();
}

function 释放Q2回身斩(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (!是朱雀院红叶(施法者)) return;
  const 活跃列表 = 查询战斗技能实例(施法者, "红叶Q");
  for (let i = 0; i < 活跃列表.length; i++) {
    const 控制器 = 活跃列表[i];
    const 数据 = 控制器.数据 as Q数据;
    if (数据 == null || 数据.已Q2) continue;
    数据.已Q2 = true;
    执行Q2回身斩(施法者, 控制器, 技能实例ID, 数据);
    return;
  }
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

/** W 成功招架后延长 Q2 窗口（最多延长一次，不无限刷新） */
export function 延长Q2窗口(this: void, 施法者: any, 延长秒: number): void {
  if (!是朱雀院红叶(施法者)) return;
  const 活跃列表 = 查询战斗技能实例(施法者, "红叶Q");
  for (let i = 0; i < 活跃列表.length; i++) {
    const 控制器 = 活跃列表[i];
    const 数据 = 控制器.数据 as Q数据;
    if (数据 == null || 数据.Q2壳 == null || 数据.已Q2) continue;
    if (数据.已延长窗口) return;
    数据.已延长窗口 = true;
    const 剩余秒 = 数据.Q2到期时间 - getGameTime();
    const 新窗口秒 = (剩余秒 > 0 ? 剩余秒 : 0) + 延长秒;
    清理限时二段技能壳(数据.Q2壳);
    数据.Q2壳 = null;
    数据.Q2到期时间 = 0;
    开启Q2窗口(施法者, 控制器, 数据, 新窗口秒);
    return;
  }
}

export function 注册朱雀院红叶Q(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "朱雀院红叶-飞燕·穿（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "AMQ1",
    获取或创建上下文: function Q上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放Q飞燕穿,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 2.5,
  });
  注册单位技能壳监听({
    名称: "朱雀院红叶-Q2回身斩（ASQ2）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "ASQ2",
    获取或创建上下文: function Q2上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放Q2回身斩,
    创建独立技能实例: false,
  });
}

export const 朱雀院红叶Q模块 = {
  技能ID: 朱雀院红叶技能配置.Q.技能ID,
  二段技能ID: 朱雀院红叶技能配置.Q2技能ID,
  二段窗口秒: Q配置.Q2窗口秒,
  注册: 注册朱雀院红叶Q,
} as const;
