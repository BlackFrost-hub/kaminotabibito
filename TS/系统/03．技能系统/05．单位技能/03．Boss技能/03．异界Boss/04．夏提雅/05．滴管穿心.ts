/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 刷新夏提雅猎血连击Buff } from './03．滴管长枪连击';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 获取夏提雅英灵投影, 尝试触发英灵战乙女复刻 } from './09．英灵战乙女';
import { 播放夏提雅台词 } from './18．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 显示夏提雅常规吟唱条 } from './19．吟唱条';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getServerTime: (this: void) => number;
};
const { 特效显示_隐藏 } = require('平台扩展API动作') as {
  特效显示_隐藏: (this: void, effect: any, visible: boolean) => void;
};
const { 开始冲锋并附带残影表现 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.冲锋残影表现') as {
  开始冲锋并附带残影表现: (this: void, unit: any, moveConfig: any, visualConfig: any) => number;
};
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { CosBJ, SinBJ } = require('lib.扩展函数.BJ函数.12．数学函数') as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;

function 隐藏并销毁滴管穿心命中特效(this: void, effect?: any): void {
  if (effect == null || effect === 0) return;
  特效显示_隐藏(effect, false);
  DestroyEffect(effect);
}

function 开始滴管穿心冲锋(this: void, unit: any, moveConfig: any, facing: number, 动画速度?: number): number {
  const cfg = 夏提雅数值与表现配置.滴管穿心;
  return 开始冲锋并附带残影表现(unit, { ...moveConfig, 位移特效: '' }, {
    残影模型: 夏提雅数值与表现配置.表现资源.滴管长枪拖尾特效路径,
    残影生成间隔: cfg.拖尾特效生成间隔秒,
    残影生命周期: cfg.拖尾特效生命周期秒,
    残影透明度: 255,
    残影朝向: facing,
    动画速度,
  });
}

function 尝试安排滴管穿心英灵复刻(this: void, context: 夏提雅运行时上下文, lockedX: number, lockedY: number): void {
  const projection = 获取夏提雅英灵投影(context);
  if (!单位有效(projection)) {
    debugLogForce('夏提雅-滴管穿心', '英灵复刻跳过：投影无效');
    return;
  }
  const cfg = 夏提雅数值与表现配置.滴管穿心;
  const p2 = 夏提雅数值与表现配置.P2;
  let startX = GetUnitX(projection);
  let startY = GetUnitY(projection);
  let dx = lockedX - startX;
  let dy = lockedY - startY;
  let rawDistance = SquareRoot(dx * dx + dy * dy);
  if (!(rawDistance > 1)) {
    const bossX = GetUnitX(context.Boss单位);
    const bossY = GetUnitY(context.Boss单位);
    const bossDx = lockedX - bossX;
    const bossDy = lockedY - bossY;
    const bossDistance = SquareRoot(bossDx * bossDx + bossDy * bossDy);
    if (!(bossDistance > 1)) {
      debugLogForce('夏提雅-滴管穿心', '英灵复刻跳过：Boss与目标重合', 'distance=', rawDistance);
      return;
    }
    const fallbackFacing = Atan2(bossDy, bossDx) * RAD_TO_DEG;
    startX = lockedX + CosBJ(fallbackFacing) * p2.英灵常驻距离;
    startY = lockedY + SinBJ(fallbackFacing) * p2.英灵常驻距离;
    SetUnitPosition(projection, startX, startY);
    SetUnitFacing(projection, fallbackFacing + 180);
    dx = lockedX - startX;
    dy = lockedY - startY;
    rawDistance = SquareRoot(dx * dx + dy * dy);
    debugLogForce('夏提雅-滴管穿心', '英灵复刻重置起点', 'distance=', rawDistance, 'facing=', fallbackFacing);
  }
  const distance = rawDistance < cfg.最大距离 ? rawDistance : cfg.最大距离;
  const ratio = distance / rawDistance;
  const endX = startX + dx * ratio;
  const endY = startY + dy * ratio;
  const facing = Atan2(dy, dx) * RAD_TO_DEG;
  const delay = GetRandomReal(p2.英灵复刻延迟最小秒, p2.英灵复刻延迟最大秒);
  const started = 尝试触发英灵战乙女复刻(context, '滴管穿心', {
    X: startX,
    Y: startY,
    朝向: facing,
    延迟秒: delay,
    复刻结算: function 夏提雅滴管穿心英灵复刻(this: void): void {
      开始硬直(projection, cfg.冲锋秒);
      开始滴管穿心冲锋(projection, {
        目标X: endX,
        目标Y: endY,
        距离: distance,
        持续时间: cfg.冲锋秒,
        检查地形: true,
        暂停单位: false,
        禁用碰撞: true,
        命中半径: cfg.命中半径,
        只命中敌人: true,
        允许重复命中: false,
        命中后结束: false,
        动画序号: p2.英灵复刻冲锋动画编号,
        命中回调: function 滴管穿心英灵命中(this: void, _source: any, hit: any): void {
          const damage = 计算组合技能伤害(context.Boss单位, hit, {
            来源攻击力比例: cfg.伤害攻击力比例 * p2.英灵复刻伤害比例,
            目标最大生命比例: cfg.伤害目标最大生命比例 * p2.英灵复刻伤害比例,
          });
          造成AOE技能伤害({
            来源: context.Boss单位,
            目标: hit,
            伤害: damage,
            attack: false,
            ranged: false,
            attackType: ATTACK_TYPE_NORMAL,
            伤害类型: DAMAGE_TYPE_NORMAL,
            weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
            来源类型: 'Boss技能',
            标签: '夏提雅·英灵复刻-滴管穿心',
          });
        },
      }, facing, p2.英灵复刻冲锋动画速度);
    },
  });
  debugLogForce('夏提雅-滴管穿心', '英灵复刻安排', 'started=', started, 'distance=', distance, 'facing=', facing, 'delay=', delay);
  if (started) 创建技能提示圈({ 类型: '方向直线', X: startX, Y: startY, 宽度: cfg.路径宽度, 长度: distance, 朝向: facing, 持续时间: delay, 来源单位: context.Boss单位 });
}

