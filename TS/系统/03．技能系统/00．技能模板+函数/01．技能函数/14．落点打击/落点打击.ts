/** @noSelfInFile */
/**
 * 落点打击模板
 *
 * 说明：
 * 1. 用于“延迟后在指定点生效”的技能模板，例如落雷、陨石、延迟爆点。
 * 2. 支持多段落点、随机散布、提示半径与伤害半径分离。
 * 3. 当前版本不做取消接口，主打快速复用。
 */

const jass = require("jass.common") as any;

const AddSpecialEffect = jass.AddSpecialEffect as (path: string, x: number, y: number) => any;
const CreateTimer = jass.CreateTimer as () => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any, target: any, amount: number,
  attack: boolean, ranged: boolean,
  attackType: any, damageType: any, weaponType: any
) => boolean;

const {
  safeTimerStart,
  safeDestroyTimer,
} = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};

const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const { 创建渐变圆形提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效") as {
  创建渐变圆形提示圈: (this: void, x: number, y: number, r: number, time: number, speed?: number) => any;
};

const 默认落雷特效 = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl";
const 默认攻击类型 = jass.ATTACK_TYPE_NORMAL;
const 默认伤害类型 = jass.DAMAGE_TYPE_NORMAL;
const 默认武器类型 = jass.WEAPON_TYPE_WHOKNOWS;

interface 落点信息 {
  X: number;
  Y: number;
  触发延迟: number;
}

interface 落点打击内部实例 {
  id: number;
  参数: 落点打击参数;
  落点列表: 落点信息[];
  剩余落点数: number;
  单位命中次数: Record<number, number | undefined>;
}

interface 落点打击定时器上下文 {
  实例ID: number;
  落点序号: number;
}

export interface 落点打击参数 {
  X: number;
  Y: number;
  延迟时间: number;
  伤害半径: number;
  提示半径?: number;
  伤害值?: number;
  所有者?: any;
  影响目标?: "敌方" | "友方" | "全部";
  落点数量?: number;
  落点间隔?: number;
  随机区域形状?: "圆形" | "矩形";
  随机散布半径?: number;
  随机矩形长度?: number;
  随机矩形宽度?: number;
  随机区域方向角?: number;
  最小落点间距?: number;
  随机取点最大尝试次数?: number;
  每单位最大命中次数?: number;
  提示特效启用?: boolean;
  提示特效动画速度?: number;
  落点特效模型?: string;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
  on单次命中?: (this: void, 单位: any, 落点序号: number, 实例ID: number) => void;
  on单次生效?: (this: void, X: number, Y: number, 落点序号: number, 实例ID: number) => void;
  on全部完成?: (this: void, 实例ID: number) => void;
}

const 落点打击实例表: Record<number, 落点打击内部实例 | undefined> = {};
const 落点打击定时器上下文表: Record<number, 落点打击定时器上下文 | undefined> = {};
let 下一个落点打击ID = 0;

function 取句柄ID(h: any): number {
  if (h == null || h === 0) {
    return 0;
  }
  return GetHandleId(h) || 0;
}

function 单位是否受影响(目标单位: any, 参数: 落点打击参数): boolean {
  const 影响目标 = 参数.影响目标 ?? "敌方";
  const 所有者 = 参数.所有者;

  if (影响目标 === "全部") {
    return true;
  }
  if (所有者 == null || 所有者 === 0) {
    return true;
  }
  if (影响目标 === "敌方") {
    return isUnitEnemy(目标单位, 所有者);
  }
  return isUnitAlly(目标单位, 所有者);
}

function 单位是否还能命中(实例: 落点打击内部实例, 单位: any): boolean {
  const 最大命中次数 = 实例.参数.每单位最大命中次数;
  if (最大命中次数 == null || 最大命中次数 <= 0) {
    return true;
  }

  const 单位ID = 取句柄ID(单位);
  if (单位ID <= 0) {
    return true;
  }

  return (实例.单位命中次数[单位ID] ?? 0) < 最大命中次数;
}

function 记录单位命中次数(实例: 落点打击内部实例, 单位: any): void {
  const 单位ID = 取句柄ID(单位);
  if (单位ID <= 0) {
    return;
  }
  实例.单位命中次数[单位ID] = (实例.单位命中次数[单位ID] ?? 0) + 1;
}

