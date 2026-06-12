/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { createFrame as 创建帧 } from "../../09．表现系统/01．UI工具/01．帧创建";
import { FramePoint, FrameType } from "../../09．表现系统/01．UI工具/00．类型定义";
import { setFramePosition as 设置帧位置, setFramePointRelative as 设置帧相对位置, setFrameSize as 设置帧尺寸 } from "../../09．表现系统/01．UI工具/02．位置尺寸";
import { setButtonText as 设置按钮文本, setFrameClickEvent as 设置帧点击事件, setFrameTexture as 设置帧贴图 } from "../../09．表现系统/01．UI工具/03．内容设置";
import { getGameUIFrame as 获取游戏UI帧, hideFrame as 隐藏帧, showFrame as 显示帧 } from "../../09．表现系统/01．UI工具/05．帧控制";
import 英雄选择配置表 from "../../00．核心系统/00．玩家系统/01．英雄选择/00．英雄选择配置表";
import { 首领奖励池配置 } from "./00．类型定义";
import { 查找首领奖励池 } from "./01．奖励配置表";
import { 领取首领奖励选择 } from "./03．奖励发放";
import { 获取首领奖励装备详情 } from "./06．奖励详情资料";
import { 格式化奖励属性列, 格式化奖励特效列表 } from "./07．奖励选择文本格式";
import { 发放首领奖励装备 } from "./08．奖励物品发放";
import { 记录首领奖励待选择, 清除首领奖励待选择, 自动随机发放旧待选择首领奖励 } from "./09．待选择奖励";
import { 创建首领奖励标题贴图 } from "./11．奖励标题贴图";
import { 创建首领奖励底部操作按钮 } from "./12．底部操作按钮";

const 首领奖励面板贴图 = "UI\\BossReward\\boss_reward_panel_v2.tga";
const 选中边框贴图 = "UI\\BossReward\\reward_selected_border.tga";
const 勾选标记贴图 = "UI\\BossReward\\reward_check_badge.tga";
const 详情装饰贴图 = "UI\\BossReward\\boss_reward_detail_overlay.tga";
const 首领奖励面板宽度 = 0.58;
const 首领奖励面板高度 = 0.326;
const 首领奖励面板中心X = 0.4;
const 首领奖励面板中心Y = 0.34;
const 颜色标题 = "|cffffe6a6";
const 颜色正文 = "|cff000000";
const 颜色小标题 = "|cffffcc5c";
const 颜色按钮 = "|cffffffff";
const 颜色结束 = "|r";
const 槽位中心X: number[] = [-0.216, -0.144, -0.073, 0.000, 0.071, 0.143, 0.215];
const 槽位图标Y = 0.076;
const 槽位按钮Y = 0.053;
const 槽位内嵌图标宽度 = 0.048;
const 槽位内嵌图标高度 = 0.041;
const 槽位内嵌图标偏移X = 0.0018;
const 槽位内嵌图标偏移Y = 0.0016;
const 槽位点击宽度 = 0.059;
const 槽位点击高度 = 0.051;
const 槽位选中边框宽度 = 0.056;
const 槽位选中边框高度 = 0.048;
const 槽位勾选尺寸 = 0.031;
const 槽位勾选偏移X = 0.017;
const 槽位勾选偏移Y = -0.013;
const 槽位按钮宽度 = 0.040;
const 槽位按钮高度 = 0.015;
const 确认按钮Y = -0.126;
const 确认领取命中X = -0.150;
const 确认领取命中Y = -0.129;
const 确认领取命中宽度 = 0.116;
const 确认领取命中高度 = 0.026;
const 暂不选择命中X = 0.143;
const 暂不选择命中Y = -0.126;
const 暂不选择命中宽度 = 确认领取命中宽度;
const 暂不选择命中高度 = 确认领取命中高度;

const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (玩家: any, x: number, y: number, 持续时间: number, 文本: string) => void;
const GetPlayerId = jass.GetPlayerId as (玩家: any) => number;
const GetLocalPlayer = jass.GetLocalPlayer as () => any;
const Player = jass.Player as (玩家ID: number) => any;

