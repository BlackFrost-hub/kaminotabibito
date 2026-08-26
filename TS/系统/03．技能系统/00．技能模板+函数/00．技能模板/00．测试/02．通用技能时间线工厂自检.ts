/** @noSelfInFile */
// 通用技能时间线工厂自检（默认关闭：不注册、不被任何模块导入）。
// 需要 JASS 真实单位句柄，进图环境手动调用 `运行时间线工厂自检(英雄)`。

import { 创建通用技能时间线, 停止通用技能时间线 } from "../01．多阶段技能编排/07．通用技能时间线工厂";

export function 运行时间线工厂自检(this: void, 英雄: any): string[] {
  const 结果: string[] = [];
  if (英雄 == null || 英雄 === 0) {
    结果.push("FAIL 无效测试单位");
    return 结果;
  }

  // 1. 三段时间线（立即 + 延迟 + 立即），结束回调只执行一次
  let 结束次数 = 0;
  let 最后原因 = "";
  const id = 创建通用技能时间线({
    单位: 英雄,
    阶段: [
      { 名称: "起手", 业务: function (this: void, _u: any, 数据: Record<string, any>, 完成: (this: void) => void): void { 数据["起手执行"] = true; 完成(); } },
      { 名称: "前摇", 延迟秒: 0.2, 业务: function (this: void, _u: any, _数据: Record<string, any>, 完成: (this: void) => void): void { 完成(); } },
      { 名称: "结算", 业务: function (this: void, _u: any, _数据: Record<string, any>, 完成: (this: void) => void): void { 完成(); } },
    ],
    数据: {},
    结束回调: function (this: void, _u: any, 原因: string, _id: number): void {
      结束次数 += 1;
      最后原因 = 原因;
    },
  });
  结果.push("INFO 三段时间线: 创建ID=" + id + "，进图观察 0.2 秒后完成，结束次数=1");
  结果.push("INFO 结束原因=" + 最后原因 + "（完成/中断/死亡/主单位死亡/自我打断）");

  // 2. 主动停止（中断），结束回调只执行一次
  const id2 = 创建通用技能时间线({
    单位: 英雄,
    阶段: [{ 名称: "长前摇", 延迟秒: 3, 业务: function (this: void, _u: any, _d: Record<string, any>, 完成: (this: void) => void): void { 完成(); } }],
    结束回调: function (this: void, _u: any, 原因: string, _id: number): void { 结果.push("INFO 停止回调原因=" + 原因); },
  });
  const 停止成功 = id2 !== 0 && 停止通用技能时间线(id2, "中断");
  结果.push((停止成功 ? "PASS " : "FAIL ") + "主动停止-中断返回true");

  // 3. 无效输入
  const id3 = 创建通用技能时间线({ 单位: 英雄, 阶段: [] });
  结果.push((id3 === 0 ? "PASS " : "FAIL ") + "空阶段返回0");

  // 4. 死亡中断（进图 KillUnit 验证）
  结果.push("INFO 死亡中断: 创建长前摇时间线后 KillUnit(英雄) 应自动中断并回调原因=死亡，进图验证");

  return 结果;
}

export {};
