/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const 全局变量 = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

import { createFrame as 创建帧 } from "../09．表现系统/01．UI工具/01．帧创建";
import { setFramePointRelative as 设置帧相对位置, setFrameSize as 设置帧尺寸 } from "../09．表现系统/01．UI工具/02．位置尺寸";
import { setButtonText as 设置按钮文本, setFrameClickEvent as 设置帧点击事件, setFrameTexture as 设置帧贴图 } from "../09．表现系统/01．UI工具/03．内容设置";
import { hideFrame as 隐藏帧, showFrame as 显示帧 } from "../09．表现系统/01．UI工具/05．帧控制";
import { FramePoint, FrameType } from "../09．表现系统/01．UI工具/00．类型定义";

const 聊天命令事件中心 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, 玩家: any, 命令: string) => void) => void;
};
const 首领奖励界面 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面") as {
  显示首领奖励选择界面: (this: void) => void;
  隐藏首领奖励选择界面: (this: void) => void;
  获取首领奖励面板帧: (this: void) => number;
};
const 首领奖励配置 = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表") as {
  瑟兰迪尔奖励池ID: string;
  查找首领奖励池: (this: void, 奖励池ID: string) => any;
};
const 首领奖励发放 = require("系统.02．物品系统.18．首领奖励选择.03．奖励发放") as {
  领取首领奖励选择: (this: void, 奖励池ID: string, 玩家ID: number, 已选装备名: string[]) => string;
};
const 首领奖励领取状态 = require("系统.02．物品系统.18．首领奖励选择.02．领取状态") as {
  清除首领奖励领取记录: (this: void, 奖励池ID: string, 玩家ID: number) => boolean;
};
const 物品名反查 = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, 名字: string) => string | undefined;
};
const 四字符转换 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, 内容: string | undefined | null) => number;
};
const 创建物品模块 = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, x: number, y: number) => any;
};
const Player = jass.Player as (序号: number) => any;
const GetPlayerId = jass.GetPlayerId as (玩家: any) => number;
const GetUnitX = jass.GetUnitX as (单位: any) => number;
const GetUnitY = jass.GetUnitY as (单位: any) => number;
const UnitAddItem = jass.UnitAddItem as (单位: any, 物品: any) => boolean | number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  玩家: any,
  x: number,
  y: number,
  持续时间: number,
  文本: string
) => void;

const 测试命令 = "brtest";
const 重置测试命令 = "brreset";
const 选项按钮: number[] = [];
const 选项图标: number[] = [];
const 选项图标按钮: number[] = [];
const 选中边框: number[] = [];
const 勾选标记: number[] = [];
const 已选择: boolean[] = [];
let 详情图标 = 0;
let 详情标题 = 0;
let 详情分类 = 0;
let 详情评分 = 0;
let 详情描述 = 0;
let 详情属性 = 0;
let 详情特效 = 0;
let 确认按钮 = 0;
let 关闭按钮 = 0;
let 测试界面已创建 = false;
let 当前玩家: any = null;
let 当前详情序号 = 0;

interface 首领奖励测试选项 {
  装备名: string;
}

interface 首领奖励测试奖励池 {
  选项: 首领奖励测试选项[];
}

const 奖励图标路径表: Record<string, string> = {
  执法者徽记: "Equipment\\Icon\\Item\\enforcer_badge.blp",
  月光锁链护腕: "Equipment\\Icon\\Item\\moonlight_chain_bracer.blp",
  审判之锋长剑: "Equipment\\Icon\\MainWeapon\\Sword\\judgement_edge_longsword.blp",
  精灵执法披风: "Equipment\\Icon\\Clothes\\elven_enforcer_cloak.blp",
  瑟兰迪尔的决心: "Equipment\\Icon\\Soul\\thranduil_resolve.blp",
};

const 选中边框贴图 = "UI\\BossReward\\reward_selected_border.tga";
const 勾选标记贴图 = "UI\\BossReward\\reward_check_badge.tga";
const 颜色标题 = "|cff4b1f08";
const 颜色正文 = "|cff21140a";
const 颜色小标题 = "|cff6a3608";
const 颜色结束 = "|r";

interface 首领奖励详情资料 {
  分类: string;
  等级: string;
  评分: string;
  描述: string;
  属性: string;
  特效: string;
}

