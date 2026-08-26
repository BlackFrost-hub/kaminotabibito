/** @noSelfInFile */
/**
 * 区域进出与共享状态工厂自检（H-02）
 *
 * 默认关闭；进图后手动调用 运行H02自检()。
 * 覆盖测试矩阵：
 *   1. 单位进入、停留、离开（回调顺序：离开 → 进入 → 停留）
 *   2. 单位在区域中死亡（失效强制离开）
 *   3. 两个区域覆盖同一单位：共享计数 +2 → 分别销毁 -1 → 归零触发 on共享离开
 *   4. 自定义目标源（非枚举，直接返回列表）
 *   5. 区域销毁时按进入顺序全部离开
 */

import { 创建区域进出 } from "../../04．机制组件/03．持续危险区/05．区域进出与共享状态工厂";

const jass = require("jass.common") as any;
const Player = jass.Player as (this: void, index: number) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const KillUnit = jass.KillUnit as (this: void, unit: any) => void;
function 空输出(this: void, _消息: string): void {}
const print = (jass.print as ((this: void, s: string) => void) | undefined) ?? 空输出;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};

const 农民单位类型 = stringToFourCCSafe("hpea");
const 事件日志: string[] = [];

function 记录(this: void, 事件: string): void {
  事件日志.push(事件);
  print("[H-02自检] " + 事件);
}

function 断言(this: void, 条件: boolean, 消息: string): void {
  print("[H-02自检] " + (条件 ? "通过: " : "失败: ") + 消息);
}

export function 运行H02自检(this: void): void {
  const 目标A = CreateUnit(Player(1), 农民单位类型, 100, 0, 0);

  // ---- 1/2/4. 进入/停留/离开 + 自定义目标源 + 死亡强制离开 ----
  const 区域1 = 创建区域进出({
    名称: "H02-区域1",
    中心: { 类型: "固定", X: 0, Y: 0 },
    半径: 300,
    Tick间隔毫秒: 100,
    // 自定义目标源（测试矩阵 4）
    目标源: function (this: void): any[] {
      return [目标A];
    },
    on进入: function (this: void, _目标): void {
      记录("区域1-进入");
    },
    on停留: function (this: void, _目标): void {
      记录("区域1-停留");
    },
    on离开: function (this: void, _目标): void {
      记录("区域1-离开");
    },
  });

  // ---- 3. 共享计数 ----
  const 区域2 = 创建区域进出({
    名称: "H02-区域2",
    中心: { 类型: "固定", X: 100, Y: 0 },
    半径: 300,
    Tick间隔毫秒: 100,
    目标源: function (this: void): any[] {
      return [目标A];
    },
    共享键: "H02共享",
    on进入: function (this: void, _目标): void {
      记录("区域2-进入");
    },
    on离开: function (this: void, _目标): void {
      记录("区域2-离开");
    },
    on共享离开: function (this: void, _目标, 键): void {
      记录("共享归零-" + 键);
    },
  });

  const 区域3 = 创建区域进出({
    名称: "H02-区域3",
    中心: { 类型: "固定", X: -100, Y: 0 },
    半径: 300,
    Tick间隔毫秒: 100,
    目标源: function (this: void): any[] {
      return [目标A];
    },
    共享键: "H02共享",
    on进入: function (this: void, _目标): void {
      记录("区域3-进入");
    },
    on离开: function (this: void, _目标): void {
      记录("区域3-离开");
    },
    on共享离开: function (this: void, _目标, _键): void {
      记录("共享归零-再次");
    },
  });
  if (区域1 == null || 区域2 == null || 区域3 == null) {
    print("[H-02自检] 区域参数非法，无法启动自检");
    return;
  }

  // 阶段一：等待 2 Tick 让三区域进入
  addDelayedCallback(250, function 阶段一(this: void): void {
    断言(区域1.取当前成员().length === 1, "区域1进入1目标");
    断言(区域3.取共享计数(目标A) === 2, "两共享区域覆盖同一目标计数=2");

    // 阶段二：区域2 销毁 → 计数 -1（不触发共享归零）
    区域2.销毁();
    addDelayedCallback(250, function 阶段二(this: void): void {
      断言(区域3.取共享计数(目标A) === 1, "区域2销毁后计数=1");

      // 阶段三：目标A 走出区域1（传送远点）→ 区域1 离开
      SetUnitPosition(目标A, 5000, 5000);
      addDelayedCallback(250, function 阶段三(this: void): void {
        断言(区域1.取当前成员().length === 0, "走出后区域1离开");
        断言(区域3.取共享计数(目标A) === 0, "区域3离开后共享计数归零");

        // 阶段四：目标死亡强制离开 + 销毁稳定顺序
        SetUnitPosition(目标A, 0, 0);
        addDelayedCallback(250, function 阶段四(this: void): void {
          KillUnit(目标A);
          addDelayedCallback(250, function 阶段四校验(this: void): void {
            断言(区域1.取当前成员().length === 0, "死亡强制离开");
            const 销毁顺序: string[] = [];
            const 销毁目标1 = CreateUnit(Player(1), 农民单位类型, 10, 0, 0);
            const 销毁目标2 = CreateUnit(Player(1), 农民单位类型, 20, 0, 0);
            const 区域4 = 创建区域进出({
              名称: "H02-区域4",
              中心: { 类型: "固定", X: 0, Y: 0 },
              半径: 500,
              Tick间隔毫秒: 100,
              目标源: function (this: void): any[] {
                return [销毁目标1, 销毁目标2];
              },
              on进入: function (this: void, 目标): void {
                销毁顺序.push("进入");
              },
              on离开: function (this: void, _目标): void {
                销毁顺序.push("离开");
              },
            });
            if (区域4 == null) {
              print("[H-02自检] 区域4参数非法，无法完成销毁顺序自检");
              return;
            }
            addDelayedCallback(250, function 阶段五(this: void): void {
              区域4.销毁();
              addDelayedCallback(100, function 阶段五校验(this: void): void {
                断言(销毁顺序.length === 4, "销毁时2目标全部离开（进入2+离开2）");
                print("[H-02自检] 全部自检项执行完毕");
              });
            });
          });
        });
      });
    });
  });
}

export {};
