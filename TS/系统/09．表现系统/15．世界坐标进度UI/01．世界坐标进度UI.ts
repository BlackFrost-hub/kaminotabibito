/** @noSelfInFile */

import { 格式化一位小数 } from '../08．吟唱条/04．数字格式化';
import type { 世界坐标进度UI, 世界坐标进度UI参数, 世界坐标进度UI类型 } from './00．类型';

const japi = require('jass.japi') as any;
const jass = require('jass.common') as any;
const { onTick10ms, offTick10ms } = require('系统.00．核心系统.05．中心计时器') as {
  onTick10ms: (this: void, callback: (this: void) => void) => void;
  offTick10ms: (this: void, callback: (this: void) => void) => void;
};

const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (type: string, name: string, parent: number, template: string, id: number) => number;
const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzFrameGetLowerLevelFrame = japi.DzFrameGetLowerLevelFrame as () => number;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: number, point: number, relativeFrame: number, relativePoint: number, x: number, y: number) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment as (frame: number, align: number) => void;
const DzFrameSetTextColor = japi.DzFrameSetTextColor as (frame: number, red: number, green: number, blue: number, alpha: number) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, path: string, size: number, flag: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameSetIgnoreTrackEvents = japi.DzFrameSetIgnoreTrackEvents as (frame: number, ignore: boolean) => void;
const DzFrameBindWorldPos = japi.DzFrameBindWorldPos as (frame: number, x: number, y: number, z: number, screenX: number, screenY: number, fogVisible: boolean) => void;
const DzFrameUnBind = japi.DzFrameUnBind as (frame: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const DzDestroyFrame = japi.DzDestroyFrame as (frame: number) => void;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetWidgetLife = jass.GetWidgetLife as (widget: any) => number;

const 点左上 = 0;
const 点中 = 4;
const 默认宽度 = 0.082;
const 默认高度 = 0.0205;
const 默认内条左偏移 = 0.005;
const 默认内条上偏移 = -0.0115;
const 默认内条宽度 = 0.072;
const 默认内条高度 = 0.0062;
const 默认层级 = 6700;
const 默认平滑过渡秒 = 0.2;
const 驱动间隔秒 = 0.01;
const 默认底框贴图 = 'UI\\WorldProgress\\world_progress_frame.tga';

const 类型表现表: Record<世界坐标进度UI类型, { 贴图: string; 颜色: string }> = {
  通用: { 贴图: 'UI\\WorldProgress\\world_progress_fill.tga', 颜色: '72cfff' },
  安魂: { 贴图: 'UI\\WorldProgress\\world_progress_fill_soul.tga', 颜色: '79e4d2' },
  危险: { 贴图: 'UI\\WorldProgress\\world_progress_fill_danger.tga', 颜色: 'ff746d' },
  自然: { 贴图: 'UI\\WorldProgress\\world_progress_fill_nature.tga', 颜色: '8cdb86' },
  奥术: { 贴图: 'UI\\WorldProgress\\world_progress_fill_arcane.tga', 颜色: '9ab7ff' },
};

let 世界坐标进度UI父帧 = 0;
let 下一个世界坐标进度UIID = 1;
let 世界坐标进度UI驱动已启动 = false;
const 世界坐标进度UI列表: 世界坐标进度UI[] = [];

function 取世界坐标进度UI父帧(this: void): number {
  if (世界坐标进度UI父帧 !== 0) return 世界坐标进度UI父帧;
  const lower = DzFrameGetLowerLevelFrame();
  const parent = lower != null && lower !== 0 ? lower : DzGetGameUI();
  世界坐标进度UI父帧 = DzCreateFrameByTagName('FRAME', 'WorldProgressUILayer', parent, 'template', 0);
  return 世界坐标进度UI父帧 !== 0 ? 世界坐标进度UI父帧 : parent;
}

function 创建贴图帧(this: void, typeName: string, parent: number, texture: string, priority: number): number {
  const frame = DzCreateFrameByTagName('BACKDROP', typeName, parent, 'template', 0);
  if (frame == null || frame === 0) return 0;
  DzFrameSetTexture(frame, texture, 0);
  DzFrameSetPriority(frame, priority);
  DzFrameSetIgnoreTrackEvents(frame, true);
  return frame;
}

function 限制进度值(this: void, value: number, maximum: number): number {
  if (!(value > 0)) return 0;
  if (value > maximum) return maximum;
  return value;
}

function 刷新填充(this: void, ui: 世界坐标进度UI): void {
  const ratio = ui.最大值 > 0 ? ui.显示值 / ui.最大值 : 0;
  DzFrameSetSize(ui.填充帧, ui.内条宽度 * ratio, ui.内条高度);
  DzFrameShow(ui.填充帧, ratio > 0);
}

function 刷新文本(this: void, ui: 世界坐标进度UI): void {
  DzFrameSetText(
    ui.文本帧,
    '|cffd8f4ee' + ui.标题 + '|r |cff' + ui.数值颜色 + 格式化一位小数(ui.显示值)
      + '|r|cff8fa7ad / ' + 格式化一位小数(ui.最大值) + ui.数值后缀 + '|r',
  );
}

function 从驱动列表移除(this: void, ui: 世界坐标进度UI): void {
  for (let i = 世界坐标进度UI列表.length - 1; i >= 0; i--) {
    if (世界坐标进度UI列表[i] === ui) {
      世界坐标进度UI列表.splice(i, 1);
      return;
    }
  }
}

function 尝试停止世界坐标进度UI驱动(this: void): void {
  if (!世界坐标进度UI驱动已启动 || 世界坐标进度UI列表.length > 0) return;
  世界坐标进度UI驱动已启动 = false;
  offTick10ms(驱动世界坐标进度UI);
}

function 确保世界坐标进度UI驱动(this: void): void {
  if (世界坐标进度UI驱动已启动) return;
  世界坐标进度UI驱动已启动 = true;
  onTick10ms(驱动世界坐标进度UI);
}

function 刷新世界坐标进度UI跟随(this: void, ui: 世界坐标进度UI): boolean {
  if (ui.跟随单位 == null || ui.跟随单位 === 0) return true;
  if (GetUnitTypeId(ui.跟随单位) === 0 || GetWidgetLife(ui.跟随单位) <= 0.405) {
    销毁世界坐标进度UI(ui);
    return false;
  }
  DzFrameBindWorldPos(
    ui.根帧,
    GetUnitX(ui.跟随单位) + ui.跟随X偏移,
    GetUnitY(ui.跟随单位) + ui.跟随Y偏移,
    GetUnitFlyHeight(ui.跟随单位) + ui.跟随Z偏移,
    ui.屏幕X偏移,
    ui.屏幕Y偏移,
    false,
  );
  return true;
}

function 驱动世界坐标进度UI(this: void): void {
  for (let i = 世界坐标进度UI列表.length - 1; i >= 0; i--) {
    const ui = 世界坐标进度UI列表[i];
    if (ui == null || ui.已销毁) {
      世界坐标进度UI列表.splice(i, 1);
      continue;
    }
    if (!刷新世界坐标进度UI跟随(ui)) continue;
    if (ui.显示值 !== ui.目标值) {
      ui.动画已经过秒 += 驱动间隔秒;
      let ratio = ui.动画已经过秒 / ui.平滑过渡秒;
      if (ratio >= 1) ratio = 1;
      ui.显示值 = ui.动画起始值 + (ui.目标值 - ui.动画起始值) * ratio;
      if (ratio >= 1) ui.显示值 = ui.目标值;
      刷新填充(ui);
    }
    ui.文本刷新Tick += 1;
    if (ui.文本刷新Tick >= 5) {
      ui.文本刷新Tick = 0;
      刷新文本(ui);
    }
  }
  尝试停止世界坐标进度UI驱动();
}

export function 创建世界坐标进度UI(this: void, 参数: 世界坐标进度UI参数): 世界坐标进度UI | null {
  if (!(参数.最大值 > 0)) return null;
  const id = 下一个世界坐标进度UIID;
  下一个世界坐标进度UIID += 1;
  const suffix = tostring(id);
  const parent = 取世界坐标进度UI父帧();
  const type = 参数.类型 ?? '通用';
  const typeVisual = 类型表现表[type];
  const root = 创建贴图帧('WorldProgressUIRoot_' + suffix, parent, 参数.底框贴图 ?? 默认底框贴图, 默认层级);
  if (root === 0) return null;
  const fill = 创建贴图帧('WorldProgressUIFill_' + suffix, root, 参数.填充贴图 ?? typeVisual.贴图, 默认层级 + 1);
  const text = DzCreateFrameByTagName('TEXT', 'WorldProgressUIText_' + suffix, root, 'template', 0);
  if (fill === 0 || text == null || text === 0) {
    DzDestroyFrame(root);
    return null;
  }

  const width = 参数.宽度 ?? 默认宽度;
  const height = 参数.高度 ?? 默认高度;
  const innerWidth = width * (默认内条宽度 / 默认宽度);
  const innerHeight = height * (默认内条高度 / 默认高度);
  DzFrameSetSize(root, width, height);
  DzFrameSetSize(fill, 0, innerHeight);
  DzFrameSetPoint(fill, 点左上, root, 点左上, width * (默认内条左偏移 / 默认宽度), height * (默认内条上偏移 / 默认高度));

  DzFrameSetSize(text, width * 1.08, height * 0.58);
  DzFrameSetPoint(text, 点中, root, 点中, 0, height * 0.13);
  DzFrameSetTextAlignment(text, -1);
  DzFrameSetTextAlignment(text, 18);
  DzFrameSetTextColor(text, 216, 244, 238, 255);
  DzFrameSetFont(text, 'UI\\unit_name_zcool_qingke.ttf', 0.0095, 0);
  DzFrameSetPriority(text, 默认层级 + 2);
  DzFrameSetIgnoreTrackEvents(text, true);

  const visible = 参数.初始显示 ?? false;
  const current = 限制进度值(参数.当前值 ?? 0, 参数.最大值);
  const smoothDuration = 参数.平滑过渡秒 != null && 参数.平滑过渡秒 > 0 ? 参数.平滑过渡秒 : 默认平滑过渡秒;
  const ui: 世界坐标进度UI = {
    ID: id,
    根帧: root,
    填充帧: fill,
    文本帧: text,
    最大值: 参数.最大值,
    目标值: current,
    显示值: current,
    动画起始值: current,
    动画已经过秒: smoothDuration,
    平滑过渡秒: smoothDuration,
    标题: 参数.标题 ?? '进度',
    数值后缀: 参数.数值后缀 ?? '',
    类型: type,
    数值颜色: typeVisual.颜色,
    内条宽度: innerWidth,
    内条高度: innerHeight,
    文本刷新Tick: 0,
    已显示: visible,
    已销毁: false,
    屏幕X偏移: 参数.屏幕X偏移 ?? 0,
    屏幕Y偏移: 参数.屏幕Y偏移 ?? 0,
    跟随单位: 参数.跟随单位 ?? null,
    跟随X偏移: 参数.跟随X偏移 ?? 0,
    跟随Y偏移: 参数.跟随Y偏移 ?? 0,
    跟随Z偏移: 参数.跟随Z偏移 ?? 0,
  };
  const z = 参数.Z ?? 180;
  const fogVisible = 参数.雾中可见 ?? false;
  DzFrameBindWorldPos(root, 参数.X, 参数.Y, z, 参数.屏幕X偏移 ?? 0, 参数.屏幕Y偏移 ?? 0, fogVisible);
  刷新填充(ui);
  刷新文本(ui);
  DzFrameShow(root, visible);
  世界坐标进度UI列表.push(ui);
  确保世界坐标进度UI驱动();
  return ui;
}

export function 更新世界坐标进度UI(this: void, ui: 世界坐标进度UI | null | undefined, 当前值: number, 立即更新 = false): void {
  if (ui == null || ui.已销毁) return;
  const target = 限制进度值(当前值, ui.最大值);
  ui.目标值 = target;
  if (立即更新) {
    ui.显示值 = target;
    ui.动画起始值 = target;
    ui.动画已经过秒 = ui.平滑过渡秒;
    刷新填充(ui);
    刷新文本(ui);
    return;
  }
  ui.动画起始值 = ui.显示值;
  ui.动画已经过秒 = 0;
}

export function 设置世界坐标进度UI类型(this: void, ui: 世界坐标进度UI | null | undefined, type: 世界坐标进度UI类型): void {
  if (ui == null || ui.已销毁 || ui.类型 === type) return;
  const visual = 类型表现表[type];
  ui.类型 = type;
  ui.数值颜色 = visual.颜色;
  DzFrameSetTexture(ui.填充帧, visual.贴图, 0);
  刷新文本(ui);
}

export function 设置世界坐标进度UI显示(this: void, ui: 世界坐标进度UI | null | undefined, visible: boolean): void {
  if (ui == null || ui.已销毁 || ui.已显示 === visible) return;
  ui.已显示 = visible;
  DzFrameShow(ui.根帧, visible);
}

export function 销毁世界坐标进度UI(this: void, ui: 世界坐标进度UI | null | undefined): void {
  if (ui == null || ui.已销毁) return;
  ui.已销毁 = true;
  ui.已显示 = false;
  从驱动列表移除(ui);
  DzFrameShow(ui.根帧, false);
  DzFrameUnBind(ui.根帧);
  DzDestroyFrame(ui.根帧);
  尝试停止世界坐标进度UI驱动();
}