const 奖励详情资料表: Record<string, 首领奖励详情资料> = {
  执法者徽记: {
    分类: "饰品",
    等级: "B-",
    评分: "6400",
    描述: "象征精灵执法者权威的徽记，冷月与秩序铭刻其上。",
    属性: "全属性 +32\n护甲 +15\n冷却缩减 +10%",
    特效: "秩序守护：攻击时有 10% 概率使目标沉默 2 秒；同一目标 8 秒内只触发一次。",
  },
  月光锁链护腕: {
    分类: "饰品",
    等级: "B-",
    评分: "6200",
    描述: "银蓝色锁链护腕，能在束缚降临时反噬敌意。",
    属性: "敏捷 +45\n攻击速度 +50%\n生命值 +600",
    特效: "束缚反击：自身受到控制时，获得 2 秒 30% 减伤，并反弹本次伤害 30%；冷却 12 秒。",
  },
  审判之锋长剑: {
    分类: "主武器 · 剑",
    等级: "B",
    评分: "6500",
    描述: "为审判而锻造的长剑，锋刃会先斩向仍未低头的敌人。",
    属性: "攻击力 +160\n力量 +22\n护甲穿透 +20%",
    特效: "罪与罚：攻击生命值高于 70% 的目标时，额外造成 18% 物理伤害。",
  },
  精灵执法披风: {
    分类: "衣服",
    等级: "B",
    评分: "6500",
    描述: "披风展开时如同一片肃穆领域，令靠近者不敢轻举妄动。",
    属性: "生命值 +2600\n护甲 +28\n魔抗 +18%\n移动速度 +6%",
    特效: "秩序领域：周围 300 范围内敌方单位攻击速度降低 15%。",
  },
  瑟兰迪尔的决心: {
    分类: "灵魂",
    等级: "B-",
    评分: "6100",
    描述: "残留着瑟兰迪尔执念的灵魂印记，只在精灵城回应召唤。",
    属性: "全属性 +15",
    特效: "使用：召唤瑟兰迪尔幻影协助战斗 30 秒，仅精灵城内可用。",
  },
};

const 槽位中心X: number[] = [-0.216, -0.144, -0.073, 0.000, 0.071];
const 槽位图标Y = 0.076;
const 槽位按钮Y = 0.053;
const 槽位图标尺寸 = 0.055;
const 槽位按钮宽度 = 0.040;
const 槽位按钮高度 = 0.015;
const 确认按钮Y = -0.126;

function 获取大法师(this: void): any {
  return 全局变量.gg_unit_Hamg_0002;
}

function 提示(this: void, 文本: string): void {
  const 玩家 = 当前玩家 || Player(0);
  DisplayTimedTextToPlayer(玩家, 0, 0, 8, "[首领奖励测试] " + 文本);
}

function 获取奖励装备名(this: void, 序号: number): string {
  const 奖励池 = 首领奖励配置.查找首领奖励池(首领奖励配置.瑟兰迪尔奖励池ID) as 首领奖励测试奖励池 | null;
  if (奖励池 == null) return "";
  const 选项 = 奖励池.选项[序号];
  if (选项 == null) return "";
  return 选项.装备名 || "";
}

function 获取奖励图标路径(this: void, 序号: number): string {
  const 装备名 = 获取奖励装备名(序号);
  return 奖励图标路径表[装备名] || "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp";
}

function 获取奖励详情资料(this: void, 序号: number): 首领奖励详情资料 | null {
  const 装备名 = 获取奖励装备名(序号);
  return 奖励详情资料表[装备名] || null;
}

function 设置文本帧文字(this: void, 帧: number, 文本: string): void {
  if (帧 !== 0) japi.DzFrameSetText(帧, 文本);
}

function 创建测试文本帧(this: void, 名字: string, 父帧: number, 文本: string, x: number, y: number, 宽度: number, 高度: number): number {
  const 文本帧 = 创建帧({
    type: FrameType.TEXT,
    name: 名字,
    parent: 父帧,
    template: "template",
    visible: true,
  }) || 0;
  if (文本帧 === 0) return 0;
  设置帧相对位置(文本帧, FramePoint.TOPLEFT, 父帧, FramePoint.CENTER, x, y);
  设置帧尺寸(文本帧, { width: 宽度, height: 高度 });
  japi.DzFrameSetTextAlignment(文本帧, 0);
  japi.DzFrameSetFont(文本帧, "Fonts\\dfst-m3u.ttf", 0.0135, 0);
  japi.DzFrameSetTextColor(文本帧, 33, 20, 10, 255);
  japi.DzFrameSetText(文本帧, 文本);
  return 文本帧;
}

