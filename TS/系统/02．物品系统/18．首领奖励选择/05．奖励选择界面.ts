/** @noSelfInFile */

import { createFrame as 创建帧 } from "../../09．表现系统/01．UI工具/01．帧创建";
import { FramePoint, FrameType } from "../../09．表现系统/01．UI工具/00．类型定义";
import { setFramePosition as 设置帧位置, setFrameSize as 设置帧尺寸 } from "../../09．表现系统/01．UI工具/02．位置尺寸";
import { setFrameTexture as 设置帧贴图 } from "../../09．表现系统/01．UI工具/03．内容设置";
import { getGameUIFrame as 获取游戏UI帧, hideFrame as 隐藏帧, showFrame as 显示帧 } from "../../09．表现系统/01．UI工具/05．帧控制";

const 首领奖励面板贴图 = "UI\\BossReward\\boss_reward_panel_v2.tga";
const 首领奖励面板宽度 = 0.58;
const 首领奖励面板高度 = 0.326;
const 首领奖励面板中心X = 0.4;
const 首领奖励面板中心Y = 0.34;

let 首领奖励面板帧 = 0;
let 首领奖励界面已初始化 = false;

function 创建首领奖励面板兜底(this: any): number | null {
  const 父帧 = 获取游戏UI帧();
  return 创建帧({
    type: FrameType.BACKDROP,
    name: "BossRewardPanelBackdropFallback",
    parent: 父帧,
    template: "template",
    id: 0,
    visible: false,
  });
}

export function 初始化首领奖励选择界面(this: void): void {
  if (首领奖励界面已初始化) return;
  首领奖励界面已初始化 = true;

  const 面板 = 创建首领奖励面板兜底();

  if (面板 == null || 面板 === 0) return;
  首领奖励面板帧 = 面板;
  设置帧尺寸(面板, {
    width: 首领奖励面板宽度,
    height: 首领奖励面板高度,
  });
  设置帧位置(面板, {
    point: FramePoint.CENTER,
    x: 首领奖励面板中心X,
    y: 首领奖励面板中心Y,
  });
  设置帧贴图(面板, 首领奖励面板贴图);
  隐藏帧(面板);
}

export function 显示首领奖励选择界面(this: void): void {
  初始化首领奖励选择界面();
  if (首领奖励面板帧 !== 0) 显示帧(首领奖励面板帧);
}

export function 隐藏首领奖励选择界面(this: void): void {
  if (首领奖励面板帧 !== 0) 隐藏帧(首领奖励面板帧);
}

export function 获取首领奖励面板帧(this: void): number {
  初始化首领奖励选择界面();
  return 首领奖励面板帧;
}