interface 首领奖励槽位状态 {
  槽位ID: number;
  玩家ID: number;
  玩家: any;
  面板帧: number;
  当前奖励池: 首领奖励池配置 | null;
  当前奖励池ID: string;
  当前详情序号: number;
  面板已显示: boolean;
  内容已创建: boolean;
  选项按钮: number[];
  选项图标: number[];
  选项图标按钮: number[];
  选中边框: number[];
  勾选标记: number[];
  已选择: boolean[];
  详情装饰: number;
  详情图标: number;
  详情标题: number;
  详情分类: number;
  详情评分: number;
  详情描述: number;
  详情属性: number;
  详情属性二: number;
  详情属性三: number;
  详情特效: number;
  确认按钮: number;
  关闭按钮: number;
  确认按钮文字: number;
  关闭按钮文字: number;
}

interface 首领奖励选项点击路由 {
  槽位ID: number;
  序号: number;
}

let 首领奖励界面已初始化 = false;
let 首领奖励首个面板帧 = 0;
const 首领奖励槽位表: Record<number, 首领奖励槽位状态 | undefined> = {};
const 选项点击路由表: Record<number, 首领奖励选项点击路由 | undefined> = {};
const 确认点击路由表: Record<number, number | undefined> = {};
const 关闭点击路由表: Record<number, number | undefined> = {};

function 创建槽位状态(this: void, 玩家ID: number): 首领奖励槽位状态 {
  return {
    槽位ID: 玩家ID,
    玩家ID,
    玩家: Player(玩家ID),
    面板帧: 0,
    当前奖励池: null,
    当前奖励池ID: "",
    当前详情序号: 0,
    面板已显示: false,
    内容已创建: false,
    选项按钮: [],
    选项图标: [],
    选项图标按钮: [],
    选中边框: [],
    勾选标记: [],
    已选择: [],
    详情装饰: 0,
    详情图标: 0,
    详情标题: 0,
    详情分类: 0,
    详情评分: 0,
    详情描述: 0,
    详情属性: 0,
    详情属性二: 0,
    详情属性三: 0,
    详情特效: 0,
    确认按钮: 0,
    关闭按钮: 0,
    确认按钮文字: 0,
    关闭按钮文字: 0,
  };
}

function 获取槽位状态(this: void, 玩家ID: number): 首领奖励槽位状态 | undefined {
  return 首领奖励槽位表[玩家ID];
}

function 获取本地玩家ID(this: void): number {
  const 本地玩家 = GetLocalPlayer();
  if (本地玩家 == null || 本地玩家 === 0) return -1;
  return GetPlayerId(本地玩家);
}

function 是否本地槽位(this: void, 状态: 首领奖励槽位状态): boolean {
  const 本地玩家 = GetLocalPlayer();
  return 状态.玩家 != null && 状态.玩家 !== 0 && 状态.玩家 === 本地玩家;
}

function 获取触发UI帧(this: void): number {
  if ((japi as any).DzGetTriggerUIEventFrame != null) return (japi as any).DzGetTriggerUIEventFrame();
  return 0;
}

function 获取触发UI玩家(this: void): any {
  if ((japi as any).DzGetTriggerKeyPlayer != null) return (japi as any).DzGetTriggerKeyPlayer();
  if ((japi as any).DzGetTriggerUIEventPlayer != null) return (japi as any).DzGetTriggerUIEventPlayer();
  return GetLocalPlayer();
}

function 获取触发玩家ID(this: void): number {
  const 玩家 = 获取触发UI玩家();
  if (玩家 == null || 玩家 === 0) return -1;
  return GetPlayerId(玩家);
}

function 触发玩家匹配槽位(this: void, 状态: 首领奖励槽位状态): boolean {
  return 获取触发玩家ID() === 状态.玩家ID;
}

function 获取槽位后缀(this: void, 状态: 首领奖励槽位状态): string {
  return "_s" + 状态.槽位ID;
}

function 获取鼠标焦点帧(this: void): number {
  if ((japi as any).DzGetMouseFocus != null) return (japi as any).DzGetMouseFocus();
  return 0;
}

function 获取父帧(this: void, 帧: number): number {
  if (帧 === 0 || (japi as any).DzFrameGetParent == null) return 0;
  return (japi as any).DzFrameGetParent(帧);
}