function 刷新详情内容(this: void): void {
  const 装备名 = 获取奖励装备名(当前详情序号);
  const 详情 = 获取奖励详情资料(当前详情序号);
  if (详情 == null || 装备名 === "") return;

  if (详情图标 !== 0) 设置帧贴图(详情图标, 获取奖励图标路径(当前详情序号));
  设置文本帧文字(详情标题, 颜色标题 + 装备名 + 颜色结束);
  设置文本帧文字(详情分类, 颜色正文 + 详情.分类 + "    " + 详情.等级 + 颜色结束);
  设置文本帧文字(详情评分, 颜色小标题 + "装备评分：" + 颜色结束 + 颜色正文 + " " + 详情.评分 + 颜色结束);
  设置文本帧文字(详情描述, 颜色正文 + 详情.描述 + 颜色结束);
  设置文本帧文字(详情属性, 颜色小标题 + "属性" + 颜色结束 + "\n" + 颜色正文 + 详情.属性 + 颜色结束);
  设置文本帧文字(详情特效, 颜色小标题 + "特效" + 颜色结束 + "\n" + 颜色正文 + 详情.特效 + 颜色结束);
}

function 统计选择数量(this: void): number {
  let 数量 = 0;
  for (let 序号 = 0; 序号 < 已选择.length; 序号++) {
    if (已选择[序号]) 数量++;
  }
  return 数量;
}

function 收集已选装备名(this: void): string[] {
  const 装备名列表: string[] = [];
  for (let 序号 = 0; 序号 < 已选择.length; 序号++) {
    if (已选择[序号]) {
      const 装备名 = 获取奖励装备名(序号);
      if (装备名 !== "") 装备名列表.push(装备名);
    }
  }
  return 装备名列表;
}

function 刷新选项按钮文字(this: void): void {
  for (let 序号 = 0; 序号 < 选项按钮.length; 序号++) {
    const 按钮 = 选项按钮[序号];
    const 装备名 = 获取奖励装备名(序号);
    if (按钮 !== 0 && 装备名 !== "") 设置按钮文本(按钮, "");
    if (选中边框[序号] !== 0) {
      if (已选择[序号]) 显示帧(选中边框[序号]);
      else 隐藏帧(选中边框[序号]);
    }
    if (勾选标记[序号] !== 0) {
      if (已选择[序号]) 显示帧(勾选标记[序号]);
      else 隐藏帧(勾选标记[序号]);
    }
  }
  if (确认按钮 !== 0) {
    设置按钮文本(确认按钮, "确认领取 " + 统计选择数量() + "/2");
  }
}

function 切换选项(this: void, 序号: number): void {
  当前详情序号 = 序号;
  刷新详情内容();
  if (!已选择[序号] && 统计选择数量() >= 2) {
    提示("最多只能选择 2 件装备。");
    return;
  }
  已选择[序号] = !已选择[序号];
  刷新选项按钮文字();
}

function 点击选项一(this: void): void { 切换选项(0); }
function 点击选项二(this: void): void { 切换选项(1); }
function 点击选项三(this: void): void { 切换选项(2); }
function 点击选项四(this: void): void { 切换选项(3); }
function 点击选项五(this: void): void { 切换选项(4); }

