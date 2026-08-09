/** @noSelfInFile */

const jass = require("jass.common") as any;
const { stringToFourCCSafe, fourCCToStringSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
  fourCCToStringSafe: (this: void, fourcc: number) => string;
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
const { 处理合成消耗装备属性, beginEquipItemMessageSilence, endEquipItemMessageSilence } = require("系统.02．物品系统.11．装备系统") as {
  处理合成消耗装备属性: (this: void, unit: any, item: any, consumedCount: number) => void;
  beginEquipItemMessageSilence: (this: void) => void;
  endEquipItemMessageSilence: (this: void) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetItemCharges = jass.GetItemCharges as (item: any) => number;
const SetItemCharges = jass.SetItemCharges as (item: any, charges: number) => void;
const RemoveItem = jass.RemoveItem as (item: any) => void;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const UnitAddItem = jass.UnitAddItem as (unit: any, item: any) => boolean | number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

const 合成调试模块 = "装备合成";
const 一次性打造壳类型ID列表 = ["I01A", "I04U", "I09A", "I09L", "I09T"] as const;
const 一次性打造壳类型ID集合 = new Set<number>();

for (let i = 0; i < 一次性打造壳类型ID列表.length; i++) {
  一次性打造壳类型ID集合.add(stringToFourCCSafe(一次性打造壳类型ID列表[i]));
}

function 输出合成调试日志(this: void, ...args: any[]): void {
  debugLogForce(合成调试模块, ...args);
}

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
  跳过实际消耗: boolean;
}

interface 合成消耗计划 {
  配方: 合成配方;
  物品列表: 背包物品状态[];
}

/** 配方配置使用装备数据里的 name；同名物品可追加 #内部ID 指定唯一物品。 */
const 合成配方定义列表: readonly 合成配方定义[] = [
  { 材料: [["火药弓#I026", 1], ["铁块#I04V", 5], ["矮人燧发枪图纸#I04O", 1]], 产物: "矮人燧发枪#I04K" },
  { 材料: [["火药弓#I026", 1], ["铁块#I04V", 5], ["合成|打造#I04U", 1], ["矮人火炮图纸#I04N", 1]], 产物: "矮人火炮#I04L" },
  { 材料: [["战士风衣#I03H", 1], ["风之能量#I04Q", 3], ["矮人火枪风衣图纸#I04P", 1]], 产物: "矮人火枪披风#I04M" },
  { 材料: [["蝎壳#I03Y", 3], ["合成|打造#I04U", 1]], 产物: "蝎甲#I04X" },
  { 材料: [["毒囊#I04R", 5]], 产物: "毒囊道具#I04Y" },
  { 材料: [["鸟人羽毛#I04S", 5], ["高原狼皮#I04T", 5], ["合成|打造#I04U", 1]], 产物: "高原战衣#I058" },
  { 材料: [["风之能量#I04Q", 3]], 产物: "风之饰品#I04Z" },
  { 材料: [["血浴之母的第一条右腿#I03O", 1], ["血浴之母的第一条左腿#I03N", 1], ["委托编织#I09T", 1]], 产物: "炽热蜘蛛项链#I0AK" },
  { 材料: [["血浴之母的第二条右腿#I03Q", 1], ["血浴之母的第二条左腿#I03P", 1], ["委托编织#I09T", 1]], 产物: "防御蜘蛛项链#I09V" },
  { 材料: [["血浴之母的第三条右腿#I03R", 1], ["血浴之母的第三条左腿#I03T", 1], ["委托编织#I09T", 1]], 产物: "生命蜘蛛项链#I09U" },
  { 材料: [["血浴之母的第四条右腿#I03S", 1], ["血浴之母的第四条左腿#I03U", 1], ["委托编织#I09T", 1]], 产物: "追击蜘蛛项链#I09X" },
  { 材料: [["淡水鱼（小）#I02X", 5]], 产物: "淡水鱼（普通）#I02W" },
  { 材料: [["淡水鱼（普通）#I02W", 2]], 产物: "淡水鱼（大）#I02Y" },
  { 材料: [["恢复指环#I00S", 3]], 产物: "初心戒指#I01K" },
  { 材料: [["石头#I02J", 3], ["木材#I024", 2]], 产物: "篝火#I02M" },
  { 材料: [["小盾牌#I027", 1], ["木材#I024", 2]], 产物: "精致木盾#I02B" },
  { 材料: [["螃蟹壳#I02K", 2], ["合成|打造#I01A", 1]], 产物: "蟹壳护肩#I02L" },
  { 材料: [["铁矛图纸#I02A", 1], ["铁块#I023", 2], ["地精长矛#I022", 1]], 产物: "铁矛#I025" },
  { 材料: [["地精长矛#I022", 1], ["蟹钳#I02N", 1]], 产物: "钳枪#I02O" },
  { 材料: [["炸药粉#I01P", 2], ["木材#I024", 2], ["火药弓图纸#I029", 1]], 产物: "火药弓#I026" },
  { 材料: [["树枝骨干+3#I00M", 1], ["树枝骨干#I00C", 1]], 产物: "树枝骨干MAX#I00N" },
  { 材料: [["树枝骨干+2#I00L", 1], ["树枝骨干#I00C", 1]], 产物: "树枝骨干+3#I00M" },
  { 材料: [["树枝骨干+1#I00K", 1], ["树枝骨干#I00C", 1]], 产物: "树枝骨干+2#I00L" },
  { 材料: [["树枝骨干#I00C", 2]], 产物: "树枝骨干+1#I00K" },
  { 材料: [["树枝#I00P", 2]], 产物: "树枝骨干#I00C" },
  { 材料: [["魔力树枝#I00D", 1], ["生命树枝#I00E", 1]], 产物: "生机树枝#I00I" },
  { 材料: [["小法杖#I00T", 1], ["魔力树枝#I00D", 1]], 产物: "树枝法杖（主武器）#I00H" },
  { 材料: [["精灵铁剑#I00V", 1], ["树枝骨干#I00C", 1]], 产物: "树枝剑（主武器）#I00F" },
  { 材料: [["木材#I024", 2], ["合成|打造#I01A", 1]], 产物: "树枝#I00P" },
  { 材料: [["风鸟之心#I05C", 1], ["合成|打造#I01A", 1], ["湖之龙枪#I039", 1]], 产物: "森灵圣枪#I0DL" },
  { 材料: [["豺狼皮#I01O", 6], ["合成|打造#I01A", 1]], 产物: "皮裤#I02G" },
  { 材料: [["女妖头饰#I075", 1], ["火魔之息#I08Y", 2]], 产物: "女妖头饰-强化#I076" },
  { 材料: [["狱生面具#I077", 1], ["恶魔残魂#I090", 2]], 产物: "狱生面具（强化）#I078" },
  { 材料: [["汭冥血杖#I07L", 1], ["炽热能量#I08Z", 2]], 产物: "汭冥血杖-强化#I07M" },
  { 材料: [["改良版魔法药水（中）#I05U", 1], ["炽热能量#I08Z", 1], ["药水合成#I09L", 1]], 产物: "浴魔药剂#I09I" },
  { 材料: [["改良版医疗剂（中）#I05S", 1], ["恶魔残魂#I090", 1], ["药水合成#I09L", 1]], 产物: "浴血药剂#I09J" },
  { 材料: [["改良版医疗剂（中）#I05S", 1], ["药水合成#I09L", 1]], 产物: "浴灵药剂#I09K" },
  { 材料: [["熔墓之戒#I08U", 1], ["恶魔结晶#I091", 2], ["合成|打造#I09A", 1]], 产物: "亡墓恶戒#I09G" },
  { 材料: [["虚空板甲#I08N", 1], ["恶魔精魄#I093", 2], ["合成|打造#I09A", 1]], 产物: "虚空装甲#I09F" },
  { 材料: [["汭冥符文#I07Q", 1], ["火焰元素#I092", 2], ["炽热能量#I08Z", 3], ["食尸鬼头颅#I064", 1], ["合成|打造#I09A", 1]], 产物: "熔狱头骷#I09E" },
];

const 合成配方索引 = new Map<number, 合成配方[]>();
const 合成成功特效路径 = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl";
const 合成成功特效持续秒 = 2;

function 解析合成物品类型ID(this: void, 物品描述: string): number {
  const 分隔位置 = 物品描述.indexOf("#");
  if (分隔位置 > 0) {
    const 内部ID = 物品描述.substring(分隔位置 + 1);
    if (内部ID.length === 4) return stringToFourCCSafe(内部ID);
    物品描述 = 物品描述.substring(0, 分隔位置);
  }
  return stringToFourCCSafe(按名字反查物品ID(物品描述));
}

function 合并原料(this: void, 原料列表: readonly 原料定义[]): 合成材料[] {
  const 结果: 合成材料[] = [];
  for (let i = 0; i < 原料列表.length; i++) {
    const 物品名 = 原料列表[i][0];
    const count = 原料列表[i][1];
    const itemTypeId = 解析合成物品类型ID(物品名);
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
  const 产物类型ID = 解析合成物品类型ID(定义.产物);
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

function 读取背包状态(this: void, 单位: any, 触发物品: any, 触发物品类型ID: number, 使用虚拟触发材料: boolean): 背包物品状态[] | null {
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
      跳过实际消耗: false,
    });
  }
  if (使用虚拟触发材料) {
    结果.push({
      物品: null,
      物品类型ID: 触发物品类型ID,
      可用数量: 1,
      消耗数量: 0,
      跳过实际消耗: true,
    });
  }
  输出合成调试日志("读取背包状态", "trigger", fourCCToStringSafe(触发物品类型ID), "found", 找到触发物品, "count", 结果.length);
  return 找到触发物品 || 使用虚拟触发材料 ? 结果 : null;
}