function 查找选项点击路由(this: void, 起始帧: number): 首领奖励选项点击路由 | undefined {
  let 帧 = 起始帧;
  for (let 层级 = 0; 层级 < 8; 层级++) {
    if (帧 === 0) return undefined;
    const 路由 = 选项点击路由表[帧];
    if (路由 != null) return 路由;
    帧 = 获取父帧(帧);
  }
  return undefined;
}

function 查找按钮槽位路由(this: void, 起始帧: number, 路由表: Record<number, number | undefined>): number | undefined {
  let 帧 = 起始帧;
  for (let 层级 = 0; 层级 < 8; 层级++) {
    if (帧 === 0) return undefined;
    const 槽位ID = 路由表[帧];
    if (槽位ID != null) return 槽位ID;
    帧 = 获取父帧(帧);
  }
  return undefined;
}

function 创建首领奖励面板兜底(this: void, 状态: 首领奖励槽位状态): number | null {
  return 创建帧({
    type: FrameType.BACKDROP,
    name: "BossRewardPanelBackdropFallback" + 获取槽位后缀(状态),
    parent: 获取游戏UI帧(),
    template: "template",
    id: 0,
    visible: false,
  });
}

function 提示(this: void, 状态: 首领奖励槽位状态, 文本: string): void {
  if (状态.玩家 != null && 状态.玩家 !== 0) {
    DisplayTimedTextToPlayer(状态.玩家, 0, 0, 8, "|cffffcc00[首领奖励]|r " + 文本);
  }
}

function 设置文本帧文字(this: void, 帧: number, 文本: string): void {
  if (帧 !== 0) japi.DzFrameSetText(帧, 文本);
}

function 设置文本帧字体大小(this: void, 帧: number, 字号: number): void {
  if (帧 !== 0) japi.DzFrameSetFont(帧, "Fonts\\dfst-m3u.ttf", 字号, 0);
}

function 创建文本帧(this: void, 状态: 首领奖励槽位状态, 名字: string, 父帧: number, 文本: string, x: number, y: number, 宽度: number, 高度: number): number {
  const 文本帧 = 创建帧({
    type: FrameType.TEXT,
    name: 名字 + 获取槽位后缀(状态),
    parent: 父帧,
    template: "template",
    visible: true,
    enable: false,
  }) || 0;
  if (文本帧 === 0) return 0;
  设置帧相对位置(文本帧, FramePoint.TOPLEFT, 父帧, FramePoint.CENTER, x, y);
  设置帧尺寸(文本帧, { width: 宽度, height: 高度 });
  japi.DzFrameSetTextAlignment(文本帧, 0);
  japi.DzFrameSetFont(文本帧, "Fonts\\dfst-m3u.ttf", 0.0135, 0);
  japi.DzFrameSetTextColor(文本帧, 0, 0, 0, 255);
  japi.DzFrameSetPriority(文本帧, 20);
  japi.DzFrameSetText(文本帧, 文本);
  return 文本帧;
}

function 创建文字按钮(this: void, 状态: 首领奖励槽位状态, 名字: string, 父帧: number, 文字: string, x: number, y: number, 宽度: number, 高度: number, 点击函数: (this: void) => void): number {
  const 按钮 = 创建帧({
    type: FrameType.GLUETEXTBUTTON,
    name: 名字 + 获取槽位后缀(状态),
    parent: 父帧,
    template: "template",
    visible: true,
    enable: true,
  }) || 0;
  if (按钮 === 0) return 0;
  设置帧相对位置(按钮, FramePoint.CENTER, 父帧, FramePoint.CENTER, x, y);
  设置帧尺寸(按钮, { width: 宽度, height: 高度 });
  japi.DzFrameSetTextAlignment(按钮, 18);
  japi.DzFrameSetFont(按钮, "Fonts\\dfst-m3u.ttf", 0.015, 0);
  japi.DzFrameSetPriority(按钮, 30);
  设置按钮文本(按钮, 文字);
  设置帧点击事件(按钮, 点击函数 as any, true);
  return 按钮;
}

