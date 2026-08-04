/** @noSelfInFile */

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.index") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 处理合成消耗装备属性 } = require("系统.02．物品系统.11．装备系统") as {
  处理合成消耗装备属性: (this: void, unit: any, item: any, consumedCount: number) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetItemCharges = jass.GetItemCharges as (item: any) => number;
const SetItemCharges = jass.SetItemCharges as (item: any, charges: number) => void;
const RemoveItem = jass.RemoveItem as (item: any) => void;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const UnitAddItem = jass.UnitAddItem as (unit: any, item: any) => boolean | number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

type 原料定义 = readonly [string, number];

interface 合成配方定义 {
  材料: readonly 原料定义[];
  产物: string;
}

interface 合成材料 {
  物品类型ID: number;
  数量: number;
}

interface 合成配方 {
  材料: 合成材料[];
  产物类型ID: number;
}

interface 背包物品状态 {
  物品: any;
  物品类型ID: number;
  可用数量: number;
  消耗数量: number;
}

interface 合成消耗计划 {
  配方: 合成配方;
  物品列表: 背包物品状态[];
}

/** 配方配置使用装备数据里的 name，注册时统一反查为物品类型 ID。 */
const 合成配方定义列表: readonly 合成配方定义[] = [
  { 材料: [["火药弓", 1], ["铁块", 5], ["矮人燧发枪图纸", 1]], 产物: "矮人燧发枪" },
  { 材料: [["火药弓", 1], ["铁块", 5], ["合成|打造", 1], ["矮人火炮图纸", 1]], 产物: "矮人火炮" },
  { 材料: [["战士风衣", 1], ["风之能量", 3], ["矮人火枪风衣图纸", 1]], 产物: "矮人火枪披风" },
  { 材料: [["蝎壳", 3], ["合成|打造", 1]], 产物: "蝎甲" },
  { 材料: [["毒囊", 5]], 产物: "毒囊道具" },
  { 材料: [["鸟人羽毛", 5], ["高原狼皮", 5], ["合成|打造", 1]], 产物: "高原战衣" },
  { 材料: [["风之能量", 3]], 产物: "风之饰品" },
  { 材料: [["血浴之母的第一条右腿", 1], ["血浴之母的第一条左腿", 1], ["委托编织", 1]], 产物: "炽热蜘蛛项链" },
  { 材料: [["血浴之母的第二条右腿", 1], ["血浴之母的第二条左腿", 1], ["委托编织", 1]], 产物: "防御蜘蛛项链" },
  { 材料: [["血浴之母的第三条右腿", 1], ["血浴之母的第三条左腿", 1], ["委托编织", 1]], 产物: "生命蜘蛛项链" },
  { 材料: [["血浴之母的第四条右腿", 1], ["血浴之母的第四条左腿", 1], ["委托编织", 1]], 产物: "追击蜘蛛项链" },
  { 材料: [["淡水鱼（小）", 5]], 产物: "淡水鱼（普通）" },
  { 材料: [["淡水鱼（普通）", 2]], 产物: "淡水鱼（大）" },
  { 材料: [["恢复指环", 3]], 产物: "初心戒指" },
  { 材料: [["石头", 3], ["木材", 2]], 产物: "篝火" },
  { 材料: [["小盾牌", 1], ["木材", 2]], 产物: "精致木盾" },
  { 材料: [["螃蟹壳", 2], ["合成|打造", 1]], 产物: "蟹壳护肩" },
  { 材料: [["铁矛图纸", 1], ["铁块", 2], ["地精长矛", 1]], 产物: "铁矛" },
  { 材料: [["地精长矛", 1], ["蟹钳", 1]], 产物: "钳枪" },
  { 材料: [["炸药粉", 2], ["木材", 2], ["火药弓图纸", 1]], 产物: "火药弓" },
  { 材料: [["树枝骨干+3", 1], ["树枝骨干", 1]], 产物: "树枝骨干MAX" },
  { 材料: [["树枝骨干+2", 1], ["树枝骨干", 1]], 产物: "树枝骨干+3" },
  { 材料: [["树枝骨干+1", 1], ["树枝骨干", 1]], 产物: "树枝骨干+2" },
  { 材料: [["树枝骨干", 2]], 产物: "树枝骨干+1" },
  { 材料: [["树枝", 2]], 产物: "树枝骨干" },
  { 材料: [["魔力树枝", 1], ["生命树枝", 1]], 产物: "生机树枝" },
  { 材料: [["小法杖", 1], ["魔力树枝", 1], ["合成|打造", 1]], 产物: "树枝法杖（主武器）" },
  { 材料: [["精灵铁剑", 1], ["树枝骨干", 1], ["合成|打造", 1]], 产物: "树枝剑（主武器）" },
  { 材料: [["木材", 2], ["合成|打造", 1]], 产物: "树枝" },
  { 材料: [["风鸟之心", 1], ["合成|打造", 1], ["湖之龙枪", 1]], 产物: "森灵圣枪" },
  { 材料: [["豺狼皮", 6], ["合成|打造", 1]], 产物: "皮裤" },
  { 材料: [["女妖头饰", 1], ["火魔之息", 2]], 产物: "女妖头饰-强化" },
  { 材料: [["狱生面具", 1], ["恶魔残魂", 2]], 产物: "狱生面具（强化）" },
  { 材料: [["汭冥血杖", 1], ["炽热能量", 2]], 产物: "汭冥血杖-强化" },
  { 材料: [["改良版魔法药水（中）", 1], ["炽热能量", 1], ["药水合成", 1]], 产物: "浴魔药剂" },
  { 材料: [["改良版医疗剂（中）", 1], ["恶魔残魂", 1], ["药水合成", 1]], 产物: "浴血药剂" },
  { 材料: [["熔墓之戒", 1], ["恶魔结晶", 2], ["合成|打造", 1]], 产物: "亡墓恶戒" },
  { 材料: [["虚空板甲", 1], ["恶魔精魄", 2], ["合成|打造", 1]], 产物: "虚空装甲" },
  { 材料: [["汭冥符文", 1], ["火焰元素", 2], ["炽热能量", 3], ["食尸鬼头颅", 1], ["合成|打造", 1]], 产物: "熔狱头骷" },
];