function 构建消耗计划(this: void, 单位: any, 触发物品: any, 触发物品类型ID: number, 配方: 合成配方, 使用虚拟触发材料: boolean): 合成消耗计划 | null {
  const 背包状态 = 读取背包状态(单位, 触发物品, 触发物品类型ID, 使用虚拟触发材料);
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
    if (需要数量 > 0) {
      输出合成调试日志("材料不足", "trigger", fourCCToStringSafe(触发物品类型ID), "material", fourCCToStringSafe(材料.物品类型ID), "need", 材料.数量, "missing", 需要数量);
      return null;
    }
  }

  const 物品列表: 背包物品状态[] = [];
  for (let i = 0; i < 背包状态.length; i++) {
    if (背包状态[i].消耗数量 > 0) 物品列表.push(背包状态[i]);
  }
  输出合成调试日志("构建消耗计划成功", "trigger", fourCCToStringSafe(触发物品类型ID), "product", fourCCToStringSafe(配方.产物类型ID), "itemCount", 物品列表.length);
  return { 配方, 物品列表 };
}

function 查找可合成计划(this: void, 单位: any, 物品: any, 物品类型ID: number, 使用虚拟触发材料: boolean): 合成消耗计划 | null {
  const 配方列表 = 合成配方索引.get(物品类型ID);
  if (配方列表 == null) return null;
  输出合成调试日志("查找配方", "trigger", fourCCToStringSafe(物品类型ID), "candidates", 配方列表.length);

  for (let i = 0; i < 配方列表.length; i++) {
    const 计划 = 构建消耗计划(单位, 物品, 物品类型ID, 配方列表[i], 使用虚拟触发材料);
    if (计划 != null) return 计划;
  }
  return null;
}

