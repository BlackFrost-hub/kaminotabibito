/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 净化负面, 恢复生命魔法, 取最大生命, 播放单位特效, 监听装备丢弃清理, 第二章后段Boss战利品装备名, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 创建窗口承伤次数触发器 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/10．窗口承伤次数触发";

function 古树之心护符过滤(this: void, event: any): boolean {
  return 单位持有第二章后段Boss战利品(event.单位, 第二章后段Boss战利品装备名.古树之心护符);
}

function on古树之心护符触发(this: void, event: any): void {
  const target = event.单位;
  净化负面(target);
  恢复生命魔法(target, target, 取最大生命(target) * 0.08);
  播放单位特效(装备小特效.护盾闪光, target, "origin", 0.8);
}

const 古树之心护符承伤次数 = 创建窗口承伤次数触发器({
  名称: "古树之心护符",
  次数阈值: 4,
  过滤伤害: 古树之心护符过滤,
  on触发: on古树之心护符触发,
});

监听装备丢弃清理(第二章后段Boss战利品装备名.古树之心护符, function 清空古树之心护符次数(this: void, unit: any): void {
  古树之心护符承伤次数.清空(unit);
});

export {};