const 合成配方索引 = new Map<number, 合成配方[]>();
const 合成成功特效路径 = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl";
const 合成成功特效持续秒 = 2;

function 合并原料(this: void, 原料列表: readonly 原料定义[]): 合成材料[] {
  const 结果: 合成材料[] = [];
  for (let i = 0; i < 原料列表.length; i++) {
    const 物品名 = 原料列表[i][0];
    const count = 原料列表[i][1];
    const itemTypeId = stringToFourCCSafe(按名字反查物品ID(物品名));
    if (!(itemTypeId > 0) || !(count > 0)) continue;

    let merged = false;
    for (let j = 0; j < 结果.length; j++) {
      if (结果[j].物品类型ID !== itemTypeId) continue;
      结果[j].数量 += count;
      merged = true;
      break;
    }
    if (!merged) 结果.push({ 物品类型ID: itemTypeId, 数量: count });
  }
  return 结果;
}

function 注册合成配方(this: void, 定义: 合成配方定义): void {
  const 产物类型ID = stringToFourCCSafe(按名字反查物品ID(定义.产物));
  const 材料 = 合并原料(定义.材料);
  if (!(产物类型ID > 0) || 材料.length <= 0) return;

  const 配方: 合成配方 = { 材料, 产物类型ID };
  for (let i = 0; i < 材料.length; i++) {
    const 物品类型ID = 材料[i].物品类型ID;
    let 配方列表 = 合成配方索引.get(物品类型ID);
    if (配方列表 == null) {
      配方列表 = [];
      合成配方索引.set(物品类型ID, 配方列表);
    }
    配方列表.push(配方);
  }
}

function 初始化合成配方(this: void): void {
  if (合成配方索引.size > 0) return;
  for (let i = 0; i < 合成配方定义列表.length; i++) {
    注册合成配方(合成配方定义列表[i]);
  }
}

function 获取物品可用数量(this: void, 物品: any): number {
  const charges = GetItemCharges(物品);
  return charges > 0 ? charges : 1;
}