function 获取当前装备名(this: void, 状态: 首领奖励槽位状态, 序号: number): string {
  if (状态.当前奖励池 == null) return "";
  const 选项 = 状态.当前奖励池.选项[序号];
  return 选项 != null ? 选项.装备名 : "";
}

function 统计选择数量(this: void, 状态: 首领奖励槽位状态): number {
  let 数量 = 0;
  if (状态.当前奖励池 == null) return 0;
  for (let 序号 = 0; 序号 < 状态.当前奖励池.选项.length; 序号++) {
    if (状态.已选择[序号]) 数量++;
  }
  return 数量;
}

function 收集已选装备名(this: void, 状态: 首领奖励槽位状态): string[] {
  const 结果: string[] = [];
  if (状态.当前奖励池 == null) return 结果;
  for (let 序号 = 0; 序号 < 状态.当前奖励池.选项.length; 序号++) {
    if (状态.已选择[序号]) 结果.push(状态.当前奖励池.选项[序号].装备名);
  }
  return 结果;
}

function 刷新详情内容(this: void, 状态: 首领奖励槽位状态): void {
  const 装备名 = 获取当前装备名(状态, 状态.当前详情序号);
  const 选项 = 状态.当前奖励池?.选项[状态.当前详情序号];
  if (装备名 === "" || 选项 == null) return;
  const 详情 = 获取首领奖励装备详情(选项);
  if (状态.详情图标 !== 0) 设置帧贴图(状态.详情图标, 详情.图标);
  设置文本帧文字(状态.详情标题, 颜色标题 + 装备名 + 颜色结束);
  设置文本帧文字(状态.详情分类, 颜色正文 + 详情.分类 + "    " + 详情.等级 + 颜色结束);
  设置文本帧文字(状态.详情评分, 颜色正文 + 详情.评分 + 颜色结束);
  设置文本帧文字(状态.详情描述, 颜色正文 + 详情.描述 + 颜色结束);
  设置文本帧文字(状态.详情属性, 颜色正文 + 格式化奖励属性列(详情.属性, 0, 5) + 颜色结束);
  设置文本帧文字(状态.详情属性二, 颜色正文 + 格式化奖励属性列(详情.属性, 1, 5) + 颜色结束);
  设置文本帧文字(状态.详情属性三, 颜色正文 + 格式化奖励属性列(详情.属性, 2, 5) + 颜色结束);
  设置文本帧文字(状态.详情特效, 颜色正文 + 格式化奖励特效列表(详情.特效) + 颜色结束);
}

function 刷新选项显示(this: void, 状态: 首领奖励槽位状态): void {
  if (状态.当前奖励池 == null) return;
  for (let 序号 = 0; 序号 < 槽位中心X.length; 序号++) {
    const 可见 = 序号 < 状态.当前奖励池.选项.length;
    if (状态.选项图标[序号] !== 0) {
      if (可见) {
        const 详情 = 获取首领奖励装备详情(状态.当前奖励池.选项[序号]);
        设置帧贴图(状态.选项图标[序号], 详情.图标);
        显示帧(状态.选项图标[序号]);
      } else 隐藏帧(状态.选项图标[序号]);
    }
    if (状态.选项图标按钮[序号] !== 0) {
      if (可见) 显示帧(状态.选项图标按钮[序号]);
      else 隐藏帧(状态.选项图标按钮[序号]);
    }
    if (状态.选项按钮[序号] !== 0) {
      if (可见) 显示帧(状态.选项按钮[序号]);
      else 隐藏帧(状态.选项按钮[序号]);
    }
    if (状态.选中边框[序号] !== 0) {
      if (可见 && 状态.已选择[序号]) 显示帧(状态.选中边框[序号]);
      else 隐藏帧(状态.选中边框[序号]);
    }
    if (状态.勾选标记[序号] !== 0) {
      if (可见 && 状态.已选择[序号]) 显示帧(状态.勾选标记[序号]);
      else 隐藏帧(状态.勾选标记[序号]);
    }
  }
  if (状态.确认按钮文字 !== 0) {
    设置文本帧文字(状态.确认按钮文字, 颜色按钮 + "确认领取  " + 统计选择数量(状态) + "/" + 状态.当前奖励池.可选数量 + 颜色结束);
  }
}

