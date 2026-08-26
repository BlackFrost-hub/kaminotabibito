/** @noSelfInFile */
/**
 * 薄 Boss 阶段编排工厂组合示例自检（H-04）
 *
 * 默认关闭；进图后手动调用 运行H04自检()。
 * 演示并验证与 战斗技能调度器 的组合方式：
 *   1. 阶段切换顺序：旧阶段 on离开 → 旧阶段篮子清理 → 新阶段 on进入
 *   2. 阶段技能池：为两个技能生成阶段允许函数，切换阶段后池外技能被禁
 *   3. 阶段清理篮子：离开时登记项被清理
 *   4. 销毁幂等：重复调用只离开一次
 * 公共层不含任何 Boss 世界观内容（示例用通用测试单位）。
 */

import {
  创建薄Boss阶段编排,
  为技能生成阶段允许,
} from "../../04．机制组件/10．复杂战斗通用机制/28．薄Boss阶段编排工厂";

const jass = require("jass.common") as any;
const Player = jass.Player as (this: void, index: number) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
function 空输出(this: void, _消息: string): void {}
const print = (jass.print as ((this: void, s: string) => void) | undefined) ?? 空输出;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const 农民单位类型 = stringToFourCCSafe("hpea");
const 事件日志: string[] = [];

function 断言(this: void, 条件: boolean, 消息: string): void {
  print("[H-04自检] " + (条件 ? "通过: " : "失败: ") + 消息);
}

export function 运行H04自检(this: void): void {
  const boss = CreateUnit(Player(15), 农民单位类型, 0, 0, 0);
  if (boss == null) {
    print("[H-04自检] 无法创建测试单位，中止");
    return;
  }

  let 阶段一离开次数 = 0;
  let 阶段二进入次数 = 0;
  let 篮子清理次数 = 0;
  let 销毁离开次数 = 0;

  const 编排 = 创建薄Boss阶段编排({
    名称: "H04-测试编排",
    单位: boss,
    初始阶段ID: "P1",
    阶段列表: [
      {
        ID: "P1",
        技能池: ["技能A", "技能B"],
        on离开: function (this: void): void {
          阶段一离开次数++;
          事件日志.push("P1离开");
        },
      },
      {
        ID: "P2",
        血量百分比: 0.5,
        技能池: ["技能B", "技能C"],
        on进入: function (this: void, 编排实例: any): void {
          阶段二进入次数++;
          事件日志.push("P2进入");
          const 阶段篮子 = 编排实例.取阶段清理篮子("P2");
          if (阶段篮子 != null) {
            阶段篮子.登记清理("示例-清理计数", function P2阶段篮子清理(this: void): void {
              篮子清理次数++;
            });
          }
        },
        on离开: function (this: void): void {
          销毁离开次数++;
          事件日志.push("P2离开");
        },
      },
    ],
  });

  // 阶段允许函数（战斗技能调度器 战斗技能定义.阶段允许 接入方式）
  const 技能A允许 = 为技能生成阶段允许(编排, "技能A");
  const 技能B允许 = 为技能生成阶段允许(编排, "技能B");
  const 技能C允许 = 为技能生成阶段允许(编排, "技能C");

  断言(编排.取当前阶段ID() === "P1", "初始阶段 P1");
  断言(技能A允许(), "P1 阶段池允许技能A");
  断言(技能C允许() === false, "P1 阶段池禁止技能C");

  // 业务条件触发：进入 P2（顺序：P1离开 → P1篮子清理 → P2进入）
  编排.手动进入阶段("P2", 0.5);
  断言(编排.取当前阶段ID() === "P2", "业务条件进入 P2");
  断言(阶段一离开次数 === 1 && 阶段二进入次数 === 1, "P1离开 → P2进入 各一次");
  断言(技能A允许() === false, "P2 阶段池禁止技能A");
  断言(技能C允许(), "P2 阶段池允许技能C");
  // 防重复进入
  断言(编排.手动进入阶段("P2", 0.5) === false, "同阶段重复进入被拒");

  // 回到已离开阶段后，必须得到新的可登记篮子。
  断言(编排.手动进入阶段("P1", 1), "允许业务条件回到 P1");
  const 重入阶段篮子 = 编排.取阶段清理篮子("P1");
  断言(重入阶段篮子 != null && !重入阶段篮子.已清理(), "P1 重入后阶段篮子已重建");
  断言(篮子清理次数 === 1, "首次离开 P2 时清理阶段篮子");
  断言(编排.手动进入阶段("P2", 0.5), "再次进入 P2");
  断言(阶段一离开次数 === 2 && 阶段二进入次数 === 2, "阶段重入回调次数正确");

  // 销毁：P2 离开 + 全部阶段篮子清理（幂等）
  编排.销毁();
  编排.销毁();
  断言(销毁离开次数 === 2, "销毁幂等（每次实际离开 P2 各一次）");
  断言(篮子清理次数 === 2, "两代 P2 阶段篮子均完成清理");
  print("[H-04自检] 事件顺序: " + 事件日志.join(" → "));
  print("[H-04自检] 全部自检项执行完毕");
}

export {};
