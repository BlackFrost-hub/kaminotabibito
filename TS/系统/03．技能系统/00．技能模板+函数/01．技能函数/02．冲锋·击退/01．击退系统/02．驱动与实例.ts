/** @noSelfInFile */
import {
  CENTER_TIMER_TICKS,
  DEFAULT_ATTACK_TYPE,
  DEFAULT_DAMAGE_TYPE,
  DEFAULT_MOVE_EFFECT_MODEL,
  DEFAULT_WEAPON_TYPE,
  TICK_INTERVAL,
  jass,
  位移实例,
  位移结束原因,
  通用位移参数,
  活动位移列表,
  位移映射,
  单位当前位移,
  分配新位移ID,
  取句柄ID,
  单位存活,
  清理命中记录,
  计算每Tick位移,
  单位已被暂停,
  添加单位暂停,
  移除单位暂停,
  单位是否存在其他暂停占用,
  零秒后重置单位动画,
} from "./00．共享";
import { 推进一步 } from "./01．命中与移动";

const { onTick10ms, offTick10ms } = globalThis as unknown as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};

let 已注册到中心计时器 = false;
let tick计数 = 0;

function 注册到中心计时器(): void {
  if (已注册到中心计时器) return;
  已注册到中心计时器 = true;
  onTick10ms(on冲锋击退系统Tick);
}

function 从中心计时器注销(): void {
  if (!已注册到中心计时器) return;
  已注册到中心计时器 = false;
  offTick10ms(on冲锋击退系统Tick);
}

function 尝试收尾中心计时器(): void {
  if (活动位移列表.length !== 0) return;
  tick计数 = 0;
  从中心计时器注销();
}

function 内部移除位移(实例: 位移实例): void {
  const 位移ID = 实例.id;
  const 单位ID = 实例.单位ID;

  delete 位移映射[位移ID];
  if (单位当前位移[单位ID] === 位移ID) {
    delete 单位当前位移[单位ID];
  }
  清理命中记录(位移ID);

  const idx = 实例.listIndex;
  const lastIdx = 活动位移列表.length - 1;
  if (idx !== lastIdx) {
    const last = 活动位移列表[lastIdx];
    活动位移列表[idx] = last;
    last.listIndex = idx;
  }
  活动位移列表.pop();
  尝试收尾中心计时器();
}

export function 结束位移实例(实例: 位移实例, 原因: 位移结束原因, 命中目标?: any): void {
  if (位移映射[实例.id] !== 实例) return;

  const 单位 = 实例.单位;
  const 位移ID = 实例.id;
  const 结束回调 = 实例.结束回调;

  if (实例.禁用碰撞) {
    jass.SetUnitPathing(单位, true);
  }
  if (实例.暂停单位) {
    移除单位暂停(单位, 实例.暂停来源);
  }
  if (单位存活(单位) && 原因 !== "死亡" && 原因 !== "主单位死亡") {
    零秒后重置单位动画(单位);
  }

  内部移除位移(实例);

  if (typeof 结束回调 === "function") {
    结束回调(单位, 原因, 位移ID, 命中目标);
  }
}

export function 结束位移ID(位移ID: number, 原因: 位移结束原因, 命中目标?: any): boolean {
  const 实例 = 位移映射[位移ID];
  if (!实例) return false;
  结束位移实例(实例, 原因, 命中目标);
  return true;
}

export function 停止单位位移(单位: any, 原因: 位移结束原因 = "中断"): boolean {
  const 位移ID = 单位当前位移[取句柄ID(单位)];
  if (!位移ID) return false;
  return 结束位移ID(位移ID, 原因);
}