function 切换选项(this: void, 状态: 首领奖励槽位状态, 序号: number): void {
  if (状态.当前奖励池 == null || 序号 >= 状态.当前奖励池.选项.length) return;
  状态.当前详情序号 = 序号;
  刷新详情内容(状态);
  if (!状态.已选择[序号] && 统计选择数量(状态) >= 状态.当前奖励池.可选数量) {
    提示(状态, "最多只能选择 " + 状态.当前奖励池.可选数量 + " 件装备。");
    return;
  }
  状态.已选择[序号] = !状态.已选择[序号];
  刷新选项显示(状态);
}

function 点击奖励选项帧(this: void): void {
  let 触发帧 = 获取触发UI帧();
  if (触发帧 === 0) 触发帧 = 获取鼠标焦点帧();
  const 路由 = 查找选项点击路由(触发帧);
  if (路由 == null) return;
  const 状态 = 获取槽位状态(路由.槽位ID);
  if (状态 == null || !触发玩家匹配槽位(状态)) return;
  切换选项(状态, 路由.序号);
}

function 创建选项图标按钮(this: void, 状态: 首领奖励槽位状态, 父帧: number, 序号: number): void {
  const 后缀 = 获取槽位后缀(状态);
  const 图标 = 创建帧({ type: FrameType.BACKDROP, name: "首领奖励选项图标" + 序号 + 后缀, parent: 父帧, template: "template", visible: true }) || 0;
  if (图标 !== 0) {
    设置帧相对位置(图标, FramePoint.CENTER, 父帧, FramePoint.CENTER, 槽位中心X[序号] + 槽位内嵌图标偏移X, 槽位图标Y + 槽位内嵌图标偏移Y);
    设置帧尺寸(图标, { width: 槽位内嵌图标宽度, height: 槽位内嵌图标高度 });
    japi.DzFrameSetPriority(图标, 20);
  }
  const 边框 = 创建帧({ type: FrameType.BACKDROP, name: "首领奖励选中边框" + 序号 + 后缀, parent: 图标 !== 0 ? 图标 : 父帧, template: "template", visible: false }) || 0;
  if (边框 !== 0) {
    if (图标 !== 0) 设置帧相对位置(边框, FramePoint.CENTER, 图标, FramePoint.CENTER, 0, 0);
    else 设置帧相对位置(边框, FramePoint.CENTER, 父帧, FramePoint.CENTER, 槽位中心X[序号], 槽位图标Y);
    设置帧尺寸(边框, { width: 槽位选中边框宽度, height: 槽位选中边框高度 });
    设置帧贴图(边框, 选中边框贴图);
    japi.DzFrameSetPriority(边框, 220);
  }
  const 勾选 = 创建帧({ type: FrameType.BACKDROP, name: "首领奖励勾选标记" + 序号 + 后缀, parent: 图标 !== 0 ? 图标 : 父帧, template: "template", visible: false }) || 0;
  if (勾选 !== 0) {
    if (图标 !== 0) 设置帧相对位置(勾选, FramePoint.CENTER, 图标, FramePoint.CENTER, 槽位勾选偏移X, 槽位勾选偏移Y);
    else 设置帧相对位置(勾选, FramePoint.CENTER, 父帧, FramePoint.CENTER, 槽位中心X[序号] + 槽位内嵌图标偏移X + 槽位勾选偏移X, 槽位图标Y + 槽位内嵌图标偏移Y + 槽位勾选偏移Y);
    设置帧尺寸(勾选, { width: 槽位勾选尺寸, height: 槽位勾选尺寸 });
    设置帧贴图(勾选, 勾选标记贴图);
    japi.DzFrameSetPriority(勾选, 240);
  }
  const 图标按钮 = 创建帧({ type: FrameType.GLUETEXTBUTTON, name: "首领奖励图标按钮" + 序号 + 后缀, parent: 父帧, template: "template", visible: true, enable: true, alpha: 0 }) || 0;
  if (图标按钮 !== 0) {
    设置帧相对位置(图标按钮, FramePoint.CENTER, 父帧, FramePoint.CENTER, 槽位中心X[序号], 槽位图标Y);
    设置帧尺寸(图标按钮, { width: 槽位点击宽度, height: 槽位点击高度 });
    japi.DzFrameSetPriority(图标按钮, 30);
    选项点击路由表[图标按钮] = { 槽位ID: 状态.槽位ID, 序号 };
    设置帧点击事件(图标按钮, 点击奖励选项帧 as any, true);
  }
  状态.选项图标[序号] = 图标;
  状态.选项图标按钮[序号] = 图标按钮;
  状态.选中边框[序号] = 边框;
  状态.勾选标记[序号] = 勾选;
}

