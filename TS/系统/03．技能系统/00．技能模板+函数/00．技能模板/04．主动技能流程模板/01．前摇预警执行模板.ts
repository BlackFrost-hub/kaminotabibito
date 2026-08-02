/** @noSelfInFile */
/**
 * 主动技能流程：前摇预警执行模板
 *
 * 适用：
 * - 主动技能常见流程：转向 -> 前摇/读条/动作 -> 地面预警 -> 真正执行。
 * - 这里只负责流程编排，不负责具体伤害、弹幕、召唤、Buff 结算。
 */

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;

const { Atan2BJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  Atan2BJ: (this: void, y: number, x: number) => number;
};

import {
  开始技能阶段链,
  停止技能阶段链,
  创建前摇阶段,
  创建立即执行阶段,
  type 技能阶段链结束原因,
  type 技能阶段链上下文,
} from "../01．多阶段技能编排/index";
import type { 技能前摇参数 } from "../01．多阶段技能编排/index";
import { 创建技能提示圈, type 技能提示圈配置 } from "../../02．通用函数/16．技能提示圈工厂";
import type { 机制清理篮子 } from "../../04．机制组件/06．机制清理/01．机制清理篮子";
import {
  创建主动技能流程生命周期,
  type 主动技能流程控制器,
  type 主动技能流程结束原因,
} from "./00．流程生命周期";

export interface 主动技能流程模板上下文 {
  阶段链ID: number;
  施法者: any;
  目标?: any;
  目标X: number;
  目标Y: number;
  朝向: number;
  数据: Record<string, any>;
}

export interface 主动技能流程模板参数 {
  名称?: string;
  施法者: any;
  目标?: any;
  目标X?: number;
  目标Y?: number;
  朝向?: number;
  数据?: Record<string, any>;
  清理?: 机制清理篮子;
  施法者死亡时取消?: boolean;
  目标失效时取消?: boolean;
  /** 默认 true。会在前摇前面向目标/目标点。 */
  自动面向?: boolean;
  前摇?: 技能前摇参数;
  提示圈?: 技能提示圈配置 | false | ((this: void, 上下文: 主动技能流程模板上下文) => 技能提示圈配置 | false);
  执行: (this: void, 上下文: 主动技能流程模板上下文) => void;
  结束回调?: (this: void, 上下文: 主动技能流程模板上下文, 原因: 主动技能流程结束原因) => void;
}

export interface 主动技能流程模板实例 extends 主动技能流程控制器 {
  阶段链ID: number;
}

function 取目标点(this: void, 参数: 主动技能流程模板参数): { x: number; y: number } {
  const 目标 = 参数.目标;
  if (目标 != null && 目标 !== 0) {
    return { x: GetUnitX(目标), y: GetUnitY(目标) };
  }
  if (参数.目标X != null && 参数.目标Y != null) {
    return { x: 参数.目标X, y: 参数.目标Y };
  }
  return { x: GetUnitX(参数.施法者), y: GetUnitY(参数.施法者) };
}

function 取朝向(this: void, 参数: 主动技能流程模板参数, 目标X: number, 目标Y: number): number {
  if (参数.朝向 != null) return 参数.朝向;
  const 施法者X = GetUnitX(参数.施法者);
  const 施法者Y = GetUnitY(参数.施法者);
  if (施法者X === 目标X && 施法者Y === 目标Y) {
    return GetUnitFacing(参数.施法者);
  }
  return Atan2BJ(目标Y - 施法者Y, 目标X - 施法者X);
}

function 创建模板上下文(this: void, 参数: 主动技能流程模板参数, 阶段链上下文: 技能阶段链上下文): 主动技能流程模板上下文 {
  const 点 = 取目标点(参数);
  const 朝向 = 取朝向(参数, 点.x, 点.y);
  return {
    阶段链ID: 阶段链上下文.阶段链ID,
    施法者: 参数.施法者,
    目标: 参数.目标,
    目标X: 点.x,
    目标Y: 点.y,
    朝向,
    数据: 阶段链上下文.数据,
  };
}

function 创建预览上下文(this: void, 参数: 主动技能流程模板参数): 主动技能流程模板上下文 {
  const 点 = 取目标点(参数);
  const 朝向 = 取朝向(参数, 点.x, 点.y);
  return {
    阶段链ID: 0,
    施法者: 参数.施法者,
    目标: 参数.目标,
    目标X: 点.x,
    目标Y: 点.y,
    朝向,
    数据: 参数.数据 ?? {},
  };
}

function 创建生命周期结束上下文(
  this: void,
  参数: 主动技能流程模板参数,
  阶段链ID: number,
  阶段链上下文?: 技能阶段链上下文,
): 主动技能流程模板上下文 {
  if (阶段链上下文 != null) return 创建模板上下文(参数, 阶段链上下文);
  const 上下文 = 创建预览上下文(参数);
  上下文.阶段链ID = 阶段链ID;
  return 上下文;
}

function 转换阶段链结束原因(this: void, 原因: 主动技能流程结束原因): 技能阶段链结束原因 {
  if (原因 === "目标失效" || 原因 === "清理") return "中断";
  return 原因;
}