export function 释放夏提雅滴管穿心(this: void, context: 夏提雅运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.挑战已结束 || context.当前大型技能 != null) {
    debugLogForce('夏提雅-滴管穿心', '本体释放拒绝', 'boss=', 单位有效(boss), 'target=', 单位有效(target), 'ended=', context.挑战已结束, 'largeSkill=', context.当前大型技能);
    return false;
  }
  播放夏提雅台词(boss, '滴管穿心');
  播放Boss坐标音效(夏提雅数值与表现配置.音效.滴管穿心突进, GetUnitX(boss), GetUnitY(boss), 夏提雅数值与表现配置.音效默认裁断距离);
  const cfg = 夏提雅数值与表现配置.滴管穿心;
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const dx = targetX - startX;
  const dy = targetY - startY;
  const rawDistance = SquareRoot(dx * dx + dy * dy);
  if (!(rawDistance > 1)) {
    debugLogForce('夏提雅-滴管穿心', '本体释放拒绝：目标距离过小', 'distance=', rawDistance);
    return false;
  }
  const distance = rawDistance < cfg.最大距离 ? rawDistance : cfg.最大距离;
  const ratio = distance / rawDistance;
  const endX = startX + dx * ratio;
  const endY = startY + dy * ratio;
  const facing = Atan2(dy, dx) * RAD_TO_DEG;
  SetUnitFacing(boss, facing);
  开始硬直(boss, cfg.预警秒);
  显示夏提雅常规吟唱条(cfg.预警秒, cfg.吟唱条颜色ID, cfg.吟唱条标题文本, cfg.吟唱条提示文本);
  context.普通机制忙碌到Ms = getServerTime() + (cfg.预警秒 + cfg.冲锋秒) * 1000;
  重置夏提雅猎血连击(context);
  创建技能提示圈({
    类型: '方向直线',
    X: startX,
    Y: startY,
    宽度: cfg.路径宽度,
    长度: distance,
    朝向: facing,
    持续时间: cfg.预警秒,
    来源单位: boss,
  });
  const mainTargetId = GetHandleId(target);
  const delayedId = addDelayedCallback(cfg.预警秒 * 1000, function 滴管穿心开始冲锋(this: void): void {
    if (!单位有效(boss) || context.挑战已结束) return;
    const chargeId = 开始滴管穿心冲锋(boss, {
      目标X: endX,
      目标Y: endY,
      距离: distance,
      持续时间: cfg.冲锋秒,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      命中半径: cfg.命中半径,
      只命中敌人: true,
      允许重复命中: false,
      命中后结束: false,
      命中回调: function 滴管穿心命中(this: void, source: any, hit: any): void {
        播放Boss坐标音效(夏提雅数值与表现配置.音效.滴管穿心汲血, GetUnitX(hit), GetUnitY(hit), 夏提雅数值与表现配置.音效默认裁断距离);
        const damage = 计算组合技能伤害(source, hit, {
          来源攻击力比例: cfg.伤害攻击力比例,
          目标最大生命比例: cfg.伤害目标最大生命比例,
        });
        造成AOE技能伤害({
          来源: source,
          目标: hit,
          伤害: damage,
          attack: false,
          ranged: false,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: DAMAGE_TYPE_NORMAL,
          weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
          来源类型: 'Boss技能',
          标签: '夏提雅·滴管穿心',
        });
        const effect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.滴管穿心命中特效路径, GetUnitX(hit), GetUnitY(hit));
        if (effect != null && effect !== 0) addDelayedCallback(cfg.命中特效持续秒 * 1000, 隐藏并销毁滴管穿心命中特效, effect);
        if (GetHandleId(hit) === mainTargetId) {
          context.当前猎血目标 = hit;
          context.当前猎血段数 = 1;
          context.猎血段数过期时间Ms = getServerTime() + 夏提雅数值与表现配置.滴管长枪连击.连击过期秒 * 1000;
          刷新夏提雅猎血连击Buff(context);
        }
      },
      开始回调: function 滴管穿心冲锋动作(this: void): void {
        播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.冲锋秒, 恢复动画编号: 0 });
      },
      结束回调: function 滴管穿心冲锋结束(this: void, _source: any, reason: string): void {
        if (reason === '完成' || reason === '撞墙') 尝试安排滴管穿心英灵复刻(context, targetX, targetY);
      },
    }, facing);
    debugLogForce('夏提雅-滴管穿心', '本体冲锋启动', 'chargeId=', chargeId, 'facing=', facing, 'distance=', distance);
    if (chargeId === 0) context.普通机制忙碌到Ms = getServerTime();
  });
  context.清理.登记延迟回调('夏提雅-滴管穿心预警', delayedId);
  return true;
}

export const 滴管穿心技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  包含战斗自身位移: true,
  语义: '锁定目标当前位置并沿预警路径突进；路径每个目标只结算一次，主目标命中后建立猎血第一段。',
} as const;