function 隐藏槽位界面(this: void, 状态: 首领奖励槽位状态): void {
  状态.面板已显示 = false;
  if (状态.面板帧 !== 0 && 是否本地槽位(状态)) 隐藏帧(状态.面板帧);
}

function 显示槽位界面(this: void, 状态: 首领奖励槽位状态): void {
  状态.面板已显示 = true;
  if (状态.面板帧 !== 0 && 是否本地槽位(状态)) 显示帧(状态.面板帧);
}

function 确认领取槽位(this: void, 状态: 首领奖励槽位状态): void {
  if (状态.当前奖励池 == null) return;
  const 已选装备名 = 收集已选装备名(状态);
  if (已选装备名.length !== 状态.当前奖励池.可选数量) {
    提示(状态, "请先选择 " + 状态.当前奖励池.可选数量 + " 件装备。");
    return;
  }
  const 发放结果 = 领取首领奖励选择(状态.当前奖励池ID, 状态.玩家ID, 已选装备名);
  if (发放结果 !== "成功") {
    提示(状态, "领取失败：" + 发放结果);
    return;
  }
  let 成功数量 = 0;
  for (let 序号 = 0; 序号 < 已选装备名.length; 序号++) {
    if (发放首领奖励装备(状态.玩家, 已选装备名[序号])) 成功数量++;
  }
  清除首领奖励待选择(状态.当前奖励池ID, 状态.玩家ID);
  提示(状态, "已领取 " + 成功数量 + " 件装备。");
  隐藏槽位界面(状态);
}

function 点击确认领取帧(this: void): void {
  const 原始触发帧 = 获取触发UI帧();
  const 鼠标焦点帧 = 获取鼠标焦点帧();
  let 触发帧 = 原始触发帧;
  if (触发帧 === 0) 触发帧 = 鼠标焦点帧;
  const 槽位ID = 查找按钮槽位路由(触发帧, 确认点击路由表);
  if (槽位ID == null) {
    return;
  }
  const 状态 = 获取槽位状态(槽位ID);
  if (状态 == null) {
    return;
  }
  if (!触发玩家匹配槽位(状态)) {
    return;
  }
  确认领取槽位(状态);
}

function 点击关闭界面帧(this: void): void {
  const 原始触发帧 = 获取触发UI帧();
  const 鼠标焦点帧 = 获取鼠标焦点帧();
  let 触发帧 = 原始触发帧;
  if (触发帧 === 0) 触发帧 = 鼠标焦点帧;
  const 槽位ID = 查找按钮槽位路由(触发帧, 关闭点击路由表);
  if (槽位ID == null) {
    return;
  }
  const 状态 = 获取槽位状态(槽位ID);
  if (状态 == null) {
    return;
  }
  if (!触发玩家匹配槽位(状态)) {
    return;
  }
  隐藏槽位界面(状态);
  提示(状态, "已暂存本次奖励，可按 F7 再次打开选择。");
}