function 计算两点距离平方(ax: number, ay: number, bx: number, by: number): number {
  const dx = ax - bx;
  const dy = ay - by;
  return dx * dx + dy * dy;
}

function 计算落点最小间距(参数: 落点打击参数): number {
  if (参数.最小落点间距 != null && 参数.最小落点间距 > 0) {
    return 参数.最小落点间距;
  }
  if ((参数.落点数量 ?? 1) <= 1) {
    return 0;
  }
  if (参数.伤害半径 <= 0) {
    return 0;
  }
  // 默认只做轻度打散：允许重叠，但降低多个落点高概率贴脸扎堆的情况。
  return 参数.伤害半径 * 0.45;
}

function 计算候选点到已有落点的最小距离平方(已有落点: 落点信息[], 候选X: number, 候选Y: number): number {
  if (已有落点.length <= 0) {
    return 999999999;
  }

  let 最小距离平方 = 999999999;
  for (const 已有落点信息 of 已有落点) {
    const 距离平方 = 计算两点距离平方(候选X, 候选Y, 已有落点信息.X, 已有落点信息.Y);
    if (距离平方 < 最小距离平方) {
      最小距离平方 = 距离平方;
    }
  }
  return 最小距离平方;
}

function 生成随机候选落点(中心X: number, 中心Y: number, 散布半径: number, 触发延迟: number): 落点信息 {
  if (散布半径 <= 0) {
    return { X: 中心X, Y: 中心Y, 触发延迟 };
  }

  while (true) {
    const 偏移X = GetRandomReal(-散布半径, 散布半径);
    const 偏移Y = GetRandomReal(-散布半径, 散布半径);
    if (偏移X * 偏移X + 偏移Y * 偏移Y > 散布半径 * 散布半径) {
      continue;
    }
    return {
      X: 中心X + 偏移X,
      Y: 中心Y + 偏移Y,
      触发延迟,
    };
  }
}

function 生成随机矩形候选落点(中心X: number, 中心Y: number, 长度: number, 宽度: number, 方向角: number, 触发延迟: number): 落点信息 {
  if (长度 <= 0 || 宽度 <= 0) {
    return { X: 中心X, Y: 中心Y, 触发延迟 };
  }

  const 前后偏移 = GetRandomReal(-长度 * 0.5, 长度 * 0.5);
  const 左右偏移 = GetRandomReal(-宽度 * 0.5, 宽度 * 0.5);
  const 前向X = CosBJ(方向角);
  const 前向Y = SinBJ(方向角);
  const 右向X = CosBJ(方向角 - 90);
  const 右向Y = SinBJ(方向角 - 90);
  return {
    X: 中心X + 前向X * 前后偏移 + 右向X * 左右偏移,
    Y: 中心Y + 前向Y * 前后偏移 + 右向Y * 左右偏移,
    触发延迟,
  };
}

function 生成单个落点(参数: 落点打击参数, 已有落点: 落点信息[], 触发延迟: number): 落点信息 {
  const 随机区域形状 = 参数.随机区域形状 ?? "圆形";
  const 散布半径 = 参数.随机散布半径 != null && 参数.随机散布半径 > 0 ? 参数.随机散布半径 : 0;
  const 矩形长度 = 参数.随机矩形长度 != null && 参数.随机矩形长度 > 0 ? 参数.随机矩形长度 : 0;
  const 矩形宽度 = 参数.随机矩形宽度 != null && 参数.随机矩形宽度 > 0 ? 参数.随机矩形宽度 : 0;
  const 方向角 = 参数.随机区域方向角 ?? 0;

  if (随机区域形状 === "矩形") {
    if (矩形长度 <= 0 || 矩形宽度 <= 0) {
      return { X: 参数.X, Y: 参数.Y, 触发延迟 };
    }
  } else if (散布半径 <= 0) {
    return { X: 参数.X, Y: 参数.Y, 触发延迟 };
  }

  const 最小落点间距 = 计算落点最小间距(参数);
  const 最小落点间距平方 = 最小落点间距 * 最小落点间距;
  const 最大尝试次数 = 参数.随机取点最大尝试次数 != null && 参数.随机取点最大尝试次数 > 0
    ? 参数.随机取点最大尝试次数
    : 32;

  let 最佳候选 = 随机区域形状 === "矩形"
    ? 生成随机矩形候选落点(参数.X, 参数.Y, 矩形长度, 矩形宽度, 方向角, 触发延迟)
    : 生成随机候选落点(参数.X, 参数.Y, 散布半径, 触发延迟);
  let 最佳候选最小距离平方 = 计算候选点到已有落点的最小距离平方(已有落点, 最佳候选.X, 最佳候选.Y);

  let i = 1;
  while (i < 最大尝试次数) {
    const 候选 = 随机区域形状 === "矩形"
      ? 生成随机矩形候选落点(参数.X, 参数.Y, 矩形长度, 矩形宽度, 方向角, 触发延迟)
      : 生成随机候选落点(参数.X, 参数.Y, 散布半径, 触发延迟);
    const 候选最小距离平方 = 计算候选点到已有落点的最小距离平方(已有落点, 候选.X, 候选.Y);
    if (候选最小距离平方 >= 最小落点间距平方) {
      return 候选;
    }
    if (候选最小距离平方 > 最佳候选最小距离平方) {
      最佳候选 = 候选;
      最佳候选最小距离平方 = 候选最小距离平方;
    }
    i += 1;
  }

  return 最佳候选;
}