function 创建测试图标按钮(this: void, 父帧: number, 序号: number, 点击函数: any): void {
  const 图标 = 创建帧({
    type: FrameType.BACKDROP,
    name: "首领奖励测试图标" + 序号,
    parent: 父帧,
    template: "template",
    visible: true,
  }) || 0;
  if (图标 !== 0) {
    设置帧相对位置(图标, FramePoint.CENTER, 父帧, FramePoint.CENTER, 槽位中心X[序号], 槽位图标Y);
    设置帧尺寸(图标, { width: 槽位图标尺寸, height: 槽位图标尺寸 });
    设置帧贴图(图标, 获取奖励图标路径(序号));
    japi.DzFrameSetPriority(图标, 10);
  }

  const 边框 = 创建帧({
    type: FrameType.BACKDROP,
    name: "首领奖励测试选中边框" + 序号,
    parent: 父帧,
    template: "template",
    visible: false,
  }) || 0;
  if (边框 !== 0) {
    设置帧相对位置(边框, FramePoint.CENTER, 父帧, FramePoint.CENTER, 槽位中心X[序号], 槽位图标Y);
    设置帧尺寸(边框, { width: 槽位图标尺寸 + 0.008, height: 槽位图标尺寸 + 0.008 });
    设置帧贴图(边框, 选中边框贴图);
    japi.DzFrameSetPriority(边框, 12);
  }

  const 勾选 = 创建帧({
    type: FrameType.BACKDROP,
    name: "首领奖励测试勾选标记" + 序号,
    parent: 父帧,
    template: "template",
    visible: false,
  }) || 0;
  if (勾选 !== 0) {
    设置帧相对位置(勾选, FramePoint.CENTER, 父帧, FramePoint.CENTER, 槽位中心X[序号] + 0.021, 槽位图标Y + 0.021);
    设置帧尺寸(勾选, { width: 0.018, height: 0.018 });
    设置帧贴图(勾选, 勾选标记贴图);
    japi.DzFrameSetPriority(勾选, 13);
  }

  const 图标按钮 = 创建帧({
    type: FrameType.GLUETEXTBUTTON,
    name: "首领奖励测试图标按钮" + 序号,
    parent: 图标 !== 0 ? 图标 : 父帧,
    template: "template",
    visible: true,
    enable: true,
    alpha: 0,
  }) || 0;
  if (图标 !== 0 && 图标按钮 !== 0) {
    japi.DzFrameSetAllPoints(图标按钮, 图标);
    japi.DzFrameSetPriority(图标按钮, 14);
    设置帧点击事件(图标按钮, 点击函数);
  }
  选项图标[序号] = 图标;
  选项图标按钮[序号] = 图标按钮;
  选中边框[序号] = 边框;
  勾选标记[序号] = 勾选;
}

