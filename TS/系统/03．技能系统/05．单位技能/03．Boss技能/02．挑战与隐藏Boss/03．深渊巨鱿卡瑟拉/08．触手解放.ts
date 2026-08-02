/** @noSelfInFile */

import type { 卡瑟拉运行时上下文 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置, 卡瑟拉音效配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, 极坐标X, 极坐标Y, 播放卡瑟拉限时动作 } from "./14．公共工具";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
import { 创建限时摧毁目标组, type 限时摧毁目标组实例, type 限时摧毁目标组结束原因 } from "../../../../00．技能模板+函数/04．机制组件/05．机制单位/02．限时摧毁目标组";
import type { 可攻击机制单位结束原因 } from "../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位";
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const ShowUnit = jass.ShowUnit as (unit: any, show: boolean) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 临时调整护甲 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  临时调整护甲: (this: void, unit: any, value: number) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示大招吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};

const 卡瑟拉触手解放暂停来源 = "Boss:Kasela:触手解放";

interface 触手解放实例 {
  context: 卡瑟拉运行时上下文;
  已结束: boolean;
  击破数量: number;
  目标组?: 限时摧毁目标组实例;
}

function 治疗Boss最大生命比例(this: void, boss: any, ratio: number): void {
  if (!单位有效(boss) || !(ratio > 0)) return;
  doHeal({ HealSource: boss, HealTarget: boss, HealAmount: GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * ratio, ItemHeal: false, HealEffect: false });
}

function 播放潜入特效(this: void, x: number, y: number): void {
  const cfg = 卡瑟拉数值与表现配置.触手解放;
  const model: string = cfg.潜入特效路径;
  if (model !== "") {
    const effect = AddSpecialEffect(model, x, y);
    DestroyEffect(effect);
  }
  创建点特效({
    模型路径: cfg.潜入回归能量爆闪特效模型路径,
    X: x,
    Y: y,
    缩放: cfg.潜入回归叠加特效缩放,
    持续秒: cfg.潜入回归叠加特效持续秒,
  });
  创建点特效({
    模型路径: cfg.潜入回归水柱特效模型路径,
    X: x,
    Y: y,
    缩放: cfg.潜入回归叠加特效缩放,
    持续秒: cfg.潜入回归叠加特效持续秒,
  });
}