function 读取背包状态(this: void, 单位: any, 触发物品: any): 背包物品状态[] | null {
  const 结果: 背包物品状态[] = [];
  let 找到触发物品 = false;
  for (let i = 0; i < 6; i++) {
    const 物品 = UnitItemInSlot(单位, i);
    if (物品 == null || 物品 === 0) continue;
    if (物品 === 触发物品) 找到触发物品 = true;
    结果.push({
      物品,
      物品类型ID: GetItemTypeId(物品),
      可用数量: 获取物品可用数量(物品),
      消耗数量: 0,
    });
  }
  return 找到触发物品 ? 结果 : null;
}

function 构建消耗计划(this: void, 单位: any, 触发物品: any, 配方: 合成配方): 合成消耗计划 | null {
  const 背包状态 = 读取背包状态(单位, 触发物品);
  if (背包状态 == null) return null;

  for (let i = 0; i < 配方.材料.length; i++) {
    const 材料 = 配方.材料[i];
    let 需要数量 = 材料.数量;
    for (let j = 0; j < 背包状态.length && 需要数量 > 0; j++) {
      const 背包物品 = 背包状态[j];
      if (背包物品.物品类型ID !== 材料.物品类型ID || 背包物品.可用数量 <= 0) continue;
      const 本次消耗 = 背包物品.可用数量 < 需要数量 ? 背包物品.可用数量 : 需要数量;
      背包物品.可用数量 -= 本次消耗;
      背包物品.消耗数量 += 本次消耗;
      需要数量 -= 本次消耗;
    }
    if (需要数量 > 0) return null;
  }

  const 物品列表: 背包物品状态[] = [];
  for (let i = 0; i < 背包状态.length; i++) {
    if (背包状态[i].消耗数量 > 0) 物品列表.push(背包状态[i]);
  }
  return { 配方, 物品列表 };
}

function 查找可合成计划(this: void, 单位: any, 物品: any): 合成消耗计划 | null {
  const 物品类型ID = GetItemTypeId(物品);
  const 配方列表 = 合成配方索引.get(物品类型ID);
  if (配方列表 == null) return null;

  for (let i = 0; i < 配方列表.length; i++) {
    const 计划 = 构建消耗计划(单位, 物品, 配方列表[i]);
    if (计划 != null) return 计划;
  }
  return null;
}

function 消耗合成材料(this: void, 单位: any, 物品列表: readonly 背包物品状态[]): void {
  for (let i = 0; i < 物品列表.length; i++) {
    const 状态 = 物品列表[i];
    const charges = GetItemCharges(状态.物品);
    if (charges > 0 && 状态.消耗数量 < charges) {
      // 部分消耗不会触发丢弃事件，只在这里按实际消耗数量回退属性。
      处理合成消耗装备属性(单位, 状态.物品, 状态.消耗数量);
      SetItemCharges(状态.物品, charges - 状态.消耗数量);
    } else {
      // 完整移除会触发装备系统的丢弃处理，由丢弃事件统一回退一次属性。
      RemoveItem(状态.物品);
    }
  }
}

function 创建并加入合成产物(this: void, 单位: any, 产物类型ID: number): any {
  const 产物 = 创建物品并注册排泄监听(产物类型ID, GetUnitX(单位), GetUnitY(单位));
  if (产物 == null || 产物 === 0) return null;

  const charges = GetItemCharges(产物);
  if (charges > 0) SetItemCharges(产物, 1);
  UnitAddItem(单位, 产物);
  return 产物;
}

function 播放合成成功特效(this: void, 单位: any): void {
  createTimedEffect(合成成功特效路径, GetUnitX(单位), GetUnitY(单位), 0, 合成成功特效持续秒);
}

export function 处理通用物品合成打造(this: void, 单位: any, 物品: any): void {
  if (单位 == null || 单位 === 0 || 物品 == null || 物品 === 0) return;
  初始化合成配方();

  const 计划 = 查找可合成计划(单位, 物品);
  if (计划 == null) return;

  消耗合成材料(单位, 计划.物品列表);
  创建并加入合成产物(单位, 计划.配方.产物类型ID);
  播放合成成功特效(单位);
}

初始化合成配方();

export {};
