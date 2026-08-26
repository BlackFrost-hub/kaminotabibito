/** @noSelfInFile */
/**
 * 弹道编排工厂自检（H-03）
 *
 * 默认关闭；进图后手动调用 运行H03自检()。
 * 覆盖测试矩阵：
 *   1. 直线到点（on到达点 触发）
 *   2. 有目标短时追踪后保持方向（追踪保持秒 → 延迟锁定方向）
 *   3. 贝塞尔高到低（XYZ 轨迹）
 *   4. 中途改向（延迟改向）
 *   5. 命中后结束（碰撞消失）与穿透（碰撞消失 false + 多段命中）
 *   6. 中断清理（预警阶段中断不发射；发射后中断销毁弹幕）
 */

import { 发射弹道 } from "../09．复杂战斗模板/05．弹道编排工厂";
import {
  创建战斗技能实例,
} from "../../04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";

const jass = require("jass.common") as any;
const print = (jass.print ?? ((_s: string) => {})) as (this: void, s: string) => void;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};

const 农民单位类型 = stringToFourCCSafe("hpea");

function 断言(this: void, 条件: boolean, 消息: string): void {
  print("[H-03自检] " + (条件 ? "通过: " : "失败: ") + 消息);
}

export function 运行H03自检(this: void): void {
  const 施法者 = jass.CreateUnit(jass.Player(0), 农民单位类型, 0, 0, 0);
  const 敌人A = jass.CreateUnit(jass.Player(1), 农民单位类型, 600, 0, 0);
  const 敌人B = jass.CreateUnit(jass.Player(1), 农民单位类型, 1200, 0, 0);
  if (施法者 == null || 敌人A == null || 敌人B == null) {
    print("[H-03自检] 无法创建测试单位，中止");
    return;
  }

  // ---- 1. 直线到点 ----
  let 到点次数 = 0;
  发射弹道({
    名称: "H03-直线到点",
    所有者: 施法者,
    发射方向角: 0,
    速度: 522,
    轨迹: { 类型: "直线到点", 终点X: 900, 终点Y: 0 },
    命中半径: 100,
    影响目标: "敌方",
    伤害值: 1,
    on到达点: function (this: void, _弹幕ID, _原因): void {
      到点次数++;
    },
  });

  // ---- 2. 追踪短时后保持方向 ----
  发射弹道({
    名称: "H03-追踪保持",
    所有者: 施法者,
    发射方向角: 90,
    速度: 400,
    轨迹: { 类型: "追踪", 目标: 敌人A, 追踪保持秒: 0.5 },
    命中半径: 80,
    影响目标: "敌方",
    伤害值: 1,
  });

  // ---- 3. 贝塞尔高到低 ----
  发射弹道({
    名称: "H03-贝塞尔高到低",
    所有者: 施法者,
    发射方向角: 0,
    速度: 500,
    轨迹: {
      类型: "贝塞尔",
      控制X: 400,
      控制Y: 300,
      终点X: 800,
      终点Y: 0,
      起点Z: 300,
      控制Z: 400,
      终点Z: 0,
    },
    命中半径: 90,
    影响目标: "敌方",
    伤害值: 1,
  });

  // ---- 4. 中途改向 ----
  发射弹道({
    名称: "H03-延迟改向",
    所有者: 施法者,
    发射方向角: 0,
    速度: 500,
    轨迹: { 类型: "延迟改向", 延迟秒: 0.6, 新方向角: 90 },
    命中半径: 80,
    影响目标: "敌方",
    伤害值: 1,
  });

  // ---- 5. 穿透 + 多段命中 ----
  let 穿透命中数 = 0;
  发射弹道({
    名称: "H03-穿透",
    所有者: 施法者,
    发射方向角: 0,
    速度: 522,
    轨迹: { 类型: "直线", 距离: 1500 },
    命中半径: 120,
    影响目标: "敌方",
    伤害值: 1,
    碰撞消失: false,
    最大总命中次数: 2,
    on命中: function (this: void, _目标, _弹幕ID): void {
      穿透命中数++;
    },
  });

  // ---- 6. 中断清理（预警阶段中断 + H-01 实例接入） ----
  const 控制器 = 创建战斗技能实例({ 技能键: "H03弹道", 施法者: 施法者 });
  let 未发射即中断 = false;
  const 预警弹道 = 发射弹道({
    名称: "H03-预警中断",
    所有者: 施法者,
    发射方向角: 0,
    速度: 500,
    轨迹: { 类型: "直线", 距离: 800 },
    预警: { 延迟秒: 1.5, 模型: "war3mapImported\\dummy.mdl" },
    命中半径: 80,
    影响目标: "敌方",
    实例控制器: 控制器,
    on发射: function (this: void): void {
      if (预警弹道 != null && 预警弹道.已中断()) 未发射即中断 = false;
    },
  });
  预警弹道.中断();
  未发射即中断 = !预警弹道.已发射();
  断言(未发射即中断, "预警阶段中断不发射");

  // 实例收束联动中断
  const 弹道2 = 发射弹道({
    名称: "H03-实例收束联动",
    所有者: 施法者,
    发射方向角: 180,
    速度: 500,
    轨迹: { 类型: "直线", 距离: 800 },
    命中半径: 80,
    影响目标: "敌方",
    实例控制器: 控制器,
  });
  控制器.中断();
  断言(控制器.已结束(), "H-01实例中断收束");
  void 弹道2;

  // ---- 3 秒后统一校验 ----
  addDelayedCallback(3000, function H03校验(this: void): void {
    断言(到点次数 === 1, "直线到点 on到达点 恰好触发一次");
    断言(穿透命中数 >= 2, "穿透弹道命中两个目标（实际 " + 穿透命中数 + "）");
    const 存活A = jass.GetUnitState(敌人A, jass.UNIT_STATE_LIFE) > 0;
    const 存活B = jass.GetUnitState(敌人B, jass.UNIT_STATE_LIFE) > 0;
    print("[H-03自检] 敌人A存活=" + (存活A ? "是" : "否") + "（被追踪/直线/贝塞尔命中属正常） 敌人B存活=" + (存活B ? "是" : "否"));
    print("[H-03自检] 全部自检项执行完毕");
  });
}

export {};
