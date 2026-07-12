/** @noSelfInFile */

import type { 机制清理篮子 } from "../../04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建技能互斥锁, type 技能互斥锁 } from "../../04．机制组件/10．复杂战斗通用机制/18．技能互斥锁";
import type {
  可抢占状态结束事件,
  可抢占独占状态管理器,
} from "../../04．机制组件/10．复杂战斗通用机制/19．可抢占独占状态";
import {
  开始技能阶段链,
  停止技能阶段链,
  type 技能阶段定义,
  type 技能阶段链结束原因,
  type 技能阶段链上下文,
} from "../01．多阶段技能编排/06．技能阶段链执行器";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

export interface 固定组合技能执行器参数<TContext> {
  名称: string;
  清理?: 机制清理篮子;
  互斥锁?: 技能互斥锁;
  互斥组?: string;
  独占状态管理器?: 可抢占独占状态管理器;
  默认独占优先级?: number;
  取当前时间?: (this: void) => number;
}

export interface 固定组合技能启动参数<TContext> {
  key: string;
  单位: any;
  上下文: TContext;
  阶段列表: 技能阶段定义[];
  最大持续毫秒: number;
  互斥组?: string;
  数据?: Record<string, any>;
  独占优先级?: number;
  独占状态可被抢占?: boolean;
  结束回调?: (this: void, event: 固定组合技能结束事件<TContext>) => void;
}

export interface 固定组合技能运行快照<TContext> {
  执行ID: number;
  key: string;
  单位: any;
  上下文: TContext;
  阶段链ID: number;
  互斥组: string;
  开始毫秒: number;
  最大持续毫秒: number;
  数据: Record<string, any>;
}

export interface 固定组合技能结束事件<TContext> extends 固定组合技能运行快照<TContext> {
  原因: 技能阶段链结束原因;
  阶段上下文?: 技能阶段链上下文;
}

export interface 固定组合技能执行器<TContext> {
  开始(参数: 固定组合技能启动参数<TContext>, nowMs?: number): number;
  停止(执行ID?: number, 原因?: 技能阶段链结束原因): boolean;
  是否运行中(): boolean;
  取当前(): 固定组合技能运行快照<TContext> | undefined;
  取互斥锁(): 技能互斥锁;
}

interface 固定组合技能运行时<TContext> extends 固定组合技能运行快照<TContext> {
  互斥占用者: string;
  独占Token: number;
  已结束: boolean;
  结束回调?: (this: void, event: 固定组合技能结束事件<TContext>) => void;
}

class 固定组合技能执行器实现<TContext> implements 固定组合技能执行器<TContext> {
  private 参数: 固定组合技能执行器参数<TContext>;
  private 互斥锁: 技能互斥锁;
  private 取当前时间: (this: void) => number;
  private 当前?: 固定组合技能运行时<TContext>;
  private 下一个执行ID = 0;

  constructor(参数: 固定组合技能执行器参数<TContext>) {
    this.参数 = 参数;
    this.取当前时间 = 参数.取当前时间 ?? getServerTime;
    this.互斥锁 = 参数.互斥锁 ?? 创建技能互斥锁({
      名称: 参数.名称 + "-固定组合",
      清理: 参数.清理,
      取当前时间: 参数.取当前时间,
    });

    if (参数.清理 != null) {
      const self = this;
      参数.清理.登记清理(参数.名称 + "-固定组合执行器", function 固定组合执行器清理(this: void): void {
        self.停止(undefined, "中断");
      });
    }
  }