function 创建测试文字按钮(this: void, 名字: string, 父帧: number, 文字: string, x: number, y: number, 宽度: number, 高度: number, 点击函数: any): number {
  const 按钮 = 创建帧({
    type: FrameType.GLUETEXTBUTTON,
    name: 名字,
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
  设置按钮文本(按钮, 文字);
  设置帧点击事件(按钮, 点击函数);
  return 按钮;
}

function 发放单件装备(this: void, 装备名: string, 大法师: any): boolean {
  const 物品ID字符串 = 物品名反查.按名字反查物品ID(装备名);
  const 物品类型ID = 四字符转换.stringToFourCCSafe(物品ID字符串);
  if (物品类型ID === 0) {
    提示("物品名反查失败：" + 装备名);
    return false;
  }

  const 物品 = 创建物品模块.创建物品并注册排泄监听(物品类型ID, GetUnitX(大法师), GetUnitY(大法师));
  if (物品 == null || 物品 === 0) {
    提示("创建物品失败：" + 装备名);
    return false;
  }

  const 结果 = UnitAddItem(大法师, 物品);
  if (结果 !== true && 结果 !== 1) {
    提示("大法师背包可能已满，物品已掉在脚下：" + 装备名);
  }
  return true;
}

function 点击确认领取(this: void): void {
  const 大法师 = 获取大法师();
  if (大法师 == null || 大法师 === 0) {
    提示("未找到 gg_unit_Hamg_0002，无法发放。");
    return;
  }

  const 已选装备名 = 收集已选装备名();
  if (已选装备名.length !== 2) {
    提示("请先选择 2 件装备。");
    return;
  }

  const 玩家ID = 当前玩家 != null ? GetPlayerId(当前玩家) : 0;
  const 发放结果 = 首领奖励发放.领取首领奖励选择(首领奖励配置.瑟兰迪尔奖励池ID, 玩家ID, 已选装备名);
  if (发放结果 !== "成功") {
    提示("领取校验失败：" + 发放结果);
    return;
  }

  let 成功数量 = 0;
  for (let 序号 = 0; 序号 < 已选装备名.length; 序号++) {
    if (发放单件装备(已选装备名[序号], 大法师)) 成功数量++;
  }
  提示("已给大法师发放 " + 成功数量 + " 件装备。");
}

function 点击关闭测试界面(this: void): void {
  首领奖励界面.隐藏首领奖励选择界面();
}

function 创建测试按钮(this: void): void {
  if (测试界面已创建) return;
  const 父帧 = 首领奖励界面.获取首领奖励面板帧();
  if (父帧 === 0) {
    提示("首领奖励面板创建失败。");
    return;
  }

  const 点击函数列表 = [点击选项一, 点击选项二, 点击选项三, 点击选项四, 点击选项五];
  for (let 序号 = 0; 序号 < 5; 序号++) {
    已选择[序号] = false;
    创建测试图标按钮(父帧, 序号, 点击函数列表[序号]);
    const 按钮 = 创建测试文字按钮(
      "首领奖励测试选项" + 序号,
      父帧,
      "",
      槽位中心X[序号],
      槽位按钮Y,
      槽位按钮宽度,
      槽位按钮高度,
      点击函数列表[序号]
    );
    选项按钮[序号] = 按钮;
  }

  详情图标 = 创建帧({
    type: FrameType.BACKDROP,
    name: "首领奖励测试详情图标",
    parent: 父帧,
    template: "template",
    visible: true,
  }) || 0;
  if (详情图标 !== 0) {
    设置帧相对位置(详情图标, FramePoint.CENTER, 父帧, FramePoint.CENTER, -0.211, -0.001);
    设置帧尺寸(详情图标, { width: 0.046, height: 0.046 });
  }
  详情标题 = 创建测试文本帧("首领奖励测试详情标题", 父帧, "", -0.168, 0.017, 0.125, 0.020);
  详情分类 = 创建测试文本帧("首领奖励测试详情分类", 父帧, "", -0.168, -0.008, 0.125, 0.018);
  详情评分 = 创建测试文本帧("首领奖励测试详情评分", 父帧, "", -0.168, -0.034, 0.125, 0.018);
  详情描述 = 创建测试文本帧("首领奖励测试详情描述", 父帧, "", -0.239, -0.069, 0.190, 0.034);
  详情属性 = 创建测试文本帧("首领奖励测试详情属性", 父帧, "", -0.020, 0.022, 0.245, 0.083);
  详情特效 = 创建测试文本帧("首领奖励测试详情特效", 父帧, "", -0.020, -0.062, 0.250, 0.074);
  当前详情序号 = 0;
  刷新详情内容();

  确认按钮 = 创建测试文字按钮(
    "首领奖励测试确认",
    父帧,
    "确认领取 0/2",
    -0.172,
    确认按钮Y,
    0.135,
    0.023,
    点击确认领取
  );

  关闭按钮 = 创建测试文字按钮(
    "首领奖励测试关闭",
    父帧,
    "关闭",
    0.140,
    确认按钮Y,
    0.115,
    0.023,
    点击关闭测试界面
  );

  测试界面已创建 = true;
}

function 重置测试选择(this: void): void {
  for (let 序号 = 0; 序号 < 5; 序号++) {
    已选择[序号] = false;
    if (选项图标[序号] !== 0) 显示帧(选项图标[序号]);
    if (选项图标按钮[序号] !== 0) 显示帧(选项图标按钮[序号]);
    if (选项按钮[序号] !== 0) 显示帧(选项按钮[序号]);
  }
  if (确认按钮 !== 0) 显示帧(确认按钮);
  if (关闭按钮 !== 0) 显示帧(关闭按钮);
  刷新选项按钮文字();
}

function 打开奖励选择测试(this: void, 玩家: any): void {
  当前玩家 = 玩家;
  首领奖励界面.显示首领奖励选择界面();
  创建测试按钮();
  重置测试选择();
  提示("已打开测试界面：选择 2 件后点确认领取。");
}

function 重置奖励选择测试领取状态(this: void, 玩家: any): void {
  当前玩家 = 玩家;
  const 玩家ID = GetPlayerId(玩家);
  const 已清除 = 首领奖励领取状态.清除首领奖励领取记录(首领奖励配置.瑟兰迪尔奖励池ID, 玩家ID);
  提示(已清除 ? "已重置本局领取记录，可再次测试。" : "当前没有领取记录。");
}

聊天命令事件中心.注册聊天命令监听(测试命令, 打开奖励选择测试);
聊天命令事件中心.注册聊天命令监听(重置测试命令, 重置奖励选择测试领取状态);

export {};