export function on冲锋击退系统Tick(): void {
  tick计数 += 1;
  if (tick计数 < CENTER_TIMER_TICKS) return;
  tick计数 = 0;

  let i = 0;
  while (i < 活动位移列表.length) {
    const 实例 = 活动位移列表[i];
    if (位移映射[实例.id] !== 实例) {
      i += 1;
      continue;
    }

    if (!单位存活(实例.单位)) {
      结束位移实例(实例, "死亡");
      continue;
    }

    if (实例.主单位死亡时中断 && 实例.主单位 != null && 实例.主单位 !== 0 && !单位存活(实例.主单位)) {
      结束位移实例(实例, "主单位死亡");
      continue;
    }

    if (!实例.暂停单位 && 单位已被暂停(实例.单位)) {
      结束位移实例(实例, "中断");
      continue;
    }
    if (实例.暂停单位 && 单位已被暂停(实例.单位) && 单位是否存在其他暂停占用(实例.单位, 实例.暂停来源)) {
      结束位移实例(实例, "中断");
      continue;
    }

    const 结果 = 推进一步(实例);
    if (结果.停止) {
      结束位移实例(实例, 结果.原因 ?? "完成", 结果.命中目标);
      continue;
    }

    i += 1;
  }
}

export function 创建位移实例(单位: any, 角度: number, 参数: 通用位移参数): number {
  if (!单位存活(单位)) return 0;
  if (参数.距离 == null || 参数.距离 <= 0) return 0;

  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return 0;

  停止单位位移(单位, "中断");

  const 每Tick位移 = 计算每Tick位移(参数.距离, 参数.持续时间, 参数.每秒速度);
  if (每Tick位移 <= 0) return 0;

  const 位移ID = 分配新位移ID();
  const 实例: 位移实例 = {
    id: 位移ID,
    listIndex: 活动位移列表.length,
    单位,
    单位ID,
    主单位: 参数.主单位,
    主单位死亡时中断: 参数.主单位死亡时中断 !== false,
    角度,
    每Tick位移,
    总距离: 参数.距离,
    已移动: 0,
    检查地形: 参数.检查地形 !== false,
    朝向跟随位移: 参数.朝向跟随位移 !== false,
    暂停单位: 参数.暂停单位 !== false,
    禁用碰撞: 参数.禁用碰撞 === true,
    位移特效: 参数.位移特效 ?? DEFAULT_MOVE_EFFECT_MODEL,
    附加位移特效: 参数.附加位移特效 ?? "",
    位移特效缩放: 参数.位移特效缩放 ?? 1,
    位移特效高度: 参数.位移特效高度 ?? 0,
    位移特效持续秒: 参数.位移特效持续秒 ?? 0.3,
    附加位移特效缩放: 参数.附加位移特效缩放 ?? 1,
    附加位移特效高度: 参数.附加位移特效高度 ?? 0,
    附加位移特效持续秒: 参数.附加位移特效持续秒 ?? 0.3,
    命中半径: 参数.命中半径 ?? 0,
    只命中敌人: 参数.只命中敌人 === true,
    允许命中自己: 参数.允许命中自己 === true,
    允许重复命中: 参数.允许重复命中 === true,
    命中后结束: 参数.命中后结束 === true,
    命中伤害: 参数.命中伤害 ?? 0,
    伤害来源: 参数.伤害来源 ?? 单位,
    攻击类型: 参数.攻击类型 ?? DEFAULT_ATTACK_TYPE,
    伤害类型: 参数.伤害类型 ?? DEFAULT_DAMAGE_TYPE,
    武器类型: 参数.武器类型 ?? DEFAULT_WEAPON_TYPE,
    技能伤害标记: 参数.技能伤害标记,
    命中过滤: 参数.命中过滤,
    命中回调: 参数.命中回调,
    撞墙回调: 参数.撞墙回调,
    结束回调: 参数.结束回调,
    暂停来源: `击退系统:${位移ID}`,
  };

  位移映射[位移ID] = 实例;
  单位当前位移[单位ID] = 位移ID;
  活动位移列表.push(实例);
  if (实例.禁用碰撞) {
    jass.SetUnitPathing(单位, false);
  }
  if (实例.暂停单位) {
    添加单位暂停(单位, 实例.暂停来源);
  }
  注册到中心计时器();

  if (typeof 参数.开始回调 === "function") {
    参数.开始回调(单位, 位移ID);
  }

  return 位移ID;
}
