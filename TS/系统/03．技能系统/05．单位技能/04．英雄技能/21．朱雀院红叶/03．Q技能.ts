/** @noSelfInFile */

import {
  朱雀院红叶技能配置,
  朱雀院红叶表现配置,
  朱雀院红叶音效配置,
  朱雀院红叶动作配置,
  朱雀院红叶动作槽,
  朱雀院红叶待平衡数值,
} from "./00．配置";
import type { 战斗技能实例控制器 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";

const jass = require("jass.common") as any;
const { stringToFourCCSafe, fourCCToStringSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
  fourCCToStringSafe: (this: void, fourcc: number) => string;
};
const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例, 查询战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => 战斗技能实例控制器;
  查询战斗技能实例: (this: void, 施法者: any, 技能键: string) => 战斗技能实例控制器[];
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
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
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
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
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
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院红叶技能配置.单位类型ID);
const Q技能ID = stringToFourCCSafe(朱雀院红叶技能配置.Q.技能ID);
const Q2技能ID = stringToFourCCSafe(朱雀院红叶技能配置.Q2技能ID);
const Q配置 = 朱雀院红叶待平衡数值.Q;
const Q冲锋音效 = 朱雀院红叶音效配置.Q冲锋;
const Q回身斩音效 = 朱雀院红叶音效配置.Q回身斩;

function 创建Q终点特效(this: void, X: number, Y: number, 方向角: number): void {
  const 路径列表 = 朱雀院红叶表现配置.Q终点.模型路径;
  const 时长列表 = 朱雀院红叶表现配置.Q终点.持续秒;
  const 缩放列表 = 朱雀院红叶表现配置.Q终点.缩放列表;
  for (let i = 0; i < 路径列表.length; i++) {
    创建点特效({
      模型路径: 路径列表[i],
      RGB: 朱雀院红叶表现配置.Q终点.RGB,
      X,
      Y,
      Z: 朱雀院红叶表现配置.Q终点.高度,
      面向角度: 方向角,
      动画索引: 0,
      缩放: 缩放列表?.[i] ?? 朱雀院红叶表现配置.Q终点.缩放,
      持续秒: 时长列表[i],
    });
  }
}

function 创建派生刀光(this: void, 施法者: any, 控制器: 战斗技能实例控制器, 方向角: number, 伤害值: number, 标签: string, 技能实例ID: number | undefined): void {
  发射弹道({
    名称: "朱雀院红叶-派生刀光表现",
    所有者: 施法者,
    发射X: GetUnitX(施法者),
    发射Y: GetUnitY(施法者),
    发射方向角: 方向角,
    速度: 朱雀院红叶表现配置.派生刀光.冲锋速度,
    轨迹: { 类型: "直线", 距离: 朱雀院红叶表现配置.派生刀光.冲锋距离 },
    模型: 朱雀院红叶表现配置.派生刀光.模型路径,
    RGB: 朱雀院红叶表现配置.派生刀光.RGB,
    缩放: 朱雀院红叶表现配置.派生刀光.缩放,
    飞行高度: 朱雀院红叶表现配置.派生刀光.高度,
    命中半径: 朱雀院红叶表现配置.派生刀光.命中半径,
    影响目标: "敌方",
    碰撞消失: false,
    每单位最大命中次数: 1,
    目标筛选: function 红叶派生刀光目标筛选(this: void, 单位: any): boolean {
      return 单位 !== 施法者 && 单位存活(单位) && jass.IsUnitEnemy(单位, GetOwningPlayer(施法者));
    },
    on命中: function 红叶派生刀光命中(this: void, 单位: any, _弹幕ID: number): void {
      结算Q单体伤害(施法者, 单位, 技能实例ID, 伤害值, 标签);
    },
    伤害形态: "AOE",
    实例控制器: 控制器,
  });
}

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;

interface Q数据 {
  位移ID: number;
  已命中: boolean;
  已Q2: boolean;
  强化已消费: boolean;
  剑痕已读取: boolean;
  已延长窗口: boolean;
  Q2壳: any;
  Q2到期时间: number;
  终点特效已创建: boolean;
}

//=============================================================================
// 伤害结算（统一攻击/伤害/武器类型）
//=============================================================================

