/** @noSelfInFile */
/**
 * 点名技能：预警结算模板
 *
 * 说明：
 * - 只负责把一名或多名目标注册为“点名 -> 预警 -> 延迟结算”。
 * - 目标怎么选、伤害怎么结算、是否分摊，都由调用方或更底层技能函数决定。
 */

import {
  创建点名预警执行器,
  type 点名预警执行结果,
  type 点名预警执行器,
} from "../../04．机制组件/10．复杂战斗通用机制/05．点名预警执行器";
import type { 技能提示圈配置 } from "../../02．通用函数/16．技能提示圈工厂";
import type { 机制清理篮子 } from "../../04．机制组件/06．机制清理/01．机制清理篮子";

export interface 点名预警结算模板参数 {
  名称: string;
  施法者?: any;
  清理?: 机制清理篮子;
  目标?: any;
  目标列表?: any[];
  延迟秒: number;
  锁定坐标?: boolean;
  提示圈?: 技能提示圈配置 | false | ((this: void, 结果: 点名预警执行结果, 序号: number) => 技能提示圈配置 | false);
  on锁定?: (this: void, 结果: 点名预警执行结果, 序号: number) => void;
  on结算: (this: void, 结果: 点名预警执行结果, 序号: number) => void;
  on全部结算完成?: (this: void) => void;
  on取消?: (this: void) => void;
}

export interface 点名预警结算模板实例 {
  数量: number;
  取消(this: void): void;
}

function 取点名目标列表(this: void, 参数: 点名预警结算模板参数): any[] {
  if (参数.目标列表 != null) {
    return 参数.目标列表;
  }
  if (参数.目标 != null && 参数.目标 !== 0) {
    return [参数.目标];
  }
  return [];
}

export function 开始点名预警结算模板(this: void, 参数: 点名预警结算模板参数): 点名预警结算模板实例 {
  const 目标列表 = 取点名目标列表(参数);
  const 执行器列表: 点名预警执行器[] = [];
  let 剩余结算数量 = 目标列表.length;
  let 已取消 = false;

  if (目标列表.length <= 0) {
    if (参数.on全部结算完成 != null) 参数.on全部结算完成();
    return {
      数量: 0,
      取消: function 点名预警空实例取消(this: void): void {},
    };
  }

  for (let i = 0; i < 目标列表.length; i++) {
    const 序号 = i + 1;
    const 目标 = 目标列表[i];
    if (目标 == null || 目标 === 0) {
      剩余结算数量 -= 1;
      continue;
    }

    const 原提示圈 = 参数.提示圈;
    const 执行器 = 创建点名预警执行器({
      清理: 参数.清理,
      名称: `${参数.名称}${序号}`,
      目标,
      延迟秒: 参数.延迟秒,
      锁定坐标: 参数.锁定坐标,
      提示圈: 原提示圈 == null || 原提示圈 === false
        ? 原提示圈
        : function 点名预警模板提示圈(this: void, 结果: 点名预警执行结果): 技能提示圈配置 | false {
          return typeof 原提示圈 === "function" ? 原提示圈(结果, 序号) : 原提示圈;
        },
      on锁定: function 点名预警模板锁定(this: void, 结果: 点名预警执行结果): void {
        if (参数.on锁定 != null) 参数.on锁定(结果, 序号);
      },
      on结算: function 点名预警模板结算(this: void, 结果: 点名预警执行结果): void {
        参数.on结算(结果, 序号);
        剩余结算数量 -= 1;
        if (剩余结算数量 <= 0 && 参数.on全部结算完成 != null) {
          参数.on全部结算完成();
        }
      },
      on取消: function 点名预警模板取消(this: void): void {
        if (!已取消 && 参数.on取消 != null) {
          参数.on取消();
        }
      },
    });
    执行器列表.push(执行器);
  }

  return {
    数量: 执行器列表.length,
    取消: function 点名预警结算模板取消(this: void): void {
      if (已取消) return;
      已取消 = true;
      for (const 执行器 of 执行器列表) {
        执行器.取消();
      }
      if (参数.on取消 != null) {
        参数.on取消();
      }
    },
  };
}
