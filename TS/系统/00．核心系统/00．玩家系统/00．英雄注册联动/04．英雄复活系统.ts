/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const g = require("jass.globals") as { udg_FHD?: any; udg_Boss?: any; [key: string]: any };

const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
  YDUserDataSetSafe: (this: void, tableTypeName: string, tableKey: any, attr: string, valueTypeName: string, value: any) => void;
};
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 开始无敌帧 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧") as {
  开始无敌帧: (this: void, unit: any, duration: number) => number;
};
const { 沿角度步进直到地形阻挡 } = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进") as {
  沿角度步进直到地形阻挡: (this: void, 参数: {
    起点X: number;
    起点Y: number;
    角度度: number;
    单步距离: number;
    步数: number;
    检测单位?: any;
  }) => {
    最终X: number;
    最终Y: number;
    实际步数: number;
    是否提前停止: boolean;
  };
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { onTick10ms, offTick10ms } = globalThis as unknown as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};
const 冷却数字文本模块 = require("系统.09．表现系统.01．UI工具.06．冷却数字文本") as {
  创建冷却数字文本组: (this: void, 配置: any) => any;
  设置冷却数字文本锚点: (this: void, 文本组: any, relativeFrame: number, point: number, relativePoint: number, x: number, y: number) => void;
  设置冷却数字文本: (this: void, 文本组: any, text: string) => void;
  显示冷却数字文本: (this: void, 文本组: any, visible: boolean) => void;
  英雄栏冷却数字层: any[];
};
const 创建冷却数字文本组 = 冷却数字文本模块.创建冷却数字文本组;
const 设置冷却数字文本锚点 = 冷却数字文本模块.设置冷却数字文本锚点;
const 设置冷却数字文本 = 冷却数字文本模块.设置冷却数字文本;
const 显示冷却数字文本 = 冷却数字文本模块.显示冷却数字文本;

