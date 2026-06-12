/** @noSelfInFile */

const japi = require("jass.japi") as any;

import { createFrame as 创建帧 } from "../../09．表现系统/01．UI工具/01．帧创建";
import { FramePoint, FrameType } from "../../09．表现系统/01．UI工具/00．类型定义";
import { setFramePointRelative as 设置帧相对位置, setFrameSize as 设置帧尺寸 } from "../../09．表现系统/01．UI工具/02．位置尺寸";
import { setFrameTexture as 设置帧贴图 } from "../../09．表现系统/01．UI工具/03．内容设置";

const 战利品选择贴图 = "UI\\BossReward\\text_loot_select_256x64.tga";
const F7打开关闭贴图 = "UI\\BossReward\\text_f7_toggle_256x64.tga";

export function 创建首领奖励标题贴图(this: void, 父帧: number, 后缀: string): void {
  const 战利品标题 = 创建帧({
    type: FrameType.BACKDROP,
    name: "首领奖励战利品选择标题" + 后缀,
    parent: 父帧,
    template: "template",
    visible: true,
  }) || 0;
  if (战利品标题 !== 0) {
    设置帧相对位置(战利品标题, FramePoint.CENTER, 父帧, FramePoint.CENTER, -0.100, 0.125);
    设置帧尺寸(战利品标题, { width: 0.096, height: 0.0240 });
    设置帧贴图(战利品标题, 战利品选择贴图);
    japi.DzFrameSetPriority(战利品标题, 40);
  }

  const F7提示 = 创建帧({
    type: FrameType.BACKDROP,
    name: "首领奖励F7打开关闭标题" + 后缀,
    parent: 父帧,
    template: "template",
    visible: true,
  }) || 0;
  if (F7提示 !== 0) {
    设置帧相对位置(F7提示, FramePoint.CENTER, 父帧, FramePoint.CENTER, 0.100, 0.125);
    设置帧尺寸(F7提示, { width: 0.096, height: 0.0240 });
    设置帧贴图(F7提示, F7打开关闭贴图);
    japi.DzFrameSetPriority(F7提示, 40);
  }
}