function 消耗合成材料(this: void, 单位: any, 物品列表: readonly 背包物品状态[]): void {
  for (let i = 0; i < 物品列表.length; i++) {
    const 状态 = 物品列表[i];
    if (状态.跳过实际消耗) {
      输出合成调试日志("跳过已消耗打造壳", "item", fourCCToStringSafe(状态.物品类型ID));
      continue;
    }
    const charges = GetItemCharges(状态.物品);
    输出合成调试日志("消耗材料", "item", fourCCToStringSafe(状态.物品类型ID), "available", charges, "consume", 状态.消耗数量);
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
  输出合成调试日志("创建产物", "product", fourCCToStringSafe(产物类型ID));
  const 产物 = 创建物品并注册排泄监听(产物类型ID, GetUnitX(单位), GetUnitY(单位));
  if (产物 == null || 产物 === 0) {
    输出合成调试日志("创建产物失败", "product", fourCCToStringSafe(产物类型ID));
    return null;
  }

  const charges = GetItemCharges(产物);
  if (charges > 0) SetItemCharges(产物, 1);
  UnitAddItem(单位, 产物);
  输出合成调试日志("创建产物成功", "product", fourCCToStringSafe(产物类型ID));
  return 产物;
}

function 播放合成成功特效(this: void, 单位: any): void {
  createTimedEffect(合成成功特效路径, GetUnitX(单位), GetUnitY(单位), 0, 合成成功特效持续秒);
}

export function 是一次性打造壳(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return 一次性打造壳类型ID集合.has(GetItemTypeId(物品));
}

function 处理指定类型物品合成打造(this: void, 单位: any, 物品: any, 物品类型ID: number, 使用虚拟触发材料: boolean): void {
  if (单位 == null || 单位 === 0 || !(物品类型ID > 0)) return;
  初始化合成配方();
  if (!合成配方索引.has(物品类型ID)) return;
  输出合成调试日志("触发打造", "item", fourCCToStringSafe(物品类型ID));

  const 计划 = 查找可合成计划(单位, 物品, 物品类型ID, 使用虚拟触发材料);
  if (计划 == null) return;

  beginEquipItemMessageSilence();
  消耗合成材料(单位, 计划.物品列表);
  endEquipItemMessageSilence();
  创建并加入合成产物(单位, 计划.配方.产物类型ID);
  播放合成成功特效(单位);
}

export function 处理通用物品合成打造(this: void, 单位: any, 物品: any): void {
  if (物品 == null || 物品 === 0) return;
  处理指定类型物品合成打造(单位, 物品, GetItemTypeId(物品), false);
}

export function 处理一次性打造壳合成(this: void, 单位: any, 物品类型ID: number): void {
  if (!一次性打造壳类型ID集合.has(物品类型ID)) return;
  处理指定类型物品合成打造(单位, null, 物品类型ID, true);
}

初始化合成配方();

export {};