function 移动镜头到玩家(this: void, 玩家: any, x: number, y: number): void {
  StarOther_PanCameraToTimedForPlayer(玩家, x, y, 0.1);
}
const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (
  type: string,
  name: string,
  parent: number,
  template: string,
  id: number
) => number;
const DzFrameGetHeroBarButton = japi.DzFrameGetHeroBarButton as (buttonId: number) => number;
const DzFrameSetPoint = japi.DzFrameSetPoint as (
  frame: number,
  point: number,
  relativeFrame: number,
  relativePoint: number,
  x: number,
  y: number
) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment as (frame: number, align: number) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, font: string, size: number, flag: number) => void;
const DzFrameSetTextColor = japi.DzFrameSetTextColor as (
  frame: number,
  red: number,
  green: number,
  blue: number,
  alpha: number
) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const GetUnitX = jass.GetUnitX as (unit: any) => number;  
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const IsUnitType = jass.IsUnitType as (unit: any, whichUnitType: number) => boolean;
const ReviveHeroLoc = jass.ReviveHeroLoc as (whichHero: any, loc: any, showExp: boolean) => void;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const Location = jass.Location as (x: number, y: number) => any;
const RemoveLocation = jass.RemoveLocation as (loc: any) => void;
const SetUnitX = jass.SetUnitX as (unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (unit: any, y: number) => void;
const R2I = jass.R2I as (value: number) => number;

const 复活延迟秒 = 10.0;
const 复活无敌秒 = 1.0;
const 复活半径 = 500.0;
const 复活推进步数 = 20;
const 复活次数属性 = "次数";
const 复活次数表 = "团队复活";
const Boss战表 = "Boss战";
const Boss战单位属性 = "单位";
const 英雄栏文本框体数量 = 5;
const 英雄栏倒计时字体 = "UI\\uizt.ttf";
const 英雄栏倒计时文字宽度 = 0.056;
const 英雄栏倒计时文字高度 = 0.020;
const 英雄栏倒计时字体大小 = 0.0175;
const 英雄栏倒计时偏移X = -0.0055;
const 英雄栏倒计时偏移Y = 0.0006;
const 英雄栏倒计时底阴影偏移X = 0.0014;
const 英雄栏倒计时底阴影偏移Y = -0.0018;
const 英雄栏倒计时阴影偏移X = -0.0014;
const 英雄栏倒计时阴影偏移Y = -0.0014;
const 英雄栏倒计时左描边偏移X = -0.0011;
const 英雄栏倒计时左描边偏移Y = 0.0000;
const 英雄栏倒计时右描边偏移X = 0.0011;
const 英雄栏倒计时右描边偏移Y = 0.0000;
const 英雄栏倒计时文字优先级 = 6;
const 帧点中心 = 4;
const 文本对齐居中 = 18;

const 设置测试次数 = true;
const 测试复活次数 = 10;
let 已注册死亡 = false;
let 已初始化英雄栏倒计时 = false;
let 已注册英雄栏倒计时Tick = false;

const 英雄栏倒计时底阴影框体表: number[] = [0, 0, 0, 0, 0];
const 英雄栏倒计时左描边框体表: number[] = [0, 0, 0, 0, 0];
const 英雄栏倒计时右描边框体表: number[] = [0, 0, 0, 0, 0];
const 英雄栏倒计时阴影框体表: number[] = [0, 0, 0, 0, 0];
const 英雄栏倒计时框体表: number[] = [0, 0, 0, 0, 0];
const 英雄栏倒计时文本组表: any[] = [null, null, null, null, null];
const 英雄栏倒计时剩余秒表: number[] = [0, 0, 0, 0, 0];

function 是否有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 取英雄栏槽位(this: void, unit: any): number {
  if (!是否有效(unit)) return -1;
  const owner = GetOwningPlayer(unit);
  if (!是否有效(owner)) return -1;
  const playerId = GetPlayerId(owner);
  if (playerId < 0 || playerId >= 英雄栏文本框体数量) return -1;
  return playerId;
}

function 是否本地英雄栏槽位(this: void, 槽位: number): boolean {
  const localPlayer = GetLocalPlayer();
  if (!是否有效(localPlayer)) return false;
  return GetPlayerId(localPlayer) === 槽位;
}

function 十倍精度文本(this: void, value: number): string {
  const 十倍整数 = R2I(value * 10 + 0.5);
  const 整数部分 = R2I(十倍整数 / 10);
  const 小数部分 = 十倍整数 - 整数部分 * 10;
  return `${整数部分}.${小数部分}`;
}

function 转白金文本(this: void, text: string): string {
  if (text === "") return "";
  return `|cfffff2d8${text}|r`;
}

function 转阴影文本(this: void, text: string): string {
  if (text === "") return "";
  return `|cff101010${text}|r`;
}

function 转底阴影文本(this: void, text: string): string {
  if (text === "") return "";
  return `|cff080808${text}|r`;
}

function 转描边文本(this: void, text: string): string {
  if (text === "") return "";
  return `|cff3a2a18${text}|r`;
}

function 是否有英雄栏倒计时在运行(this: void): boolean {
  for (let i = 0; i < 英雄栏倒计时剩余秒表.length; i++) {
    if (英雄栏倒计时剩余秒表[i] > 0) return true;
  }
  return false;
}

function 隐藏英雄栏倒计时(this: void, 槽位: number): void {
  if (槽位 < 0 || 槽位 >= 英雄栏倒计时框体表.length) return;
  英雄栏倒计时剩余秒表[槽位] = 0;
  const 文本组 = 英雄栏倒计时文本组表[槽位];
  if (文本组 != null) {
    设置冷却数字文本(文本组, "");
    显示冷却数字文本(文本组, false);
    return;
  }
  const 底阴影框体 = 英雄栏倒计时底阴影框体表[槽位];
  const 左描边框体 = 英雄栏倒计时左描边框体表[槽位];
  const 右描边框体 = 英雄栏倒计时右描边框体表[槽位];
  const 阴影框体 = 英雄栏倒计时阴影框体表[槽位];
  const 文字框体 = 英雄栏倒计时框体表[槽位];
  if (底阴影框体 !== 0) DzFrameShow(底阴影框体, false);
  if (左描边框体 !== 0) DzFrameShow(左描边框体, false);
  if (右描边框体 !== 0) DzFrameShow(右描边框体, false);
  if (阴影框体 !== 0) DzFrameShow(阴影框体, false);
  if (文字框体 !== 0) DzFrameShow(文字框体, false);
}

function 刷新英雄栏倒计时文本(this: void, 槽位: number): void {
  const 文本组 = 英雄栏倒计时文本组表[槽位];
  if (文本组 != null) {
    设置冷却数字文本(文本组, 十倍精度文本(英雄栏倒计时剩余秒表[槽位]));
    显示冷却数字文本(文本组, 是否本地英雄栏槽位(槽位));
    return;
  }
  const 底阴影框体 = 英雄栏倒计时底阴影框体表[槽位];
  const 左描边框体 = 英雄栏倒计时左描边框体表[槽位];
  const 右描边框体 = 英雄栏倒计时右描边框体表[槽位];
  const 阴影框体 = 英雄栏倒计时阴影框体表[槽位];
  const 文字框体 = 英雄栏倒计时框体表[槽位];
  if (底阴影框体 === 0 || 左描边框体 === 0 || 右描边框体 === 0 || 阴影框体 === 0 || 文字框体 === 0) return;
  const 文本 = 十倍精度文本(英雄栏倒计时剩余秒表[槽位]);
  DzFrameSetText(底阴影框体, 转底阴影文本(文本));
  DzFrameSetText(左描边框体, 转描边文本(文本));
  DzFrameSetText(右描边框体, 转描边文本(文本));
  DzFrameSetText(阴影框体, 转阴影文本(文本));
  DzFrameSetText(文字框体, 转白金文本(文本));
}

function 创建英雄栏倒计时框体(this: void, 槽位: number): number {
  const gameUI = DzGetGameUI();
  if (gameUI === 0) return 0;
  const button = DzFrameGetHeroBarButton(0);
  if (button === 0) return 0;

  const 文本组 = 创建冷却数字文本组({
    名称前缀: `英雄复活倒计时_${槽位}_`,
    父级: gameUI,
    宽度: 英雄栏倒计时文字宽度,
    高度: 英雄栏倒计时文字高度,
    字体大小: 英雄栏倒计时字体大小,
    优先级: 英雄栏倒计时文字优先级,
    对齐: 文本对齐居中,
    层: 冷却数字文本模块.英雄栏冷却数字层,
  });
  if (文本组 == null) return 0;

  设置冷却数字文本锚点(文本组, button, 帧点中心, 帧点中心, 英雄栏倒计时偏移X, 英雄栏倒计时偏移Y);
  显示冷却数字文本(文本组, false);
  英雄栏倒计时文本组表[槽位] = 文本组;
  英雄栏倒计时框体表[槽位] = 文本组.主文本框体;
  return 文本组.主文本框体;
}

function 确保英雄栏倒计时框体(this: void, 槽位: number): number {
  if (槽位 < 0 || 槽位 >= 英雄栏倒计时框体表.length) return 0;
  const oldFrame = 英雄栏倒计时框体表[槽位];
  if (oldFrame !== 0) return oldFrame;
  return 创建英雄栏倒计时框体(槽位);
}

function 初始化英雄栏倒计时框体(this: void): void {
  if (已初始化英雄栏倒计时) return;
  已初始化英雄栏倒计时 = true;
  for (let i = 0; i < 英雄栏文本框体数量; i++) {
    确保英雄栏倒计时框体(i);
  }
}

function on英雄栏倒计时Tick(this: void): void {
  let 仍有倒计时 = false;
  for (let i = 0; i < 英雄栏倒计时剩余秒表.length; i++) {
    const 剩余秒 = 英雄栏倒计时剩余秒表[i];
    if (剩余秒 <= 0) continue;

    const 新剩余秒 = 剩余秒 - 0.01;
    if (新剩余秒 <= 0) {
      隐藏英雄栏倒计时(i);
      continue;
    }

    英雄栏倒计时剩余秒表[i] = 新剩余秒;
    刷新英雄栏倒计时文本(i);
    仍有倒计时 = true;
  }

  if (!仍有倒计时 && 已注册英雄栏倒计时Tick) {
    已注册英雄栏倒计时Tick = false;
    offTick10ms(on英雄栏倒计时Tick);
  }
}

function 启动英雄栏倒计时(this: void, unit: any): void {
  const 槽位 = 取英雄栏槽位(unit);
  if (槽位 < 0) return;

  const frame = 确保英雄栏倒计时框体(槽位);
  if (frame === 0) return;

  英雄栏倒计时剩余秒表[槽位] = 复活延迟秒;
  刷新英雄栏倒计时文本(槽位);
  const 底阴影框体 = 英雄栏倒计时底阴影框体表[槽位];
  const 左描边框体 = 英雄栏倒计时左描边框体表[槽位];
  const 右描边框体 = 英雄栏倒计时右描边框体表[槽位];
  const 阴影框体 = 英雄栏倒计时阴影框体表[槽位];
  const 本地可见 = 是否本地英雄栏槽位(槽位);
  if (底阴影框体 !== 0) DzFrameShow(底阴影框体, 本地可见);
  if (左描边框体 !== 0) DzFrameShow(左描边框体, 本地可见);
  if (右描边框体 !== 0) DzFrameShow(右描边框体, 本地可见);
  if (阴影框体 !== 0) DzFrameShow(阴影框体, 本地可见);
  DzFrameShow(frame, 本地可见);

  if (!已注册英雄栏倒计时Tick) {
    已注册英雄栏倒计时Tick = true;
    onTick10ms(on英雄栏倒计时Tick);
  }
}

function 是玩家英雄(this: void, unit: any): boolean {
  if (!是否有效(unit)) return false;
  return getRegisteredPlayerHero(GetOwningPlayer(unit)) === unit;
}

function 寻找可通行复活点(this: void, boss: any, 检测单位: any): { x: number; y: number } | null {
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);

  const 角度度 = GetRandomDirectionDeg();
  const 步进距离 = 复活半径 / 复活推进步数;
  const 结果 = 沿角度步进直到地形阻挡({
    起点X: bx,
    起点Y: by,
    角度度,
    单步距离: 步进距离,
    步数: 复活推进步数,
    检测单位,
  });

  return { x: 结果.最终X, y: 结果.最终Y };
}