function 结算Q单体伤害(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined, 伤害值: number, 标签: string): void {
  debugLogForce("红叶-Q", "伤害", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "目标", GetUnitName(目标), "handle", 目标, "X", Math.floor(GetUnitX(目标)), "Y", Math.floor(GetUnitY(目标)), "伤害", Math.floor(伤害值), "标签", 标签, "实例", 技能实例ID ?? "-");
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

function 开启Q2窗口(this: void, 施法者: any, 控制器: 战斗技能实例控制器, 数据: Q数据, 持续秒: number = Q配置.Q2窗口秒): void {
  if (数据.Q2壳 != null) return;
  debugLogForce("红叶-Q", "状态", "开启Q2窗口", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "持续秒", 持续秒);
  const 壳 = 创建限时二段技能壳({
    名称: "飞燕·回身斩（Q）",
    单位: 施法者,
    一段技能ID: Q技能ID,
    二段技能ID: Q2技能ID,
    持续秒,
    二段说明:
      "|cffffcc00技能说明：|r立即施展回身斩，攻击身后的敌人。|n"
      + "|cffffcc00伤害：|r回身斩造成攻击力|cff87ceeb80%|r的物理伤害。|n"
      + "|cffffcc00不做任何操作：|r二段窗口结束后机会消失，按钮自动恢复。",
    超时回调: function Q2窗口超时(this: void, 超时壳: any): void {
      if (数据.Q2壳 !== 超时壳) return;
      数据.Q2壳 = null;
      数据.Q2到期时间 = 0;
      debugLogForce("红叶-Q", "结束", "原因", "Q2窗口超时", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
      控制器.完成();
    },
  });
  if (壳 != null) {
    数据.Q2壳 = 壳;
    数据.Q2到期时间 = getGameTime() + 持续秒 * 1000;
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
  debugLogForce("红叶-Q", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(Q技能ID), "实例", 技能实例ID ?? "-", "阶段", "Q1", "目标", "点施放", "施法者X", Math.floor(GetUnitX(施法者)), "施法者Y", Math.floor(GetUnitY(施法者)), "目标X", Math.floor(GetSpellTargetX()), "目标Y", Math.floor(GetSpellTargetY()));
  if (!是朱雀院红叶(施法者)) {
    debugLogForce("红叶-Q", "释放被拒", "原因", "非红叶单位", "施法者", 施法者);
    return;
  }
  播放红叶动作(施法者, 朱雀院红叶动作槽.Q冲刺);
  // 重复 Q：已有活跃 Q 实例时忽略本次释放（Q1 位移/Q2 窗口期间不叠加）
  if (查询战斗技能实例(施法者, "红叶Q").length > 0) {
    debugLogForce("红叶-Q", "释放被拒", "原因", "重复Q活跃实例", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
    return;
  }
  // 技能喊话：施法成功起点（全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "朱雀院红叶", 朱雀院红叶技能配置.Q.技能ID);
  const 起点X = GetUnitX(施法者);
  const 起点Y = GetUnitY(施法者);
  const 方向 = 两点角度(起点X, 起点Y, GetSpellTargetX(), GetSpellTargetY());
  const 数据: Q数据 = { 位移ID: 0, 已命中: false, 已Q2: false, 强化已消费: false, 剑痕已读取: false, 已延长窗口: false, Q2壳: null, Q2到期时间: 0, 终点特效已创建: false };
  const 控制器 = 创建战斗技能实例({
    技能键: "红叶Q",
    施法者,
    技能实例ID,
    数据,
    结束回调: function Q结束(this: void, _原因: string, _c: any): void {
      debugLogForce("红叶-Q", "结束", "原因", "-", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
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

  debugLogForce("红叶-Q", "位移", "类型", "冲锋", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "距离", Q配置.突进距离);
  const 位移ID = 开始冲锋(施法者, {
    角度: 方向,
    距离: Q配置.突进距离,
    每秒速度: Q配置.突进速度,
    检查地形: true,
    朝向跟随位移: true,
    暂停单位: true,
    命中半径: Q配置.命中半径,
    只命中敌人: true,
    // 命中不停车：穿过敌人继续突进，目标落在身后直接衔接 Q2 回身斩
    命中后结束: false,
    允许重复命中: false,
    位移特效: 朱雀院红叶表现配置.Q冲锋.模型路径[0],
    附加位移特效: 朱雀院红叶表现配置.Q冲锋.模型路径[1],
    位移特效缩放: 朱雀院红叶表现配置.Q冲锋.缩放,
    位移特效高度: 朱雀院红叶表现配置.Q冲锋.高度,
    位移特效持续秒: 朱雀院红叶表现配置.Q冲锋.持续秒,
    位移特效面向角度: 方向,
    附加位移特效缩放: 朱雀院红叶表现配置.Q冲锋.缩放,
    附加位移特效高度: 朱雀院红叶表现配置.Q冲锋.高度,
    附加位移特效持续秒: 朱雀院红叶表现配置.Q冲锋.持续秒,
    附加位移特效面向角度: 方向,
    附加位移特效偏移角度: 方向 + 180,
    附加位移特效偏移距离: 300,
    命中回调: function Q1命中(this: void, _移动单位: any, 目标: any, _位移ID: number): void {
      debugLogForce("红叶-Q", "命中", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "目标", GetUnitName(目标), "handle", 目标, "X", Math.floor(GetUnitX(目标)), "Y", Math.floor(GetUnitY(目标)), "伤害", Math.floor(读取单位攻击力(施法者) * Q配置.伤害攻击力倍率), "实例", 技能实例ID ?? "-");
      if (数据.已命中) return;
      数据.已命中 = true;
      播放红叶动作(施法者, 朱雀院红叶动作槽.Q命中斩);
      if (!数据.终点特效已创建) {
        数据.终点特效已创建 = true;
        创建Q终点特效(GetUnitX(施法者), GetUnitY(施法者), 方向);
      }
      结算Q单体伤害(施法者, 目标, 技能实例ID, 读取单位攻击力(施法者) * Q配置.伤害攻击力倍率, "朱雀院红叶-Q1");
      施加朱雀院破绽(施法者, 目标);
      // D 强化：Q1 命中追加一次短距离朱雀刀光（进入强化分支才消费）
      if (联动D.尝试消费D强化 != null && 联动D.尝试消费D强化(施法者)) {
        创建派生刀光(施法者, 控制器, 方向, 读取单位攻击力(施法者) * Q配置.D刀光攻击力倍率, "朱雀院红叶-Q1D刀光", 技能实例ID);
      }
      开启Q2窗口(施法者, 控制器, 数据);
    },
    撞墙回调: function Q撞墙(this: void, 移动单位: any, _位移ID: number): void {
      // 不可达：短惩罚冷却（不进完整失败冷却）
      const 最大 = platformAbilityApi.技能_获取技能最大冷却时间(移动单位, Q技能ID);
      platformAbilityAction.技能_设置技能冷却时间(移动单位, Q技能ID, Q配置.短惩罚冷却秒, 最大);
    },
    结束回调: function Q1位移结束(this: void, 移动单位: any, 原因: string, _位移ID: number): void {
      数据.位移ID = 0;
      if (!数据.已命中 && 原因 === "完成" && !数据.终点特效已创建) {
        数据.终点特效已创建 = true;
        创建Q终点特效(GetUnitX(移动单位), GetUnitY(移动单位), 方向);
      }
      if (!数据.已命中) 控制器.完成();
    },
  });
  数据.位移ID = 位移ID;
  // 冲锋启动音（突进真实启动后；单位绑定，参数配置驱动；启动失败不播）
  if (位移ID !== 0) Sound3DII_UnitPlayReuse(Q冲锋音效.路径, 施法者, Q冲锋音效.裁断距离);
  if (位移ID === 0) {
    debugLogForce("红叶-Q", "释放被拒", "原因", "冲锋位移启动失败", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
    控制器.中断();
  }
}

//=============================================================================
// Q2：回身斩（ASQ2 输入壳）
//=============================================================================

function 执行Q2回身斩(this: void, 施法者: any, 控制器: 战斗技能实例控制器, 技能实例ID: number | undefined, 数据: Q数据): void {
  播放红叶动作(施法者, 朱雀院红叶动作槽.Q2回身斩);
  const 方向 = GetUnitFacing(施法者); // 角度制
  // 回身斩攻击身后扇形：以当前朝向的反方向为中心（穿越冲锋后目标在身后）
  const 背向 = 方向 + 180;
  const X = GetUnitX(施法者);
  const Y = GetUnitY(施法者);
  创建Q终点特效(X, Y, 背向);
  // 回身斩音（Q2 结算点；坐标=施法者位置，参数配置驱动）
  Sound3DII_CooPlayReuse(Q回身斩音效.路径, X, Y, Q回身斩音效.高度, Q回身斩音效.裁断距离);
  const 扇形敌人 = 获取扇形区域单位({
    X,
    Y,
    半径: Q配置.Q2扇形半径,
    方向角: 背向,
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
      创建派生刀光(施法者, 控制器, 背向, 读取单位攻击力(施法者) * Q配置.刀势剑气攻击力倍率, "朱雀院红叶-Q2刀势剑气", 技能实例ID);
    }
  }
  // 剑痕读取：每次 Q 最多读取一条 E 剑痕，沿剑痕方向追加回响（读取即锁定）
  if (!数据.剑痕已读取) {
    数据.剑痕已读取 = true;
    const 剑痕 = 联动E.读取最近剑痕并锁定 != null ? 联动E.读取最近剑痕并锁定(施法者) : null;
    if (剑痕 != null) {
      debugLogForce("红叶-Q", "状态", "剑痕回响", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
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
  debugLogForce("红叶-Q", "结束", "原因", "Q2施放完成", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
  控制器.完成();
}

function 释放Q2回身斩(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  debugLogForce("红叶-Q", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(Q2技能ID), "实例", 技能实例ID ?? "-", "阶段", "Q2");
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
    const 剩余秒 = (数据.Q2到期时间 - getGameTime()) / 1000;
    const 新窗口秒 = (剩余秒 > 0 ? 剩余秒 : 0) + 延长秒;
    清理限时二段技能壳(数据.Q2壳);
    数据.Q2壳 = null;
    数据.Q2到期时间 = 0;
    开启Q2窗口(施法者, 控制器, 数据, 新窗口秒);
    debugLogForce("红叶-Q", "状态", "Q2窗口延长", "新窗口秒", 新窗口秒);
    return;
  }
}

export function 注册朱雀院红叶Q(this: void): void {
  debugLogForce("红叶-Q", "注册", "名称", "Q", "函数", "注册朱雀院红叶Q");
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