function 回归卡瑟拉(this: void, data: 触手解放实例, success: boolean): void {
  if (data.已结束) return;
  data.已结束 = true;
  关闭吟唱条("大招");
  const context = data.context;
  const boss = context.Boss单位;
  context.Boss潜入中 = false;
  if (!单位有效(boss)) return;
  ShowUnit(boss, true);
  移除单位暂停(boss, 卡瑟拉触手解放暂停来源);
  播放潜入特效(GetUnitX(boss), GetUnitY(boss));
  const cfg = 卡瑟拉数值与表现配置.触手解放;
  if (success) {
    播放Boss坐标音效(卡瑟拉音效配置.触手解放.成功破甲, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
    const armorDown = data.击破数量 * cfg.每条破甲比例 * 100;
    if (armorDown > 0) 临时调整护甲(boss, -armorDown);
  } else {
    播放Boss坐标音效(卡瑟拉音效配置.触手解放.失败回血, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
    治疗Boss最大生命比例(boss, cfg.失败回血比例);
  }
}

function on巨型触手目标结束(this: void, _目标: any, 原因: 可攻击机制单位结束原因, 变量?: any): void {
  const data = 变量 as 触手解放实例 | undefined;
  if (data == null || data.已结束) return;
  if (原因 !== "机制清理" && 原因 !== "主动销毁") data.击破数量 = data.击破数量 + 1;
}

function on卡瑟拉触手解放目标组结束(this: void, 是否成功: boolean, _剩余数量: number, 变量?: any, 原因?: 限时摧毁目标组结束原因): void {
  const data = 变量 as 触手解放实例 | undefined;
  if (data == null || data.已结束) return;
  if (原因 === "机制清理" || 原因 === "主动结束") {
    data.已结束 = true;
    关闭吟唱条("大招");
    data.context.Boss潜入中 = false;
    return;
  }
  回归卡瑟拉(data, 是否成功);
}

function 创建巨型触手参数(this: void, context: 卡瑟拉运行时上下文, angle: number): any {
  const boss = context.Boss单位;
  const cfg = 卡瑟拉数值与表现配置.触手解放;
  const x = 极坐标X(GetUnitX(boss), angle, 650);
  const y = 极坐标Y(GetUnitY(boss), angle, 650);
  return {
    清理: context.清理,
    名称: "卡瑟拉-解放巨型触手",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: "hfoo",
    模型路径: cfg.巨型触手模型路径,
    X: x,
    Y: y,
    朝向: angle + 180,
    最大生命: cfg.巨型触手生命值,
    缩放: cfg.巨型触手缩放,
    固定站桩: true,
    持续时间: cfg.限时秒 + 2,
  };
}

function 执行卡瑟拉潜入与触手解放(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !context.Boss潜入中) return;
  const cfg = 卡瑟拉数值与表现配置.触手解放;
  播放潜入特效(GetUnitX(boss), GetUnitY(boss));
  ShowUnit(boss, false);
  添加单位暂停(boss, 卡瑟拉触手解放暂停来源);
  创建技能提示圈({
    类型: "双环",
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    半径: 720,
    持续时间: cfg.限时秒,
    来源单位: boss,
  });
  显示大招吟唱条({
    总时长: cfg.限时秒,
    颜色ID: cfg.吟唱条颜色ID,
    标题文本: cfg.吟唱条标题文本,
    提示文本: cfg.吟唱条提示文本,
  });
  const data: 触手解放实例 = { context, 已结束: false, 击破数量: 0 };
  播放Boss坐标音效(卡瑟拉音效配置.触手解放.巨型触手出水, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
  const 目标列表: any[] = [];
  for (let i = 0; i < cfg.触手数量; i++) {
    目标列表.push(创建巨型触手参数(context, i * 90));
  }
  const 目标组 = 创建限时摧毁目标组({
    清理: context.清理,
    名称: "卡瑟拉-触手解放巨型触手组",
    持续秒: cfg.限时秒,
    目标列表,
    变量: data,
    on目标结束: on巨型触手目标结束,
    on结束: on卡瑟拉触手解放目标组结束,
  });
  data.目标组 = 目标组;
  const 触手特效配置 = {
    模型路径: cfg.巨型触手出现特效模型路径,
    缩放: cfg.巨型触手出现特效缩放,
    持续秒: cfg.巨型触手出现特效持续秒,
  };
  for (let i = 0; i < 目标组.目标单位列表.length; i++) {
    const 目标 = 目标组.目标单位列表[i];
    if (!单位有效(目标.单位)) continue;
    创建点特效({
      ...触手特效配置,
      X: GetUnitX(目标.单位),
      Y: GetUnitY(目标.单位),
    });
  }
}

export function 触发卡瑟拉触手解放(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  if (context.触手解放已触发 || context.Boss潜入中) return;
  const cfg = 卡瑟拉数值与表现配置.触手解放;
  context.触手解放已触发 = true;
  context.Boss潜入中 = true;
  播放卡瑟拉限时动作(boss, cfg.动画编号, cfg.动画速度, cfg.动作原始时长秒);
  播放卡瑟拉台词(boss, "触手解放");
  播放Boss坐标音效(卡瑟拉音效配置.触手解放.Boss下潜, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 卡瑟拉音效配置.怪物拟声.标识,
    音效路径列表: 卡瑟拉音效配置.怪物拟声.音效路径列表,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    裁断距离: 卡瑟拉音效配置.默认裁断距离,
    冷却Ms: 卡瑟拉音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 卡瑟拉音效配置.怪物拟声.转阶段触发概率百分比,
  });
  const 潜入ID = addDelayedCallback(cfg.动作原始时长秒 * 1000, function 卡瑟拉触手解放动作结束(this: void): void {
    执行卡瑟拉潜入与触手解放(context);
  });
  context.清理.登记延迟回调("卡瑟拉-触手解放潜入", 潜入ID);
}