function 读取当前复活Boss(this: void): any {
  const battleBoss = YDUserDataGetSafe("string", Boss战表, Boss战单位属性, "unit");
  if (是否有效(battleBoss)) return battleBoss;
  return g.udg_Boss;
}

function on复活镜头移动(this: void, variable?: any): void {
  if (variable == null) return;
  移动镜头到玩家(variable.玩家, variable.x, variable.y);
}

function 施加复活无敌(this: void, hero: any): void {
  if (!是否有效(hero)) return;
  开始无敌帧(hero, 复活无敌秒);
}

function on英雄死亡延迟复活(this: void, variable?: any): void {
  复活玩家英雄(variable, true);
}

function 复活玩家英雄(this: void, dyingUnit: any, 消耗复活次数: boolean, 原地复活: boolean = false): boolean {
  if (!是否有效(dyingUnit)) return false;
  if (!是玩家英雄(dyingUnit)) return false;
  if (IsUnitType(dyingUnit, jass.UNIT_TYPE_DEAD) !== true) return false;

  const 原地X = 原地复活 ? GetUnitX(dyingUnit) : 0;
  const 原地Y = 原地复活 ? GetUnitY(dyingUnit) : 0;

  隐藏英雄栏倒计时(取英雄栏槽位(dyingUnit));

  const 剩余次数 = 消耗复活次数
    ? (YDUserDataGetSafe("string", 复活次数表, 复活次数属性, "integer") as number | undefined)
    : undefined;
  if (剩余次数 != null && 剩余次数 <= 0) return false;
  if (剩余次数 != null) {
    YDUserDataSetSafe("string", 复活次数表, 复活次数属性, "integer", 剩余次数 - 1);
  }

  if (原地复活) {
    const loc = Location(原地X, 原地Y);
    ReviveHeroLoc(dyingUnit, loc, true);
    RemoveLocation(loc);
    SetUnitX(dyingUnit, 原地X);
    SetUnitY(dyingUnit, 原地Y);
    施加复活无敌(dyingUnit);
    addDelayedCallback(0, on复活镜头移动, { 玩家: GetOwningPlayer(dyingUnit), x: 原地X, y: 原地Y });
  } else {
    const boss = 读取当前复活Boss();
    if (是否有效(boss)) {
      const pos = 寻找可通行复活点(boss, dyingUnit);
      if (pos == null) return false;

      const loc = Location(GetUnitX(boss), GetUnitY(boss));
      ReviveHeroLoc(dyingUnit, loc, true);
      RemoveLocation(loc);
      SetUnitX(dyingUnit, pos.x);
      SetUnitY(dyingUnit, pos.y);
      施加复活无敌(dyingUnit);
      addDelayedCallback(0, on复活镜头移动, { 玩家: GetOwningPlayer(dyingUnit), x: pos.x, y: pos.y });
    } else {
      const 复活点 = g.udg_FHD;
      if (!是否有效(复活点)) return false;
      ReviveHeroLoc(dyingUnit, 复活点, true);
      施加复活无敌(dyingUnit);
      addDelayedCallback(0, on复活镜头移动, { 玩家: GetOwningPlayer(dyingUnit), x: GetUnitX(dyingUnit), y: GetUnitY(dyingUnit) });
    }
  }

  return true;
}

/**
 * 立即复活已注册的玩家英雄，不消耗关卡团队复活次数。
 * 原地复活为 true 时，英雄会在死亡坐标复活，不读取 Boss 复活点或全局复活点。
 * 调用方必须处于全局同步游戏逻辑，不能从 GetLocalPlayer 分支调用。
 */
export function 直接复活玩家英雄(this: void, dyingUnit: any, 原地复活: boolean = false): boolean {
  return 复活玩家英雄(dyingUnit, false, 原地复活);
}

function 英雄死亡延迟复活(this: void, dyingUnit: any, 击杀者: any): void {
  if (!是玩家英雄(dyingUnit)) return;
  启动英雄栏倒计时(dyingUnit);
  addDelayedCallback(复活延迟秒 * 1000, on英雄死亡延迟复活, dyingUnit);
}

export function 初始化英雄复活(this: void): void {
  if (已注册死亡) return;
  已注册死亡 = true;
  初始化英雄栏倒计时框体();

  if (设置测试次数) {
    YDUserDataSetSafe("string", 复活次数表, 复活次数属性, "integer", 测试复活次数);
  }

  const 死亡模块 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心");
  (死亡模块.registerDeathListener as (cb: Function) => void)(英雄死亡延迟复活);
}

export {};