function 取落点与其他点的最小距离平方(落点列表: 落点信息[], 序号: number): number {
  const 当前落点 = 落点列表[序号];
  if (当前落点 == null) {
    return 0;
  }

  let 最小距离平方 = 999999999;
  let i = 0;
  while (i < 落点列表.length) {
    if (i !== 序号) {
      const 其他落点 = 落点列表[i];
      if (其他落点 != null) {
        const 距离平方 = 计算两点距离平方(当前落点.X, 当前落点.Y, 其他落点.X, 其他落点.Y);
        if (距离平方 < 最小距离平方) {
          最小距离平方 = 距离平方;
        }
      }
    }
    i += 1;
  }

  return 最小距离平方;
}

function 轻度打散落点列表(参数: 落点打击参数, 落点列表: 落点信息[]): void {
  if (落点列表.length <= 2) {
    return;
  }

  const 最小落点间距 = 计算落点最小间距(参数);
  if (最小落点间距 <= 0) {
    return;
  }

  const 目标距离平方 = 最小落点间距 * 最小落点间距;
  const 总轮数 = 2;
  const 单点重抽次数 = 8;

  let 轮次 = 0;
  while (轮次 < 总轮数) {
    let 最挤序号 = -1;
    let 最挤距离平方 = 999999999;

    let i = 0;
    while (i < 落点列表.length) {
      const 当前最小距离平方 = 取落点与其他点的最小距离平方(落点列表, i);
      if (当前最小距离平方 < 最挤距离平方) {
        最挤距离平方 = 当前最小距离平方;
        最挤序号 = i;
      }
      i += 1;
    }

    if (最挤序号 < 0 || 最挤距离平方 >= 目标距离平方) {
      return;
    }

    const 当前落点 = 落点列表[最挤序号];
    if (当前落点 == null) {
      return;
    }

    const 其他落点 = 落点列表.filter((_: 落点信息, 索引: number) => 索引 !== 最挤序号);
    let 最佳候选 = 当前落点;
    let 最佳候选距离平方 = 最挤距离平方;

    let j = 0;
    while (j < 单点重抽次数) {
      const 候选 = 生成单个落点(参数, 其他落点, 当前落点.触发延迟);
      const 候选距离平方 = 计算候选点到已有落点的最小距离平方(其他落点, 候选.X, 候选.Y);
      if (候选距离平方 > 最佳候选距离平方) {
        最佳候选 = 候选;
        最佳候选距离平方 = 候选距离平方;
        if (候选距离平方 >= 目标距离平方) {
          break;
        }
      }
      j += 1;
    }

    落点列表[最挤序号] = 最佳候选;
    轮次 += 1;
  }
}

function 创建落点列表(参数: 落点打击参数): 落点信息[] {
  const 落点数量 = 参数.落点数量 != null && 参数.落点数量 > 0 ? 参数.落点数量 : 1;
  const 落点间隔 = 参数.落点间隔 != null && 参数.落点间隔 > 0 ? 参数.落点间隔 : 0;
  const 结果: 落点信息[] = [];

  let i = 0;
  while (i < 落点数量) {
    结果.push(生成单个落点(参数, 结果, 参数.延迟时间 + i * 落点间隔));
    i += 1;
  }

  轻度打散落点列表(参数, 结果);
  return 结果;
}