function 创建首领奖励内容(this: void, 状态: 首领奖励槽位状态): void {
  if (状态.内容已创建 || 状态.面板帧 === 0) return;
  const 父帧 = 状态.面板帧;
  创建首领奖励标题贴图(父帧, 获取槽位后缀(状态));
  for (let 序号 = 0; 序号 < 槽位中心X.length; 序号++) {
    状态.已选择[序号] = false;
    创建选项图标按钮(状态, 父帧, 序号);
    状态.选项按钮[序号] = 创建文字按钮(状态, "首领奖励选项按钮" + 序号, 父帧, "", 槽位中心X[序号], 槽位按钮Y, 槽位按钮宽度, 槽位按钮高度, 点击奖励选项帧);
    if (状态.选项按钮[序号] !== 0) 选项点击路由表[状态.选项按钮[序号]] = { 槽位ID: 状态.槽位ID, 序号 };
  }
  状态.详情装饰 = 创建帧({ type: FrameType.BACKDROP, name: "首领奖励详情装饰" + 获取槽位后缀(状态), parent: 父帧, template: "template", visible: true }) || 0;
  if (状态.详情装饰 !== 0) {
    设置帧相对位置(状态.详情装饰, FramePoint.CENTER, 父帧, FramePoint.CENTER, 0, 0);
    设置帧尺寸(状态.详情装饰, { width: 0.58, height: 0.326 });
    设置帧贴图(状态.详情装饰, 详情装饰贴图);
    japi.DzFrameSetPriority(状态.详情装饰, 6);
  }
  状态.详情图标 = 创建帧({ type: FrameType.BACKDROP, name: "首领奖励详情图标" + 获取槽位后缀(状态), parent: 父帧, template: "template", visible: true }) || 0;
  if (状态.详情图标 !== 0) {
    设置帧相对位置(状态.详情图标, FramePoint.CENTER, 父帧, FramePoint.CENTER, -0.211, -0.001);
    设置帧尺寸(状态.详情图标, { width: 0.046, height: 0.046 });
  }
  状态.详情标题 = 创建文本帧(状态, "首领奖励详情标题", 父帧, "", -0.168, 0.017, 0.125, 0.020);
  状态.详情分类 = 创建文本帧(状态, "首领奖励详情分类", 父帧, "", -0.168, -0.008, 0.125, 0.018);
  状态.详情评分 = 创建文本帧(状态, "首领奖励详情评分", 父帧, "", -0.152, -0.038, 0.070, 0.018);
  状态.详情描述 = 创建文本帧(状态, "首领奖励详情描述", 父帧, "", -0.239, -0.069, 0.190, 0.034);
  状态.详情属性 = 创建文本帧(状态, "首领奖励详情属性", 父帧, "", 0.010, 0.030, 0.086, 0.074);
  状态.详情属性二 = 创建文本帧(状态, "首领奖励详情属性二", 父帧, "", 0.105, 0.030, 0.086, 0.074);
  状态.详情属性三 = 创建文本帧(状态, "首领奖励详情属性三", 父帧, "", 0.200, 0.030, 0.060, 0.074);
  设置文本帧字体大小(状态.详情属性, 0.0115);
  设置文本帧字体大小(状态.详情属性二, 0.0115);
  设置文本帧字体大小(状态.详情属性三, 0.0115);
  状态.详情特效 = 创建文本帧(状态, "首领奖励详情特效", 父帧, "", 0.000, -0.050, 0.268, 0.083);
  设置文本帧字体大小(状态.详情特效, 0.0108);
  const 后缀 = 获取槽位后缀(状态);
  const 确认底部按钮 = 创建首领奖励底部操作按钮(父帧, 后缀, "首领奖励确认按钮", 颜色按钮 + "确认领取  0/0" + 颜色结束, 确认领取命中X, 确认领取命中Y, 确认领取命中宽度, 确认领取命中高度, -0.228, -0.116, 0.136, 0.026, 点击确认领取帧);
  const 关闭底部按钮 = 创建首领奖励底部操作按钮(父帧, 后缀, "首领奖励关闭按钮", 颜色按钮 + "暂不选择" + 颜色结束, 暂不选择命中X, 暂不选择命中Y, 暂不选择命中宽度, 暂不选择命中高度, 0.086, -0.116, 0.115, 0.026, 点击关闭界面帧);
  状态.确认按钮 = 确认底部按钮.按钮;
  状态.关闭按钮 = 关闭底部按钮.按钮;
  状态.确认按钮文字 = 确认底部按钮.文本;
  状态.关闭按钮文字 = 关闭底部按钮.文本;
  if (状态.确认按钮 !== 0) 确认点击路由表[状态.确认按钮] = 状态.槽位ID;
  if (状态.关闭按钮 !== 0) 关闭点击路由表[状态.关闭按钮] = 状态.槽位ID;
  if (确认底部按钮.命中框 !== 0) 确认点击路由表[确认底部按钮.命中框] = 状态.槽位ID;
  if (关闭底部按钮.命中框 !== 0) 关闭点击路由表[关闭底部按钮.命中框] = 状态.槽位ID;
  if (状态.确认按钮文字 !== 0) 确认点击路由表[状态.确认按钮文字] = 状态.槽位ID;
  if (状态.关闭按钮文字 !== 0) 关闭点击路由表[状态.关闭按钮文字] = 状态.槽位ID;
  状态.内容已创建 = true;
}