  开始(启动参数: 固定组合技能启动参数<TContext>, nowMs?: number): number {
    if (this.当前 != null || 启动参数.key === "" || 启动参数.阶段列表.length <= 0 || 启动参数.最大持续毫秒 <= 0) return 0;

    const now = nowMs == null ? this.取当前时间() : nowMs;
    const 执行ID = ++this.下一个执行ID;
    const 互斥组 = 启动参数.互斥组 ?? this.参数.互斥组 ?? this.参数.名称;
    const 互斥占用者 = this.参数.名称 + ":" + String(执行ID) + ":" + 启动参数.key;
    if (!this.互斥锁.尝试占用(互斥组, 互斥占用者, 启动参数.最大持续毫秒, now)) return 0;

    let 独占Token = 0;
    const 独占状态管理器 = this.参数.独占状态管理器;
    if (独占状态管理器 != null) {
      const self = this;
      独占Token = 独占状态管理器.开始({
        key: 互斥占用者,
        优先级: 启动参数.独占优先级 ?? this.参数.默认独占优先级 ?? 100,
        持续毫秒: 启动参数.最大持续毫秒,
        可被抢占: 启动参数.独占状态可被抢占 === true,
        on结束: function 固定组合独占状态结束(this: void, _event: 可抢占状态结束事件): void {
          const 当前 = self.当前;
          if (当前 != null && 当前.执行ID === 执行ID && !当前.已结束) self.停止(执行ID, "中断");
        },
      }, now);
      if (独占Token === 0) {
        this.互斥锁.释放(互斥组, 互斥占用者);
        return 0;
      }
    }

    const 数据: Record<string, any> = {
      ...(启动参数.数据 ?? {}),
      固定组合执行ID: 执行ID,
      固定组合Key: 启动参数.key,
      固定组合上下文: 启动参数.上下文,
    };
    const 运行时: 固定组合技能运行时<TContext> = {
      执行ID,
      key: 启动参数.key,
      单位: 启动参数.单位,
      上下文: 启动参数.上下文,
      阶段链ID: 0,
      互斥组,
      开始毫秒: now,
      最大持续毫秒: 启动参数.最大持续毫秒,
      数据,
      互斥占用者,
      独占Token,
      已结束: false,
      结束回调: 启动参数.结束回调,
    };
    this.当前 = 运行时;

    const self = this;
    const 阶段链ID = 开始技能阶段链(启动参数.单位, 启动参数.阶段列表, {
      数据,
      结束回调: function 固定组合阶段链结束(
        this: void,
        _单位: any,
        原因: 技能阶段链结束原因,
        回调阶段链ID: number,
        阶段上下文: 技能阶段链上下文,
      ): void {
        运行时.阶段链ID = 回调阶段链ID;
        self.完成运行时(运行时, 原因, 阶段上下文);
      },
    });
    运行时.阶段链ID = 阶段链ID;
    if (阶段链ID === 0 && !运行时.已结束) this.完成运行时(运行时, "中断");
    return 执行ID;
  }

  停止(执行ID?: number, 原因: 技能阶段链结束原因 = "中断"): boolean {
    const 当前 = this.当前;
    if (当前 == null || 当前.已结束) return false;
    if (执行ID != null && 执行ID !== 0 && 当前.执行ID !== 执行ID) return false;
    if (当前.阶段链ID !== 0 && 停止技能阶段链(当前.阶段链ID, 原因)) return true;
    this.完成运行时(当前, 原因);
    return true;
  }

  是否运行中(): boolean {
    return this.当前 != null && !this.当前.已结束;
  }

  取当前(): 固定组合技能运行快照<TContext> | undefined {
    return this.当前;
  }

  取互斥锁(): 技能互斥锁 {
    return this.互斥锁;
  }

  private 完成运行时(
    运行时: 固定组合技能运行时<TContext>,
    原因: 技能阶段链结束原因,
    阶段上下文?: 技能阶段链上下文,
  ): void {
    if (运行时.已结束) return;
    运行时.已结束 = true;
    if (this.当前 === 运行时) this.当前 = undefined;
    this.互斥锁.释放(运行时.互斥组, 运行时.互斥占用者);
    if (运行时.独占Token !== 0) {
      this.参数.独占状态管理器?.结束(
        运行时.独占Token,
        原因 === "完成" ? "完成" : "取消",
        运行时.key,
      );
    }
    if (运行时.结束回调 != null) {
      运行时.结束回调({
        执行ID: 运行时.执行ID,
        key: 运行时.key,
        单位: 运行时.单位,
        上下文: 运行时.上下文,
        阶段链ID: 运行时.阶段链ID,
        互斥组: 运行时.互斥组,
        开始毫秒: 运行时.开始毫秒,
        最大持续毫秒: 运行时.最大持续毫秒,
        数据: 运行时.数据,
        原因,
        阶段上下文,
      });
    }
  }
}

export function 创建固定组合技能执行器<TContext>(
  this: void,
  参数: 固定组合技能执行器参数<TContext>,
): 固定组合技能执行器<TContext> {
  return new 固定组合技能执行器实现(参数);
}
