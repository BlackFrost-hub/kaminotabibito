/** @noSelfInFile */

import { 教派剑士单位技能配置 } from './00．配置';
import { 获取全部教派剑士上下文, 获取或创建教派剑士上下文, 教派剑士单位存活, type 教派剑士运行时上下文 } from './01．运行时上下文';
import { 教派剑士技能配置, 教派剑士音效配置 } from './02．数值与表现配置';
import { 播放教派剑士台词 } from './11．台词播放';
import { 创建可攻击机制单位, type 可攻击机制单位实例, type 可攻击机制单位结束原因 } from '../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位';
import { 开始冲锋 } from '../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/01．击退系统/03．对外接口';
import { 两点角度, 极坐标X, 极坐标Y, 距离平方XY, 读取单位最大生命 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行战斗自身传送到坐标 } from '../../../../00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 执行非伤害生命移除 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/09．非伤害生命移除';
import { 教派剑士BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/11．教派剑士';

const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback, removeDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, callbackId: number) => void;
};
const { 开始硬直 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require('lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统') as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { getUnitsInRange } = require('lib.扩展函数.自定义扩展函数.01．选取中心范围') as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { Sound3DII_CooPlayReuse } = require('lib.扩展函数.封装函数.02．音效系统.03．3D音效播放') as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const ShowUnit = jass.ShowUnit as (unit: any, show: boolean) => void;
const IssuePointOrder = jass.IssuePointOrder as (unit: any, order: string, x: number, y: number) => boolean;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 黑洞暂停来源 = 'Boss:教派剑士:黑洞跨越';

interface 黑洞跨越状态 {
  已结束: boolean;
  上下文: 教派剑士运行时上下文;
  阶段: '前摇' | '奔跑' | '消失' | '出口等待' | '结束';
  黑洞实例?: 可攻击机制单位实例;
  黑洞单位?: any;
  黑洞X: number;
  黑洞Y: number;
  出口目标?: any;
  移动检查回调ID: number;
  奔跑属性已应用: boolean;
  Boss已隐藏: boolean;
  启动回调ID: number;
  出口回调ID: number;
  出现回调ID: number;
}

const 教派剑士单位类型ID = stringToFourCCSafe(教派剑士单位技能配置.单位ID);
const 黑洞跨越技能ID = stringToFourCCSafe(教派剑士单位技能配置.技能ID.黑洞跨越);
let 黑洞跨越已注册 = false;

function 修改单位实数属性(this: void, unit: any, 属性名: string, 增量: number): void {
  const 当前值 = Number(YDUserDataGetSafe('unit', unit, 属性名, 'real')) || 0;
  YDUserDataSetSafe('unit', unit, 属性名, 'real', 当前值 + 增量);
}

function 扣除Boss最大生命比例(this: void, boss: any, ratio: number): void {
  执行非伤害生命移除({
    目标: boss,
    数值: 读取单位最大生命(boss) * ratio,
    不致死: false,
    显示文字: false,
    显示特效: false,
  });
}

function 恢复黑洞奔跑属性(this: void, 状态: 黑洞跨越状态): void {
  if (!状态.奔跑属性已应用) return;
  状态.奔跑属性已应用 = false;
  const boss = 状态.上下文.Boss单位;
  修改单位实数属性(boss, '闪避率', -教派剑士技能配置.黑洞跨越.奔跑闪避加成);
  修改单位实数属性(boss, '眩晕抗性', 教派剑士技能配置.黑洞跨越.奔跑韧性降低);
  移除单位指定Buff(boss, 教派剑士BuffID.黑洞奔袭);
  debugLogForce('教派剑士-黑洞跨越', '奔跑属性恢复', 'bossHid=', boss != null && boss !== 0 ? GetHandleId(boss) : 0);
}

function 清除黑洞强化普攻(this: void, variable?: any): void {
  const 上下文 = variable as 教派剑士运行时上下文 | undefined;
  if (上下文 == null) return;
  上下文.黑洞强化普攻清除回调ID = 0;
  上下文.黑洞强化普攻就绪 = false;
  移除单位指定Buff(上下文.Boss单位, 教派剑士BuffID.黑洞强化普攻);
  debugLogForce('教派剑士-黑洞跨越', '强化普攻窗口结束', 'bossHid=', 上下文.Boss单位 != null && 上下文.Boss单位 !== 0 ? GetHandleId(上下文.Boss单位) : 0);
}

function 激活黑洞强化普攻(this: void, 上下文: 教派剑士运行时上下文): void {
  const 配置 = 教派剑士技能配置.黑洞跨越;
  if (上下文.黑洞强化普攻清除回调ID !== 0) removeDelayedCallback(上下文.黑洞强化普攻清除回调ID);
  上下文.黑洞强化普攻就绪 = true;
  registerManualBuff(上下文.Boss单位, 教派剑士BuffID.黑洞强化普攻, 配置.强化普攻窗口秒, 0, { sourceUnit: 上下文.Boss单位, effectSourceName: '黑洞强化普攻', effectSourceType: '技能' });
  上下文.黑洞强化普攻清除回调ID = addDelayedCallback(配置.强化普攻窗口秒 * 1000, 清除黑洞强化普攻, 上下文);
  上下文.清理.登记延迟回调('教派剑士-黑洞强化普攻窗口', 上下文.黑洞强化普攻清除回调ID);
  debugLogForce('教派剑士-黑洞跨越', '强化普攻窗口激活', 'bossHid=', GetHandleId(上下文.Boss单位), 'duration=', 配置.强化普攻窗口秒);
}

function 结束黑洞跨越(this: void, 状态: 黑洞跨越状态, 原因: string): void {
  if (状态.已结束) return;
  状态.已结束 = true;
  状态.阶段 = '结束';
  恢复黑洞奔跑属性(状态);
  if (状态.移动检查回调ID !== 0) {
    removeDelayedCallback(状态.移动检查回调ID);
    状态.移动检查回调ID = 0;
  }
  const 黑洞实例 = 状态.黑洞实例;
  状态.黑洞实例 = undefined;
  状态.黑洞单位 = undefined;
  if (黑洞实例 != null) 黑洞实例.销毁('主动销毁');
  const boss = 状态.上下文.Boss单位;
  if (状态.Boss已隐藏 && boss != null && boss !== 0) {
    ShowUnit(boss, true);
    移除单位暂停(boss, 黑洞暂停来源);
    状态.Boss已隐藏 = false;
  }
  关闭吟唱条(教派剑士技能配置.黑洞跨越.读条通道);
  if (状态.上下文.黑洞状态 === 状态) 状态.上下文.黑洞状态 = undefined;
  debugLogForce('教派剑士-黑洞跨越', '状态结束', 'bossHid=', boss != null && boss !== 0 ? GetHandleId(boss) : 0, 'reason=', 原因);
}

function on黑洞跨越清理(this: void, variable?: any): void {
  const 状态 = variable as 黑洞跨越状态 | undefined;
  if (状态 != null) 结束黑洞跨越(状态, '上下文清理');
}

function 结算黑洞摧毁(this: void, 状态: 黑洞跨越状态, killer: any): void {
  const 配置 = 教派剑士技能配置.黑洞跨越;
  const boss = 状态.上下文.Boss单位;
  EC_CreateEffect(配置.黑洞摧毁特效路径, 状态.黑洞X, 状态.黑洞Y, 0, 0, 配置.黑洞摧毁特效缩放, 1, 配置.黑洞摧毁特效持续秒);
  Sound3DII_CooPlayReuse(教派剑士音效配置.黑洞跨越.黑洞被摧毁, 状态.黑洞X, 状态.黑洞Y, 0, 教派剑士音效配置.音效裁断距离);
  const 单位列表 = getUnitsInRange(状态.黑洞X, 状态.黑洞Y, 配置.摧毁爆炸半径);
  let 命中数 = 0;
  for (let i = 0; i < 单位列表.length; i++) {
    const target = 单位列表[i];
    const 比例 = target === killer ? 配置.摧毁者已损生命比例 : 配置.普通目标已损生命比例;
    const 结果 = 执行BossAOE技能伤害({
      来源: boss,
      目标: target,
      技能ID: 黑洞跨越技能ID,
      伤害公式: { 目标已损生命比例: 比例 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_ENHANCED,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: '教派剑士·黑洞摧毁',
    });
    if (结果.是否造成伤害) 命中数++;
    if (教派剑士单位存活(target)) {
      开始冲锋(target, {
        主单位: boss,
        角度: 两点角度(GetUnitX(target), GetUnitY(target), 状态.黑洞X, 状态.黑洞Y),
        距离: 配置.吸引距离,
        持续时间: 配置.吸引持续秒,
        检查地形: true,
        朝向跟随位移: false,
        暂停单位: false,
      });
    }
  }
  debugLogForce('教派剑士-黑洞跨越', '黑洞被玩家摧毁并结算', 'bossHid=', GetHandleId(boss), 'killerHid=', killer != null && killer !== 0 ? GetHandleId(killer) : 0, 'targetCount=', 单位列表.length, 'hitCount=', 命中数);
}

function on黑洞机制结束(this: void, _unit: any, reason: 可攻击机制单位结束原因, killer?: any, variable?: any): void {
  const 状态 = variable as 黑洞跨越状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  状态.黑洞实例 = undefined;
  状态.黑洞单位 = undefined;
  if (reason === '被击杀') {
    恢复黑洞奔跑属性(状态);
    if (killer != null && killer !== 0) 结算黑洞摧毁(状态, killer);
    结束黑洞跨越(状态, '黑洞被击杀');
    return;
  }
  if (状态.阶段 === '消失' || 状态.阶段 === '出口等待') return;
  结束黑洞跨越(状态, reason === '自然到期' ? '黑洞自然到期' : '黑洞提前结束');
}

function on黑洞Boss出现(this: void, variable?: any): void {
  const 状态 = variable as 黑洞跨越状态 | undefined;
  if (状态 == null || 状态.已结束 || !教派剑士单位存活(状态.上下文.Boss单位)) return;
  const boss = 状态.上下文.Boss单位;
  ShowUnit(boss, true);
  移除单位暂停(boss, 黑洞暂停来源);
  状态.Boss已隐藏 = false;
  激活黑洞强化普攻(状态.上下文);
  播放教派剑士台词(boss, '黑洞跨越');
  Sound3DII_CooPlayReuse(教派剑士音效配置.黑洞跨越.Boss出现, GetUnitX(boss), GetUnitY(boss), 0, 教派剑士音效配置.音效裁断距离);
  const target = 状态.出口目标;
  const 已下达攻击 = target != null && target !== 0 && 教派剑士单位存活(target)
    ? IssueTargetOrder(boss, 'attack', target)
    : false;
  debugLogForce('教派剑士-黑洞跨越', 'Boss出现并追击出口目标', 'bossHid=', GetHandleId(boss), 'targetHid=', target != null && target !== 0 ? GetHandleId(target) : 0, 'ordered=', 已下达攻击);
  结束黑洞跨越(状态, '成功穿越并出现');
}

function on创建黑洞出口(this: void, variable?: any): void {
  const 状态 = variable as 黑洞跨越状态 | undefined;
  if (状态 == null || 状态.已结束 || !教派剑士单位存活(状态.上下文.Boss单位)) return;
  const boss = 状态.上下文.Boss单位;
  const 配置 = 教派剑士技能配置.黑洞跨越;
  const target = 获取Boss技能随机敌对英雄(boss);
  状态.出口目标 = target;
  let X = 状态.黑洞X;
  let Y = 状态.黑洞Y;
  if (target != null && target !== 0 && 教派剑士单位存活(target)) {
    const behind = GetUnitFacing(target) + 180;
    X = 极坐标X(GetUnitX(target), behind, 配置.出口身后距离);
    Y = 极坐标Y(GetUnitY(target), behind, 配置.出口身后距离);
    SetUnitFacing(boss, 两点角度(X, Y, GetUnitX(target), GetUnitY(target)));
  }
  执行战斗自身传送到坐标(boss, X, Y);
  EC_CreateEffect(配置.黑洞模型路径, X, Y, 0, 0, 配置.黑洞缩放, 1, 配置.出口黑洞持续秒);
  状态.阶段 = '出口等待';
  状态.出现回调ID = addDelayedCallback(配置.出口等待秒 * 1000, on黑洞Boss出现, 状态);
  状态.上下文.清理.登记延迟回调('教派剑士-黑洞出现', 状态.出现回调ID);
  debugLogForce('教派剑士-黑洞跨越', '出口创建', 'bossHid=', GetHandleId(boss), 'targetHid=', target != null && target !== 0 ? GetHandleId(target) : 0, 'x=', X, 'y=', Y);
}

function 安排黑洞移动检查(this: void, 状态: 黑洞跨越状态): void {
  if (状态.已结束 || 状态.阶段 !== '奔跑') return;
  const 配置 = 教派剑士技能配置.黑洞跨越;
  状态.移动检查回调ID = addDelayedCallback(配置.移动检查间隔秒 * 1000, on黑洞移动检查, 状态);
  状态.上下文.清理.登记延迟回调('教派剑士-黑洞移动检查', 状态.移动检查回调ID);
}

function on黑洞移动检查(this: void, variable?: any): void {
  const 状态 = variable as 黑洞跨越状态 | undefined;
  if (状态 == null || 状态.已结束 || 状态.阶段 !== '奔跑') return;
  状态.移动检查回调ID = 0;
  const boss = 状态.上下文.Boss单位;
  if (!教派剑士单位存活(boss)) {
    结束黑洞跨越(状态, 'Boss失效');
    return;
  }
  const 配置 = 教派剑士技能配置.黑洞跨越;
  const 在入口内 = 距离平方XY(GetUnitX(boss), GetUnitY(boss), 状态.黑洞X, 状态.黑洞Y) <= 配置.黑洞进入距离 * 配置.黑洞进入距离;
  if (状态.黑洞实例 == null || !状态.黑洞实例.是否存活()) {
    结束黑洞跨越(状态, '黑洞失效');
    return;
  }
  if (!在入口内) {
    IssuePointOrder(boss, 'move', 状态.黑洞X, 状态.黑洞Y);
    安排黑洞移动检查(状态);
    return;
  }
  恢复黑洞奔跑属性(状态);
  状态.阶段 = '消失';
  Sound3DII_CooPlayReuse(教派剑士音效配置.黑洞跨越.进入黑洞, GetUnitX(boss), GetUnitY(boss), 0, 教派剑士音效配置.音效裁断距离);
  const 黑洞实例 = 状态.黑洞实例;
  状态.黑洞实例 = undefined;
  状态.黑洞单位 = undefined;
  黑洞实例.销毁('主动销毁');
  添加单位暂停(boss, 黑洞暂停来源);
  ShowUnit(boss, false);
  状态.Boss已隐藏 = true;
  状态.出口回调ID = addDelayedCallback(配置.消失等待秒 * 1000, on创建黑洞出口, 状态);
  状态.上下文.清理.登记延迟回调('教派剑士-黑洞出口', 状态.出口回调ID);
  debugLogForce('教派剑士-黑洞跨越', '成功进入黑洞并消失', 'bossHid=', GetHandleId(boss), 'wait=', 配置.消失等待秒);
}

function on开始黑洞奔跑(this: void, variable?: any): void {
  const 状态 = variable as 黑洞跨越状态 | undefined;
  if (状态 == null || 状态.已结束 || !教派剑士单位存活(状态.上下文.Boss单位)) return;
  const boss = 状态.上下文.Boss单位;
  const 配置 = 教派剑士技能配置.黑洞跨越;
  关闭吟唱条(配置.读条通道);
  扣除Boss最大生命比例(boss, 配置.自损最大生命比例);
  if (!教派剑士单位存活(boss)) {
    结束黑洞跨越(状态, '自损后死亡');
    return;
  }
  状态.黑洞实例 = 创建可攻击机制单位({
    清理: 状态.上下文.清理,
    名称: '教派剑士-黑洞入口',
    单位名称: '黑洞',
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    模型路径: 配置.黑洞模型路径,
    X: 状态.黑洞X,
    Y: 状态.黑洞Y,
    最大生命: 读取单位最大生命(boss) * 配置.黑洞最大生命比例,
    固定站桩: true,
    禁止普攻: true,
    禁用路径: true,
    缩放: 配置.黑洞缩放,
    持续时间: 配置.黑洞持续秒,
    变量: 状态,
    on结束: on黑洞机制结束,
  });
  if (状态.黑洞实例 == null) {
    结束黑洞跨越(状态, '黑洞创建失败');
    return;
  }
  状态.黑洞单位 = 状态.黑洞实例.单位;
  状态.奔跑属性已应用 = true;
  修改单位实数属性(boss, '闪避率', 配置.奔跑闪避加成);
  修改单位实数属性(boss, '眩晕抗性', -配置.奔跑韧性降低);
  registerManualBuff(boss, 教派剑士BuffID.黑洞奔袭, 配置.黑洞持续秒, 0, { sourceUnit: boss, effectSourceName: '黑洞奔袭', effectSourceType: '技能' });
  状态.阶段 = '奔跑';
  const 已下达移动 = IssuePointOrder(boss, 'move', 状态.黑洞X, 状态.黑洞Y);
  安排黑洞移动检查(状态);
  debugLogForce('教派剑士-黑洞跨越', '黑洞创建并开始真实移动', 'bossHid=', GetHandleId(boss), 'holeHid=', GetHandleId(状态.黑洞单位), 'ordered=', 已下达移动, 'x=', 状态.黑洞X, 'y=', 状态.黑洞Y);
}

function 黑洞克制属性承伤修正(this: void, context: any): number {
  if (context == null || context.target == null || context.target === 0 || (context.isFireDamage !== true && context.isLightDamage !== true)) return context?.currentDamage ?? 0;
  const 上下文列表 = 获取全部教派剑士上下文();
  for (let i = 0; i < 上下文列表.length; i++) {
    const 状态 = 上下文列表[i].黑洞状态 as 黑洞跨越状态 | undefined;
    if (状态 != null && !状态.已结束 && 状态.黑洞单位 === context.target) {
      const after = context.currentDamage * 教派剑士技能配置.黑洞跨越.克制属性承伤倍率;
      debugLogForce('教派剑士-黑洞跨越', '黑洞受到火/光克制增伤', 'holeHid=', GetHandleId(context.target), 'before=', context.currentDamage, 'after=', after);
      return after;
    }
  }
  return context.currentDamage;
}

export function 释放教派剑士黑洞跨越(this: void, 上下文: 教派剑士运行时上下文): boolean {
  const boss = 上下文?.Boss单位;
  if (!教派剑士单位存活(boss) || 上下文.黑洞状态 != null) return false;
  const 配置 = 教派剑士技能配置.黑洞跨越;
  const 方向 = GetRandomReal(0, 360);
  const 状态: 黑洞跨越状态 = {
    已结束: false,
    上下文,
    阶段: '前摇',
    黑洞X: 极坐标X(GetUnitX(boss), 方向, 配置.黑洞生成距离),
    黑洞Y: 极坐标Y(GetUnitY(boss), 方向, 配置.黑洞生成距离),
    移动检查回调ID: 0,
    奔跑属性已应用: false,
    Boss已隐藏: false,
    启动回调ID: 0,
    出口回调ID: 0,
    出现回调ID: 0,
  };
  上下文.黑洞状态 = 状态;
  上下文.清理.登记清理('教派剑士-黑洞跨越清理', on黑洞跨越清理, 状态);
  开始硬直(boss, 配置.施法硬直秒);
  SetUnitAnimation(boss, 配置.动作名);
  Sound3DII_CooPlayReuse(教派剑士音效配置.黑洞跨越.黑洞开启, GetUnitX(boss), GetUnitY(boss), 0, 教派剑士音效配置.音效裁断距离);
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.施法硬直秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  状态.启动回调ID = addDelayedCallback(配置.施法硬直秒 * 1000, on开始黑洞奔跑, 状态);
  上下文.清理.登记延迟回调('教派剑士-黑洞奔跑开始', 状态.启动回调ID);
  debugLogForce('教派剑士-黑洞跨越', '施法前摇开始', 'bossHid=', GetHandleId(boss), 'holeX=', 状态.黑洞X, 'holeY=', 状态.黑洞Y);
  return true;
}

function on教派剑士黑洞跨越生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 黑洞跨越技能ID || GetUnitTypeId(castingUnit) !== 教派剑士单位类型ID) return;
  const 上下文 = 获取或创建教派剑士上下文(castingUnit);
  const 已开始 = 上下文 != null && 释放教派剑士黑洞跨越(上下文);
  debugLogForce('教派剑士-黑洞跨越', '正式SPELL_EFFECT入口', 'bossHid=', GetHandleId(castingUnit), 'started=', 已开始);
}

export function 注册教派剑士黑洞跨越(this: void): void {
  if (黑洞跨越已注册) return;
  黑洞跨越已注册 = true;
  registerSpellEffectListener(on教派剑士黑洞跨越生效);
  registerDamageModifier(黑洞克制属性承伤修正, 8);
  debugLogForce('教派剑士-黑洞跨越', '技能壳与黑洞克制承伤监听注册完成', 'skillId=', 黑洞跨越技能ID);
}