function 重置选择状态(this: void, 状态: 首领奖励槽位状态): void {
  for (let 序号 = 0; 序号 < 槽位中心X.length; 序号++) {
    状态.已选择[序号] = false;
  }
  状态.当前详情序号 = 0;
}

function 初始化首领奖励槽位(this: void, 玩家ID: number): void {
  if (首领奖励槽位表[玩家ID] != null) return;
  const 状态 = 创建槽位状态(玩家ID);
  首领奖励槽位表[玩家ID] = 状态;
  const 面板 = 创建首领奖励面板兜底(状态);
  if (面板 == null || 面板 === 0) return;
  状态.面板帧 = 面板;
  if (首领奖励首个面板帧 === 0) 首领奖励首个面板帧 = 面板;
  设置帧尺寸(面板, { width: 首领奖励面板宽度, height: 首领奖励面板高度 });
  设置帧位置(面板, { point: FramePoint.CENTER, x: 首领奖励面板中心X, y: 首领奖励面板中心Y });
  设置帧贴图(面板, 首领奖励面板贴图);
  隐藏帧(面板);
  创建首领奖励内容(状态);
}

export function 初始化首领奖励选择界面(this: void): void {
  if (首领奖励界面已初始化) return;
  首领奖励界面已初始化 = true;
  for (const 玩家ID of 英雄选择配置表.可选玩家ID列表) {
    初始化首领奖励槽位(玩家ID);
  }
}

export function 打开首领奖励选择界面(this: void, 奖励池ID: string, 玩家: any): void {
  初始化首领奖励选择界面();
  const 奖励池 = 查找首领奖励池(奖励池ID);
  if (奖励池 == null || 玩家 == null || 玩家 === 0) return;
  自动随机发放旧待选择首领奖励(玩家, 奖励池ID);
  const 玩家ID = GetPlayerId(玩家);
  const 状态 = 获取槽位状态(玩家ID);
  if (状态 == null || 状态.面板帧 === 0) return;
  状态.玩家 = 玩家;
  状态.当前奖励池 = 奖励池;
  状态.当前奖励池ID = 奖励池ID;
  记录首领奖励待选择(奖励池ID, 玩家);
  重置选择状态(状态);
  刷新选项显示(状态);
  刷新详情内容(状态);
  显示槽位界面(状态);
}

export function 显示首领奖励选择界面(this: void): void {
  初始化首领奖励选择界面();
  const 状态 = 获取槽位状态(获取本地玩家ID());
  if (状态 != null) 显示槽位界面(状态);
}

export function 隐藏首领奖励选择界面(this: void): void {
  const 状态 = 获取槽位状态(获取本地玩家ID());
  if (状态 != null) 隐藏槽位界面(状态);
}

export function 首领奖励选择界面是否显示(this: void, 玩家: any): boolean {
  初始化首领奖励选择界面();
  if (玩家 == null || 玩家 === 0) return false;
  const 状态 = 获取槽位状态(GetPlayerId(玩家));
  return 状态 != null && 状态.面板已显示;
}

export function 切换首领奖励选择界面(this: void, 奖励池ID: string, 玩家: any): void {
  初始化首领奖励选择界面();
  if (玩家 == null || 玩家 === 0) return;
  const 状态 = 获取槽位状态(GetPlayerId(玩家));
  if (状态 != null && 状态.面板已显示) {
    隐藏槽位界面(状态);
    return;
  }
  打开首领奖励选择界面(奖励池ID, 玩家);
}

export function 获取首领奖励面板帧(this: void): number {
  初始化首领奖励选择界面();
  const 状态 = 获取槽位状态(获取本地玩家ID());
  return 状态 != null ? 状态.面板帧 : 首领奖励首个面板帧;
}