function 创建落点提示特效(参数: 落点打击参数, 落点: 落点信息): void {
  if (参数.提示特效启用 === false) {
    return;
  }

  const 提示半径 = 参数.提示半径 ?? 参数.伤害半径;
  if (提示半径 <= 0 || 落点.触发延迟 <= 0) {
    return;
  }

  创建渐变圆形提示圈(
    落点.X,
    落点.Y,
    提示半径,
    落点.触发延迟,
    参数.提示特效动画速度
  );
}

function 创建落点命中特效(参数: 落点打击参数, X: number, Y: number): void {
  const 模型路径 = 参数.落点特效模型 ?? 默认落雷特效;
  const 特效 = AddSpecialEffect(模型路径, X, Y);
  if (特效 != null && 特效 !== 0) {
    DestroyEffect(特效);
  }
}

function 结算单次落点伤害(实例: 落点打击内部实例, 落点序号: number): void {
  const 落点 = 实例.落点列表[落点序号];
  if (落点 == null) {
    return;
  }

  创建落点命中特效(实例.参数, 落点.X, 落点.Y);
  实例.参数.on单次生效?.(落点.X, 落点.Y, 落点序号 + 1, 实例.id);

  const 伤害值 = 实例.参数.伤害值 ?? 0;
  if (伤害值 > 0 && 实例.参数.伤害半径 > 0) {
    const 单位列表 = getUnitsInRange(落点.X, 落点.Y, 实例.参数.伤害半径);
    for (const 单位 of 单位列表) {
      if (!单位是否受影响(单位, 实例.参数)) {
        continue;
      }
      if (!单位是否还能命中(实例, 单位)) {
        continue;
      }

      UnitDamageTarget(
        实例.参数.所有者 ?? 单位,
        单位,
        伤害值,
        false,
        false,
        实例.参数.攻击类型 ?? 默认攻击类型,
        实例.参数.伤害类型 ?? 默认伤害类型,
        实例.参数.武器类型 ?? 默认武器类型
      );
      记录单位命中次数(实例, 单位);
      实例.参数.on单次命中?.(单位, 落点序号 + 1, 实例.id);
    }
  }
}

function 结束落点打击实例(实例ID: number): void {
  const 实例 = 落点打击实例表[实例ID];
  if (实例 == null) {
    return;
  }

  delete 落点打击实例表[实例ID];
  实例.参数.on全部完成?.(实例ID);
}

function on落点打击定时器到时(): void {
  const t = GetExpiredTimer();
  if (!t) {
    return;
  }

  const 定时器ID = 取句柄ID(t);
  const 上下文 = 落点打击定时器上下文表[定时器ID];
  delete 落点打击定时器上下文表[定时器ID];
  safeDestroyTimer(t);

  if (上下文 == null) {
    return;
  }

  const 实例 = 落点打击实例表[上下文.实例ID];
  if (实例 == null) {
    return;
  }

  结算单次落点伤害(实例, 上下文.落点序号);
  实例.剩余落点数 -= 1;
  if (实例.剩余落点数 <= 0) {
    结束落点打击实例(实例.id);
  }
}

function 启动单个落点计时器(实例ID: number, 落点序号: number, 延迟: number): void {
  const t = CreateTimer();
  if (!t) {
    return;
  }

  落点打击定时器上下文表[取句柄ID(t)] = {
    实例ID,
    落点序号,
  };
  safeTimerStart(t, 延迟, false, on落点打击定时器到时);
}

export function 创建落点打击(参数: 落点打击参数): number {
  if (参数.伤害半径 <= 0) {
    return 0;
  }

  const 落点列表 = 创建落点列表(参数);
  if (落点列表.length <= 0) {
    return 0;
  }

  const 实例ID = 下一个落点打击ID + 1;
  下一个落点打击ID = 实例ID;

  const 实例: 落点打击内部实例 = {
    id: 实例ID,
    参数,
    落点列表,
    剩余落点数: 落点列表.length,
    单位命中次数: {},
  };
  落点打击实例表[实例ID] = 实例;

  let i = 0;
  while (i < 落点列表.length) {
    const 落点 = 落点列表[i];
    创建落点提示特效(参数, 落点);
    启动单个落点计时器(实例ID, i, 落点.触发延迟 > 0 ? 落点.触发延迟 : 0);
    i += 1;
  }

  return 实例ID;
}