function 创建提示圈阶段参数(this: void, 参数: 主动技能流程模板参数): 技能前摇参数 {
  const 原前摇 = 参数.前摇 ?? { 持续时间: 0 };
  const 原创建提示特效 = 原前摇.创建提示特效;
  const 模板前摇: 技能前摇参数 = { ...原前摇 };
  模板前摇.创建提示特效 = function 主动技能流程模板创建提示(this: void, 单位: any, 前摇ID: number): any {
    const 原结果 = 原创建提示特效 != null ? 原创建提示特效(单位, 前摇ID) : null;
    const 提示圈 = 参数.提示圈;
    if (提示圈 !== false && 提示圈 != null) {
      const 上下文 = 创建预览上下文(参数);
      const 配置 = typeof 提示圈 === "function" ? 提示圈(上下文) : 提示圈;
      if (配置 !== false) {
        创建技能提示圈({
          ...配置,
          X: 配置.X ?? 配置.x ?? 上下文.目标X,
          Y: 配置.Y ?? 配置.y ?? 上下文.目标Y,
          朝向: 配置.朝向 ?? 配置.方向角 ?? 上下文.朝向,
          来源单位: 配置.来源单位 ?? 参数.施法者,
          持续时间: 配置.持续时间 ?? 原前摇.持续时间,
        });
      }
    }
    return 原结果;
  };
  return 模板前摇;
}

export function 开始主动技能前摇预警执行模板(this: void, 参数: 主动技能流程模板参数): 主动技能流程模板实例 {
  const 阶段列表 = [];
  let 阶段链ID = 0;
  let 最后阶段上下文: 技能阶段链上下文 | undefined;

  const 生命周期 = 创建主动技能流程生命周期({
    名称: 参数.名称 ?? "主动技能流程",
    施法者: 参数.施法者,
    目标: 参数.目标,
    清理: 参数.清理,
    施法者死亡时取消: 参数.施法者死亡时取消,
    目标死亡时取消: 参数.目标失效时取消 !== false && 参数.目标 != null && 参数.目标 !== 0,
    on停止: function 主动技能流程生命周期停止(this: void, 原因: 主动技能流程结束原因): void {
      if (阶段链ID !== 0) 停止技能阶段链(阶段链ID, 转换阶段链结束原因(原因));
    },
    on结束: function 主动技能流程生命周期结束(this: void, 原因: 主动技能流程结束原因): void {
      if (参数.结束回调 != null) {
        参数.结束回调(创建生命周期结束上下文(参数, 阶段链ID, 最后阶段上下文), 原因);
      }
    },
  });

  if (生命周期.是否结束()) {
    return {
      阶段链ID: 0,
      停止: function 主动技能流程无阶段停止(this: void, 原因?: 主动技能流程结束原因): boolean {
        return 生命周期.停止(原因);
      },
      结束: function 主动技能流程无阶段结束(this: void, 原因: 主动技能流程结束原因): boolean {
        return 生命周期.结束(原因);
      },
      完成: function 主动技能流程无阶段完成(this: void): boolean {
        return 生命周期.完成();
      },
      是否结束: function 主动技能流程无阶段是否结束(this: void): boolean {
        return 生命周期.是否结束();
      },
      读取结束原因: function 主动技能流程无阶段读取结束原因(this: void): 主动技能流程结束原因 | undefined {
        return 生命周期.读取结束原因();
      },
    };
  }

  if (参数.自动面向 !== false) {
    阶段列表.push(创建立即执行阶段(function 主动技能流程模板面向阶段(this: void, 阶段上下文): void {
      const 上下文 = 创建模板上下文(参数, 阶段上下文);
      SetUnitFacing(参数.施法者, 上下文.朝向);
    }, "面向目标"));
  }

  if (参数.前摇 != null) {
    阶段列表.push(创建前摇阶段(创建提示圈阶段参数(参数)));
  }

  阶段列表.push(创建立即执行阶段(function 主动技能流程模板执行阶段(this: void, 阶段上下文): void {
    参数.执行(创建模板上下文(参数, 阶段上下文));
  }, "执行"));

  const 启动阶段链ID = 开始技能阶段链(参数.施法者, 阶段列表, {
    数据: 参数.数据,
    结束回调: function 主动技能流程模板结束(this: void, _单位: any, 原因: 技能阶段链结束原因, 回调阶段链ID: number, 阶段上下文: 技能阶段链上下文): void {
      阶段链ID = 回调阶段链ID;
      最后阶段上下文 = 阶段上下文;
      生命周期.结束(原因);
    },
  });
  if (阶段链ID === 0) 阶段链ID = 启动阶段链ID;

  return {
    阶段链ID,
    停止: function 主动技能流程模板停止(this: void, 原因?: 主动技能流程结束原因): boolean {
      return 生命周期.停止(原因);
    },
    结束: function 主动技能流程模板结束控制(this: void, 原因: 主动技能流程结束原因): boolean {
      return 生命周期.结束(原因);
    },
    完成: function 主动技能流程模板完成(this: void): boolean {
      return 生命周期.完成();
    },
    是否结束: function 主动技能流程模板是否结束(this: void): boolean {
      return 生命周期.是否结束();
    },
    读取结束原因: function 主动技能流程模板读取结束原因(this: void): 主动技能流程结束原因 | undefined {
      return 生命周期.读取结束原因();
    },
  };
}
